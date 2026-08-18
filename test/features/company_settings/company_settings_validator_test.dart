import 'package:flutter_test/flutter_test.dart';

import 'package:retail_erp/features/company_settings/domain/company_settings_enums.dart';
import 'package:retail_erp/features/company_settings/domain/entities/company_settings_draft.dart';
import 'package:retail_erp/features/company_settings/services/company_settings_validator.dart';

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

void main() {
  group('CompanySettingsValidator.validate', () {
    test('accepts a fully valid draft', () {
      final errors = CompanySettingsValidator.validate(_validDraft());
      expect(errors.values.where((e) => e != null), isEmpty);
    });

    test('requires business name, address line 1, city, state, pincode', () {
      final draft = _validDraft().withLogoPath(null);
      final errors = CompanySettingsValidator.validate(
        CompanySettingsDraft(
          businessName: '',
          businessType: draft.businessType,
          gstRegistered: false,
          phone: '',
          addressLine1: '',
          city: '',
          state: '',
          pincode: '',
          defaultTaxType: draft.defaultTaxType,
          invoicePrefix: '',
          invoiceStartNumber: '',
          financialYearStartMonth: 4,
          decimalPlaces: 2,
          showLogoOnInvoice: true,
          showBankDetailsOnInvoice: true,
          showGstDetailsOnInvoice: true,
        ),
      );

      expect(errors['businessName'], 'Business name is required.');
      expect(errors['addressLine1'], 'Address 1 is required.');
      expect(errors['city'], 'City is required.');
      expect(errors['state'], 'State is required.');
      expect(errors['pincode'], 'Pincode is required.');
      expect(errors['phone'], 'Phone number is required.');
      expect(errors['invoicePrefix'], 'Invoice prefix is required.');
      expect(errors['invoiceStartNumber'], 'Starting invoice number is required.');
    });

    test('requires GSTIN only when GST registration is enabled', () {
      final base = _validDraft();

      final disabled = CompanySettingsValidator.validate(
        base.withLogoPath(null),
      );
      expect(disabled['gstin'], isNull);

      final enabled = CompanySettingsValidator.validate(
        CompanySettingsDraft(
          businessName: base.businessName,
          businessType: base.businessType,
          gstRegistered: true,
          phone: base.phone,
          addressLine1: base.addressLine1,
          city: base.city,
          state: base.state,
          pincode: base.pincode,
          defaultTaxType: base.defaultTaxType,
          invoicePrefix: base.invoicePrefix,
          invoiceStartNumber: base.invoiceStartNumber,
          financialYearStartMonth: 4,
          decimalPlaces: 2,
          showLogoOnInvoice: true,
          showBankDetailsOnInvoice: true,
          showGstDetailsOnInvoice: true,
        ),
      );
      expect(
        enabled['gstin'],
        'GSTIN is required when GST registration is enabled.',
      );
    });

    test('requires CIN for incorporated business types only', () {
      final base = _validDraft();

      CompanySettingsDraft withType(BusinessType type, {String cin = ''}) {
        return CompanySettingsDraft(
          businessName: base.businessName,
          businessType: type,
          gstRegistered: false,
          cin: cin,
          phone: base.phone,
          addressLine1: base.addressLine1,
          city: base.city,
          state: base.state,
          pincode: base.pincode,
          defaultTaxType: base.defaultTaxType,
          invoicePrefix: base.invoicePrefix,
          invoiceStartNumber: base.invoiceStartNumber,
          financialYearStartMonth: 4,
          decimalPlaces: 2,
          showLogoOnInvoice: true,
          showBankDetailsOnInvoice: true,
          showGstDetailsOnInvoice: true,
        );
      }

      expect(
        CompanySettingsValidator.validate(withType(BusinessType.llp))['cin'],
        'CIN is required for this business type.',
      );
      expect(
        CompanySettingsValidator.validate(
          withType(BusinessType.privateLimited),
        )['cin'],
        'CIN is required for this business type.',
      );
      expect(
        CompanySettingsValidator.validate(
          withType(BusinessType.proprietorship),
        )['cin'],
        isNull,
      );
      // Valid CIN passes for incorporated types.
      expect(
        CompanySettingsValidator.validate(
          withType(
            BusinessType.privateLimited,
            cin: 'U12345MH2024PTC123456',
          ),
        )['cin'],
        isNull,
      );
    });
  });

  group('field validators', () {
    test('GSTIN format', () {
      expect(
        CompanySettingsValidator.validateGstin('27ABCDE1234F1Z5'),
        isNull,
      );
      expect(
        CompanySettingsValidator.validateGstin('27abcde1234f1z5'),
        isNull,
      );
      expect(
        CompanySettingsValidator.validateGstin('12345'),
        isNotNull,
      );
    });

    test('PAN format', () {
      expect(CompanySettingsValidator.validatePan('ABCDE1234F'), isNull);
      expect(CompanySettingsValidator.validatePan('abcde1234f'), isNull);
      expect(CompanySettingsValidator.validatePan('ABCDE123'), isNotNull);
    });

    test('CIN format', () {
      expect(
        CompanySettingsValidator.validateCin('U12345MH2024PTC123456'),
        isNull,
      );
      expect(
        CompanySettingsValidator.validateCin('L21090DL2024PLC123456'),
        isNull,
      );
      expect(
        CompanySettingsValidator.validateCin('U12345MH2024PTC'),
        isNotNull,
      );
    });

    test('phone accepts mobile and landline, rejects others', () {
      expect(CompanySettingsValidator.validatePhone('9876543210'), isNull);
      expect(CompanySettingsValidator.validatePhone('+91 98765 43210'), isNull);
      expect(CompanySettingsValidator.validatePhone('022-12345678'), isNull);
      expect(CompanySettingsValidator.validatePhone('12345'), isNotNull);
      expect(CompanySettingsValidator.validatePhone('1234567890'), isNotNull);
    });

    test('email format', () {
      expect(CompanySettingsValidator.validateEmail('acme@example.com'), isNull);
      expect(CompanySettingsValidator.validateEmail('not-an-email'), isNotNull);
      expect(CompanySettingsValidator.validateEmail(''), isNull);
    });

    test('website accepts bare domains and URLs, rejects junk', () {
      expect(CompanySettingsValidator.validateWebsite('acme.com'), isNull);
      expect(
        CompanySettingsValidator.validateWebsite('https://www.acme.com/in'),
        isNull,
      );
      expect(CompanySettingsValidator.validateWebsite('acme'), isNotNull);
      expect(CompanySettingsValidator.validateWebsite(''), isNull);
    });

    test('pincode is a 6-digit number', () {
      expect(CompanySettingsValidator.validatePincode('400001'), isNull);
      expect(CompanySettingsValidator.validatePincode('40001'), isNotNull);
    });

    test('IFSC code', () {
      expect(
        CompanySettingsValidator.validateIfsc('SBIN0001234'),
        isNull,
      );
      expect(
        CompanySettingsValidator.validateIfsc('sbin0001234'),
        isNull,
      );
      expect(CompanySettingsValidator.validateIfsc('SBIN123'), isNotNull);
    });

    test('UPI ID', () {
      expect(CompanySettingsValidator.validateUpiId('acme@upi'), isNull);
      expect(CompanySettingsValidator.validateUpiId('acme.upi@ybl'), isNull);
      expect(CompanySettingsValidator.validateUpiId('acme'), isNotNull);
    });

    test('invoice prefix trims, caps length and rejects invalid characters', () {
      expect(CompanySettingsValidator.validateInvoicePrefix('  INV-2026  '), isNull);
      expect(CompanySettingsValidator.validateInvoicePrefix('INV 2026'), isNotNull);
      expect(CompanySettingsValidator.validateInvoicePrefix('INV/2026'), isNotNull);
      expect(
        CompanySettingsValidator.validateInvoicePrefix('ABCDEFGHIJK'),
        isNotNull,
      );
      expect(CompanySettingsValidator.validateInvoicePrefix(''), isNotNull);
    });

    test('invoice start number must be a positive integer', () {
      expect(CompanySettingsValidator.validateInvoiceStartNumber('1'), isNull);
      expect(CompanySettingsValidator.validateInvoiceStartNumber('500'), isNull);
      expect(CompanySettingsValidator.validateInvoiceStartNumber('0'), isNotNull);
      expect(CompanySettingsValidator.validateInvoiceStartNumber('-3'), isNotNull);
      expect(CompanySettingsValidator.validateInvoiceStartNumber('1.5'), isNotNull);
      expect(CompanySettingsValidator.validateInvoiceStartNumber('abc'), isNotNull);
    });

    test('currency code is a 3-letter code', () {
      expect(CompanySettingsValidator.validateCurrencyCode('INR'), isNull);
      expect(CompanySettingsValidator.validateCurrencyCode('inr'), isNull);
      expect(CompanySettingsValidator.validateCurrencyCode('USD1'), isNotNull);
    });
  });
}
