import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:retail_erp/core/database/app_database.dart' hide CompanySettings;
import 'package:retail_erp/core/database/app_database.dart' as db;
import 'package:retail_erp/features/company_settings/data/repositories/company_settings_repository.dart';
import 'package:retail_erp/features/company_settings/domain/company_settings_enums.dart';
import 'package:retail_erp/features/company_settings/domain/entities/company_settings.dart';
import 'package:retail_erp/features/company_settings/domain/entities/company_settings_draft.dart';

CompanySettingsDraft _validDraft() {
  return CompanySettingsDraft(
    businessName: '  Acme Retailers  ',
    legalName: 'Acme Retailers Pvt Ltd',
    businessType: BusinessType.privateLimited,
    gstRegistered: true,
    gstin: '27aabcd1234f1z5',
    pan: 'abcde1234f',
    cin: 'U12345MH2024PTC123456',
    phone: '9876543210',
    email: '  CONTACT@acme.com ',
    website: 'www.acme.com',
    addressLine1: 'MG Road',
    addressLine2: 'Near Metro',
    city: 'Mumbai',
    state: 'Maharashtra',
    pincode: '400001',
    country: 'India',
    defaultTaxType: TaxTreatment.inclusive,
    invoicePrefix: ' INV ',
    invoiceStartNumber: '25',
    financialYearStartMonth: 4,
    currencyCode: 'inr',
    currencySymbol: '₹',
    decimalPlaces: 2,
    bankName: 'SBI',
    bankAccountName: 'Acme Retailers',
    bankAccountNumber: '123456789012',
    bankIfsc: 'sbin0001234',
    bankBranch: 'Fort',
    upiId: 'acme@upi',
    invoiceFooter: 'Thanks!',
    invoiceTerms: 'Net 30',
    invoiceThankYouMessage: 'Thank you for your business!',
    showLogoOnInvoice: true,
    showBankDetailsOnInvoice: false,
    showGstDetailsOnInvoice: true,
  );
}

void main() {
  group('CompanySettingsRepository', () {
    late AppDatabase database;
    late CompanySettingsRepository repository;

    setUp(() async {
      database = AppDatabase(NativeDatabase.memory());
      await database.customSelect('SELECT 1').get();
      repository = CompanySettingsRepository(database: database);
    });

    tearDown(() => database.close());

    Future<int> rowCount() async {
      return (await database.select(database.companySettingsTable).get()).length;
    }

    test('getOrCreate creates the default singleton row on first access', () async {
      final settings = await repository.getOrCreate();

      expect(settings.id, CompanySettings.singletonId);
      expect(await rowCount(), 1);
      // Defaults from the schema.
      expect(settings.companyName, '');
      expect(settings.currencyCode, 'INR');
      expect(settings.currencySymbol, '₹');
      expect(settings.decimalPlaces, 2);
      expect(settings.financialYearStartMonth, 4);
      expect(settings.invoicePrefix, 'INV-');
      expect(settings.invoiceStartNumber, 1);
      expect(settings.businessType, BusinessType.proprietorship);
      expect(settings.gstRegistered, isFalse);
      expect(settings.defaultTaxType, TaxTreatment.exclusive);
      expect(settings.showLogoOnInvoice, isTrue);
      expect(settings.country, isNull);
    });

    test('getOrCreate never duplicates the row', () async {
      await repository.getOrCreate();
      await repository.getOrCreate();
      await repository.getOrCreate();

      expect(await rowCount(), 1);
    });

    test('save inserts the row when it does not exist yet', () async {
      final saved = await repository.save(_validDraft());

      expect(saved.id, CompanySettings.singletonId);
      expect(await rowCount(), 1);
    });

    test('save updates the existing row instead of creating a second one', () async {
      await repository.getOrCreate();
      final saved = await repository.save(_validDraft());
      final again = await repository.save(_validDraft());

      expect(await rowCount(), 1);
      expect(saved.id, CompanySettings.singletonId);
      expect(again.companyName, 'Acme Retailers');
    });

    test('save trims and normalizes values', () async {
      final saved = await repository.save(_validDraft());

      expect(saved.companyName, 'Acme Retailers');
      expect(saved.legalName, 'Acme Retailers Pvt Ltd');
      expect(saved.gstNumber, '27AABCD1234F1Z5');
      expect(saved.panNumber, 'ABCDE1234F');
      expect(saved.cin, 'U12345MH2024PTC123456');
      expect(saved.email, 'contact@acme.com');
      expect(saved.mobile, '9876543210');
      expect(saved.invoicePrefix, 'INV');
      expect(saved.invoiceStartNumber, 25);
      expect(saved.currencyCode, 'INR');
      expect(saved.bankIfsc, 'SBIN0001234');
      // State code derived from the GSTIN for future GST reports.
      expect(saved.stateCode, '27');
      expect(saved.businessType, BusinessType.privateLimited);
      expect(saved.defaultTaxType, TaxTreatment.inclusive);
      expect(saved.showBankDetailsOnInvoice, isFalse);
    });

    test('save preserves fields not surfaced in the UI', () async {
      // Pre-seed the row with a purchase prefix, timezone and active flag.
      await database.into(database.companySettingsTable).insert(
        db.CompanySettingsTableCompanion.insert(
          id: const Value(1),
          companyName: 'Old',
          purchasePrefix: const Value('PO-'),
          timezone: const Value('Asia/Calcutta'),
          isActive: const Value(false),
        ),
      );

      await repository.save(_validDraft());

      final row = (await database
              .select(database.companySettingsTable)
              .get())
          .single;
      expect(row.purchasePrefix, 'PO-');
      expect(row.timezone, 'Asia/Calcutta');
      expect(row.isActive, isFalse);
    });

    test('keeps createdAt and refreshes updatedAt', () async {
      // Seed a row created long ago; the save must keep createdAt and bump
      // updatedAt to now.
      await database.into(database.companySettingsTable).insert(
        db.CompanySettingsTableCompanion.insert(
          id: const Value(1),
          companyName: 'Old',
          createdAt: Value(DateTime(2025, 1, 1)),
          updatedAt: Value(DateTime(2025, 1, 1)),
        ),
      );

      final saved = await repository.save(_validDraft());

      expect(saved.createdAt, DateTime(2025, 1, 1));
      expect(saved.updatedAt.isAfter(DateTime(2025, 1, 1)), isTrue);
    });

    test('database rejects a second company_settings row', () async {
      await repository.getOrCreate();

      await expectLater(
        database.into(database.companySettingsTable).insert(
          db.CompanySettingsTableCompanion.insert(
            id: const Value(2),
            companyName: 'Second company',
          ),
        ),
        throwsA(anyOf(isA<SqliteException>(), isA<DriftWrappedException>())),
      );
      expect(await rowCount(), 1);
    });

    test('logoPath round-trips through save', () async {
      final saved = await repository.save(
        _validDraft().withLogoPath('/tmp/company_logo.png'),
      );
      expect(saved.logoPath, '/tmp/company_logo.png');

      final cleared = await repository.save(_validDraft().withLogoPath(null));
      expect(cleared.logoPath, isNull);
    });

    test('blank optional fields are stored as null', () async {
      final draft = _validDraft().withLogoPath(null);
      final saved = await repository.save(
        CompanySettingsDraft(
          businessName: draft.businessName,
          businessType: draft.businessType,
          gstRegistered: false,
          phone: draft.phone,
          addressLine1: draft.addressLine1,
          city: draft.city,
          state: draft.state,
          pincode: draft.pincode,
          defaultTaxType: draft.defaultTaxType,
          invoicePrefix: draft.invoicePrefix,
          invoiceStartNumber: draft.invoiceStartNumber,
          financialYearStartMonth: 4,
          decimalPlaces: 2,
          showLogoOnInvoice: true,
          showBankDetailsOnInvoice: true,
          showGstDetailsOnInvoice: true,
        ),
      );

      expect(saved.gstNumber, isNull);
      expect(saved.legalName, isNull);
      expect(saved.stateCode, isNull);
    });
  });
}
