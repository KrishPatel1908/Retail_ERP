import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:retail_erp/core/database/app_database.dart' hide CompanySettings;
import 'package:retail_erp/features/company_settings/data/repositories/company_settings_repository.dart';
import 'package:retail_erp/features/company_settings/domain/company_settings_enums.dart';
import 'package:retail_erp/features/company_settings/domain/company_settings_exceptions.dart';
import 'package:retail_erp/features/company_settings/domain/entities/company_settings.dart';
import 'package:retail_erp/features/company_settings/domain/entities/company_settings_draft.dart';
import 'package:retail_erp/features/company_settings/services/company_settings_service.dart';

/// Repository that counts its reads so tests can assert caching.
class _CountingRepository extends CompanySettingsRepository {
  _CountingRepository(AppDatabase database) : super(database: database);

  int getOrCreateCalls = 0;

  @override
  Future<CompanySettings> getOrCreate() {
    getOrCreateCalls++;
    return super.getOrCreate();
  }
}

CompanySettingsDraft _validDraft() {
  return CompanySettingsDraft(
    businessName: 'Acme Retailers',
    businessType: BusinessType.proprietorship,
    gstRegistered: false,
    phone: '9876543210',
    addressLine1: 'MG Road',
    city: 'Mumbai',
    state: 'Maharashtra',
    pincode: '400001',
    defaultTaxType: TaxTreatment.exclusive,
    invoicePrefix: 'INV',
    invoiceStartNumber: '1',
    financialYearStartMonth: 4,
    currencyCode: 'INR',
    currencySymbol: '₹',
    decimalPlaces: 2,
    showLogoOnInvoice: true,
    showBankDetailsOnInvoice: true,
    showGstDetailsOnInvoice: true,
  );
}

void main() {
  late AppDatabase database;

  setUp(() async {
    CompanySettingsService.invalidateCache();
    database = AppDatabase(NativeDatabase.memory());
    await database.customSelect('SELECT 1').get();
  });

  tearDown(() {
    CompanySettingsService.invalidateCache();
    database.close();
  });

  test('getSettings loads once and serves the cache afterwards', () async {
    final repository = _CountingRepository(database);
    final service = CompanySettingsService(repository: repository);

    final first = await service.getSettings();
    final second = await service.getSettings();

    expect(repository.getOrCreateCalls, 1);
    expect(identical(first, second), isTrue);
    expect(CompanySettingsService.cached, isNotNull);
  });

  test('save persists, refreshes the cache and rejects invalid drafts', () async {
    final repository = _CountingRepository(database);
    final service = CompanySettingsService(repository: repository);

    final saved = await service.save(_validDraft());
    expect(saved.companyName, 'Acme Retailers');

    // The cache now holds the saved configuration — no reload required.
    final cached = await service.getSettings();
    expect(cached.companyName, 'Acme Retailers');
    expect(repository.getOrCreateCalls, 0);

    // Invalid drafts are rejected at the application layer.
    final invalid = _validDraft().withLogoPath(null);
    final badDraft = CompanySettingsDraft(
      businessName: '',
      businessType: invalid.businessType,
      gstRegistered: false,
      phone: invalid.phone,
      addressLine1: invalid.addressLine1,
      city: invalid.city,
      state: invalid.state,
      pincode: invalid.pincode,
      defaultTaxType: invalid.defaultTaxType,
      invoicePrefix: invalid.invoicePrefix,
      invoiceStartNumber: invalid.invoiceStartNumber,
      financialYearStartMonth: 4,
      decimalPlaces: 2,
      showLogoOnInvoice: true,
      showBankDetailsOnInvoice: true,
      showGstDetailsOnInvoice: true,
    );
    await expectLater(
      service.save(badDraft),
      throwsA(isA<CompanySettingsValidationException>()),
    );
  });

  test('invalidateCache forces a fresh load', () async {
    final repository = _CountingRepository(database);
    final service = CompanySettingsService(repository: repository);

    await service.getSettings();
    CompanySettingsService.invalidateCache();

    await service.getSettings();
    expect(repository.getOrCreateCalls, 2);
  });
}
