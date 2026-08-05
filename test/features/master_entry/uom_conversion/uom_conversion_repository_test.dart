import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:retail_erp/core/database/app_database.dart' as db;
import 'package:retail_erp/features/master_entry/uom_conversion/data/repositories/uom_conversion_repository.dart';
import 'package:retail_erp/features/master_entry/uom_conversion/domain/exceptions/uom_conversion_exceptions.dart';

/// The uom_conversion table ships seeded with the 7 universal conversions
/// of the approved blueprint (§3.6).
const int seededConversionCount = 7;

void main() {
  group('UomConversionRepository', () {
    late db.AppDatabase database;
    late UomConversionRepository repository;

    setUp(() async {
      database = db.AppDatabase(NativeDatabase.memory());
      await database.customSelect('SELECT 1').get();
      repository = UomConversionRepository(database: database);
    });

    tearDown(() => database.close());

    Future<db.Unit> unitByName(String name) async {
      final query = database.select(database.units)
        ..where((t) => t.unitName.equals(name));
      return query.getSingle();
    }

    test('getAllConversions returns seeded conversions sorted by from unit',
        () async {
      final rows = await repository.getAllConversions();
      expect(rows, hasLength(seededConversionCount));

      // Sorted by from-unit name: Bundle, Dozen, Foot, Kilogram, ...
      expect(rows.first.fromUnitName, 'Bundle');
      expect(rows.first.toUnitName, 'Piece');
      expect(rows.first.conversionFactor, 12.0);
      expect(rows.last.fromUnitName, 'Pair');
      // Denormalised symbols are resolved.
      expect(rows.first.fromUnitSymbol, 'bdl');
    });

    test('creates a conversion with a trimmed description', () async {
      final box = await unitByName('Box');
      final packet = await unitByName('Packet');

      final created = await repository.createConversion(
        fromUnitId: box.id,
        toUnitId: packet.id,
        conversionFactor: 10,
        description: '  1 Box = 10 Packets  ',
      );

      expect(created.id, greaterThan(0));
      expect(created.fromUnitName, 'Box');
      expect(created.toUnitName, 'Packet');
      expect(created.conversionFactor, 10.0);
      expect(created.description, '1 Box = 10 Packets');
    });

    test('rejects identical from/to units and non-positive factors',
        () async {
      final box = await unitByName('Box');
      final packet = await unitByName('Packet');

      await expectLater(
        repository.createConversion(
          fromUnitId: box.id,
          toUnitId: box.id,
          conversionFactor: 1,
        ),
        throwsArgumentError,
      );
      await expectLater(
        repository.createConversion(
          fromUnitId: box.id,
          toUnitId: packet.id,
          conversionFactor: 0,
        ),
        throwsArgumentError,
      );
    });

    test('rejects a duplicate in the same direction', () async {
      final kilogram = await unitByName('Kilogram');
      final gram = await unitByName('Gram');

      // Seeded: Kilogram -> Gram, factor 1000.
      await expectLater(
        repository.createConversion(
          fromUnitId: kilogram.id,
          toUnitId: gram.id,
          conversionFactor: 1000,
        ),
        throwsA(isA<UomConversionAlreadyExistsException>()),
      );
    });

    test('rejects the reverse of an existing conversion', () async {
      final kilogram = await unitByName('Kilogram');
      final gram = await unitByName('Gram');

      // Gram -> Kilogram is derived automatically from Kilogram -> Gram.
      await expectLater(
        repository.createConversion(
          fromUnitId: gram.id,
          toUnitId: kilogram.id,
          conversionFactor: 0.001,
        ),
        throwsA(isA<UomConversionAlreadyExistsException>()),
      );
    });

    test('searchConversions filters by unit name and symbol', () async {
      // By from-unit name.
      final byName = await repository.searchConversions('dozen');
      expect(byName.map((c) => c.fromUnitName), ['Dozen']);

      // By to-unit symbol ("g" matches Gram).
      final bySymbol = await repository.searchConversions('g');
      expect(bySymbol.map((c) => c.toUnitName), contains('Gram'));

      expect(await repository.searchConversions('zzz'), isEmpty);
      expect(
        await repository.searchConversions(''),
        hasLength(seededConversionCount),
      );
    });

    test('updateConversion changes the factor and description', () async {
      final rows = await repository.getAllConversions();
      final target = rows.firstWhere((c) => c.fromUnitName == 'Dozen');

      final updated = await repository.updateConversion(
        target.id,
        fromUnitId: target.fromUnitId,
        toUnitId: target.toUnitId,
        conversionFactor: 6,
        description: 'Half-gross',
      );

      expect(updated.conversionFactor, 6.0);
      expect(updated.description, 'Half-gross');

      final reloaded = await repository.getAllConversions();
      expect(
        reloaded.firstWhere((c) => c.id == target.id).conversionFactor,
        6.0,
      );
    });

    test('updateConversion rejects a pair already used by another row',
        () async {
      final rows = await repository.getAllConversions();
      final dozen = rows.firstWhere((c) => c.fromUnitName == 'Dozen');
      final bundle = rows.firstWhere((c) => c.fromUnitName == 'Bundle');

      await expectLater(
        repository.updateConversion(
          dozen.id,
          fromUnitId: bundle.fromUnitId,
          toUnitId: bundle.toUnitId,
          conversionFactor: 12,
        ),
        throwsA(isA<UomConversionAlreadyExistsException>()),
      );
    });

    test('update throws for unknown ids', () async {
      final box = await unitByName('Box');
      final packet = await unitByName('Packet');

      await expectLater(
        repository.updateConversion(
          9999,
          fromUnitId: box.id,
          toUnitId: packet.id,
          conversionFactor: 10,
        ),
        throwsA(isA<UomConversionNotFoundException>()),
      );
    });

    test('deleting a missing conversion is a silent no-op', () async {
      await repository.deleteConversion(9999);
      expect(
        await repository.getAllConversions(),
        hasLength(seededConversionCount),
      );
    });

    test('deleteConversion removes the row', () async {
      final box = await unitByName('Box');
      final packet = await unitByName('Packet');
      final created = await repository.createConversion(
        fromUnitId: box.id,
        toUnitId: packet.id,
        conversionFactor: 10,
      );

      await repository.deleteConversion(created.id);

      expect(
        await repository.getAllConversions(),
        hasLength(seededConversionCount),
      );
    });

    test('resolveFactor uses the stored row and derives the reverse',
        () async {
      final kilogram = await unitByName('Kilogram');
      final gram = await unitByName('Gram');

      expect(await repository.resolveFactor(kilogram.id, gram.id), 1000.0);
      expect(
        await repository.resolveFactor(gram.id, kilogram.id),
        closeTo(0.001, 1e-9),
      );
      // Identical units always resolve.
      expect(await repository.resolveFactor(gram.id, gram.id), 1.0);

      // No global conversion between Box and Packet.
      final box = await unitByName('Box');
      final packet = await unitByName('Packet');
      expect(await repository.resolveFactor(box.id, packet.id), isNull);
    });
  });
}
