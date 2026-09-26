import 'dart:io';

import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

import 'package:retail_erp/core/database/app_database.dart' as db;
import 'package:retail_erp/features/master_entry/unit/data/repositories/unit_repository.dart';
import 'package:retail_erp/features/master_entry/unit/domain/entities/unit.dart';
import 'package:retail_erp/features/master_entry/unit/domain/exceptions/unit_exceptions.dart';

/// The unit table ships seeded with the reference units of the approved
/// blueprint (§3.5), including the Area/Time measures added in the redesign.
const int seededUnitCount = 19;

void main() {
  group('UnitRepository', () {
    late db.AppDatabase database;
    late UnitRepository repository;

    setUp(() async {
      database = db.AppDatabase(NativeDatabase.memory());
      await database.customSelect('SELECT 1').get();
      repository = UnitRepository(database: database);
    });

    tearDown(() => database.close());

    test('creates a unit', () async {
      final created = await repository.createUnit(
        name: 'Crate',
        symbol: 'crt',
        family: UnitType.packaging.dbValue,
      );

      expect(created.id, greaterThan(0));
      expect(created.unitName, 'Crate');
      expect(created.unitSymbol, 'crt');
      expect(created.unitFamily, UnitType.packaging.dbValue);
      expect(created.isActive, isTrue);
    });

    test('trims whitespace from name and symbol', () async {
      final created = await repository.createUnit(
        name: '  Crate  ',
        symbol: ' crt ',
        family: UnitType.packaging.dbValue,
      );

      expect(created.unitName, 'Crate');
      expect(created.unitSymbol, 'crt');
    });

    test('stores a trimmed description or null', () async {
      final withDescription = await repository.createUnit(
        name: 'Crate',
        symbol: 'crt',
        family: UnitType.packaging.dbValue,
        description: '  A wooden crate  ',
      );
      expect(withDescription.description, 'A wooden crate');

      final blankDescription = await repository.createUnit(
        name: 'Pallet',
        symbol: 'plt',
        family: UnitType.packaging.dbValue,
        description: '   ',
      );
      expect(blankDescription.description, isNull);
    });

    test('getAllUnits returns all units ordered by name', () async {
      await repository.createUnit(
        name: 'Aardvark',
        symbol: 'aa',
        family: UnitType.count.dbValue,
      );
      await repository.createUnit(
        name: 'Zzz',
        symbol: 'zz',
        family: UnitType.count.dbValue,
      );

      final rows = await repository.getAllUnits();
      expect(rows, hasLength(seededUnitCount + 2));
      expect(rows.first.unitName, 'Aardvark');
      expect(rows.last.unitName, 'Zzz');
    });

    test('searchUnits filters case-insensitively by name and symbol', () async {
      await repository.createUnit(
        name: 'TestWidget',
        symbol: 'tw',
        family: UnitType.other.dbValue,
      );

      // By name (case-insensitive).
      expect(
        (await repository.searchUnits('testwidget')).map((u) => u.unitName),
        ['TestWidget'],
      );
      // By symbol.
      expect((await repository.searchUnits('TW')).map((u) => u.unitName), [
        'TestWidget',
      ]);
      expect(await repository.searchUnits('zzz'), isEmpty);
      expect(await repository.searchUnits(''), hasLength(seededUnitCount + 1));
    });

    test('existsByName is case-insensitive and honours excludeId', () async {
      await repository.createUnit(
        name: 'Crate',
        symbol: 'crt',
        family: UnitType.packaging.dbValue,
      );

      expect(await repository.existsByName('CRATE'), isTrue);
      expect(await repository.existsByName('crate'), isTrue);
      expect(await repository.existsByName('Pallet'), isFalse);

      final row = (await repository.getAllUnits()).firstWhere(
        (u) => u.unitName == 'Crate',
      );
      expect(
        await repository.existsByName('Crate', excludeId: row.id),
        isFalse,
      );
    });

    test('createUnit rejects duplicate names', () async {
      await repository.createUnit(
        name: 'Crate',
        symbol: 'crt',
        family: UnitType.packaging.dbValue,
      );

      await expectLater(
        repository.createUnit(
          name: 'crate',
          symbol: 'ct',
          family: UnitType.packaging.dbValue,
        ),
        throwsA(
          isA<UnitAlreadyExistsException>().having(
            (e) => e.message,
            'message',
            contains('crate'),
          ),
        ),
      );
    });

    test('updateUnit updates fields and persists the new values', () async {
      final created = await repository.createUnit(
        name: 'Crate',
        symbol: 'crt',
        family: UnitType.packaging.dbValue,
      );

      final updated = await repository.updateUnit(
        created.id,
        name: 'Wooden Crate',
        symbol: 'wcr',
        family: UnitType.area.dbValue,
        description: 'Flat-packed',
      );

      expect(updated.unitName, 'Wooden Crate');
      expect(updated.unitSymbol, 'wcr');
      expect(updated.unitFamily, UnitType.area.dbValue);
      expect(updated.description, 'Flat-packed');

      final reloaded = await repository.getAllUnits();
      expect(reloaded.any((u) => u.unitName == 'Wooden Crate'), isTrue);
    });

    test('updateUnit can clear the description', () async {
      final created = await repository.createUnit(
        name: 'Crate',
        symbol: 'crt',
        family: UnitType.packaging.dbValue,
        description: 'A crate',
      );

      final updated = await repository.updateUnit(
        created.id,
        name: 'Crate',
        symbol: 'crt',
        family: UnitType.packaging.dbValue,
        description: '',
      );

      expect(updated.description, isNull);
    });

    test('updateUnit rejects a name that collides with another unit', () async {
      final first = await repository.createUnit(
        name: 'Crate',
        symbol: 'crt',
        family: UnitType.packaging.dbValue,
      );
      await repository.createUnit(
        name: 'Pallet',
        symbol: 'plt',
        family: UnitType.packaging.dbValue,
      );

      await expectLater(
        repository.updateUnit(
          first.id,
          name: 'PALLET',
          symbol: 'crt',
          family: UnitType.packaging.dbValue,
        ),
        throwsA(isA<UnitAlreadyExistsException>()),
      );
    });

    test('updateUnit throws UnitNotFoundException for unknown ids', () async {
      await expectLater(
        repository.updateUnit(
          9999,
          name: 'Missing',
          symbol: 'ms',
          family: UnitType.other.dbValue,
        ),
        throwsA(isA<UnitNotFoundException>()),
      );
    });

    test('deleteUnit removes the unit', () async {
      final created = await repository.createUnit(
        name: 'Crate',
        symbol: 'crt',
        family: UnitType.packaging.dbValue,
      );
      expect(await repository.getAllUnits(), hasLength(seededUnitCount + 1));

      await repository.deleteUnit(created.id);

      expect(await repository.getAllUnits(), hasLength(seededUnitCount));
    });

    test('deleteUnit rejects units referenced by global conversions', () async {
      // Piece (seeded id 1) is referenced by the seeded Dozen/Pair/Bundle
      // conversions, so it must not be deletable.
      final piece = (await repository.getAllUnits()).firstWhere(
        (u) => u.unitName == 'Piece',
      );

      await expectLater(
        repository.deleteUnit(piece.id),
        throwsA(isA<UnitInUseException>()),
      );
      // The unit is still present.
      expect(
        (await repository.getAllUnits()).any((u) => u.id == piece.id),
        isTrue,
      );
    });

    test('persists data across restart (file database)', () async {
      // Two sequential AppDatabase sessions on the same file are intentional
      // here; the warning below is only relevant for overlapping databases.
      driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
      final tempDir = await Directory.systemTemp.createTemp(
        'retail_erp_unit_test',
      );
      addTearDown(() => tempDir.delete(recursive: true));
      final file = File(p.join(tempDir.path, 'RetailERP.db'));

      // First session: create a unit, then close the database.
      final firstSession = db.AppDatabase(NativeDatabase(file));
      await firstSession.customSelect('SELECT 1').get();
      await UnitRepository(database: firstSession).createUnit(
        name: 'Persisted',
        symbol: 'ps',
        family: UnitType.other.dbValue,
      );
      await firstSession.close();

      // Second session: the same file reopens and still contains the data.
      final secondSession = db.AppDatabase(NativeDatabase(file));
      await secondSession.customSelect('SELECT 1').get();
      final rows = await UnitRepository(database: secondSession).getAllUnits();
      expect(rows.any((u) => u.unitName == 'Persisted'), isTrue);
      await secondSession.close();
    });
  });
}
