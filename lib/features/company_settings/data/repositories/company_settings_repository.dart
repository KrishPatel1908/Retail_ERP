import 'package:drift/drift.dart';

import 'package:retail_erp/core/database/app_database.dart' as db;
import 'package:retail_erp/core/database/database_provider.dart';
import 'package:retail_erp/core/database/exceptions/database_exceptions.dart';

import '../../domain/company_settings_enums.dart';
import '../../domain/entities/company_settings.dart';
import '../../domain/entities/company_settings_draft.dart';

/// Data access for the single company configuration row (`id = 1`).
///
/// The only entry point the application layer uses to read and write company
/// settings. Drift types never leak past this class: callers receive and
/// return [CompanySettings] domain entities only.
///
/// The singleton rule is enforced at the database level by
/// `CHECK (id = 1)`; this repository never reads or writes any other id, so
/// callers cannot accidentally create a second company.
class CompanySettingsRepository {
  CompanySettingsRepository({db.AppDatabase? database})
    : database = database ?? DatabaseProvider.instance.database;

  /// The Drift database. Subclasses (tests) access tables through this
  /// handle; the handle itself never leaks past a repository.
  final db.AppDatabase database;

  /// Returns the current company configuration, creating the default row
  /// (`id = 1`) on first access.
  ///
  /// This is a single indexed-by-primary-key lookup; the application layer
  /// caches the result so unrelated pages never repeat the query.
  Future<CompanySettings> getOrCreate() async {
    final existing = await _getById();
    if (existing != null) return _toEntity(existing);

    try {
      final now = DateTime.now();
      await database
          .into(database.companySettingsTable)
          .insert(
            db.CompanySettingsTableCompanion.insert(
              id: const Value(CompanySettings.singletonId),
              companyName: '',
              createdAt: Value(now),
              updatedAt: Value(now),
            ),
          );
      final created = await _getById();
      if (created == null) {
        throw const DatabaseOperationException(
          'Company settings row could not be created.',
        );
      }
      return _toEntity(created);
    } on AppDatabaseException {
      rethrow;
    } on Exception catch (error, stackTrace) {
      throw DatabaseOperationException(
        'Failed to load company settings.',
        cause: error,
        stackTrace: stackTrace,
      );
    }
  }

  /// Persists the company configuration atomically.
  ///
  /// Runs inside one transaction: the row is updated when it exists and
  /// inserted otherwise, so a save can never create a second company.
  /// Fields not surfaced in the settings UI (document-numbering prefixes,
  /// timezone, activity flag, timestamps) are preserved on update.
  Future<CompanySettings> save(CompanySettingsDraft draft) async {
    try {
      await database.transaction(() async {
        final existing = await _getById();
        if (existing == null) {
          final now = DateTime.now();
          await database
              .into(database.companySettingsTable)
              .insert(_toInsertCompanion(draft, now: now));
          return;
        }
        await (database.update(database.companySettingsTable)
              ..where((t) => t.id.equals(CompanySettings.singletonId)))
            .write(_toUpdateCompanion(draft, existing: existing));
      });
      final saved = await _getById();
      if (saved == null) {
        throw const DatabaseOperationException(
          'Company settings row could not be saved.',
        );
      }
      return _toEntity(saved);
    } on AppDatabaseException {
      rethrow;
    } on Exception catch (error, stackTrace) {
      throw DatabaseOperationException(
        'Failed to save company settings.',
        cause: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<db.CompanySettings?> _getById() async {
    return (database.select(database.companySettingsTable)
          ..where((t) => t.id.equals(CompanySettings.singletonId)))
        .getSingleOrNull();
  }

  /// Normalizes a raw text field to trimmed-or-null.
  String? _optional(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  String? _stateCodeFromGstin(String gstin) {
    final normalized = _optional(gstin)?.toUpperCase();
    if (normalized == null || normalized.length != 15) return null;
    return normalized.substring(0, 2);
  }

  db.CompanySettingsTableCompanion _toInsertCompanion(
    CompanySettingsDraft draft, {
    required DateTime now,
  }) {
    return db.CompanySettingsTableCompanion.insert(
      id: const Value(CompanySettings.singletonId),
      companyName: draft.businessName.trim(),
      legalName: Value(_optional(draft.legalName)),
      businessType: Value(draft.businessType.dbValue),
      gstRegistered: Value(draft.gstRegistered),
      gstNumber: Value(_optional(draft.gstin)?.toUpperCase()),
      panNumber: Value(_optional(draft.pan)?.toUpperCase()),
      cin: Value(_optional(draft.cin)?.toUpperCase()),
      mobile: Value(_optional(draft.phone)),
      email: Value(_optional(draft.email)?.toLowerCase()),
      website: Value(_optional(draft.website)),
      addressLine1: Value(_optional(draft.addressLine1)),
      addressLine2: Value(_optional(draft.addressLine2)),
      city: Value(_optional(draft.city)),
      state: Value(_optional(draft.state)),
      stateCode: Value(_stateCodeFromGstin(draft.gstin)),
      country: Value(_optional(draft.country)),
      pincode: Value(_optional(draft.pincode)),
      logoPath: Value(draft.logoPath),
      pricesInclusiveOfTax: Value(draft.defaultTaxType.inclusiveOfTax),
      invoicePrefix: Value(draft.invoicePrefix.trim()),
      invoiceStartNumber: Value(_parsePositiveInt(draft.invoiceStartNumber)),
      financialYearStartMonth: Value(draft.financialYearStartMonth),
      currencyCode: Value(
        _optional(draft.currencyCode)?.toUpperCase() ?? 'INR',
      ),
      currencySymbol: Value(_optional(draft.currencySymbol) ?? '\u20B9'),
      decimalPlaces: Value(draft.decimalPlaces),
      bankName: Value(_optional(draft.bankName)),
      bankAccountName: Value(_optional(draft.bankAccountName)),
      bankAccountNumber: Value(_optional(draft.bankAccountNumber)),
      bankIfsc: Value(_optional(draft.bankIfsc)?.toUpperCase()),
      bankBranch: Value(_optional(draft.bankBranch)),
      upiId: Value(_optional(draft.upiId)),
      invoiceFooter: Value(_optional(draft.invoiceFooter)),
      invoiceTerms: Value(_optional(draft.invoiceTerms)),
      invoiceThankYouMessage: Value(_optional(draft.invoiceThankYouMessage)),
      showLogoOnInvoice: Value(draft.showLogoOnInvoice),
      showBankDetailsOnInvoice: Value(draft.showBankDetailsOnInvoice),
      showGstDetailsOnInvoice: Value(draft.showGstDetailsOnInvoice),
      createdAt: Value(now),
      updatedAt: Value(now),
    );
  }

  db.CompanySettingsTableCompanion _toUpdateCompanion(
    CompanySettingsDraft draft, {
    required db.CompanySettings existing,
  }) {
    return db.CompanySettingsTableCompanion(
      companyName: Value(draft.businessName.trim()),
      legalName: Value(_optional(draft.legalName)),
      businessType: Value(draft.businessType.dbValue),
      gstRegistered: Value(draft.gstRegistered),
      gstNumber: Value(_optional(draft.gstin)?.toUpperCase()),
      panNumber: Value(_optional(draft.pan)?.toUpperCase()),
      cin: Value(_optional(draft.cin)?.toUpperCase()),
      mobile: Value(_optional(draft.phone)),
      email: Value(_optional(draft.email)?.toLowerCase()),
      website: Value(_optional(draft.website)),
      addressLine1: Value(_optional(draft.addressLine1)),
      addressLine2: Value(_optional(draft.addressLine2)),
      city: Value(_optional(draft.city)),
      state: Value(_optional(draft.state)),
      stateCode: Value(_stateCodeFromGstin(draft.gstin)),
      country: Value(_optional(draft.country)),
      pincode: Value(_optional(draft.pincode)),
      logoPath: Value(draft.logoPath),
      pricesInclusiveOfTax: Value(draft.defaultTaxType.inclusiveOfTax),
      invoicePrefix: Value(draft.invoicePrefix.trim()),
      invoiceStartNumber: Value(_parsePositiveInt(draft.invoiceStartNumber)),
      financialYearStartMonth: Value(draft.financialYearStartMonth),
      currencyCode: Value(
        _optional(draft.currencyCode)?.toUpperCase() ?? 'INR',
      ),
      currencySymbol: Value(_optional(draft.currencySymbol) ?? '\u20B9'),
      decimalPlaces: Value(draft.decimalPlaces),
      bankName: Value(_optional(draft.bankName)),
      bankAccountName: Value(_optional(draft.bankAccountName)),
      bankAccountNumber: Value(_optional(draft.bankAccountNumber)),
      bankIfsc: Value(_optional(draft.bankIfsc)?.toUpperCase()),
      bankBranch: Value(_optional(draft.bankBranch)),
      upiId: Value(_optional(draft.upiId)),
      invoiceFooter: Value(_optional(draft.invoiceFooter)),
      invoiceTerms: Value(_optional(draft.invoiceTerms)),
      invoiceThankYouMessage: Value(_optional(draft.invoiceThankYouMessage)),
      showLogoOnInvoice: Value(draft.showLogoOnInvoice),
      showBankDetailsOnInvoice: Value(draft.showBankDetailsOnInvoice),
      showGstDetailsOnInvoice: Value(draft.showGstDetailsOnInvoice),
      updatedAt: Value(DateTime.now()),
    );
  }

  int _parsePositiveInt(String value) {
    final parsed = int.tryParse(value.trim());
    return (parsed == null || parsed < 1) ? 1 : parsed;
  }

  CompanySettings _toEntity(db.CompanySettings row) {
    return CompanySettings(
      id: row.id,
      companyName: row.companyName,
      legalName: row.legalName,
      businessType: BusinessType.fromDbValue(row.businessType),
      gstRegistered: row.gstRegistered,
      gstNumber: row.gstNumber,
      panNumber: row.panNumber,
      cin: row.cin,
      mobile: row.mobile,
      email: row.email,
      website: row.website,
      addressLine1: row.addressLine1,
      addressLine2: row.addressLine2,
      city: row.city,
      state: row.state,
      stateCode: row.stateCode,
      country: row.country,
      pincode: row.pincode,
      logoPath: row.logoPath,
      defaultTaxType: TaxTreatment.fromInclusive(row.pricesInclusiveOfTax),
      invoicePrefix: row.invoicePrefix,
      invoiceStartNumber: row.invoiceStartNumber,
      financialYearStartMonth: row.financialYearStartMonth,
      currencyCode: row.currencyCode,
      currencySymbol: row.currencySymbol,
      decimalPlaces: row.decimalPlaces,
      bankName: row.bankName,
      bankAccountName: row.bankAccountName,
      bankAccountNumber: row.bankAccountNumber,
      bankIfsc: row.bankIfsc,
      bankBranch: row.bankBranch,
      upiId: row.upiId,
      invoiceFooter: row.invoiceFooter,
      invoiceTerms: row.invoiceTerms,
      invoiceThankYouMessage: row.invoiceThankYouMessage,
      showLogoOnInvoice: row.showLogoOnInvoice,
      showBankDetailsOnInvoice: row.showBankDetailsOnInvoice,
      showGstDetailsOnInvoice: row.showGstDetailsOnInvoice,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }
}
