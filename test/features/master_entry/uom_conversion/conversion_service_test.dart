import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:retail_erp/core/database/app_database.dart' as db;
import 'package:retail_erp/features/master_entry/uom_conversion/data/repositories/uom_conversion_repository.dart';
import 'package:retail_erp/features/master_entry/uom_conversion/services/conversion_service.dart';

void main() {
  group('ConversionService (priority: product UOM → global UOM → error)', () {
    late db.AppDatabase database;
    late UomConversionRepository uomRepository;

    setUp(() async {
      database = db.AppDatabase(NativeDatabase.memory());
      await database.customSelect('SELECT 1').get();
      uomRepository = UomConversionRepository(database: database);
    });

    tearDown(() => database.close());

    Future<db.Unit> unitByName(String name) async {
      final query = database.select(database.units)
        ..where((t) => t.unitName.equals(name));
      return query.getSingle();
    }

    test('uses the product-specific conversion first', () async {
      final kilogram = await unitByName('Kilogram');
      final gram = await unitByName('Gram');

      final service = ConversionService(
        uomRepository: uomRepository,
        productLookup: (productId, from, to) async => 500, // product rule
      );

      final result = await service.convert(
        productId: 1,
        fromUnitId: kilogram.id,
        toUnitId: gram.id,
        quantity: 2,
      );
      expect(result, 1000.0);
    });

    test(
      'falls back to the global conversion when the product has none',
      () async {
        final kilogram = await unitByName('Kilogram');
        final gram = await unitByName('Gram');

        final service = ConversionService(
          uomRepository: uomRepository,
          productLookup: (productId, from, to) async => null,
        );

        final result = await service.convert(
          productId: 1,
          fromUnitId: kilogram.id,
          toUnitId: gram.id,
          quantity: 2,
        );
        expect(result, 2000.0);
      },
    );

    test('uses the global reverse conversion automatically', () async {
      final kilogram = await unitByName('Kilogram');
      final gram = await unitByName('Gram');

      final service = ConversionService(uomRepository: uomRepository);

      final result = await service.convert(
        fromUnitId: gram.id,
        toUnitId: kilogram.id,
        quantity: 1000,
      );
      expect(result, closeTo(1.0, 1e-9));
    });

    test(
      'without a product id the global conversion is used directly',
      () async {
        final kilogram = await unitByName('Kilogram');
        final gram = await unitByName('Gram');

        final service = ConversionService(
          uomRepository: uomRepository,
          productLookup: (productId, from, to) async => 500,
        );

        final result = await service.convert(
          fromUnitId: kilogram.id,
          toUnitId: gram.id,
          quantity: 1,
        );
        expect(result, 1000.0);
      },
    );

    test('throws a friendly error when no conversion exists', () async {
      final box = await unitByName('Box');
      final packet = await unitByName('Packet');

      final service = ConversionService(
        uomRepository: uomRepository,
        productLookup: (productId, from, to) async => null,
      );

      await expectLater(
        service.convert(
          productId: 1,
          fromUnitId: box.id,
          toUnitId: packet.id,
          quantity: 1,
        ),
        throwsA(
          isA<ConversionNotFoundException>().having(
            (e) => e.message,
            'message',
            'No conversion found between selected units.',
          ),
        ),
      );
    });
  });
}
