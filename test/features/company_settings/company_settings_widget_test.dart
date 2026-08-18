import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:retail_erp/app/retail_erp_app.dart';
import 'package:retail_erp/core/database/app_database.dart' hide CompanySettings;
import 'package:retail_erp/features/company_settings/data/repositories/company_settings_repository.dart';
import 'package:retail_erp/features/company_settings/domain/company_settings_enums.dart';
import 'package:retail_erp/features/company_settings/domain/entities/company_settings.dart';
import 'package:retail_erp/features/company_settings/domain/entities/company_settings_draft.dart';
import 'package:retail_erp/features/company_settings/presentation/pages/company_settings_page.dart';
import 'package:retail_erp/features/company_settings/presentation/widgets/settings_skeleton.dart';
import 'package:retail_erp/features/company_settings/services/company_banner_storage.dart';
import 'package:retail_erp/features/company_settings/services/company_logo_picker.dart';
import 'package:retail_erp/features/company_settings/services/company_logo_storage.dart';
import 'package:retail_erp/features/company_settings/services/company_settings_service.dart';

import '../../helpers/test_database.dart';
import '../../helpers/test_viewport.dart';

/// Repository whose first read is delayed, so the loading skeleton is
/// observable in tests.
class _SlowRepository extends CompanySettingsRepository {
  _SlowRepository(AppDatabase database) : super(database: database);

  @override
  Future<CompanySettings> getOrCreate() async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    return super.getOrCreate();
  }
}

/// Repository that always fails to load, for the error state.
class _FailingRepository extends CompanySettingsRepository {
  _FailingRepository(AppDatabase database) : super(database: database);

  @override
  Future<CompanySettings> getOrCreate() async {
    throw StateError('database unavailable');
  }
}

class _FixedPicker extends CompanyLogoPicker {
  _FixedPicker(this.file);

  final File? file;

  @override
  Future<File?> pick() async => file;
}

class _FakeLogoStorage extends CompanyLogoStorage {
  int storeCalls = 0;
  final List<String> deleted = [];
  bool rejectValidate = false;

  @override
  Future<void> validate(File source) async {
    if (rejectValidate) {
      throw const CompanyLogoException(
        'Only png, jpg, jpeg, webp, bmp images are supported.',
      );
    }
  }

  @override
  Future<String> store(File source) async {
    storeCalls++;
    return '${source.path}.stored';
  }

  @override
  Future<void> delete(String path) async {
    deleted.add(path);
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
    country: 'India',
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

Widget _harness(CompanySettingsPage page) {
  return MaterialApp(
    home: Scaffold(body: page),
  );
}

void main() {
  group('Company Settings page', () {
    late AppDatabase database;
    late CompanySettingsService service;

    setUp(() async {
      CompanySettingsService.invalidateCache();
      database = AppDatabase(NativeDatabase.memory());
      await database.customSelect('SELECT 1').get();
      service = CompanySettingsService(
        repository: CompanySettingsRepository(database: database),
      );
    });

    tearDown(() {
      CompanySettingsService.invalidateCache();
      database.close();
    });

    Future<void> pumpPage(
      WidgetTester tester, {
      CompanyLogoPicker? picker,
      CompanyLogoStorage? storage,
      CompanyBannerStorage? bannerStorage,
    }) async {
      await tester.pumpWidget(
        _harness(
          CompanySettingsPage(
            service: service,
            logoPicker: picker,
            logoStorage: storage,
            bannerStorage: bannerStorage ??
                CompanyBannerStorage(directoryProvider: () async => Directory.systemTemp),
          ),
        ),
      );
      await tester.pumpAndSettle();
    }

    testWidgets('loads settings and pre-fills the form', (tester) async {
      useTallViewport(tester);
      await service.save(_validDraft());
      CompanySettingsService.invalidateCache();

      await pumpPage(tester);

      expect(find.text('Edit Profile'), findsOneWidget);
      expect(find.text('Acme Retailers'), findsWidgets);

      await tester.tap(find.text('Edit Profile'));
      await tester.pumpAndSettle();

      expect(find.text('Save Changes'), findsOneWidget);
      expect(find.text('Company Logo'), findsOneWidget);
      expect(find.text('Company Information'), findsOneWidget);
      expect(find.text('Business Address'), findsOneWidget);
      expect(find.text('Tax & Billing'), findsOneWidget);
      expect(find.text('Financial Settings'), findsOneWidget);
      expect(find.text('Bank Details'), findsOneWidget);

      final businessName = tester.widget<TextField>(
        find.byKey(const ValueKey('company-settings-business-name')),
      );
      expect(businessName.controller!.text, 'Acme Retailers');
      final country = tester.widget<TextField>(
        find.byKey(const ValueKey('company-settings-country')),
      );
      expect(country.controller!.text, 'India');
    });

    testWidgets('new database defaults to India and INR', (tester) async {
      useTallViewport(tester);
      await pumpPage(tester);

      final country = tester.widget<TextField>(
        find.byKey(const ValueKey('company-settings-country')),
      );
      expect(country.controller!.text, 'India');
      final currency = tester.widget<TextField>(
        find.byKey(const ValueKey('company-settings-currency-code')),
      );
      expect(currency.controller!.text, 'INR');
    });

    testWidgets('shows validation errors when saving an empty form', (
      tester,
    ) async {
      useTallViewport(tester);
      await pumpPage(tester);

      await tester.ensureVisible(find.byKey(const ValueKey('company-settings-save')));
      await tester.tap(find.byKey(const ValueKey('company-settings-save')));
      await tester.pumpAndSettle();

      expect(find.text('Business name is required.'), findsOneWidget);
      expect(find.text('Address 1 is required.'), findsOneWidget);
      expect(find.text('City is required.'), findsOneWidget);
      expect(find.text('State is required.'), findsOneWidget);
      expect(find.text('Pincode is required.'), findsOneWidget);
      expect(find.text('Phone number is required.'), findsOneWidget);
      // Note: the fresh row's database defaults pre-fill the invoice prefix
      // ('INV-') and starting number ('1'), so those are not flagged here.
    });

    testWidgets('save persists values and shows a success message', (
      tester,
    ) async {
      useTallViewport(tester);
      await pumpPage(tester);

      await tester.enterText(
        find.byKey(const ValueKey('company-settings-business-name')),
        'Acme Retailers',
      );
      await tester.enterText(
        find.byKey(const ValueKey('company-settings-phone')),
        '9876543210',
      );
      await tester.enterText(
        find.byKey(const ValueKey('company-settings-address-line-1')),
        'MG Road',
      );
      await tester.enterText(
        find.byKey(const ValueKey('company-settings-city')),
        'Mumbai',
      );
      await tester.enterText(
        find.byKey(const ValueKey('company-settings-state')),
        'Maharashtra',
      );
      await tester.enterText(
        find.byKey(const ValueKey('company-settings-pincode')),
        '400001',
      );
      await tester.enterText(
        find.byKey(const ValueKey('company-settings-invoice-prefix')),
        'INV',
      );
      await tester.enterText(
        find.byKey(const ValueKey('company-settings-invoice-start')),
        '25',
      );

      await tester.ensureVisible(find.byKey(const ValueKey('company-settings-save')));
      await tester.tap(find.byKey(const ValueKey('company-settings-save')));
      await tester.pumpAndSettle();

      expect(
        find.text('Company settings saved successfully.'),
        findsOneWidget,
      );

      // Persisted in the database — and no second row was created.
      final rows = await database.select(database.companySettingsTable).get();
      expect(rows, hasLength(1));
      expect(rows.single.companyName, 'Acme Retailers');
      expect(rows.single.invoiceStartNumber, 25);
      expect(rows.single.city, 'Mumbai');
    });

    testWidgets('shows the skeleton while loading', (tester) async {
      useTallViewport(tester);
      final slowService = CompanySettingsService(
        repository: _SlowRepository(database),
      );

      await tester.pumpWidget(
        _harness(CompanySettingsPage(service: slowService)),
      );
      await tester.pump();

      expect(find.byType(SettingsSkeleton), findsOneWidget);

      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();
      expect(find.byType(SettingsSkeleton), findsNothing);
      expect(find.text('Save Changes'), findsOneWidget);
    });

    testWidgets('shows an error state with retry when loading fails', (
      tester,
    ) async {
      useTallViewport(tester);
      final failingService = CompanySettingsService(
        repository: _FailingRepository(database),
      );

      await tester.pumpWidget(
        _harness(CompanySettingsPage(service: failingService)),
      );
      await tester.pumpAndSettle();

      expect(find.text('Could not load company settings'), findsOneWidget);
      expect(find.text('Try Again'), findsOneWidget);
    });

    testWidgets('uploads, saves and removes a logo', (tester) async {
      // Extra tall surface so the whole form, including the save button,
      // is on screen without scrolling.
      useTallViewport(tester, size: const Size(1400, 3600));
      final storage = _FakeLogoStorage();
      final tempFile = File(
        '${Directory.systemTemp.createTempSync('logo_pick').path}/logo.png',
      );
      tempFile.writeAsBytesSync(List.filled(10, 0));
      addTearDown(() => tempFile.parent.deleteSync(recursive: true));

      await pumpPage(
        tester,
        picker: _FixedPicker(tempFile),
        storage: storage,
      );

      // Upload: the picked file becomes the pending logo.
      await tester.ensureVisible(
        find.byKey(const ValueKey('company-settings-logo-upload')),
      );
      await tester.tap(find.byKey(const ValueKey('company-settings-logo-upload')));
      await tester.pumpAndSettle();
      expect(find.text('Replace Logo'), findsOneWidget);

      // Save with the pending logo.
      await tester.enterText(
        find.byKey(const ValueKey('company-settings-business-name')),
        'Acme Retailers',
      );
      await tester.enterText(
        find.byKey(const ValueKey('company-settings-phone')),
        '9876543210',
      );
      await tester.enterText(
        find.byKey(const ValueKey('company-settings-address-line-1')),
        'MG Road',
      );
      await tester.enterText(
        find.byKey(const ValueKey('company-settings-city')),
        'Mumbai',
      );
      await tester.enterText(
        find.byKey(const ValueKey('company-settings-state')),
        'Maharashtra',
      );
      await tester.enterText(
        find.byKey(const ValueKey('company-settings-pincode')),
        '400001',
      );
      await tester.enterText(
        find.byKey(const ValueKey('company-settings-invoice-prefix')),
        'INV',
      );
      await tester.enterText(
        find.byKey(const ValueKey('company-settings-invoice-start')),
        '1',
      );

      await tester.ensureVisible(find.byKey(const ValueKey('company-settings-save')));
      await tester.tap(find.byKey(const ValueKey('company-settings-save')));
      await tester.pumpAndSettle();

      expect(storage.storeCalls, 1);
      var rows = await database.select(database.companySettingsTable).get();
      expect(rows.single.logoPath, '${tempFile.path}.stored');

      // Remove the logo and save again — enters edit mode, removes file, saves.
      await tester.ensureVisible(
        find.byKey(const ValueKey('company-profile-edit-button')),
      );
      await tester.tap(find.byKey(const ValueKey('company-profile-edit-button')));
      await tester.pumpAndSettle();

      await tester.ensureVisible(
        find.byKey(const ValueKey('company-settings-logo-remove')),
      );
      await tester.tap(find.byKey(const ValueKey('company-settings-logo-remove')));
      await tester.pumpAndSettle();
      expect(find.text('Upload Logo'), findsOneWidget);

      // Let the success snackbar from the previous save expire so it does
      // not obscure the save button at the bottom of the form.
      await tester.pump(const Duration(seconds: 5));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.byKey(const ValueKey('company-settings-save')));
      await tester.tap(find.byKey(const ValueKey('company-settings-save')));
      await tester.pumpAndSettle();

      expect(storage.deleted, contains('${tempFile.path}.stored'));
      rows = await database.select(database.companySettingsTable).get();
      expect(rows.single.logoPath, isNull);
    });

    testWidgets('rejects an invalid logo at pick time with a message', (
      tester,
    ) async {
      useTallViewport(tester);
      final storage = _FakeLogoStorage()..rejectValidate = true;
      final tempFile = File(
        '${Directory.systemTemp.createTempSync('logo_pick').path}/logo.txt',
      );
      tempFile.writeAsBytesSync(List.filled(10, 0));
      addTearDown(() => tempFile.parent.deleteSync(recursive: true));

      await pumpPage(
        tester,
        picker: _FixedPicker(tempFile),
        storage: storage,
      );

      await tester.ensureVisible(
        find.byKey(const ValueKey('company-settings-logo-upload')),
      );
      await tester.tap(find.byKey(const ValueKey('company-settings-logo-upload')));
      await tester.pumpAndSettle();

      expect(
        find.text('Only png, jpg, jpeg, webp, bmp images are supported.'),
        findsOneWidget,
      );
      expect(storage.storeCalls, 0);
    });
  });

  group('Shell integration', () {
    setUp(resetTestDatabase);

    testWidgets('Company Settings opens from the sidebar', (tester) async {
      useTallViewport(tester);
      await tester.pumpWidget(const RetailErpApp());

      await tester.tap(find.text('Master Entry'));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Company Settings'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Company Settings'));
      await tester.pumpAndSettle();

      // The settings form renders inside the shell.
      expect(find.text('Company Settings'), findsWidgets);
      expect(find.text('Company Information'), findsOneWidget);
    });
  });
}
