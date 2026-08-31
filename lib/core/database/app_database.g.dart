// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $CompanySettingsTableTable extends CompanySettingsTable
    with TableInfo<$CompanySettingsTableTable, CompanySettings> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CompanySettingsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _companyNameMeta = const VerificationMeta(
    'companyName',
  );
  @override
  late final GeneratedColumn<String> companyName = GeneratedColumn<String>(
    'company_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _legalNameMeta = const VerificationMeta(
    'legalName',
  );
  @override
  late final GeneratedColumn<String> legalName = GeneratedColumn<String>(
    'legal_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _businessTypeMeta = const VerificationMeta(
    'businessType',
  );
  @override
  late final GeneratedColumn<String> businessType = GeneratedColumn<String>(
    'business_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('PROPRIETORSHIP'),
  );
  static const VerificationMeta _gstRegisteredMeta = const VerificationMeta(
    'gstRegistered',
  );
  @override
  late final GeneratedColumn<bool> gstRegistered = GeneratedColumn<bool>(
    'gst_registered',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("gst_registered" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _gstNumberMeta = const VerificationMeta(
    'gstNumber',
  );
  @override
  late final GeneratedColumn<String> gstNumber = GeneratedColumn<String>(
    'gst_number',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _panNumberMeta = const VerificationMeta(
    'panNumber',
  );
  @override
  late final GeneratedColumn<String> panNumber = GeneratedColumn<String>(
    'pan_number',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cinMeta = const VerificationMeta('cin');
  @override
  late final GeneratedColumn<String> cin = GeneratedColumn<String>(
    'cin',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _mobileMeta = const VerificationMeta('mobile');
  @override
  late final GeneratedColumn<String> mobile = GeneratedColumn<String>(
    'mobile',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _websiteMeta = const VerificationMeta(
    'website',
  );
  @override
  late final GeneratedColumn<String> website = GeneratedColumn<String>(
    'website',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _addressLine1Meta = const VerificationMeta(
    'addressLine1',
  );
  @override
  late final GeneratedColumn<String> addressLine1 = GeneratedColumn<String>(
    'address_line1',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _addressLine2Meta = const VerificationMeta(
    'addressLine2',
  );
  @override
  late final GeneratedColumn<String> addressLine2 = GeneratedColumn<String>(
    'address_line2',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cityMeta = const VerificationMeta('city');
  @override
  late final GeneratedColumn<String> city = GeneratedColumn<String>(
    'city',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _stateMeta = const VerificationMeta('state');
  @override
  late final GeneratedColumn<String> state = GeneratedColumn<String>(
    'state',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _stateCodeMeta = const VerificationMeta(
    'stateCode',
  );
  @override
  late final GeneratedColumn<String> stateCode = GeneratedColumn<String>(
    'state_code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _countryMeta = const VerificationMeta(
    'country',
  );
  @override
  late final GeneratedColumn<String> country = GeneratedColumn<String>(
    'country',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pincodeMeta = const VerificationMeta(
    'pincode',
  );
  @override
  late final GeneratedColumn<String> pincode = GeneratedColumn<String>(
    'pincode',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _logoPathMeta = const VerificationMeta(
    'logoPath',
  );
  @override
  late final GeneratedColumn<String> logoPath = GeneratedColumn<String>(
    'logo_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pricesInclusiveOfTaxMeta =
      const VerificationMeta('pricesInclusiveOfTax');
  @override
  late final GeneratedColumn<bool> pricesInclusiveOfTax = GeneratedColumn<bool>(
    'prices_inclusive_of_tax',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("prices_inclusive_of_tax" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _invoicePrefixMeta = const VerificationMeta(
    'invoicePrefix',
  );
  @override
  late final GeneratedColumn<String> invoicePrefix = GeneratedColumn<String>(
    'invoice_prefix',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('INV-'),
  );
  static const VerificationMeta _invoiceStartNumberMeta =
      const VerificationMeta('invoiceStartNumber');
  @override
  late final GeneratedColumn<int> invoiceStartNumber = GeneratedColumn<int>(
    'invoice_start_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _purchasePrefixMeta = const VerificationMeta(
    'purchasePrefix',
  );
  @override
  late final GeneratedColumn<String> purchasePrefix = GeneratedColumn<String>(
    'purchase_prefix',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('PUR-'),
  );
  static const VerificationMeta _receiptPrefixMeta = const VerificationMeta(
    'receiptPrefix',
  );
  @override
  late final GeneratedColumn<String> receiptPrefix = GeneratedColumn<String>(
    'receipt_prefix',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('RCT-'),
  );
  static const VerificationMeta _financialYearStartMonthMeta =
      const VerificationMeta('financialYearStartMonth');
  @override
  late final GeneratedColumn<int> financialYearStartMonth =
      GeneratedColumn<int>(
        'financial_year_start_month',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultValue: const Constant(4),
      );
  static const VerificationMeta _currencyCodeMeta = const VerificationMeta(
    'currencyCode',
  );
  @override
  late final GeneratedColumn<String> currencyCode = GeneratedColumn<String>(
    'currency_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('INR'),
  );
  static const VerificationMeta _currencySymbolMeta = const VerificationMeta(
    'currencySymbol',
  );
  @override
  late final GeneratedColumn<String> currencySymbol = GeneratedColumn<String>(
    'currency_symbol',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('\u20B9'),
  );
  static const VerificationMeta _decimalPlacesMeta = const VerificationMeta(
    'decimalPlaces',
  );
  @override
  late final GeneratedColumn<int> decimalPlaces = GeneratedColumn<int>(
    'decimal_places',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(2),
  );
  static const VerificationMeta _timezoneMeta = const VerificationMeta(
    'timezone',
  );
  @override
  late final GeneratedColumn<String> timezone = GeneratedColumn<String>(
    'timezone',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Asia/Kolkata'),
  );
  static const VerificationMeta _bankNameMeta = const VerificationMeta(
    'bankName',
  );
  @override
  late final GeneratedColumn<String> bankName = GeneratedColumn<String>(
    'bank_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bankAccountNameMeta = const VerificationMeta(
    'bankAccountName',
  );
  @override
  late final GeneratedColumn<String> bankAccountName = GeneratedColumn<String>(
    'bank_account_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bankAccountNumberMeta = const VerificationMeta(
    'bankAccountNumber',
  );
  @override
  late final GeneratedColumn<String> bankAccountNumber =
      GeneratedColumn<String>(
        'bank_account_number',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _bankIfscMeta = const VerificationMeta(
    'bankIfsc',
  );
  @override
  late final GeneratedColumn<String> bankIfsc = GeneratedColumn<String>(
    'bank_ifsc',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bankBranchMeta = const VerificationMeta(
    'bankBranch',
  );
  @override
  late final GeneratedColumn<String> bankBranch = GeneratedColumn<String>(
    'bank_branch',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _upiIdMeta = const VerificationMeta('upiId');
  @override
  late final GeneratedColumn<String> upiId = GeneratedColumn<String>(
    'upi_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _invoiceFooterMeta = const VerificationMeta(
    'invoiceFooter',
  );
  @override
  late final GeneratedColumn<String> invoiceFooter = GeneratedColumn<String>(
    'invoice_footer',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _invoiceTermsMeta = const VerificationMeta(
    'invoiceTerms',
  );
  @override
  late final GeneratedColumn<String> invoiceTerms = GeneratedColumn<String>(
    'invoice_terms',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _invoiceThankYouMessageMeta =
      const VerificationMeta('invoiceThankYouMessage');
  @override
  late final GeneratedColumn<String> invoiceThankYouMessage =
      GeneratedColumn<String>(
        'invoice_thank_you_message',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _showLogoOnInvoiceMeta = const VerificationMeta(
    'showLogoOnInvoice',
  );
  @override
  late final GeneratedColumn<bool> showLogoOnInvoice = GeneratedColumn<bool>(
    'show_logo_on_invoice',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("show_logo_on_invoice" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _showBankDetailsOnInvoiceMeta =
      const VerificationMeta('showBankDetailsOnInvoice');
  @override
  late final GeneratedColumn<bool> showBankDetailsOnInvoice =
      GeneratedColumn<bool>(
        'show_bank_details_on_invoice',
        aliasedName,
        false,
        type: DriftSqlType.bool,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("show_bank_details_on_invoice" IN (0, 1))',
        ),
        defaultValue: const Constant(true),
      );
  static const VerificationMeta _showGstDetailsOnInvoiceMeta =
      const VerificationMeta('showGstDetailsOnInvoice');
  @override
  late final GeneratedColumn<bool> showGstDetailsOnInvoice =
      GeneratedColumn<bool>(
        'show_gst_details_on_invoice',
        aliasedName,
        false,
        type: DriftSqlType.bool,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("show_gst_details_on_invoice" IN (0, 1))',
        ),
        defaultValue: const Constant(true),
      );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    companyName,
    legalName,
    businessType,
    gstRegistered,
    gstNumber,
    panNumber,
    cin,
    mobile,
    email,
    website,
    addressLine1,
    addressLine2,
    city,
    state,
    stateCode,
    country,
    pincode,
    logoPath,
    pricesInclusiveOfTax,
    invoicePrefix,
    invoiceStartNumber,
    purchasePrefix,
    receiptPrefix,
    financialYearStartMonth,
    currencyCode,
    currencySymbol,
    decimalPlaces,
    timezone,
    bankName,
    bankAccountName,
    bankAccountNumber,
    bankIfsc,
    bankBranch,
    upiId,
    invoiceFooter,
    invoiceTerms,
    invoiceThankYouMessage,
    showLogoOnInvoice,
    showBankDetailsOnInvoice,
    showGstDetailsOnInvoice,
    isActive,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'company_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<CompanySettings> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('company_name')) {
      context.handle(
        _companyNameMeta,
        companyName.isAcceptableOrUnknown(
          data['company_name']!,
          _companyNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_companyNameMeta);
    }
    if (data.containsKey('legal_name')) {
      context.handle(
        _legalNameMeta,
        legalName.isAcceptableOrUnknown(data['legal_name']!, _legalNameMeta),
      );
    }
    if (data.containsKey('business_type')) {
      context.handle(
        _businessTypeMeta,
        businessType.isAcceptableOrUnknown(
          data['business_type']!,
          _businessTypeMeta,
        ),
      );
    }
    if (data.containsKey('gst_registered')) {
      context.handle(
        _gstRegisteredMeta,
        gstRegistered.isAcceptableOrUnknown(
          data['gst_registered']!,
          _gstRegisteredMeta,
        ),
      );
    }
    if (data.containsKey('gst_number')) {
      context.handle(
        _gstNumberMeta,
        gstNumber.isAcceptableOrUnknown(data['gst_number']!, _gstNumberMeta),
      );
    }
    if (data.containsKey('pan_number')) {
      context.handle(
        _panNumberMeta,
        panNumber.isAcceptableOrUnknown(data['pan_number']!, _panNumberMeta),
      );
    }
    if (data.containsKey('cin')) {
      context.handle(
        _cinMeta,
        cin.isAcceptableOrUnknown(data['cin']!, _cinMeta),
      );
    }
    if (data.containsKey('mobile')) {
      context.handle(
        _mobileMeta,
        mobile.isAcceptableOrUnknown(data['mobile']!, _mobileMeta),
      );
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    }
    if (data.containsKey('website')) {
      context.handle(
        _websiteMeta,
        website.isAcceptableOrUnknown(data['website']!, _websiteMeta),
      );
    }
    if (data.containsKey('address_line1')) {
      context.handle(
        _addressLine1Meta,
        addressLine1.isAcceptableOrUnknown(
          data['address_line1']!,
          _addressLine1Meta,
        ),
      );
    }
    if (data.containsKey('address_line2')) {
      context.handle(
        _addressLine2Meta,
        addressLine2.isAcceptableOrUnknown(
          data['address_line2']!,
          _addressLine2Meta,
        ),
      );
    }
    if (data.containsKey('city')) {
      context.handle(
        _cityMeta,
        city.isAcceptableOrUnknown(data['city']!, _cityMeta),
      );
    }
    if (data.containsKey('state')) {
      context.handle(
        _stateMeta,
        state.isAcceptableOrUnknown(data['state']!, _stateMeta),
      );
    }
    if (data.containsKey('state_code')) {
      context.handle(
        _stateCodeMeta,
        stateCode.isAcceptableOrUnknown(data['state_code']!, _stateCodeMeta),
      );
    }
    if (data.containsKey('country')) {
      context.handle(
        _countryMeta,
        country.isAcceptableOrUnknown(data['country']!, _countryMeta),
      );
    }
    if (data.containsKey('pincode')) {
      context.handle(
        _pincodeMeta,
        pincode.isAcceptableOrUnknown(data['pincode']!, _pincodeMeta),
      );
    }
    if (data.containsKey('logo_path')) {
      context.handle(
        _logoPathMeta,
        logoPath.isAcceptableOrUnknown(data['logo_path']!, _logoPathMeta),
      );
    }
    if (data.containsKey('prices_inclusive_of_tax')) {
      context.handle(
        _pricesInclusiveOfTaxMeta,
        pricesInclusiveOfTax.isAcceptableOrUnknown(
          data['prices_inclusive_of_tax']!,
          _pricesInclusiveOfTaxMeta,
        ),
      );
    }
    if (data.containsKey('invoice_prefix')) {
      context.handle(
        _invoicePrefixMeta,
        invoicePrefix.isAcceptableOrUnknown(
          data['invoice_prefix']!,
          _invoicePrefixMeta,
        ),
      );
    }
    if (data.containsKey('invoice_start_number')) {
      context.handle(
        _invoiceStartNumberMeta,
        invoiceStartNumber.isAcceptableOrUnknown(
          data['invoice_start_number']!,
          _invoiceStartNumberMeta,
        ),
      );
    }
    if (data.containsKey('purchase_prefix')) {
      context.handle(
        _purchasePrefixMeta,
        purchasePrefix.isAcceptableOrUnknown(
          data['purchase_prefix']!,
          _purchasePrefixMeta,
        ),
      );
    }
    if (data.containsKey('receipt_prefix')) {
      context.handle(
        _receiptPrefixMeta,
        receiptPrefix.isAcceptableOrUnknown(
          data['receipt_prefix']!,
          _receiptPrefixMeta,
        ),
      );
    }
    if (data.containsKey('financial_year_start_month')) {
      context.handle(
        _financialYearStartMonthMeta,
        financialYearStartMonth.isAcceptableOrUnknown(
          data['financial_year_start_month']!,
          _financialYearStartMonthMeta,
        ),
      );
    }
    if (data.containsKey('currency_code')) {
      context.handle(
        _currencyCodeMeta,
        currencyCode.isAcceptableOrUnknown(
          data['currency_code']!,
          _currencyCodeMeta,
        ),
      );
    }
    if (data.containsKey('currency_symbol')) {
      context.handle(
        _currencySymbolMeta,
        currencySymbol.isAcceptableOrUnknown(
          data['currency_symbol']!,
          _currencySymbolMeta,
        ),
      );
    }
    if (data.containsKey('decimal_places')) {
      context.handle(
        _decimalPlacesMeta,
        decimalPlaces.isAcceptableOrUnknown(
          data['decimal_places']!,
          _decimalPlacesMeta,
        ),
      );
    }
    if (data.containsKey('timezone')) {
      context.handle(
        _timezoneMeta,
        timezone.isAcceptableOrUnknown(data['timezone']!, _timezoneMeta),
      );
    }
    if (data.containsKey('bank_name')) {
      context.handle(
        _bankNameMeta,
        bankName.isAcceptableOrUnknown(data['bank_name']!, _bankNameMeta),
      );
    }
    if (data.containsKey('bank_account_name')) {
      context.handle(
        _bankAccountNameMeta,
        bankAccountName.isAcceptableOrUnknown(
          data['bank_account_name']!,
          _bankAccountNameMeta,
        ),
      );
    }
    if (data.containsKey('bank_account_number')) {
      context.handle(
        _bankAccountNumberMeta,
        bankAccountNumber.isAcceptableOrUnknown(
          data['bank_account_number']!,
          _bankAccountNumberMeta,
        ),
      );
    }
    if (data.containsKey('bank_ifsc')) {
      context.handle(
        _bankIfscMeta,
        bankIfsc.isAcceptableOrUnknown(data['bank_ifsc']!, _bankIfscMeta),
      );
    }
    if (data.containsKey('bank_branch')) {
      context.handle(
        _bankBranchMeta,
        bankBranch.isAcceptableOrUnknown(data['bank_branch']!, _bankBranchMeta),
      );
    }
    if (data.containsKey('upi_id')) {
      context.handle(
        _upiIdMeta,
        upiId.isAcceptableOrUnknown(data['upi_id']!, _upiIdMeta),
      );
    }
    if (data.containsKey('invoice_footer')) {
      context.handle(
        _invoiceFooterMeta,
        invoiceFooter.isAcceptableOrUnknown(
          data['invoice_footer']!,
          _invoiceFooterMeta,
        ),
      );
    }
    if (data.containsKey('invoice_terms')) {
      context.handle(
        _invoiceTermsMeta,
        invoiceTerms.isAcceptableOrUnknown(
          data['invoice_terms']!,
          _invoiceTermsMeta,
        ),
      );
    }
    if (data.containsKey('invoice_thank_you_message')) {
      context.handle(
        _invoiceThankYouMessageMeta,
        invoiceThankYouMessage.isAcceptableOrUnknown(
          data['invoice_thank_you_message']!,
          _invoiceThankYouMessageMeta,
        ),
      );
    }
    if (data.containsKey('show_logo_on_invoice')) {
      context.handle(
        _showLogoOnInvoiceMeta,
        showLogoOnInvoice.isAcceptableOrUnknown(
          data['show_logo_on_invoice']!,
          _showLogoOnInvoiceMeta,
        ),
      );
    }
    if (data.containsKey('show_bank_details_on_invoice')) {
      context.handle(
        _showBankDetailsOnInvoiceMeta,
        showBankDetailsOnInvoice.isAcceptableOrUnknown(
          data['show_bank_details_on_invoice']!,
          _showBankDetailsOnInvoiceMeta,
        ),
      );
    }
    if (data.containsKey('show_gst_details_on_invoice')) {
      context.handle(
        _showGstDetailsOnInvoiceMeta,
        showGstDetailsOnInvoice.isAcceptableOrUnknown(
          data['show_gst_details_on_invoice']!,
          _showGstDetailsOnInvoiceMeta,
        ),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CompanySettings map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CompanySettings(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      companyName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}company_name'],
      )!,
      legalName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}legal_name'],
      ),
      businessType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}business_type'],
      )!,
      gstRegistered: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}gst_registered'],
      )!,
      gstNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}gst_number'],
      ),
      panNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pan_number'],
      ),
      cin: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cin'],
      ),
      mobile: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mobile'],
      ),
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      ),
      website: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}website'],
      ),
      addressLine1: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address_line1'],
      ),
      addressLine2: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address_line2'],
      ),
      city: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}city'],
      ),
      state: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}state'],
      ),
      stateCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}state_code'],
      ),
      country: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}country'],
      ),
      pincode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pincode'],
      ),
      logoPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}logo_path'],
      ),
      pricesInclusiveOfTax: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}prices_inclusive_of_tax'],
      )!,
      invoicePrefix: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}invoice_prefix'],
      )!,
      invoiceStartNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}invoice_start_number'],
      )!,
      purchasePrefix: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}purchase_prefix'],
      )!,
      receiptPrefix: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}receipt_prefix'],
      )!,
      financialYearStartMonth: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}financial_year_start_month'],
      )!,
      currencyCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency_code'],
      )!,
      currencySymbol: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency_symbol'],
      )!,
      decimalPlaces: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}decimal_places'],
      )!,
      timezone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}timezone'],
      )!,
      bankName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bank_name'],
      ),
      bankAccountName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bank_account_name'],
      ),
      bankAccountNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bank_account_number'],
      ),
      bankIfsc: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bank_ifsc'],
      ),
      bankBranch: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bank_branch'],
      ),
      upiId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}upi_id'],
      ),
      invoiceFooter: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}invoice_footer'],
      ),
      invoiceTerms: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}invoice_terms'],
      ),
      invoiceThankYouMessage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}invoice_thank_you_message'],
      ),
      showLogoOnInvoice: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}show_logo_on_invoice'],
      )!,
      showBankDetailsOnInvoice: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}show_bank_details_on_invoice'],
      )!,
      showGstDetailsOnInvoice: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}show_gst_details_on_invoice'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $CompanySettingsTableTable createAlias(String alias) {
    return $CompanySettingsTableTable(attachedDatabase, alias);
  }
}

class CompanySettings extends DataClass implements Insertable<CompanySettings> {
  /// Primary key. `CHECK (id = 1)` enforces the single-row rule.
  final int id;

  /// The name displayed throughout the ERP.
  final String companyName;
  final String? legalName;

  /// One of the [BusinessType] db values (e.g. `PROPRIETORSHIP`).
  final String businessType;

  /// Whether the business is registered for GST; when true the GSTIN is
  /// required by the application layer.
  final bool gstRegistered;
  final String? gstNumber;
  final String? panNumber;
  final String? cin;
  final String? mobile;
  final String? email;
  final String? website;
  final String? addressLine1;
  final String? addressLine2;
  final String? city;
  final String? state;
  final String? stateCode;
  final String? country;
  final String? pincode;

  /// Absolute path of the logo file stored outside the database.
  final String? logoPath;

  /// `true` = tax inclusive, `false` = tax exclusive (the default tax type).
  final bool pricesInclusiveOfTax;
  final String invoicePrefix;
  final int invoiceStartNumber;
  final String purchasePrefix;
  final String receiptPrefix;

  /// 1–12; April (4) is the default Indian financial-year start.
  final int financialYearStartMonth;
  final String currencyCode;
  final String currencySymbol;
  final int decimalPlaces;
  final String timezone;
  final String? bankName;
  final String? bankAccountName;
  final String? bankAccountNumber;
  final String? bankIfsc;
  final String? bankBranch;
  final String? upiId;
  final String? invoiceFooter;
  final String? invoiceTerms;
  final String? invoiceThankYouMessage;
  final bool showLogoOnInvoice;
  final bool showBankDetailsOnInvoice;
  final bool showGstDetailsOnInvoice;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  const CompanySettings({
    required this.id,
    required this.companyName,
    this.legalName,
    required this.businessType,
    required this.gstRegistered,
    this.gstNumber,
    this.panNumber,
    this.cin,
    this.mobile,
    this.email,
    this.website,
    this.addressLine1,
    this.addressLine2,
    this.city,
    this.state,
    this.stateCode,
    this.country,
    this.pincode,
    this.logoPath,
    required this.pricesInclusiveOfTax,
    required this.invoicePrefix,
    required this.invoiceStartNumber,
    required this.purchasePrefix,
    required this.receiptPrefix,
    required this.financialYearStartMonth,
    required this.currencyCode,
    required this.currencySymbol,
    required this.decimalPlaces,
    required this.timezone,
    this.bankName,
    this.bankAccountName,
    this.bankAccountNumber,
    this.bankIfsc,
    this.bankBranch,
    this.upiId,
    this.invoiceFooter,
    this.invoiceTerms,
    this.invoiceThankYouMessage,
    required this.showLogoOnInvoice,
    required this.showBankDetailsOnInvoice,
    required this.showGstDetailsOnInvoice,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['company_name'] = Variable<String>(companyName);
    if (!nullToAbsent || legalName != null) {
      map['legal_name'] = Variable<String>(legalName);
    }
    map['business_type'] = Variable<String>(businessType);
    map['gst_registered'] = Variable<bool>(gstRegistered);
    if (!nullToAbsent || gstNumber != null) {
      map['gst_number'] = Variable<String>(gstNumber);
    }
    if (!nullToAbsent || panNumber != null) {
      map['pan_number'] = Variable<String>(panNumber);
    }
    if (!nullToAbsent || cin != null) {
      map['cin'] = Variable<String>(cin);
    }
    if (!nullToAbsent || mobile != null) {
      map['mobile'] = Variable<String>(mobile);
    }
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || website != null) {
      map['website'] = Variable<String>(website);
    }
    if (!nullToAbsent || addressLine1 != null) {
      map['address_line1'] = Variable<String>(addressLine1);
    }
    if (!nullToAbsent || addressLine2 != null) {
      map['address_line2'] = Variable<String>(addressLine2);
    }
    if (!nullToAbsent || city != null) {
      map['city'] = Variable<String>(city);
    }
    if (!nullToAbsent || state != null) {
      map['state'] = Variable<String>(state);
    }
    if (!nullToAbsent || stateCode != null) {
      map['state_code'] = Variable<String>(stateCode);
    }
    if (!nullToAbsent || country != null) {
      map['country'] = Variable<String>(country);
    }
    if (!nullToAbsent || pincode != null) {
      map['pincode'] = Variable<String>(pincode);
    }
    if (!nullToAbsent || logoPath != null) {
      map['logo_path'] = Variable<String>(logoPath);
    }
    map['prices_inclusive_of_tax'] = Variable<bool>(pricesInclusiveOfTax);
    map['invoice_prefix'] = Variable<String>(invoicePrefix);
    map['invoice_start_number'] = Variable<int>(invoiceStartNumber);
    map['purchase_prefix'] = Variable<String>(purchasePrefix);
    map['receipt_prefix'] = Variable<String>(receiptPrefix);
    map['financial_year_start_month'] = Variable<int>(financialYearStartMonth);
    map['currency_code'] = Variable<String>(currencyCode);
    map['currency_symbol'] = Variable<String>(currencySymbol);
    map['decimal_places'] = Variable<int>(decimalPlaces);
    map['timezone'] = Variable<String>(timezone);
    if (!nullToAbsent || bankName != null) {
      map['bank_name'] = Variable<String>(bankName);
    }
    if (!nullToAbsent || bankAccountName != null) {
      map['bank_account_name'] = Variable<String>(bankAccountName);
    }
    if (!nullToAbsent || bankAccountNumber != null) {
      map['bank_account_number'] = Variable<String>(bankAccountNumber);
    }
    if (!nullToAbsent || bankIfsc != null) {
      map['bank_ifsc'] = Variable<String>(bankIfsc);
    }
    if (!nullToAbsent || bankBranch != null) {
      map['bank_branch'] = Variable<String>(bankBranch);
    }
    if (!nullToAbsent || upiId != null) {
      map['upi_id'] = Variable<String>(upiId);
    }
    if (!nullToAbsent || invoiceFooter != null) {
      map['invoice_footer'] = Variable<String>(invoiceFooter);
    }
    if (!nullToAbsent || invoiceTerms != null) {
      map['invoice_terms'] = Variable<String>(invoiceTerms);
    }
    if (!nullToAbsent || invoiceThankYouMessage != null) {
      map['invoice_thank_you_message'] = Variable<String>(
        invoiceThankYouMessage,
      );
    }
    map['show_logo_on_invoice'] = Variable<bool>(showLogoOnInvoice);
    map['show_bank_details_on_invoice'] = Variable<bool>(
      showBankDetailsOnInvoice,
    );
    map['show_gst_details_on_invoice'] = Variable<bool>(
      showGstDetailsOnInvoice,
    );
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  CompanySettingsTableCompanion toCompanion(bool nullToAbsent) {
    return CompanySettingsTableCompanion(
      id: Value(id),
      companyName: Value(companyName),
      legalName: legalName == null && nullToAbsent
          ? const Value.absent()
          : Value(legalName),
      businessType: Value(businessType),
      gstRegistered: Value(gstRegistered),
      gstNumber: gstNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(gstNumber),
      panNumber: panNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(panNumber),
      cin: cin == null && nullToAbsent ? const Value.absent() : Value(cin),
      mobile: mobile == null && nullToAbsent
          ? const Value.absent()
          : Value(mobile),
      email: email == null && nullToAbsent
          ? const Value.absent()
          : Value(email),
      website: website == null && nullToAbsent
          ? const Value.absent()
          : Value(website),
      addressLine1: addressLine1 == null && nullToAbsent
          ? const Value.absent()
          : Value(addressLine1),
      addressLine2: addressLine2 == null && nullToAbsent
          ? const Value.absent()
          : Value(addressLine2),
      city: city == null && nullToAbsent ? const Value.absent() : Value(city),
      state: state == null && nullToAbsent
          ? const Value.absent()
          : Value(state),
      stateCode: stateCode == null && nullToAbsent
          ? const Value.absent()
          : Value(stateCode),
      country: country == null && nullToAbsent
          ? const Value.absent()
          : Value(country),
      pincode: pincode == null && nullToAbsent
          ? const Value.absent()
          : Value(pincode),
      logoPath: logoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(logoPath),
      pricesInclusiveOfTax: Value(pricesInclusiveOfTax),
      invoicePrefix: Value(invoicePrefix),
      invoiceStartNumber: Value(invoiceStartNumber),
      purchasePrefix: Value(purchasePrefix),
      receiptPrefix: Value(receiptPrefix),
      financialYearStartMonth: Value(financialYearStartMonth),
      currencyCode: Value(currencyCode),
      currencySymbol: Value(currencySymbol),
      decimalPlaces: Value(decimalPlaces),
      timezone: Value(timezone),
      bankName: bankName == null && nullToAbsent
          ? const Value.absent()
          : Value(bankName),
      bankAccountName: bankAccountName == null && nullToAbsent
          ? const Value.absent()
          : Value(bankAccountName),
      bankAccountNumber: bankAccountNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(bankAccountNumber),
      bankIfsc: bankIfsc == null && nullToAbsent
          ? const Value.absent()
          : Value(bankIfsc),
      bankBranch: bankBranch == null && nullToAbsent
          ? const Value.absent()
          : Value(bankBranch),
      upiId: upiId == null && nullToAbsent
          ? const Value.absent()
          : Value(upiId),
      invoiceFooter: invoiceFooter == null && nullToAbsent
          ? const Value.absent()
          : Value(invoiceFooter),
      invoiceTerms: invoiceTerms == null && nullToAbsent
          ? const Value.absent()
          : Value(invoiceTerms),
      invoiceThankYouMessage: invoiceThankYouMessage == null && nullToAbsent
          ? const Value.absent()
          : Value(invoiceThankYouMessage),
      showLogoOnInvoice: Value(showLogoOnInvoice),
      showBankDetailsOnInvoice: Value(showBankDetailsOnInvoice),
      showGstDetailsOnInvoice: Value(showGstDetailsOnInvoice),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory CompanySettings.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CompanySettings(
      id: serializer.fromJson<int>(json['id']),
      companyName: serializer.fromJson<String>(json['companyName']),
      legalName: serializer.fromJson<String?>(json['legalName']),
      businessType: serializer.fromJson<String>(json['businessType']),
      gstRegistered: serializer.fromJson<bool>(json['gstRegistered']),
      gstNumber: serializer.fromJson<String?>(json['gstNumber']),
      panNumber: serializer.fromJson<String?>(json['panNumber']),
      cin: serializer.fromJson<String?>(json['cin']),
      mobile: serializer.fromJson<String?>(json['mobile']),
      email: serializer.fromJson<String?>(json['email']),
      website: serializer.fromJson<String?>(json['website']),
      addressLine1: serializer.fromJson<String?>(json['addressLine1']),
      addressLine2: serializer.fromJson<String?>(json['addressLine2']),
      city: serializer.fromJson<String?>(json['city']),
      state: serializer.fromJson<String?>(json['state']),
      stateCode: serializer.fromJson<String?>(json['stateCode']),
      country: serializer.fromJson<String?>(json['country']),
      pincode: serializer.fromJson<String?>(json['pincode']),
      logoPath: serializer.fromJson<String?>(json['logoPath']),
      pricesInclusiveOfTax: serializer.fromJson<bool>(
        json['pricesInclusiveOfTax'],
      ),
      invoicePrefix: serializer.fromJson<String>(json['invoicePrefix']),
      invoiceStartNumber: serializer.fromJson<int>(json['invoiceStartNumber']),
      purchasePrefix: serializer.fromJson<String>(json['purchasePrefix']),
      receiptPrefix: serializer.fromJson<String>(json['receiptPrefix']),
      financialYearStartMonth: serializer.fromJson<int>(
        json['financialYearStartMonth'],
      ),
      currencyCode: serializer.fromJson<String>(json['currencyCode']),
      currencySymbol: serializer.fromJson<String>(json['currencySymbol']),
      decimalPlaces: serializer.fromJson<int>(json['decimalPlaces']),
      timezone: serializer.fromJson<String>(json['timezone']),
      bankName: serializer.fromJson<String?>(json['bankName']),
      bankAccountName: serializer.fromJson<String?>(json['bankAccountName']),
      bankAccountNumber: serializer.fromJson<String?>(
        json['bankAccountNumber'],
      ),
      bankIfsc: serializer.fromJson<String?>(json['bankIfsc']),
      bankBranch: serializer.fromJson<String?>(json['bankBranch']),
      upiId: serializer.fromJson<String?>(json['upiId']),
      invoiceFooter: serializer.fromJson<String?>(json['invoiceFooter']),
      invoiceTerms: serializer.fromJson<String?>(json['invoiceTerms']),
      invoiceThankYouMessage: serializer.fromJson<String?>(
        json['invoiceThankYouMessage'],
      ),
      showLogoOnInvoice: serializer.fromJson<bool>(json['showLogoOnInvoice']),
      showBankDetailsOnInvoice: serializer.fromJson<bool>(
        json['showBankDetailsOnInvoice'],
      ),
      showGstDetailsOnInvoice: serializer.fromJson<bool>(
        json['showGstDetailsOnInvoice'],
      ),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'companyName': serializer.toJson<String>(companyName),
      'legalName': serializer.toJson<String?>(legalName),
      'businessType': serializer.toJson<String>(businessType),
      'gstRegistered': serializer.toJson<bool>(gstRegistered),
      'gstNumber': serializer.toJson<String?>(gstNumber),
      'panNumber': serializer.toJson<String?>(panNumber),
      'cin': serializer.toJson<String?>(cin),
      'mobile': serializer.toJson<String?>(mobile),
      'email': serializer.toJson<String?>(email),
      'website': serializer.toJson<String?>(website),
      'addressLine1': serializer.toJson<String?>(addressLine1),
      'addressLine2': serializer.toJson<String?>(addressLine2),
      'city': serializer.toJson<String?>(city),
      'state': serializer.toJson<String?>(state),
      'stateCode': serializer.toJson<String?>(stateCode),
      'country': serializer.toJson<String?>(country),
      'pincode': serializer.toJson<String?>(pincode),
      'logoPath': serializer.toJson<String?>(logoPath),
      'pricesInclusiveOfTax': serializer.toJson<bool>(pricesInclusiveOfTax),
      'invoicePrefix': serializer.toJson<String>(invoicePrefix),
      'invoiceStartNumber': serializer.toJson<int>(invoiceStartNumber),
      'purchasePrefix': serializer.toJson<String>(purchasePrefix),
      'receiptPrefix': serializer.toJson<String>(receiptPrefix),
      'financialYearStartMonth': serializer.toJson<int>(
        financialYearStartMonth,
      ),
      'currencyCode': serializer.toJson<String>(currencyCode),
      'currencySymbol': serializer.toJson<String>(currencySymbol),
      'decimalPlaces': serializer.toJson<int>(decimalPlaces),
      'timezone': serializer.toJson<String>(timezone),
      'bankName': serializer.toJson<String?>(bankName),
      'bankAccountName': serializer.toJson<String?>(bankAccountName),
      'bankAccountNumber': serializer.toJson<String?>(bankAccountNumber),
      'bankIfsc': serializer.toJson<String?>(bankIfsc),
      'bankBranch': serializer.toJson<String?>(bankBranch),
      'upiId': serializer.toJson<String?>(upiId),
      'invoiceFooter': serializer.toJson<String?>(invoiceFooter),
      'invoiceTerms': serializer.toJson<String?>(invoiceTerms),
      'invoiceThankYouMessage': serializer.toJson<String?>(
        invoiceThankYouMessage,
      ),
      'showLogoOnInvoice': serializer.toJson<bool>(showLogoOnInvoice),
      'showBankDetailsOnInvoice': serializer.toJson<bool>(
        showBankDetailsOnInvoice,
      ),
      'showGstDetailsOnInvoice': serializer.toJson<bool>(
        showGstDetailsOnInvoice,
      ),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  CompanySettings copyWith({
    int? id,
    String? companyName,
    Value<String?> legalName = const Value.absent(),
    String? businessType,
    bool? gstRegistered,
    Value<String?> gstNumber = const Value.absent(),
    Value<String?> panNumber = const Value.absent(),
    Value<String?> cin = const Value.absent(),
    Value<String?> mobile = const Value.absent(),
    Value<String?> email = const Value.absent(),
    Value<String?> website = const Value.absent(),
    Value<String?> addressLine1 = const Value.absent(),
    Value<String?> addressLine2 = const Value.absent(),
    Value<String?> city = const Value.absent(),
    Value<String?> state = const Value.absent(),
    Value<String?> stateCode = const Value.absent(),
    Value<String?> country = const Value.absent(),
    Value<String?> pincode = const Value.absent(),
    Value<String?> logoPath = const Value.absent(),
    bool? pricesInclusiveOfTax,
    String? invoicePrefix,
    int? invoiceStartNumber,
    String? purchasePrefix,
    String? receiptPrefix,
    int? financialYearStartMonth,
    String? currencyCode,
    String? currencySymbol,
    int? decimalPlaces,
    String? timezone,
    Value<String?> bankName = const Value.absent(),
    Value<String?> bankAccountName = const Value.absent(),
    Value<String?> bankAccountNumber = const Value.absent(),
    Value<String?> bankIfsc = const Value.absent(),
    Value<String?> bankBranch = const Value.absent(),
    Value<String?> upiId = const Value.absent(),
    Value<String?> invoiceFooter = const Value.absent(),
    Value<String?> invoiceTerms = const Value.absent(),
    Value<String?> invoiceThankYouMessage = const Value.absent(),
    bool? showLogoOnInvoice,
    bool? showBankDetailsOnInvoice,
    bool? showGstDetailsOnInvoice,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => CompanySettings(
    id: id ?? this.id,
    companyName: companyName ?? this.companyName,
    legalName: legalName.present ? legalName.value : this.legalName,
    businessType: businessType ?? this.businessType,
    gstRegistered: gstRegistered ?? this.gstRegistered,
    gstNumber: gstNumber.present ? gstNumber.value : this.gstNumber,
    panNumber: panNumber.present ? panNumber.value : this.panNumber,
    cin: cin.present ? cin.value : this.cin,
    mobile: mobile.present ? mobile.value : this.mobile,
    email: email.present ? email.value : this.email,
    website: website.present ? website.value : this.website,
    addressLine1: addressLine1.present ? addressLine1.value : this.addressLine1,
    addressLine2: addressLine2.present ? addressLine2.value : this.addressLine2,
    city: city.present ? city.value : this.city,
    state: state.present ? state.value : this.state,
    stateCode: stateCode.present ? stateCode.value : this.stateCode,
    country: country.present ? country.value : this.country,
    pincode: pincode.present ? pincode.value : this.pincode,
    logoPath: logoPath.present ? logoPath.value : this.logoPath,
    pricesInclusiveOfTax: pricesInclusiveOfTax ?? this.pricesInclusiveOfTax,
    invoicePrefix: invoicePrefix ?? this.invoicePrefix,
    invoiceStartNumber: invoiceStartNumber ?? this.invoiceStartNumber,
    purchasePrefix: purchasePrefix ?? this.purchasePrefix,
    receiptPrefix: receiptPrefix ?? this.receiptPrefix,
    financialYearStartMonth:
        financialYearStartMonth ?? this.financialYearStartMonth,
    currencyCode: currencyCode ?? this.currencyCode,
    currencySymbol: currencySymbol ?? this.currencySymbol,
    decimalPlaces: decimalPlaces ?? this.decimalPlaces,
    timezone: timezone ?? this.timezone,
    bankName: bankName.present ? bankName.value : this.bankName,
    bankAccountName: bankAccountName.present
        ? bankAccountName.value
        : this.bankAccountName,
    bankAccountNumber: bankAccountNumber.present
        ? bankAccountNumber.value
        : this.bankAccountNumber,
    bankIfsc: bankIfsc.present ? bankIfsc.value : this.bankIfsc,
    bankBranch: bankBranch.present ? bankBranch.value : this.bankBranch,
    upiId: upiId.present ? upiId.value : this.upiId,
    invoiceFooter: invoiceFooter.present
        ? invoiceFooter.value
        : this.invoiceFooter,
    invoiceTerms: invoiceTerms.present ? invoiceTerms.value : this.invoiceTerms,
    invoiceThankYouMessage: invoiceThankYouMessage.present
        ? invoiceThankYouMessage.value
        : this.invoiceThankYouMessage,
    showLogoOnInvoice: showLogoOnInvoice ?? this.showLogoOnInvoice,
    showBankDetailsOnInvoice:
        showBankDetailsOnInvoice ?? this.showBankDetailsOnInvoice,
    showGstDetailsOnInvoice:
        showGstDetailsOnInvoice ?? this.showGstDetailsOnInvoice,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  CompanySettings copyWithCompanion(CompanySettingsTableCompanion data) {
    return CompanySettings(
      id: data.id.present ? data.id.value : this.id,
      companyName: data.companyName.present
          ? data.companyName.value
          : this.companyName,
      legalName: data.legalName.present ? data.legalName.value : this.legalName,
      businessType: data.businessType.present
          ? data.businessType.value
          : this.businessType,
      gstRegistered: data.gstRegistered.present
          ? data.gstRegistered.value
          : this.gstRegistered,
      gstNumber: data.gstNumber.present ? data.gstNumber.value : this.gstNumber,
      panNumber: data.panNumber.present ? data.panNumber.value : this.panNumber,
      cin: data.cin.present ? data.cin.value : this.cin,
      mobile: data.mobile.present ? data.mobile.value : this.mobile,
      email: data.email.present ? data.email.value : this.email,
      website: data.website.present ? data.website.value : this.website,
      addressLine1: data.addressLine1.present
          ? data.addressLine1.value
          : this.addressLine1,
      addressLine2: data.addressLine2.present
          ? data.addressLine2.value
          : this.addressLine2,
      city: data.city.present ? data.city.value : this.city,
      state: data.state.present ? data.state.value : this.state,
      stateCode: data.stateCode.present ? data.stateCode.value : this.stateCode,
      country: data.country.present ? data.country.value : this.country,
      pincode: data.pincode.present ? data.pincode.value : this.pincode,
      logoPath: data.logoPath.present ? data.logoPath.value : this.logoPath,
      pricesInclusiveOfTax: data.pricesInclusiveOfTax.present
          ? data.pricesInclusiveOfTax.value
          : this.pricesInclusiveOfTax,
      invoicePrefix: data.invoicePrefix.present
          ? data.invoicePrefix.value
          : this.invoicePrefix,
      invoiceStartNumber: data.invoiceStartNumber.present
          ? data.invoiceStartNumber.value
          : this.invoiceStartNumber,
      purchasePrefix: data.purchasePrefix.present
          ? data.purchasePrefix.value
          : this.purchasePrefix,
      receiptPrefix: data.receiptPrefix.present
          ? data.receiptPrefix.value
          : this.receiptPrefix,
      financialYearStartMonth: data.financialYearStartMonth.present
          ? data.financialYearStartMonth.value
          : this.financialYearStartMonth,
      currencyCode: data.currencyCode.present
          ? data.currencyCode.value
          : this.currencyCode,
      currencySymbol: data.currencySymbol.present
          ? data.currencySymbol.value
          : this.currencySymbol,
      decimalPlaces: data.decimalPlaces.present
          ? data.decimalPlaces.value
          : this.decimalPlaces,
      timezone: data.timezone.present ? data.timezone.value : this.timezone,
      bankName: data.bankName.present ? data.bankName.value : this.bankName,
      bankAccountName: data.bankAccountName.present
          ? data.bankAccountName.value
          : this.bankAccountName,
      bankAccountNumber: data.bankAccountNumber.present
          ? data.bankAccountNumber.value
          : this.bankAccountNumber,
      bankIfsc: data.bankIfsc.present ? data.bankIfsc.value : this.bankIfsc,
      bankBranch: data.bankBranch.present
          ? data.bankBranch.value
          : this.bankBranch,
      upiId: data.upiId.present ? data.upiId.value : this.upiId,
      invoiceFooter: data.invoiceFooter.present
          ? data.invoiceFooter.value
          : this.invoiceFooter,
      invoiceTerms: data.invoiceTerms.present
          ? data.invoiceTerms.value
          : this.invoiceTerms,
      invoiceThankYouMessage: data.invoiceThankYouMessage.present
          ? data.invoiceThankYouMessage.value
          : this.invoiceThankYouMessage,
      showLogoOnInvoice: data.showLogoOnInvoice.present
          ? data.showLogoOnInvoice.value
          : this.showLogoOnInvoice,
      showBankDetailsOnInvoice: data.showBankDetailsOnInvoice.present
          ? data.showBankDetailsOnInvoice.value
          : this.showBankDetailsOnInvoice,
      showGstDetailsOnInvoice: data.showGstDetailsOnInvoice.present
          ? data.showGstDetailsOnInvoice.value
          : this.showGstDetailsOnInvoice,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CompanySettings(')
          ..write('id: $id, ')
          ..write('companyName: $companyName, ')
          ..write('legalName: $legalName, ')
          ..write('businessType: $businessType, ')
          ..write('gstRegistered: $gstRegistered, ')
          ..write('gstNumber: $gstNumber, ')
          ..write('panNumber: $panNumber, ')
          ..write('cin: $cin, ')
          ..write('mobile: $mobile, ')
          ..write('email: $email, ')
          ..write('website: $website, ')
          ..write('addressLine1: $addressLine1, ')
          ..write('addressLine2: $addressLine2, ')
          ..write('city: $city, ')
          ..write('state: $state, ')
          ..write('stateCode: $stateCode, ')
          ..write('country: $country, ')
          ..write('pincode: $pincode, ')
          ..write('logoPath: $logoPath, ')
          ..write('pricesInclusiveOfTax: $pricesInclusiveOfTax, ')
          ..write('invoicePrefix: $invoicePrefix, ')
          ..write('invoiceStartNumber: $invoiceStartNumber, ')
          ..write('purchasePrefix: $purchasePrefix, ')
          ..write('receiptPrefix: $receiptPrefix, ')
          ..write('financialYearStartMonth: $financialYearStartMonth, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('currencySymbol: $currencySymbol, ')
          ..write('decimalPlaces: $decimalPlaces, ')
          ..write('timezone: $timezone, ')
          ..write('bankName: $bankName, ')
          ..write('bankAccountName: $bankAccountName, ')
          ..write('bankAccountNumber: $bankAccountNumber, ')
          ..write('bankIfsc: $bankIfsc, ')
          ..write('bankBranch: $bankBranch, ')
          ..write('upiId: $upiId, ')
          ..write('invoiceFooter: $invoiceFooter, ')
          ..write('invoiceTerms: $invoiceTerms, ')
          ..write('invoiceThankYouMessage: $invoiceThankYouMessage, ')
          ..write('showLogoOnInvoice: $showLogoOnInvoice, ')
          ..write('showBankDetailsOnInvoice: $showBankDetailsOnInvoice, ')
          ..write('showGstDetailsOnInvoice: $showGstDetailsOnInvoice, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    companyName,
    legalName,
    businessType,
    gstRegistered,
    gstNumber,
    panNumber,
    cin,
    mobile,
    email,
    website,
    addressLine1,
    addressLine2,
    city,
    state,
    stateCode,
    country,
    pincode,
    logoPath,
    pricesInclusiveOfTax,
    invoicePrefix,
    invoiceStartNumber,
    purchasePrefix,
    receiptPrefix,
    financialYearStartMonth,
    currencyCode,
    currencySymbol,
    decimalPlaces,
    timezone,
    bankName,
    bankAccountName,
    bankAccountNumber,
    bankIfsc,
    bankBranch,
    upiId,
    invoiceFooter,
    invoiceTerms,
    invoiceThankYouMessage,
    showLogoOnInvoice,
    showBankDetailsOnInvoice,
    showGstDetailsOnInvoice,
    isActive,
    createdAt,
    updatedAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CompanySettings &&
          other.id == this.id &&
          other.companyName == this.companyName &&
          other.legalName == this.legalName &&
          other.businessType == this.businessType &&
          other.gstRegistered == this.gstRegistered &&
          other.gstNumber == this.gstNumber &&
          other.panNumber == this.panNumber &&
          other.cin == this.cin &&
          other.mobile == this.mobile &&
          other.email == this.email &&
          other.website == this.website &&
          other.addressLine1 == this.addressLine1 &&
          other.addressLine2 == this.addressLine2 &&
          other.city == this.city &&
          other.state == this.state &&
          other.stateCode == this.stateCode &&
          other.country == this.country &&
          other.pincode == this.pincode &&
          other.logoPath == this.logoPath &&
          other.pricesInclusiveOfTax == this.pricesInclusiveOfTax &&
          other.invoicePrefix == this.invoicePrefix &&
          other.invoiceStartNumber == this.invoiceStartNumber &&
          other.purchasePrefix == this.purchasePrefix &&
          other.receiptPrefix == this.receiptPrefix &&
          other.financialYearStartMonth == this.financialYearStartMonth &&
          other.currencyCode == this.currencyCode &&
          other.currencySymbol == this.currencySymbol &&
          other.decimalPlaces == this.decimalPlaces &&
          other.timezone == this.timezone &&
          other.bankName == this.bankName &&
          other.bankAccountName == this.bankAccountName &&
          other.bankAccountNumber == this.bankAccountNumber &&
          other.bankIfsc == this.bankIfsc &&
          other.bankBranch == this.bankBranch &&
          other.upiId == this.upiId &&
          other.invoiceFooter == this.invoiceFooter &&
          other.invoiceTerms == this.invoiceTerms &&
          other.invoiceThankYouMessage == this.invoiceThankYouMessage &&
          other.showLogoOnInvoice == this.showLogoOnInvoice &&
          other.showBankDetailsOnInvoice == this.showBankDetailsOnInvoice &&
          other.showGstDetailsOnInvoice == this.showGstDetailsOnInvoice &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class CompanySettingsTableCompanion extends UpdateCompanion<CompanySettings> {
  final Value<int> id;
  final Value<String> companyName;
  final Value<String?> legalName;
  final Value<String> businessType;
  final Value<bool> gstRegistered;
  final Value<String?> gstNumber;
  final Value<String?> panNumber;
  final Value<String?> cin;
  final Value<String?> mobile;
  final Value<String?> email;
  final Value<String?> website;
  final Value<String?> addressLine1;
  final Value<String?> addressLine2;
  final Value<String?> city;
  final Value<String?> state;
  final Value<String?> stateCode;
  final Value<String?> country;
  final Value<String?> pincode;
  final Value<String?> logoPath;
  final Value<bool> pricesInclusiveOfTax;
  final Value<String> invoicePrefix;
  final Value<int> invoiceStartNumber;
  final Value<String> purchasePrefix;
  final Value<String> receiptPrefix;
  final Value<int> financialYearStartMonth;
  final Value<String> currencyCode;
  final Value<String> currencySymbol;
  final Value<int> decimalPlaces;
  final Value<String> timezone;
  final Value<String?> bankName;
  final Value<String?> bankAccountName;
  final Value<String?> bankAccountNumber;
  final Value<String?> bankIfsc;
  final Value<String?> bankBranch;
  final Value<String?> upiId;
  final Value<String?> invoiceFooter;
  final Value<String?> invoiceTerms;
  final Value<String?> invoiceThankYouMessage;
  final Value<bool> showLogoOnInvoice;
  final Value<bool> showBankDetailsOnInvoice;
  final Value<bool> showGstDetailsOnInvoice;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const CompanySettingsTableCompanion({
    this.id = const Value.absent(),
    this.companyName = const Value.absent(),
    this.legalName = const Value.absent(),
    this.businessType = const Value.absent(),
    this.gstRegistered = const Value.absent(),
    this.gstNumber = const Value.absent(),
    this.panNumber = const Value.absent(),
    this.cin = const Value.absent(),
    this.mobile = const Value.absent(),
    this.email = const Value.absent(),
    this.website = const Value.absent(),
    this.addressLine1 = const Value.absent(),
    this.addressLine2 = const Value.absent(),
    this.city = const Value.absent(),
    this.state = const Value.absent(),
    this.stateCode = const Value.absent(),
    this.country = const Value.absent(),
    this.pincode = const Value.absent(),
    this.logoPath = const Value.absent(),
    this.pricesInclusiveOfTax = const Value.absent(),
    this.invoicePrefix = const Value.absent(),
    this.invoiceStartNumber = const Value.absent(),
    this.purchasePrefix = const Value.absent(),
    this.receiptPrefix = const Value.absent(),
    this.financialYearStartMonth = const Value.absent(),
    this.currencyCode = const Value.absent(),
    this.currencySymbol = const Value.absent(),
    this.decimalPlaces = const Value.absent(),
    this.timezone = const Value.absent(),
    this.bankName = const Value.absent(),
    this.bankAccountName = const Value.absent(),
    this.bankAccountNumber = const Value.absent(),
    this.bankIfsc = const Value.absent(),
    this.bankBranch = const Value.absent(),
    this.upiId = const Value.absent(),
    this.invoiceFooter = const Value.absent(),
    this.invoiceTerms = const Value.absent(),
    this.invoiceThankYouMessage = const Value.absent(),
    this.showLogoOnInvoice = const Value.absent(),
    this.showBankDetailsOnInvoice = const Value.absent(),
    this.showGstDetailsOnInvoice = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  CompanySettingsTableCompanion.insert({
    this.id = const Value.absent(),
    required String companyName,
    this.legalName = const Value.absent(),
    this.businessType = const Value.absent(),
    this.gstRegistered = const Value.absent(),
    this.gstNumber = const Value.absent(),
    this.panNumber = const Value.absent(),
    this.cin = const Value.absent(),
    this.mobile = const Value.absent(),
    this.email = const Value.absent(),
    this.website = const Value.absent(),
    this.addressLine1 = const Value.absent(),
    this.addressLine2 = const Value.absent(),
    this.city = const Value.absent(),
    this.state = const Value.absent(),
    this.stateCode = const Value.absent(),
    this.country = const Value.absent(),
    this.pincode = const Value.absent(),
    this.logoPath = const Value.absent(),
    this.pricesInclusiveOfTax = const Value.absent(),
    this.invoicePrefix = const Value.absent(),
    this.invoiceStartNumber = const Value.absent(),
    this.purchasePrefix = const Value.absent(),
    this.receiptPrefix = const Value.absent(),
    this.financialYearStartMonth = const Value.absent(),
    this.currencyCode = const Value.absent(),
    this.currencySymbol = const Value.absent(),
    this.decimalPlaces = const Value.absent(),
    this.timezone = const Value.absent(),
    this.bankName = const Value.absent(),
    this.bankAccountName = const Value.absent(),
    this.bankAccountNumber = const Value.absent(),
    this.bankIfsc = const Value.absent(),
    this.bankBranch = const Value.absent(),
    this.upiId = const Value.absent(),
    this.invoiceFooter = const Value.absent(),
    this.invoiceTerms = const Value.absent(),
    this.invoiceThankYouMessage = const Value.absent(),
    this.showLogoOnInvoice = const Value.absent(),
    this.showBankDetailsOnInvoice = const Value.absent(),
    this.showGstDetailsOnInvoice = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : companyName = Value(companyName);
  static Insertable<CompanySettings> custom({
    Expression<int>? id,
    Expression<String>? companyName,
    Expression<String>? legalName,
    Expression<String>? businessType,
    Expression<bool>? gstRegistered,
    Expression<String>? gstNumber,
    Expression<String>? panNumber,
    Expression<String>? cin,
    Expression<String>? mobile,
    Expression<String>? email,
    Expression<String>? website,
    Expression<String>? addressLine1,
    Expression<String>? addressLine2,
    Expression<String>? city,
    Expression<String>? state,
    Expression<String>? stateCode,
    Expression<String>? country,
    Expression<String>? pincode,
    Expression<String>? logoPath,
    Expression<bool>? pricesInclusiveOfTax,
    Expression<String>? invoicePrefix,
    Expression<int>? invoiceStartNumber,
    Expression<String>? purchasePrefix,
    Expression<String>? receiptPrefix,
    Expression<int>? financialYearStartMonth,
    Expression<String>? currencyCode,
    Expression<String>? currencySymbol,
    Expression<int>? decimalPlaces,
    Expression<String>? timezone,
    Expression<String>? bankName,
    Expression<String>? bankAccountName,
    Expression<String>? bankAccountNumber,
    Expression<String>? bankIfsc,
    Expression<String>? bankBranch,
    Expression<String>? upiId,
    Expression<String>? invoiceFooter,
    Expression<String>? invoiceTerms,
    Expression<String>? invoiceThankYouMessage,
    Expression<bool>? showLogoOnInvoice,
    Expression<bool>? showBankDetailsOnInvoice,
    Expression<bool>? showGstDetailsOnInvoice,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (companyName != null) 'company_name': companyName,
      if (legalName != null) 'legal_name': legalName,
      if (businessType != null) 'business_type': businessType,
      if (gstRegistered != null) 'gst_registered': gstRegistered,
      if (gstNumber != null) 'gst_number': gstNumber,
      if (panNumber != null) 'pan_number': panNumber,
      if (cin != null) 'cin': cin,
      if (mobile != null) 'mobile': mobile,
      if (email != null) 'email': email,
      if (website != null) 'website': website,
      if (addressLine1 != null) 'address_line1': addressLine1,
      if (addressLine2 != null) 'address_line2': addressLine2,
      if (city != null) 'city': city,
      if (state != null) 'state': state,
      if (stateCode != null) 'state_code': stateCode,
      if (country != null) 'country': country,
      if (pincode != null) 'pincode': pincode,
      if (logoPath != null) 'logo_path': logoPath,
      if (pricesInclusiveOfTax != null)
        'prices_inclusive_of_tax': pricesInclusiveOfTax,
      if (invoicePrefix != null) 'invoice_prefix': invoicePrefix,
      if (invoiceStartNumber != null)
        'invoice_start_number': invoiceStartNumber,
      if (purchasePrefix != null) 'purchase_prefix': purchasePrefix,
      if (receiptPrefix != null) 'receipt_prefix': receiptPrefix,
      if (financialYearStartMonth != null)
        'financial_year_start_month': financialYearStartMonth,
      if (currencyCode != null) 'currency_code': currencyCode,
      if (currencySymbol != null) 'currency_symbol': currencySymbol,
      if (decimalPlaces != null) 'decimal_places': decimalPlaces,
      if (timezone != null) 'timezone': timezone,
      if (bankName != null) 'bank_name': bankName,
      if (bankAccountName != null) 'bank_account_name': bankAccountName,
      if (bankAccountNumber != null) 'bank_account_number': bankAccountNumber,
      if (bankIfsc != null) 'bank_ifsc': bankIfsc,
      if (bankBranch != null) 'bank_branch': bankBranch,
      if (upiId != null) 'upi_id': upiId,
      if (invoiceFooter != null) 'invoice_footer': invoiceFooter,
      if (invoiceTerms != null) 'invoice_terms': invoiceTerms,
      if (invoiceThankYouMessage != null)
        'invoice_thank_you_message': invoiceThankYouMessage,
      if (showLogoOnInvoice != null) 'show_logo_on_invoice': showLogoOnInvoice,
      if (showBankDetailsOnInvoice != null)
        'show_bank_details_on_invoice': showBankDetailsOnInvoice,
      if (showGstDetailsOnInvoice != null)
        'show_gst_details_on_invoice': showGstDetailsOnInvoice,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  CompanySettingsTableCompanion copyWith({
    Value<int>? id,
    Value<String>? companyName,
    Value<String?>? legalName,
    Value<String>? businessType,
    Value<bool>? gstRegistered,
    Value<String?>? gstNumber,
    Value<String?>? panNumber,
    Value<String?>? cin,
    Value<String?>? mobile,
    Value<String?>? email,
    Value<String?>? website,
    Value<String?>? addressLine1,
    Value<String?>? addressLine2,
    Value<String?>? city,
    Value<String?>? state,
    Value<String?>? stateCode,
    Value<String?>? country,
    Value<String?>? pincode,
    Value<String?>? logoPath,
    Value<bool>? pricesInclusiveOfTax,
    Value<String>? invoicePrefix,
    Value<int>? invoiceStartNumber,
    Value<String>? purchasePrefix,
    Value<String>? receiptPrefix,
    Value<int>? financialYearStartMonth,
    Value<String>? currencyCode,
    Value<String>? currencySymbol,
    Value<int>? decimalPlaces,
    Value<String>? timezone,
    Value<String?>? bankName,
    Value<String?>? bankAccountName,
    Value<String?>? bankAccountNumber,
    Value<String?>? bankIfsc,
    Value<String?>? bankBranch,
    Value<String?>? upiId,
    Value<String?>? invoiceFooter,
    Value<String?>? invoiceTerms,
    Value<String?>? invoiceThankYouMessage,
    Value<bool>? showLogoOnInvoice,
    Value<bool>? showBankDetailsOnInvoice,
    Value<bool>? showGstDetailsOnInvoice,
    Value<bool>? isActive,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return CompanySettingsTableCompanion(
      id: id ?? this.id,
      companyName: companyName ?? this.companyName,
      legalName: legalName ?? this.legalName,
      businessType: businessType ?? this.businessType,
      gstRegistered: gstRegistered ?? this.gstRegistered,
      gstNumber: gstNumber ?? this.gstNumber,
      panNumber: panNumber ?? this.panNumber,
      cin: cin ?? this.cin,
      mobile: mobile ?? this.mobile,
      email: email ?? this.email,
      website: website ?? this.website,
      addressLine1: addressLine1 ?? this.addressLine1,
      addressLine2: addressLine2 ?? this.addressLine2,
      city: city ?? this.city,
      state: state ?? this.state,
      stateCode: stateCode ?? this.stateCode,
      country: country ?? this.country,
      pincode: pincode ?? this.pincode,
      logoPath: logoPath ?? this.logoPath,
      pricesInclusiveOfTax: pricesInclusiveOfTax ?? this.pricesInclusiveOfTax,
      invoicePrefix: invoicePrefix ?? this.invoicePrefix,
      invoiceStartNumber: invoiceStartNumber ?? this.invoiceStartNumber,
      purchasePrefix: purchasePrefix ?? this.purchasePrefix,
      receiptPrefix: receiptPrefix ?? this.receiptPrefix,
      financialYearStartMonth:
          financialYearStartMonth ?? this.financialYearStartMonth,
      currencyCode: currencyCode ?? this.currencyCode,
      currencySymbol: currencySymbol ?? this.currencySymbol,
      decimalPlaces: decimalPlaces ?? this.decimalPlaces,
      timezone: timezone ?? this.timezone,
      bankName: bankName ?? this.bankName,
      bankAccountName: bankAccountName ?? this.bankAccountName,
      bankAccountNumber: bankAccountNumber ?? this.bankAccountNumber,
      bankIfsc: bankIfsc ?? this.bankIfsc,
      bankBranch: bankBranch ?? this.bankBranch,
      upiId: upiId ?? this.upiId,
      invoiceFooter: invoiceFooter ?? this.invoiceFooter,
      invoiceTerms: invoiceTerms ?? this.invoiceTerms,
      invoiceThankYouMessage:
          invoiceThankYouMessage ?? this.invoiceThankYouMessage,
      showLogoOnInvoice: showLogoOnInvoice ?? this.showLogoOnInvoice,
      showBankDetailsOnInvoice:
          showBankDetailsOnInvoice ?? this.showBankDetailsOnInvoice,
      showGstDetailsOnInvoice:
          showGstDetailsOnInvoice ?? this.showGstDetailsOnInvoice,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (companyName.present) {
      map['company_name'] = Variable<String>(companyName.value);
    }
    if (legalName.present) {
      map['legal_name'] = Variable<String>(legalName.value);
    }
    if (businessType.present) {
      map['business_type'] = Variable<String>(businessType.value);
    }
    if (gstRegistered.present) {
      map['gst_registered'] = Variable<bool>(gstRegistered.value);
    }
    if (gstNumber.present) {
      map['gst_number'] = Variable<String>(gstNumber.value);
    }
    if (panNumber.present) {
      map['pan_number'] = Variable<String>(panNumber.value);
    }
    if (cin.present) {
      map['cin'] = Variable<String>(cin.value);
    }
    if (mobile.present) {
      map['mobile'] = Variable<String>(mobile.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (website.present) {
      map['website'] = Variable<String>(website.value);
    }
    if (addressLine1.present) {
      map['address_line1'] = Variable<String>(addressLine1.value);
    }
    if (addressLine2.present) {
      map['address_line2'] = Variable<String>(addressLine2.value);
    }
    if (city.present) {
      map['city'] = Variable<String>(city.value);
    }
    if (state.present) {
      map['state'] = Variable<String>(state.value);
    }
    if (stateCode.present) {
      map['state_code'] = Variable<String>(stateCode.value);
    }
    if (country.present) {
      map['country'] = Variable<String>(country.value);
    }
    if (pincode.present) {
      map['pincode'] = Variable<String>(pincode.value);
    }
    if (logoPath.present) {
      map['logo_path'] = Variable<String>(logoPath.value);
    }
    if (pricesInclusiveOfTax.present) {
      map['prices_inclusive_of_tax'] = Variable<bool>(
        pricesInclusiveOfTax.value,
      );
    }
    if (invoicePrefix.present) {
      map['invoice_prefix'] = Variable<String>(invoicePrefix.value);
    }
    if (invoiceStartNumber.present) {
      map['invoice_start_number'] = Variable<int>(invoiceStartNumber.value);
    }
    if (purchasePrefix.present) {
      map['purchase_prefix'] = Variable<String>(purchasePrefix.value);
    }
    if (receiptPrefix.present) {
      map['receipt_prefix'] = Variable<String>(receiptPrefix.value);
    }
    if (financialYearStartMonth.present) {
      map['financial_year_start_month'] = Variable<int>(
        financialYearStartMonth.value,
      );
    }
    if (currencyCode.present) {
      map['currency_code'] = Variable<String>(currencyCode.value);
    }
    if (currencySymbol.present) {
      map['currency_symbol'] = Variable<String>(currencySymbol.value);
    }
    if (decimalPlaces.present) {
      map['decimal_places'] = Variable<int>(decimalPlaces.value);
    }
    if (timezone.present) {
      map['timezone'] = Variable<String>(timezone.value);
    }
    if (bankName.present) {
      map['bank_name'] = Variable<String>(bankName.value);
    }
    if (bankAccountName.present) {
      map['bank_account_name'] = Variable<String>(bankAccountName.value);
    }
    if (bankAccountNumber.present) {
      map['bank_account_number'] = Variable<String>(bankAccountNumber.value);
    }
    if (bankIfsc.present) {
      map['bank_ifsc'] = Variable<String>(bankIfsc.value);
    }
    if (bankBranch.present) {
      map['bank_branch'] = Variable<String>(bankBranch.value);
    }
    if (upiId.present) {
      map['upi_id'] = Variable<String>(upiId.value);
    }
    if (invoiceFooter.present) {
      map['invoice_footer'] = Variable<String>(invoiceFooter.value);
    }
    if (invoiceTerms.present) {
      map['invoice_terms'] = Variable<String>(invoiceTerms.value);
    }
    if (invoiceThankYouMessage.present) {
      map['invoice_thank_you_message'] = Variable<String>(
        invoiceThankYouMessage.value,
      );
    }
    if (showLogoOnInvoice.present) {
      map['show_logo_on_invoice'] = Variable<bool>(showLogoOnInvoice.value);
    }
    if (showBankDetailsOnInvoice.present) {
      map['show_bank_details_on_invoice'] = Variable<bool>(
        showBankDetailsOnInvoice.value,
      );
    }
    if (showGstDetailsOnInvoice.present) {
      map['show_gst_details_on_invoice'] = Variable<bool>(
        showGstDetailsOnInvoice.value,
      );
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CompanySettingsTableCompanion(')
          ..write('id: $id, ')
          ..write('companyName: $companyName, ')
          ..write('legalName: $legalName, ')
          ..write('businessType: $businessType, ')
          ..write('gstRegistered: $gstRegistered, ')
          ..write('gstNumber: $gstNumber, ')
          ..write('panNumber: $panNumber, ')
          ..write('cin: $cin, ')
          ..write('mobile: $mobile, ')
          ..write('email: $email, ')
          ..write('website: $website, ')
          ..write('addressLine1: $addressLine1, ')
          ..write('addressLine2: $addressLine2, ')
          ..write('city: $city, ')
          ..write('state: $state, ')
          ..write('stateCode: $stateCode, ')
          ..write('country: $country, ')
          ..write('pincode: $pincode, ')
          ..write('logoPath: $logoPath, ')
          ..write('pricesInclusiveOfTax: $pricesInclusiveOfTax, ')
          ..write('invoicePrefix: $invoicePrefix, ')
          ..write('invoiceStartNumber: $invoiceStartNumber, ')
          ..write('purchasePrefix: $purchasePrefix, ')
          ..write('receiptPrefix: $receiptPrefix, ')
          ..write('financialYearStartMonth: $financialYearStartMonth, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('currencySymbol: $currencySymbol, ')
          ..write('decimalPlaces: $decimalPlaces, ')
          ..write('timezone: $timezone, ')
          ..write('bankName: $bankName, ')
          ..write('bankAccountName: $bankAccountName, ')
          ..write('bankAccountNumber: $bankAccountNumber, ')
          ..write('bankIfsc: $bankIfsc, ')
          ..write('bankBranch: $bankBranch, ')
          ..write('upiId: $upiId, ')
          ..write('invoiceFooter: $invoiceFooter, ')
          ..write('invoiceTerms: $invoiceTerms, ')
          ..write('invoiceThankYouMessage: $invoiceThankYouMessage, ')
          ..write('showLogoOnInvoice: $showLogoOnInvoice, ')
          ..write('showBankDetailsOnInvoice: $showBankDetailsOnInvoice, ')
          ..write('showGstDetailsOnInvoice: $showGstDetailsOnInvoice, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $CategoriesTable extends Categories
    with TableInfo<$CategoriesTable, Category> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _categoryCodeMeta = const VerificationMeta(
    'categoryCode',
  );
  @override
  late final GeneratedColumn<String> categoryCode = GeneratedColumn<String>(
    'category_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _categoryNameMeta = const VerificationMeta(
    'categoryName',
  );
  @override
  late final GeneratedColumn<String> categoryName = GeneratedColumn<String>(
    'category_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    categoryCode,
    categoryName,
    description,
    isActive,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'category';
  @override
  VerificationContext validateIntegrity(
    Insertable<Category> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('category_code')) {
      context.handle(
        _categoryCodeMeta,
        categoryCode.isAcceptableOrUnknown(
          data['category_code']!,
          _categoryCodeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_categoryCodeMeta);
    }
    if (data.containsKey('category_name')) {
      context.handle(
        _categoryNameMeta,
        categoryName.isAcceptableOrUnknown(
          data['category_name']!,
          _categoryNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_categoryNameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Category map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Category(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      categoryCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_code'],
      )!,
      categoryName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $CategoriesTable createAlias(String alias) {
    return $CategoriesTable(attachedDatabase, alias);
  }
}

class Category extends DataClass implements Insertable<Category> {
  final int id;
  final String categoryCode;
  final String categoryName;
  final String? description;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Category({
    required this.id,
    required this.categoryCode,
    required this.categoryName,
    this.description,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['category_code'] = Variable<String>(categoryCode);
    map['category_name'] = Variable<String>(categoryName);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  CategoriesCompanion toCompanion(bool nullToAbsent) {
    return CategoriesCompanion(
      id: Value(id),
      categoryCode: Value(categoryCode),
      categoryName: Value(categoryName),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Category.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Category(
      id: serializer.fromJson<int>(json['id']),
      categoryCode: serializer.fromJson<String>(json['categoryCode']),
      categoryName: serializer.fromJson<String>(json['categoryName']),
      description: serializer.fromJson<String?>(json['description']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'categoryCode': serializer.toJson<String>(categoryCode),
      'categoryName': serializer.toJson<String>(categoryName),
      'description': serializer.toJson<String?>(description),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Category copyWith({
    int? id,
    String? categoryCode,
    String? categoryName,
    Value<String?> description = const Value.absent(),
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Category(
    id: id ?? this.id,
    categoryCode: categoryCode ?? this.categoryCode,
    categoryName: categoryName ?? this.categoryName,
    description: description.present ? description.value : this.description,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Category copyWithCompanion(CategoriesCompanion data) {
    return Category(
      id: data.id.present ? data.id.value : this.id,
      categoryCode: data.categoryCode.present
          ? data.categoryCode.value
          : this.categoryCode,
      categoryName: data.categoryName.present
          ? data.categoryName.value
          : this.categoryName,
      description: data.description.present
          ? data.description.value
          : this.description,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Category(')
          ..write('id: $id, ')
          ..write('categoryCode: $categoryCode, ')
          ..write('categoryName: $categoryName, ')
          ..write('description: $description, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    categoryCode,
    categoryName,
    description,
    isActive,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Category &&
          other.id == this.id &&
          other.categoryCode == this.categoryCode &&
          other.categoryName == this.categoryName &&
          other.description == this.description &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class CategoriesCompanion extends UpdateCompanion<Category> {
  final Value<int> id;
  final Value<String> categoryCode;
  final Value<String> categoryName;
  final Value<String?> description;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const CategoriesCompanion({
    this.id = const Value.absent(),
    this.categoryCode = const Value.absent(),
    this.categoryName = const Value.absent(),
    this.description = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  CategoriesCompanion.insert({
    this.id = const Value.absent(),
    required String categoryCode,
    required String categoryName,
    this.description = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : categoryCode = Value(categoryCode),
       categoryName = Value(categoryName);
  static Insertable<Category> custom({
    Expression<int>? id,
    Expression<String>? categoryCode,
    Expression<String>? categoryName,
    Expression<String>? description,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (categoryCode != null) 'category_code': categoryCode,
      if (categoryName != null) 'category_name': categoryName,
      if (description != null) 'description': description,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  CategoriesCompanion copyWith({
    Value<int>? id,
    Value<String>? categoryCode,
    Value<String>? categoryName,
    Value<String?>? description,
    Value<bool>? isActive,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return CategoriesCompanion(
      id: id ?? this.id,
      categoryCode: categoryCode ?? this.categoryCode,
      categoryName: categoryName ?? this.categoryName,
      description: description ?? this.description,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (categoryCode.present) {
      map['category_code'] = Variable<String>(categoryCode.value);
    }
    if (categoryName.present) {
      map['category_name'] = Variable<String>(categoryName.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesCompanion(')
          ..write('id: $id, ')
          ..write('categoryCode: $categoryCode, ')
          ..write('categoryName: $categoryName, ')
          ..write('description: $description, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $SubCategoriesTable extends SubCategories
    with TableInfo<$SubCategoriesTable, SubCategory> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SubCategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
    'category_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES category (id)',
    ),
  );
  static const VerificationMeta _subCategoryCodeMeta = const VerificationMeta(
    'subCategoryCode',
  );
  @override
  late final GeneratedColumn<String> subCategoryCode = GeneratedColumn<String>(
    'sub_category_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _subCategoryNameMeta = const VerificationMeta(
    'subCategoryName',
  );
  @override
  late final GeneratedColumn<String> subCategoryName = GeneratedColumn<String>(
    'sub_category_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    categoryId,
    subCategoryCode,
    subCategoryName,
    description,
    isActive,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sub_category';
  @override
  VerificationContext validateIntegrity(
    Insertable<SubCategory> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('sub_category_code')) {
      context.handle(
        _subCategoryCodeMeta,
        subCategoryCode.isAcceptableOrUnknown(
          data['sub_category_code']!,
          _subCategoryCodeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_subCategoryCodeMeta);
    }
    if (data.containsKey('sub_category_name')) {
      context.handle(
        _subCategoryNameMeta,
        subCategoryName.isAcceptableOrUnknown(
          data['sub_category_name']!,
          _subCategoryNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_subCategoryNameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {categoryId, id},
  ];
  @override
  SubCategory map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SubCategory(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}category_id'],
      )!,
      subCategoryCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sub_category_code'],
      )!,
      subCategoryName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sub_category_name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $SubCategoriesTable createAlias(String alias) {
    return $SubCategoriesTable(attachedDatabase, alias);
  }
}

class SubCategory extends DataClass implements Insertable<SubCategory> {
  final int id;
  final int categoryId;
  final String subCategoryCode;
  final String subCategoryName;
  final String? description;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  const SubCategory({
    required this.id,
    required this.categoryId,
    required this.subCategoryCode,
    required this.subCategoryName,
    this.description,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['category_id'] = Variable<int>(categoryId);
    map['sub_category_code'] = Variable<String>(subCategoryCode);
    map['sub_category_name'] = Variable<String>(subCategoryName);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  SubCategoriesCompanion toCompanion(bool nullToAbsent) {
    return SubCategoriesCompanion(
      id: Value(id),
      categoryId: Value(categoryId),
      subCategoryCode: Value(subCategoryCode),
      subCategoryName: Value(subCategoryName),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory SubCategory.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SubCategory(
      id: serializer.fromJson<int>(json['id']),
      categoryId: serializer.fromJson<int>(json['categoryId']),
      subCategoryCode: serializer.fromJson<String>(json['subCategoryCode']),
      subCategoryName: serializer.fromJson<String>(json['subCategoryName']),
      description: serializer.fromJson<String?>(json['description']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'categoryId': serializer.toJson<int>(categoryId),
      'subCategoryCode': serializer.toJson<String>(subCategoryCode),
      'subCategoryName': serializer.toJson<String>(subCategoryName),
      'description': serializer.toJson<String?>(description),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  SubCategory copyWith({
    int? id,
    int? categoryId,
    String? subCategoryCode,
    String? subCategoryName,
    Value<String?> description = const Value.absent(),
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => SubCategory(
    id: id ?? this.id,
    categoryId: categoryId ?? this.categoryId,
    subCategoryCode: subCategoryCode ?? this.subCategoryCode,
    subCategoryName: subCategoryName ?? this.subCategoryName,
    description: description.present ? description.value : this.description,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  SubCategory copyWithCompanion(SubCategoriesCompanion data) {
    return SubCategory(
      id: data.id.present ? data.id.value : this.id,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      subCategoryCode: data.subCategoryCode.present
          ? data.subCategoryCode.value
          : this.subCategoryCode,
      subCategoryName: data.subCategoryName.present
          ? data.subCategoryName.value
          : this.subCategoryName,
      description: data.description.present
          ? data.description.value
          : this.description,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SubCategory(')
          ..write('id: $id, ')
          ..write('categoryId: $categoryId, ')
          ..write('subCategoryCode: $subCategoryCode, ')
          ..write('subCategoryName: $subCategoryName, ')
          ..write('description: $description, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    categoryId,
    subCategoryCode,
    subCategoryName,
    description,
    isActive,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SubCategory &&
          other.id == this.id &&
          other.categoryId == this.categoryId &&
          other.subCategoryCode == this.subCategoryCode &&
          other.subCategoryName == this.subCategoryName &&
          other.description == this.description &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class SubCategoriesCompanion extends UpdateCompanion<SubCategory> {
  final Value<int> id;
  final Value<int> categoryId;
  final Value<String> subCategoryCode;
  final Value<String> subCategoryName;
  final Value<String?> description;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const SubCategoriesCompanion({
    this.id = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.subCategoryCode = const Value.absent(),
    this.subCategoryName = const Value.absent(),
    this.description = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  SubCategoriesCompanion.insert({
    this.id = const Value.absent(),
    required int categoryId,
    required String subCategoryCode,
    required String subCategoryName,
    this.description = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : categoryId = Value(categoryId),
       subCategoryCode = Value(subCategoryCode),
       subCategoryName = Value(subCategoryName);
  static Insertable<SubCategory> custom({
    Expression<int>? id,
    Expression<int>? categoryId,
    Expression<String>? subCategoryCode,
    Expression<String>? subCategoryName,
    Expression<String>? description,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (categoryId != null) 'category_id': categoryId,
      if (subCategoryCode != null) 'sub_category_code': subCategoryCode,
      if (subCategoryName != null) 'sub_category_name': subCategoryName,
      if (description != null) 'description': description,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  SubCategoriesCompanion copyWith({
    Value<int>? id,
    Value<int>? categoryId,
    Value<String>? subCategoryCode,
    Value<String>? subCategoryName,
    Value<String?>? description,
    Value<bool>? isActive,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return SubCategoriesCompanion(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      subCategoryCode: subCategoryCode ?? this.subCategoryCode,
      subCategoryName: subCategoryName ?? this.subCategoryName,
      description: description ?? this.description,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (subCategoryCode.present) {
      map['sub_category_code'] = Variable<String>(subCategoryCode.value);
    }
    if (subCategoryName.present) {
      map['sub_category_name'] = Variable<String>(subCategoryName.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SubCategoriesCompanion(')
          ..write('id: $id, ')
          ..write('categoryId: $categoryId, ')
          ..write('subCategoryCode: $subCategoryCode, ')
          ..write('subCategoryName: $subCategoryName, ')
          ..write('description: $description, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $BrandsTable extends Brands with TableInfo<$BrandsTable, Brand> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BrandsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _brandCodeMeta = const VerificationMeta(
    'brandCode',
  );
  @override
  late final GeneratedColumn<String> brandCode = GeneratedColumn<String>(
    'brand_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _brandNameMeta = const VerificationMeta(
    'brandName',
  );
  @override
  late final GeneratedColumn<String> brandName = GeneratedColumn<String>(
    'brand_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    brandCode,
    brandName,
    description,
    isActive,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'brand';
  @override
  VerificationContext validateIntegrity(
    Insertable<Brand> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('brand_code')) {
      context.handle(
        _brandCodeMeta,
        brandCode.isAcceptableOrUnknown(data['brand_code']!, _brandCodeMeta),
      );
    } else if (isInserting) {
      context.missing(_brandCodeMeta);
    }
    if (data.containsKey('brand_name')) {
      context.handle(
        _brandNameMeta,
        brandName.isAcceptableOrUnknown(data['brand_name']!, _brandNameMeta),
      );
    } else if (isInserting) {
      context.missing(_brandNameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Brand map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Brand(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      brandCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}brand_code'],
      )!,
      brandName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}brand_name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $BrandsTable createAlias(String alias) {
    return $BrandsTable(attachedDatabase, alias);
  }
}

class Brand extends DataClass implements Insertable<Brand> {
  final int id;
  final String brandCode;
  final String brandName;
  final String? description;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Brand({
    required this.id,
    required this.brandCode,
    required this.brandName,
    this.description,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['brand_code'] = Variable<String>(brandCode);
    map['brand_name'] = Variable<String>(brandName);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  BrandsCompanion toCompanion(bool nullToAbsent) {
    return BrandsCompanion(
      id: Value(id),
      brandCode: Value(brandCode),
      brandName: Value(brandName),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Brand.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Brand(
      id: serializer.fromJson<int>(json['id']),
      brandCode: serializer.fromJson<String>(json['brandCode']),
      brandName: serializer.fromJson<String>(json['brandName']),
      description: serializer.fromJson<String?>(json['description']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'brandCode': serializer.toJson<String>(brandCode),
      'brandName': serializer.toJson<String>(brandName),
      'description': serializer.toJson<String?>(description),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Brand copyWith({
    int? id,
    String? brandCode,
    String? brandName,
    Value<String?> description = const Value.absent(),
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Brand(
    id: id ?? this.id,
    brandCode: brandCode ?? this.brandCode,
    brandName: brandName ?? this.brandName,
    description: description.present ? description.value : this.description,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Brand copyWithCompanion(BrandsCompanion data) {
    return Brand(
      id: data.id.present ? data.id.value : this.id,
      brandCode: data.brandCode.present ? data.brandCode.value : this.brandCode,
      brandName: data.brandName.present ? data.brandName.value : this.brandName,
      description: data.description.present
          ? data.description.value
          : this.description,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Brand(')
          ..write('id: $id, ')
          ..write('brandCode: $brandCode, ')
          ..write('brandName: $brandName, ')
          ..write('description: $description, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    brandCode,
    brandName,
    description,
    isActive,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Brand &&
          other.id == this.id &&
          other.brandCode == this.brandCode &&
          other.brandName == this.brandName &&
          other.description == this.description &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class BrandsCompanion extends UpdateCompanion<Brand> {
  final Value<int> id;
  final Value<String> brandCode;
  final Value<String> brandName;
  final Value<String?> description;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const BrandsCompanion({
    this.id = const Value.absent(),
    this.brandCode = const Value.absent(),
    this.brandName = const Value.absent(),
    this.description = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  BrandsCompanion.insert({
    this.id = const Value.absent(),
    required String brandCode,
    required String brandName,
    this.description = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : brandCode = Value(brandCode),
       brandName = Value(brandName);
  static Insertable<Brand> custom({
    Expression<int>? id,
    Expression<String>? brandCode,
    Expression<String>? brandName,
    Expression<String>? description,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (brandCode != null) 'brand_code': brandCode,
      if (brandName != null) 'brand_name': brandName,
      if (description != null) 'description': description,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  BrandsCompanion copyWith({
    Value<int>? id,
    Value<String>? brandCode,
    Value<String>? brandName,
    Value<String?>? description,
    Value<bool>? isActive,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return BrandsCompanion(
      id: id ?? this.id,
      brandCode: brandCode ?? this.brandCode,
      brandName: brandName ?? this.brandName,
      description: description ?? this.description,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (brandCode.present) {
      map['brand_code'] = Variable<String>(brandCode.value);
    }
    if (brandName.present) {
      map['brand_name'] = Variable<String>(brandName.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BrandsCompanion(')
          ..write('id: $id, ')
          ..write('brandCode: $brandCode, ')
          ..write('brandName: $brandName, ')
          ..write('description: $description, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $UnitsTable extends Units with TableInfo<$UnitsTable, Unit> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UnitsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _unitNameMeta = const VerificationMeta(
    'unitName',
  );
  @override
  late final GeneratedColumn<String> unitName = GeneratedColumn<String>(
    'unit_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitSymbolMeta = const VerificationMeta(
    'unitSymbol',
  );
  @override
  late final GeneratedColumn<String> unitSymbol = GeneratedColumn<String>(
    'unit_symbol',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitFamilyMeta = const VerificationMeta(
    'unitFamily',
  );
  @override
  late final GeneratedColumn<String> unitFamily = GeneratedColumn<String>(
    'unit_family',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('GENERAL'),
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    unitName,
    unitSymbol,
    unitFamily,
    description,
    isActive,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'unit';
  @override
  VerificationContext validateIntegrity(
    Insertable<Unit> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('unit_name')) {
      context.handle(
        _unitNameMeta,
        unitName.isAcceptableOrUnknown(data['unit_name']!, _unitNameMeta),
      );
    } else if (isInserting) {
      context.missing(_unitNameMeta);
    }
    if (data.containsKey('unit_symbol')) {
      context.handle(
        _unitSymbolMeta,
        unitSymbol.isAcceptableOrUnknown(data['unit_symbol']!, _unitSymbolMeta),
      );
    } else if (isInserting) {
      context.missing(_unitSymbolMeta);
    }
    if (data.containsKey('unit_family')) {
      context.handle(
        _unitFamilyMeta,
        unitFamily.isAcceptableOrUnknown(data['unit_family']!, _unitFamilyMeta),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Unit map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Unit(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      unitName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit_name'],
      )!,
      unitSymbol: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit_symbol'],
      )!,
      unitFamily: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit_family'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $UnitsTable createAlias(String alias) {
    return $UnitsTable(attachedDatabase, alias);
  }
}

class Unit extends DataClass implements Insertable<Unit> {
  final int id;
  final String unitName;
  final String unitSymbol;
  final String unitFamily;
  final String? description;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Unit({
    required this.id,
    required this.unitName,
    required this.unitSymbol,
    required this.unitFamily,
    this.description,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['unit_name'] = Variable<String>(unitName);
    map['unit_symbol'] = Variable<String>(unitSymbol);
    map['unit_family'] = Variable<String>(unitFamily);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  UnitsCompanion toCompanion(bool nullToAbsent) {
    return UnitsCompanion(
      id: Value(id),
      unitName: Value(unitName),
      unitSymbol: Value(unitSymbol),
      unitFamily: Value(unitFamily),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Unit.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Unit(
      id: serializer.fromJson<int>(json['id']),
      unitName: serializer.fromJson<String>(json['unitName']),
      unitSymbol: serializer.fromJson<String>(json['unitSymbol']),
      unitFamily: serializer.fromJson<String>(json['unitFamily']),
      description: serializer.fromJson<String?>(json['description']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'unitName': serializer.toJson<String>(unitName),
      'unitSymbol': serializer.toJson<String>(unitSymbol),
      'unitFamily': serializer.toJson<String>(unitFamily),
      'description': serializer.toJson<String?>(description),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Unit copyWith({
    int? id,
    String? unitName,
    String? unitSymbol,
    String? unitFamily,
    Value<String?> description = const Value.absent(),
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Unit(
    id: id ?? this.id,
    unitName: unitName ?? this.unitName,
    unitSymbol: unitSymbol ?? this.unitSymbol,
    unitFamily: unitFamily ?? this.unitFamily,
    description: description.present ? description.value : this.description,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Unit copyWithCompanion(UnitsCompanion data) {
    return Unit(
      id: data.id.present ? data.id.value : this.id,
      unitName: data.unitName.present ? data.unitName.value : this.unitName,
      unitSymbol: data.unitSymbol.present
          ? data.unitSymbol.value
          : this.unitSymbol,
      unitFamily: data.unitFamily.present
          ? data.unitFamily.value
          : this.unitFamily,
      description: data.description.present
          ? data.description.value
          : this.description,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Unit(')
          ..write('id: $id, ')
          ..write('unitName: $unitName, ')
          ..write('unitSymbol: $unitSymbol, ')
          ..write('unitFamily: $unitFamily, ')
          ..write('description: $description, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    unitName,
    unitSymbol,
    unitFamily,
    description,
    isActive,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Unit &&
          other.id == this.id &&
          other.unitName == this.unitName &&
          other.unitSymbol == this.unitSymbol &&
          other.unitFamily == this.unitFamily &&
          other.description == this.description &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class UnitsCompanion extends UpdateCompanion<Unit> {
  final Value<int> id;
  final Value<String> unitName;
  final Value<String> unitSymbol;
  final Value<String> unitFamily;
  final Value<String?> description;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const UnitsCompanion({
    this.id = const Value.absent(),
    this.unitName = const Value.absent(),
    this.unitSymbol = const Value.absent(),
    this.unitFamily = const Value.absent(),
    this.description = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  UnitsCompanion.insert({
    this.id = const Value.absent(),
    required String unitName,
    required String unitSymbol,
    this.unitFamily = const Value.absent(),
    this.description = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : unitName = Value(unitName),
       unitSymbol = Value(unitSymbol);
  static Insertable<Unit> custom({
    Expression<int>? id,
    Expression<String>? unitName,
    Expression<String>? unitSymbol,
    Expression<String>? unitFamily,
    Expression<String>? description,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (unitName != null) 'unit_name': unitName,
      if (unitSymbol != null) 'unit_symbol': unitSymbol,
      if (unitFamily != null) 'unit_family': unitFamily,
      if (description != null) 'description': description,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  UnitsCompanion copyWith({
    Value<int>? id,
    Value<String>? unitName,
    Value<String>? unitSymbol,
    Value<String>? unitFamily,
    Value<String?>? description,
    Value<bool>? isActive,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return UnitsCompanion(
      id: id ?? this.id,
      unitName: unitName ?? this.unitName,
      unitSymbol: unitSymbol ?? this.unitSymbol,
      unitFamily: unitFamily ?? this.unitFamily,
      description: description ?? this.description,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (unitName.present) {
      map['unit_name'] = Variable<String>(unitName.value);
    }
    if (unitSymbol.present) {
      map['unit_symbol'] = Variable<String>(unitSymbol.value);
    }
    if (unitFamily.present) {
      map['unit_family'] = Variable<String>(unitFamily.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UnitsCompanion(')
          ..write('id: $id, ')
          ..write('unitName: $unitName, ')
          ..write('unitSymbol: $unitSymbol, ')
          ..write('unitFamily: $unitFamily, ')
          ..write('description: $description, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $UomConversionsTable extends UomConversions
    with TableInfo<$UomConversionsTable, UomConversion> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UomConversionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _fromUnitIdMeta = const VerificationMeta(
    'fromUnitId',
  );
  @override
  late final GeneratedColumn<int> fromUnitId = GeneratedColumn<int>(
    'from_unit_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES unit (id)',
    ),
  );
  static const VerificationMeta _toUnitIdMeta = const VerificationMeta(
    'toUnitId',
  );
  @override
  late final GeneratedColumn<int> toUnitId = GeneratedColumn<int>(
    'to_unit_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES unit (id)',
    ),
  );
  static const VerificationMeta _conversionFactorMeta = const VerificationMeta(
    'conversionFactor',
  );
  @override
  late final GeneratedColumn<double> conversionFactor = GeneratedColumn<double>(
    'conversion_factor',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    fromUnitId,
    toUnitId,
    conversionFactor,
    description,
    isActive,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'uom_conversion';
  @override
  VerificationContext validateIntegrity(
    Insertable<UomConversion> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('from_unit_id')) {
      context.handle(
        _fromUnitIdMeta,
        fromUnitId.isAcceptableOrUnknown(
          data['from_unit_id']!,
          _fromUnitIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_fromUnitIdMeta);
    }
    if (data.containsKey('to_unit_id')) {
      context.handle(
        _toUnitIdMeta,
        toUnitId.isAcceptableOrUnknown(data['to_unit_id']!, _toUnitIdMeta),
      );
    } else if (isInserting) {
      context.missing(_toUnitIdMeta);
    }
    if (data.containsKey('conversion_factor')) {
      context.handle(
        _conversionFactorMeta,
        conversionFactor.isAcceptableOrUnknown(
          data['conversion_factor']!,
          _conversionFactorMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_conversionFactorMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {fromUnitId, toUnitId},
  ];
  @override
  UomConversion map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UomConversion(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      fromUnitId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}from_unit_id'],
      )!,
      toUnitId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}to_unit_id'],
      )!,
      conversionFactor: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}conversion_factor'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $UomConversionsTable createAlias(String alias) {
    return $UomConversionsTable(attachedDatabase, alias);
  }
}

class UomConversion extends DataClass implements Insertable<UomConversion> {
  final int id;
  final int fromUnitId;
  final int toUnitId;
  final double conversionFactor;
  final String? description;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  const UomConversion({
    required this.id,
    required this.fromUnitId,
    required this.toUnitId,
    required this.conversionFactor,
    this.description,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['from_unit_id'] = Variable<int>(fromUnitId);
    map['to_unit_id'] = Variable<int>(toUnitId);
    map['conversion_factor'] = Variable<double>(conversionFactor);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  UomConversionsCompanion toCompanion(bool nullToAbsent) {
    return UomConversionsCompanion(
      id: Value(id),
      fromUnitId: Value(fromUnitId),
      toUnitId: Value(toUnitId),
      conversionFactor: Value(conversionFactor),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory UomConversion.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UomConversion(
      id: serializer.fromJson<int>(json['id']),
      fromUnitId: serializer.fromJson<int>(json['fromUnitId']),
      toUnitId: serializer.fromJson<int>(json['toUnitId']),
      conversionFactor: serializer.fromJson<double>(json['conversionFactor']),
      description: serializer.fromJson<String?>(json['description']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'fromUnitId': serializer.toJson<int>(fromUnitId),
      'toUnitId': serializer.toJson<int>(toUnitId),
      'conversionFactor': serializer.toJson<double>(conversionFactor),
      'description': serializer.toJson<String?>(description),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  UomConversion copyWith({
    int? id,
    int? fromUnitId,
    int? toUnitId,
    double? conversionFactor,
    Value<String?> description = const Value.absent(),
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => UomConversion(
    id: id ?? this.id,
    fromUnitId: fromUnitId ?? this.fromUnitId,
    toUnitId: toUnitId ?? this.toUnitId,
    conversionFactor: conversionFactor ?? this.conversionFactor,
    description: description.present ? description.value : this.description,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  UomConversion copyWithCompanion(UomConversionsCompanion data) {
    return UomConversion(
      id: data.id.present ? data.id.value : this.id,
      fromUnitId: data.fromUnitId.present
          ? data.fromUnitId.value
          : this.fromUnitId,
      toUnitId: data.toUnitId.present ? data.toUnitId.value : this.toUnitId,
      conversionFactor: data.conversionFactor.present
          ? data.conversionFactor.value
          : this.conversionFactor,
      description: data.description.present
          ? data.description.value
          : this.description,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UomConversion(')
          ..write('id: $id, ')
          ..write('fromUnitId: $fromUnitId, ')
          ..write('toUnitId: $toUnitId, ')
          ..write('conversionFactor: $conversionFactor, ')
          ..write('description: $description, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    fromUnitId,
    toUnitId,
    conversionFactor,
    description,
    isActive,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UomConversion &&
          other.id == this.id &&
          other.fromUnitId == this.fromUnitId &&
          other.toUnitId == this.toUnitId &&
          other.conversionFactor == this.conversionFactor &&
          other.description == this.description &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class UomConversionsCompanion extends UpdateCompanion<UomConversion> {
  final Value<int> id;
  final Value<int> fromUnitId;
  final Value<int> toUnitId;
  final Value<double> conversionFactor;
  final Value<String?> description;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const UomConversionsCompanion({
    this.id = const Value.absent(),
    this.fromUnitId = const Value.absent(),
    this.toUnitId = const Value.absent(),
    this.conversionFactor = const Value.absent(),
    this.description = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  UomConversionsCompanion.insert({
    this.id = const Value.absent(),
    required int fromUnitId,
    required int toUnitId,
    required double conversionFactor,
    this.description = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : fromUnitId = Value(fromUnitId),
       toUnitId = Value(toUnitId),
       conversionFactor = Value(conversionFactor);
  static Insertable<UomConversion> custom({
    Expression<int>? id,
    Expression<int>? fromUnitId,
    Expression<int>? toUnitId,
    Expression<double>? conversionFactor,
    Expression<String>? description,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (fromUnitId != null) 'from_unit_id': fromUnitId,
      if (toUnitId != null) 'to_unit_id': toUnitId,
      if (conversionFactor != null) 'conversion_factor': conversionFactor,
      if (description != null) 'description': description,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  UomConversionsCompanion copyWith({
    Value<int>? id,
    Value<int>? fromUnitId,
    Value<int>? toUnitId,
    Value<double>? conversionFactor,
    Value<String?>? description,
    Value<bool>? isActive,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return UomConversionsCompanion(
      id: id ?? this.id,
      fromUnitId: fromUnitId ?? this.fromUnitId,
      toUnitId: toUnitId ?? this.toUnitId,
      conversionFactor: conversionFactor ?? this.conversionFactor,
      description: description ?? this.description,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (fromUnitId.present) {
      map['from_unit_id'] = Variable<int>(fromUnitId.value);
    }
    if (toUnitId.present) {
      map['to_unit_id'] = Variable<int>(toUnitId.value);
    }
    if (conversionFactor.present) {
      map['conversion_factor'] = Variable<double>(conversionFactor.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UomConversionsCompanion(')
          ..write('id: $id, ')
          ..write('fromUnitId: $fromUnitId, ')
          ..write('toUnitId: $toUnitId, ')
          ..write('conversionFactor: $conversionFactor, ')
          ..write('description: $description, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $TaxCategoriesTable extends TaxCategories
    with TableInfo<$TaxCategoriesTable, TaxCategory> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TaxCategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _taxCategoryCodeMeta = const VerificationMeta(
    'taxCategoryCode',
  );
  @override
  late final GeneratedColumn<String> taxCategoryCode = GeneratedColumn<String>(
    'tax_category_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _taxCategoryNameMeta = const VerificationMeta(
    'taxCategoryName',
  );
  @override
  late final GeneratedColumn<String> taxCategoryName = GeneratedColumn<String>(
    'tax_category_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    taxCategoryCode,
    taxCategoryName,
    description,
    isActive,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tax_category';
  @override
  VerificationContext validateIntegrity(
    Insertable<TaxCategory> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('tax_category_code')) {
      context.handle(
        _taxCategoryCodeMeta,
        taxCategoryCode.isAcceptableOrUnknown(
          data['tax_category_code']!,
          _taxCategoryCodeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_taxCategoryCodeMeta);
    }
    if (data.containsKey('tax_category_name')) {
      context.handle(
        _taxCategoryNameMeta,
        taxCategoryName.isAcceptableOrUnknown(
          data['tax_category_name']!,
          _taxCategoryNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_taxCategoryNameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TaxCategory map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TaxCategory(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      taxCategoryCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tax_category_code'],
      )!,
      taxCategoryName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tax_category_name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $TaxCategoriesTable createAlias(String alias) {
    return $TaxCategoriesTable(attachedDatabase, alias);
  }
}

class TaxCategory extends DataClass implements Insertable<TaxCategory> {
  final int id;
  final String taxCategoryCode;
  final String taxCategoryName;
  final String? description;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  const TaxCategory({
    required this.id,
    required this.taxCategoryCode,
    required this.taxCategoryName,
    this.description,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['tax_category_code'] = Variable<String>(taxCategoryCode);
    map['tax_category_name'] = Variable<String>(taxCategoryName);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  TaxCategoriesCompanion toCompanion(bool nullToAbsent) {
    return TaxCategoriesCompanion(
      id: Value(id),
      taxCategoryCode: Value(taxCategoryCode),
      taxCategoryName: Value(taxCategoryName),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory TaxCategory.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TaxCategory(
      id: serializer.fromJson<int>(json['id']),
      taxCategoryCode: serializer.fromJson<String>(json['taxCategoryCode']),
      taxCategoryName: serializer.fromJson<String>(json['taxCategoryName']),
      description: serializer.fromJson<String?>(json['description']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'taxCategoryCode': serializer.toJson<String>(taxCategoryCode),
      'taxCategoryName': serializer.toJson<String>(taxCategoryName),
      'description': serializer.toJson<String?>(description),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  TaxCategory copyWith({
    int? id,
    String? taxCategoryCode,
    String? taxCategoryName,
    Value<String?> description = const Value.absent(),
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => TaxCategory(
    id: id ?? this.id,
    taxCategoryCode: taxCategoryCode ?? this.taxCategoryCode,
    taxCategoryName: taxCategoryName ?? this.taxCategoryName,
    description: description.present ? description.value : this.description,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  TaxCategory copyWithCompanion(TaxCategoriesCompanion data) {
    return TaxCategory(
      id: data.id.present ? data.id.value : this.id,
      taxCategoryCode: data.taxCategoryCode.present
          ? data.taxCategoryCode.value
          : this.taxCategoryCode,
      taxCategoryName: data.taxCategoryName.present
          ? data.taxCategoryName.value
          : this.taxCategoryName,
      description: data.description.present
          ? data.description.value
          : this.description,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TaxCategory(')
          ..write('id: $id, ')
          ..write('taxCategoryCode: $taxCategoryCode, ')
          ..write('taxCategoryName: $taxCategoryName, ')
          ..write('description: $description, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    taxCategoryCode,
    taxCategoryName,
    description,
    isActive,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TaxCategory &&
          other.id == this.id &&
          other.taxCategoryCode == this.taxCategoryCode &&
          other.taxCategoryName == this.taxCategoryName &&
          other.description == this.description &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class TaxCategoriesCompanion extends UpdateCompanion<TaxCategory> {
  final Value<int> id;
  final Value<String> taxCategoryCode;
  final Value<String> taxCategoryName;
  final Value<String?> description;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const TaxCategoriesCompanion({
    this.id = const Value.absent(),
    this.taxCategoryCode = const Value.absent(),
    this.taxCategoryName = const Value.absent(),
    this.description = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  TaxCategoriesCompanion.insert({
    this.id = const Value.absent(),
    required String taxCategoryCode,
    required String taxCategoryName,
    this.description = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : taxCategoryCode = Value(taxCategoryCode),
       taxCategoryName = Value(taxCategoryName);
  static Insertable<TaxCategory> custom({
    Expression<int>? id,
    Expression<String>? taxCategoryCode,
    Expression<String>? taxCategoryName,
    Expression<String>? description,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (taxCategoryCode != null) 'tax_category_code': taxCategoryCode,
      if (taxCategoryName != null) 'tax_category_name': taxCategoryName,
      if (description != null) 'description': description,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  TaxCategoriesCompanion copyWith({
    Value<int>? id,
    Value<String>? taxCategoryCode,
    Value<String>? taxCategoryName,
    Value<String?>? description,
    Value<bool>? isActive,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return TaxCategoriesCompanion(
      id: id ?? this.id,
      taxCategoryCode: taxCategoryCode ?? this.taxCategoryCode,
      taxCategoryName: taxCategoryName ?? this.taxCategoryName,
      description: description ?? this.description,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (taxCategoryCode.present) {
      map['tax_category_code'] = Variable<String>(taxCategoryCode.value);
    }
    if (taxCategoryName.present) {
      map['tax_category_name'] = Variable<String>(taxCategoryName.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TaxCategoriesCompanion(')
          ..write('id: $id, ')
          ..write('taxCategoryCode: $taxCategoryCode, ')
          ..write('taxCategoryName: $taxCategoryName, ')
          ..write('description: $description, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $TaxTypesTable extends TaxTypes with TableInfo<$TaxTypesTable, TaxType> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TaxTypesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _taxTypeCodeMeta = const VerificationMeta(
    'taxTypeCode',
  );
  @override
  late final GeneratedColumn<String> taxTypeCode = GeneratedColumn<String>(
    'tax_type_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _taxTypeNameMeta = const VerificationMeta(
    'taxTypeName',
  );
  @override
  late final GeneratedColumn<String> taxTypeName = GeneratedColumn<String>(
    'tax_type_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    taxTypeCode,
    taxTypeName,
    description,
    isActive,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tax_type';
  @override
  VerificationContext validateIntegrity(
    Insertable<TaxType> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('tax_type_code')) {
      context.handle(
        _taxTypeCodeMeta,
        taxTypeCode.isAcceptableOrUnknown(
          data['tax_type_code']!,
          _taxTypeCodeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_taxTypeCodeMeta);
    }
    if (data.containsKey('tax_type_name')) {
      context.handle(
        _taxTypeNameMeta,
        taxTypeName.isAcceptableOrUnknown(
          data['tax_type_name']!,
          _taxTypeNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_taxTypeNameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TaxType map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TaxType(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      taxTypeCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tax_type_code'],
      )!,
      taxTypeName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tax_type_name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $TaxTypesTable createAlias(String alias) {
    return $TaxTypesTable(attachedDatabase, alias);
  }
}

class TaxType extends DataClass implements Insertable<TaxType> {
  final int id;
  final String taxTypeCode;
  final String taxTypeName;
  final String? description;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  const TaxType({
    required this.id,
    required this.taxTypeCode,
    required this.taxTypeName,
    this.description,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['tax_type_code'] = Variable<String>(taxTypeCode);
    map['tax_type_name'] = Variable<String>(taxTypeName);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  TaxTypesCompanion toCompanion(bool nullToAbsent) {
    return TaxTypesCompanion(
      id: Value(id),
      taxTypeCode: Value(taxTypeCode),
      taxTypeName: Value(taxTypeName),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory TaxType.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TaxType(
      id: serializer.fromJson<int>(json['id']),
      taxTypeCode: serializer.fromJson<String>(json['taxTypeCode']),
      taxTypeName: serializer.fromJson<String>(json['taxTypeName']),
      description: serializer.fromJson<String?>(json['description']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'taxTypeCode': serializer.toJson<String>(taxTypeCode),
      'taxTypeName': serializer.toJson<String>(taxTypeName),
      'description': serializer.toJson<String?>(description),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  TaxType copyWith({
    int? id,
    String? taxTypeCode,
    String? taxTypeName,
    Value<String?> description = const Value.absent(),
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => TaxType(
    id: id ?? this.id,
    taxTypeCode: taxTypeCode ?? this.taxTypeCode,
    taxTypeName: taxTypeName ?? this.taxTypeName,
    description: description.present ? description.value : this.description,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  TaxType copyWithCompanion(TaxTypesCompanion data) {
    return TaxType(
      id: data.id.present ? data.id.value : this.id,
      taxTypeCode: data.taxTypeCode.present
          ? data.taxTypeCode.value
          : this.taxTypeCode,
      taxTypeName: data.taxTypeName.present
          ? data.taxTypeName.value
          : this.taxTypeName,
      description: data.description.present
          ? data.description.value
          : this.description,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TaxType(')
          ..write('id: $id, ')
          ..write('taxTypeCode: $taxTypeCode, ')
          ..write('taxTypeName: $taxTypeName, ')
          ..write('description: $description, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    taxTypeCode,
    taxTypeName,
    description,
    isActive,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TaxType &&
          other.id == this.id &&
          other.taxTypeCode == this.taxTypeCode &&
          other.taxTypeName == this.taxTypeName &&
          other.description == this.description &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class TaxTypesCompanion extends UpdateCompanion<TaxType> {
  final Value<int> id;
  final Value<String> taxTypeCode;
  final Value<String> taxTypeName;
  final Value<String?> description;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const TaxTypesCompanion({
    this.id = const Value.absent(),
    this.taxTypeCode = const Value.absent(),
    this.taxTypeName = const Value.absent(),
    this.description = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  TaxTypesCompanion.insert({
    this.id = const Value.absent(),
    required String taxTypeCode,
    required String taxTypeName,
    this.description = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : taxTypeCode = Value(taxTypeCode),
       taxTypeName = Value(taxTypeName);
  static Insertable<TaxType> custom({
    Expression<int>? id,
    Expression<String>? taxTypeCode,
    Expression<String>? taxTypeName,
    Expression<String>? description,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (taxTypeCode != null) 'tax_type_code': taxTypeCode,
      if (taxTypeName != null) 'tax_type_name': taxTypeName,
      if (description != null) 'description': description,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  TaxTypesCompanion copyWith({
    Value<int>? id,
    Value<String>? taxTypeCode,
    Value<String>? taxTypeName,
    Value<String?>? description,
    Value<bool>? isActive,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return TaxTypesCompanion(
      id: id ?? this.id,
      taxTypeCode: taxTypeCode ?? this.taxTypeCode,
      taxTypeName: taxTypeName ?? this.taxTypeName,
      description: description ?? this.description,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (taxTypeCode.present) {
      map['tax_type_code'] = Variable<String>(taxTypeCode.value);
    }
    if (taxTypeName.present) {
      map['tax_type_name'] = Variable<String>(taxTypeName.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TaxTypesCompanion(')
          ..write('id: $id, ')
          ..write('taxTypeCode: $taxTypeCode, ')
          ..write('taxTypeName: $taxTypeName, ')
          ..write('description: $description, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $TaxCategoryRatesTable extends TaxCategoryRates
    with TableInfo<$TaxCategoryRatesTable, TaxCategoryRate> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TaxCategoryRatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _taxCategoryIdMeta = const VerificationMeta(
    'taxCategoryId',
  );
  @override
  late final GeneratedColumn<int> taxCategoryId = GeneratedColumn<int>(
    'tax_category_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES tax_category (id)',
    ),
  );
  static const VerificationMeta _taxTypeIdMeta = const VerificationMeta(
    'taxTypeId',
  );
  @override
  late final GeneratedColumn<int> taxTypeId = GeneratedColumn<int>(
    'tax_type_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES tax_type (id)',
    ),
  );
  static const VerificationMeta _ratePercentMeta = const VerificationMeta(
    'ratePercent',
  );
  @override
  late final GeneratedColumn<double> ratePercent = GeneratedColumn<double>(
    'rate_percent',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    taxCategoryId,
    taxTypeId,
    ratePercent,
    isActive,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tax_category_rate';
  @override
  VerificationContext validateIntegrity(
    Insertable<TaxCategoryRate> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('tax_category_id')) {
      context.handle(
        _taxCategoryIdMeta,
        taxCategoryId.isAcceptableOrUnknown(
          data['tax_category_id']!,
          _taxCategoryIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_taxCategoryIdMeta);
    }
    if (data.containsKey('tax_type_id')) {
      context.handle(
        _taxTypeIdMeta,
        taxTypeId.isAcceptableOrUnknown(data['tax_type_id']!, _taxTypeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_taxTypeIdMeta);
    }
    if (data.containsKey('rate_percent')) {
      context.handle(
        _ratePercentMeta,
        ratePercent.isAcceptableOrUnknown(
          data['rate_percent']!,
          _ratePercentMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_ratePercentMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {taxCategoryId, taxTypeId},
  ];
  @override
  TaxCategoryRate map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TaxCategoryRate(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      taxCategoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tax_category_id'],
      )!,
      taxTypeId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tax_type_id'],
      )!,
      ratePercent: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}rate_percent'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $TaxCategoryRatesTable createAlias(String alias) {
    return $TaxCategoryRatesTable(attachedDatabase, alias);
  }
}

class TaxCategoryRate extends DataClass implements Insertable<TaxCategoryRate> {
  final int id;
  final int taxCategoryId;
  final int taxTypeId;
  final double ratePercent;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  const TaxCategoryRate({
    required this.id,
    required this.taxCategoryId,
    required this.taxTypeId,
    required this.ratePercent,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['tax_category_id'] = Variable<int>(taxCategoryId);
    map['tax_type_id'] = Variable<int>(taxTypeId);
    map['rate_percent'] = Variable<double>(ratePercent);
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  TaxCategoryRatesCompanion toCompanion(bool nullToAbsent) {
    return TaxCategoryRatesCompanion(
      id: Value(id),
      taxCategoryId: Value(taxCategoryId),
      taxTypeId: Value(taxTypeId),
      ratePercent: Value(ratePercent),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory TaxCategoryRate.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TaxCategoryRate(
      id: serializer.fromJson<int>(json['id']),
      taxCategoryId: serializer.fromJson<int>(json['taxCategoryId']),
      taxTypeId: serializer.fromJson<int>(json['taxTypeId']),
      ratePercent: serializer.fromJson<double>(json['ratePercent']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'taxCategoryId': serializer.toJson<int>(taxCategoryId),
      'taxTypeId': serializer.toJson<int>(taxTypeId),
      'ratePercent': serializer.toJson<double>(ratePercent),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  TaxCategoryRate copyWith({
    int? id,
    int? taxCategoryId,
    int? taxTypeId,
    double? ratePercent,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => TaxCategoryRate(
    id: id ?? this.id,
    taxCategoryId: taxCategoryId ?? this.taxCategoryId,
    taxTypeId: taxTypeId ?? this.taxTypeId,
    ratePercent: ratePercent ?? this.ratePercent,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  TaxCategoryRate copyWithCompanion(TaxCategoryRatesCompanion data) {
    return TaxCategoryRate(
      id: data.id.present ? data.id.value : this.id,
      taxCategoryId: data.taxCategoryId.present
          ? data.taxCategoryId.value
          : this.taxCategoryId,
      taxTypeId: data.taxTypeId.present ? data.taxTypeId.value : this.taxTypeId,
      ratePercent: data.ratePercent.present
          ? data.ratePercent.value
          : this.ratePercent,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TaxCategoryRate(')
          ..write('id: $id, ')
          ..write('taxCategoryId: $taxCategoryId, ')
          ..write('taxTypeId: $taxTypeId, ')
          ..write('ratePercent: $ratePercent, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    taxCategoryId,
    taxTypeId,
    ratePercent,
    isActive,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TaxCategoryRate &&
          other.id == this.id &&
          other.taxCategoryId == this.taxCategoryId &&
          other.taxTypeId == this.taxTypeId &&
          other.ratePercent == this.ratePercent &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class TaxCategoryRatesCompanion extends UpdateCompanion<TaxCategoryRate> {
  final Value<int> id;
  final Value<int> taxCategoryId;
  final Value<int> taxTypeId;
  final Value<double> ratePercent;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const TaxCategoryRatesCompanion({
    this.id = const Value.absent(),
    this.taxCategoryId = const Value.absent(),
    this.taxTypeId = const Value.absent(),
    this.ratePercent = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  TaxCategoryRatesCompanion.insert({
    this.id = const Value.absent(),
    required int taxCategoryId,
    required int taxTypeId,
    required double ratePercent,
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : taxCategoryId = Value(taxCategoryId),
       taxTypeId = Value(taxTypeId),
       ratePercent = Value(ratePercent);
  static Insertable<TaxCategoryRate> custom({
    Expression<int>? id,
    Expression<int>? taxCategoryId,
    Expression<int>? taxTypeId,
    Expression<double>? ratePercent,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (taxCategoryId != null) 'tax_category_id': taxCategoryId,
      if (taxTypeId != null) 'tax_type_id': taxTypeId,
      if (ratePercent != null) 'rate_percent': ratePercent,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  TaxCategoryRatesCompanion copyWith({
    Value<int>? id,
    Value<int>? taxCategoryId,
    Value<int>? taxTypeId,
    Value<double>? ratePercent,
    Value<bool>? isActive,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return TaxCategoryRatesCompanion(
      id: id ?? this.id,
      taxCategoryId: taxCategoryId ?? this.taxCategoryId,
      taxTypeId: taxTypeId ?? this.taxTypeId,
      ratePercent: ratePercent ?? this.ratePercent,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (taxCategoryId.present) {
      map['tax_category_id'] = Variable<int>(taxCategoryId.value);
    }
    if (taxTypeId.present) {
      map['tax_type_id'] = Variable<int>(taxTypeId.value);
    }
    if (ratePercent.present) {
      map['rate_percent'] = Variable<double>(ratePercent.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TaxCategoryRatesCompanion(')
          ..write('id: $id, ')
          ..write('taxCategoryId: $taxCategoryId, ')
          ..write('taxTypeId: $taxTypeId, ')
          ..write('ratePercent: $ratePercent, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $CustomersTable extends Customers
    with TableInfo<$CustomersTable, Customer> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CustomersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _customerCodeMeta = const VerificationMeta(
    'customerCode',
  );
  @override
  late final GeneratedColumn<String> customerCode = GeneratedColumn<String>(
    'customer_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _customerNameMeta = const VerificationMeta(
    'customerName',
  );
  @override
  late final GeneratedColumn<String> customerName = GeneratedColumn<String>(
    'customer_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _gstNumberMeta = const VerificationMeta(
    'gstNumber',
  );
  @override
  late final GeneratedColumn<String> gstNumber = GeneratedColumn<String>(
    'gst_number',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _panNumberMeta = const VerificationMeta(
    'panNumber',
  );
  @override
  late final GeneratedColumn<String> panNumber = GeneratedColumn<String>(
    'pan_number',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _mobileMeta = const VerificationMeta('mobile');
  @override
  late final GeneratedColumn<String> mobile = GeneratedColumn<String>(
    'mobile',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _alternateMobileMeta = const VerificationMeta(
    'alternateMobile',
  );
  @override
  late final GeneratedColumn<String> alternateMobile = GeneratedColumn<String>(
    'alternate_mobile',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _addressLine1Meta = const VerificationMeta(
    'addressLine1',
  );
  @override
  late final GeneratedColumn<String> addressLine1 = GeneratedColumn<String>(
    'address_line1',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _addressLine2Meta = const VerificationMeta(
    'addressLine2',
  );
  @override
  late final GeneratedColumn<String> addressLine2 = GeneratedColumn<String>(
    'address_line2',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cityMeta = const VerificationMeta('city');
  @override
  late final GeneratedColumn<String> city = GeneratedColumn<String>(
    'city',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _stateMeta = const VerificationMeta('state');
  @override
  late final GeneratedColumn<String> state = GeneratedColumn<String>(
    'state',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _stateCodeMeta = const VerificationMeta(
    'stateCode',
  );
  @override
  late final GeneratedColumn<String> stateCode = GeneratedColumn<String>(
    'state_code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _countryMeta = const VerificationMeta(
    'country',
  );
  @override
  late final GeneratedColumn<String> country = GeneratedColumn<String>(
    'country',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pincodeMeta = const VerificationMeta(
    'pincode',
  );
  @override
  late final GeneratedColumn<String> pincode = GeneratedColumn<String>(
    'pincode',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _creditLimitMeta = const VerificationMeta(
    'creditLimit',
  );
  @override
  late final GeneratedColumn<int> creditLimit = GeneratedColumn<int>(
    'credit_limit',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _openingBalanceMeta = const VerificationMeta(
    'openingBalance',
  );
  @override
  late final GeneratedColumn<int> openingBalance = GeneratedColumn<int>(
    'opening_balance',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _outstandingBalanceMeta =
      const VerificationMeta('outstandingBalance');
  @override
  late final GeneratedColumn<int> outstandingBalance = GeneratedColumn<int>(
    'outstanding_balance',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _paymentDueDateMeta = const VerificationMeta(
    'paymentDueDate',
  );
  @override
  late final GeneratedColumn<DateTime> paymentDueDate =
      GeneratedColumn<DateTime>(
        'payment_due_date',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _accountNameMeta = const VerificationMeta(
    'accountName',
  );
  @override
  late final GeneratedColumn<String> accountName = GeneratedColumn<String>(
    'account_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _accountNumberMeta = const VerificationMeta(
    'accountNumber',
  );
  @override
  late final GeneratedColumn<String> accountNumber = GeneratedColumn<String>(
    'account_number',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bankNameMeta = const VerificationMeta(
    'bankName',
  );
  @override
  late final GeneratedColumn<String> bankName = GeneratedColumn<String>(
    'bank_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _branchNameMeta = const VerificationMeta(
    'branchName',
  );
  @override
  late final GeneratedColumn<String> branchName = GeneratedColumn<String>(
    'branch_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ifscCodeMeta = const VerificationMeta(
    'ifscCode',
  );
  @override
  late final GeneratedColumn<String> ifscCode = GeneratedColumn<String>(
    'ifsc_code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _balanceTypeMeta = const VerificationMeta(
    'balanceType',
  );
  @override
  late final GeneratedColumn<String> balanceType = GeneratedColumn<String>(
    'balance_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('DEBIT'),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    customerCode,
    customerName,
    gstNumber,
    panNumber,
    mobile,
    alternateMobile,
    email,
    addressLine1,
    addressLine2,
    city,
    state,
    stateCode,
    country,
    pincode,
    creditLimit,
    openingBalance,
    outstandingBalance,
    paymentDueDate,
    accountName,
    accountNumber,
    bankName,
    branchName,
    ifscCode,
    balanceType,
    notes,
    isActive,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'customer';
  @override
  VerificationContext validateIntegrity(
    Insertable<Customer> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('customer_code')) {
      context.handle(
        _customerCodeMeta,
        customerCode.isAcceptableOrUnknown(
          data['customer_code']!,
          _customerCodeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_customerCodeMeta);
    }
    if (data.containsKey('customer_name')) {
      context.handle(
        _customerNameMeta,
        customerName.isAcceptableOrUnknown(
          data['customer_name']!,
          _customerNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_customerNameMeta);
    }
    if (data.containsKey('gst_number')) {
      context.handle(
        _gstNumberMeta,
        gstNumber.isAcceptableOrUnknown(data['gst_number']!, _gstNumberMeta),
      );
    }
    if (data.containsKey('pan_number')) {
      context.handle(
        _panNumberMeta,
        panNumber.isAcceptableOrUnknown(data['pan_number']!, _panNumberMeta),
      );
    }
    if (data.containsKey('mobile')) {
      context.handle(
        _mobileMeta,
        mobile.isAcceptableOrUnknown(data['mobile']!, _mobileMeta),
      );
    }
    if (data.containsKey('alternate_mobile')) {
      context.handle(
        _alternateMobileMeta,
        alternateMobile.isAcceptableOrUnknown(
          data['alternate_mobile']!,
          _alternateMobileMeta,
        ),
      );
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    }
    if (data.containsKey('address_line1')) {
      context.handle(
        _addressLine1Meta,
        addressLine1.isAcceptableOrUnknown(
          data['address_line1']!,
          _addressLine1Meta,
        ),
      );
    }
    if (data.containsKey('address_line2')) {
      context.handle(
        _addressLine2Meta,
        addressLine2.isAcceptableOrUnknown(
          data['address_line2']!,
          _addressLine2Meta,
        ),
      );
    }
    if (data.containsKey('city')) {
      context.handle(
        _cityMeta,
        city.isAcceptableOrUnknown(data['city']!, _cityMeta),
      );
    }
    if (data.containsKey('state')) {
      context.handle(
        _stateMeta,
        state.isAcceptableOrUnknown(data['state']!, _stateMeta),
      );
    }
    if (data.containsKey('state_code')) {
      context.handle(
        _stateCodeMeta,
        stateCode.isAcceptableOrUnknown(data['state_code']!, _stateCodeMeta),
      );
    }
    if (data.containsKey('country')) {
      context.handle(
        _countryMeta,
        country.isAcceptableOrUnknown(data['country']!, _countryMeta),
      );
    }
    if (data.containsKey('pincode')) {
      context.handle(
        _pincodeMeta,
        pincode.isAcceptableOrUnknown(data['pincode']!, _pincodeMeta),
      );
    }
    if (data.containsKey('credit_limit')) {
      context.handle(
        _creditLimitMeta,
        creditLimit.isAcceptableOrUnknown(
          data['credit_limit']!,
          _creditLimitMeta,
        ),
      );
    }
    if (data.containsKey('opening_balance')) {
      context.handle(
        _openingBalanceMeta,
        openingBalance.isAcceptableOrUnknown(
          data['opening_balance']!,
          _openingBalanceMeta,
        ),
      );
    }
    if (data.containsKey('outstanding_balance')) {
      context.handle(
        _outstandingBalanceMeta,
        outstandingBalance.isAcceptableOrUnknown(
          data['outstanding_balance']!,
          _outstandingBalanceMeta,
        ),
      );
    }
    if (data.containsKey('payment_due_date')) {
      context.handle(
        _paymentDueDateMeta,
        paymentDueDate.isAcceptableOrUnknown(
          data['payment_due_date']!,
          _paymentDueDateMeta,
        ),
      );
    }
    if (data.containsKey('account_name')) {
      context.handle(
        _accountNameMeta,
        accountName.isAcceptableOrUnknown(
          data['account_name']!,
          _accountNameMeta,
        ),
      );
    }
    if (data.containsKey('account_number')) {
      context.handle(
        _accountNumberMeta,
        accountNumber.isAcceptableOrUnknown(
          data['account_number']!,
          _accountNumberMeta,
        ),
      );
    }
    if (data.containsKey('bank_name')) {
      context.handle(
        _bankNameMeta,
        bankName.isAcceptableOrUnknown(data['bank_name']!, _bankNameMeta),
      );
    }
    if (data.containsKey('branch_name')) {
      context.handle(
        _branchNameMeta,
        branchName.isAcceptableOrUnknown(data['branch_name']!, _branchNameMeta),
      );
    }
    if (data.containsKey('ifsc_code')) {
      context.handle(
        _ifscCodeMeta,
        ifscCode.isAcceptableOrUnknown(data['ifsc_code']!, _ifscCodeMeta),
      );
    }
    if (data.containsKey('balance_type')) {
      context.handle(
        _balanceTypeMeta,
        balanceType.isAcceptableOrUnknown(
          data['balance_type']!,
          _balanceTypeMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Customer map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Customer(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      customerCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}customer_code'],
      )!,
      customerName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}customer_name'],
      )!,
      gstNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}gst_number'],
      ),
      panNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pan_number'],
      ),
      mobile: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mobile'],
      ),
      alternateMobile: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}alternate_mobile'],
      ),
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      ),
      addressLine1: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address_line1'],
      ),
      addressLine2: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address_line2'],
      ),
      city: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}city'],
      ),
      state: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}state'],
      ),
      stateCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}state_code'],
      ),
      country: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}country'],
      ),
      pincode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pincode'],
      ),
      creditLimit: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}credit_limit'],
      )!,
      openingBalance: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}opening_balance'],
      )!,
      outstandingBalance: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}outstanding_balance'],
      )!,
      paymentDueDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}payment_due_date'],
      ),
      accountName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_name'],
      ),
      accountNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_number'],
      ),
      bankName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bank_name'],
      ),
      branchName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}branch_name'],
      ),
      ifscCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ifsc_code'],
      ),
      balanceType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}balance_type'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $CustomersTable createAlias(String alias) {
    return $CustomersTable(attachedDatabase, alias);
  }
}

class Customer extends DataClass implements Insertable<Customer> {
  final int id;
  final String customerCode;
  final String customerName;
  final String? gstNumber;
  final String? panNumber;
  final String? mobile;
  final String? alternateMobile;
  final String? email;
  final String? addressLine1;
  final String? addressLine2;
  final String? city;
  final String? state;
  final String? stateCode;
  final String? country;
  final String? pincode;
  final int creditLimit;
  final int openingBalance;
  final int outstandingBalance;
  final DateTime? paymentDueDate;
  final String? accountName;
  final String? accountNumber;
  final String? bankName;
  final String? branchName;
  final String? ifscCode;

  /// `DEBIT` or `CREDIT` — see the shared `BalanceType` enum.
  final String balanceType;
  final String? notes;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Customer({
    required this.id,
    required this.customerCode,
    required this.customerName,
    this.gstNumber,
    this.panNumber,
    this.mobile,
    this.alternateMobile,
    this.email,
    this.addressLine1,
    this.addressLine2,
    this.city,
    this.state,
    this.stateCode,
    this.country,
    this.pincode,
    required this.creditLimit,
    required this.openingBalance,
    required this.outstandingBalance,
    this.paymentDueDate,
    this.accountName,
    this.accountNumber,
    this.bankName,
    this.branchName,
    this.ifscCode,
    required this.balanceType,
    this.notes,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['customer_code'] = Variable<String>(customerCode);
    map['customer_name'] = Variable<String>(customerName);
    if (!nullToAbsent || gstNumber != null) {
      map['gst_number'] = Variable<String>(gstNumber);
    }
    if (!nullToAbsent || panNumber != null) {
      map['pan_number'] = Variable<String>(panNumber);
    }
    if (!nullToAbsent || mobile != null) {
      map['mobile'] = Variable<String>(mobile);
    }
    if (!nullToAbsent || alternateMobile != null) {
      map['alternate_mobile'] = Variable<String>(alternateMobile);
    }
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || addressLine1 != null) {
      map['address_line1'] = Variable<String>(addressLine1);
    }
    if (!nullToAbsent || addressLine2 != null) {
      map['address_line2'] = Variable<String>(addressLine2);
    }
    if (!nullToAbsent || city != null) {
      map['city'] = Variable<String>(city);
    }
    if (!nullToAbsent || state != null) {
      map['state'] = Variable<String>(state);
    }
    if (!nullToAbsent || stateCode != null) {
      map['state_code'] = Variable<String>(stateCode);
    }
    if (!nullToAbsent || country != null) {
      map['country'] = Variable<String>(country);
    }
    if (!nullToAbsent || pincode != null) {
      map['pincode'] = Variable<String>(pincode);
    }
    map['credit_limit'] = Variable<int>(creditLimit);
    map['opening_balance'] = Variable<int>(openingBalance);
    map['outstanding_balance'] = Variable<int>(outstandingBalance);
    if (!nullToAbsent || paymentDueDate != null) {
      map['payment_due_date'] = Variable<DateTime>(paymentDueDate);
    }
    if (!nullToAbsent || accountName != null) {
      map['account_name'] = Variable<String>(accountName);
    }
    if (!nullToAbsent || accountNumber != null) {
      map['account_number'] = Variable<String>(accountNumber);
    }
    if (!nullToAbsent || bankName != null) {
      map['bank_name'] = Variable<String>(bankName);
    }
    if (!nullToAbsent || branchName != null) {
      map['branch_name'] = Variable<String>(branchName);
    }
    if (!nullToAbsent || ifscCode != null) {
      map['ifsc_code'] = Variable<String>(ifscCode);
    }
    map['balance_type'] = Variable<String>(balanceType);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  CustomersCompanion toCompanion(bool nullToAbsent) {
    return CustomersCompanion(
      id: Value(id),
      customerCode: Value(customerCode),
      customerName: Value(customerName),
      gstNumber: gstNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(gstNumber),
      panNumber: panNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(panNumber),
      mobile: mobile == null && nullToAbsent
          ? const Value.absent()
          : Value(mobile),
      alternateMobile: alternateMobile == null && nullToAbsent
          ? const Value.absent()
          : Value(alternateMobile),
      email: email == null && nullToAbsent
          ? const Value.absent()
          : Value(email),
      addressLine1: addressLine1 == null && nullToAbsent
          ? const Value.absent()
          : Value(addressLine1),
      addressLine2: addressLine2 == null && nullToAbsent
          ? const Value.absent()
          : Value(addressLine2),
      city: city == null && nullToAbsent ? const Value.absent() : Value(city),
      state: state == null && nullToAbsent
          ? const Value.absent()
          : Value(state),
      stateCode: stateCode == null && nullToAbsent
          ? const Value.absent()
          : Value(stateCode),
      country: country == null && nullToAbsent
          ? const Value.absent()
          : Value(country),
      pincode: pincode == null && nullToAbsent
          ? const Value.absent()
          : Value(pincode),
      creditLimit: Value(creditLimit),
      openingBalance: Value(openingBalance),
      outstandingBalance: Value(outstandingBalance),
      paymentDueDate: paymentDueDate == null && nullToAbsent
          ? const Value.absent()
          : Value(paymentDueDate),
      accountName: accountName == null && nullToAbsent
          ? const Value.absent()
          : Value(accountName),
      accountNumber: accountNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(accountNumber),
      bankName: bankName == null && nullToAbsent
          ? const Value.absent()
          : Value(bankName),
      branchName: branchName == null && nullToAbsent
          ? const Value.absent()
          : Value(branchName),
      ifscCode: ifscCode == null && nullToAbsent
          ? const Value.absent()
          : Value(ifscCode),
      balanceType: Value(balanceType),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Customer.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Customer(
      id: serializer.fromJson<int>(json['id']),
      customerCode: serializer.fromJson<String>(json['customerCode']),
      customerName: serializer.fromJson<String>(json['customerName']),
      gstNumber: serializer.fromJson<String?>(json['gstNumber']),
      panNumber: serializer.fromJson<String?>(json['panNumber']),
      mobile: serializer.fromJson<String?>(json['mobile']),
      alternateMobile: serializer.fromJson<String?>(json['alternateMobile']),
      email: serializer.fromJson<String?>(json['email']),
      addressLine1: serializer.fromJson<String?>(json['addressLine1']),
      addressLine2: serializer.fromJson<String?>(json['addressLine2']),
      city: serializer.fromJson<String?>(json['city']),
      state: serializer.fromJson<String?>(json['state']),
      stateCode: serializer.fromJson<String?>(json['stateCode']),
      country: serializer.fromJson<String?>(json['country']),
      pincode: serializer.fromJson<String?>(json['pincode']),
      creditLimit: serializer.fromJson<int>(json['creditLimit']),
      openingBalance: serializer.fromJson<int>(json['openingBalance']),
      outstandingBalance: serializer.fromJson<int>(json['outstandingBalance']),
      paymentDueDate: serializer.fromJson<DateTime?>(json['paymentDueDate']),
      accountName: serializer.fromJson<String?>(json['accountName']),
      accountNumber: serializer.fromJson<String?>(json['accountNumber']),
      bankName: serializer.fromJson<String?>(json['bankName']),
      branchName: serializer.fromJson<String?>(json['branchName']),
      ifscCode: serializer.fromJson<String?>(json['ifscCode']),
      balanceType: serializer.fromJson<String>(json['balanceType']),
      notes: serializer.fromJson<String?>(json['notes']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'customerCode': serializer.toJson<String>(customerCode),
      'customerName': serializer.toJson<String>(customerName),
      'gstNumber': serializer.toJson<String?>(gstNumber),
      'panNumber': serializer.toJson<String?>(panNumber),
      'mobile': serializer.toJson<String?>(mobile),
      'alternateMobile': serializer.toJson<String?>(alternateMobile),
      'email': serializer.toJson<String?>(email),
      'addressLine1': serializer.toJson<String?>(addressLine1),
      'addressLine2': serializer.toJson<String?>(addressLine2),
      'city': serializer.toJson<String?>(city),
      'state': serializer.toJson<String?>(state),
      'stateCode': serializer.toJson<String?>(stateCode),
      'country': serializer.toJson<String?>(country),
      'pincode': serializer.toJson<String?>(pincode),
      'creditLimit': serializer.toJson<int>(creditLimit),
      'openingBalance': serializer.toJson<int>(openingBalance),
      'outstandingBalance': serializer.toJson<int>(outstandingBalance),
      'paymentDueDate': serializer.toJson<DateTime?>(paymentDueDate),
      'accountName': serializer.toJson<String?>(accountName),
      'accountNumber': serializer.toJson<String?>(accountNumber),
      'bankName': serializer.toJson<String?>(bankName),
      'branchName': serializer.toJson<String?>(branchName),
      'ifscCode': serializer.toJson<String?>(ifscCode),
      'balanceType': serializer.toJson<String>(balanceType),
      'notes': serializer.toJson<String?>(notes),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Customer copyWith({
    int? id,
    String? customerCode,
    String? customerName,
    Value<String?> gstNumber = const Value.absent(),
    Value<String?> panNumber = const Value.absent(),
    Value<String?> mobile = const Value.absent(),
    Value<String?> alternateMobile = const Value.absent(),
    Value<String?> email = const Value.absent(),
    Value<String?> addressLine1 = const Value.absent(),
    Value<String?> addressLine2 = const Value.absent(),
    Value<String?> city = const Value.absent(),
    Value<String?> state = const Value.absent(),
    Value<String?> stateCode = const Value.absent(),
    Value<String?> country = const Value.absent(),
    Value<String?> pincode = const Value.absent(),
    int? creditLimit,
    int? openingBalance,
    int? outstandingBalance,
    Value<DateTime?> paymentDueDate = const Value.absent(),
    Value<String?> accountName = const Value.absent(),
    Value<String?> accountNumber = const Value.absent(),
    Value<String?> bankName = const Value.absent(),
    Value<String?> branchName = const Value.absent(),
    Value<String?> ifscCode = const Value.absent(),
    String? balanceType,
    Value<String?> notes = const Value.absent(),
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Customer(
    id: id ?? this.id,
    customerCode: customerCode ?? this.customerCode,
    customerName: customerName ?? this.customerName,
    gstNumber: gstNumber.present ? gstNumber.value : this.gstNumber,
    panNumber: panNumber.present ? panNumber.value : this.panNumber,
    mobile: mobile.present ? mobile.value : this.mobile,
    alternateMobile: alternateMobile.present
        ? alternateMobile.value
        : this.alternateMobile,
    email: email.present ? email.value : this.email,
    addressLine1: addressLine1.present ? addressLine1.value : this.addressLine1,
    addressLine2: addressLine2.present ? addressLine2.value : this.addressLine2,
    city: city.present ? city.value : this.city,
    state: state.present ? state.value : this.state,
    stateCode: stateCode.present ? stateCode.value : this.stateCode,
    country: country.present ? country.value : this.country,
    pincode: pincode.present ? pincode.value : this.pincode,
    creditLimit: creditLimit ?? this.creditLimit,
    openingBalance: openingBalance ?? this.openingBalance,
    outstandingBalance: outstandingBalance ?? this.outstandingBalance,
    paymentDueDate: paymentDueDate.present
        ? paymentDueDate.value
        : this.paymentDueDate,
    accountName: accountName.present ? accountName.value : this.accountName,
    accountNumber: accountNumber.present
        ? accountNumber.value
        : this.accountNumber,
    bankName: bankName.present ? bankName.value : this.bankName,
    branchName: branchName.present ? branchName.value : this.branchName,
    ifscCode: ifscCode.present ? ifscCode.value : this.ifscCode,
    balanceType: balanceType ?? this.balanceType,
    notes: notes.present ? notes.value : this.notes,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Customer copyWithCompanion(CustomersCompanion data) {
    return Customer(
      id: data.id.present ? data.id.value : this.id,
      customerCode: data.customerCode.present
          ? data.customerCode.value
          : this.customerCode,
      customerName: data.customerName.present
          ? data.customerName.value
          : this.customerName,
      gstNumber: data.gstNumber.present ? data.gstNumber.value : this.gstNumber,
      panNumber: data.panNumber.present ? data.panNumber.value : this.panNumber,
      mobile: data.mobile.present ? data.mobile.value : this.mobile,
      alternateMobile: data.alternateMobile.present
          ? data.alternateMobile.value
          : this.alternateMobile,
      email: data.email.present ? data.email.value : this.email,
      addressLine1: data.addressLine1.present
          ? data.addressLine1.value
          : this.addressLine1,
      addressLine2: data.addressLine2.present
          ? data.addressLine2.value
          : this.addressLine2,
      city: data.city.present ? data.city.value : this.city,
      state: data.state.present ? data.state.value : this.state,
      stateCode: data.stateCode.present ? data.stateCode.value : this.stateCode,
      country: data.country.present ? data.country.value : this.country,
      pincode: data.pincode.present ? data.pincode.value : this.pincode,
      creditLimit: data.creditLimit.present
          ? data.creditLimit.value
          : this.creditLimit,
      openingBalance: data.openingBalance.present
          ? data.openingBalance.value
          : this.openingBalance,
      outstandingBalance: data.outstandingBalance.present
          ? data.outstandingBalance.value
          : this.outstandingBalance,
      paymentDueDate: data.paymentDueDate.present
          ? data.paymentDueDate.value
          : this.paymentDueDate,
      accountName: data.accountName.present
          ? data.accountName.value
          : this.accountName,
      accountNumber: data.accountNumber.present
          ? data.accountNumber.value
          : this.accountNumber,
      bankName: data.bankName.present ? data.bankName.value : this.bankName,
      branchName: data.branchName.present
          ? data.branchName.value
          : this.branchName,
      ifscCode: data.ifscCode.present ? data.ifscCode.value : this.ifscCode,
      balanceType: data.balanceType.present
          ? data.balanceType.value
          : this.balanceType,
      notes: data.notes.present ? data.notes.value : this.notes,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Customer(')
          ..write('id: $id, ')
          ..write('customerCode: $customerCode, ')
          ..write('customerName: $customerName, ')
          ..write('gstNumber: $gstNumber, ')
          ..write('panNumber: $panNumber, ')
          ..write('mobile: $mobile, ')
          ..write('alternateMobile: $alternateMobile, ')
          ..write('email: $email, ')
          ..write('addressLine1: $addressLine1, ')
          ..write('addressLine2: $addressLine2, ')
          ..write('city: $city, ')
          ..write('state: $state, ')
          ..write('stateCode: $stateCode, ')
          ..write('country: $country, ')
          ..write('pincode: $pincode, ')
          ..write('creditLimit: $creditLimit, ')
          ..write('openingBalance: $openingBalance, ')
          ..write('outstandingBalance: $outstandingBalance, ')
          ..write('paymentDueDate: $paymentDueDate, ')
          ..write('accountName: $accountName, ')
          ..write('accountNumber: $accountNumber, ')
          ..write('bankName: $bankName, ')
          ..write('branchName: $branchName, ')
          ..write('ifscCode: $ifscCode, ')
          ..write('balanceType: $balanceType, ')
          ..write('notes: $notes, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    customerCode,
    customerName,
    gstNumber,
    panNumber,
    mobile,
    alternateMobile,
    email,
    addressLine1,
    addressLine2,
    city,
    state,
    stateCode,
    country,
    pincode,
    creditLimit,
    openingBalance,
    outstandingBalance,
    paymentDueDate,
    accountName,
    accountNumber,
    bankName,
    branchName,
    ifscCode,
    balanceType,
    notes,
    isActive,
    createdAt,
    updatedAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Customer &&
          other.id == this.id &&
          other.customerCode == this.customerCode &&
          other.customerName == this.customerName &&
          other.gstNumber == this.gstNumber &&
          other.panNumber == this.panNumber &&
          other.mobile == this.mobile &&
          other.alternateMobile == this.alternateMobile &&
          other.email == this.email &&
          other.addressLine1 == this.addressLine1 &&
          other.addressLine2 == this.addressLine2 &&
          other.city == this.city &&
          other.state == this.state &&
          other.stateCode == this.stateCode &&
          other.country == this.country &&
          other.pincode == this.pincode &&
          other.creditLimit == this.creditLimit &&
          other.openingBalance == this.openingBalance &&
          other.outstandingBalance == this.outstandingBalance &&
          other.paymentDueDate == this.paymentDueDate &&
          other.accountName == this.accountName &&
          other.accountNumber == this.accountNumber &&
          other.bankName == this.bankName &&
          other.branchName == this.branchName &&
          other.ifscCode == this.ifscCode &&
          other.balanceType == this.balanceType &&
          other.notes == this.notes &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class CustomersCompanion extends UpdateCompanion<Customer> {
  final Value<int> id;
  final Value<String> customerCode;
  final Value<String> customerName;
  final Value<String?> gstNumber;
  final Value<String?> panNumber;
  final Value<String?> mobile;
  final Value<String?> alternateMobile;
  final Value<String?> email;
  final Value<String?> addressLine1;
  final Value<String?> addressLine2;
  final Value<String?> city;
  final Value<String?> state;
  final Value<String?> stateCode;
  final Value<String?> country;
  final Value<String?> pincode;
  final Value<int> creditLimit;
  final Value<int> openingBalance;
  final Value<int> outstandingBalance;
  final Value<DateTime?> paymentDueDate;
  final Value<String?> accountName;
  final Value<String?> accountNumber;
  final Value<String?> bankName;
  final Value<String?> branchName;
  final Value<String?> ifscCode;
  final Value<String> balanceType;
  final Value<String?> notes;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const CustomersCompanion({
    this.id = const Value.absent(),
    this.customerCode = const Value.absent(),
    this.customerName = const Value.absent(),
    this.gstNumber = const Value.absent(),
    this.panNumber = const Value.absent(),
    this.mobile = const Value.absent(),
    this.alternateMobile = const Value.absent(),
    this.email = const Value.absent(),
    this.addressLine1 = const Value.absent(),
    this.addressLine2 = const Value.absent(),
    this.city = const Value.absent(),
    this.state = const Value.absent(),
    this.stateCode = const Value.absent(),
    this.country = const Value.absent(),
    this.pincode = const Value.absent(),
    this.creditLimit = const Value.absent(),
    this.openingBalance = const Value.absent(),
    this.outstandingBalance = const Value.absent(),
    this.paymentDueDate = const Value.absent(),
    this.accountName = const Value.absent(),
    this.accountNumber = const Value.absent(),
    this.bankName = const Value.absent(),
    this.branchName = const Value.absent(),
    this.ifscCode = const Value.absent(),
    this.balanceType = const Value.absent(),
    this.notes = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  CustomersCompanion.insert({
    this.id = const Value.absent(),
    required String customerCode,
    required String customerName,
    this.gstNumber = const Value.absent(),
    this.panNumber = const Value.absent(),
    this.mobile = const Value.absent(),
    this.alternateMobile = const Value.absent(),
    this.email = const Value.absent(),
    this.addressLine1 = const Value.absent(),
    this.addressLine2 = const Value.absent(),
    this.city = const Value.absent(),
    this.state = const Value.absent(),
    this.stateCode = const Value.absent(),
    this.country = const Value.absent(),
    this.pincode = const Value.absent(),
    this.creditLimit = const Value.absent(),
    this.openingBalance = const Value.absent(),
    this.outstandingBalance = const Value.absent(),
    this.paymentDueDate = const Value.absent(),
    this.accountName = const Value.absent(),
    this.accountNumber = const Value.absent(),
    this.bankName = const Value.absent(),
    this.branchName = const Value.absent(),
    this.ifscCode = const Value.absent(),
    this.balanceType = const Value.absent(),
    this.notes = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : customerCode = Value(customerCode),
       customerName = Value(customerName);
  static Insertable<Customer> custom({
    Expression<int>? id,
    Expression<String>? customerCode,
    Expression<String>? customerName,
    Expression<String>? gstNumber,
    Expression<String>? panNumber,
    Expression<String>? mobile,
    Expression<String>? alternateMobile,
    Expression<String>? email,
    Expression<String>? addressLine1,
    Expression<String>? addressLine2,
    Expression<String>? city,
    Expression<String>? state,
    Expression<String>? stateCode,
    Expression<String>? country,
    Expression<String>? pincode,
    Expression<int>? creditLimit,
    Expression<int>? openingBalance,
    Expression<int>? outstandingBalance,
    Expression<DateTime>? paymentDueDate,
    Expression<String>? accountName,
    Expression<String>? accountNumber,
    Expression<String>? bankName,
    Expression<String>? branchName,
    Expression<String>? ifscCode,
    Expression<String>? balanceType,
    Expression<String>? notes,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (customerCode != null) 'customer_code': customerCode,
      if (customerName != null) 'customer_name': customerName,
      if (gstNumber != null) 'gst_number': gstNumber,
      if (panNumber != null) 'pan_number': panNumber,
      if (mobile != null) 'mobile': mobile,
      if (alternateMobile != null) 'alternate_mobile': alternateMobile,
      if (email != null) 'email': email,
      if (addressLine1 != null) 'address_line1': addressLine1,
      if (addressLine2 != null) 'address_line2': addressLine2,
      if (city != null) 'city': city,
      if (state != null) 'state': state,
      if (stateCode != null) 'state_code': stateCode,
      if (country != null) 'country': country,
      if (pincode != null) 'pincode': pincode,
      if (creditLimit != null) 'credit_limit': creditLimit,
      if (openingBalance != null) 'opening_balance': openingBalance,
      if (outstandingBalance != null) 'outstanding_balance': outstandingBalance,
      if (paymentDueDate != null) 'payment_due_date': paymentDueDate,
      if (accountName != null) 'account_name': accountName,
      if (accountNumber != null) 'account_number': accountNumber,
      if (bankName != null) 'bank_name': bankName,
      if (branchName != null) 'branch_name': branchName,
      if (ifscCode != null) 'ifsc_code': ifscCode,
      if (balanceType != null) 'balance_type': balanceType,
      if (notes != null) 'notes': notes,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  CustomersCompanion copyWith({
    Value<int>? id,
    Value<String>? customerCode,
    Value<String>? customerName,
    Value<String?>? gstNumber,
    Value<String?>? panNumber,
    Value<String?>? mobile,
    Value<String?>? alternateMobile,
    Value<String?>? email,
    Value<String?>? addressLine1,
    Value<String?>? addressLine2,
    Value<String?>? city,
    Value<String?>? state,
    Value<String?>? stateCode,
    Value<String?>? country,
    Value<String?>? pincode,
    Value<int>? creditLimit,
    Value<int>? openingBalance,
    Value<int>? outstandingBalance,
    Value<DateTime?>? paymentDueDate,
    Value<String?>? accountName,
    Value<String?>? accountNumber,
    Value<String?>? bankName,
    Value<String?>? branchName,
    Value<String?>? ifscCode,
    Value<String>? balanceType,
    Value<String?>? notes,
    Value<bool>? isActive,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return CustomersCompanion(
      id: id ?? this.id,
      customerCode: customerCode ?? this.customerCode,
      customerName: customerName ?? this.customerName,
      gstNumber: gstNumber ?? this.gstNumber,
      panNumber: panNumber ?? this.panNumber,
      mobile: mobile ?? this.mobile,
      alternateMobile: alternateMobile ?? this.alternateMobile,
      email: email ?? this.email,
      addressLine1: addressLine1 ?? this.addressLine1,
      addressLine2: addressLine2 ?? this.addressLine2,
      city: city ?? this.city,
      state: state ?? this.state,
      stateCode: stateCode ?? this.stateCode,
      country: country ?? this.country,
      pincode: pincode ?? this.pincode,
      creditLimit: creditLimit ?? this.creditLimit,
      openingBalance: openingBalance ?? this.openingBalance,
      outstandingBalance: outstandingBalance ?? this.outstandingBalance,
      paymentDueDate: paymentDueDate ?? this.paymentDueDate,
      accountName: accountName ?? this.accountName,
      accountNumber: accountNumber ?? this.accountNumber,
      bankName: bankName ?? this.bankName,
      branchName: branchName ?? this.branchName,
      ifscCode: ifscCode ?? this.ifscCode,
      balanceType: balanceType ?? this.balanceType,
      notes: notes ?? this.notes,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (customerCode.present) {
      map['customer_code'] = Variable<String>(customerCode.value);
    }
    if (customerName.present) {
      map['customer_name'] = Variable<String>(customerName.value);
    }
    if (gstNumber.present) {
      map['gst_number'] = Variable<String>(gstNumber.value);
    }
    if (panNumber.present) {
      map['pan_number'] = Variable<String>(panNumber.value);
    }
    if (mobile.present) {
      map['mobile'] = Variable<String>(mobile.value);
    }
    if (alternateMobile.present) {
      map['alternate_mobile'] = Variable<String>(alternateMobile.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (addressLine1.present) {
      map['address_line1'] = Variable<String>(addressLine1.value);
    }
    if (addressLine2.present) {
      map['address_line2'] = Variable<String>(addressLine2.value);
    }
    if (city.present) {
      map['city'] = Variable<String>(city.value);
    }
    if (state.present) {
      map['state'] = Variable<String>(state.value);
    }
    if (stateCode.present) {
      map['state_code'] = Variable<String>(stateCode.value);
    }
    if (country.present) {
      map['country'] = Variable<String>(country.value);
    }
    if (pincode.present) {
      map['pincode'] = Variable<String>(pincode.value);
    }
    if (creditLimit.present) {
      map['credit_limit'] = Variable<int>(creditLimit.value);
    }
    if (openingBalance.present) {
      map['opening_balance'] = Variable<int>(openingBalance.value);
    }
    if (outstandingBalance.present) {
      map['outstanding_balance'] = Variable<int>(outstandingBalance.value);
    }
    if (paymentDueDate.present) {
      map['payment_due_date'] = Variable<DateTime>(paymentDueDate.value);
    }
    if (accountName.present) {
      map['account_name'] = Variable<String>(accountName.value);
    }
    if (accountNumber.present) {
      map['account_number'] = Variable<String>(accountNumber.value);
    }
    if (bankName.present) {
      map['bank_name'] = Variable<String>(bankName.value);
    }
    if (branchName.present) {
      map['branch_name'] = Variable<String>(branchName.value);
    }
    if (ifscCode.present) {
      map['ifsc_code'] = Variable<String>(ifscCode.value);
    }
    if (balanceType.present) {
      map['balance_type'] = Variable<String>(balanceType.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CustomersCompanion(')
          ..write('id: $id, ')
          ..write('customerCode: $customerCode, ')
          ..write('customerName: $customerName, ')
          ..write('gstNumber: $gstNumber, ')
          ..write('panNumber: $panNumber, ')
          ..write('mobile: $mobile, ')
          ..write('alternateMobile: $alternateMobile, ')
          ..write('email: $email, ')
          ..write('addressLine1: $addressLine1, ')
          ..write('addressLine2: $addressLine2, ')
          ..write('city: $city, ')
          ..write('state: $state, ')
          ..write('stateCode: $stateCode, ')
          ..write('country: $country, ')
          ..write('pincode: $pincode, ')
          ..write('creditLimit: $creditLimit, ')
          ..write('openingBalance: $openingBalance, ')
          ..write('outstandingBalance: $outstandingBalance, ')
          ..write('paymentDueDate: $paymentDueDate, ')
          ..write('accountName: $accountName, ')
          ..write('accountNumber: $accountNumber, ')
          ..write('bankName: $bankName, ')
          ..write('branchName: $branchName, ')
          ..write('ifscCode: $ifscCode, ')
          ..write('balanceType: $balanceType, ')
          ..write('notes: $notes, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $SuppliersTable extends Suppliers
    with TableInfo<$SuppliersTable, Supplier> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SuppliersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _supplierCodeMeta = const VerificationMeta(
    'supplierCode',
  );
  @override
  late final GeneratedColumn<String> supplierCode = GeneratedColumn<String>(
    'supplier_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _supplierNameMeta = const VerificationMeta(
    'supplierName',
  );
  @override
  late final GeneratedColumn<String> supplierName = GeneratedColumn<String>(
    'supplier_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contactPersonMeta = const VerificationMeta(
    'contactPerson',
  );
  @override
  late final GeneratedColumn<String> contactPerson = GeneratedColumn<String>(
    'contact_person',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _gstNumberMeta = const VerificationMeta(
    'gstNumber',
  );
  @override
  late final GeneratedColumn<String> gstNumber = GeneratedColumn<String>(
    'gst_number',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _panNumberMeta = const VerificationMeta(
    'panNumber',
  );
  @override
  late final GeneratedColumn<String> panNumber = GeneratedColumn<String>(
    'pan_number',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _mobileMeta = const VerificationMeta('mobile');
  @override
  late final GeneratedColumn<String> mobile = GeneratedColumn<String>(
    'mobile',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _alternateMobileMeta = const VerificationMeta(
    'alternateMobile',
  );
  @override
  late final GeneratedColumn<String> alternateMobile = GeneratedColumn<String>(
    'alternate_mobile',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _addressLine1Meta = const VerificationMeta(
    'addressLine1',
  );
  @override
  late final GeneratedColumn<String> addressLine1 = GeneratedColumn<String>(
    'address_line1',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _addressLine2Meta = const VerificationMeta(
    'addressLine2',
  );
  @override
  late final GeneratedColumn<String> addressLine2 = GeneratedColumn<String>(
    'address_line2',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cityMeta = const VerificationMeta('city');
  @override
  late final GeneratedColumn<String> city = GeneratedColumn<String>(
    'city',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _stateMeta = const VerificationMeta('state');
  @override
  late final GeneratedColumn<String> state = GeneratedColumn<String>(
    'state',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _stateCodeMeta = const VerificationMeta(
    'stateCode',
  );
  @override
  late final GeneratedColumn<String> stateCode = GeneratedColumn<String>(
    'state_code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _countryMeta = const VerificationMeta(
    'country',
  );
  @override
  late final GeneratedColumn<String> country = GeneratedColumn<String>(
    'country',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pincodeMeta = const VerificationMeta(
    'pincode',
  );
  @override
  late final GeneratedColumn<String> pincode = GeneratedColumn<String>(
    'pincode',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _creditLimitMeta = const VerificationMeta(
    'creditLimit',
  );
  @override
  late final GeneratedColumn<int> creditLimit = GeneratedColumn<int>(
    'credit_limit',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _openingBalanceMeta = const VerificationMeta(
    'openingBalance',
  );
  @override
  late final GeneratedColumn<int> openingBalance = GeneratedColumn<int>(
    'opening_balance',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _outstandingBalanceMeta =
      const VerificationMeta('outstandingBalance');
  @override
  late final GeneratedColumn<int> outstandingBalance = GeneratedColumn<int>(
    'outstanding_balance',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _paymentDueDateMeta = const VerificationMeta(
    'paymentDueDate',
  );
  @override
  late final GeneratedColumn<DateTime> paymentDueDate =
      GeneratedColumn<DateTime>(
        'payment_due_date',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _accountNameMeta = const VerificationMeta(
    'accountName',
  );
  @override
  late final GeneratedColumn<String> accountName = GeneratedColumn<String>(
    'account_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _accountNumberMeta = const VerificationMeta(
    'accountNumber',
  );
  @override
  late final GeneratedColumn<String> accountNumber = GeneratedColumn<String>(
    'account_number',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bankNameMeta = const VerificationMeta(
    'bankName',
  );
  @override
  late final GeneratedColumn<String> bankName = GeneratedColumn<String>(
    'bank_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _branchNameMeta = const VerificationMeta(
    'branchName',
  );
  @override
  late final GeneratedColumn<String> branchName = GeneratedColumn<String>(
    'branch_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ifscCodeMeta = const VerificationMeta(
    'ifscCode',
  );
  @override
  late final GeneratedColumn<String> ifscCode = GeneratedColumn<String>(
    'ifsc_code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _paymentTermsMeta = const VerificationMeta(
    'paymentTerms',
  );
  @override
  late final GeneratedColumn<String> paymentTerms = GeneratedColumn<String>(
    'payment_terms',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _balanceTypeMeta = const VerificationMeta(
    'balanceType',
  );
  @override
  late final GeneratedColumn<String> balanceType = GeneratedColumn<String>(
    'balance_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('DEBIT'),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    supplierCode,
    supplierName,
    contactPerson,
    gstNumber,
    panNumber,
    mobile,
    alternateMobile,
    email,
    addressLine1,
    addressLine2,
    city,
    state,
    stateCode,
    country,
    pincode,
    creditLimit,
    openingBalance,
    outstandingBalance,
    paymentDueDate,
    accountName,
    accountNumber,
    bankName,
    branchName,
    ifscCode,
    paymentTerms,
    balanceType,
    notes,
    isActive,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'supplier';
  @override
  VerificationContext validateIntegrity(
    Insertable<Supplier> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('supplier_code')) {
      context.handle(
        _supplierCodeMeta,
        supplierCode.isAcceptableOrUnknown(
          data['supplier_code']!,
          _supplierCodeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_supplierCodeMeta);
    }
    if (data.containsKey('supplier_name')) {
      context.handle(
        _supplierNameMeta,
        supplierName.isAcceptableOrUnknown(
          data['supplier_name']!,
          _supplierNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_supplierNameMeta);
    }
    if (data.containsKey('contact_person')) {
      context.handle(
        _contactPersonMeta,
        contactPerson.isAcceptableOrUnknown(
          data['contact_person']!,
          _contactPersonMeta,
        ),
      );
    }
    if (data.containsKey('gst_number')) {
      context.handle(
        _gstNumberMeta,
        gstNumber.isAcceptableOrUnknown(data['gst_number']!, _gstNumberMeta),
      );
    }
    if (data.containsKey('pan_number')) {
      context.handle(
        _panNumberMeta,
        panNumber.isAcceptableOrUnknown(data['pan_number']!, _panNumberMeta),
      );
    }
    if (data.containsKey('mobile')) {
      context.handle(
        _mobileMeta,
        mobile.isAcceptableOrUnknown(data['mobile']!, _mobileMeta),
      );
    }
    if (data.containsKey('alternate_mobile')) {
      context.handle(
        _alternateMobileMeta,
        alternateMobile.isAcceptableOrUnknown(
          data['alternate_mobile']!,
          _alternateMobileMeta,
        ),
      );
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    }
    if (data.containsKey('address_line1')) {
      context.handle(
        _addressLine1Meta,
        addressLine1.isAcceptableOrUnknown(
          data['address_line1']!,
          _addressLine1Meta,
        ),
      );
    }
    if (data.containsKey('address_line2')) {
      context.handle(
        _addressLine2Meta,
        addressLine2.isAcceptableOrUnknown(
          data['address_line2']!,
          _addressLine2Meta,
        ),
      );
    }
    if (data.containsKey('city')) {
      context.handle(
        _cityMeta,
        city.isAcceptableOrUnknown(data['city']!, _cityMeta),
      );
    }
    if (data.containsKey('state')) {
      context.handle(
        _stateMeta,
        state.isAcceptableOrUnknown(data['state']!, _stateMeta),
      );
    }
    if (data.containsKey('state_code')) {
      context.handle(
        _stateCodeMeta,
        stateCode.isAcceptableOrUnknown(data['state_code']!, _stateCodeMeta),
      );
    }
    if (data.containsKey('country')) {
      context.handle(
        _countryMeta,
        country.isAcceptableOrUnknown(data['country']!, _countryMeta),
      );
    }
    if (data.containsKey('pincode')) {
      context.handle(
        _pincodeMeta,
        pincode.isAcceptableOrUnknown(data['pincode']!, _pincodeMeta),
      );
    }
    if (data.containsKey('credit_limit')) {
      context.handle(
        _creditLimitMeta,
        creditLimit.isAcceptableOrUnknown(
          data['credit_limit']!,
          _creditLimitMeta,
        ),
      );
    }
    if (data.containsKey('opening_balance')) {
      context.handle(
        _openingBalanceMeta,
        openingBalance.isAcceptableOrUnknown(
          data['opening_balance']!,
          _openingBalanceMeta,
        ),
      );
    }
    if (data.containsKey('outstanding_balance')) {
      context.handle(
        _outstandingBalanceMeta,
        outstandingBalance.isAcceptableOrUnknown(
          data['outstanding_balance']!,
          _outstandingBalanceMeta,
        ),
      );
    }
    if (data.containsKey('payment_due_date')) {
      context.handle(
        _paymentDueDateMeta,
        paymentDueDate.isAcceptableOrUnknown(
          data['payment_due_date']!,
          _paymentDueDateMeta,
        ),
      );
    }
    if (data.containsKey('account_name')) {
      context.handle(
        _accountNameMeta,
        accountName.isAcceptableOrUnknown(
          data['account_name']!,
          _accountNameMeta,
        ),
      );
    }
    if (data.containsKey('account_number')) {
      context.handle(
        _accountNumberMeta,
        accountNumber.isAcceptableOrUnknown(
          data['account_number']!,
          _accountNumberMeta,
        ),
      );
    }
    if (data.containsKey('bank_name')) {
      context.handle(
        _bankNameMeta,
        bankName.isAcceptableOrUnknown(data['bank_name']!, _bankNameMeta),
      );
    }
    if (data.containsKey('branch_name')) {
      context.handle(
        _branchNameMeta,
        branchName.isAcceptableOrUnknown(data['branch_name']!, _branchNameMeta),
      );
    }
    if (data.containsKey('ifsc_code')) {
      context.handle(
        _ifscCodeMeta,
        ifscCode.isAcceptableOrUnknown(data['ifsc_code']!, _ifscCodeMeta),
      );
    }
    if (data.containsKey('payment_terms')) {
      context.handle(
        _paymentTermsMeta,
        paymentTerms.isAcceptableOrUnknown(
          data['payment_terms']!,
          _paymentTermsMeta,
        ),
      );
    }
    if (data.containsKey('balance_type')) {
      context.handle(
        _balanceTypeMeta,
        balanceType.isAcceptableOrUnknown(
          data['balance_type']!,
          _balanceTypeMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Supplier map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Supplier(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      supplierCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}supplier_code'],
      )!,
      supplierName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}supplier_name'],
      )!,
      contactPerson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}contact_person'],
      ),
      gstNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}gst_number'],
      ),
      panNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pan_number'],
      ),
      mobile: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mobile'],
      ),
      alternateMobile: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}alternate_mobile'],
      ),
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      ),
      addressLine1: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address_line1'],
      ),
      addressLine2: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address_line2'],
      ),
      city: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}city'],
      ),
      state: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}state'],
      ),
      stateCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}state_code'],
      ),
      country: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}country'],
      ),
      pincode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pincode'],
      ),
      creditLimit: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}credit_limit'],
      )!,
      openingBalance: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}opening_balance'],
      )!,
      outstandingBalance: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}outstanding_balance'],
      )!,
      paymentDueDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}payment_due_date'],
      ),
      accountName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_name'],
      ),
      accountNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_number'],
      ),
      bankName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bank_name'],
      ),
      branchName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}branch_name'],
      ),
      ifscCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ifsc_code'],
      ),
      paymentTerms: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payment_terms'],
      ),
      balanceType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}balance_type'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $SuppliersTable createAlias(String alias) {
    return $SuppliersTable(attachedDatabase, alias);
  }
}

class Supplier extends DataClass implements Insertable<Supplier> {
  final int id;
  final String supplierCode;
  final String supplierName;
  final String? contactPerson;
  final String? gstNumber;
  final String? panNumber;
  final String? mobile;
  final String? alternateMobile;
  final String? email;
  final String? addressLine1;
  final String? addressLine2;
  final String? city;
  final String? state;
  final String? stateCode;
  final String? country;
  final String? pincode;
  final int creditLimit;
  final int openingBalance;
  final int outstandingBalance;
  final DateTime? paymentDueDate;
  final String? accountName;
  final String? accountNumber;
  final String? bankName;
  final String? branchName;
  final String? ifscCode;

  /// Payment terms such as `Net 30` or `Cash on Delivery`.
  final String? paymentTerms;

  /// `DEBIT` or `CREDIT` — see the shared `BalanceType` enum.
  final String balanceType;
  final String? notes;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Supplier({
    required this.id,
    required this.supplierCode,
    required this.supplierName,
    this.contactPerson,
    this.gstNumber,
    this.panNumber,
    this.mobile,
    this.alternateMobile,
    this.email,
    this.addressLine1,
    this.addressLine2,
    this.city,
    this.state,
    this.stateCode,
    this.country,
    this.pincode,
    required this.creditLimit,
    required this.openingBalance,
    required this.outstandingBalance,
    this.paymentDueDate,
    this.accountName,
    this.accountNumber,
    this.bankName,
    this.branchName,
    this.ifscCode,
    this.paymentTerms,
    required this.balanceType,
    this.notes,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['supplier_code'] = Variable<String>(supplierCode);
    map['supplier_name'] = Variable<String>(supplierName);
    if (!nullToAbsent || contactPerson != null) {
      map['contact_person'] = Variable<String>(contactPerson);
    }
    if (!nullToAbsent || gstNumber != null) {
      map['gst_number'] = Variable<String>(gstNumber);
    }
    if (!nullToAbsent || panNumber != null) {
      map['pan_number'] = Variable<String>(panNumber);
    }
    if (!nullToAbsent || mobile != null) {
      map['mobile'] = Variable<String>(mobile);
    }
    if (!nullToAbsent || alternateMobile != null) {
      map['alternate_mobile'] = Variable<String>(alternateMobile);
    }
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || addressLine1 != null) {
      map['address_line1'] = Variable<String>(addressLine1);
    }
    if (!nullToAbsent || addressLine2 != null) {
      map['address_line2'] = Variable<String>(addressLine2);
    }
    if (!nullToAbsent || city != null) {
      map['city'] = Variable<String>(city);
    }
    if (!nullToAbsent || state != null) {
      map['state'] = Variable<String>(state);
    }
    if (!nullToAbsent || stateCode != null) {
      map['state_code'] = Variable<String>(stateCode);
    }
    if (!nullToAbsent || country != null) {
      map['country'] = Variable<String>(country);
    }
    if (!nullToAbsent || pincode != null) {
      map['pincode'] = Variable<String>(pincode);
    }
    map['credit_limit'] = Variable<int>(creditLimit);
    map['opening_balance'] = Variable<int>(openingBalance);
    map['outstanding_balance'] = Variable<int>(outstandingBalance);
    if (!nullToAbsent || paymentDueDate != null) {
      map['payment_due_date'] = Variable<DateTime>(paymentDueDate);
    }
    if (!nullToAbsent || accountName != null) {
      map['account_name'] = Variable<String>(accountName);
    }
    if (!nullToAbsent || accountNumber != null) {
      map['account_number'] = Variable<String>(accountNumber);
    }
    if (!nullToAbsent || bankName != null) {
      map['bank_name'] = Variable<String>(bankName);
    }
    if (!nullToAbsent || branchName != null) {
      map['branch_name'] = Variable<String>(branchName);
    }
    if (!nullToAbsent || ifscCode != null) {
      map['ifsc_code'] = Variable<String>(ifscCode);
    }
    if (!nullToAbsent || paymentTerms != null) {
      map['payment_terms'] = Variable<String>(paymentTerms);
    }
    map['balance_type'] = Variable<String>(balanceType);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  SuppliersCompanion toCompanion(bool nullToAbsent) {
    return SuppliersCompanion(
      id: Value(id),
      supplierCode: Value(supplierCode),
      supplierName: Value(supplierName),
      contactPerson: contactPerson == null && nullToAbsent
          ? const Value.absent()
          : Value(contactPerson),
      gstNumber: gstNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(gstNumber),
      panNumber: panNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(panNumber),
      mobile: mobile == null && nullToAbsent
          ? const Value.absent()
          : Value(mobile),
      alternateMobile: alternateMobile == null && nullToAbsent
          ? const Value.absent()
          : Value(alternateMobile),
      email: email == null && nullToAbsent
          ? const Value.absent()
          : Value(email),
      addressLine1: addressLine1 == null && nullToAbsent
          ? const Value.absent()
          : Value(addressLine1),
      addressLine2: addressLine2 == null && nullToAbsent
          ? const Value.absent()
          : Value(addressLine2),
      city: city == null && nullToAbsent ? const Value.absent() : Value(city),
      state: state == null && nullToAbsent
          ? const Value.absent()
          : Value(state),
      stateCode: stateCode == null && nullToAbsent
          ? const Value.absent()
          : Value(stateCode),
      country: country == null && nullToAbsent
          ? const Value.absent()
          : Value(country),
      pincode: pincode == null && nullToAbsent
          ? const Value.absent()
          : Value(pincode),
      creditLimit: Value(creditLimit),
      openingBalance: Value(openingBalance),
      outstandingBalance: Value(outstandingBalance),
      paymentDueDate: paymentDueDate == null && nullToAbsent
          ? const Value.absent()
          : Value(paymentDueDate),
      accountName: accountName == null && nullToAbsent
          ? const Value.absent()
          : Value(accountName),
      accountNumber: accountNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(accountNumber),
      bankName: bankName == null && nullToAbsent
          ? const Value.absent()
          : Value(bankName),
      branchName: branchName == null && nullToAbsent
          ? const Value.absent()
          : Value(branchName),
      ifscCode: ifscCode == null && nullToAbsent
          ? const Value.absent()
          : Value(ifscCode),
      paymentTerms: paymentTerms == null && nullToAbsent
          ? const Value.absent()
          : Value(paymentTerms),
      balanceType: Value(balanceType),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Supplier.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Supplier(
      id: serializer.fromJson<int>(json['id']),
      supplierCode: serializer.fromJson<String>(json['supplierCode']),
      supplierName: serializer.fromJson<String>(json['supplierName']),
      contactPerson: serializer.fromJson<String?>(json['contactPerson']),
      gstNumber: serializer.fromJson<String?>(json['gstNumber']),
      panNumber: serializer.fromJson<String?>(json['panNumber']),
      mobile: serializer.fromJson<String?>(json['mobile']),
      alternateMobile: serializer.fromJson<String?>(json['alternateMobile']),
      email: serializer.fromJson<String?>(json['email']),
      addressLine1: serializer.fromJson<String?>(json['addressLine1']),
      addressLine2: serializer.fromJson<String?>(json['addressLine2']),
      city: serializer.fromJson<String?>(json['city']),
      state: serializer.fromJson<String?>(json['state']),
      stateCode: serializer.fromJson<String?>(json['stateCode']),
      country: serializer.fromJson<String?>(json['country']),
      pincode: serializer.fromJson<String?>(json['pincode']),
      creditLimit: serializer.fromJson<int>(json['creditLimit']),
      openingBalance: serializer.fromJson<int>(json['openingBalance']),
      outstandingBalance: serializer.fromJson<int>(json['outstandingBalance']),
      paymentDueDate: serializer.fromJson<DateTime?>(json['paymentDueDate']),
      accountName: serializer.fromJson<String?>(json['accountName']),
      accountNumber: serializer.fromJson<String?>(json['accountNumber']),
      bankName: serializer.fromJson<String?>(json['bankName']),
      branchName: serializer.fromJson<String?>(json['branchName']),
      ifscCode: serializer.fromJson<String?>(json['ifscCode']),
      paymentTerms: serializer.fromJson<String?>(json['paymentTerms']),
      balanceType: serializer.fromJson<String>(json['balanceType']),
      notes: serializer.fromJson<String?>(json['notes']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'supplierCode': serializer.toJson<String>(supplierCode),
      'supplierName': serializer.toJson<String>(supplierName),
      'contactPerson': serializer.toJson<String?>(contactPerson),
      'gstNumber': serializer.toJson<String?>(gstNumber),
      'panNumber': serializer.toJson<String?>(panNumber),
      'mobile': serializer.toJson<String?>(mobile),
      'alternateMobile': serializer.toJson<String?>(alternateMobile),
      'email': serializer.toJson<String?>(email),
      'addressLine1': serializer.toJson<String?>(addressLine1),
      'addressLine2': serializer.toJson<String?>(addressLine2),
      'city': serializer.toJson<String?>(city),
      'state': serializer.toJson<String?>(state),
      'stateCode': serializer.toJson<String?>(stateCode),
      'country': serializer.toJson<String?>(country),
      'pincode': serializer.toJson<String?>(pincode),
      'creditLimit': serializer.toJson<int>(creditLimit),
      'openingBalance': serializer.toJson<int>(openingBalance),
      'outstandingBalance': serializer.toJson<int>(outstandingBalance),
      'paymentDueDate': serializer.toJson<DateTime?>(paymentDueDate),
      'accountName': serializer.toJson<String?>(accountName),
      'accountNumber': serializer.toJson<String?>(accountNumber),
      'bankName': serializer.toJson<String?>(bankName),
      'branchName': serializer.toJson<String?>(branchName),
      'ifscCode': serializer.toJson<String?>(ifscCode),
      'paymentTerms': serializer.toJson<String?>(paymentTerms),
      'balanceType': serializer.toJson<String>(balanceType),
      'notes': serializer.toJson<String?>(notes),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Supplier copyWith({
    int? id,
    String? supplierCode,
    String? supplierName,
    Value<String?> contactPerson = const Value.absent(),
    Value<String?> gstNumber = const Value.absent(),
    Value<String?> panNumber = const Value.absent(),
    Value<String?> mobile = const Value.absent(),
    Value<String?> alternateMobile = const Value.absent(),
    Value<String?> email = const Value.absent(),
    Value<String?> addressLine1 = const Value.absent(),
    Value<String?> addressLine2 = const Value.absent(),
    Value<String?> city = const Value.absent(),
    Value<String?> state = const Value.absent(),
    Value<String?> stateCode = const Value.absent(),
    Value<String?> country = const Value.absent(),
    Value<String?> pincode = const Value.absent(),
    int? creditLimit,
    int? openingBalance,
    int? outstandingBalance,
    Value<DateTime?> paymentDueDate = const Value.absent(),
    Value<String?> accountName = const Value.absent(),
    Value<String?> accountNumber = const Value.absent(),
    Value<String?> bankName = const Value.absent(),
    Value<String?> branchName = const Value.absent(),
    Value<String?> ifscCode = const Value.absent(),
    Value<String?> paymentTerms = const Value.absent(),
    String? balanceType,
    Value<String?> notes = const Value.absent(),
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Supplier(
    id: id ?? this.id,
    supplierCode: supplierCode ?? this.supplierCode,
    supplierName: supplierName ?? this.supplierName,
    contactPerson: contactPerson.present
        ? contactPerson.value
        : this.contactPerson,
    gstNumber: gstNumber.present ? gstNumber.value : this.gstNumber,
    panNumber: panNumber.present ? panNumber.value : this.panNumber,
    mobile: mobile.present ? mobile.value : this.mobile,
    alternateMobile: alternateMobile.present
        ? alternateMobile.value
        : this.alternateMobile,
    email: email.present ? email.value : this.email,
    addressLine1: addressLine1.present ? addressLine1.value : this.addressLine1,
    addressLine2: addressLine2.present ? addressLine2.value : this.addressLine2,
    city: city.present ? city.value : this.city,
    state: state.present ? state.value : this.state,
    stateCode: stateCode.present ? stateCode.value : this.stateCode,
    country: country.present ? country.value : this.country,
    pincode: pincode.present ? pincode.value : this.pincode,
    creditLimit: creditLimit ?? this.creditLimit,
    openingBalance: openingBalance ?? this.openingBalance,
    outstandingBalance: outstandingBalance ?? this.outstandingBalance,
    paymentDueDate: paymentDueDate.present
        ? paymentDueDate.value
        : this.paymentDueDate,
    accountName: accountName.present ? accountName.value : this.accountName,
    accountNumber: accountNumber.present
        ? accountNumber.value
        : this.accountNumber,
    bankName: bankName.present ? bankName.value : this.bankName,
    branchName: branchName.present ? branchName.value : this.branchName,
    ifscCode: ifscCode.present ? ifscCode.value : this.ifscCode,
    paymentTerms: paymentTerms.present ? paymentTerms.value : this.paymentTerms,
    balanceType: balanceType ?? this.balanceType,
    notes: notes.present ? notes.value : this.notes,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Supplier copyWithCompanion(SuppliersCompanion data) {
    return Supplier(
      id: data.id.present ? data.id.value : this.id,
      supplierCode: data.supplierCode.present
          ? data.supplierCode.value
          : this.supplierCode,
      supplierName: data.supplierName.present
          ? data.supplierName.value
          : this.supplierName,
      contactPerson: data.contactPerson.present
          ? data.contactPerson.value
          : this.contactPerson,
      gstNumber: data.gstNumber.present ? data.gstNumber.value : this.gstNumber,
      panNumber: data.panNumber.present ? data.panNumber.value : this.panNumber,
      mobile: data.mobile.present ? data.mobile.value : this.mobile,
      alternateMobile: data.alternateMobile.present
          ? data.alternateMobile.value
          : this.alternateMobile,
      email: data.email.present ? data.email.value : this.email,
      addressLine1: data.addressLine1.present
          ? data.addressLine1.value
          : this.addressLine1,
      addressLine2: data.addressLine2.present
          ? data.addressLine2.value
          : this.addressLine2,
      city: data.city.present ? data.city.value : this.city,
      state: data.state.present ? data.state.value : this.state,
      stateCode: data.stateCode.present ? data.stateCode.value : this.stateCode,
      country: data.country.present ? data.country.value : this.country,
      pincode: data.pincode.present ? data.pincode.value : this.pincode,
      creditLimit: data.creditLimit.present
          ? data.creditLimit.value
          : this.creditLimit,
      openingBalance: data.openingBalance.present
          ? data.openingBalance.value
          : this.openingBalance,
      outstandingBalance: data.outstandingBalance.present
          ? data.outstandingBalance.value
          : this.outstandingBalance,
      paymentDueDate: data.paymentDueDate.present
          ? data.paymentDueDate.value
          : this.paymentDueDate,
      accountName: data.accountName.present
          ? data.accountName.value
          : this.accountName,
      accountNumber: data.accountNumber.present
          ? data.accountNumber.value
          : this.accountNumber,
      bankName: data.bankName.present ? data.bankName.value : this.bankName,
      branchName: data.branchName.present
          ? data.branchName.value
          : this.branchName,
      ifscCode: data.ifscCode.present ? data.ifscCode.value : this.ifscCode,
      paymentTerms: data.paymentTerms.present
          ? data.paymentTerms.value
          : this.paymentTerms,
      balanceType: data.balanceType.present
          ? data.balanceType.value
          : this.balanceType,
      notes: data.notes.present ? data.notes.value : this.notes,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Supplier(')
          ..write('id: $id, ')
          ..write('supplierCode: $supplierCode, ')
          ..write('supplierName: $supplierName, ')
          ..write('contactPerson: $contactPerson, ')
          ..write('gstNumber: $gstNumber, ')
          ..write('panNumber: $panNumber, ')
          ..write('mobile: $mobile, ')
          ..write('alternateMobile: $alternateMobile, ')
          ..write('email: $email, ')
          ..write('addressLine1: $addressLine1, ')
          ..write('addressLine2: $addressLine2, ')
          ..write('city: $city, ')
          ..write('state: $state, ')
          ..write('stateCode: $stateCode, ')
          ..write('country: $country, ')
          ..write('pincode: $pincode, ')
          ..write('creditLimit: $creditLimit, ')
          ..write('openingBalance: $openingBalance, ')
          ..write('outstandingBalance: $outstandingBalance, ')
          ..write('paymentDueDate: $paymentDueDate, ')
          ..write('accountName: $accountName, ')
          ..write('accountNumber: $accountNumber, ')
          ..write('bankName: $bankName, ')
          ..write('branchName: $branchName, ')
          ..write('ifscCode: $ifscCode, ')
          ..write('paymentTerms: $paymentTerms, ')
          ..write('balanceType: $balanceType, ')
          ..write('notes: $notes, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    supplierCode,
    supplierName,
    contactPerson,
    gstNumber,
    panNumber,
    mobile,
    alternateMobile,
    email,
    addressLine1,
    addressLine2,
    city,
    state,
    stateCode,
    country,
    pincode,
    creditLimit,
    openingBalance,
    outstandingBalance,
    paymentDueDate,
    accountName,
    accountNumber,
    bankName,
    branchName,
    ifscCode,
    paymentTerms,
    balanceType,
    notes,
    isActive,
    createdAt,
    updatedAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Supplier &&
          other.id == this.id &&
          other.supplierCode == this.supplierCode &&
          other.supplierName == this.supplierName &&
          other.contactPerson == this.contactPerson &&
          other.gstNumber == this.gstNumber &&
          other.panNumber == this.panNumber &&
          other.mobile == this.mobile &&
          other.alternateMobile == this.alternateMobile &&
          other.email == this.email &&
          other.addressLine1 == this.addressLine1 &&
          other.addressLine2 == this.addressLine2 &&
          other.city == this.city &&
          other.state == this.state &&
          other.stateCode == this.stateCode &&
          other.country == this.country &&
          other.pincode == this.pincode &&
          other.creditLimit == this.creditLimit &&
          other.openingBalance == this.openingBalance &&
          other.outstandingBalance == this.outstandingBalance &&
          other.paymentDueDate == this.paymentDueDate &&
          other.accountName == this.accountName &&
          other.accountNumber == this.accountNumber &&
          other.bankName == this.bankName &&
          other.branchName == this.branchName &&
          other.ifscCode == this.ifscCode &&
          other.paymentTerms == this.paymentTerms &&
          other.balanceType == this.balanceType &&
          other.notes == this.notes &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class SuppliersCompanion extends UpdateCompanion<Supplier> {
  final Value<int> id;
  final Value<String> supplierCode;
  final Value<String> supplierName;
  final Value<String?> contactPerson;
  final Value<String?> gstNumber;
  final Value<String?> panNumber;
  final Value<String?> mobile;
  final Value<String?> alternateMobile;
  final Value<String?> email;
  final Value<String?> addressLine1;
  final Value<String?> addressLine2;
  final Value<String?> city;
  final Value<String?> state;
  final Value<String?> stateCode;
  final Value<String?> country;
  final Value<String?> pincode;
  final Value<int> creditLimit;
  final Value<int> openingBalance;
  final Value<int> outstandingBalance;
  final Value<DateTime?> paymentDueDate;
  final Value<String?> accountName;
  final Value<String?> accountNumber;
  final Value<String?> bankName;
  final Value<String?> branchName;
  final Value<String?> ifscCode;
  final Value<String?> paymentTerms;
  final Value<String> balanceType;
  final Value<String?> notes;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const SuppliersCompanion({
    this.id = const Value.absent(),
    this.supplierCode = const Value.absent(),
    this.supplierName = const Value.absent(),
    this.contactPerson = const Value.absent(),
    this.gstNumber = const Value.absent(),
    this.panNumber = const Value.absent(),
    this.mobile = const Value.absent(),
    this.alternateMobile = const Value.absent(),
    this.email = const Value.absent(),
    this.addressLine1 = const Value.absent(),
    this.addressLine2 = const Value.absent(),
    this.city = const Value.absent(),
    this.state = const Value.absent(),
    this.stateCode = const Value.absent(),
    this.country = const Value.absent(),
    this.pincode = const Value.absent(),
    this.creditLimit = const Value.absent(),
    this.openingBalance = const Value.absent(),
    this.outstandingBalance = const Value.absent(),
    this.paymentDueDate = const Value.absent(),
    this.accountName = const Value.absent(),
    this.accountNumber = const Value.absent(),
    this.bankName = const Value.absent(),
    this.branchName = const Value.absent(),
    this.ifscCode = const Value.absent(),
    this.paymentTerms = const Value.absent(),
    this.balanceType = const Value.absent(),
    this.notes = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  SuppliersCompanion.insert({
    this.id = const Value.absent(),
    required String supplierCode,
    required String supplierName,
    this.contactPerson = const Value.absent(),
    this.gstNumber = const Value.absent(),
    this.panNumber = const Value.absent(),
    this.mobile = const Value.absent(),
    this.alternateMobile = const Value.absent(),
    this.email = const Value.absent(),
    this.addressLine1 = const Value.absent(),
    this.addressLine2 = const Value.absent(),
    this.city = const Value.absent(),
    this.state = const Value.absent(),
    this.stateCode = const Value.absent(),
    this.country = const Value.absent(),
    this.pincode = const Value.absent(),
    this.creditLimit = const Value.absent(),
    this.openingBalance = const Value.absent(),
    this.outstandingBalance = const Value.absent(),
    this.paymentDueDate = const Value.absent(),
    this.accountName = const Value.absent(),
    this.accountNumber = const Value.absent(),
    this.bankName = const Value.absent(),
    this.branchName = const Value.absent(),
    this.ifscCode = const Value.absent(),
    this.paymentTerms = const Value.absent(),
    this.balanceType = const Value.absent(),
    this.notes = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : supplierCode = Value(supplierCode),
       supplierName = Value(supplierName);
  static Insertable<Supplier> custom({
    Expression<int>? id,
    Expression<String>? supplierCode,
    Expression<String>? supplierName,
    Expression<String>? contactPerson,
    Expression<String>? gstNumber,
    Expression<String>? panNumber,
    Expression<String>? mobile,
    Expression<String>? alternateMobile,
    Expression<String>? email,
    Expression<String>? addressLine1,
    Expression<String>? addressLine2,
    Expression<String>? city,
    Expression<String>? state,
    Expression<String>? stateCode,
    Expression<String>? country,
    Expression<String>? pincode,
    Expression<int>? creditLimit,
    Expression<int>? openingBalance,
    Expression<int>? outstandingBalance,
    Expression<DateTime>? paymentDueDate,
    Expression<String>? accountName,
    Expression<String>? accountNumber,
    Expression<String>? bankName,
    Expression<String>? branchName,
    Expression<String>? ifscCode,
    Expression<String>? paymentTerms,
    Expression<String>? balanceType,
    Expression<String>? notes,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (supplierCode != null) 'supplier_code': supplierCode,
      if (supplierName != null) 'supplier_name': supplierName,
      if (contactPerson != null) 'contact_person': contactPerson,
      if (gstNumber != null) 'gst_number': gstNumber,
      if (panNumber != null) 'pan_number': panNumber,
      if (mobile != null) 'mobile': mobile,
      if (alternateMobile != null) 'alternate_mobile': alternateMobile,
      if (email != null) 'email': email,
      if (addressLine1 != null) 'address_line1': addressLine1,
      if (addressLine2 != null) 'address_line2': addressLine2,
      if (city != null) 'city': city,
      if (state != null) 'state': state,
      if (stateCode != null) 'state_code': stateCode,
      if (country != null) 'country': country,
      if (pincode != null) 'pincode': pincode,
      if (creditLimit != null) 'credit_limit': creditLimit,
      if (openingBalance != null) 'opening_balance': openingBalance,
      if (outstandingBalance != null) 'outstanding_balance': outstandingBalance,
      if (paymentDueDate != null) 'payment_due_date': paymentDueDate,
      if (accountName != null) 'account_name': accountName,
      if (accountNumber != null) 'account_number': accountNumber,
      if (bankName != null) 'bank_name': bankName,
      if (branchName != null) 'branch_name': branchName,
      if (ifscCode != null) 'ifsc_code': ifscCode,
      if (paymentTerms != null) 'payment_terms': paymentTerms,
      if (balanceType != null) 'balance_type': balanceType,
      if (notes != null) 'notes': notes,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  SuppliersCompanion copyWith({
    Value<int>? id,
    Value<String>? supplierCode,
    Value<String>? supplierName,
    Value<String?>? contactPerson,
    Value<String?>? gstNumber,
    Value<String?>? panNumber,
    Value<String?>? mobile,
    Value<String?>? alternateMobile,
    Value<String?>? email,
    Value<String?>? addressLine1,
    Value<String?>? addressLine2,
    Value<String?>? city,
    Value<String?>? state,
    Value<String?>? stateCode,
    Value<String?>? country,
    Value<String?>? pincode,
    Value<int>? creditLimit,
    Value<int>? openingBalance,
    Value<int>? outstandingBalance,
    Value<DateTime?>? paymentDueDate,
    Value<String?>? accountName,
    Value<String?>? accountNumber,
    Value<String?>? bankName,
    Value<String?>? branchName,
    Value<String?>? ifscCode,
    Value<String?>? paymentTerms,
    Value<String>? balanceType,
    Value<String?>? notes,
    Value<bool>? isActive,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return SuppliersCompanion(
      id: id ?? this.id,
      supplierCode: supplierCode ?? this.supplierCode,
      supplierName: supplierName ?? this.supplierName,
      contactPerson: contactPerson ?? this.contactPerson,
      gstNumber: gstNumber ?? this.gstNumber,
      panNumber: panNumber ?? this.panNumber,
      mobile: mobile ?? this.mobile,
      alternateMobile: alternateMobile ?? this.alternateMobile,
      email: email ?? this.email,
      addressLine1: addressLine1 ?? this.addressLine1,
      addressLine2: addressLine2 ?? this.addressLine2,
      city: city ?? this.city,
      state: state ?? this.state,
      stateCode: stateCode ?? this.stateCode,
      country: country ?? this.country,
      pincode: pincode ?? this.pincode,
      creditLimit: creditLimit ?? this.creditLimit,
      openingBalance: openingBalance ?? this.openingBalance,
      outstandingBalance: outstandingBalance ?? this.outstandingBalance,
      paymentDueDate: paymentDueDate ?? this.paymentDueDate,
      accountName: accountName ?? this.accountName,
      accountNumber: accountNumber ?? this.accountNumber,
      bankName: bankName ?? this.bankName,
      branchName: branchName ?? this.branchName,
      ifscCode: ifscCode ?? this.ifscCode,
      paymentTerms: paymentTerms ?? this.paymentTerms,
      balanceType: balanceType ?? this.balanceType,
      notes: notes ?? this.notes,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (supplierCode.present) {
      map['supplier_code'] = Variable<String>(supplierCode.value);
    }
    if (supplierName.present) {
      map['supplier_name'] = Variable<String>(supplierName.value);
    }
    if (contactPerson.present) {
      map['contact_person'] = Variable<String>(contactPerson.value);
    }
    if (gstNumber.present) {
      map['gst_number'] = Variable<String>(gstNumber.value);
    }
    if (panNumber.present) {
      map['pan_number'] = Variable<String>(panNumber.value);
    }
    if (mobile.present) {
      map['mobile'] = Variable<String>(mobile.value);
    }
    if (alternateMobile.present) {
      map['alternate_mobile'] = Variable<String>(alternateMobile.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (addressLine1.present) {
      map['address_line1'] = Variable<String>(addressLine1.value);
    }
    if (addressLine2.present) {
      map['address_line2'] = Variable<String>(addressLine2.value);
    }
    if (city.present) {
      map['city'] = Variable<String>(city.value);
    }
    if (state.present) {
      map['state'] = Variable<String>(state.value);
    }
    if (stateCode.present) {
      map['state_code'] = Variable<String>(stateCode.value);
    }
    if (country.present) {
      map['country'] = Variable<String>(country.value);
    }
    if (pincode.present) {
      map['pincode'] = Variable<String>(pincode.value);
    }
    if (creditLimit.present) {
      map['credit_limit'] = Variable<int>(creditLimit.value);
    }
    if (openingBalance.present) {
      map['opening_balance'] = Variable<int>(openingBalance.value);
    }
    if (outstandingBalance.present) {
      map['outstanding_balance'] = Variable<int>(outstandingBalance.value);
    }
    if (paymentDueDate.present) {
      map['payment_due_date'] = Variable<DateTime>(paymentDueDate.value);
    }
    if (accountName.present) {
      map['account_name'] = Variable<String>(accountName.value);
    }
    if (accountNumber.present) {
      map['account_number'] = Variable<String>(accountNumber.value);
    }
    if (bankName.present) {
      map['bank_name'] = Variable<String>(bankName.value);
    }
    if (branchName.present) {
      map['branch_name'] = Variable<String>(branchName.value);
    }
    if (ifscCode.present) {
      map['ifsc_code'] = Variable<String>(ifscCode.value);
    }
    if (paymentTerms.present) {
      map['payment_terms'] = Variable<String>(paymentTerms.value);
    }
    if (balanceType.present) {
      map['balance_type'] = Variable<String>(balanceType.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SuppliersCompanion(')
          ..write('id: $id, ')
          ..write('supplierCode: $supplierCode, ')
          ..write('supplierName: $supplierName, ')
          ..write('contactPerson: $contactPerson, ')
          ..write('gstNumber: $gstNumber, ')
          ..write('panNumber: $panNumber, ')
          ..write('mobile: $mobile, ')
          ..write('alternateMobile: $alternateMobile, ')
          ..write('email: $email, ')
          ..write('addressLine1: $addressLine1, ')
          ..write('addressLine2: $addressLine2, ')
          ..write('city: $city, ')
          ..write('state: $state, ')
          ..write('stateCode: $stateCode, ')
          ..write('country: $country, ')
          ..write('pincode: $pincode, ')
          ..write('creditLimit: $creditLimit, ')
          ..write('openingBalance: $openingBalance, ')
          ..write('outstandingBalance: $outstandingBalance, ')
          ..write('paymentDueDate: $paymentDueDate, ')
          ..write('accountName: $accountName, ')
          ..write('accountNumber: $accountNumber, ')
          ..write('bankName: $bankName, ')
          ..write('branchName: $branchName, ')
          ..write('ifscCode: $ifscCode, ')
          ..write('paymentTerms: $paymentTerms, ')
          ..write('balanceType: $balanceType, ')
          ..write('notes: $notes, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $ProductsTable extends Products with TableInfo<$ProductsTable, Product> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _productCodeMeta = const VerificationMeta(
    'productCode',
  );
  @override
  late final GeneratedColumn<String> productCode = GeneratedColumn<String>(
    'product_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _productNameMeta = const VerificationMeta(
    'productName',
  );
  @override
  late final GeneratedColumn<String> productName = GeneratedColumn<String>(
    'product_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
    'category_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES category (id)',
    ),
  );
  static const VerificationMeta _subCategoryIdMeta = const VerificationMeta(
    'subCategoryId',
  );
  @override
  late final GeneratedColumn<int> subCategoryId = GeneratedColumn<int>(
    'sub_category_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES sub_category (id)',
    ),
  );
  static const VerificationMeta _brandIdMeta = const VerificationMeta(
    'brandId',
  );
  @override
  late final GeneratedColumn<int> brandId = GeneratedColumn<int>(
    'brand_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES brand (id)',
    ),
  );
  static const VerificationMeta _unitIdMeta = const VerificationMeta('unitId');
  @override
  late final GeneratedColumn<int> unitId = GeneratedColumn<int>(
    'unit_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES unit (id)',
    ),
  );
  static const VerificationMeta _sellingPriceMeta = const VerificationMeta(
    'sellingPrice',
  );
  @override
  late final GeneratedColumn<int> sellingPrice = GeneratedColumn<int>(
    'selling_price',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _purchasePriceMeta = const VerificationMeta(
    'purchasePrice',
  );
  @override
  late final GeneratedColumn<int> purchasePrice = GeneratedColumn<int>(
    'purchase_price',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _mrpMeta = const VerificationMeta('mrp');
  @override
  late final GeneratedColumn<int> mrp = GeneratedColumn<int>(
    'mrp',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _wholesalePriceMeta = const VerificationMeta(
    'wholesalePrice',
  );
  @override
  late final GeneratedColumn<int> wholesalePrice = GeneratedColumn<int>(
    'wholesale_price',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _barcodeMeta = const VerificationMeta(
    'barcode',
  );
  @override
  late final GeneratedColumn<String> barcode = GeneratedColumn<String>(
    'barcode',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hsnCodeMeta = const VerificationMeta(
    'hsnCode',
  );
  @override
  late final GeneratedColumn<String> hsnCode = GeneratedColumn<String>(
    'hsn_code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _taxTypeIdMeta = const VerificationMeta(
    'taxTypeId',
  );
  @override
  late final GeneratedColumn<int> taxTypeId = GeneratedColumn<int>(
    'tax_type_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES tax_type (id)',
    ),
  );
  static const VerificationMeta _taxCategoryIdMeta = const VerificationMeta(
    'taxCategoryId',
  );
  @override
  late final GeneratedColumn<int> taxCategoryId = GeneratedColumn<int>(
    'tax_category_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES tax_category (id)',
    ),
  );
  static const VerificationMeta _expiryDateMeta = const VerificationMeta(
    'expiryDate',
  );
  @override
  late final GeneratedColumn<DateTime> expiryDate = GeneratedColumn<DateTime>(
    'expiry_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    productCode,
    productName,
    categoryId,
    subCategoryId,
    brandId,
    unitId,
    sellingPrice,
    purchasePrice,
    mrp,
    wholesalePrice,
    barcode,
    hsnCode,
    taxTypeId,
    taxCategoryId,
    expiryDate,
    notes,
    isActive,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'product';
  @override
  VerificationContext validateIntegrity(
    Insertable<Product> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('product_code')) {
      context.handle(
        _productCodeMeta,
        productCode.isAcceptableOrUnknown(
          data['product_code']!,
          _productCodeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_productCodeMeta);
    }
    if (data.containsKey('product_name')) {
      context.handle(
        _productNameMeta,
        productName.isAcceptableOrUnknown(
          data['product_name']!,
          _productNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_productNameMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    }
    if (data.containsKey('sub_category_id')) {
      context.handle(
        _subCategoryIdMeta,
        subCategoryId.isAcceptableOrUnknown(
          data['sub_category_id']!,
          _subCategoryIdMeta,
        ),
      );
    }
    if (data.containsKey('brand_id')) {
      context.handle(
        _brandIdMeta,
        brandId.isAcceptableOrUnknown(data['brand_id']!, _brandIdMeta),
      );
    }
    if (data.containsKey('unit_id')) {
      context.handle(
        _unitIdMeta,
        unitId.isAcceptableOrUnknown(data['unit_id']!, _unitIdMeta),
      );
    } else if (isInserting) {
      context.missing(_unitIdMeta);
    }
    if (data.containsKey('selling_price')) {
      context.handle(
        _sellingPriceMeta,
        sellingPrice.isAcceptableOrUnknown(
          data['selling_price']!,
          _sellingPriceMeta,
        ),
      );
    }
    if (data.containsKey('purchase_price')) {
      context.handle(
        _purchasePriceMeta,
        purchasePrice.isAcceptableOrUnknown(
          data['purchase_price']!,
          _purchasePriceMeta,
        ),
      );
    }
    if (data.containsKey('mrp')) {
      context.handle(
        _mrpMeta,
        mrp.isAcceptableOrUnknown(data['mrp']!, _mrpMeta),
      );
    }
    if (data.containsKey('wholesale_price')) {
      context.handle(
        _wholesalePriceMeta,
        wholesalePrice.isAcceptableOrUnknown(
          data['wholesale_price']!,
          _wholesalePriceMeta,
        ),
      );
    }
    if (data.containsKey('barcode')) {
      context.handle(
        _barcodeMeta,
        barcode.isAcceptableOrUnknown(data['barcode']!, _barcodeMeta),
      );
    }
    if (data.containsKey('hsn_code')) {
      context.handle(
        _hsnCodeMeta,
        hsnCode.isAcceptableOrUnknown(data['hsn_code']!, _hsnCodeMeta),
      );
    }
    if (data.containsKey('tax_type_id')) {
      context.handle(
        _taxTypeIdMeta,
        taxTypeId.isAcceptableOrUnknown(data['tax_type_id']!, _taxTypeIdMeta),
      );
    }
    if (data.containsKey('tax_category_id')) {
      context.handle(
        _taxCategoryIdMeta,
        taxCategoryId.isAcceptableOrUnknown(
          data['tax_category_id']!,
          _taxCategoryIdMeta,
        ),
      );
    }
    if (data.containsKey('expiry_date')) {
      context.handle(
        _expiryDateMeta,
        expiryDate.isAcceptableOrUnknown(data['expiry_date']!, _expiryDateMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Product map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Product(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      productCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_code'],
      )!,
      productName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_name'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}category_id'],
      ),
      subCategoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sub_category_id'],
      ),
      brandId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}brand_id'],
      ),
      unitId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}unit_id'],
      )!,
      sellingPrice: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}selling_price'],
      )!,
      purchasePrice: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}purchase_price'],
      ),
      mrp: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}mrp'],
      ),
      wholesalePrice: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}wholesale_price'],
      ),
      barcode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}barcode'],
      ),
      hsnCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hsn_code'],
      ),
      taxTypeId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tax_type_id'],
      ),
      taxCategoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tax_category_id'],
      ),
      expiryDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}expiry_date'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ProductsTable createAlias(String alias) {
    return $ProductsTable(attachedDatabase, alias);
  }
}

class Product extends DataClass implements Insertable<Product> {
  final int id;
  final String productCode;
  final String productName;
  final int? categoryId;
  final int? subCategoryId;
  final int? brandId;
  final int unitId;
  final int sellingPrice;
  final int? purchasePrice;
  final int? mrp;
  final int? wholesalePrice;
  final String? barcode;
  final String? hsnCode;
  final int? taxTypeId;
  final int? taxCategoryId;

  /// Optional expiry date for the parent product (e.g. food, medicine).
  final DateTime? expiryDate;
  final String? notes;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Product({
    required this.id,
    required this.productCode,
    required this.productName,
    this.categoryId,
    this.subCategoryId,
    this.brandId,
    required this.unitId,
    required this.sellingPrice,
    this.purchasePrice,
    this.mrp,
    this.wholesalePrice,
    this.barcode,
    this.hsnCode,
    this.taxTypeId,
    this.taxCategoryId,
    this.expiryDate,
    this.notes,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['product_code'] = Variable<String>(productCode);
    map['product_name'] = Variable<String>(productName);
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<int>(categoryId);
    }
    if (!nullToAbsent || subCategoryId != null) {
      map['sub_category_id'] = Variable<int>(subCategoryId);
    }
    if (!nullToAbsent || brandId != null) {
      map['brand_id'] = Variable<int>(brandId);
    }
    map['unit_id'] = Variable<int>(unitId);
    map['selling_price'] = Variable<int>(sellingPrice);
    if (!nullToAbsent || purchasePrice != null) {
      map['purchase_price'] = Variable<int>(purchasePrice);
    }
    if (!nullToAbsent || mrp != null) {
      map['mrp'] = Variable<int>(mrp);
    }
    if (!nullToAbsent || wholesalePrice != null) {
      map['wholesale_price'] = Variable<int>(wholesalePrice);
    }
    if (!nullToAbsent || barcode != null) {
      map['barcode'] = Variable<String>(barcode);
    }
    if (!nullToAbsent || hsnCode != null) {
      map['hsn_code'] = Variable<String>(hsnCode);
    }
    if (!nullToAbsent || taxTypeId != null) {
      map['tax_type_id'] = Variable<int>(taxTypeId);
    }
    if (!nullToAbsent || taxCategoryId != null) {
      map['tax_category_id'] = Variable<int>(taxCategoryId);
    }
    if (!nullToAbsent || expiryDate != null) {
      map['expiry_date'] = Variable<DateTime>(expiryDate);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ProductsCompanion toCompanion(bool nullToAbsent) {
    return ProductsCompanion(
      id: Value(id),
      productCode: Value(productCode),
      productName: Value(productName),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      subCategoryId: subCategoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(subCategoryId),
      brandId: brandId == null && nullToAbsent
          ? const Value.absent()
          : Value(brandId),
      unitId: Value(unitId),
      sellingPrice: Value(sellingPrice),
      purchasePrice: purchasePrice == null && nullToAbsent
          ? const Value.absent()
          : Value(purchasePrice),
      mrp: mrp == null && nullToAbsent ? const Value.absent() : Value(mrp),
      wholesalePrice: wholesalePrice == null && nullToAbsent
          ? const Value.absent()
          : Value(wholesalePrice),
      barcode: barcode == null && nullToAbsent
          ? const Value.absent()
          : Value(barcode),
      hsnCode: hsnCode == null && nullToAbsent
          ? const Value.absent()
          : Value(hsnCode),
      taxTypeId: taxTypeId == null && nullToAbsent
          ? const Value.absent()
          : Value(taxTypeId),
      taxCategoryId: taxCategoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(taxCategoryId),
      expiryDate: expiryDate == null && nullToAbsent
          ? const Value.absent()
          : Value(expiryDate),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Product.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Product(
      id: serializer.fromJson<int>(json['id']),
      productCode: serializer.fromJson<String>(json['productCode']),
      productName: serializer.fromJson<String>(json['productName']),
      categoryId: serializer.fromJson<int?>(json['categoryId']),
      subCategoryId: serializer.fromJson<int?>(json['subCategoryId']),
      brandId: serializer.fromJson<int?>(json['brandId']),
      unitId: serializer.fromJson<int>(json['unitId']),
      sellingPrice: serializer.fromJson<int>(json['sellingPrice']),
      purchasePrice: serializer.fromJson<int?>(json['purchasePrice']),
      mrp: serializer.fromJson<int?>(json['mrp']),
      wholesalePrice: serializer.fromJson<int?>(json['wholesalePrice']),
      barcode: serializer.fromJson<String?>(json['barcode']),
      hsnCode: serializer.fromJson<String?>(json['hsnCode']),
      taxTypeId: serializer.fromJson<int?>(json['taxTypeId']),
      taxCategoryId: serializer.fromJson<int?>(json['taxCategoryId']),
      expiryDate: serializer.fromJson<DateTime?>(json['expiryDate']),
      notes: serializer.fromJson<String?>(json['notes']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'productCode': serializer.toJson<String>(productCode),
      'productName': serializer.toJson<String>(productName),
      'categoryId': serializer.toJson<int?>(categoryId),
      'subCategoryId': serializer.toJson<int?>(subCategoryId),
      'brandId': serializer.toJson<int?>(brandId),
      'unitId': serializer.toJson<int>(unitId),
      'sellingPrice': serializer.toJson<int>(sellingPrice),
      'purchasePrice': serializer.toJson<int?>(purchasePrice),
      'mrp': serializer.toJson<int?>(mrp),
      'wholesalePrice': serializer.toJson<int?>(wholesalePrice),
      'barcode': serializer.toJson<String?>(barcode),
      'hsnCode': serializer.toJson<String?>(hsnCode),
      'taxTypeId': serializer.toJson<int?>(taxTypeId),
      'taxCategoryId': serializer.toJson<int?>(taxCategoryId),
      'expiryDate': serializer.toJson<DateTime?>(expiryDate),
      'notes': serializer.toJson<String?>(notes),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Product copyWith({
    int? id,
    String? productCode,
    String? productName,
    Value<int?> categoryId = const Value.absent(),
    Value<int?> subCategoryId = const Value.absent(),
    Value<int?> brandId = const Value.absent(),
    int? unitId,
    int? sellingPrice,
    Value<int?> purchasePrice = const Value.absent(),
    Value<int?> mrp = const Value.absent(),
    Value<int?> wholesalePrice = const Value.absent(),
    Value<String?> barcode = const Value.absent(),
    Value<String?> hsnCode = const Value.absent(),
    Value<int?> taxTypeId = const Value.absent(),
    Value<int?> taxCategoryId = const Value.absent(),
    Value<DateTime?> expiryDate = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Product(
    id: id ?? this.id,
    productCode: productCode ?? this.productCode,
    productName: productName ?? this.productName,
    categoryId: categoryId.present ? categoryId.value : this.categoryId,
    subCategoryId: subCategoryId.present
        ? subCategoryId.value
        : this.subCategoryId,
    brandId: brandId.present ? brandId.value : this.brandId,
    unitId: unitId ?? this.unitId,
    sellingPrice: sellingPrice ?? this.sellingPrice,
    purchasePrice: purchasePrice.present
        ? purchasePrice.value
        : this.purchasePrice,
    mrp: mrp.present ? mrp.value : this.mrp,
    wholesalePrice: wholesalePrice.present
        ? wholesalePrice.value
        : this.wholesalePrice,
    barcode: barcode.present ? barcode.value : this.barcode,
    hsnCode: hsnCode.present ? hsnCode.value : this.hsnCode,
    taxTypeId: taxTypeId.present ? taxTypeId.value : this.taxTypeId,
    taxCategoryId: taxCategoryId.present
        ? taxCategoryId.value
        : this.taxCategoryId,
    expiryDate: expiryDate.present ? expiryDate.value : this.expiryDate,
    notes: notes.present ? notes.value : this.notes,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Product copyWithCompanion(ProductsCompanion data) {
    return Product(
      id: data.id.present ? data.id.value : this.id,
      productCode: data.productCode.present
          ? data.productCode.value
          : this.productCode,
      productName: data.productName.present
          ? data.productName.value
          : this.productName,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      subCategoryId: data.subCategoryId.present
          ? data.subCategoryId.value
          : this.subCategoryId,
      brandId: data.brandId.present ? data.brandId.value : this.brandId,
      unitId: data.unitId.present ? data.unitId.value : this.unitId,
      sellingPrice: data.sellingPrice.present
          ? data.sellingPrice.value
          : this.sellingPrice,
      purchasePrice: data.purchasePrice.present
          ? data.purchasePrice.value
          : this.purchasePrice,
      mrp: data.mrp.present ? data.mrp.value : this.mrp,
      wholesalePrice: data.wholesalePrice.present
          ? data.wholesalePrice.value
          : this.wholesalePrice,
      barcode: data.barcode.present ? data.barcode.value : this.barcode,
      hsnCode: data.hsnCode.present ? data.hsnCode.value : this.hsnCode,
      taxTypeId: data.taxTypeId.present ? data.taxTypeId.value : this.taxTypeId,
      taxCategoryId: data.taxCategoryId.present
          ? data.taxCategoryId.value
          : this.taxCategoryId,
      expiryDate: data.expiryDate.present
          ? data.expiryDate.value
          : this.expiryDate,
      notes: data.notes.present ? data.notes.value : this.notes,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Product(')
          ..write('id: $id, ')
          ..write('productCode: $productCode, ')
          ..write('productName: $productName, ')
          ..write('categoryId: $categoryId, ')
          ..write('subCategoryId: $subCategoryId, ')
          ..write('brandId: $brandId, ')
          ..write('unitId: $unitId, ')
          ..write('sellingPrice: $sellingPrice, ')
          ..write('purchasePrice: $purchasePrice, ')
          ..write('mrp: $mrp, ')
          ..write('wholesalePrice: $wholesalePrice, ')
          ..write('barcode: $barcode, ')
          ..write('hsnCode: $hsnCode, ')
          ..write('taxTypeId: $taxTypeId, ')
          ..write('taxCategoryId: $taxCategoryId, ')
          ..write('expiryDate: $expiryDate, ')
          ..write('notes: $notes, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    productCode,
    productName,
    categoryId,
    subCategoryId,
    brandId,
    unitId,
    sellingPrice,
    purchasePrice,
    mrp,
    wholesalePrice,
    barcode,
    hsnCode,
    taxTypeId,
    taxCategoryId,
    expiryDate,
    notes,
    isActive,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Product &&
          other.id == this.id &&
          other.productCode == this.productCode &&
          other.productName == this.productName &&
          other.categoryId == this.categoryId &&
          other.subCategoryId == this.subCategoryId &&
          other.brandId == this.brandId &&
          other.unitId == this.unitId &&
          other.sellingPrice == this.sellingPrice &&
          other.purchasePrice == this.purchasePrice &&
          other.mrp == this.mrp &&
          other.wholesalePrice == this.wholesalePrice &&
          other.barcode == this.barcode &&
          other.hsnCode == this.hsnCode &&
          other.taxTypeId == this.taxTypeId &&
          other.taxCategoryId == this.taxCategoryId &&
          other.expiryDate == this.expiryDate &&
          other.notes == this.notes &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ProductsCompanion extends UpdateCompanion<Product> {
  final Value<int> id;
  final Value<String> productCode;
  final Value<String> productName;
  final Value<int?> categoryId;
  final Value<int?> subCategoryId;
  final Value<int?> brandId;
  final Value<int> unitId;
  final Value<int> sellingPrice;
  final Value<int?> purchasePrice;
  final Value<int?> mrp;
  final Value<int?> wholesalePrice;
  final Value<String?> barcode;
  final Value<String?> hsnCode;
  final Value<int?> taxTypeId;
  final Value<int?> taxCategoryId;
  final Value<DateTime?> expiryDate;
  final Value<String?> notes;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const ProductsCompanion({
    this.id = const Value.absent(),
    this.productCode = const Value.absent(),
    this.productName = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.subCategoryId = const Value.absent(),
    this.brandId = const Value.absent(),
    this.unitId = const Value.absent(),
    this.sellingPrice = const Value.absent(),
    this.purchasePrice = const Value.absent(),
    this.mrp = const Value.absent(),
    this.wholesalePrice = const Value.absent(),
    this.barcode = const Value.absent(),
    this.hsnCode = const Value.absent(),
    this.taxTypeId = const Value.absent(),
    this.taxCategoryId = const Value.absent(),
    this.expiryDate = const Value.absent(),
    this.notes = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  ProductsCompanion.insert({
    this.id = const Value.absent(),
    required String productCode,
    required String productName,
    this.categoryId = const Value.absent(),
    this.subCategoryId = const Value.absent(),
    this.brandId = const Value.absent(),
    required int unitId,
    this.sellingPrice = const Value.absent(),
    this.purchasePrice = const Value.absent(),
    this.mrp = const Value.absent(),
    this.wholesalePrice = const Value.absent(),
    this.barcode = const Value.absent(),
    this.hsnCode = const Value.absent(),
    this.taxTypeId = const Value.absent(),
    this.taxCategoryId = const Value.absent(),
    this.expiryDate = const Value.absent(),
    this.notes = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : productCode = Value(productCode),
       productName = Value(productName),
       unitId = Value(unitId);
  static Insertable<Product> custom({
    Expression<int>? id,
    Expression<String>? productCode,
    Expression<String>? productName,
    Expression<int>? categoryId,
    Expression<int>? subCategoryId,
    Expression<int>? brandId,
    Expression<int>? unitId,
    Expression<int>? sellingPrice,
    Expression<int>? purchasePrice,
    Expression<int>? mrp,
    Expression<int>? wholesalePrice,
    Expression<String>? barcode,
    Expression<String>? hsnCode,
    Expression<int>? taxTypeId,
    Expression<int>? taxCategoryId,
    Expression<DateTime>? expiryDate,
    Expression<String>? notes,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (productCode != null) 'product_code': productCode,
      if (productName != null) 'product_name': productName,
      if (categoryId != null) 'category_id': categoryId,
      if (subCategoryId != null) 'sub_category_id': subCategoryId,
      if (brandId != null) 'brand_id': brandId,
      if (unitId != null) 'unit_id': unitId,
      if (sellingPrice != null) 'selling_price': sellingPrice,
      if (purchasePrice != null) 'purchase_price': purchasePrice,
      if (mrp != null) 'mrp': mrp,
      if (wholesalePrice != null) 'wholesale_price': wholesalePrice,
      if (barcode != null) 'barcode': barcode,
      if (hsnCode != null) 'hsn_code': hsnCode,
      if (taxTypeId != null) 'tax_type_id': taxTypeId,
      if (taxCategoryId != null) 'tax_category_id': taxCategoryId,
      if (expiryDate != null) 'expiry_date': expiryDate,
      if (notes != null) 'notes': notes,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  ProductsCompanion copyWith({
    Value<int>? id,
    Value<String>? productCode,
    Value<String>? productName,
    Value<int?>? categoryId,
    Value<int?>? subCategoryId,
    Value<int?>? brandId,
    Value<int>? unitId,
    Value<int>? sellingPrice,
    Value<int?>? purchasePrice,
    Value<int?>? mrp,
    Value<int?>? wholesalePrice,
    Value<String?>? barcode,
    Value<String?>? hsnCode,
    Value<int?>? taxTypeId,
    Value<int?>? taxCategoryId,
    Value<DateTime?>? expiryDate,
    Value<String?>? notes,
    Value<bool>? isActive,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return ProductsCompanion(
      id: id ?? this.id,
      productCode: productCode ?? this.productCode,
      productName: productName ?? this.productName,
      categoryId: categoryId ?? this.categoryId,
      subCategoryId: subCategoryId ?? this.subCategoryId,
      brandId: brandId ?? this.brandId,
      unitId: unitId ?? this.unitId,
      sellingPrice: sellingPrice ?? this.sellingPrice,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      mrp: mrp ?? this.mrp,
      wholesalePrice: wholesalePrice ?? this.wholesalePrice,
      barcode: barcode ?? this.barcode,
      hsnCode: hsnCode ?? this.hsnCode,
      taxTypeId: taxTypeId ?? this.taxTypeId,
      taxCategoryId: taxCategoryId ?? this.taxCategoryId,
      expiryDate: expiryDate ?? this.expiryDate,
      notes: notes ?? this.notes,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (productCode.present) {
      map['product_code'] = Variable<String>(productCode.value);
    }
    if (productName.present) {
      map['product_name'] = Variable<String>(productName.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (subCategoryId.present) {
      map['sub_category_id'] = Variable<int>(subCategoryId.value);
    }
    if (brandId.present) {
      map['brand_id'] = Variable<int>(brandId.value);
    }
    if (unitId.present) {
      map['unit_id'] = Variable<int>(unitId.value);
    }
    if (sellingPrice.present) {
      map['selling_price'] = Variable<int>(sellingPrice.value);
    }
    if (purchasePrice.present) {
      map['purchase_price'] = Variable<int>(purchasePrice.value);
    }
    if (mrp.present) {
      map['mrp'] = Variable<int>(mrp.value);
    }
    if (wholesalePrice.present) {
      map['wholesale_price'] = Variable<int>(wholesalePrice.value);
    }
    if (barcode.present) {
      map['barcode'] = Variable<String>(barcode.value);
    }
    if (hsnCode.present) {
      map['hsn_code'] = Variable<String>(hsnCode.value);
    }
    if (taxTypeId.present) {
      map['tax_type_id'] = Variable<int>(taxTypeId.value);
    }
    if (taxCategoryId.present) {
      map['tax_category_id'] = Variable<int>(taxCategoryId.value);
    }
    if (expiryDate.present) {
      map['expiry_date'] = Variable<DateTime>(expiryDate.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductsCompanion(')
          ..write('id: $id, ')
          ..write('productCode: $productCode, ')
          ..write('productName: $productName, ')
          ..write('categoryId: $categoryId, ')
          ..write('subCategoryId: $subCategoryId, ')
          ..write('brandId: $brandId, ')
          ..write('unitId: $unitId, ')
          ..write('sellingPrice: $sellingPrice, ')
          ..write('purchasePrice: $purchasePrice, ')
          ..write('mrp: $mrp, ')
          ..write('wholesalePrice: $wholesalePrice, ')
          ..write('barcode: $barcode, ')
          ..write('hsnCode: $hsnCode, ')
          ..write('taxTypeId: $taxTypeId, ')
          ..write('taxCategoryId: $taxCategoryId, ')
          ..write('expiryDate: $expiryDate, ')
          ..write('notes: $notes, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $ProductVariantsTable extends ProductVariants
    with TableInfo<$ProductVariantsTable, ProductVariant> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductVariantsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<int> productId = GeneratedColumn<int>(
    'product_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES product (id)',
    ),
  );
  static const VerificationMeta _variantNameMeta = const VerificationMeta(
    'variantName',
  );
  @override
  late final GeneratedColumn<String> variantName = GeneratedColumn<String>(
    'variant_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sellingPriceMeta = const VerificationMeta(
    'sellingPrice',
  );
  @override
  late final GeneratedColumn<int> sellingPrice = GeneratedColumn<int>(
    'selling_price',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _purchasePriceMeta = const VerificationMeta(
    'purchasePrice',
  );
  @override
  late final GeneratedColumn<int> purchasePrice = GeneratedColumn<int>(
    'purchase_price',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _mrpMeta = const VerificationMeta('mrp');
  @override
  late final GeneratedColumn<int> mrp = GeneratedColumn<int>(
    'mrp',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _wholesalePriceMeta = const VerificationMeta(
    'wholesalePrice',
  );
  @override
  late final GeneratedColumn<int> wholesalePrice = GeneratedColumn<int>(
    'wholesale_price',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _barcodeMeta = const VerificationMeta(
    'barcode',
  );
  @override
  late final GeneratedColumn<String> barcode = GeneratedColumn<String>(
    'barcode',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hsnCodeMeta = const VerificationMeta(
    'hsnCode',
  );
  @override
  late final GeneratedColumn<String> hsnCode = GeneratedColumn<String>(
    'hsn_code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _expiryDateMeta = const VerificationMeta(
    'expiryDate',
  );
  @override
  late final GeneratedColumn<DateTime> expiryDate = GeneratedColumn<DateTime>(
    'expiry_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    productId,
    variantName,
    sellingPrice,
    purchasePrice,
    mrp,
    wholesalePrice,
    barcode,
    hsnCode,
    expiryDate,
    notes,
    isActive,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'product_variant';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProductVariant> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('variant_name')) {
      context.handle(
        _variantNameMeta,
        variantName.isAcceptableOrUnknown(
          data['variant_name']!,
          _variantNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_variantNameMeta);
    }
    if (data.containsKey('selling_price')) {
      context.handle(
        _sellingPriceMeta,
        sellingPrice.isAcceptableOrUnknown(
          data['selling_price']!,
          _sellingPriceMeta,
        ),
      );
    }
    if (data.containsKey('purchase_price')) {
      context.handle(
        _purchasePriceMeta,
        purchasePrice.isAcceptableOrUnknown(
          data['purchase_price']!,
          _purchasePriceMeta,
        ),
      );
    }
    if (data.containsKey('mrp')) {
      context.handle(
        _mrpMeta,
        mrp.isAcceptableOrUnknown(data['mrp']!, _mrpMeta),
      );
    }
    if (data.containsKey('wholesale_price')) {
      context.handle(
        _wholesalePriceMeta,
        wholesalePrice.isAcceptableOrUnknown(
          data['wholesale_price']!,
          _wholesalePriceMeta,
        ),
      );
    }
    if (data.containsKey('barcode')) {
      context.handle(
        _barcodeMeta,
        barcode.isAcceptableOrUnknown(data['barcode']!, _barcodeMeta),
      );
    }
    if (data.containsKey('hsn_code')) {
      context.handle(
        _hsnCodeMeta,
        hsnCode.isAcceptableOrUnknown(data['hsn_code']!, _hsnCodeMeta),
      );
    }
    if (data.containsKey('expiry_date')) {
      context.handle(
        _expiryDateMeta,
        expiryDate.isAcceptableOrUnknown(data['expiry_date']!, _expiryDateMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {productId, variantName},
  ];
  @override
  ProductVariant map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProductVariant(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}product_id'],
      )!,
      variantName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}variant_name'],
      )!,
      sellingPrice: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}selling_price'],
      )!,
      purchasePrice: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}purchase_price'],
      ),
      mrp: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}mrp'],
      ),
      wholesalePrice: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}wholesale_price'],
      ),
      barcode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}barcode'],
      ),
      hsnCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hsn_code'],
      ),
      expiryDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}expiry_date'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ProductVariantsTable createAlias(String alias) {
    return $ProductVariantsTable(attachedDatabase, alias);
  }
}

class ProductVariant extends DataClass implements Insertable<ProductVariant> {
  final int id;
  final int productId;
  final String variantName;
  final int sellingPrice;
  final int? purchasePrice;
  final int? mrp;
  final int? wholesalePrice;
  final String? barcode;
  final String? hsnCode;
  final DateTime? expiryDate;
  final String? notes;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  const ProductVariant({
    required this.id,
    required this.productId,
    required this.variantName,
    required this.sellingPrice,
    this.purchasePrice,
    this.mrp,
    this.wholesalePrice,
    this.barcode,
    this.hsnCode,
    this.expiryDate,
    this.notes,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['product_id'] = Variable<int>(productId);
    map['variant_name'] = Variable<String>(variantName);
    map['selling_price'] = Variable<int>(sellingPrice);
    if (!nullToAbsent || purchasePrice != null) {
      map['purchase_price'] = Variable<int>(purchasePrice);
    }
    if (!nullToAbsent || mrp != null) {
      map['mrp'] = Variable<int>(mrp);
    }
    if (!nullToAbsent || wholesalePrice != null) {
      map['wholesale_price'] = Variable<int>(wholesalePrice);
    }
    if (!nullToAbsent || barcode != null) {
      map['barcode'] = Variable<String>(barcode);
    }
    if (!nullToAbsent || hsnCode != null) {
      map['hsn_code'] = Variable<String>(hsnCode);
    }
    if (!nullToAbsent || expiryDate != null) {
      map['expiry_date'] = Variable<DateTime>(expiryDate);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ProductVariantsCompanion toCompanion(bool nullToAbsent) {
    return ProductVariantsCompanion(
      id: Value(id),
      productId: Value(productId),
      variantName: Value(variantName),
      sellingPrice: Value(sellingPrice),
      purchasePrice: purchasePrice == null && nullToAbsent
          ? const Value.absent()
          : Value(purchasePrice),
      mrp: mrp == null && nullToAbsent ? const Value.absent() : Value(mrp),
      wholesalePrice: wholesalePrice == null && nullToAbsent
          ? const Value.absent()
          : Value(wholesalePrice),
      barcode: barcode == null && nullToAbsent
          ? const Value.absent()
          : Value(barcode),
      hsnCode: hsnCode == null && nullToAbsent
          ? const Value.absent()
          : Value(hsnCode),
      expiryDate: expiryDate == null && nullToAbsent
          ? const Value.absent()
          : Value(expiryDate),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory ProductVariant.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProductVariant(
      id: serializer.fromJson<int>(json['id']),
      productId: serializer.fromJson<int>(json['productId']),
      variantName: serializer.fromJson<String>(json['variantName']),
      sellingPrice: serializer.fromJson<int>(json['sellingPrice']),
      purchasePrice: serializer.fromJson<int?>(json['purchasePrice']),
      mrp: serializer.fromJson<int?>(json['mrp']),
      wholesalePrice: serializer.fromJson<int?>(json['wholesalePrice']),
      barcode: serializer.fromJson<String?>(json['barcode']),
      hsnCode: serializer.fromJson<String?>(json['hsnCode']),
      expiryDate: serializer.fromJson<DateTime?>(json['expiryDate']),
      notes: serializer.fromJson<String?>(json['notes']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'productId': serializer.toJson<int>(productId),
      'variantName': serializer.toJson<String>(variantName),
      'sellingPrice': serializer.toJson<int>(sellingPrice),
      'purchasePrice': serializer.toJson<int?>(purchasePrice),
      'mrp': serializer.toJson<int?>(mrp),
      'wholesalePrice': serializer.toJson<int?>(wholesalePrice),
      'barcode': serializer.toJson<String?>(barcode),
      'hsnCode': serializer.toJson<String?>(hsnCode),
      'expiryDate': serializer.toJson<DateTime?>(expiryDate),
      'notes': serializer.toJson<String?>(notes),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ProductVariant copyWith({
    int? id,
    int? productId,
    String? variantName,
    int? sellingPrice,
    Value<int?> purchasePrice = const Value.absent(),
    Value<int?> mrp = const Value.absent(),
    Value<int?> wholesalePrice = const Value.absent(),
    Value<String?> barcode = const Value.absent(),
    Value<String?> hsnCode = const Value.absent(),
    Value<DateTime?> expiryDate = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => ProductVariant(
    id: id ?? this.id,
    productId: productId ?? this.productId,
    variantName: variantName ?? this.variantName,
    sellingPrice: sellingPrice ?? this.sellingPrice,
    purchasePrice: purchasePrice.present
        ? purchasePrice.value
        : this.purchasePrice,
    mrp: mrp.present ? mrp.value : this.mrp,
    wholesalePrice: wholesalePrice.present
        ? wholesalePrice.value
        : this.wholesalePrice,
    barcode: barcode.present ? barcode.value : this.barcode,
    hsnCode: hsnCode.present ? hsnCode.value : this.hsnCode,
    expiryDate: expiryDate.present ? expiryDate.value : this.expiryDate,
    notes: notes.present ? notes.value : this.notes,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ProductVariant copyWithCompanion(ProductVariantsCompanion data) {
    return ProductVariant(
      id: data.id.present ? data.id.value : this.id,
      productId: data.productId.present ? data.productId.value : this.productId,
      variantName: data.variantName.present
          ? data.variantName.value
          : this.variantName,
      sellingPrice: data.sellingPrice.present
          ? data.sellingPrice.value
          : this.sellingPrice,
      purchasePrice: data.purchasePrice.present
          ? data.purchasePrice.value
          : this.purchasePrice,
      mrp: data.mrp.present ? data.mrp.value : this.mrp,
      wholesalePrice: data.wholesalePrice.present
          ? data.wholesalePrice.value
          : this.wholesalePrice,
      barcode: data.barcode.present ? data.barcode.value : this.barcode,
      hsnCode: data.hsnCode.present ? data.hsnCode.value : this.hsnCode,
      expiryDate: data.expiryDate.present
          ? data.expiryDate.value
          : this.expiryDate,
      notes: data.notes.present ? data.notes.value : this.notes,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProductVariant(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('variantName: $variantName, ')
          ..write('sellingPrice: $sellingPrice, ')
          ..write('purchasePrice: $purchasePrice, ')
          ..write('mrp: $mrp, ')
          ..write('wholesalePrice: $wholesalePrice, ')
          ..write('barcode: $barcode, ')
          ..write('hsnCode: $hsnCode, ')
          ..write('expiryDate: $expiryDate, ')
          ..write('notes: $notes, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    productId,
    variantName,
    sellingPrice,
    purchasePrice,
    mrp,
    wholesalePrice,
    barcode,
    hsnCode,
    expiryDate,
    notes,
    isActive,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProductVariant &&
          other.id == this.id &&
          other.productId == this.productId &&
          other.variantName == this.variantName &&
          other.sellingPrice == this.sellingPrice &&
          other.purchasePrice == this.purchasePrice &&
          other.mrp == this.mrp &&
          other.wholesalePrice == this.wholesalePrice &&
          other.barcode == this.barcode &&
          other.hsnCode == this.hsnCode &&
          other.expiryDate == this.expiryDate &&
          other.notes == this.notes &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ProductVariantsCompanion extends UpdateCompanion<ProductVariant> {
  final Value<int> id;
  final Value<int> productId;
  final Value<String> variantName;
  final Value<int> sellingPrice;
  final Value<int?> purchasePrice;
  final Value<int?> mrp;
  final Value<int?> wholesalePrice;
  final Value<String?> barcode;
  final Value<String?> hsnCode;
  final Value<DateTime?> expiryDate;
  final Value<String?> notes;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const ProductVariantsCompanion({
    this.id = const Value.absent(),
    this.productId = const Value.absent(),
    this.variantName = const Value.absent(),
    this.sellingPrice = const Value.absent(),
    this.purchasePrice = const Value.absent(),
    this.mrp = const Value.absent(),
    this.wholesalePrice = const Value.absent(),
    this.barcode = const Value.absent(),
    this.hsnCode = const Value.absent(),
    this.expiryDate = const Value.absent(),
    this.notes = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  ProductVariantsCompanion.insert({
    this.id = const Value.absent(),
    required int productId,
    required String variantName,
    this.sellingPrice = const Value.absent(),
    this.purchasePrice = const Value.absent(),
    this.mrp = const Value.absent(),
    this.wholesalePrice = const Value.absent(),
    this.barcode = const Value.absent(),
    this.hsnCode = const Value.absent(),
    this.expiryDate = const Value.absent(),
    this.notes = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : productId = Value(productId),
       variantName = Value(variantName);
  static Insertable<ProductVariant> custom({
    Expression<int>? id,
    Expression<int>? productId,
    Expression<String>? variantName,
    Expression<int>? sellingPrice,
    Expression<int>? purchasePrice,
    Expression<int>? mrp,
    Expression<int>? wholesalePrice,
    Expression<String>? barcode,
    Expression<String>? hsnCode,
    Expression<DateTime>? expiryDate,
    Expression<String>? notes,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (productId != null) 'product_id': productId,
      if (variantName != null) 'variant_name': variantName,
      if (sellingPrice != null) 'selling_price': sellingPrice,
      if (purchasePrice != null) 'purchase_price': purchasePrice,
      if (mrp != null) 'mrp': mrp,
      if (wholesalePrice != null) 'wholesale_price': wholesalePrice,
      if (barcode != null) 'barcode': barcode,
      if (hsnCode != null) 'hsn_code': hsnCode,
      if (expiryDate != null) 'expiry_date': expiryDate,
      if (notes != null) 'notes': notes,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  ProductVariantsCompanion copyWith({
    Value<int>? id,
    Value<int>? productId,
    Value<String>? variantName,
    Value<int>? sellingPrice,
    Value<int?>? purchasePrice,
    Value<int?>? mrp,
    Value<int?>? wholesalePrice,
    Value<String?>? barcode,
    Value<String?>? hsnCode,
    Value<DateTime?>? expiryDate,
    Value<String?>? notes,
    Value<bool>? isActive,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return ProductVariantsCompanion(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      variantName: variantName ?? this.variantName,
      sellingPrice: sellingPrice ?? this.sellingPrice,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      mrp: mrp ?? this.mrp,
      wholesalePrice: wholesalePrice ?? this.wholesalePrice,
      barcode: barcode ?? this.barcode,
      hsnCode: hsnCode ?? this.hsnCode,
      expiryDate: expiryDate ?? this.expiryDate,
      notes: notes ?? this.notes,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<int>(productId.value);
    }
    if (variantName.present) {
      map['variant_name'] = Variable<String>(variantName.value);
    }
    if (sellingPrice.present) {
      map['selling_price'] = Variable<int>(sellingPrice.value);
    }
    if (purchasePrice.present) {
      map['purchase_price'] = Variable<int>(purchasePrice.value);
    }
    if (mrp.present) {
      map['mrp'] = Variable<int>(mrp.value);
    }
    if (wholesalePrice.present) {
      map['wholesale_price'] = Variable<int>(wholesalePrice.value);
    }
    if (barcode.present) {
      map['barcode'] = Variable<String>(barcode.value);
    }
    if (hsnCode.present) {
      map['hsn_code'] = Variable<String>(hsnCode.value);
    }
    if (expiryDate.present) {
      map['expiry_date'] = Variable<DateTime>(expiryDate.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductVariantsCompanion(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('variantName: $variantName, ')
          ..write('sellingPrice: $sellingPrice, ')
          ..write('purchasePrice: $purchasePrice, ')
          ..write('mrp: $mrp, ')
          ..write('wholesalePrice: $wholesalePrice, ')
          ..write('barcode: $barcode, ')
          ..write('hsnCode: $hsnCode, ')
          ..write('expiryDate: $expiryDate, ')
          ..write('notes: $notes, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $ProductUomsTable extends ProductUoms
    with TableInfo<$ProductUomsTable, ProductUom> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductUomsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<int> productId = GeneratedColumn<int>(
    'product_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES product (id)',
    ),
  );
  static const VerificationMeta _fromUnitIdMeta = const VerificationMeta(
    'fromUnitId',
  );
  @override
  late final GeneratedColumn<int> fromUnitId = GeneratedColumn<int>(
    'from_unit_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES unit (id)',
    ),
  );
  static const VerificationMeta _toUnitIdMeta = const VerificationMeta(
    'toUnitId',
  );
  @override
  late final GeneratedColumn<int> toUnitId = GeneratedColumn<int>(
    'to_unit_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES unit (id)',
    ),
  );
  static const VerificationMeta _conversionFactorMeta = const VerificationMeta(
    'conversionFactor',
  );
  @override
  late final GeneratedColumn<double> conversionFactor = GeneratedColumn<double>(
    'conversion_factor',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isDefaultMeta = const VerificationMeta(
    'isDefault',
  );
  @override
  late final GeneratedColumn<bool> isDefault = GeneratedColumn<bool>(
    'is_default',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_default" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    productId,
    fromUnitId,
    toUnitId,
    conversionFactor,
    isDefault,
    description,
    isActive,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'product_uom';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProductUom> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('from_unit_id')) {
      context.handle(
        _fromUnitIdMeta,
        fromUnitId.isAcceptableOrUnknown(
          data['from_unit_id']!,
          _fromUnitIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_fromUnitIdMeta);
    }
    if (data.containsKey('to_unit_id')) {
      context.handle(
        _toUnitIdMeta,
        toUnitId.isAcceptableOrUnknown(data['to_unit_id']!, _toUnitIdMeta),
      );
    } else if (isInserting) {
      context.missing(_toUnitIdMeta);
    }
    if (data.containsKey('conversion_factor')) {
      context.handle(
        _conversionFactorMeta,
        conversionFactor.isAcceptableOrUnknown(
          data['conversion_factor']!,
          _conversionFactorMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_conversionFactorMeta);
    }
    if (data.containsKey('is_default')) {
      context.handle(
        _isDefaultMeta,
        isDefault.isAcceptableOrUnknown(data['is_default']!, _isDefaultMeta),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {productId, fromUnitId, toUnitId, conversionFactor},
  ];
  @override
  ProductUom map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProductUom(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}product_id'],
      )!,
      fromUnitId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}from_unit_id'],
      )!,
      toUnitId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}to_unit_id'],
      )!,
      conversionFactor: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}conversion_factor'],
      )!,
      isDefault: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_default'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ProductUomsTable createAlias(String alias) {
    return $ProductUomsTable(attachedDatabase, alias);
  }
}

class ProductUom extends DataClass implements Insertable<ProductUom> {
  final int id;
  final int productId;
  final int fromUnitId;
  final int toUnitId;
  final double conversionFactor;
  final bool isDefault;
  final String? description;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  const ProductUom({
    required this.id,
    required this.productId,
    required this.fromUnitId,
    required this.toUnitId,
    required this.conversionFactor,
    required this.isDefault,
    this.description,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['product_id'] = Variable<int>(productId);
    map['from_unit_id'] = Variable<int>(fromUnitId);
    map['to_unit_id'] = Variable<int>(toUnitId);
    map['conversion_factor'] = Variable<double>(conversionFactor);
    map['is_default'] = Variable<bool>(isDefault);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ProductUomsCompanion toCompanion(bool nullToAbsent) {
    return ProductUomsCompanion(
      id: Value(id),
      productId: Value(productId),
      fromUnitId: Value(fromUnitId),
      toUnitId: Value(toUnitId),
      conversionFactor: Value(conversionFactor),
      isDefault: Value(isDefault),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory ProductUom.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProductUom(
      id: serializer.fromJson<int>(json['id']),
      productId: serializer.fromJson<int>(json['productId']),
      fromUnitId: serializer.fromJson<int>(json['fromUnitId']),
      toUnitId: serializer.fromJson<int>(json['toUnitId']),
      conversionFactor: serializer.fromJson<double>(json['conversionFactor']),
      isDefault: serializer.fromJson<bool>(json['isDefault']),
      description: serializer.fromJson<String?>(json['description']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'productId': serializer.toJson<int>(productId),
      'fromUnitId': serializer.toJson<int>(fromUnitId),
      'toUnitId': serializer.toJson<int>(toUnitId),
      'conversionFactor': serializer.toJson<double>(conversionFactor),
      'isDefault': serializer.toJson<bool>(isDefault),
      'description': serializer.toJson<String?>(description),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ProductUom copyWith({
    int? id,
    int? productId,
    int? fromUnitId,
    int? toUnitId,
    double? conversionFactor,
    bool? isDefault,
    Value<String?> description = const Value.absent(),
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => ProductUom(
    id: id ?? this.id,
    productId: productId ?? this.productId,
    fromUnitId: fromUnitId ?? this.fromUnitId,
    toUnitId: toUnitId ?? this.toUnitId,
    conversionFactor: conversionFactor ?? this.conversionFactor,
    isDefault: isDefault ?? this.isDefault,
    description: description.present ? description.value : this.description,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ProductUom copyWithCompanion(ProductUomsCompanion data) {
    return ProductUom(
      id: data.id.present ? data.id.value : this.id,
      productId: data.productId.present ? data.productId.value : this.productId,
      fromUnitId: data.fromUnitId.present
          ? data.fromUnitId.value
          : this.fromUnitId,
      toUnitId: data.toUnitId.present ? data.toUnitId.value : this.toUnitId,
      conversionFactor: data.conversionFactor.present
          ? data.conversionFactor.value
          : this.conversionFactor,
      isDefault: data.isDefault.present ? data.isDefault.value : this.isDefault,
      description: data.description.present
          ? data.description.value
          : this.description,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProductUom(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('fromUnitId: $fromUnitId, ')
          ..write('toUnitId: $toUnitId, ')
          ..write('conversionFactor: $conversionFactor, ')
          ..write('isDefault: $isDefault, ')
          ..write('description: $description, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    productId,
    fromUnitId,
    toUnitId,
    conversionFactor,
    isDefault,
    description,
    isActive,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProductUom &&
          other.id == this.id &&
          other.productId == this.productId &&
          other.fromUnitId == this.fromUnitId &&
          other.toUnitId == this.toUnitId &&
          other.conversionFactor == this.conversionFactor &&
          other.isDefault == this.isDefault &&
          other.description == this.description &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ProductUomsCompanion extends UpdateCompanion<ProductUom> {
  final Value<int> id;
  final Value<int> productId;
  final Value<int> fromUnitId;
  final Value<int> toUnitId;
  final Value<double> conversionFactor;
  final Value<bool> isDefault;
  final Value<String?> description;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const ProductUomsCompanion({
    this.id = const Value.absent(),
    this.productId = const Value.absent(),
    this.fromUnitId = const Value.absent(),
    this.toUnitId = const Value.absent(),
    this.conversionFactor = const Value.absent(),
    this.isDefault = const Value.absent(),
    this.description = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  ProductUomsCompanion.insert({
    this.id = const Value.absent(),
    required int productId,
    required int fromUnitId,
    required int toUnitId,
    required double conversionFactor,
    this.isDefault = const Value.absent(),
    this.description = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : productId = Value(productId),
       fromUnitId = Value(fromUnitId),
       toUnitId = Value(toUnitId),
       conversionFactor = Value(conversionFactor);
  static Insertable<ProductUom> custom({
    Expression<int>? id,
    Expression<int>? productId,
    Expression<int>? fromUnitId,
    Expression<int>? toUnitId,
    Expression<double>? conversionFactor,
    Expression<bool>? isDefault,
    Expression<String>? description,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (productId != null) 'product_id': productId,
      if (fromUnitId != null) 'from_unit_id': fromUnitId,
      if (toUnitId != null) 'to_unit_id': toUnitId,
      if (conversionFactor != null) 'conversion_factor': conversionFactor,
      if (isDefault != null) 'is_default': isDefault,
      if (description != null) 'description': description,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  ProductUomsCompanion copyWith({
    Value<int>? id,
    Value<int>? productId,
    Value<int>? fromUnitId,
    Value<int>? toUnitId,
    Value<double>? conversionFactor,
    Value<bool>? isDefault,
    Value<String?>? description,
    Value<bool>? isActive,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return ProductUomsCompanion(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      fromUnitId: fromUnitId ?? this.fromUnitId,
      toUnitId: toUnitId ?? this.toUnitId,
      conversionFactor: conversionFactor ?? this.conversionFactor,
      isDefault: isDefault ?? this.isDefault,
      description: description ?? this.description,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<int>(productId.value);
    }
    if (fromUnitId.present) {
      map['from_unit_id'] = Variable<int>(fromUnitId.value);
    }
    if (toUnitId.present) {
      map['to_unit_id'] = Variable<int>(toUnitId.value);
    }
    if (conversionFactor.present) {
      map['conversion_factor'] = Variable<double>(conversionFactor.value);
    }
    if (isDefault.present) {
      map['is_default'] = Variable<bool>(isDefault.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductUomsCompanion(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('fromUnitId: $fromUnitId, ')
          ..write('toUnitId: $toUnitId, ')
          ..write('conversionFactor: $conversionFactor, ')
          ..write('isDefault: $isDefault, ')
          ..write('description: $description, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $DocumentNumberSequencesTable extends DocumentNumberSequences
    with TableInfo<$DocumentNumberSequencesTable, DocumentNumberSequence> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DocumentNumberSequencesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _documentTypeMeta = const VerificationMeta(
    'documentType',
  );
  @override
  late final GeneratedColumn<String> documentType = GeneratedColumn<String>(
    'document_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _prefixMeta = const VerificationMeta('prefix');
  @override
  late final GeneratedColumn<String> prefix = GeneratedColumn<String>(
    'prefix',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _suffixMeta = const VerificationMeta('suffix');
  @override
  late final GeneratedColumn<String> suffix = GeneratedColumn<String>(
    'suffix',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastNumberMeta = const VerificationMeta(
    'lastNumber',
  );
  @override
  late final GeneratedColumn<int> lastNumber = GeneratedColumn<int>(
    'last_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _paddingMeta = const VerificationMeta(
    'padding',
  );
  @override
  late final GeneratedColumn<int> padding = GeneratedColumn<int>(
    'padding',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(4),
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    documentType,
    prefix,
    suffix,
    lastNumber,
    padding,
    isActive,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'document_number_sequence';
  @override
  VerificationContext validateIntegrity(
    Insertable<DocumentNumberSequence> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('document_type')) {
      context.handle(
        _documentTypeMeta,
        documentType.isAcceptableOrUnknown(
          data['document_type']!,
          _documentTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_documentTypeMeta);
    }
    if (data.containsKey('prefix')) {
      context.handle(
        _prefixMeta,
        prefix.isAcceptableOrUnknown(data['prefix']!, _prefixMeta),
      );
    } else if (isInserting) {
      context.missing(_prefixMeta);
    }
    if (data.containsKey('suffix')) {
      context.handle(
        _suffixMeta,
        suffix.isAcceptableOrUnknown(data['suffix']!, _suffixMeta),
      );
    }
    if (data.containsKey('last_number')) {
      context.handle(
        _lastNumberMeta,
        lastNumber.isAcceptableOrUnknown(data['last_number']!, _lastNumberMeta),
      );
    }
    if (data.containsKey('padding')) {
      context.handle(
        _paddingMeta,
        padding.isAcceptableOrUnknown(data['padding']!, _paddingMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DocumentNumberSequence map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DocumentNumberSequence(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      documentType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}document_type'],
      )!,
      prefix: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}prefix'],
      )!,
      suffix: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}suffix'],
      ),
      lastNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_number'],
      )!,
      padding: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}padding'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $DocumentNumberSequencesTable createAlias(String alias) {
    return $DocumentNumberSequencesTable(attachedDatabase, alias);
  }
}

class DocumentNumberSequence extends DataClass
    implements Insertable<DocumentNumberSequence> {
  final int id;
  final String documentType;
  final String prefix;
  final String? suffix;
  final int lastNumber;
  final int padding;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  const DocumentNumberSequence({
    required this.id,
    required this.documentType,
    required this.prefix,
    this.suffix,
    required this.lastNumber,
    required this.padding,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['document_type'] = Variable<String>(documentType);
    map['prefix'] = Variable<String>(prefix);
    if (!nullToAbsent || suffix != null) {
      map['suffix'] = Variable<String>(suffix);
    }
    map['last_number'] = Variable<int>(lastNumber);
    map['padding'] = Variable<int>(padding);
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  DocumentNumberSequencesCompanion toCompanion(bool nullToAbsent) {
    return DocumentNumberSequencesCompanion(
      id: Value(id),
      documentType: Value(documentType),
      prefix: Value(prefix),
      suffix: suffix == null && nullToAbsent
          ? const Value.absent()
          : Value(suffix),
      lastNumber: Value(lastNumber),
      padding: Value(padding),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory DocumentNumberSequence.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DocumentNumberSequence(
      id: serializer.fromJson<int>(json['id']),
      documentType: serializer.fromJson<String>(json['documentType']),
      prefix: serializer.fromJson<String>(json['prefix']),
      suffix: serializer.fromJson<String?>(json['suffix']),
      lastNumber: serializer.fromJson<int>(json['lastNumber']),
      padding: serializer.fromJson<int>(json['padding']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'documentType': serializer.toJson<String>(documentType),
      'prefix': serializer.toJson<String>(prefix),
      'suffix': serializer.toJson<String?>(suffix),
      'lastNumber': serializer.toJson<int>(lastNumber),
      'padding': serializer.toJson<int>(padding),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  DocumentNumberSequence copyWith({
    int? id,
    String? documentType,
    String? prefix,
    Value<String?> suffix = const Value.absent(),
    int? lastNumber,
    int? padding,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => DocumentNumberSequence(
    id: id ?? this.id,
    documentType: documentType ?? this.documentType,
    prefix: prefix ?? this.prefix,
    suffix: suffix.present ? suffix.value : this.suffix,
    lastNumber: lastNumber ?? this.lastNumber,
    padding: padding ?? this.padding,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  DocumentNumberSequence copyWithCompanion(
    DocumentNumberSequencesCompanion data,
  ) {
    return DocumentNumberSequence(
      id: data.id.present ? data.id.value : this.id,
      documentType: data.documentType.present
          ? data.documentType.value
          : this.documentType,
      prefix: data.prefix.present ? data.prefix.value : this.prefix,
      suffix: data.suffix.present ? data.suffix.value : this.suffix,
      lastNumber: data.lastNumber.present
          ? data.lastNumber.value
          : this.lastNumber,
      padding: data.padding.present ? data.padding.value : this.padding,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DocumentNumberSequence(')
          ..write('id: $id, ')
          ..write('documentType: $documentType, ')
          ..write('prefix: $prefix, ')
          ..write('suffix: $suffix, ')
          ..write('lastNumber: $lastNumber, ')
          ..write('padding: $padding, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    documentType,
    prefix,
    suffix,
    lastNumber,
    padding,
    isActive,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DocumentNumberSequence &&
          other.id == this.id &&
          other.documentType == this.documentType &&
          other.prefix == this.prefix &&
          other.suffix == this.suffix &&
          other.lastNumber == this.lastNumber &&
          other.padding == this.padding &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class DocumentNumberSequencesCompanion
    extends UpdateCompanion<DocumentNumberSequence> {
  final Value<int> id;
  final Value<String> documentType;
  final Value<String> prefix;
  final Value<String?> suffix;
  final Value<int> lastNumber;
  final Value<int> padding;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const DocumentNumberSequencesCompanion({
    this.id = const Value.absent(),
    this.documentType = const Value.absent(),
    this.prefix = const Value.absent(),
    this.suffix = const Value.absent(),
    this.lastNumber = const Value.absent(),
    this.padding = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  DocumentNumberSequencesCompanion.insert({
    this.id = const Value.absent(),
    required String documentType,
    required String prefix,
    this.suffix = const Value.absent(),
    this.lastNumber = const Value.absent(),
    this.padding = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : documentType = Value(documentType),
       prefix = Value(prefix);
  static Insertable<DocumentNumberSequence> custom({
    Expression<int>? id,
    Expression<String>? documentType,
    Expression<String>? prefix,
    Expression<String>? suffix,
    Expression<int>? lastNumber,
    Expression<int>? padding,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (documentType != null) 'document_type': documentType,
      if (prefix != null) 'prefix': prefix,
      if (suffix != null) 'suffix': suffix,
      if (lastNumber != null) 'last_number': lastNumber,
      if (padding != null) 'padding': padding,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  DocumentNumberSequencesCompanion copyWith({
    Value<int>? id,
    Value<String>? documentType,
    Value<String>? prefix,
    Value<String?>? suffix,
    Value<int>? lastNumber,
    Value<int>? padding,
    Value<bool>? isActive,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return DocumentNumberSequencesCompanion(
      id: id ?? this.id,
      documentType: documentType ?? this.documentType,
      prefix: prefix ?? this.prefix,
      suffix: suffix ?? this.suffix,
      lastNumber: lastNumber ?? this.lastNumber,
      padding: padding ?? this.padding,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (documentType.present) {
      map['document_type'] = Variable<String>(documentType.value);
    }
    if (prefix.present) {
      map['prefix'] = Variable<String>(prefix.value);
    }
    if (suffix.present) {
      map['suffix'] = Variable<String>(suffix.value);
    }
    if (lastNumber.present) {
      map['last_number'] = Variable<int>(lastNumber.value);
    }
    if (padding.present) {
      map['padding'] = Variable<int>(padding.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DocumentNumberSequencesCompanion(')
          ..write('id: $id, ')
          ..write('documentType: $documentType, ')
          ..write('prefix: $prefix, ')
          ..write('suffix: $suffix, ')
          ..write('lastNumber: $lastNumber, ')
          ..write('padding: $padding, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $PurchasesTable extends Purchases
    with TableInfo<$PurchasesTable, Purchase> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PurchasesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _purchaseNumberMeta = const VerificationMeta(
    'purchaseNumber',
  );
  @override
  late final GeneratedColumn<String> purchaseNumber = GeneratedColumn<String>(
    'purchase_number',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _supplierIdMeta = const VerificationMeta(
    'supplierId',
  );
  @override
  late final GeneratedColumn<int> supplierId = GeneratedColumn<int>(
    'supplier_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES supplier (id)',
    ),
  );
  static const VerificationMeta _purchaseDateMeta = const VerificationMeta(
    'purchaseDate',
  );
  @override
  late final GeneratedColumn<DateTime> purchaseDate = GeneratedColumn<DateTime>(
    'purchase_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _invoiceNumberMeta = const VerificationMeta(
    'invoiceNumber',
  );
  @override
  late final GeneratedColumn<String> invoiceNumber = GeneratedColumn<String>(
    'invoice_number',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _subtotalMeta = const VerificationMeta(
    'subtotal',
  );
  @override
  late final GeneratedColumn<int> subtotal = GeneratedColumn<int>(
    'subtotal',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _discountMeta = const VerificationMeta(
    'discount',
  );
  @override
  late final GeneratedColumn<int> discount = GeneratedColumn<int>(
    'discount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _taxMeta = const VerificationMeta('tax');
  @override
  late final GeneratedColumn<int> tax = GeneratedColumn<int>(
    'tax',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _totalMeta = const VerificationMeta('total');
  @override
  late final GeneratedColumn<int> total = GeneratedColumn<int>(
    'total',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _paidAmountMeta = const VerificationMeta(
    'paidAmount',
  );
  @override
  late final GeneratedColumn<int> paidAmount = GeneratedColumn<int>(
    'paid_amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _dueAmountMeta = const VerificationMeta(
    'dueAmount',
  );
  @override
  late final GeneratedColumn<int> dueAmount = GeneratedColumn<int>(
    'due_amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _paymentStatusMeta = const VerificationMeta(
    'paymentStatus',
  );
  @override
  late final GeneratedColumn<String> paymentStatus = GeneratedColumn<String>(
    'payment_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('UNPAID'),
  );
  static const VerificationMeta _paymentMethodMeta = const VerificationMeta(
    'paymentMethod',
  );
  @override
  late final GeneratedColumn<String> paymentMethod = GeneratedColumn<String>(
    'payment_method',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isReturnMeta = const VerificationMeta(
    'isReturn',
  );
  @override
  late final GeneratedColumn<bool> isReturn = GeneratedColumn<bool>(
    'is_return',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_return" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _originalPurchaseIdMeta =
      const VerificationMeta('originalPurchaseId');
  @override
  late final GeneratedColumn<int> originalPurchaseId = GeneratedColumn<int>(
    'original_purchase_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    purchaseNumber,
    supplierId,
    purchaseDate,
    invoiceNumber,
    subtotal,
    discount,
    tax,
    total,
    paidAmount,
    dueAmount,
    paymentStatus,
    paymentMethod,
    notes,
    isReturn,
    originalPurchaseId,
    isActive,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'purchase';
  @override
  VerificationContext validateIntegrity(
    Insertable<Purchase> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('purchase_number')) {
      context.handle(
        _purchaseNumberMeta,
        purchaseNumber.isAcceptableOrUnknown(
          data['purchase_number']!,
          _purchaseNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_purchaseNumberMeta);
    }
    if (data.containsKey('supplier_id')) {
      context.handle(
        _supplierIdMeta,
        supplierId.isAcceptableOrUnknown(data['supplier_id']!, _supplierIdMeta),
      );
    } else if (isInserting) {
      context.missing(_supplierIdMeta);
    }
    if (data.containsKey('purchase_date')) {
      context.handle(
        _purchaseDateMeta,
        purchaseDate.isAcceptableOrUnknown(
          data['purchase_date']!,
          _purchaseDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_purchaseDateMeta);
    }
    if (data.containsKey('invoice_number')) {
      context.handle(
        _invoiceNumberMeta,
        invoiceNumber.isAcceptableOrUnknown(
          data['invoice_number']!,
          _invoiceNumberMeta,
        ),
      );
    }
    if (data.containsKey('subtotal')) {
      context.handle(
        _subtotalMeta,
        subtotal.isAcceptableOrUnknown(data['subtotal']!, _subtotalMeta),
      );
    }
    if (data.containsKey('discount')) {
      context.handle(
        _discountMeta,
        discount.isAcceptableOrUnknown(data['discount']!, _discountMeta),
      );
    }
    if (data.containsKey('tax')) {
      context.handle(
        _taxMeta,
        tax.isAcceptableOrUnknown(data['tax']!, _taxMeta),
      );
    }
    if (data.containsKey('total')) {
      context.handle(
        _totalMeta,
        total.isAcceptableOrUnknown(data['total']!, _totalMeta),
      );
    }
    if (data.containsKey('paid_amount')) {
      context.handle(
        _paidAmountMeta,
        paidAmount.isAcceptableOrUnknown(data['paid_amount']!, _paidAmountMeta),
      );
    }
    if (data.containsKey('due_amount')) {
      context.handle(
        _dueAmountMeta,
        dueAmount.isAcceptableOrUnknown(data['due_amount']!, _dueAmountMeta),
      );
    }
    if (data.containsKey('payment_status')) {
      context.handle(
        _paymentStatusMeta,
        paymentStatus.isAcceptableOrUnknown(
          data['payment_status']!,
          _paymentStatusMeta,
        ),
      );
    }
    if (data.containsKey('payment_method')) {
      context.handle(
        _paymentMethodMeta,
        paymentMethod.isAcceptableOrUnknown(
          data['payment_method']!,
          _paymentMethodMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('is_return')) {
      context.handle(
        _isReturnMeta,
        isReturn.isAcceptableOrUnknown(data['is_return']!, _isReturnMeta),
      );
    }
    if (data.containsKey('original_purchase_id')) {
      context.handle(
        _originalPurchaseIdMeta,
        originalPurchaseId.isAcceptableOrUnknown(
          data['original_purchase_id']!,
          _originalPurchaseIdMeta,
        ),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Purchase map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Purchase(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      purchaseNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}purchase_number'],
      )!,
      supplierId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}supplier_id'],
      )!,
      purchaseDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}purchase_date'],
      )!,
      invoiceNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}invoice_number'],
      ),
      subtotal: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}subtotal'],
      )!,
      discount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}discount'],
      )!,
      tax: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tax'],
      )!,
      total: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total'],
      )!,
      paidAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}paid_amount'],
      )!,
      dueAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}due_amount'],
      )!,
      paymentStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payment_status'],
      )!,
      paymentMethod: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payment_method'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      isReturn: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_return'],
      )!,
      originalPurchaseId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}original_purchase_id'],
      ),
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $PurchasesTable createAlias(String alias) {
    return $PurchasesTable(attachedDatabase, alias);
  }
}

class Purchase extends DataClass implements Insertable<Purchase> {
  final int id;
  final String purchaseNumber;
  final int supplierId;
  final DateTime purchaseDate;
  final String? invoiceNumber;

  /// Subtotal before discount and tax, in paise.
  final int subtotal;

  /// Total discount across all items, in paise.
  final int discount;

  /// Total tax across all items, in paise.
  final int tax;

  /// Grand total = subtotal - discount + tax, in paise.
  final int total;

  /// Amount already paid to supplier, in paise.
  final int paidAmount;

  /// Amount due = total - paid, in paise.
  final int dueAmount;

  /// UNPAID, PARTIAL, or PAID — derived, never set by the user.
  final String paymentStatus;

  /// Payment method used for the initial payment: Cash, UPI, Bank, Card, Other.
  final String? paymentMethod;
  final String? notes;
  final bool isReturn;

  /// Reference to the original purchase when this is a return.
  final int? originalPurchaseId;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Purchase({
    required this.id,
    required this.purchaseNumber,
    required this.supplierId,
    required this.purchaseDate,
    this.invoiceNumber,
    required this.subtotal,
    required this.discount,
    required this.tax,
    required this.total,
    required this.paidAmount,
    required this.dueAmount,
    required this.paymentStatus,
    this.paymentMethod,
    this.notes,
    required this.isReturn,
    this.originalPurchaseId,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['purchase_number'] = Variable<String>(purchaseNumber);
    map['supplier_id'] = Variable<int>(supplierId);
    map['purchase_date'] = Variable<DateTime>(purchaseDate);
    if (!nullToAbsent || invoiceNumber != null) {
      map['invoice_number'] = Variable<String>(invoiceNumber);
    }
    map['subtotal'] = Variable<int>(subtotal);
    map['discount'] = Variable<int>(discount);
    map['tax'] = Variable<int>(tax);
    map['total'] = Variable<int>(total);
    map['paid_amount'] = Variable<int>(paidAmount);
    map['due_amount'] = Variable<int>(dueAmount);
    map['payment_status'] = Variable<String>(paymentStatus);
    if (!nullToAbsent || paymentMethod != null) {
      map['payment_method'] = Variable<String>(paymentMethod);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['is_return'] = Variable<bool>(isReturn);
    if (!nullToAbsent || originalPurchaseId != null) {
      map['original_purchase_id'] = Variable<int>(originalPurchaseId);
    }
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  PurchasesCompanion toCompanion(bool nullToAbsent) {
    return PurchasesCompanion(
      id: Value(id),
      purchaseNumber: Value(purchaseNumber),
      supplierId: Value(supplierId),
      purchaseDate: Value(purchaseDate),
      invoiceNumber: invoiceNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(invoiceNumber),
      subtotal: Value(subtotal),
      discount: Value(discount),
      tax: Value(tax),
      total: Value(total),
      paidAmount: Value(paidAmount),
      dueAmount: Value(dueAmount),
      paymentStatus: Value(paymentStatus),
      paymentMethod: paymentMethod == null && nullToAbsent
          ? const Value.absent()
          : Value(paymentMethod),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      isReturn: Value(isReturn),
      originalPurchaseId: originalPurchaseId == null && nullToAbsent
          ? const Value.absent()
          : Value(originalPurchaseId),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Purchase.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Purchase(
      id: serializer.fromJson<int>(json['id']),
      purchaseNumber: serializer.fromJson<String>(json['purchaseNumber']),
      supplierId: serializer.fromJson<int>(json['supplierId']),
      purchaseDate: serializer.fromJson<DateTime>(json['purchaseDate']),
      invoiceNumber: serializer.fromJson<String?>(json['invoiceNumber']),
      subtotal: serializer.fromJson<int>(json['subtotal']),
      discount: serializer.fromJson<int>(json['discount']),
      tax: serializer.fromJson<int>(json['tax']),
      total: serializer.fromJson<int>(json['total']),
      paidAmount: serializer.fromJson<int>(json['paidAmount']),
      dueAmount: serializer.fromJson<int>(json['dueAmount']),
      paymentStatus: serializer.fromJson<String>(json['paymentStatus']),
      paymentMethod: serializer.fromJson<String?>(json['paymentMethod']),
      notes: serializer.fromJson<String?>(json['notes']),
      isReturn: serializer.fromJson<bool>(json['isReturn']),
      originalPurchaseId: serializer.fromJson<int?>(json['originalPurchaseId']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'purchaseNumber': serializer.toJson<String>(purchaseNumber),
      'supplierId': serializer.toJson<int>(supplierId),
      'purchaseDate': serializer.toJson<DateTime>(purchaseDate),
      'invoiceNumber': serializer.toJson<String?>(invoiceNumber),
      'subtotal': serializer.toJson<int>(subtotal),
      'discount': serializer.toJson<int>(discount),
      'tax': serializer.toJson<int>(tax),
      'total': serializer.toJson<int>(total),
      'paidAmount': serializer.toJson<int>(paidAmount),
      'dueAmount': serializer.toJson<int>(dueAmount),
      'paymentStatus': serializer.toJson<String>(paymentStatus),
      'paymentMethod': serializer.toJson<String?>(paymentMethod),
      'notes': serializer.toJson<String?>(notes),
      'isReturn': serializer.toJson<bool>(isReturn),
      'originalPurchaseId': serializer.toJson<int?>(originalPurchaseId),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Purchase copyWith({
    int? id,
    String? purchaseNumber,
    int? supplierId,
    DateTime? purchaseDate,
    Value<String?> invoiceNumber = const Value.absent(),
    int? subtotal,
    int? discount,
    int? tax,
    int? total,
    int? paidAmount,
    int? dueAmount,
    String? paymentStatus,
    Value<String?> paymentMethod = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    bool? isReturn,
    Value<int?> originalPurchaseId = const Value.absent(),
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Purchase(
    id: id ?? this.id,
    purchaseNumber: purchaseNumber ?? this.purchaseNumber,
    supplierId: supplierId ?? this.supplierId,
    purchaseDate: purchaseDate ?? this.purchaseDate,
    invoiceNumber: invoiceNumber.present
        ? invoiceNumber.value
        : this.invoiceNumber,
    subtotal: subtotal ?? this.subtotal,
    discount: discount ?? this.discount,
    tax: tax ?? this.tax,
    total: total ?? this.total,
    paidAmount: paidAmount ?? this.paidAmount,
    dueAmount: dueAmount ?? this.dueAmount,
    paymentStatus: paymentStatus ?? this.paymentStatus,
    paymentMethod: paymentMethod.present
        ? paymentMethod.value
        : this.paymentMethod,
    notes: notes.present ? notes.value : this.notes,
    isReturn: isReturn ?? this.isReturn,
    originalPurchaseId: originalPurchaseId.present
        ? originalPurchaseId.value
        : this.originalPurchaseId,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Purchase copyWithCompanion(PurchasesCompanion data) {
    return Purchase(
      id: data.id.present ? data.id.value : this.id,
      purchaseNumber: data.purchaseNumber.present
          ? data.purchaseNumber.value
          : this.purchaseNumber,
      supplierId: data.supplierId.present
          ? data.supplierId.value
          : this.supplierId,
      purchaseDate: data.purchaseDate.present
          ? data.purchaseDate.value
          : this.purchaseDate,
      invoiceNumber: data.invoiceNumber.present
          ? data.invoiceNumber.value
          : this.invoiceNumber,
      subtotal: data.subtotal.present ? data.subtotal.value : this.subtotal,
      discount: data.discount.present ? data.discount.value : this.discount,
      tax: data.tax.present ? data.tax.value : this.tax,
      total: data.total.present ? data.total.value : this.total,
      paidAmount: data.paidAmount.present
          ? data.paidAmount.value
          : this.paidAmount,
      dueAmount: data.dueAmount.present ? data.dueAmount.value : this.dueAmount,
      paymentStatus: data.paymentStatus.present
          ? data.paymentStatus.value
          : this.paymentStatus,
      paymentMethod: data.paymentMethod.present
          ? data.paymentMethod.value
          : this.paymentMethod,
      notes: data.notes.present ? data.notes.value : this.notes,
      isReturn: data.isReturn.present ? data.isReturn.value : this.isReturn,
      originalPurchaseId: data.originalPurchaseId.present
          ? data.originalPurchaseId.value
          : this.originalPurchaseId,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Purchase(')
          ..write('id: $id, ')
          ..write('purchaseNumber: $purchaseNumber, ')
          ..write('supplierId: $supplierId, ')
          ..write('purchaseDate: $purchaseDate, ')
          ..write('invoiceNumber: $invoiceNumber, ')
          ..write('subtotal: $subtotal, ')
          ..write('discount: $discount, ')
          ..write('tax: $tax, ')
          ..write('total: $total, ')
          ..write('paidAmount: $paidAmount, ')
          ..write('dueAmount: $dueAmount, ')
          ..write('paymentStatus: $paymentStatus, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('notes: $notes, ')
          ..write('isReturn: $isReturn, ')
          ..write('originalPurchaseId: $originalPurchaseId, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    purchaseNumber,
    supplierId,
    purchaseDate,
    invoiceNumber,
    subtotal,
    discount,
    tax,
    total,
    paidAmount,
    dueAmount,
    paymentStatus,
    paymentMethod,
    notes,
    isReturn,
    originalPurchaseId,
    isActive,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Purchase &&
          other.id == this.id &&
          other.purchaseNumber == this.purchaseNumber &&
          other.supplierId == this.supplierId &&
          other.purchaseDate == this.purchaseDate &&
          other.invoiceNumber == this.invoiceNumber &&
          other.subtotal == this.subtotal &&
          other.discount == this.discount &&
          other.tax == this.tax &&
          other.total == this.total &&
          other.paidAmount == this.paidAmount &&
          other.dueAmount == this.dueAmount &&
          other.paymentStatus == this.paymentStatus &&
          other.paymentMethod == this.paymentMethod &&
          other.notes == this.notes &&
          other.isReturn == this.isReturn &&
          other.originalPurchaseId == this.originalPurchaseId &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class PurchasesCompanion extends UpdateCompanion<Purchase> {
  final Value<int> id;
  final Value<String> purchaseNumber;
  final Value<int> supplierId;
  final Value<DateTime> purchaseDate;
  final Value<String?> invoiceNumber;
  final Value<int> subtotal;
  final Value<int> discount;
  final Value<int> tax;
  final Value<int> total;
  final Value<int> paidAmount;
  final Value<int> dueAmount;
  final Value<String> paymentStatus;
  final Value<String?> paymentMethod;
  final Value<String?> notes;
  final Value<bool> isReturn;
  final Value<int?> originalPurchaseId;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const PurchasesCompanion({
    this.id = const Value.absent(),
    this.purchaseNumber = const Value.absent(),
    this.supplierId = const Value.absent(),
    this.purchaseDate = const Value.absent(),
    this.invoiceNumber = const Value.absent(),
    this.subtotal = const Value.absent(),
    this.discount = const Value.absent(),
    this.tax = const Value.absent(),
    this.total = const Value.absent(),
    this.paidAmount = const Value.absent(),
    this.dueAmount = const Value.absent(),
    this.paymentStatus = const Value.absent(),
    this.paymentMethod = const Value.absent(),
    this.notes = const Value.absent(),
    this.isReturn = const Value.absent(),
    this.originalPurchaseId = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  PurchasesCompanion.insert({
    this.id = const Value.absent(),
    required String purchaseNumber,
    required int supplierId,
    required DateTime purchaseDate,
    this.invoiceNumber = const Value.absent(),
    this.subtotal = const Value.absent(),
    this.discount = const Value.absent(),
    this.tax = const Value.absent(),
    this.total = const Value.absent(),
    this.paidAmount = const Value.absent(),
    this.dueAmount = const Value.absent(),
    this.paymentStatus = const Value.absent(),
    this.paymentMethod = const Value.absent(),
    this.notes = const Value.absent(),
    this.isReturn = const Value.absent(),
    this.originalPurchaseId = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : purchaseNumber = Value(purchaseNumber),
       supplierId = Value(supplierId),
       purchaseDate = Value(purchaseDate);
  static Insertable<Purchase> custom({
    Expression<int>? id,
    Expression<String>? purchaseNumber,
    Expression<int>? supplierId,
    Expression<DateTime>? purchaseDate,
    Expression<String>? invoiceNumber,
    Expression<int>? subtotal,
    Expression<int>? discount,
    Expression<int>? tax,
    Expression<int>? total,
    Expression<int>? paidAmount,
    Expression<int>? dueAmount,
    Expression<String>? paymentStatus,
    Expression<String>? paymentMethod,
    Expression<String>? notes,
    Expression<bool>? isReturn,
    Expression<int>? originalPurchaseId,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (purchaseNumber != null) 'purchase_number': purchaseNumber,
      if (supplierId != null) 'supplier_id': supplierId,
      if (purchaseDate != null) 'purchase_date': purchaseDate,
      if (invoiceNumber != null) 'invoice_number': invoiceNumber,
      if (subtotal != null) 'subtotal': subtotal,
      if (discount != null) 'discount': discount,
      if (tax != null) 'tax': tax,
      if (total != null) 'total': total,
      if (paidAmount != null) 'paid_amount': paidAmount,
      if (dueAmount != null) 'due_amount': dueAmount,
      if (paymentStatus != null) 'payment_status': paymentStatus,
      if (paymentMethod != null) 'payment_method': paymentMethod,
      if (notes != null) 'notes': notes,
      if (isReturn != null) 'is_return': isReturn,
      if (originalPurchaseId != null)
        'original_purchase_id': originalPurchaseId,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  PurchasesCompanion copyWith({
    Value<int>? id,
    Value<String>? purchaseNumber,
    Value<int>? supplierId,
    Value<DateTime>? purchaseDate,
    Value<String?>? invoiceNumber,
    Value<int>? subtotal,
    Value<int>? discount,
    Value<int>? tax,
    Value<int>? total,
    Value<int>? paidAmount,
    Value<int>? dueAmount,
    Value<String>? paymentStatus,
    Value<String?>? paymentMethod,
    Value<String?>? notes,
    Value<bool>? isReturn,
    Value<int?>? originalPurchaseId,
    Value<bool>? isActive,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return PurchasesCompanion(
      id: id ?? this.id,
      purchaseNumber: purchaseNumber ?? this.purchaseNumber,
      supplierId: supplierId ?? this.supplierId,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      subtotal: subtotal ?? this.subtotal,
      discount: discount ?? this.discount,
      tax: tax ?? this.tax,
      total: total ?? this.total,
      paidAmount: paidAmount ?? this.paidAmount,
      dueAmount: dueAmount ?? this.dueAmount,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      notes: notes ?? this.notes,
      isReturn: isReturn ?? this.isReturn,
      originalPurchaseId: originalPurchaseId ?? this.originalPurchaseId,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (purchaseNumber.present) {
      map['purchase_number'] = Variable<String>(purchaseNumber.value);
    }
    if (supplierId.present) {
      map['supplier_id'] = Variable<int>(supplierId.value);
    }
    if (purchaseDate.present) {
      map['purchase_date'] = Variable<DateTime>(purchaseDate.value);
    }
    if (invoiceNumber.present) {
      map['invoice_number'] = Variable<String>(invoiceNumber.value);
    }
    if (subtotal.present) {
      map['subtotal'] = Variable<int>(subtotal.value);
    }
    if (discount.present) {
      map['discount'] = Variable<int>(discount.value);
    }
    if (tax.present) {
      map['tax'] = Variable<int>(tax.value);
    }
    if (total.present) {
      map['total'] = Variable<int>(total.value);
    }
    if (paidAmount.present) {
      map['paid_amount'] = Variable<int>(paidAmount.value);
    }
    if (dueAmount.present) {
      map['due_amount'] = Variable<int>(dueAmount.value);
    }
    if (paymentStatus.present) {
      map['payment_status'] = Variable<String>(paymentStatus.value);
    }
    if (paymentMethod.present) {
      map['payment_method'] = Variable<String>(paymentMethod.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (isReturn.present) {
      map['is_return'] = Variable<bool>(isReturn.value);
    }
    if (originalPurchaseId.present) {
      map['original_purchase_id'] = Variable<int>(originalPurchaseId.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PurchasesCompanion(')
          ..write('id: $id, ')
          ..write('purchaseNumber: $purchaseNumber, ')
          ..write('supplierId: $supplierId, ')
          ..write('purchaseDate: $purchaseDate, ')
          ..write('invoiceNumber: $invoiceNumber, ')
          ..write('subtotal: $subtotal, ')
          ..write('discount: $discount, ')
          ..write('tax: $tax, ')
          ..write('total: $total, ')
          ..write('paidAmount: $paidAmount, ')
          ..write('dueAmount: $dueAmount, ')
          ..write('paymentStatus: $paymentStatus, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('notes: $notes, ')
          ..write('isReturn: $isReturn, ')
          ..write('originalPurchaseId: $originalPurchaseId, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $PurchaseItemsTable extends PurchaseItems
    with TableInfo<$PurchaseItemsTable, PurchaseItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PurchaseItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _purchaseIdMeta = const VerificationMeta(
    'purchaseId',
  );
  @override
  late final GeneratedColumn<int> purchaseId = GeneratedColumn<int>(
    'purchase_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES purchase (id)',
    ),
  );
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<int> productId = GeneratedColumn<int>(
    'product_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES product (id)',
    ),
  );
  static const VerificationMeta _variantIdMeta = const VerificationMeta(
    'variantId',
  );
  @override
  late final GeneratedColumn<int> variantId = GeneratedColumn<int>(
    'variant_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES product_variant (id)',
    ),
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitIdMeta = const VerificationMeta('unitId');
  @override
  late final GeneratedColumn<int> unitId = GeneratedColumn<int>(
    'unit_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES unit (id)',
    ),
  );
  static const VerificationMeta _purchasePriceMeta = const VerificationMeta(
    'purchasePrice',
  );
  @override
  late final GeneratedColumn<int> purchasePrice = GeneratedColumn<int>(
    'purchase_price',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _discountMeta = const VerificationMeta(
    'discount',
  );
  @override
  late final GeneratedColumn<int> discount = GeneratedColumn<int>(
    'discount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _taxRateMeta = const VerificationMeta(
    'taxRate',
  );
  @override
  late final GeneratedColumn<double> taxRate = GeneratedColumn<double>(
    'tax_rate',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _taxAmountMeta = const VerificationMeta(
    'taxAmount',
  );
  @override
  late final GeneratedColumn<int> taxAmount = GeneratedColumn<int>(
    'tax_amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lineTotalMeta = const VerificationMeta(
    'lineTotal',
  );
  @override
  late final GeneratedColumn<int> lineTotal = GeneratedColumn<int>(
    'line_total',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _returnedQuantityMeta = const VerificationMeta(
    'returnedQuantity',
  );
  @override
  late final GeneratedColumn<int> returnedQuantity = GeneratedColumn<int>(
    'returned_quantity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    purchaseId,
    productId,
    variantId,
    quantity,
    unitId,
    purchasePrice,
    discount,
    taxRate,
    taxAmount,
    lineTotal,
    returnedQuantity,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'purchase_item';
  @override
  VerificationContext validateIntegrity(
    Insertable<PurchaseItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('purchase_id')) {
      context.handle(
        _purchaseIdMeta,
        purchaseId.isAcceptableOrUnknown(data['purchase_id']!, _purchaseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_purchaseIdMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('variant_id')) {
      context.handle(
        _variantIdMeta,
        variantId.isAcceptableOrUnknown(data['variant_id']!, _variantIdMeta),
      );
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('unit_id')) {
      context.handle(
        _unitIdMeta,
        unitId.isAcceptableOrUnknown(data['unit_id']!, _unitIdMeta),
      );
    } else if (isInserting) {
      context.missing(_unitIdMeta);
    }
    if (data.containsKey('purchase_price')) {
      context.handle(
        _purchasePriceMeta,
        purchasePrice.isAcceptableOrUnknown(
          data['purchase_price']!,
          _purchasePriceMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_purchasePriceMeta);
    }
    if (data.containsKey('discount')) {
      context.handle(
        _discountMeta,
        discount.isAcceptableOrUnknown(data['discount']!, _discountMeta),
      );
    }
    if (data.containsKey('tax_rate')) {
      context.handle(
        _taxRateMeta,
        taxRate.isAcceptableOrUnknown(data['tax_rate']!, _taxRateMeta),
      );
    }
    if (data.containsKey('tax_amount')) {
      context.handle(
        _taxAmountMeta,
        taxAmount.isAcceptableOrUnknown(data['tax_amount']!, _taxAmountMeta),
      );
    }
    if (data.containsKey('line_total')) {
      context.handle(
        _lineTotalMeta,
        lineTotal.isAcceptableOrUnknown(data['line_total']!, _lineTotalMeta),
      );
    }
    if (data.containsKey('returned_quantity')) {
      context.handle(
        _returnedQuantityMeta,
        returnedQuantity.isAcceptableOrUnknown(
          data['returned_quantity']!,
          _returnedQuantityMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PurchaseItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PurchaseItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      purchaseId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}purchase_id'],
      )!,
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}product_id'],
      )!,
      variantId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}variant_id'],
      ),
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quantity'],
      )!,
      unitId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}unit_id'],
      )!,
      purchasePrice: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}purchase_price'],
      )!,
      discount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}discount'],
      )!,
      taxRate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}tax_rate'],
      )!,
      taxAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tax_amount'],
      )!,
      lineTotal: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}line_total'],
      )!,
      returnedQuantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}returned_quantity'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $PurchaseItemsTable createAlias(String alias) {
    return $PurchaseItemsTable(attachedDatabase, alias);
  }
}

class PurchaseItem extends DataClass implements Insertable<PurchaseItem> {
  final int id;
  final int purchaseId;
  final int productId;
  final int? variantId;

  /// Quantity purchased.
  final int quantity;

  /// Unit of measure — references the product's unit.
  final int unitId;

  /// Price per unit paid to supplier, in paise.
  final int purchasePrice;

  /// Line-level discount, in paise.
  final int discount;

  /// Tax rate percent (e.g. 18 for 18%).
  final double taxRate;

  /// Tax amount in paise.
  final int taxAmount;

  /// line_total = (qty * price) - discount + tax_amount, in paise.
  final int lineTotal;

  /// For returns: quantity returned against this item.
  final int returnedQuantity;
  final DateTime createdAt;
  final DateTime updatedAt;
  const PurchaseItem({
    required this.id,
    required this.purchaseId,
    required this.productId,
    this.variantId,
    required this.quantity,
    required this.unitId,
    required this.purchasePrice,
    required this.discount,
    required this.taxRate,
    required this.taxAmount,
    required this.lineTotal,
    required this.returnedQuantity,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['purchase_id'] = Variable<int>(purchaseId);
    map['product_id'] = Variable<int>(productId);
    if (!nullToAbsent || variantId != null) {
      map['variant_id'] = Variable<int>(variantId);
    }
    map['quantity'] = Variable<int>(quantity);
    map['unit_id'] = Variable<int>(unitId);
    map['purchase_price'] = Variable<int>(purchasePrice);
    map['discount'] = Variable<int>(discount);
    map['tax_rate'] = Variable<double>(taxRate);
    map['tax_amount'] = Variable<int>(taxAmount);
    map['line_total'] = Variable<int>(lineTotal);
    map['returned_quantity'] = Variable<int>(returnedQuantity);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  PurchaseItemsCompanion toCompanion(bool nullToAbsent) {
    return PurchaseItemsCompanion(
      id: Value(id),
      purchaseId: Value(purchaseId),
      productId: Value(productId),
      variantId: variantId == null && nullToAbsent
          ? const Value.absent()
          : Value(variantId),
      quantity: Value(quantity),
      unitId: Value(unitId),
      purchasePrice: Value(purchasePrice),
      discount: Value(discount),
      taxRate: Value(taxRate),
      taxAmount: Value(taxAmount),
      lineTotal: Value(lineTotal),
      returnedQuantity: Value(returnedQuantity),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory PurchaseItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PurchaseItem(
      id: serializer.fromJson<int>(json['id']),
      purchaseId: serializer.fromJson<int>(json['purchaseId']),
      productId: serializer.fromJson<int>(json['productId']),
      variantId: serializer.fromJson<int?>(json['variantId']),
      quantity: serializer.fromJson<int>(json['quantity']),
      unitId: serializer.fromJson<int>(json['unitId']),
      purchasePrice: serializer.fromJson<int>(json['purchasePrice']),
      discount: serializer.fromJson<int>(json['discount']),
      taxRate: serializer.fromJson<double>(json['taxRate']),
      taxAmount: serializer.fromJson<int>(json['taxAmount']),
      lineTotal: serializer.fromJson<int>(json['lineTotal']),
      returnedQuantity: serializer.fromJson<int>(json['returnedQuantity']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'purchaseId': serializer.toJson<int>(purchaseId),
      'productId': serializer.toJson<int>(productId),
      'variantId': serializer.toJson<int?>(variantId),
      'quantity': serializer.toJson<int>(quantity),
      'unitId': serializer.toJson<int>(unitId),
      'purchasePrice': serializer.toJson<int>(purchasePrice),
      'discount': serializer.toJson<int>(discount),
      'taxRate': serializer.toJson<double>(taxRate),
      'taxAmount': serializer.toJson<int>(taxAmount),
      'lineTotal': serializer.toJson<int>(lineTotal),
      'returnedQuantity': serializer.toJson<int>(returnedQuantity),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  PurchaseItem copyWith({
    int? id,
    int? purchaseId,
    int? productId,
    Value<int?> variantId = const Value.absent(),
    int? quantity,
    int? unitId,
    int? purchasePrice,
    int? discount,
    double? taxRate,
    int? taxAmount,
    int? lineTotal,
    int? returnedQuantity,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => PurchaseItem(
    id: id ?? this.id,
    purchaseId: purchaseId ?? this.purchaseId,
    productId: productId ?? this.productId,
    variantId: variantId.present ? variantId.value : this.variantId,
    quantity: quantity ?? this.quantity,
    unitId: unitId ?? this.unitId,
    purchasePrice: purchasePrice ?? this.purchasePrice,
    discount: discount ?? this.discount,
    taxRate: taxRate ?? this.taxRate,
    taxAmount: taxAmount ?? this.taxAmount,
    lineTotal: lineTotal ?? this.lineTotal,
    returnedQuantity: returnedQuantity ?? this.returnedQuantity,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  PurchaseItem copyWithCompanion(PurchaseItemsCompanion data) {
    return PurchaseItem(
      id: data.id.present ? data.id.value : this.id,
      purchaseId: data.purchaseId.present
          ? data.purchaseId.value
          : this.purchaseId,
      productId: data.productId.present ? data.productId.value : this.productId,
      variantId: data.variantId.present ? data.variantId.value : this.variantId,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      unitId: data.unitId.present ? data.unitId.value : this.unitId,
      purchasePrice: data.purchasePrice.present
          ? data.purchasePrice.value
          : this.purchasePrice,
      discount: data.discount.present ? data.discount.value : this.discount,
      taxRate: data.taxRate.present ? data.taxRate.value : this.taxRate,
      taxAmount: data.taxAmount.present ? data.taxAmount.value : this.taxAmount,
      lineTotal: data.lineTotal.present ? data.lineTotal.value : this.lineTotal,
      returnedQuantity: data.returnedQuantity.present
          ? data.returnedQuantity.value
          : this.returnedQuantity,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PurchaseItem(')
          ..write('id: $id, ')
          ..write('purchaseId: $purchaseId, ')
          ..write('productId: $productId, ')
          ..write('variantId: $variantId, ')
          ..write('quantity: $quantity, ')
          ..write('unitId: $unitId, ')
          ..write('purchasePrice: $purchasePrice, ')
          ..write('discount: $discount, ')
          ..write('taxRate: $taxRate, ')
          ..write('taxAmount: $taxAmount, ')
          ..write('lineTotal: $lineTotal, ')
          ..write('returnedQuantity: $returnedQuantity, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    purchaseId,
    productId,
    variantId,
    quantity,
    unitId,
    purchasePrice,
    discount,
    taxRate,
    taxAmount,
    lineTotal,
    returnedQuantity,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PurchaseItem &&
          other.id == this.id &&
          other.purchaseId == this.purchaseId &&
          other.productId == this.productId &&
          other.variantId == this.variantId &&
          other.quantity == this.quantity &&
          other.unitId == this.unitId &&
          other.purchasePrice == this.purchasePrice &&
          other.discount == this.discount &&
          other.taxRate == this.taxRate &&
          other.taxAmount == this.taxAmount &&
          other.lineTotal == this.lineTotal &&
          other.returnedQuantity == this.returnedQuantity &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class PurchaseItemsCompanion extends UpdateCompanion<PurchaseItem> {
  final Value<int> id;
  final Value<int> purchaseId;
  final Value<int> productId;
  final Value<int?> variantId;
  final Value<int> quantity;
  final Value<int> unitId;
  final Value<int> purchasePrice;
  final Value<int> discount;
  final Value<double> taxRate;
  final Value<int> taxAmount;
  final Value<int> lineTotal;
  final Value<int> returnedQuantity;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const PurchaseItemsCompanion({
    this.id = const Value.absent(),
    this.purchaseId = const Value.absent(),
    this.productId = const Value.absent(),
    this.variantId = const Value.absent(),
    this.quantity = const Value.absent(),
    this.unitId = const Value.absent(),
    this.purchasePrice = const Value.absent(),
    this.discount = const Value.absent(),
    this.taxRate = const Value.absent(),
    this.taxAmount = const Value.absent(),
    this.lineTotal = const Value.absent(),
    this.returnedQuantity = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  PurchaseItemsCompanion.insert({
    this.id = const Value.absent(),
    required int purchaseId,
    required int productId,
    this.variantId = const Value.absent(),
    required int quantity,
    required int unitId,
    required int purchasePrice,
    this.discount = const Value.absent(),
    this.taxRate = const Value.absent(),
    this.taxAmount = const Value.absent(),
    this.lineTotal = const Value.absent(),
    this.returnedQuantity = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : purchaseId = Value(purchaseId),
       productId = Value(productId),
       quantity = Value(quantity),
       unitId = Value(unitId),
       purchasePrice = Value(purchasePrice);
  static Insertable<PurchaseItem> custom({
    Expression<int>? id,
    Expression<int>? purchaseId,
    Expression<int>? productId,
    Expression<int>? variantId,
    Expression<int>? quantity,
    Expression<int>? unitId,
    Expression<int>? purchasePrice,
    Expression<int>? discount,
    Expression<double>? taxRate,
    Expression<int>? taxAmount,
    Expression<int>? lineTotal,
    Expression<int>? returnedQuantity,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (purchaseId != null) 'purchase_id': purchaseId,
      if (productId != null) 'product_id': productId,
      if (variantId != null) 'variant_id': variantId,
      if (quantity != null) 'quantity': quantity,
      if (unitId != null) 'unit_id': unitId,
      if (purchasePrice != null) 'purchase_price': purchasePrice,
      if (discount != null) 'discount': discount,
      if (taxRate != null) 'tax_rate': taxRate,
      if (taxAmount != null) 'tax_amount': taxAmount,
      if (lineTotal != null) 'line_total': lineTotal,
      if (returnedQuantity != null) 'returned_quantity': returnedQuantity,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  PurchaseItemsCompanion copyWith({
    Value<int>? id,
    Value<int>? purchaseId,
    Value<int>? productId,
    Value<int?>? variantId,
    Value<int>? quantity,
    Value<int>? unitId,
    Value<int>? purchasePrice,
    Value<int>? discount,
    Value<double>? taxRate,
    Value<int>? taxAmount,
    Value<int>? lineTotal,
    Value<int>? returnedQuantity,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return PurchaseItemsCompanion(
      id: id ?? this.id,
      purchaseId: purchaseId ?? this.purchaseId,
      productId: productId ?? this.productId,
      variantId: variantId ?? this.variantId,
      quantity: quantity ?? this.quantity,
      unitId: unitId ?? this.unitId,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      discount: discount ?? this.discount,
      taxRate: taxRate ?? this.taxRate,
      taxAmount: taxAmount ?? this.taxAmount,
      lineTotal: lineTotal ?? this.lineTotal,
      returnedQuantity: returnedQuantity ?? this.returnedQuantity,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (purchaseId.present) {
      map['purchase_id'] = Variable<int>(purchaseId.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<int>(productId.value);
    }
    if (variantId.present) {
      map['variant_id'] = Variable<int>(variantId.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (unitId.present) {
      map['unit_id'] = Variable<int>(unitId.value);
    }
    if (purchasePrice.present) {
      map['purchase_price'] = Variable<int>(purchasePrice.value);
    }
    if (discount.present) {
      map['discount'] = Variable<int>(discount.value);
    }
    if (taxRate.present) {
      map['tax_rate'] = Variable<double>(taxRate.value);
    }
    if (taxAmount.present) {
      map['tax_amount'] = Variable<int>(taxAmount.value);
    }
    if (lineTotal.present) {
      map['line_total'] = Variable<int>(lineTotal.value);
    }
    if (returnedQuantity.present) {
      map['returned_quantity'] = Variable<int>(returnedQuantity.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PurchaseItemsCompanion(')
          ..write('id: $id, ')
          ..write('purchaseId: $purchaseId, ')
          ..write('productId: $productId, ')
          ..write('variantId: $variantId, ')
          ..write('quantity: $quantity, ')
          ..write('unitId: $unitId, ')
          ..write('purchasePrice: $purchasePrice, ')
          ..write('discount: $discount, ')
          ..write('taxRate: $taxRate, ')
          ..write('taxAmount: $taxAmount, ')
          ..write('lineTotal: $lineTotal, ')
          ..write('returnedQuantity: $returnedQuantity, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $InventoryTransactionsTable extends InventoryTransactions
    with TableInfo<$InventoryTransactionsTable, InventoryTransaction> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InventoryTransactionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<int> productId = GeneratedColumn<int>(
    'product_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES product (id)',
    ),
  );
  static const VerificationMeta _variantIdMeta = const VerificationMeta(
    'variantId',
  );
  @override
  late final GeneratedColumn<int> variantId = GeneratedColumn<int>(
    'variant_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES product_variant (id)',
    ),
  );
  static const VerificationMeta _transactionTypeMeta = const VerificationMeta(
    'transactionType',
  );
  @override
  late final GeneratedColumn<String> transactionType = GeneratedColumn<String>(
    'transaction_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _purchaseIdMeta = const VerificationMeta(
    'purchaseId',
  );
  @override
  late final GeneratedColumn<int> purchaseId = GeneratedColumn<int>(
    'purchase_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES purchase (id)',
    ),
  );
  static const VerificationMeta _transactionDateMeta = const VerificationMeta(
    'transactionDate',
  );
  @override
  late final GeneratedColumn<DateTime> transactionDate =
      GeneratedColumn<DateTime>(
        'transaction_date',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _referenceNumberMeta = const VerificationMeta(
    'referenceNumber',
  );
  @override
  late final GeneratedColumn<String> referenceNumber = GeneratedColumn<String>(
    'reference_number',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    productId,
    variantId,
    transactionType,
    quantity,
    purchaseId,
    transactionDate,
    referenceNumber,
    notes,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'inventory_transaction';
  @override
  VerificationContext validateIntegrity(
    Insertable<InventoryTransaction> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('variant_id')) {
      context.handle(
        _variantIdMeta,
        variantId.isAcceptableOrUnknown(data['variant_id']!, _variantIdMeta),
      );
    }
    if (data.containsKey('transaction_type')) {
      context.handle(
        _transactionTypeMeta,
        transactionType.isAcceptableOrUnknown(
          data['transaction_type']!,
          _transactionTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_transactionTypeMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('purchase_id')) {
      context.handle(
        _purchaseIdMeta,
        purchaseId.isAcceptableOrUnknown(data['purchase_id']!, _purchaseIdMeta),
      );
    }
    if (data.containsKey('transaction_date')) {
      context.handle(
        _transactionDateMeta,
        transactionDate.isAcceptableOrUnknown(
          data['transaction_date']!,
          _transactionDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_transactionDateMeta);
    }
    if (data.containsKey('reference_number')) {
      context.handle(
        _referenceNumberMeta,
        referenceNumber.isAcceptableOrUnknown(
          data['reference_number']!,
          _referenceNumberMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  InventoryTransaction map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InventoryTransaction(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}product_id'],
      )!,
      variantId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}variant_id'],
      ),
      transactionType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}transaction_type'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quantity'],
      )!,
      purchaseId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}purchase_id'],
      ),
      transactionDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}transaction_date'],
      )!,
      referenceNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reference_number'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $InventoryTransactionsTable createAlias(String alias) {
    return $InventoryTransactionsTable(attachedDatabase, alias);
  }
}

class InventoryTransaction extends DataClass
    implements Insertable<InventoryTransaction> {
  final int id;
  final int productId;
  final int? variantId;

  /// PURCHASE, PURCHASE_RETURN, MANUAL_ADJUSTMENT, SALE.
  final String transactionType;

  /// Positive for stock in, negative for stock out.
  final int quantity;

  /// Reference purchase ID for purchase/return transactions.
  final int? purchaseId;
  final DateTime transactionDate;
  final String? referenceNumber;
  final String? notes;
  final DateTime createdAt;
  const InventoryTransaction({
    required this.id,
    required this.productId,
    this.variantId,
    required this.transactionType,
    required this.quantity,
    this.purchaseId,
    required this.transactionDate,
    this.referenceNumber,
    this.notes,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['product_id'] = Variable<int>(productId);
    if (!nullToAbsent || variantId != null) {
      map['variant_id'] = Variable<int>(variantId);
    }
    map['transaction_type'] = Variable<String>(transactionType);
    map['quantity'] = Variable<int>(quantity);
    if (!nullToAbsent || purchaseId != null) {
      map['purchase_id'] = Variable<int>(purchaseId);
    }
    map['transaction_date'] = Variable<DateTime>(transactionDate);
    if (!nullToAbsent || referenceNumber != null) {
      map['reference_number'] = Variable<String>(referenceNumber);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  InventoryTransactionsCompanion toCompanion(bool nullToAbsent) {
    return InventoryTransactionsCompanion(
      id: Value(id),
      productId: Value(productId),
      variantId: variantId == null && nullToAbsent
          ? const Value.absent()
          : Value(variantId),
      transactionType: Value(transactionType),
      quantity: Value(quantity),
      purchaseId: purchaseId == null && nullToAbsent
          ? const Value.absent()
          : Value(purchaseId),
      transactionDate: Value(transactionDate),
      referenceNumber: referenceNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(referenceNumber),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
    );
  }

  factory InventoryTransaction.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InventoryTransaction(
      id: serializer.fromJson<int>(json['id']),
      productId: serializer.fromJson<int>(json['productId']),
      variantId: serializer.fromJson<int?>(json['variantId']),
      transactionType: serializer.fromJson<String>(json['transactionType']),
      quantity: serializer.fromJson<int>(json['quantity']),
      purchaseId: serializer.fromJson<int?>(json['purchaseId']),
      transactionDate: serializer.fromJson<DateTime>(json['transactionDate']),
      referenceNumber: serializer.fromJson<String?>(json['referenceNumber']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'productId': serializer.toJson<int>(productId),
      'variantId': serializer.toJson<int?>(variantId),
      'transactionType': serializer.toJson<String>(transactionType),
      'quantity': serializer.toJson<int>(quantity),
      'purchaseId': serializer.toJson<int?>(purchaseId),
      'transactionDate': serializer.toJson<DateTime>(transactionDate),
      'referenceNumber': serializer.toJson<String?>(referenceNumber),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  InventoryTransaction copyWith({
    int? id,
    int? productId,
    Value<int?> variantId = const Value.absent(),
    String? transactionType,
    int? quantity,
    Value<int?> purchaseId = const Value.absent(),
    DateTime? transactionDate,
    Value<String?> referenceNumber = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    DateTime? createdAt,
  }) => InventoryTransaction(
    id: id ?? this.id,
    productId: productId ?? this.productId,
    variantId: variantId.present ? variantId.value : this.variantId,
    transactionType: transactionType ?? this.transactionType,
    quantity: quantity ?? this.quantity,
    purchaseId: purchaseId.present ? purchaseId.value : this.purchaseId,
    transactionDate: transactionDate ?? this.transactionDate,
    referenceNumber: referenceNumber.present
        ? referenceNumber.value
        : this.referenceNumber,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
  );
  InventoryTransaction copyWithCompanion(InventoryTransactionsCompanion data) {
    return InventoryTransaction(
      id: data.id.present ? data.id.value : this.id,
      productId: data.productId.present ? data.productId.value : this.productId,
      variantId: data.variantId.present ? data.variantId.value : this.variantId,
      transactionType: data.transactionType.present
          ? data.transactionType.value
          : this.transactionType,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      purchaseId: data.purchaseId.present
          ? data.purchaseId.value
          : this.purchaseId,
      transactionDate: data.transactionDate.present
          ? data.transactionDate.value
          : this.transactionDate,
      referenceNumber: data.referenceNumber.present
          ? data.referenceNumber.value
          : this.referenceNumber,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InventoryTransaction(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('variantId: $variantId, ')
          ..write('transactionType: $transactionType, ')
          ..write('quantity: $quantity, ')
          ..write('purchaseId: $purchaseId, ')
          ..write('transactionDate: $transactionDate, ')
          ..write('referenceNumber: $referenceNumber, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    productId,
    variantId,
    transactionType,
    quantity,
    purchaseId,
    transactionDate,
    referenceNumber,
    notes,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InventoryTransaction &&
          other.id == this.id &&
          other.productId == this.productId &&
          other.variantId == this.variantId &&
          other.transactionType == this.transactionType &&
          other.quantity == this.quantity &&
          other.purchaseId == this.purchaseId &&
          other.transactionDate == this.transactionDate &&
          other.referenceNumber == this.referenceNumber &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt);
}

class InventoryTransactionsCompanion
    extends UpdateCompanion<InventoryTransaction> {
  final Value<int> id;
  final Value<int> productId;
  final Value<int?> variantId;
  final Value<String> transactionType;
  final Value<int> quantity;
  final Value<int?> purchaseId;
  final Value<DateTime> transactionDate;
  final Value<String?> referenceNumber;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  const InventoryTransactionsCompanion({
    this.id = const Value.absent(),
    this.productId = const Value.absent(),
    this.variantId = const Value.absent(),
    this.transactionType = const Value.absent(),
    this.quantity = const Value.absent(),
    this.purchaseId = const Value.absent(),
    this.transactionDate = const Value.absent(),
    this.referenceNumber = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  InventoryTransactionsCompanion.insert({
    this.id = const Value.absent(),
    required int productId,
    this.variantId = const Value.absent(),
    required String transactionType,
    required int quantity,
    this.purchaseId = const Value.absent(),
    required DateTime transactionDate,
    this.referenceNumber = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : productId = Value(productId),
       transactionType = Value(transactionType),
       quantity = Value(quantity),
       transactionDate = Value(transactionDate);
  static Insertable<InventoryTransaction> custom({
    Expression<int>? id,
    Expression<int>? productId,
    Expression<int>? variantId,
    Expression<String>? transactionType,
    Expression<int>? quantity,
    Expression<int>? purchaseId,
    Expression<DateTime>? transactionDate,
    Expression<String>? referenceNumber,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (productId != null) 'product_id': productId,
      if (variantId != null) 'variant_id': variantId,
      if (transactionType != null) 'transaction_type': transactionType,
      if (quantity != null) 'quantity': quantity,
      if (purchaseId != null) 'purchase_id': purchaseId,
      if (transactionDate != null) 'transaction_date': transactionDate,
      if (referenceNumber != null) 'reference_number': referenceNumber,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  InventoryTransactionsCompanion copyWith({
    Value<int>? id,
    Value<int>? productId,
    Value<int?>? variantId,
    Value<String>? transactionType,
    Value<int>? quantity,
    Value<int?>? purchaseId,
    Value<DateTime>? transactionDate,
    Value<String?>? referenceNumber,
    Value<String?>? notes,
    Value<DateTime>? createdAt,
  }) {
    return InventoryTransactionsCompanion(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      variantId: variantId ?? this.variantId,
      transactionType: transactionType ?? this.transactionType,
      quantity: quantity ?? this.quantity,
      purchaseId: purchaseId ?? this.purchaseId,
      transactionDate: transactionDate ?? this.transactionDate,
      referenceNumber: referenceNumber ?? this.referenceNumber,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<int>(productId.value);
    }
    if (variantId.present) {
      map['variant_id'] = Variable<int>(variantId.value);
    }
    if (transactionType.present) {
      map['transaction_type'] = Variable<String>(transactionType.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (purchaseId.present) {
      map['purchase_id'] = Variable<int>(purchaseId.value);
    }
    if (transactionDate.present) {
      map['transaction_date'] = Variable<DateTime>(transactionDate.value);
    }
    if (referenceNumber.present) {
      map['reference_number'] = Variable<String>(referenceNumber.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InventoryTransactionsCompanion(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('variantId: $variantId, ')
          ..write('transactionType: $transactionType, ')
          ..write('quantity: $quantity, ')
          ..write('purchaseId: $purchaseId, ')
          ..write('transactionDate: $transactionDate, ')
          ..write('referenceNumber: $referenceNumber, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $CurrentStocksTable extends CurrentStocks
    with TableInfo<$CurrentStocksTable, CurrentStock> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CurrentStocksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<int> productId = GeneratedColumn<int>(
    'product_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES product (id)',
    ),
  );
  static const VerificationMeta _variantIdMeta = const VerificationMeta(
    'variantId',
  );
  @override
  late final GeneratedColumn<int> variantId = GeneratedColumn<int>(
    'variant_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES product_variant (id)',
    ),
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    productId,
    variantId,
    quantity,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'current_stock';
  @override
  VerificationContext validateIntegrity(
    Insertable<CurrentStock> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('variant_id')) {
      context.handle(
        _variantIdMeta,
        variantId.isAcceptableOrUnknown(data['variant_id']!, _variantIdMeta),
      );
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CurrentStock map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CurrentStock(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}product_id'],
      )!,
      variantId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}variant_id'],
      ),
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quantity'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $CurrentStocksTable createAlias(String alias) {
    return $CurrentStocksTable(attachedDatabase, alias);
  }
}

class CurrentStock extends DataClass implements Insertable<CurrentStock> {
  final int id;
  final int productId;
  final int? variantId;

  /// Current quantity on hand.
  final int quantity;
  final DateTime updatedAt;
  const CurrentStock({
    required this.id,
    required this.productId,
    this.variantId,
    required this.quantity,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['product_id'] = Variable<int>(productId);
    if (!nullToAbsent || variantId != null) {
      map['variant_id'] = Variable<int>(variantId);
    }
    map['quantity'] = Variable<int>(quantity);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  CurrentStocksCompanion toCompanion(bool nullToAbsent) {
    return CurrentStocksCompanion(
      id: Value(id),
      productId: Value(productId),
      variantId: variantId == null && nullToAbsent
          ? const Value.absent()
          : Value(variantId),
      quantity: Value(quantity),
      updatedAt: Value(updatedAt),
    );
  }

  factory CurrentStock.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CurrentStock(
      id: serializer.fromJson<int>(json['id']),
      productId: serializer.fromJson<int>(json['productId']),
      variantId: serializer.fromJson<int?>(json['variantId']),
      quantity: serializer.fromJson<int>(json['quantity']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'productId': serializer.toJson<int>(productId),
      'variantId': serializer.toJson<int?>(variantId),
      'quantity': serializer.toJson<int>(quantity),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  CurrentStock copyWith({
    int? id,
    int? productId,
    Value<int?> variantId = const Value.absent(),
    int? quantity,
    DateTime? updatedAt,
  }) => CurrentStock(
    id: id ?? this.id,
    productId: productId ?? this.productId,
    variantId: variantId.present ? variantId.value : this.variantId,
    quantity: quantity ?? this.quantity,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  CurrentStock copyWithCompanion(CurrentStocksCompanion data) {
    return CurrentStock(
      id: data.id.present ? data.id.value : this.id,
      productId: data.productId.present ? data.productId.value : this.productId,
      variantId: data.variantId.present ? data.variantId.value : this.variantId,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CurrentStock(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('variantId: $variantId, ')
          ..write('quantity: $quantity, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, productId, variantId, quantity, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CurrentStock &&
          other.id == this.id &&
          other.productId == this.productId &&
          other.variantId == this.variantId &&
          other.quantity == this.quantity &&
          other.updatedAt == this.updatedAt);
}

class CurrentStocksCompanion extends UpdateCompanion<CurrentStock> {
  final Value<int> id;
  final Value<int> productId;
  final Value<int?> variantId;
  final Value<int> quantity;
  final Value<DateTime> updatedAt;
  const CurrentStocksCompanion({
    this.id = const Value.absent(),
    this.productId = const Value.absent(),
    this.variantId = const Value.absent(),
    this.quantity = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  CurrentStocksCompanion.insert({
    this.id = const Value.absent(),
    required int productId,
    this.variantId = const Value.absent(),
    this.quantity = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : productId = Value(productId);
  static Insertable<CurrentStock> custom({
    Expression<int>? id,
    Expression<int>? productId,
    Expression<int>? variantId,
    Expression<int>? quantity,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (productId != null) 'product_id': productId,
      if (variantId != null) 'variant_id': variantId,
      if (quantity != null) 'quantity': quantity,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  CurrentStocksCompanion copyWith({
    Value<int>? id,
    Value<int>? productId,
    Value<int?>? variantId,
    Value<int>? quantity,
    Value<DateTime>? updatedAt,
  }) {
    return CurrentStocksCompanion(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      variantId: variantId ?? this.variantId,
      quantity: quantity ?? this.quantity,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<int>(productId.value);
    }
    if (variantId.present) {
      map['variant_id'] = Variable<int>(variantId.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CurrentStocksCompanion(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('variantId: $variantId, ')
          ..write('quantity: $quantity, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CompanySettingsTableTable companySettingsTable =
      $CompanySettingsTableTable(this);
  late final $CategoriesTable categories = $CategoriesTable(this);
  late final $SubCategoriesTable subCategories = $SubCategoriesTable(this);
  late final $BrandsTable brands = $BrandsTable(this);
  late final $UnitsTable units = $UnitsTable(this);
  late final $UomConversionsTable uomConversions = $UomConversionsTable(this);
  late final $TaxCategoriesTable taxCategories = $TaxCategoriesTable(this);
  late final $TaxTypesTable taxTypes = $TaxTypesTable(this);
  late final $TaxCategoryRatesTable taxCategoryRates = $TaxCategoryRatesTable(
    this,
  );
  late final $CustomersTable customers = $CustomersTable(this);
  late final $SuppliersTable suppliers = $SuppliersTable(this);
  late final $ProductsTable products = $ProductsTable(this);
  late final $ProductVariantsTable productVariants = $ProductVariantsTable(
    this,
  );
  late final $ProductUomsTable productUoms = $ProductUomsTable(this);
  late final $DocumentNumberSequencesTable documentNumberSequences =
      $DocumentNumberSequencesTable(this);
  late final $PurchasesTable purchases = $PurchasesTable(this);
  late final $PurchaseItemsTable purchaseItems = $PurchaseItemsTable(this);
  late final $InventoryTransactionsTable inventoryTransactions =
      $InventoryTransactionsTable(this);
  late final $CurrentStocksTable currentStocks = $CurrentStocksTable(this);
  late final Index idxSubCategoryCategory = Index(
    'idx_sub_category_category',
    'CREATE INDEX idx_sub_category_category ON sub_category (category_id)',
  );
  late final Index idxUomFromUnit = Index(
    'idx_uom_from_unit',
    'CREATE INDEX idx_uom_from_unit ON uom_conversion (from_unit_id)',
  );
  late final Index idxUomToUnit = Index(
    'idx_uom_to_unit',
    'CREATE INDEX idx_uom_to_unit ON uom_conversion (to_unit_id)',
  );
  late final Index idxRateTaxCategory = Index(
    'idx_rate_tax_category',
    'CREATE INDEX idx_rate_tax_category ON tax_category_rate (tax_category_id)',
  );
  late final Index idxRateTaxType = Index(
    'idx_rate_tax_type',
    'CREATE INDEX idx_rate_tax_type ON tax_category_rate (tax_type_id)',
  );
  late final Index idxCustomerName = Index(
    'idx_customer_name',
    'CREATE INDEX idx_customer_name ON customer (customer_name)',
  );
  late final Index idxCustomerActiveName = Index(
    'idx_customer_active_name',
    'CREATE INDEX idx_customer_active_name ON customer (is_active, customer_name)',
  );
  late final Index idxSupplierName = Index(
    'idx_supplier_name',
    'CREATE INDEX idx_supplier_name ON supplier (supplier_name)',
  );
  late final Index idxSupplierActiveName = Index(
    'idx_supplier_active_name',
    'CREATE INDEX idx_supplier_active_name ON supplier (is_active, supplier_name)',
  );
  late final Index idxProductName = Index(
    'idx_product_name',
    'CREATE INDEX idx_product_name ON product (product_name)',
  );
  late final Index idxProductCategory = Index(
    'idx_product_category',
    'CREATE INDEX idx_product_category ON product (category_id)',
  );
  late final Index idxProductBrand = Index(
    'idx_product_brand',
    'CREATE INDEX idx_product_brand ON product (brand_id)',
  );
  late final Index idxProductBarcode = Index(
    'idx_product_barcode',
    'CREATE INDEX idx_product_barcode ON product (barcode)',
  );
  late final Index idxProductActive = Index(
    'idx_product_active',
    'CREATE INDEX idx_product_active ON product (is_active)',
  );
  late final Index idxProductCreatedAt = Index(
    'idx_product_created_at',
    'CREATE INDEX idx_product_created_at ON product (created_at)',
  );
  late final Index idxVariantProduct = Index(
    'idx_variant_product',
    'CREATE INDEX idx_variant_product ON product_variant (product_id)',
  );
  late final Index idxVariantName = Index(
    'idx_variant_name',
    'CREATE INDEX idx_variant_name ON product_variant (variant_name)',
  );
  late final Index idxVariantBarcode = Index(
    'idx_variant_barcode',
    'CREATE INDEX idx_variant_barcode ON product_variant (barcode)',
  );
  late final Index idxPurchaseNumber = Index(
    'idx_purchase_number',
    'CREATE INDEX idx_purchase_number ON purchase (purchase_number)',
  );
  late final Index idxPurchaseSupplier = Index(
    'idx_purchase_supplier',
    'CREATE INDEX idx_purchase_supplier ON purchase (supplier_id)',
  );
  late final Index idxPurchaseDate = Index(
    'idx_purchase_date',
    'CREATE INDEX idx_purchase_date ON purchase (purchase_date)',
  );
  late final Index idxPurchaseSupplierDate = Index(
    'idx_purchase_supplier_date',
    'CREATE INDEX idx_purchase_supplier_date ON purchase (supplier_id, purchase_date)',
  );
  late final Index idxPurchaseItemPurchase = Index(
    'idx_purchase_item_purchase',
    'CREATE INDEX idx_purchase_item_purchase ON purchase_item (purchase_id)',
  );
  late final Index idxPurchaseItemProduct = Index(
    'idx_purchase_item_product',
    'CREATE INDEX idx_purchase_item_product ON purchase_item (product_id)',
  );
  late final Index idxPurchaseItemVariant = Index(
    'idx_purchase_item_variant',
    'CREATE INDEX idx_purchase_item_variant ON purchase_item (variant_id)',
  );
  late final Index idxInvTxnProductVariant = Index(
    'idx_inv_txn_product_variant',
    'CREATE INDEX idx_inv_txn_product_variant ON inventory_transaction (product_id, variant_id)',
  );
  late final Index idxInvTxnType = Index(
    'idx_inv_txn_type',
    'CREATE INDEX idx_inv_txn_type ON inventory_transaction (transaction_type)',
  );
  late final Index idxInvTxnDate = Index(
    'idx_inv_txn_date',
    'CREATE INDEX idx_inv_txn_date ON inventory_transaction (transaction_date)',
  );
  late final Index idxInvTxnPurchase = Index(
    'idx_inv_txn_purchase',
    'CREATE INDEX idx_inv_txn_purchase ON inventory_transaction (purchase_id)',
  );
  late final Index idxStockProductVariant = Index(
    'idx_stock_product_variant',
    'CREATE UNIQUE INDEX idx_stock_product_variant ON current_stock (product_id, variant_id)',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    companySettingsTable,
    categories,
    subCategories,
    brands,
    units,
    uomConversions,
    taxCategories,
    taxTypes,
    taxCategoryRates,
    customers,
    suppliers,
    products,
    productVariants,
    productUoms,
    documentNumberSequences,
    purchases,
    purchaseItems,
    inventoryTransactions,
    currentStocks,
    idxSubCategoryCategory,
    idxUomFromUnit,
    idxUomToUnit,
    idxRateTaxCategory,
    idxRateTaxType,
    idxCustomerName,
    idxCustomerActiveName,
    idxSupplierName,
    idxSupplierActiveName,
    idxProductName,
    idxProductCategory,
    idxProductBrand,
    idxProductBarcode,
    idxProductActive,
    idxProductCreatedAt,
    idxVariantProduct,
    idxVariantName,
    idxVariantBarcode,
    idxPurchaseNumber,
    idxPurchaseSupplier,
    idxPurchaseDate,
    idxPurchaseSupplierDate,
    idxPurchaseItemPurchase,
    idxPurchaseItemProduct,
    idxPurchaseItemVariant,
    idxInvTxnProductVariant,
    idxInvTxnType,
    idxInvTxnDate,
    idxInvTxnPurchase,
    idxStockProductVariant,
  ];
}

typedef $$CompanySettingsTableTableCreateCompanionBuilder =
    CompanySettingsTableCompanion Function({
      Value<int> id,
      required String companyName,
      Value<String?> legalName,
      Value<String> businessType,
      Value<bool> gstRegistered,
      Value<String?> gstNumber,
      Value<String?> panNumber,
      Value<String?> cin,
      Value<String?> mobile,
      Value<String?> email,
      Value<String?> website,
      Value<String?> addressLine1,
      Value<String?> addressLine2,
      Value<String?> city,
      Value<String?> state,
      Value<String?> stateCode,
      Value<String?> country,
      Value<String?> pincode,
      Value<String?> logoPath,
      Value<bool> pricesInclusiveOfTax,
      Value<String> invoicePrefix,
      Value<int> invoiceStartNumber,
      Value<String> purchasePrefix,
      Value<String> receiptPrefix,
      Value<int> financialYearStartMonth,
      Value<String> currencyCode,
      Value<String> currencySymbol,
      Value<int> decimalPlaces,
      Value<String> timezone,
      Value<String?> bankName,
      Value<String?> bankAccountName,
      Value<String?> bankAccountNumber,
      Value<String?> bankIfsc,
      Value<String?> bankBranch,
      Value<String?> upiId,
      Value<String?> invoiceFooter,
      Value<String?> invoiceTerms,
      Value<String?> invoiceThankYouMessage,
      Value<bool> showLogoOnInvoice,
      Value<bool> showBankDetailsOnInvoice,
      Value<bool> showGstDetailsOnInvoice,
      Value<bool> isActive,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$CompanySettingsTableTableUpdateCompanionBuilder =
    CompanySettingsTableCompanion Function({
      Value<int> id,
      Value<String> companyName,
      Value<String?> legalName,
      Value<String> businessType,
      Value<bool> gstRegistered,
      Value<String?> gstNumber,
      Value<String?> panNumber,
      Value<String?> cin,
      Value<String?> mobile,
      Value<String?> email,
      Value<String?> website,
      Value<String?> addressLine1,
      Value<String?> addressLine2,
      Value<String?> city,
      Value<String?> state,
      Value<String?> stateCode,
      Value<String?> country,
      Value<String?> pincode,
      Value<String?> logoPath,
      Value<bool> pricesInclusiveOfTax,
      Value<String> invoicePrefix,
      Value<int> invoiceStartNumber,
      Value<String> purchasePrefix,
      Value<String> receiptPrefix,
      Value<int> financialYearStartMonth,
      Value<String> currencyCode,
      Value<String> currencySymbol,
      Value<int> decimalPlaces,
      Value<String> timezone,
      Value<String?> bankName,
      Value<String?> bankAccountName,
      Value<String?> bankAccountNumber,
      Value<String?> bankIfsc,
      Value<String?> bankBranch,
      Value<String?> upiId,
      Value<String?> invoiceFooter,
      Value<String?> invoiceTerms,
      Value<String?> invoiceThankYouMessage,
      Value<bool> showLogoOnInvoice,
      Value<bool> showBankDetailsOnInvoice,
      Value<bool> showGstDetailsOnInvoice,
      Value<bool> isActive,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

class $$CompanySettingsTableTableFilterComposer
    extends Composer<_$AppDatabase, $CompanySettingsTableTable> {
  $$CompanySettingsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get companyName => $composableBuilder(
    column: $table.companyName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get legalName => $composableBuilder(
    column: $table.legalName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get businessType => $composableBuilder(
    column: $table.businessType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get gstRegistered => $composableBuilder(
    column: $table.gstRegistered,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get gstNumber => $composableBuilder(
    column: $table.gstNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get panNumber => $composableBuilder(
    column: $table.panNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cin => $composableBuilder(
    column: $table.cin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mobile => $composableBuilder(
    column: $table.mobile,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get website => $composableBuilder(
    column: $table.website,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get addressLine1 => $composableBuilder(
    column: $table.addressLine1,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get addressLine2 => $composableBuilder(
    column: $table.addressLine2,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get city => $composableBuilder(
    column: $table.city,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get stateCode => $composableBuilder(
    column: $table.stateCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get country => $composableBuilder(
    column: $table.country,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pincode => $composableBuilder(
    column: $table.pincode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get logoPath => $composableBuilder(
    column: $table.logoPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get pricesInclusiveOfTax => $composableBuilder(
    column: $table.pricesInclusiveOfTax,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get invoicePrefix => $composableBuilder(
    column: $table.invoicePrefix,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get invoiceStartNumber => $composableBuilder(
    column: $table.invoiceStartNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get purchasePrefix => $composableBuilder(
    column: $table.purchasePrefix,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get receiptPrefix => $composableBuilder(
    column: $table.receiptPrefix,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get financialYearStartMonth => $composableBuilder(
    column: $table.financialYearStartMonth,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currencySymbol => $composableBuilder(
    column: $table.currencySymbol,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get decimalPlaces => $composableBuilder(
    column: $table.decimalPlaces,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get timezone => $composableBuilder(
    column: $table.timezone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bankName => $composableBuilder(
    column: $table.bankName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bankAccountName => $composableBuilder(
    column: $table.bankAccountName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bankAccountNumber => $composableBuilder(
    column: $table.bankAccountNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bankIfsc => $composableBuilder(
    column: $table.bankIfsc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bankBranch => $composableBuilder(
    column: $table.bankBranch,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get upiId => $composableBuilder(
    column: $table.upiId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get invoiceFooter => $composableBuilder(
    column: $table.invoiceFooter,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get invoiceTerms => $composableBuilder(
    column: $table.invoiceTerms,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get invoiceThankYouMessage => $composableBuilder(
    column: $table.invoiceThankYouMessage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get showLogoOnInvoice => $composableBuilder(
    column: $table.showLogoOnInvoice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get showBankDetailsOnInvoice => $composableBuilder(
    column: $table.showBankDetailsOnInvoice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get showGstDetailsOnInvoice => $composableBuilder(
    column: $table.showGstDetailsOnInvoice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CompanySettingsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $CompanySettingsTableTable> {
  $$CompanySettingsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get companyName => $composableBuilder(
    column: $table.companyName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get legalName => $composableBuilder(
    column: $table.legalName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get businessType => $composableBuilder(
    column: $table.businessType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get gstRegistered => $composableBuilder(
    column: $table.gstRegistered,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gstNumber => $composableBuilder(
    column: $table.gstNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get panNumber => $composableBuilder(
    column: $table.panNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cin => $composableBuilder(
    column: $table.cin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mobile => $composableBuilder(
    column: $table.mobile,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get website => $composableBuilder(
    column: $table.website,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get addressLine1 => $composableBuilder(
    column: $table.addressLine1,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get addressLine2 => $composableBuilder(
    column: $table.addressLine2,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get city => $composableBuilder(
    column: $table.city,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get stateCode => $composableBuilder(
    column: $table.stateCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get country => $composableBuilder(
    column: $table.country,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pincode => $composableBuilder(
    column: $table.pincode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get logoPath => $composableBuilder(
    column: $table.logoPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get pricesInclusiveOfTax => $composableBuilder(
    column: $table.pricesInclusiveOfTax,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get invoicePrefix => $composableBuilder(
    column: $table.invoicePrefix,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get invoiceStartNumber => $composableBuilder(
    column: $table.invoiceStartNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get purchasePrefix => $composableBuilder(
    column: $table.purchasePrefix,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get receiptPrefix => $composableBuilder(
    column: $table.receiptPrefix,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get financialYearStartMonth => $composableBuilder(
    column: $table.financialYearStartMonth,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currencySymbol => $composableBuilder(
    column: $table.currencySymbol,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get decimalPlaces => $composableBuilder(
    column: $table.decimalPlaces,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get timezone => $composableBuilder(
    column: $table.timezone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bankName => $composableBuilder(
    column: $table.bankName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bankAccountName => $composableBuilder(
    column: $table.bankAccountName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bankAccountNumber => $composableBuilder(
    column: $table.bankAccountNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bankIfsc => $composableBuilder(
    column: $table.bankIfsc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bankBranch => $composableBuilder(
    column: $table.bankBranch,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get upiId => $composableBuilder(
    column: $table.upiId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get invoiceFooter => $composableBuilder(
    column: $table.invoiceFooter,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get invoiceTerms => $composableBuilder(
    column: $table.invoiceTerms,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get invoiceThankYouMessage => $composableBuilder(
    column: $table.invoiceThankYouMessage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get showLogoOnInvoice => $composableBuilder(
    column: $table.showLogoOnInvoice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get showBankDetailsOnInvoice => $composableBuilder(
    column: $table.showBankDetailsOnInvoice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get showGstDetailsOnInvoice => $composableBuilder(
    column: $table.showGstDetailsOnInvoice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CompanySettingsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $CompanySettingsTableTable> {
  $$CompanySettingsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get companyName => $composableBuilder(
    column: $table.companyName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get legalName =>
      $composableBuilder(column: $table.legalName, builder: (column) => column);

  GeneratedColumn<String> get businessType => $composableBuilder(
    column: $table.businessType,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get gstRegistered => $composableBuilder(
    column: $table.gstRegistered,
    builder: (column) => column,
  );

  GeneratedColumn<String> get gstNumber =>
      $composableBuilder(column: $table.gstNumber, builder: (column) => column);

  GeneratedColumn<String> get panNumber =>
      $composableBuilder(column: $table.panNumber, builder: (column) => column);

  GeneratedColumn<String> get cin =>
      $composableBuilder(column: $table.cin, builder: (column) => column);

  GeneratedColumn<String> get mobile =>
      $composableBuilder(column: $table.mobile, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get website =>
      $composableBuilder(column: $table.website, builder: (column) => column);

  GeneratedColumn<String> get addressLine1 => $composableBuilder(
    column: $table.addressLine1,
    builder: (column) => column,
  );

  GeneratedColumn<String> get addressLine2 => $composableBuilder(
    column: $table.addressLine2,
    builder: (column) => column,
  );

  GeneratedColumn<String> get city =>
      $composableBuilder(column: $table.city, builder: (column) => column);

  GeneratedColumn<String> get state =>
      $composableBuilder(column: $table.state, builder: (column) => column);

  GeneratedColumn<String> get stateCode =>
      $composableBuilder(column: $table.stateCode, builder: (column) => column);

  GeneratedColumn<String> get country =>
      $composableBuilder(column: $table.country, builder: (column) => column);

  GeneratedColumn<String> get pincode =>
      $composableBuilder(column: $table.pincode, builder: (column) => column);

  GeneratedColumn<String> get logoPath =>
      $composableBuilder(column: $table.logoPath, builder: (column) => column);

  GeneratedColumn<bool> get pricesInclusiveOfTax => $composableBuilder(
    column: $table.pricesInclusiveOfTax,
    builder: (column) => column,
  );

  GeneratedColumn<String> get invoicePrefix => $composableBuilder(
    column: $table.invoicePrefix,
    builder: (column) => column,
  );

  GeneratedColumn<int> get invoiceStartNumber => $composableBuilder(
    column: $table.invoiceStartNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get purchasePrefix => $composableBuilder(
    column: $table.purchasePrefix,
    builder: (column) => column,
  );

  GeneratedColumn<String> get receiptPrefix => $composableBuilder(
    column: $table.receiptPrefix,
    builder: (column) => column,
  );

  GeneratedColumn<int> get financialYearStartMonth => $composableBuilder(
    column: $table.financialYearStartMonth,
    builder: (column) => column,
  );

  GeneratedColumn<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get currencySymbol => $composableBuilder(
    column: $table.currencySymbol,
    builder: (column) => column,
  );

  GeneratedColumn<int> get decimalPlaces => $composableBuilder(
    column: $table.decimalPlaces,
    builder: (column) => column,
  );

  GeneratedColumn<String> get timezone =>
      $composableBuilder(column: $table.timezone, builder: (column) => column);

  GeneratedColumn<String> get bankName =>
      $composableBuilder(column: $table.bankName, builder: (column) => column);

  GeneratedColumn<String> get bankAccountName => $composableBuilder(
    column: $table.bankAccountName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get bankAccountNumber => $composableBuilder(
    column: $table.bankAccountNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get bankIfsc =>
      $composableBuilder(column: $table.bankIfsc, builder: (column) => column);

  GeneratedColumn<String> get bankBranch => $composableBuilder(
    column: $table.bankBranch,
    builder: (column) => column,
  );

  GeneratedColumn<String> get upiId =>
      $composableBuilder(column: $table.upiId, builder: (column) => column);

  GeneratedColumn<String> get invoiceFooter => $composableBuilder(
    column: $table.invoiceFooter,
    builder: (column) => column,
  );

  GeneratedColumn<String> get invoiceTerms => $composableBuilder(
    column: $table.invoiceTerms,
    builder: (column) => column,
  );

  GeneratedColumn<String> get invoiceThankYouMessage => $composableBuilder(
    column: $table.invoiceThankYouMessage,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get showLogoOnInvoice => $composableBuilder(
    column: $table.showLogoOnInvoice,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get showBankDetailsOnInvoice => $composableBuilder(
    column: $table.showBankDetailsOnInvoice,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get showGstDetailsOnInvoice => $composableBuilder(
    column: $table.showGstDetailsOnInvoice,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$CompanySettingsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CompanySettingsTableTable,
          CompanySettings,
          $$CompanySettingsTableTableFilterComposer,
          $$CompanySettingsTableTableOrderingComposer,
          $$CompanySettingsTableTableAnnotationComposer,
          $$CompanySettingsTableTableCreateCompanionBuilder,
          $$CompanySettingsTableTableUpdateCompanionBuilder,
          (
            CompanySettings,
            BaseReferences<
              _$AppDatabase,
              $CompanySettingsTableTable,
              CompanySettings
            >,
          ),
          CompanySettings,
          PrefetchHooks Function()
        > {
  $$CompanySettingsTableTableTableManager(
    _$AppDatabase db,
    $CompanySettingsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CompanySettingsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CompanySettingsTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$CompanySettingsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> companyName = const Value.absent(),
                Value<String?> legalName = const Value.absent(),
                Value<String> businessType = const Value.absent(),
                Value<bool> gstRegistered = const Value.absent(),
                Value<String?> gstNumber = const Value.absent(),
                Value<String?> panNumber = const Value.absent(),
                Value<String?> cin = const Value.absent(),
                Value<String?> mobile = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String?> website = const Value.absent(),
                Value<String?> addressLine1 = const Value.absent(),
                Value<String?> addressLine2 = const Value.absent(),
                Value<String?> city = const Value.absent(),
                Value<String?> state = const Value.absent(),
                Value<String?> stateCode = const Value.absent(),
                Value<String?> country = const Value.absent(),
                Value<String?> pincode = const Value.absent(),
                Value<String?> logoPath = const Value.absent(),
                Value<bool> pricesInclusiveOfTax = const Value.absent(),
                Value<String> invoicePrefix = const Value.absent(),
                Value<int> invoiceStartNumber = const Value.absent(),
                Value<String> purchasePrefix = const Value.absent(),
                Value<String> receiptPrefix = const Value.absent(),
                Value<int> financialYearStartMonth = const Value.absent(),
                Value<String> currencyCode = const Value.absent(),
                Value<String> currencySymbol = const Value.absent(),
                Value<int> decimalPlaces = const Value.absent(),
                Value<String> timezone = const Value.absent(),
                Value<String?> bankName = const Value.absent(),
                Value<String?> bankAccountName = const Value.absent(),
                Value<String?> bankAccountNumber = const Value.absent(),
                Value<String?> bankIfsc = const Value.absent(),
                Value<String?> bankBranch = const Value.absent(),
                Value<String?> upiId = const Value.absent(),
                Value<String?> invoiceFooter = const Value.absent(),
                Value<String?> invoiceTerms = const Value.absent(),
                Value<String?> invoiceThankYouMessage = const Value.absent(),
                Value<bool> showLogoOnInvoice = const Value.absent(),
                Value<bool> showBankDetailsOnInvoice = const Value.absent(),
                Value<bool> showGstDetailsOnInvoice = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => CompanySettingsTableCompanion(
                id: id,
                companyName: companyName,
                legalName: legalName,
                businessType: businessType,
                gstRegistered: gstRegistered,
                gstNumber: gstNumber,
                panNumber: panNumber,
                cin: cin,
                mobile: mobile,
                email: email,
                website: website,
                addressLine1: addressLine1,
                addressLine2: addressLine2,
                city: city,
                state: state,
                stateCode: stateCode,
                country: country,
                pincode: pincode,
                logoPath: logoPath,
                pricesInclusiveOfTax: pricesInclusiveOfTax,
                invoicePrefix: invoicePrefix,
                invoiceStartNumber: invoiceStartNumber,
                purchasePrefix: purchasePrefix,
                receiptPrefix: receiptPrefix,
                financialYearStartMonth: financialYearStartMonth,
                currencyCode: currencyCode,
                currencySymbol: currencySymbol,
                decimalPlaces: decimalPlaces,
                timezone: timezone,
                bankName: bankName,
                bankAccountName: bankAccountName,
                bankAccountNumber: bankAccountNumber,
                bankIfsc: bankIfsc,
                bankBranch: bankBranch,
                upiId: upiId,
                invoiceFooter: invoiceFooter,
                invoiceTerms: invoiceTerms,
                invoiceThankYouMessage: invoiceThankYouMessage,
                showLogoOnInvoice: showLogoOnInvoice,
                showBankDetailsOnInvoice: showBankDetailsOnInvoice,
                showGstDetailsOnInvoice: showGstDetailsOnInvoice,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String companyName,
                Value<String?> legalName = const Value.absent(),
                Value<String> businessType = const Value.absent(),
                Value<bool> gstRegistered = const Value.absent(),
                Value<String?> gstNumber = const Value.absent(),
                Value<String?> panNumber = const Value.absent(),
                Value<String?> cin = const Value.absent(),
                Value<String?> mobile = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String?> website = const Value.absent(),
                Value<String?> addressLine1 = const Value.absent(),
                Value<String?> addressLine2 = const Value.absent(),
                Value<String?> city = const Value.absent(),
                Value<String?> state = const Value.absent(),
                Value<String?> stateCode = const Value.absent(),
                Value<String?> country = const Value.absent(),
                Value<String?> pincode = const Value.absent(),
                Value<String?> logoPath = const Value.absent(),
                Value<bool> pricesInclusiveOfTax = const Value.absent(),
                Value<String> invoicePrefix = const Value.absent(),
                Value<int> invoiceStartNumber = const Value.absent(),
                Value<String> purchasePrefix = const Value.absent(),
                Value<String> receiptPrefix = const Value.absent(),
                Value<int> financialYearStartMonth = const Value.absent(),
                Value<String> currencyCode = const Value.absent(),
                Value<String> currencySymbol = const Value.absent(),
                Value<int> decimalPlaces = const Value.absent(),
                Value<String> timezone = const Value.absent(),
                Value<String?> bankName = const Value.absent(),
                Value<String?> bankAccountName = const Value.absent(),
                Value<String?> bankAccountNumber = const Value.absent(),
                Value<String?> bankIfsc = const Value.absent(),
                Value<String?> bankBranch = const Value.absent(),
                Value<String?> upiId = const Value.absent(),
                Value<String?> invoiceFooter = const Value.absent(),
                Value<String?> invoiceTerms = const Value.absent(),
                Value<String?> invoiceThankYouMessage = const Value.absent(),
                Value<bool> showLogoOnInvoice = const Value.absent(),
                Value<bool> showBankDetailsOnInvoice = const Value.absent(),
                Value<bool> showGstDetailsOnInvoice = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => CompanySettingsTableCompanion.insert(
                id: id,
                companyName: companyName,
                legalName: legalName,
                businessType: businessType,
                gstRegistered: gstRegistered,
                gstNumber: gstNumber,
                panNumber: panNumber,
                cin: cin,
                mobile: mobile,
                email: email,
                website: website,
                addressLine1: addressLine1,
                addressLine2: addressLine2,
                city: city,
                state: state,
                stateCode: stateCode,
                country: country,
                pincode: pincode,
                logoPath: logoPath,
                pricesInclusiveOfTax: pricesInclusiveOfTax,
                invoicePrefix: invoicePrefix,
                invoiceStartNumber: invoiceStartNumber,
                purchasePrefix: purchasePrefix,
                receiptPrefix: receiptPrefix,
                financialYearStartMonth: financialYearStartMonth,
                currencyCode: currencyCode,
                currencySymbol: currencySymbol,
                decimalPlaces: decimalPlaces,
                timezone: timezone,
                bankName: bankName,
                bankAccountName: bankAccountName,
                bankAccountNumber: bankAccountNumber,
                bankIfsc: bankIfsc,
                bankBranch: bankBranch,
                upiId: upiId,
                invoiceFooter: invoiceFooter,
                invoiceTerms: invoiceTerms,
                invoiceThankYouMessage: invoiceThankYouMessage,
                showLogoOnInvoice: showLogoOnInvoice,
                showBankDetailsOnInvoice: showBankDetailsOnInvoice,
                showGstDetailsOnInvoice: showGstDetailsOnInvoice,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CompanySettingsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CompanySettingsTableTable,
      CompanySettings,
      $$CompanySettingsTableTableFilterComposer,
      $$CompanySettingsTableTableOrderingComposer,
      $$CompanySettingsTableTableAnnotationComposer,
      $$CompanySettingsTableTableCreateCompanionBuilder,
      $$CompanySettingsTableTableUpdateCompanionBuilder,
      (
        CompanySettings,
        BaseReferences<
          _$AppDatabase,
          $CompanySettingsTableTable,
          CompanySettings
        >,
      ),
      CompanySettings,
      PrefetchHooks Function()
    >;
typedef $$CategoriesTableCreateCompanionBuilder =
    CategoriesCompanion Function({
      Value<int> id,
      required String categoryCode,
      required String categoryName,
      Value<String?> description,
      Value<bool> isActive,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$CategoriesTableUpdateCompanionBuilder =
    CategoriesCompanion Function({
      Value<int> id,
      Value<String> categoryCode,
      Value<String> categoryName,
      Value<String?> description,
      Value<bool> isActive,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$CategoriesTableReferences
    extends BaseReferences<_$AppDatabase, $CategoriesTable, Category> {
  $$CategoriesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$SubCategoriesTable, List<SubCategory>>
  _subCategoriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.subCategories,
    aliasName: 'category__id__sub_category__category_id',
  );

  $$SubCategoriesTableProcessedTableManager get subCategoriesRefs {
    final manager = $$SubCategoriesTableTableManager(
      $_db,
      $_db.subCategories,
    ).filter((f) => f.categoryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_subCategoriesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ProductsTable, List<Product>> _productsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.products,
    aliasName: 'category__id__product__category_id',
  );

  $$ProductsTableProcessedTableManager get productsRefs {
    final manager = $$ProductsTableTableManager(
      $_db,
      $_db.products,
    ).filter((f) => f.categoryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_productsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get categoryCode => $composableBuilder(
    column: $table.categoryCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get categoryName => $composableBuilder(
    column: $table.categoryName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> subCategoriesRefs(
    Expression<bool> Function($$SubCategoriesTableFilterComposer f) f,
  ) {
    final $$SubCategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.subCategories,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubCategoriesTableFilterComposer(
            $db: $db,
            $table: $db.subCategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> productsRefs(
    Expression<bool> Function($$ProductsTableFilterComposer f) f,
  ) {
    final $$ProductsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableFilterComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categoryCode => $composableBuilder(
    column: $table.categoryCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categoryName => $composableBuilder(
    column: $table.categoryName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get categoryCode => $composableBuilder(
    column: $table.categoryCode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get categoryName => $composableBuilder(
    column: $table.categoryName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> subCategoriesRefs<T extends Object>(
    Expression<T> Function($$SubCategoriesTableAnnotationComposer a) f,
  ) {
    final $$SubCategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.subCategories,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubCategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.subCategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> productsRefs<T extends Object>(
    Expression<T> Function($$ProductsTableAnnotationComposer a) f,
  ) {
    final $$ProductsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableAnnotationComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CategoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CategoriesTable,
          Category,
          $$CategoriesTableFilterComposer,
          $$CategoriesTableOrderingComposer,
          $$CategoriesTableAnnotationComposer,
          $$CategoriesTableCreateCompanionBuilder,
          $$CategoriesTableUpdateCompanionBuilder,
          (Category, $$CategoriesTableReferences),
          Category,
          PrefetchHooks Function({bool subCategoriesRefs, bool productsRefs})
        > {
  $$CategoriesTableTableManager(_$AppDatabase db, $CategoriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> categoryCode = const Value.absent(),
                Value<String> categoryName = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => CategoriesCompanion(
                id: id,
                categoryCode: categoryCode,
                categoryName: categoryName,
                description: description,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String categoryCode,
                required String categoryName,
                Value<String?> description = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => CategoriesCompanion.insert(
                id: id,
                categoryCode: categoryCode,
                categoryName: categoryName,
                description: description,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CategoriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({subCategoriesRefs = false, productsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (subCategoriesRefs) db.subCategories,
                    if (productsRefs) db.products,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (subCategoriesRefs)
                        await $_getPrefetchedData<
                          Category,
                          $CategoriesTable,
                          SubCategory
                        >(
                          currentTable: table,
                          referencedTable: $$CategoriesTableReferences
                              ._subCategoriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CategoriesTableReferences(
                                db,
                                table,
                                p0,
                              ).subCategoriesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.categoryId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (productsRefs)
                        await $_getPrefetchedData<
                          Category,
                          $CategoriesTable,
                          Product
                        >(
                          currentTable: table,
                          referencedTable: $$CategoriesTableReferences
                              ._productsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CategoriesTableReferences(
                                db,
                                table,
                                p0,
                              ).productsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.categoryId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$CategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CategoriesTable,
      Category,
      $$CategoriesTableFilterComposer,
      $$CategoriesTableOrderingComposer,
      $$CategoriesTableAnnotationComposer,
      $$CategoriesTableCreateCompanionBuilder,
      $$CategoriesTableUpdateCompanionBuilder,
      (Category, $$CategoriesTableReferences),
      Category,
      PrefetchHooks Function({bool subCategoriesRefs, bool productsRefs})
    >;
typedef $$SubCategoriesTableCreateCompanionBuilder =
    SubCategoriesCompanion Function({
      Value<int> id,
      required int categoryId,
      required String subCategoryCode,
      required String subCategoryName,
      Value<String?> description,
      Value<bool> isActive,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$SubCategoriesTableUpdateCompanionBuilder =
    SubCategoriesCompanion Function({
      Value<int> id,
      Value<int> categoryId,
      Value<String> subCategoryCode,
      Value<String> subCategoryName,
      Value<String?> description,
      Value<bool> isActive,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$SubCategoriesTableReferences
    extends BaseReferences<_$AppDatabase, $SubCategoriesTable, SubCategory> {
  $$SubCategoriesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CategoriesTable _categoryIdTable(_$AppDatabase db) =>
      db.categories.createAlias('sub_category__category_id__category__id');

  $$CategoriesTableProcessedTableManager get categoryId {
    final $_column = $_itemColumn<int>('category_id')!;

    final manager = $$CategoriesTableTableManager(
      $_db,
      $_db.categories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$ProductsTable, List<Product>> _productsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.products,
    aliasName: 'sub_category__id__product__sub_category_id',
  );

  $$ProductsTableProcessedTableManager get productsRefs {
    final manager = $$ProductsTableTableManager(
      $_db,
      $_db.products,
    ).filter((f) => f.subCategoryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_productsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SubCategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $SubCategoriesTable> {
  $$SubCategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get subCategoryCode => $composableBuilder(
    column: $table.subCategoryCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get subCategoryName => $composableBuilder(
    column: $table.subCategoryName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$CategoriesTableFilterComposer get categoryId {
    final $$CategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableFilterComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> productsRefs(
    Expression<bool> Function($$ProductsTableFilterComposer f) f,
  ) {
    final $$ProductsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.subCategoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableFilterComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SubCategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $SubCategoriesTable> {
  $$SubCategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get subCategoryCode => $composableBuilder(
    column: $table.subCategoryCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get subCategoryName => $composableBuilder(
    column: $table.subCategoryName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$CategoriesTableOrderingComposer get categoryId {
    final $$CategoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableOrderingComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SubCategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SubCategoriesTable> {
  $$SubCategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get subCategoryCode => $composableBuilder(
    column: $table.subCategoryCode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get subCategoryName => $composableBuilder(
    column: $table.subCategoryName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$CategoriesTableAnnotationComposer get categoryId {
    final $$CategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> productsRefs<T extends Object>(
    Expression<T> Function($$ProductsTableAnnotationComposer a) f,
  ) {
    final $$ProductsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.subCategoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableAnnotationComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SubCategoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SubCategoriesTable,
          SubCategory,
          $$SubCategoriesTableFilterComposer,
          $$SubCategoriesTableOrderingComposer,
          $$SubCategoriesTableAnnotationComposer,
          $$SubCategoriesTableCreateCompanionBuilder,
          $$SubCategoriesTableUpdateCompanionBuilder,
          (SubCategory, $$SubCategoriesTableReferences),
          SubCategory,
          PrefetchHooks Function({bool categoryId, bool productsRefs})
        > {
  $$SubCategoriesTableTableManager(_$AppDatabase db, $SubCategoriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SubCategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SubCategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SubCategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> categoryId = const Value.absent(),
                Value<String> subCategoryCode = const Value.absent(),
                Value<String> subCategoryName = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => SubCategoriesCompanion(
                id: id,
                categoryId: categoryId,
                subCategoryCode: subCategoryCode,
                subCategoryName: subCategoryName,
                description: description,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int categoryId,
                required String subCategoryCode,
                required String subCategoryName,
                Value<String?> description = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => SubCategoriesCompanion.insert(
                id: id,
                categoryId: categoryId,
                subCategoryCode: subCategoryCode,
                subCategoryName: subCategoryName,
                description: description,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SubCategoriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({categoryId = false, productsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (productsRefs) db.products],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (categoryId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.categoryId,
                                referencedTable: $$SubCategoriesTableReferences
                                    ._categoryIdTable(db),
                                referencedColumn: $$SubCategoriesTableReferences
                                    ._categoryIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (productsRefs)
                    await $_getPrefetchedData<
                      SubCategory,
                      $SubCategoriesTable,
                      Product
                    >(
                      currentTable: table,
                      referencedTable: $$SubCategoriesTableReferences
                          ._productsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$SubCategoriesTableReferences(
                            db,
                            table,
                            p0,
                          ).productsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.subCategoryId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$SubCategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SubCategoriesTable,
      SubCategory,
      $$SubCategoriesTableFilterComposer,
      $$SubCategoriesTableOrderingComposer,
      $$SubCategoriesTableAnnotationComposer,
      $$SubCategoriesTableCreateCompanionBuilder,
      $$SubCategoriesTableUpdateCompanionBuilder,
      (SubCategory, $$SubCategoriesTableReferences),
      SubCategory,
      PrefetchHooks Function({bool categoryId, bool productsRefs})
    >;
typedef $$BrandsTableCreateCompanionBuilder =
    BrandsCompanion Function({
      Value<int> id,
      required String brandCode,
      required String brandName,
      Value<String?> description,
      Value<bool> isActive,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$BrandsTableUpdateCompanionBuilder =
    BrandsCompanion Function({
      Value<int> id,
      Value<String> brandCode,
      Value<String> brandName,
      Value<String?> description,
      Value<bool> isActive,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$BrandsTableReferences
    extends BaseReferences<_$AppDatabase, $BrandsTable, Brand> {
  $$BrandsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ProductsTable, List<Product>> _productsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.products,
    aliasName: 'brand__id__product__brand_id',
  );

  $$ProductsTableProcessedTableManager get productsRefs {
    final manager = $$ProductsTableTableManager(
      $_db,
      $_db.products,
    ).filter((f) => f.brandId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_productsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$BrandsTableFilterComposer
    extends Composer<_$AppDatabase, $BrandsTable> {
  $$BrandsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get brandCode => $composableBuilder(
    column: $table.brandCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get brandName => $composableBuilder(
    column: $table.brandName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> productsRefs(
    Expression<bool> Function($$ProductsTableFilterComposer f) f,
  ) {
    final $$ProductsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.brandId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableFilterComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$BrandsTableOrderingComposer
    extends Composer<_$AppDatabase, $BrandsTable> {
  $$BrandsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get brandCode => $composableBuilder(
    column: $table.brandCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get brandName => $composableBuilder(
    column: $table.brandName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BrandsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BrandsTable> {
  $$BrandsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get brandCode =>
      $composableBuilder(column: $table.brandCode, builder: (column) => column);

  GeneratedColumn<String> get brandName =>
      $composableBuilder(column: $table.brandName, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> productsRefs<T extends Object>(
    Expression<T> Function($$ProductsTableAnnotationComposer a) f,
  ) {
    final $$ProductsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.brandId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableAnnotationComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$BrandsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BrandsTable,
          Brand,
          $$BrandsTableFilterComposer,
          $$BrandsTableOrderingComposer,
          $$BrandsTableAnnotationComposer,
          $$BrandsTableCreateCompanionBuilder,
          $$BrandsTableUpdateCompanionBuilder,
          (Brand, $$BrandsTableReferences),
          Brand,
          PrefetchHooks Function({bool productsRefs})
        > {
  $$BrandsTableTableManager(_$AppDatabase db, $BrandsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BrandsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BrandsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BrandsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> brandCode = const Value.absent(),
                Value<String> brandName = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => BrandsCompanion(
                id: id,
                brandCode: brandCode,
                brandName: brandName,
                description: description,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String brandCode,
                required String brandName,
                Value<String?> description = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => BrandsCompanion.insert(
                id: id,
                brandCode: brandCode,
                brandName: brandName,
                description: description,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$BrandsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({productsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (productsRefs) db.products],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (productsRefs)
                    await $_getPrefetchedData<Brand, $BrandsTable, Product>(
                      currentTable: table,
                      referencedTable: $$BrandsTableReferences
                          ._productsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$BrandsTableReferences(db, table, p0).productsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.brandId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$BrandsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BrandsTable,
      Brand,
      $$BrandsTableFilterComposer,
      $$BrandsTableOrderingComposer,
      $$BrandsTableAnnotationComposer,
      $$BrandsTableCreateCompanionBuilder,
      $$BrandsTableUpdateCompanionBuilder,
      (Brand, $$BrandsTableReferences),
      Brand,
      PrefetchHooks Function({bool productsRefs})
    >;
typedef $$UnitsTableCreateCompanionBuilder =
    UnitsCompanion Function({
      Value<int> id,
      required String unitName,
      required String unitSymbol,
      Value<String> unitFamily,
      Value<String?> description,
      Value<bool> isActive,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$UnitsTableUpdateCompanionBuilder =
    UnitsCompanion Function({
      Value<int> id,
      Value<String> unitName,
      Value<String> unitSymbol,
      Value<String> unitFamily,
      Value<String?> description,
      Value<bool> isActive,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$UnitsTableReferences
    extends BaseReferences<_$AppDatabase, $UnitsTable, Unit> {
  $$UnitsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$UomConversionsTable, List<UomConversion>>
  _fromUnitTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.uomConversions,
    aliasName: 'unit__id__uom_conversion__from_unit_id',
  );

  $$UomConversionsTableProcessedTableManager get fromUnit {
    final manager = $$UomConversionsTableTableManager(
      $_db,
      $_db.uomConversions,
    ).filter((f) => f.fromUnitId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_fromUnitTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$UomConversionsTable, List<UomConversion>>
  _toUnitTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.uomConversions,
    aliasName: 'unit__id__uom_conversion__to_unit_id',
  );

  $$UomConversionsTableProcessedTableManager get toUnit {
    final manager = $$UomConversionsTableTableManager(
      $_db,
      $_db.uomConversions,
    ).filter((f) => f.toUnitId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_toUnitTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ProductsTable, List<Product>> _productsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.products,
    aliasName: 'unit__id__product__unit_id',
  );

  $$ProductsTableProcessedTableManager get productsRefs {
    final manager = $$ProductsTableTableManager(
      $_db,
      $_db.products,
    ).filter((f) => f.unitId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_productsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ProductUomsTable, List<ProductUom>>
  _productUomsFromTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.productUoms,
    aliasName: 'unit__id__product_uom__from_unit_id',
  );

  $$ProductUomsTableProcessedTableManager get productUomsFrom {
    final manager = $$ProductUomsTableTableManager(
      $_db,
      $_db.productUoms,
    ).filter((f) => f.fromUnitId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_productUomsFromTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ProductUomsTable, List<ProductUom>>
  _productUomsToTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.productUoms,
    aliasName: 'unit__id__product_uom__to_unit_id',
  );

  $$ProductUomsTableProcessedTableManager get productUomsTo {
    final manager = $$ProductUomsTableTableManager(
      $_db,
      $_db.productUoms,
    ).filter((f) => f.toUnitId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_productUomsToTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PurchaseItemsTable, List<PurchaseItem>>
  _purchaseItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.purchaseItems,
    aliasName: 'unit__id__purchase_item__unit_id',
  );

  $$PurchaseItemsTableProcessedTableManager get purchaseItemsRefs {
    final manager = $$PurchaseItemsTableTableManager(
      $_db,
      $_db.purchaseItems,
    ).filter((f) => f.unitId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_purchaseItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$UnitsTableFilterComposer extends Composer<_$AppDatabase, $UnitsTable> {
  $$UnitsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unitName => $composableBuilder(
    column: $table.unitName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unitSymbol => $composableBuilder(
    column: $table.unitSymbol,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unitFamily => $composableBuilder(
    column: $table.unitFamily,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> fromUnit(
    Expression<bool> Function($$UomConversionsTableFilterComposer f) f,
  ) {
    final $$UomConversionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.uomConversions,
      getReferencedColumn: (t) => t.fromUnitId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UomConversionsTableFilterComposer(
            $db: $db,
            $table: $db.uomConversions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> toUnit(
    Expression<bool> Function($$UomConversionsTableFilterComposer f) f,
  ) {
    final $$UomConversionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.uomConversions,
      getReferencedColumn: (t) => t.toUnitId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UomConversionsTableFilterComposer(
            $db: $db,
            $table: $db.uomConversions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> productsRefs(
    Expression<bool> Function($$ProductsTableFilterComposer f) f,
  ) {
    final $$ProductsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.unitId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableFilterComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> productUomsFrom(
    Expression<bool> Function($$ProductUomsTableFilterComposer f) f,
  ) {
    final $$ProductUomsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.productUoms,
      getReferencedColumn: (t) => t.fromUnitId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductUomsTableFilterComposer(
            $db: $db,
            $table: $db.productUoms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> productUomsTo(
    Expression<bool> Function($$ProductUomsTableFilterComposer f) f,
  ) {
    final $$ProductUomsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.productUoms,
      getReferencedColumn: (t) => t.toUnitId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductUomsTableFilterComposer(
            $db: $db,
            $table: $db.productUoms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> purchaseItemsRefs(
    Expression<bool> Function($$PurchaseItemsTableFilterComposer f) f,
  ) {
    final $$PurchaseItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.purchaseItems,
      getReferencedColumn: (t) => t.unitId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PurchaseItemsTableFilterComposer(
            $db: $db,
            $table: $db.purchaseItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$UnitsTableOrderingComposer
    extends Composer<_$AppDatabase, $UnitsTable> {
  $$UnitsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unitName => $composableBuilder(
    column: $table.unitName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unitSymbol => $composableBuilder(
    column: $table.unitSymbol,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unitFamily => $composableBuilder(
    column: $table.unitFamily,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UnitsTableAnnotationComposer
    extends Composer<_$AppDatabase, $UnitsTable> {
  $$UnitsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get unitName =>
      $composableBuilder(column: $table.unitName, builder: (column) => column);

  GeneratedColumn<String> get unitSymbol => $composableBuilder(
    column: $table.unitSymbol,
    builder: (column) => column,
  );

  GeneratedColumn<String> get unitFamily => $composableBuilder(
    column: $table.unitFamily,
    builder: (column) => column,
  );

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> fromUnit<T extends Object>(
    Expression<T> Function($$UomConversionsTableAnnotationComposer a) f,
  ) {
    final $$UomConversionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.uomConversions,
      getReferencedColumn: (t) => t.fromUnitId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UomConversionsTableAnnotationComposer(
            $db: $db,
            $table: $db.uomConversions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> toUnit<T extends Object>(
    Expression<T> Function($$UomConversionsTableAnnotationComposer a) f,
  ) {
    final $$UomConversionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.uomConversions,
      getReferencedColumn: (t) => t.toUnitId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UomConversionsTableAnnotationComposer(
            $db: $db,
            $table: $db.uomConversions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> productsRefs<T extends Object>(
    Expression<T> Function($$ProductsTableAnnotationComposer a) f,
  ) {
    final $$ProductsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.unitId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableAnnotationComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> productUomsFrom<T extends Object>(
    Expression<T> Function($$ProductUomsTableAnnotationComposer a) f,
  ) {
    final $$ProductUomsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.productUoms,
      getReferencedColumn: (t) => t.fromUnitId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductUomsTableAnnotationComposer(
            $db: $db,
            $table: $db.productUoms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> productUomsTo<T extends Object>(
    Expression<T> Function($$ProductUomsTableAnnotationComposer a) f,
  ) {
    final $$ProductUomsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.productUoms,
      getReferencedColumn: (t) => t.toUnitId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductUomsTableAnnotationComposer(
            $db: $db,
            $table: $db.productUoms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> purchaseItemsRefs<T extends Object>(
    Expression<T> Function($$PurchaseItemsTableAnnotationComposer a) f,
  ) {
    final $$PurchaseItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.purchaseItems,
      getReferencedColumn: (t) => t.unitId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PurchaseItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.purchaseItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$UnitsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UnitsTable,
          Unit,
          $$UnitsTableFilterComposer,
          $$UnitsTableOrderingComposer,
          $$UnitsTableAnnotationComposer,
          $$UnitsTableCreateCompanionBuilder,
          $$UnitsTableUpdateCompanionBuilder,
          (Unit, $$UnitsTableReferences),
          Unit,
          PrefetchHooks Function({
            bool fromUnit,
            bool toUnit,
            bool productsRefs,
            bool productUomsFrom,
            bool productUomsTo,
            bool purchaseItemsRefs,
          })
        > {
  $$UnitsTableTableManager(_$AppDatabase db, $UnitsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UnitsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UnitsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UnitsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> unitName = const Value.absent(),
                Value<String> unitSymbol = const Value.absent(),
                Value<String> unitFamily = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => UnitsCompanion(
                id: id,
                unitName: unitName,
                unitSymbol: unitSymbol,
                unitFamily: unitFamily,
                description: description,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String unitName,
                required String unitSymbol,
                Value<String> unitFamily = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => UnitsCompanion.insert(
                id: id,
                unitName: unitName,
                unitSymbol: unitSymbol,
                unitFamily: unitFamily,
                description: description,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$UnitsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                fromUnit = false,
                toUnit = false,
                productsRefs = false,
                productUomsFrom = false,
                productUomsTo = false,
                purchaseItemsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (fromUnit) db.uomConversions,
                    if (toUnit) db.uomConversions,
                    if (productsRefs) db.products,
                    if (productUomsFrom) db.productUoms,
                    if (productUomsTo) db.productUoms,
                    if (purchaseItemsRefs) db.purchaseItems,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (fromUnit)
                        await $_getPrefetchedData<
                          Unit,
                          $UnitsTable,
                          UomConversion
                        >(
                          currentTable: table,
                          referencedTable: $$UnitsTableReferences
                              ._fromUnitTable(db),
                          managerFromTypedResult: (p0) =>
                              $$UnitsTableReferences(db, table, p0).fromUnit,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.fromUnitId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (toUnit)
                        await $_getPrefetchedData<
                          Unit,
                          $UnitsTable,
                          UomConversion
                        >(
                          currentTable: table,
                          referencedTable: $$UnitsTableReferences._toUnitTable(
                            db,
                          ),
                          managerFromTypedResult: (p0) =>
                              $$UnitsTableReferences(db, table, p0).toUnit,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.toUnitId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (productsRefs)
                        await $_getPrefetchedData<Unit, $UnitsTable, Product>(
                          currentTable: table,
                          referencedTable: $$UnitsTableReferences
                              ._productsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$UnitsTableReferences(
                                db,
                                table,
                                p0,
                              ).productsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.unitId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (productUomsFrom)
                        await $_getPrefetchedData<
                          Unit,
                          $UnitsTable,
                          ProductUom
                        >(
                          currentTable: table,
                          referencedTable: $$UnitsTableReferences
                              ._productUomsFromTable(db),
                          managerFromTypedResult: (p0) =>
                              $$UnitsTableReferences(
                                db,
                                table,
                                p0,
                              ).productUomsFrom,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.fromUnitId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (productUomsTo)
                        await $_getPrefetchedData<
                          Unit,
                          $UnitsTable,
                          ProductUom
                        >(
                          currentTable: table,
                          referencedTable: $$UnitsTableReferences
                              ._productUomsToTable(db),
                          managerFromTypedResult: (p0) =>
                              $$UnitsTableReferences(
                                db,
                                table,
                                p0,
                              ).productUomsTo,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.toUnitId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (purchaseItemsRefs)
                        await $_getPrefetchedData<
                          Unit,
                          $UnitsTable,
                          PurchaseItem
                        >(
                          currentTable: table,
                          referencedTable: $$UnitsTableReferences
                              ._purchaseItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$UnitsTableReferences(
                                db,
                                table,
                                p0,
                              ).purchaseItemsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.unitId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$UnitsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UnitsTable,
      Unit,
      $$UnitsTableFilterComposer,
      $$UnitsTableOrderingComposer,
      $$UnitsTableAnnotationComposer,
      $$UnitsTableCreateCompanionBuilder,
      $$UnitsTableUpdateCompanionBuilder,
      (Unit, $$UnitsTableReferences),
      Unit,
      PrefetchHooks Function({
        bool fromUnit,
        bool toUnit,
        bool productsRefs,
        bool productUomsFrom,
        bool productUomsTo,
        bool purchaseItemsRefs,
      })
    >;
typedef $$UomConversionsTableCreateCompanionBuilder =
    UomConversionsCompanion Function({
      Value<int> id,
      required int fromUnitId,
      required int toUnitId,
      required double conversionFactor,
      Value<String?> description,
      Value<bool> isActive,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$UomConversionsTableUpdateCompanionBuilder =
    UomConversionsCompanion Function({
      Value<int> id,
      Value<int> fromUnitId,
      Value<int> toUnitId,
      Value<double> conversionFactor,
      Value<String?> description,
      Value<bool> isActive,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$UomConversionsTableReferences
    extends BaseReferences<_$AppDatabase, $UomConversionsTable, UomConversion> {
  $$UomConversionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $UnitsTable _fromUnitIdTable(_$AppDatabase db) =>
      db.units.createAlias('uom_conversion__from_unit_id__unit__id');

  $$UnitsTableProcessedTableManager get fromUnitId {
    final $_column = $_itemColumn<int>('from_unit_id')!;

    final manager = $$UnitsTableTableManager(
      $_db,
      $_db.units,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_fromUnitIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $UnitsTable _toUnitIdTable(_$AppDatabase db) =>
      db.units.createAlias('uom_conversion__to_unit_id__unit__id');

  $$UnitsTableProcessedTableManager get toUnitId {
    final $_column = $_itemColumn<int>('to_unit_id')!;

    final manager = $$UnitsTableTableManager(
      $_db,
      $_db.units,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_toUnitIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$UomConversionsTableFilterComposer
    extends Composer<_$AppDatabase, $UomConversionsTable> {
  $$UomConversionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get conversionFactor => $composableBuilder(
    column: $table.conversionFactor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$UnitsTableFilterComposer get fromUnitId {
    final $$UnitsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.fromUnitId,
      referencedTable: $db.units,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UnitsTableFilterComposer(
            $db: $db,
            $table: $db.units,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UnitsTableFilterComposer get toUnitId {
    final $$UnitsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.toUnitId,
      referencedTable: $db.units,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UnitsTableFilterComposer(
            $db: $db,
            $table: $db.units,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$UomConversionsTableOrderingComposer
    extends Composer<_$AppDatabase, $UomConversionsTable> {
  $$UomConversionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get conversionFactor => $composableBuilder(
    column: $table.conversionFactor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$UnitsTableOrderingComposer get fromUnitId {
    final $$UnitsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.fromUnitId,
      referencedTable: $db.units,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UnitsTableOrderingComposer(
            $db: $db,
            $table: $db.units,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UnitsTableOrderingComposer get toUnitId {
    final $$UnitsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.toUnitId,
      referencedTable: $db.units,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UnitsTableOrderingComposer(
            $db: $db,
            $table: $db.units,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$UomConversionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $UomConversionsTable> {
  $$UomConversionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get conversionFactor => $composableBuilder(
    column: $table.conversionFactor,
    builder: (column) => column,
  );

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$UnitsTableAnnotationComposer get fromUnitId {
    final $$UnitsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.fromUnitId,
      referencedTable: $db.units,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UnitsTableAnnotationComposer(
            $db: $db,
            $table: $db.units,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UnitsTableAnnotationComposer get toUnitId {
    final $$UnitsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.toUnitId,
      referencedTable: $db.units,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UnitsTableAnnotationComposer(
            $db: $db,
            $table: $db.units,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$UomConversionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UomConversionsTable,
          UomConversion,
          $$UomConversionsTableFilterComposer,
          $$UomConversionsTableOrderingComposer,
          $$UomConversionsTableAnnotationComposer,
          $$UomConversionsTableCreateCompanionBuilder,
          $$UomConversionsTableUpdateCompanionBuilder,
          (UomConversion, $$UomConversionsTableReferences),
          UomConversion,
          PrefetchHooks Function({bool fromUnitId, bool toUnitId})
        > {
  $$UomConversionsTableTableManager(
    _$AppDatabase db,
    $UomConversionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UomConversionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UomConversionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UomConversionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> fromUnitId = const Value.absent(),
                Value<int> toUnitId = const Value.absent(),
                Value<double> conversionFactor = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => UomConversionsCompanion(
                id: id,
                fromUnitId: fromUnitId,
                toUnitId: toUnitId,
                conversionFactor: conversionFactor,
                description: description,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int fromUnitId,
                required int toUnitId,
                required double conversionFactor,
                Value<String?> description = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => UomConversionsCompanion.insert(
                id: id,
                fromUnitId: fromUnitId,
                toUnitId: toUnitId,
                conversionFactor: conversionFactor,
                description: description,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$UomConversionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({fromUnitId = false, toUnitId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (fromUnitId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.fromUnitId,
                                referencedTable: $$UomConversionsTableReferences
                                    ._fromUnitIdTable(db),
                                referencedColumn:
                                    $$UomConversionsTableReferences
                                        ._fromUnitIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (toUnitId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.toUnitId,
                                referencedTable: $$UomConversionsTableReferences
                                    ._toUnitIdTable(db),
                                referencedColumn:
                                    $$UomConversionsTableReferences
                                        ._toUnitIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$UomConversionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UomConversionsTable,
      UomConversion,
      $$UomConversionsTableFilterComposer,
      $$UomConversionsTableOrderingComposer,
      $$UomConversionsTableAnnotationComposer,
      $$UomConversionsTableCreateCompanionBuilder,
      $$UomConversionsTableUpdateCompanionBuilder,
      (UomConversion, $$UomConversionsTableReferences),
      UomConversion,
      PrefetchHooks Function({bool fromUnitId, bool toUnitId})
    >;
typedef $$TaxCategoriesTableCreateCompanionBuilder =
    TaxCategoriesCompanion Function({
      Value<int> id,
      required String taxCategoryCode,
      required String taxCategoryName,
      Value<String?> description,
      Value<bool> isActive,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$TaxCategoriesTableUpdateCompanionBuilder =
    TaxCategoriesCompanion Function({
      Value<int> id,
      Value<String> taxCategoryCode,
      Value<String> taxCategoryName,
      Value<String?> description,
      Value<bool> isActive,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$TaxCategoriesTableReferences
    extends BaseReferences<_$AppDatabase, $TaxCategoriesTable, TaxCategory> {
  $$TaxCategoriesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$TaxCategoryRatesTable, List<TaxCategoryRate>>
  _taxCategoryRatesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.taxCategoryRates,
    aliasName: 'tax_category__id__tax_category_rate__tax_category_id',
  );

  $$TaxCategoryRatesTableProcessedTableManager get taxCategoryRatesRefs {
    final manager = $$TaxCategoryRatesTableTableManager(
      $_db,
      $_db.taxCategoryRates,
    ).filter((f) => f.taxCategoryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _taxCategoryRatesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ProductsTable, List<Product>> _productsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.products,
    aliasName: 'tax_category__id__product__tax_category_id',
  );

  $$ProductsTableProcessedTableManager get productsRefs {
    final manager = $$ProductsTableTableManager(
      $_db,
      $_db.products,
    ).filter((f) => f.taxCategoryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_productsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TaxCategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $TaxCategoriesTable> {
  $$TaxCategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get taxCategoryCode => $composableBuilder(
    column: $table.taxCategoryCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get taxCategoryName => $composableBuilder(
    column: $table.taxCategoryName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> taxCategoryRatesRefs(
    Expression<bool> Function($$TaxCategoryRatesTableFilterComposer f) f,
  ) {
    final $$TaxCategoryRatesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.taxCategoryRates,
      getReferencedColumn: (t) => t.taxCategoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaxCategoryRatesTableFilterComposer(
            $db: $db,
            $table: $db.taxCategoryRates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> productsRefs(
    Expression<bool> Function($$ProductsTableFilterComposer f) f,
  ) {
    final $$ProductsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.taxCategoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableFilterComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TaxCategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $TaxCategoriesTable> {
  $$TaxCategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get taxCategoryCode => $composableBuilder(
    column: $table.taxCategoryCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get taxCategoryName => $composableBuilder(
    column: $table.taxCategoryName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TaxCategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $TaxCategoriesTable> {
  $$TaxCategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get taxCategoryCode => $composableBuilder(
    column: $table.taxCategoryCode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get taxCategoryName => $composableBuilder(
    column: $table.taxCategoryName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> taxCategoryRatesRefs<T extends Object>(
    Expression<T> Function($$TaxCategoryRatesTableAnnotationComposer a) f,
  ) {
    final $$TaxCategoryRatesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.taxCategoryRates,
      getReferencedColumn: (t) => t.taxCategoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaxCategoryRatesTableAnnotationComposer(
            $db: $db,
            $table: $db.taxCategoryRates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> productsRefs<T extends Object>(
    Expression<T> Function($$ProductsTableAnnotationComposer a) f,
  ) {
    final $$ProductsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.taxCategoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableAnnotationComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TaxCategoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TaxCategoriesTable,
          TaxCategory,
          $$TaxCategoriesTableFilterComposer,
          $$TaxCategoriesTableOrderingComposer,
          $$TaxCategoriesTableAnnotationComposer,
          $$TaxCategoriesTableCreateCompanionBuilder,
          $$TaxCategoriesTableUpdateCompanionBuilder,
          (TaxCategory, $$TaxCategoriesTableReferences),
          TaxCategory,
          PrefetchHooks Function({bool taxCategoryRatesRefs, bool productsRefs})
        > {
  $$TaxCategoriesTableTableManager(_$AppDatabase db, $TaxCategoriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TaxCategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TaxCategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TaxCategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> taxCategoryCode = const Value.absent(),
                Value<String> taxCategoryName = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => TaxCategoriesCompanion(
                id: id,
                taxCategoryCode: taxCategoryCode,
                taxCategoryName: taxCategoryName,
                description: description,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String taxCategoryCode,
                required String taxCategoryName,
                Value<String?> description = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => TaxCategoriesCompanion.insert(
                id: id,
                taxCategoryCode: taxCategoryCode,
                taxCategoryName: taxCategoryName,
                description: description,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TaxCategoriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({taxCategoryRatesRefs = false, productsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (taxCategoryRatesRefs) db.taxCategoryRates,
                    if (productsRefs) db.products,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (taxCategoryRatesRefs)
                        await $_getPrefetchedData<
                          TaxCategory,
                          $TaxCategoriesTable,
                          TaxCategoryRate
                        >(
                          currentTable: table,
                          referencedTable: $$TaxCategoriesTableReferences
                              ._taxCategoryRatesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TaxCategoriesTableReferences(
                                db,
                                table,
                                p0,
                              ).taxCategoryRatesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.taxCategoryId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (productsRefs)
                        await $_getPrefetchedData<
                          TaxCategory,
                          $TaxCategoriesTable,
                          Product
                        >(
                          currentTable: table,
                          referencedTable: $$TaxCategoriesTableReferences
                              ._productsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TaxCategoriesTableReferences(
                                db,
                                table,
                                p0,
                              ).productsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.taxCategoryId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$TaxCategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TaxCategoriesTable,
      TaxCategory,
      $$TaxCategoriesTableFilterComposer,
      $$TaxCategoriesTableOrderingComposer,
      $$TaxCategoriesTableAnnotationComposer,
      $$TaxCategoriesTableCreateCompanionBuilder,
      $$TaxCategoriesTableUpdateCompanionBuilder,
      (TaxCategory, $$TaxCategoriesTableReferences),
      TaxCategory,
      PrefetchHooks Function({bool taxCategoryRatesRefs, bool productsRefs})
    >;
typedef $$TaxTypesTableCreateCompanionBuilder =
    TaxTypesCompanion Function({
      Value<int> id,
      required String taxTypeCode,
      required String taxTypeName,
      Value<String?> description,
      Value<bool> isActive,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$TaxTypesTableUpdateCompanionBuilder =
    TaxTypesCompanion Function({
      Value<int> id,
      Value<String> taxTypeCode,
      Value<String> taxTypeName,
      Value<String?> description,
      Value<bool> isActive,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$TaxTypesTableReferences
    extends BaseReferences<_$AppDatabase, $TaxTypesTable, TaxType> {
  $$TaxTypesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$TaxCategoryRatesTable, List<TaxCategoryRate>>
  _taxCategoryRatesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.taxCategoryRates,
    aliasName: 'tax_type__id__tax_category_rate__tax_type_id',
  );

  $$TaxCategoryRatesTableProcessedTableManager get taxCategoryRatesRefs {
    final manager = $$TaxCategoryRatesTableTableManager(
      $_db,
      $_db.taxCategoryRates,
    ).filter((f) => f.taxTypeId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _taxCategoryRatesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ProductsTable, List<Product>> _productsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.products,
    aliasName: 'tax_type__id__product__tax_type_id',
  );

  $$ProductsTableProcessedTableManager get productsRefs {
    final manager = $$ProductsTableTableManager(
      $_db,
      $_db.products,
    ).filter((f) => f.taxTypeId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_productsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TaxTypesTableFilterComposer
    extends Composer<_$AppDatabase, $TaxTypesTable> {
  $$TaxTypesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get taxTypeCode => $composableBuilder(
    column: $table.taxTypeCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get taxTypeName => $composableBuilder(
    column: $table.taxTypeName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> taxCategoryRatesRefs(
    Expression<bool> Function($$TaxCategoryRatesTableFilterComposer f) f,
  ) {
    final $$TaxCategoryRatesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.taxCategoryRates,
      getReferencedColumn: (t) => t.taxTypeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaxCategoryRatesTableFilterComposer(
            $db: $db,
            $table: $db.taxCategoryRates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> productsRefs(
    Expression<bool> Function($$ProductsTableFilterComposer f) f,
  ) {
    final $$ProductsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.taxTypeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableFilterComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TaxTypesTableOrderingComposer
    extends Composer<_$AppDatabase, $TaxTypesTable> {
  $$TaxTypesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get taxTypeCode => $composableBuilder(
    column: $table.taxTypeCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get taxTypeName => $composableBuilder(
    column: $table.taxTypeName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TaxTypesTableAnnotationComposer
    extends Composer<_$AppDatabase, $TaxTypesTable> {
  $$TaxTypesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get taxTypeCode => $composableBuilder(
    column: $table.taxTypeCode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get taxTypeName => $composableBuilder(
    column: $table.taxTypeName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> taxCategoryRatesRefs<T extends Object>(
    Expression<T> Function($$TaxCategoryRatesTableAnnotationComposer a) f,
  ) {
    final $$TaxCategoryRatesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.taxCategoryRates,
      getReferencedColumn: (t) => t.taxTypeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaxCategoryRatesTableAnnotationComposer(
            $db: $db,
            $table: $db.taxCategoryRates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> productsRefs<T extends Object>(
    Expression<T> Function($$ProductsTableAnnotationComposer a) f,
  ) {
    final $$ProductsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.taxTypeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableAnnotationComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TaxTypesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TaxTypesTable,
          TaxType,
          $$TaxTypesTableFilterComposer,
          $$TaxTypesTableOrderingComposer,
          $$TaxTypesTableAnnotationComposer,
          $$TaxTypesTableCreateCompanionBuilder,
          $$TaxTypesTableUpdateCompanionBuilder,
          (TaxType, $$TaxTypesTableReferences),
          TaxType,
          PrefetchHooks Function({bool taxCategoryRatesRefs, bool productsRefs})
        > {
  $$TaxTypesTableTableManager(_$AppDatabase db, $TaxTypesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TaxTypesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TaxTypesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TaxTypesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> taxTypeCode = const Value.absent(),
                Value<String> taxTypeName = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => TaxTypesCompanion(
                id: id,
                taxTypeCode: taxTypeCode,
                taxTypeName: taxTypeName,
                description: description,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String taxTypeCode,
                required String taxTypeName,
                Value<String?> description = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => TaxTypesCompanion.insert(
                id: id,
                taxTypeCode: taxTypeCode,
                taxTypeName: taxTypeName,
                description: description,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TaxTypesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({taxCategoryRatesRefs = false, productsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (taxCategoryRatesRefs) db.taxCategoryRates,
                    if (productsRefs) db.products,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (taxCategoryRatesRefs)
                        await $_getPrefetchedData<
                          TaxType,
                          $TaxTypesTable,
                          TaxCategoryRate
                        >(
                          currentTable: table,
                          referencedTable: $$TaxTypesTableReferences
                              ._taxCategoryRatesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TaxTypesTableReferences(
                                db,
                                table,
                                p0,
                              ).taxCategoryRatesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.taxTypeId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (productsRefs)
                        await $_getPrefetchedData<
                          TaxType,
                          $TaxTypesTable,
                          Product
                        >(
                          currentTable: table,
                          referencedTable: $$TaxTypesTableReferences
                              ._productsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TaxTypesTableReferences(
                                db,
                                table,
                                p0,
                              ).productsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.taxTypeId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$TaxTypesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TaxTypesTable,
      TaxType,
      $$TaxTypesTableFilterComposer,
      $$TaxTypesTableOrderingComposer,
      $$TaxTypesTableAnnotationComposer,
      $$TaxTypesTableCreateCompanionBuilder,
      $$TaxTypesTableUpdateCompanionBuilder,
      (TaxType, $$TaxTypesTableReferences),
      TaxType,
      PrefetchHooks Function({bool taxCategoryRatesRefs, bool productsRefs})
    >;
typedef $$TaxCategoryRatesTableCreateCompanionBuilder =
    TaxCategoryRatesCompanion Function({
      Value<int> id,
      required int taxCategoryId,
      required int taxTypeId,
      required double ratePercent,
      Value<bool> isActive,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$TaxCategoryRatesTableUpdateCompanionBuilder =
    TaxCategoryRatesCompanion Function({
      Value<int> id,
      Value<int> taxCategoryId,
      Value<int> taxTypeId,
      Value<double> ratePercent,
      Value<bool> isActive,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$TaxCategoryRatesTableReferences
    extends
        BaseReferences<_$AppDatabase, $TaxCategoryRatesTable, TaxCategoryRate> {
  $$TaxCategoryRatesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $TaxCategoriesTable _taxCategoryIdTable(_$AppDatabase db) => db
      .taxCategories
      .createAlias('tax_category_rate__tax_category_id__tax_category__id');

  $$TaxCategoriesTableProcessedTableManager get taxCategoryId {
    final $_column = $_itemColumn<int>('tax_category_id')!;

    final manager = $$TaxCategoriesTableTableManager(
      $_db,
      $_db.taxCategories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_taxCategoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $TaxTypesTable _taxTypeIdTable(_$AppDatabase db) =>
      db.taxTypes.createAlias('tax_category_rate__tax_type_id__tax_type__id');

  $$TaxTypesTableProcessedTableManager get taxTypeId {
    final $_column = $_itemColumn<int>('tax_type_id')!;

    final manager = $$TaxTypesTableTableManager(
      $_db,
      $_db.taxTypes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_taxTypeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TaxCategoryRatesTableFilterComposer
    extends Composer<_$AppDatabase, $TaxCategoryRatesTable> {
  $$TaxCategoryRatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get ratePercent => $composableBuilder(
    column: $table.ratePercent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$TaxCategoriesTableFilterComposer get taxCategoryId {
    final $$TaxCategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taxCategoryId,
      referencedTable: $db.taxCategories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaxCategoriesTableFilterComposer(
            $db: $db,
            $table: $db.taxCategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TaxTypesTableFilterComposer get taxTypeId {
    final $$TaxTypesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taxTypeId,
      referencedTable: $db.taxTypes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaxTypesTableFilterComposer(
            $db: $db,
            $table: $db.taxTypes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TaxCategoryRatesTableOrderingComposer
    extends Composer<_$AppDatabase, $TaxCategoryRatesTable> {
  $$TaxCategoryRatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get ratePercent => $composableBuilder(
    column: $table.ratePercent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$TaxCategoriesTableOrderingComposer get taxCategoryId {
    final $$TaxCategoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taxCategoryId,
      referencedTable: $db.taxCategories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaxCategoriesTableOrderingComposer(
            $db: $db,
            $table: $db.taxCategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TaxTypesTableOrderingComposer get taxTypeId {
    final $$TaxTypesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taxTypeId,
      referencedTable: $db.taxTypes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaxTypesTableOrderingComposer(
            $db: $db,
            $table: $db.taxTypes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TaxCategoryRatesTableAnnotationComposer
    extends Composer<_$AppDatabase, $TaxCategoryRatesTable> {
  $$TaxCategoryRatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get ratePercent => $composableBuilder(
    column: $table.ratePercent,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$TaxCategoriesTableAnnotationComposer get taxCategoryId {
    final $$TaxCategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taxCategoryId,
      referencedTable: $db.taxCategories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaxCategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.taxCategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TaxTypesTableAnnotationComposer get taxTypeId {
    final $$TaxTypesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taxTypeId,
      referencedTable: $db.taxTypes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaxTypesTableAnnotationComposer(
            $db: $db,
            $table: $db.taxTypes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TaxCategoryRatesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TaxCategoryRatesTable,
          TaxCategoryRate,
          $$TaxCategoryRatesTableFilterComposer,
          $$TaxCategoryRatesTableOrderingComposer,
          $$TaxCategoryRatesTableAnnotationComposer,
          $$TaxCategoryRatesTableCreateCompanionBuilder,
          $$TaxCategoryRatesTableUpdateCompanionBuilder,
          (TaxCategoryRate, $$TaxCategoryRatesTableReferences),
          TaxCategoryRate,
          PrefetchHooks Function({bool taxCategoryId, bool taxTypeId})
        > {
  $$TaxCategoryRatesTableTableManager(
    _$AppDatabase db,
    $TaxCategoryRatesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TaxCategoryRatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TaxCategoryRatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TaxCategoryRatesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> taxCategoryId = const Value.absent(),
                Value<int> taxTypeId = const Value.absent(),
                Value<double> ratePercent = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => TaxCategoryRatesCompanion(
                id: id,
                taxCategoryId: taxCategoryId,
                taxTypeId: taxTypeId,
                ratePercent: ratePercent,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int taxCategoryId,
                required int taxTypeId,
                required double ratePercent,
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => TaxCategoryRatesCompanion.insert(
                id: id,
                taxCategoryId: taxCategoryId,
                taxTypeId: taxTypeId,
                ratePercent: ratePercent,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TaxCategoryRatesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({taxCategoryId = false, taxTypeId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (taxCategoryId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.taxCategoryId,
                                referencedTable:
                                    $$TaxCategoryRatesTableReferences
                                        ._taxCategoryIdTable(db),
                                referencedColumn:
                                    $$TaxCategoryRatesTableReferences
                                        ._taxCategoryIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (taxTypeId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.taxTypeId,
                                referencedTable:
                                    $$TaxCategoryRatesTableReferences
                                        ._taxTypeIdTable(db),
                                referencedColumn:
                                    $$TaxCategoryRatesTableReferences
                                        ._taxTypeIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$TaxCategoryRatesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TaxCategoryRatesTable,
      TaxCategoryRate,
      $$TaxCategoryRatesTableFilterComposer,
      $$TaxCategoryRatesTableOrderingComposer,
      $$TaxCategoryRatesTableAnnotationComposer,
      $$TaxCategoryRatesTableCreateCompanionBuilder,
      $$TaxCategoryRatesTableUpdateCompanionBuilder,
      (TaxCategoryRate, $$TaxCategoryRatesTableReferences),
      TaxCategoryRate,
      PrefetchHooks Function({bool taxCategoryId, bool taxTypeId})
    >;
typedef $$CustomersTableCreateCompanionBuilder =
    CustomersCompanion Function({
      Value<int> id,
      required String customerCode,
      required String customerName,
      Value<String?> gstNumber,
      Value<String?> panNumber,
      Value<String?> mobile,
      Value<String?> alternateMobile,
      Value<String?> email,
      Value<String?> addressLine1,
      Value<String?> addressLine2,
      Value<String?> city,
      Value<String?> state,
      Value<String?> stateCode,
      Value<String?> country,
      Value<String?> pincode,
      Value<int> creditLimit,
      Value<int> openingBalance,
      Value<int> outstandingBalance,
      Value<DateTime?> paymentDueDate,
      Value<String?> accountName,
      Value<String?> accountNumber,
      Value<String?> bankName,
      Value<String?> branchName,
      Value<String?> ifscCode,
      Value<String> balanceType,
      Value<String?> notes,
      Value<bool> isActive,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$CustomersTableUpdateCompanionBuilder =
    CustomersCompanion Function({
      Value<int> id,
      Value<String> customerCode,
      Value<String> customerName,
      Value<String?> gstNumber,
      Value<String?> panNumber,
      Value<String?> mobile,
      Value<String?> alternateMobile,
      Value<String?> email,
      Value<String?> addressLine1,
      Value<String?> addressLine2,
      Value<String?> city,
      Value<String?> state,
      Value<String?> stateCode,
      Value<String?> country,
      Value<String?> pincode,
      Value<int> creditLimit,
      Value<int> openingBalance,
      Value<int> outstandingBalance,
      Value<DateTime?> paymentDueDate,
      Value<String?> accountName,
      Value<String?> accountNumber,
      Value<String?> bankName,
      Value<String?> branchName,
      Value<String?> ifscCode,
      Value<String> balanceType,
      Value<String?> notes,
      Value<bool> isActive,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

class $$CustomersTableFilterComposer
    extends Composer<_$AppDatabase, $CustomersTable> {
  $$CustomersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get customerCode => $composableBuilder(
    column: $table.customerCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get customerName => $composableBuilder(
    column: $table.customerName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get gstNumber => $composableBuilder(
    column: $table.gstNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get panNumber => $composableBuilder(
    column: $table.panNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mobile => $composableBuilder(
    column: $table.mobile,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get alternateMobile => $composableBuilder(
    column: $table.alternateMobile,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get addressLine1 => $composableBuilder(
    column: $table.addressLine1,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get addressLine2 => $composableBuilder(
    column: $table.addressLine2,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get city => $composableBuilder(
    column: $table.city,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get stateCode => $composableBuilder(
    column: $table.stateCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get country => $composableBuilder(
    column: $table.country,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pincode => $composableBuilder(
    column: $table.pincode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get creditLimit => $composableBuilder(
    column: $table.creditLimit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get openingBalance => $composableBuilder(
    column: $table.openingBalance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get outstandingBalance => $composableBuilder(
    column: $table.outstandingBalance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get paymentDueDate => $composableBuilder(
    column: $table.paymentDueDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get accountName => $composableBuilder(
    column: $table.accountName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get accountNumber => $composableBuilder(
    column: $table.accountNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bankName => $composableBuilder(
    column: $table.bankName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get branchName => $composableBuilder(
    column: $table.branchName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ifscCode => $composableBuilder(
    column: $table.ifscCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get balanceType => $composableBuilder(
    column: $table.balanceType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CustomersTableOrderingComposer
    extends Composer<_$AppDatabase, $CustomersTable> {
  $$CustomersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get customerCode => $composableBuilder(
    column: $table.customerCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get customerName => $composableBuilder(
    column: $table.customerName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gstNumber => $composableBuilder(
    column: $table.gstNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get panNumber => $composableBuilder(
    column: $table.panNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mobile => $composableBuilder(
    column: $table.mobile,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get alternateMobile => $composableBuilder(
    column: $table.alternateMobile,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get addressLine1 => $composableBuilder(
    column: $table.addressLine1,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get addressLine2 => $composableBuilder(
    column: $table.addressLine2,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get city => $composableBuilder(
    column: $table.city,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get stateCode => $composableBuilder(
    column: $table.stateCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get country => $composableBuilder(
    column: $table.country,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pincode => $composableBuilder(
    column: $table.pincode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get creditLimit => $composableBuilder(
    column: $table.creditLimit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get openingBalance => $composableBuilder(
    column: $table.openingBalance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get outstandingBalance => $composableBuilder(
    column: $table.outstandingBalance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get paymentDueDate => $composableBuilder(
    column: $table.paymentDueDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get accountName => $composableBuilder(
    column: $table.accountName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get accountNumber => $composableBuilder(
    column: $table.accountNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bankName => $composableBuilder(
    column: $table.bankName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get branchName => $composableBuilder(
    column: $table.branchName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ifscCode => $composableBuilder(
    column: $table.ifscCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get balanceType => $composableBuilder(
    column: $table.balanceType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CustomersTableAnnotationComposer
    extends Composer<_$AppDatabase, $CustomersTable> {
  $$CustomersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get customerCode => $composableBuilder(
    column: $table.customerCode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get customerName => $composableBuilder(
    column: $table.customerName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get gstNumber =>
      $composableBuilder(column: $table.gstNumber, builder: (column) => column);

  GeneratedColumn<String> get panNumber =>
      $composableBuilder(column: $table.panNumber, builder: (column) => column);

  GeneratedColumn<String> get mobile =>
      $composableBuilder(column: $table.mobile, builder: (column) => column);

  GeneratedColumn<String> get alternateMobile => $composableBuilder(
    column: $table.alternateMobile,
    builder: (column) => column,
  );

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get addressLine1 => $composableBuilder(
    column: $table.addressLine1,
    builder: (column) => column,
  );

  GeneratedColumn<String> get addressLine2 => $composableBuilder(
    column: $table.addressLine2,
    builder: (column) => column,
  );

  GeneratedColumn<String> get city =>
      $composableBuilder(column: $table.city, builder: (column) => column);

  GeneratedColumn<String> get state =>
      $composableBuilder(column: $table.state, builder: (column) => column);

  GeneratedColumn<String> get stateCode =>
      $composableBuilder(column: $table.stateCode, builder: (column) => column);

  GeneratedColumn<String> get country =>
      $composableBuilder(column: $table.country, builder: (column) => column);

  GeneratedColumn<String> get pincode =>
      $composableBuilder(column: $table.pincode, builder: (column) => column);

  GeneratedColumn<int> get creditLimit => $composableBuilder(
    column: $table.creditLimit,
    builder: (column) => column,
  );

  GeneratedColumn<int> get openingBalance => $composableBuilder(
    column: $table.openingBalance,
    builder: (column) => column,
  );

  GeneratedColumn<int> get outstandingBalance => $composableBuilder(
    column: $table.outstandingBalance,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get paymentDueDate => $composableBuilder(
    column: $table.paymentDueDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get accountName => $composableBuilder(
    column: $table.accountName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get accountNumber => $composableBuilder(
    column: $table.accountNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get bankName =>
      $composableBuilder(column: $table.bankName, builder: (column) => column);

  GeneratedColumn<String> get branchName => $composableBuilder(
    column: $table.branchName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get ifscCode =>
      $composableBuilder(column: $table.ifscCode, builder: (column) => column);

  GeneratedColumn<String> get balanceType => $composableBuilder(
    column: $table.balanceType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$CustomersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CustomersTable,
          Customer,
          $$CustomersTableFilterComposer,
          $$CustomersTableOrderingComposer,
          $$CustomersTableAnnotationComposer,
          $$CustomersTableCreateCompanionBuilder,
          $$CustomersTableUpdateCompanionBuilder,
          (Customer, BaseReferences<_$AppDatabase, $CustomersTable, Customer>),
          Customer,
          PrefetchHooks Function()
        > {
  $$CustomersTableTableManager(_$AppDatabase db, $CustomersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CustomersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CustomersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CustomersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> customerCode = const Value.absent(),
                Value<String> customerName = const Value.absent(),
                Value<String?> gstNumber = const Value.absent(),
                Value<String?> panNumber = const Value.absent(),
                Value<String?> mobile = const Value.absent(),
                Value<String?> alternateMobile = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String?> addressLine1 = const Value.absent(),
                Value<String?> addressLine2 = const Value.absent(),
                Value<String?> city = const Value.absent(),
                Value<String?> state = const Value.absent(),
                Value<String?> stateCode = const Value.absent(),
                Value<String?> country = const Value.absent(),
                Value<String?> pincode = const Value.absent(),
                Value<int> creditLimit = const Value.absent(),
                Value<int> openingBalance = const Value.absent(),
                Value<int> outstandingBalance = const Value.absent(),
                Value<DateTime?> paymentDueDate = const Value.absent(),
                Value<String?> accountName = const Value.absent(),
                Value<String?> accountNumber = const Value.absent(),
                Value<String?> bankName = const Value.absent(),
                Value<String?> branchName = const Value.absent(),
                Value<String?> ifscCode = const Value.absent(),
                Value<String> balanceType = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => CustomersCompanion(
                id: id,
                customerCode: customerCode,
                customerName: customerName,
                gstNumber: gstNumber,
                panNumber: panNumber,
                mobile: mobile,
                alternateMobile: alternateMobile,
                email: email,
                addressLine1: addressLine1,
                addressLine2: addressLine2,
                city: city,
                state: state,
                stateCode: stateCode,
                country: country,
                pincode: pincode,
                creditLimit: creditLimit,
                openingBalance: openingBalance,
                outstandingBalance: outstandingBalance,
                paymentDueDate: paymentDueDate,
                accountName: accountName,
                accountNumber: accountNumber,
                bankName: bankName,
                branchName: branchName,
                ifscCode: ifscCode,
                balanceType: balanceType,
                notes: notes,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String customerCode,
                required String customerName,
                Value<String?> gstNumber = const Value.absent(),
                Value<String?> panNumber = const Value.absent(),
                Value<String?> mobile = const Value.absent(),
                Value<String?> alternateMobile = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String?> addressLine1 = const Value.absent(),
                Value<String?> addressLine2 = const Value.absent(),
                Value<String?> city = const Value.absent(),
                Value<String?> state = const Value.absent(),
                Value<String?> stateCode = const Value.absent(),
                Value<String?> country = const Value.absent(),
                Value<String?> pincode = const Value.absent(),
                Value<int> creditLimit = const Value.absent(),
                Value<int> openingBalance = const Value.absent(),
                Value<int> outstandingBalance = const Value.absent(),
                Value<DateTime?> paymentDueDate = const Value.absent(),
                Value<String?> accountName = const Value.absent(),
                Value<String?> accountNumber = const Value.absent(),
                Value<String?> bankName = const Value.absent(),
                Value<String?> branchName = const Value.absent(),
                Value<String?> ifscCode = const Value.absent(),
                Value<String> balanceType = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => CustomersCompanion.insert(
                id: id,
                customerCode: customerCode,
                customerName: customerName,
                gstNumber: gstNumber,
                panNumber: panNumber,
                mobile: mobile,
                alternateMobile: alternateMobile,
                email: email,
                addressLine1: addressLine1,
                addressLine2: addressLine2,
                city: city,
                state: state,
                stateCode: stateCode,
                country: country,
                pincode: pincode,
                creditLimit: creditLimit,
                openingBalance: openingBalance,
                outstandingBalance: outstandingBalance,
                paymentDueDate: paymentDueDate,
                accountName: accountName,
                accountNumber: accountNumber,
                bankName: bankName,
                branchName: branchName,
                ifscCode: ifscCode,
                balanceType: balanceType,
                notes: notes,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CustomersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CustomersTable,
      Customer,
      $$CustomersTableFilterComposer,
      $$CustomersTableOrderingComposer,
      $$CustomersTableAnnotationComposer,
      $$CustomersTableCreateCompanionBuilder,
      $$CustomersTableUpdateCompanionBuilder,
      (Customer, BaseReferences<_$AppDatabase, $CustomersTable, Customer>),
      Customer,
      PrefetchHooks Function()
    >;
typedef $$SuppliersTableCreateCompanionBuilder =
    SuppliersCompanion Function({
      Value<int> id,
      required String supplierCode,
      required String supplierName,
      Value<String?> contactPerson,
      Value<String?> gstNumber,
      Value<String?> panNumber,
      Value<String?> mobile,
      Value<String?> alternateMobile,
      Value<String?> email,
      Value<String?> addressLine1,
      Value<String?> addressLine2,
      Value<String?> city,
      Value<String?> state,
      Value<String?> stateCode,
      Value<String?> country,
      Value<String?> pincode,
      Value<int> creditLimit,
      Value<int> openingBalance,
      Value<int> outstandingBalance,
      Value<DateTime?> paymentDueDate,
      Value<String?> accountName,
      Value<String?> accountNumber,
      Value<String?> bankName,
      Value<String?> branchName,
      Value<String?> ifscCode,
      Value<String?> paymentTerms,
      Value<String> balanceType,
      Value<String?> notes,
      Value<bool> isActive,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$SuppliersTableUpdateCompanionBuilder =
    SuppliersCompanion Function({
      Value<int> id,
      Value<String> supplierCode,
      Value<String> supplierName,
      Value<String?> contactPerson,
      Value<String?> gstNumber,
      Value<String?> panNumber,
      Value<String?> mobile,
      Value<String?> alternateMobile,
      Value<String?> email,
      Value<String?> addressLine1,
      Value<String?> addressLine2,
      Value<String?> city,
      Value<String?> state,
      Value<String?> stateCode,
      Value<String?> country,
      Value<String?> pincode,
      Value<int> creditLimit,
      Value<int> openingBalance,
      Value<int> outstandingBalance,
      Value<DateTime?> paymentDueDate,
      Value<String?> accountName,
      Value<String?> accountNumber,
      Value<String?> bankName,
      Value<String?> branchName,
      Value<String?> ifscCode,
      Value<String?> paymentTerms,
      Value<String> balanceType,
      Value<String?> notes,
      Value<bool> isActive,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$SuppliersTableReferences
    extends BaseReferences<_$AppDatabase, $SuppliersTable, Supplier> {
  $$SuppliersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$PurchasesTable, List<Purchase>>
  _purchasesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.purchases,
    aliasName: 'supplier__id__purchase__supplier_id',
  );

  $$PurchasesTableProcessedTableManager get purchasesRefs {
    final manager = $$PurchasesTableTableManager(
      $_db,
      $_db.purchases,
    ).filter((f) => f.supplierId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_purchasesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SuppliersTableFilterComposer
    extends Composer<_$AppDatabase, $SuppliersTable> {
  $$SuppliersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get supplierCode => $composableBuilder(
    column: $table.supplierCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get supplierName => $composableBuilder(
    column: $table.supplierName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contactPerson => $composableBuilder(
    column: $table.contactPerson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get gstNumber => $composableBuilder(
    column: $table.gstNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get panNumber => $composableBuilder(
    column: $table.panNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mobile => $composableBuilder(
    column: $table.mobile,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get alternateMobile => $composableBuilder(
    column: $table.alternateMobile,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get addressLine1 => $composableBuilder(
    column: $table.addressLine1,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get addressLine2 => $composableBuilder(
    column: $table.addressLine2,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get city => $composableBuilder(
    column: $table.city,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get stateCode => $composableBuilder(
    column: $table.stateCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get country => $composableBuilder(
    column: $table.country,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pincode => $composableBuilder(
    column: $table.pincode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get creditLimit => $composableBuilder(
    column: $table.creditLimit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get openingBalance => $composableBuilder(
    column: $table.openingBalance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get outstandingBalance => $composableBuilder(
    column: $table.outstandingBalance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get paymentDueDate => $composableBuilder(
    column: $table.paymentDueDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get accountName => $composableBuilder(
    column: $table.accountName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get accountNumber => $composableBuilder(
    column: $table.accountNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bankName => $composableBuilder(
    column: $table.bankName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get branchName => $composableBuilder(
    column: $table.branchName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ifscCode => $composableBuilder(
    column: $table.ifscCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get paymentTerms => $composableBuilder(
    column: $table.paymentTerms,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get balanceType => $composableBuilder(
    column: $table.balanceType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> purchasesRefs(
    Expression<bool> Function($$PurchasesTableFilterComposer f) f,
  ) {
    final $$PurchasesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.purchases,
      getReferencedColumn: (t) => t.supplierId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PurchasesTableFilterComposer(
            $db: $db,
            $table: $db.purchases,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SuppliersTableOrderingComposer
    extends Composer<_$AppDatabase, $SuppliersTable> {
  $$SuppliersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get supplierCode => $composableBuilder(
    column: $table.supplierCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get supplierName => $composableBuilder(
    column: $table.supplierName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contactPerson => $composableBuilder(
    column: $table.contactPerson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gstNumber => $composableBuilder(
    column: $table.gstNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get panNumber => $composableBuilder(
    column: $table.panNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mobile => $composableBuilder(
    column: $table.mobile,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get alternateMobile => $composableBuilder(
    column: $table.alternateMobile,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get addressLine1 => $composableBuilder(
    column: $table.addressLine1,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get addressLine2 => $composableBuilder(
    column: $table.addressLine2,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get city => $composableBuilder(
    column: $table.city,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get stateCode => $composableBuilder(
    column: $table.stateCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get country => $composableBuilder(
    column: $table.country,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pincode => $composableBuilder(
    column: $table.pincode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get creditLimit => $composableBuilder(
    column: $table.creditLimit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get openingBalance => $composableBuilder(
    column: $table.openingBalance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get outstandingBalance => $composableBuilder(
    column: $table.outstandingBalance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get paymentDueDate => $composableBuilder(
    column: $table.paymentDueDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get accountName => $composableBuilder(
    column: $table.accountName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get accountNumber => $composableBuilder(
    column: $table.accountNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bankName => $composableBuilder(
    column: $table.bankName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get branchName => $composableBuilder(
    column: $table.branchName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ifscCode => $composableBuilder(
    column: $table.ifscCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get paymentTerms => $composableBuilder(
    column: $table.paymentTerms,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get balanceType => $composableBuilder(
    column: $table.balanceType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SuppliersTableAnnotationComposer
    extends Composer<_$AppDatabase, $SuppliersTable> {
  $$SuppliersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get supplierCode => $composableBuilder(
    column: $table.supplierCode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get supplierName => $composableBuilder(
    column: $table.supplierName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get contactPerson => $composableBuilder(
    column: $table.contactPerson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get gstNumber =>
      $composableBuilder(column: $table.gstNumber, builder: (column) => column);

  GeneratedColumn<String> get panNumber =>
      $composableBuilder(column: $table.panNumber, builder: (column) => column);

  GeneratedColumn<String> get mobile =>
      $composableBuilder(column: $table.mobile, builder: (column) => column);

  GeneratedColumn<String> get alternateMobile => $composableBuilder(
    column: $table.alternateMobile,
    builder: (column) => column,
  );

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get addressLine1 => $composableBuilder(
    column: $table.addressLine1,
    builder: (column) => column,
  );

  GeneratedColumn<String> get addressLine2 => $composableBuilder(
    column: $table.addressLine2,
    builder: (column) => column,
  );

  GeneratedColumn<String> get city =>
      $composableBuilder(column: $table.city, builder: (column) => column);

  GeneratedColumn<String> get state =>
      $composableBuilder(column: $table.state, builder: (column) => column);

  GeneratedColumn<String> get stateCode =>
      $composableBuilder(column: $table.stateCode, builder: (column) => column);

  GeneratedColumn<String> get country =>
      $composableBuilder(column: $table.country, builder: (column) => column);

  GeneratedColumn<String> get pincode =>
      $composableBuilder(column: $table.pincode, builder: (column) => column);

  GeneratedColumn<int> get creditLimit => $composableBuilder(
    column: $table.creditLimit,
    builder: (column) => column,
  );

  GeneratedColumn<int> get openingBalance => $composableBuilder(
    column: $table.openingBalance,
    builder: (column) => column,
  );

  GeneratedColumn<int> get outstandingBalance => $composableBuilder(
    column: $table.outstandingBalance,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get paymentDueDate => $composableBuilder(
    column: $table.paymentDueDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get accountName => $composableBuilder(
    column: $table.accountName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get accountNumber => $composableBuilder(
    column: $table.accountNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get bankName =>
      $composableBuilder(column: $table.bankName, builder: (column) => column);

  GeneratedColumn<String> get branchName => $composableBuilder(
    column: $table.branchName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get ifscCode =>
      $composableBuilder(column: $table.ifscCode, builder: (column) => column);

  GeneratedColumn<String> get paymentTerms => $composableBuilder(
    column: $table.paymentTerms,
    builder: (column) => column,
  );

  GeneratedColumn<String> get balanceType => $composableBuilder(
    column: $table.balanceType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> purchasesRefs<T extends Object>(
    Expression<T> Function($$PurchasesTableAnnotationComposer a) f,
  ) {
    final $$PurchasesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.purchases,
      getReferencedColumn: (t) => t.supplierId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PurchasesTableAnnotationComposer(
            $db: $db,
            $table: $db.purchases,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SuppliersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SuppliersTable,
          Supplier,
          $$SuppliersTableFilterComposer,
          $$SuppliersTableOrderingComposer,
          $$SuppliersTableAnnotationComposer,
          $$SuppliersTableCreateCompanionBuilder,
          $$SuppliersTableUpdateCompanionBuilder,
          (Supplier, $$SuppliersTableReferences),
          Supplier,
          PrefetchHooks Function({bool purchasesRefs})
        > {
  $$SuppliersTableTableManager(_$AppDatabase db, $SuppliersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SuppliersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SuppliersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SuppliersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> supplierCode = const Value.absent(),
                Value<String> supplierName = const Value.absent(),
                Value<String?> contactPerson = const Value.absent(),
                Value<String?> gstNumber = const Value.absent(),
                Value<String?> panNumber = const Value.absent(),
                Value<String?> mobile = const Value.absent(),
                Value<String?> alternateMobile = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String?> addressLine1 = const Value.absent(),
                Value<String?> addressLine2 = const Value.absent(),
                Value<String?> city = const Value.absent(),
                Value<String?> state = const Value.absent(),
                Value<String?> stateCode = const Value.absent(),
                Value<String?> country = const Value.absent(),
                Value<String?> pincode = const Value.absent(),
                Value<int> creditLimit = const Value.absent(),
                Value<int> openingBalance = const Value.absent(),
                Value<int> outstandingBalance = const Value.absent(),
                Value<DateTime?> paymentDueDate = const Value.absent(),
                Value<String?> accountName = const Value.absent(),
                Value<String?> accountNumber = const Value.absent(),
                Value<String?> bankName = const Value.absent(),
                Value<String?> branchName = const Value.absent(),
                Value<String?> ifscCode = const Value.absent(),
                Value<String?> paymentTerms = const Value.absent(),
                Value<String> balanceType = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => SuppliersCompanion(
                id: id,
                supplierCode: supplierCode,
                supplierName: supplierName,
                contactPerson: contactPerson,
                gstNumber: gstNumber,
                panNumber: panNumber,
                mobile: mobile,
                alternateMobile: alternateMobile,
                email: email,
                addressLine1: addressLine1,
                addressLine2: addressLine2,
                city: city,
                state: state,
                stateCode: stateCode,
                country: country,
                pincode: pincode,
                creditLimit: creditLimit,
                openingBalance: openingBalance,
                outstandingBalance: outstandingBalance,
                paymentDueDate: paymentDueDate,
                accountName: accountName,
                accountNumber: accountNumber,
                bankName: bankName,
                branchName: branchName,
                ifscCode: ifscCode,
                paymentTerms: paymentTerms,
                balanceType: balanceType,
                notes: notes,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String supplierCode,
                required String supplierName,
                Value<String?> contactPerson = const Value.absent(),
                Value<String?> gstNumber = const Value.absent(),
                Value<String?> panNumber = const Value.absent(),
                Value<String?> mobile = const Value.absent(),
                Value<String?> alternateMobile = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String?> addressLine1 = const Value.absent(),
                Value<String?> addressLine2 = const Value.absent(),
                Value<String?> city = const Value.absent(),
                Value<String?> state = const Value.absent(),
                Value<String?> stateCode = const Value.absent(),
                Value<String?> country = const Value.absent(),
                Value<String?> pincode = const Value.absent(),
                Value<int> creditLimit = const Value.absent(),
                Value<int> openingBalance = const Value.absent(),
                Value<int> outstandingBalance = const Value.absent(),
                Value<DateTime?> paymentDueDate = const Value.absent(),
                Value<String?> accountName = const Value.absent(),
                Value<String?> accountNumber = const Value.absent(),
                Value<String?> bankName = const Value.absent(),
                Value<String?> branchName = const Value.absent(),
                Value<String?> ifscCode = const Value.absent(),
                Value<String?> paymentTerms = const Value.absent(),
                Value<String> balanceType = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => SuppliersCompanion.insert(
                id: id,
                supplierCode: supplierCode,
                supplierName: supplierName,
                contactPerson: contactPerson,
                gstNumber: gstNumber,
                panNumber: panNumber,
                mobile: mobile,
                alternateMobile: alternateMobile,
                email: email,
                addressLine1: addressLine1,
                addressLine2: addressLine2,
                city: city,
                state: state,
                stateCode: stateCode,
                country: country,
                pincode: pincode,
                creditLimit: creditLimit,
                openingBalance: openingBalance,
                outstandingBalance: outstandingBalance,
                paymentDueDate: paymentDueDate,
                accountName: accountName,
                accountNumber: accountNumber,
                bankName: bankName,
                branchName: branchName,
                ifscCode: ifscCode,
                paymentTerms: paymentTerms,
                balanceType: balanceType,
                notes: notes,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SuppliersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({purchasesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (purchasesRefs) db.purchases],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (purchasesRefs)
                    await $_getPrefetchedData<
                      Supplier,
                      $SuppliersTable,
                      Purchase
                    >(
                      currentTable: table,
                      referencedTable: $$SuppliersTableReferences
                          ._purchasesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$SuppliersTableReferences(
                            db,
                            table,
                            p0,
                          ).purchasesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.supplierId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$SuppliersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SuppliersTable,
      Supplier,
      $$SuppliersTableFilterComposer,
      $$SuppliersTableOrderingComposer,
      $$SuppliersTableAnnotationComposer,
      $$SuppliersTableCreateCompanionBuilder,
      $$SuppliersTableUpdateCompanionBuilder,
      (Supplier, $$SuppliersTableReferences),
      Supplier,
      PrefetchHooks Function({bool purchasesRefs})
    >;
typedef $$ProductsTableCreateCompanionBuilder =
    ProductsCompanion Function({
      Value<int> id,
      required String productCode,
      required String productName,
      Value<int?> categoryId,
      Value<int?> subCategoryId,
      Value<int?> brandId,
      required int unitId,
      Value<int> sellingPrice,
      Value<int?> purchasePrice,
      Value<int?> mrp,
      Value<int?> wholesalePrice,
      Value<String?> barcode,
      Value<String?> hsnCode,
      Value<int?> taxTypeId,
      Value<int?> taxCategoryId,
      Value<DateTime?> expiryDate,
      Value<String?> notes,
      Value<bool> isActive,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$ProductsTableUpdateCompanionBuilder =
    ProductsCompanion Function({
      Value<int> id,
      Value<String> productCode,
      Value<String> productName,
      Value<int?> categoryId,
      Value<int?> subCategoryId,
      Value<int?> brandId,
      Value<int> unitId,
      Value<int> sellingPrice,
      Value<int?> purchasePrice,
      Value<int?> mrp,
      Value<int?> wholesalePrice,
      Value<String?> barcode,
      Value<String?> hsnCode,
      Value<int?> taxTypeId,
      Value<int?> taxCategoryId,
      Value<DateTime?> expiryDate,
      Value<String?> notes,
      Value<bool> isActive,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$ProductsTableReferences
    extends BaseReferences<_$AppDatabase, $ProductsTable, Product> {
  $$ProductsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CategoriesTable _categoryIdTable(_$AppDatabase db) =>
      db.categories.createAlias('product__category_id__category__id');

  $$CategoriesTableProcessedTableManager? get categoryId {
    final $_column = $_itemColumn<int>('category_id');
    if ($_column == null) return null;
    final manager = $$CategoriesTableTableManager(
      $_db,
      $_db.categories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $SubCategoriesTable _subCategoryIdTable(_$AppDatabase db) => db
      .subCategories
      .createAlias('product__sub_category_id__sub_category__id');

  $$SubCategoriesTableProcessedTableManager? get subCategoryId {
    final $_column = $_itemColumn<int>('sub_category_id');
    if ($_column == null) return null;
    final manager = $$SubCategoriesTableTableManager(
      $_db,
      $_db.subCategories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_subCategoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $BrandsTable _brandIdTable(_$AppDatabase db) =>
      db.brands.createAlias('product__brand_id__brand__id');

  $$BrandsTableProcessedTableManager? get brandId {
    final $_column = $_itemColumn<int>('brand_id');
    if ($_column == null) return null;
    final manager = $$BrandsTableTableManager(
      $_db,
      $_db.brands,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_brandIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $UnitsTable _unitIdTable(_$AppDatabase db) =>
      db.units.createAlias('product__unit_id__unit__id');

  $$UnitsTableProcessedTableManager get unitId {
    final $_column = $_itemColumn<int>('unit_id')!;

    final manager = $$UnitsTableTableManager(
      $_db,
      $_db.units,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_unitIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $TaxTypesTable _taxTypeIdTable(_$AppDatabase db) =>
      db.taxTypes.createAlias('product__tax_type_id__tax_type__id');

  $$TaxTypesTableProcessedTableManager? get taxTypeId {
    final $_column = $_itemColumn<int>('tax_type_id');
    if ($_column == null) return null;
    final manager = $$TaxTypesTableTableManager(
      $_db,
      $_db.taxTypes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_taxTypeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $TaxCategoriesTable _taxCategoryIdTable(_$AppDatabase db) => db
      .taxCategories
      .createAlias('product__tax_category_id__tax_category__id');

  $$TaxCategoriesTableProcessedTableManager? get taxCategoryId {
    final $_column = $_itemColumn<int>('tax_category_id');
    if ($_column == null) return null;
    final manager = $$TaxCategoriesTableTableManager(
      $_db,
      $_db.taxCategories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_taxCategoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$ProductVariantsTable, List<ProductVariant>>
  _productVariantsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.productVariants,
    aliasName: 'product__id__product_variant__product_id',
  );

  $$ProductVariantsTableProcessedTableManager get productVariantsRefs {
    final manager = $$ProductVariantsTableTableManager(
      $_db,
      $_db.productVariants,
    ).filter((f) => f.productId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _productVariantsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ProductUomsTable, List<ProductUom>>
  _productUomsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.productUoms,
    aliasName: 'product__id__product_uom__product_id',
  );

  $$ProductUomsTableProcessedTableManager get productUomsRefs {
    final manager = $$ProductUomsTableTableManager(
      $_db,
      $_db.productUoms,
    ).filter((f) => f.productId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_productUomsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PurchaseItemsTable, List<PurchaseItem>>
  _purchaseItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.purchaseItems,
    aliasName: 'product__id__purchase_item__product_id',
  );

  $$PurchaseItemsTableProcessedTableManager get purchaseItemsRefs {
    final manager = $$PurchaseItemsTableTableManager(
      $_db,
      $_db.purchaseItems,
    ).filter((f) => f.productId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_purchaseItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $InventoryTransactionsTable,
    List<InventoryTransaction>
  >
  _inventoryTransactionsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.inventoryTransactions,
        aliasName: 'product__id__inventory_transaction__product_id',
      );

  $$InventoryTransactionsTableProcessedTableManager
  get inventoryTransactionsRefs {
    final manager = $$InventoryTransactionsTableTableManager(
      $_db,
      $_db.inventoryTransactions,
    ).filter((f) => f.productId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _inventoryTransactionsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$CurrentStocksTable, List<CurrentStock>>
  _currentStocksRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.currentStocks,
    aliasName: 'product__id__current_stock__product_id',
  );

  $$CurrentStocksTableProcessedTableManager get currentStocksRefs {
    final manager = $$CurrentStocksTableTableManager(
      $_db,
      $_db.currentStocks,
    ).filter((f) => f.productId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_currentStocksRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ProductsTableFilterComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productCode => $composableBuilder(
    column: $table.productCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productName => $composableBuilder(
    column: $table.productName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sellingPrice => $composableBuilder(
    column: $table.sellingPrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get purchasePrice => $composableBuilder(
    column: $table.purchasePrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get mrp => $composableBuilder(
    column: $table.mrp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get wholesalePrice => $composableBuilder(
    column: $table.wholesalePrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get barcode => $composableBuilder(
    column: $table.barcode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hsnCode => $composableBuilder(
    column: $table.hsnCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get expiryDate => $composableBuilder(
    column: $table.expiryDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$CategoriesTableFilterComposer get categoryId {
    final $$CategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableFilterComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SubCategoriesTableFilterComposer get subCategoryId {
    final $$SubCategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.subCategoryId,
      referencedTable: $db.subCategories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubCategoriesTableFilterComposer(
            $db: $db,
            $table: $db.subCategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$BrandsTableFilterComposer get brandId {
    final $$BrandsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.brandId,
      referencedTable: $db.brands,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BrandsTableFilterComposer(
            $db: $db,
            $table: $db.brands,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UnitsTableFilterComposer get unitId {
    final $$UnitsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.unitId,
      referencedTable: $db.units,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UnitsTableFilterComposer(
            $db: $db,
            $table: $db.units,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TaxTypesTableFilterComposer get taxTypeId {
    final $$TaxTypesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taxTypeId,
      referencedTable: $db.taxTypes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaxTypesTableFilterComposer(
            $db: $db,
            $table: $db.taxTypes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TaxCategoriesTableFilterComposer get taxCategoryId {
    final $$TaxCategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taxCategoryId,
      referencedTable: $db.taxCategories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaxCategoriesTableFilterComposer(
            $db: $db,
            $table: $db.taxCategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> productVariantsRefs(
    Expression<bool> Function($$ProductVariantsTableFilterComposer f) f,
  ) {
    final $$ProductVariantsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.productVariants,
      getReferencedColumn: (t) => t.productId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductVariantsTableFilterComposer(
            $db: $db,
            $table: $db.productVariants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> productUomsRefs(
    Expression<bool> Function($$ProductUomsTableFilterComposer f) f,
  ) {
    final $$ProductUomsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.productUoms,
      getReferencedColumn: (t) => t.productId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductUomsTableFilterComposer(
            $db: $db,
            $table: $db.productUoms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> purchaseItemsRefs(
    Expression<bool> Function($$PurchaseItemsTableFilterComposer f) f,
  ) {
    final $$PurchaseItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.purchaseItems,
      getReferencedColumn: (t) => t.productId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PurchaseItemsTableFilterComposer(
            $db: $db,
            $table: $db.purchaseItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> inventoryTransactionsRefs(
    Expression<bool> Function($$InventoryTransactionsTableFilterComposer f) f,
  ) {
    final $$InventoryTransactionsTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.inventoryTransactions,
          getReferencedColumn: (t) => t.productId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$InventoryTransactionsTableFilterComposer(
                $db: $db,
                $table: $db.inventoryTransactions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> currentStocksRefs(
    Expression<bool> Function($$CurrentStocksTableFilterComposer f) f,
  ) {
    final $$CurrentStocksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.currentStocks,
      getReferencedColumn: (t) => t.productId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CurrentStocksTableFilterComposer(
            $db: $db,
            $table: $db.currentStocks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProductsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productCode => $composableBuilder(
    column: $table.productCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productName => $composableBuilder(
    column: $table.productName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sellingPrice => $composableBuilder(
    column: $table.sellingPrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get purchasePrice => $composableBuilder(
    column: $table.purchasePrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get mrp => $composableBuilder(
    column: $table.mrp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get wholesalePrice => $composableBuilder(
    column: $table.wholesalePrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get barcode => $composableBuilder(
    column: $table.barcode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hsnCode => $composableBuilder(
    column: $table.hsnCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get expiryDate => $composableBuilder(
    column: $table.expiryDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$CategoriesTableOrderingComposer get categoryId {
    final $$CategoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableOrderingComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SubCategoriesTableOrderingComposer get subCategoryId {
    final $$SubCategoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.subCategoryId,
      referencedTable: $db.subCategories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubCategoriesTableOrderingComposer(
            $db: $db,
            $table: $db.subCategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$BrandsTableOrderingComposer get brandId {
    final $$BrandsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.brandId,
      referencedTable: $db.brands,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BrandsTableOrderingComposer(
            $db: $db,
            $table: $db.brands,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UnitsTableOrderingComposer get unitId {
    final $$UnitsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.unitId,
      referencedTable: $db.units,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UnitsTableOrderingComposer(
            $db: $db,
            $table: $db.units,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TaxTypesTableOrderingComposer get taxTypeId {
    final $$TaxTypesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taxTypeId,
      referencedTable: $db.taxTypes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaxTypesTableOrderingComposer(
            $db: $db,
            $table: $db.taxTypes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TaxCategoriesTableOrderingComposer get taxCategoryId {
    final $$TaxCategoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taxCategoryId,
      referencedTable: $db.taxCategories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaxCategoriesTableOrderingComposer(
            $db: $db,
            $table: $db.taxCategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProductsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get productCode => $composableBuilder(
    column: $table.productCode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get productName => $composableBuilder(
    column: $table.productName,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sellingPrice => $composableBuilder(
    column: $table.sellingPrice,
    builder: (column) => column,
  );

  GeneratedColumn<int> get purchasePrice => $composableBuilder(
    column: $table.purchasePrice,
    builder: (column) => column,
  );

  GeneratedColumn<int> get mrp =>
      $composableBuilder(column: $table.mrp, builder: (column) => column);

  GeneratedColumn<int> get wholesalePrice => $composableBuilder(
    column: $table.wholesalePrice,
    builder: (column) => column,
  );

  GeneratedColumn<String> get barcode =>
      $composableBuilder(column: $table.barcode, builder: (column) => column);

  GeneratedColumn<String> get hsnCode =>
      $composableBuilder(column: $table.hsnCode, builder: (column) => column);

  GeneratedColumn<DateTime> get expiryDate => $composableBuilder(
    column: $table.expiryDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$CategoriesTableAnnotationComposer get categoryId {
    final $$CategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SubCategoriesTableAnnotationComposer get subCategoryId {
    final $$SubCategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.subCategoryId,
      referencedTable: $db.subCategories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubCategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.subCategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$BrandsTableAnnotationComposer get brandId {
    final $$BrandsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.brandId,
      referencedTable: $db.brands,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BrandsTableAnnotationComposer(
            $db: $db,
            $table: $db.brands,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UnitsTableAnnotationComposer get unitId {
    final $$UnitsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.unitId,
      referencedTable: $db.units,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UnitsTableAnnotationComposer(
            $db: $db,
            $table: $db.units,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TaxTypesTableAnnotationComposer get taxTypeId {
    final $$TaxTypesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taxTypeId,
      referencedTable: $db.taxTypes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaxTypesTableAnnotationComposer(
            $db: $db,
            $table: $db.taxTypes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TaxCategoriesTableAnnotationComposer get taxCategoryId {
    final $$TaxCategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taxCategoryId,
      referencedTable: $db.taxCategories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaxCategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.taxCategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> productVariantsRefs<T extends Object>(
    Expression<T> Function($$ProductVariantsTableAnnotationComposer a) f,
  ) {
    final $$ProductVariantsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.productVariants,
      getReferencedColumn: (t) => t.productId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductVariantsTableAnnotationComposer(
            $db: $db,
            $table: $db.productVariants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> productUomsRefs<T extends Object>(
    Expression<T> Function($$ProductUomsTableAnnotationComposer a) f,
  ) {
    final $$ProductUomsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.productUoms,
      getReferencedColumn: (t) => t.productId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductUomsTableAnnotationComposer(
            $db: $db,
            $table: $db.productUoms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> purchaseItemsRefs<T extends Object>(
    Expression<T> Function($$PurchaseItemsTableAnnotationComposer a) f,
  ) {
    final $$PurchaseItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.purchaseItems,
      getReferencedColumn: (t) => t.productId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PurchaseItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.purchaseItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> inventoryTransactionsRefs<T extends Object>(
    Expression<T> Function($$InventoryTransactionsTableAnnotationComposer a) f,
  ) {
    final $$InventoryTransactionsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.inventoryTransactions,
          getReferencedColumn: (t) => t.productId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$InventoryTransactionsTableAnnotationComposer(
                $db: $db,
                $table: $db.inventoryTransactions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> currentStocksRefs<T extends Object>(
    Expression<T> Function($$CurrentStocksTableAnnotationComposer a) f,
  ) {
    final $$CurrentStocksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.currentStocks,
      getReferencedColumn: (t) => t.productId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CurrentStocksTableAnnotationComposer(
            $db: $db,
            $table: $db.currentStocks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProductsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProductsTable,
          Product,
          $$ProductsTableFilterComposer,
          $$ProductsTableOrderingComposer,
          $$ProductsTableAnnotationComposer,
          $$ProductsTableCreateCompanionBuilder,
          $$ProductsTableUpdateCompanionBuilder,
          (Product, $$ProductsTableReferences),
          Product,
          PrefetchHooks Function({
            bool categoryId,
            bool subCategoryId,
            bool brandId,
            bool unitId,
            bool taxTypeId,
            bool taxCategoryId,
            bool productVariantsRefs,
            bool productUomsRefs,
            bool purchaseItemsRefs,
            bool inventoryTransactionsRefs,
            bool currentStocksRefs,
          })
        > {
  $$ProductsTableTableManager(_$AppDatabase db, $ProductsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProductsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> productCode = const Value.absent(),
                Value<String> productName = const Value.absent(),
                Value<int?> categoryId = const Value.absent(),
                Value<int?> subCategoryId = const Value.absent(),
                Value<int?> brandId = const Value.absent(),
                Value<int> unitId = const Value.absent(),
                Value<int> sellingPrice = const Value.absent(),
                Value<int?> purchasePrice = const Value.absent(),
                Value<int?> mrp = const Value.absent(),
                Value<int?> wholesalePrice = const Value.absent(),
                Value<String?> barcode = const Value.absent(),
                Value<String?> hsnCode = const Value.absent(),
                Value<int?> taxTypeId = const Value.absent(),
                Value<int?> taxCategoryId = const Value.absent(),
                Value<DateTime?> expiryDate = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => ProductsCompanion(
                id: id,
                productCode: productCode,
                productName: productName,
                categoryId: categoryId,
                subCategoryId: subCategoryId,
                brandId: brandId,
                unitId: unitId,
                sellingPrice: sellingPrice,
                purchasePrice: purchasePrice,
                mrp: mrp,
                wholesalePrice: wholesalePrice,
                barcode: barcode,
                hsnCode: hsnCode,
                taxTypeId: taxTypeId,
                taxCategoryId: taxCategoryId,
                expiryDate: expiryDate,
                notes: notes,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String productCode,
                required String productName,
                Value<int?> categoryId = const Value.absent(),
                Value<int?> subCategoryId = const Value.absent(),
                Value<int?> brandId = const Value.absent(),
                required int unitId,
                Value<int> sellingPrice = const Value.absent(),
                Value<int?> purchasePrice = const Value.absent(),
                Value<int?> mrp = const Value.absent(),
                Value<int?> wholesalePrice = const Value.absent(),
                Value<String?> barcode = const Value.absent(),
                Value<String?> hsnCode = const Value.absent(),
                Value<int?> taxTypeId = const Value.absent(),
                Value<int?> taxCategoryId = const Value.absent(),
                Value<DateTime?> expiryDate = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => ProductsCompanion.insert(
                id: id,
                productCode: productCode,
                productName: productName,
                categoryId: categoryId,
                subCategoryId: subCategoryId,
                brandId: brandId,
                unitId: unitId,
                sellingPrice: sellingPrice,
                purchasePrice: purchasePrice,
                mrp: mrp,
                wholesalePrice: wholesalePrice,
                barcode: barcode,
                hsnCode: hsnCode,
                taxTypeId: taxTypeId,
                taxCategoryId: taxCategoryId,
                expiryDate: expiryDate,
                notes: notes,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ProductsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                categoryId = false,
                subCategoryId = false,
                brandId = false,
                unitId = false,
                taxTypeId = false,
                taxCategoryId = false,
                productVariantsRefs = false,
                productUomsRefs = false,
                purchaseItemsRefs = false,
                inventoryTransactionsRefs = false,
                currentStocksRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (productVariantsRefs) db.productVariants,
                    if (productUomsRefs) db.productUoms,
                    if (purchaseItemsRefs) db.purchaseItems,
                    if (inventoryTransactionsRefs) db.inventoryTransactions,
                    if (currentStocksRefs) db.currentStocks,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (categoryId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.categoryId,
                                    referencedTable: $$ProductsTableReferences
                                        ._categoryIdTable(db),
                                    referencedColumn: $$ProductsTableReferences
                                        ._categoryIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (subCategoryId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.subCategoryId,
                                    referencedTable: $$ProductsTableReferences
                                        ._subCategoryIdTable(db),
                                    referencedColumn: $$ProductsTableReferences
                                        ._subCategoryIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (brandId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.brandId,
                                    referencedTable: $$ProductsTableReferences
                                        ._brandIdTable(db),
                                    referencedColumn: $$ProductsTableReferences
                                        ._brandIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (unitId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.unitId,
                                    referencedTable: $$ProductsTableReferences
                                        ._unitIdTable(db),
                                    referencedColumn: $$ProductsTableReferences
                                        ._unitIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (taxTypeId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.taxTypeId,
                                    referencedTable: $$ProductsTableReferences
                                        ._taxTypeIdTable(db),
                                    referencedColumn: $$ProductsTableReferences
                                        ._taxTypeIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (taxCategoryId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.taxCategoryId,
                                    referencedTable: $$ProductsTableReferences
                                        ._taxCategoryIdTable(db),
                                    referencedColumn: $$ProductsTableReferences
                                        ._taxCategoryIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (productVariantsRefs)
                        await $_getPrefetchedData<
                          Product,
                          $ProductsTable,
                          ProductVariant
                        >(
                          currentTable: table,
                          referencedTable: $$ProductsTableReferences
                              ._productVariantsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProductsTableReferences(
                                db,
                                table,
                                p0,
                              ).productVariantsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.productId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (productUomsRefs)
                        await $_getPrefetchedData<
                          Product,
                          $ProductsTable,
                          ProductUom
                        >(
                          currentTable: table,
                          referencedTable: $$ProductsTableReferences
                              ._productUomsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProductsTableReferences(
                                db,
                                table,
                                p0,
                              ).productUomsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.productId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (purchaseItemsRefs)
                        await $_getPrefetchedData<
                          Product,
                          $ProductsTable,
                          PurchaseItem
                        >(
                          currentTable: table,
                          referencedTable: $$ProductsTableReferences
                              ._purchaseItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProductsTableReferences(
                                db,
                                table,
                                p0,
                              ).purchaseItemsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.productId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (inventoryTransactionsRefs)
                        await $_getPrefetchedData<
                          Product,
                          $ProductsTable,
                          InventoryTransaction
                        >(
                          currentTable: table,
                          referencedTable: $$ProductsTableReferences
                              ._inventoryTransactionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProductsTableReferences(
                                db,
                                table,
                                p0,
                              ).inventoryTransactionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.productId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (currentStocksRefs)
                        await $_getPrefetchedData<
                          Product,
                          $ProductsTable,
                          CurrentStock
                        >(
                          currentTable: table,
                          referencedTable: $$ProductsTableReferences
                              ._currentStocksRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProductsTableReferences(
                                db,
                                table,
                                p0,
                              ).currentStocksRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.productId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ProductsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProductsTable,
      Product,
      $$ProductsTableFilterComposer,
      $$ProductsTableOrderingComposer,
      $$ProductsTableAnnotationComposer,
      $$ProductsTableCreateCompanionBuilder,
      $$ProductsTableUpdateCompanionBuilder,
      (Product, $$ProductsTableReferences),
      Product,
      PrefetchHooks Function({
        bool categoryId,
        bool subCategoryId,
        bool brandId,
        bool unitId,
        bool taxTypeId,
        bool taxCategoryId,
        bool productVariantsRefs,
        bool productUomsRefs,
        bool purchaseItemsRefs,
        bool inventoryTransactionsRefs,
        bool currentStocksRefs,
      })
    >;
typedef $$ProductVariantsTableCreateCompanionBuilder =
    ProductVariantsCompanion Function({
      Value<int> id,
      required int productId,
      required String variantName,
      Value<int> sellingPrice,
      Value<int?> purchasePrice,
      Value<int?> mrp,
      Value<int?> wholesalePrice,
      Value<String?> barcode,
      Value<String?> hsnCode,
      Value<DateTime?> expiryDate,
      Value<String?> notes,
      Value<bool> isActive,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$ProductVariantsTableUpdateCompanionBuilder =
    ProductVariantsCompanion Function({
      Value<int> id,
      Value<int> productId,
      Value<String> variantName,
      Value<int> sellingPrice,
      Value<int?> purchasePrice,
      Value<int?> mrp,
      Value<int?> wholesalePrice,
      Value<String?> barcode,
      Value<String?> hsnCode,
      Value<DateTime?> expiryDate,
      Value<String?> notes,
      Value<bool> isActive,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$ProductVariantsTableReferences
    extends
        BaseReferences<_$AppDatabase, $ProductVariantsTable, ProductVariant> {
  $$ProductVariantsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ProductsTable _productIdTable(_$AppDatabase db) =>
      db.products.createAlias('product_variant__product_id__product__id');

  $$ProductsTableProcessedTableManager get productId {
    final $_column = $_itemColumn<int>('product_id')!;

    final manager = $$ProductsTableTableManager(
      $_db,
      $_db.products,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_productIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$PurchaseItemsTable, List<PurchaseItem>>
  _purchaseItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.purchaseItems,
    aliasName: 'product_variant__id__purchase_item__variant_id',
  );

  $$PurchaseItemsTableProcessedTableManager get purchaseItemsRefs {
    final manager = $$PurchaseItemsTableTableManager(
      $_db,
      $_db.purchaseItems,
    ).filter((f) => f.variantId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_purchaseItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $InventoryTransactionsTable,
    List<InventoryTransaction>
  >
  _inventoryTransactionsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.inventoryTransactions,
        aliasName: 'product_variant__id__inventory_transaction__variant_id',
      );

  $$InventoryTransactionsTableProcessedTableManager
  get inventoryTransactionsRefs {
    final manager = $$InventoryTransactionsTableTableManager(
      $_db,
      $_db.inventoryTransactions,
    ).filter((f) => f.variantId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _inventoryTransactionsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$CurrentStocksTable, List<CurrentStock>>
  _currentStocksRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.currentStocks,
    aliasName: 'product_variant__id__current_stock__variant_id',
  );

  $$CurrentStocksTableProcessedTableManager get currentStocksRefs {
    final manager = $$CurrentStocksTableTableManager(
      $_db,
      $_db.currentStocks,
    ).filter((f) => f.variantId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_currentStocksRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ProductVariantsTableFilterComposer
    extends Composer<_$AppDatabase, $ProductVariantsTable> {
  $$ProductVariantsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get variantName => $composableBuilder(
    column: $table.variantName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sellingPrice => $composableBuilder(
    column: $table.sellingPrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get purchasePrice => $composableBuilder(
    column: $table.purchasePrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get mrp => $composableBuilder(
    column: $table.mrp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get wholesalePrice => $composableBuilder(
    column: $table.wholesalePrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get barcode => $composableBuilder(
    column: $table.barcode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hsnCode => $composableBuilder(
    column: $table.hsnCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get expiryDate => $composableBuilder(
    column: $table.expiryDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ProductsTableFilterComposer get productId {
    final $$ProductsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableFilterComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> purchaseItemsRefs(
    Expression<bool> Function($$PurchaseItemsTableFilterComposer f) f,
  ) {
    final $$PurchaseItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.purchaseItems,
      getReferencedColumn: (t) => t.variantId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PurchaseItemsTableFilterComposer(
            $db: $db,
            $table: $db.purchaseItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> inventoryTransactionsRefs(
    Expression<bool> Function($$InventoryTransactionsTableFilterComposer f) f,
  ) {
    final $$InventoryTransactionsTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.inventoryTransactions,
          getReferencedColumn: (t) => t.variantId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$InventoryTransactionsTableFilterComposer(
                $db: $db,
                $table: $db.inventoryTransactions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> currentStocksRefs(
    Expression<bool> Function($$CurrentStocksTableFilterComposer f) f,
  ) {
    final $$CurrentStocksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.currentStocks,
      getReferencedColumn: (t) => t.variantId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CurrentStocksTableFilterComposer(
            $db: $db,
            $table: $db.currentStocks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProductVariantsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductVariantsTable> {
  $$ProductVariantsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get variantName => $composableBuilder(
    column: $table.variantName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sellingPrice => $composableBuilder(
    column: $table.sellingPrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get purchasePrice => $composableBuilder(
    column: $table.purchasePrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get mrp => $composableBuilder(
    column: $table.mrp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get wholesalePrice => $composableBuilder(
    column: $table.wholesalePrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get barcode => $composableBuilder(
    column: $table.barcode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hsnCode => $composableBuilder(
    column: $table.hsnCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get expiryDate => $composableBuilder(
    column: $table.expiryDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProductsTableOrderingComposer get productId {
    final $$ProductsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableOrderingComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProductVariantsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductVariantsTable> {
  $$ProductVariantsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get variantName => $composableBuilder(
    column: $table.variantName,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sellingPrice => $composableBuilder(
    column: $table.sellingPrice,
    builder: (column) => column,
  );

  GeneratedColumn<int> get purchasePrice => $composableBuilder(
    column: $table.purchasePrice,
    builder: (column) => column,
  );

  GeneratedColumn<int> get mrp =>
      $composableBuilder(column: $table.mrp, builder: (column) => column);

  GeneratedColumn<int> get wholesalePrice => $composableBuilder(
    column: $table.wholesalePrice,
    builder: (column) => column,
  );

  GeneratedColumn<String> get barcode =>
      $composableBuilder(column: $table.barcode, builder: (column) => column);

  GeneratedColumn<String> get hsnCode =>
      $composableBuilder(column: $table.hsnCode, builder: (column) => column);

  GeneratedColumn<DateTime> get expiryDate => $composableBuilder(
    column: $table.expiryDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$ProductsTableAnnotationComposer get productId {
    final $$ProductsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableAnnotationComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> purchaseItemsRefs<T extends Object>(
    Expression<T> Function($$PurchaseItemsTableAnnotationComposer a) f,
  ) {
    final $$PurchaseItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.purchaseItems,
      getReferencedColumn: (t) => t.variantId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PurchaseItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.purchaseItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> inventoryTransactionsRefs<T extends Object>(
    Expression<T> Function($$InventoryTransactionsTableAnnotationComposer a) f,
  ) {
    final $$InventoryTransactionsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.inventoryTransactions,
          getReferencedColumn: (t) => t.variantId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$InventoryTransactionsTableAnnotationComposer(
                $db: $db,
                $table: $db.inventoryTransactions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> currentStocksRefs<T extends Object>(
    Expression<T> Function($$CurrentStocksTableAnnotationComposer a) f,
  ) {
    final $$CurrentStocksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.currentStocks,
      getReferencedColumn: (t) => t.variantId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CurrentStocksTableAnnotationComposer(
            $db: $db,
            $table: $db.currentStocks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProductVariantsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProductVariantsTable,
          ProductVariant,
          $$ProductVariantsTableFilterComposer,
          $$ProductVariantsTableOrderingComposer,
          $$ProductVariantsTableAnnotationComposer,
          $$ProductVariantsTableCreateCompanionBuilder,
          $$ProductVariantsTableUpdateCompanionBuilder,
          (ProductVariant, $$ProductVariantsTableReferences),
          ProductVariant,
          PrefetchHooks Function({
            bool productId,
            bool purchaseItemsRefs,
            bool inventoryTransactionsRefs,
            bool currentStocksRefs,
          })
        > {
  $$ProductVariantsTableTableManager(
    _$AppDatabase db,
    $ProductVariantsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductVariantsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductVariantsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProductVariantsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> productId = const Value.absent(),
                Value<String> variantName = const Value.absent(),
                Value<int> sellingPrice = const Value.absent(),
                Value<int?> purchasePrice = const Value.absent(),
                Value<int?> mrp = const Value.absent(),
                Value<int?> wholesalePrice = const Value.absent(),
                Value<String?> barcode = const Value.absent(),
                Value<String?> hsnCode = const Value.absent(),
                Value<DateTime?> expiryDate = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => ProductVariantsCompanion(
                id: id,
                productId: productId,
                variantName: variantName,
                sellingPrice: sellingPrice,
                purchasePrice: purchasePrice,
                mrp: mrp,
                wholesalePrice: wholesalePrice,
                barcode: barcode,
                hsnCode: hsnCode,
                expiryDate: expiryDate,
                notes: notes,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int productId,
                required String variantName,
                Value<int> sellingPrice = const Value.absent(),
                Value<int?> purchasePrice = const Value.absent(),
                Value<int?> mrp = const Value.absent(),
                Value<int?> wholesalePrice = const Value.absent(),
                Value<String?> barcode = const Value.absent(),
                Value<String?> hsnCode = const Value.absent(),
                Value<DateTime?> expiryDate = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => ProductVariantsCompanion.insert(
                id: id,
                productId: productId,
                variantName: variantName,
                sellingPrice: sellingPrice,
                purchasePrice: purchasePrice,
                mrp: mrp,
                wholesalePrice: wholesalePrice,
                barcode: barcode,
                hsnCode: hsnCode,
                expiryDate: expiryDate,
                notes: notes,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ProductVariantsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                productId = false,
                purchaseItemsRefs = false,
                inventoryTransactionsRefs = false,
                currentStocksRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (purchaseItemsRefs) db.purchaseItems,
                    if (inventoryTransactionsRefs) db.inventoryTransactions,
                    if (currentStocksRefs) db.currentStocks,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (productId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.productId,
                                    referencedTable:
                                        $$ProductVariantsTableReferences
                                            ._productIdTable(db),
                                    referencedColumn:
                                        $$ProductVariantsTableReferences
                                            ._productIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (purchaseItemsRefs)
                        await $_getPrefetchedData<
                          ProductVariant,
                          $ProductVariantsTable,
                          PurchaseItem
                        >(
                          currentTable: table,
                          referencedTable: $$ProductVariantsTableReferences
                              ._purchaseItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProductVariantsTableReferences(
                                db,
                                table,
                                p0,
                              ).purchaseItemsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.variantId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (inventoryTransactionsRefs)
                        await $_getPrefetchedData<
                          ProductVariant,
                          $ProductVariantsTable,
                          InventoryTransaction
                        >(
                          currentTable: table,
                          referencedTable: $$ProductVariantsTableReferences
                              ._inventoryTransactionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProductVariantsTableReferences(
                                db,
                                table,
                                p0,
                              ).inventoryTransactionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.variantId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (currentStocksRefs)
                        await $_getPrefetchedData<
                          ProductVariant,
                          $ProductVariantsTable,
                          CurrentStock
                        >(
                          currentTable: table,
                          referencedTable: $$ProductVariantsTableReferences
                              ._currentStocksRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProductVariantsTableReferences(
                                db,
                                table,
                                p0,
                              ).currentStocksRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.variantId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ProductVariantsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProductVariantsTable,
      ProductVariant,
      $$ProductVariantsTableFilterComposer,
      $$ProductVariantsTableOrderingComposer,
      $$ProductVariantsTableAnnotationComposer,
      $$ProductVariantsTableCreateCompanionBuilder,
      $$ProductVariantsTableUpdateCompanionBuilder,
      (ProductVariant, $$ProductVariantsTableReferences),
      ProductVariant,
      PrefetchHooks Function({
        bool productId,
        bool purchaseItemsRefs,
        bool inventoryTransactionsRefs,
        bool currentStocksRefs,
      })
    >;
typedef $$ProductUomsTableCreateCompanionBuilder =
    ProductUomsCompanion Function({
      Value<int> id,
      required int productId,
      required int fromUnitId,
      required int toUnitId,
      required double conversionFactor,
      Value<bool> isDefault,
      Value<String?> description,
      Value<bool> isActive,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$ProductUomsTableUpdateCompanionBuilder =
    ProductUomsCompanion Function({
      Value<int> id,
      Value<int> productId,
      Value<int> fromUnitId,
      Value<int> toUnitId,
      Value<double> conversionFactor,
      Value<bool> isDefault,
      Value<String?> description,
      Value<bool> isActive,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$ProductUomsTableReferences
    extends BaseReferences<_$AppDatabase, $ProductUomsTable, ProductUom> {
  $$ProductUomsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ProductsTable _productIdTable(_$AppDatabase db) =>
      db.products.createAlias('product_uom__product_id__product__id');

  $$ProductsTableProcessedTableManager get productId {
    final $_column = $_itemColumn<int>('product_id')!;

    final manager = $$ProductsTableTableManager(
      $_db,
      $_db.products,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_productIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $UnitsTable _fromUnitIdTable(_$AppDatabase db) =>
      db.units.createAlias('product_uom__from_unit_id__unit__id');

  $$UnitsTableProcessedTableManager get fromUnitId {
    final $_column = $_itemColumn<int>('from_unit_id')!;

    final manager = $$UnitsTableTableManager(
      $_db,
      $_db.units,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_fromUnitIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $UnitsTable _toUnitIdTable(_$AppDatabase db) =>
      db.units.createAlias('product_uom__to_unit_id__unit__id');

  $$UnitsTableProcessedTableManager get toUnitId {
    final $_column = $_itemColumn<int>('to_unit_id')!;

    final manager = $$UnitsTableTableManager(
      $_db,
      $_db.units,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_toUnitIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ProductUomsTableFilterComposer
    extends Composer<_$AppDatabase, $ProductUomsTable> {
  $$ProductUomsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get conversionFactor => $composableBuilder(
    column: $table.conversionFactor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDefault => $composableBuilder(
    column: $table.isDefault,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ProductsTableFilterComposer get productId {
    final $$ProductsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableFilterComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UnitsTableFilterComposer get fromUnitId {
    final $$UnitsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.fromUnitId,
      referencedTable: $db.units,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UnitsTableFilterComposer(
            $db: $db,
            $table: $db.units,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UnitsTableFilterComposer get toUnitId {
    final $$UnitsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.toUnitId,
      referencedTable: $db.units,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UnitsTableFilterComposer(
            $db: $db,
            $table: $db.units,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProductUomsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductUomsTable> {
  $$ProductUomsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get conversionFactor => $composableBuilder(
    column: $table.conversionFactor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDefault => $composableBuilder(
    column: $table.isDefault,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProductsTableOrderingComposer get productId {
    final $$ProductsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableOrderingComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UnitsTableOrderingComposer get fromUnitId {
    final $$UnitsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.fromUnitId,
      referencedTable: $db.units,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UnitsTableOrderingComposer(
            $db: $db,
            $table: $db.units,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UnitsTableOrderingComposer get toUnitId {
    final $$UnitsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.toUnitId,
      referencedTable: $db.units,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UnitsTableOrderingComposer(
            $db: $db,
            $table: $db.units,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProductUomsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductUomsTable> {
  $$ProductUomsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get conversionFactor => $composableBuilder(
    column: $table.conversionFactor,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isDefault =>
      $composableBuilder(column: $table.isDefault, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$ProductsTableAnnotationComposer get productId {
    final $$ProductsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableAnnotationComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UnitsTableAnnotationComposer get fromUnitId {
    final $$UnitsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.fromUnitId,
      referencedTable: $db.units,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UnitsTableAnnotationComposer(
            $db: $db,
            $table: $db.units,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UnitsTableAnnotationComposer get toUnitId {
    final $$UnitsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.toUnitId,
      referencedTable: $db.units,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UnitsTableAnnotationComposer(
            $db: $db,
            $table: $db.units,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProductUomsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProductUomsTable,
          ProductUom,
          $$ProductUomsTableFilterComposer,
          $$ProductUomsTableOrderingComposer,
          $$ProductUomsTableAnnotationComposer,
          $$ProductUomsTableCreateCompanionBuilder,
          $$ProductUomsTableUpdateCompanionBuilder,
          (ProductUom, $$ProductUomsTableReferences),
          ProductUom,
          PrefetchHooks Function({
            bool productId,
            bool fromUnitId,
            bool toUnitId,
          })
        > {
  $$ProductUomsTableTableManager(_$AppDatabase db, $ProductUomsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductUomsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductUomsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProductUomsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> productId = const Value.absent(),
                Value<int> fromUnitId = const Value.absent(),
                Value<int> toUnitId = const Value.absent(),
                Value<double> conversionFactor = const Value.absent(),
                Value<bool> isDefault = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => ProductUomsCompanion(
                id: id,
                productId: productId,
                fromUnitId: fromUnitId,
                toUnitId: toUnitId,
                conversionFactor: conversionFactor,
                isDefault: isDefault,
                description: description,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int productId,
                required int fromUnitId,
                required int toUnitId,
                required double conversionFactor,
                Value<bool> isDefault = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => ProductUomsCompanion.insert(
                id: id,
                productId: productId,
                fromUnitId: fromUnitId,
                toUnitId: toUnitId,
                conversionFactor: conversionFactor,
                isDefault: isDefault,
                description: description,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ProductUomsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({productId = false, fromUnitId = false, toUnitId = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (productId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.productId,
                                    referencedTable:
                                        $$ProductUomsTableReferences
                                            ._productIdTable(db),
                                    referencedColumn:
                                        $$ProductUomsTableReferences
                                            ._productIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (fromUnitId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.fromUnitId,
                                    referencedTable:
                                        $$ProductUomsTableReferences
                                            ._fromUnitIdTable(db),
                                    referencedColumn:
                                        $$ProductUomsTableReferences
                                            ._fromUnitIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (toUnitId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.toUnitId,
                                    referencedTable:
                                        $$ProductUomsTableReferences
                                            ._toUnitIdTable(db),
                                    referencedColumn:
                                        $$ProductUomsTableReferences
                                            ._toUnitIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$ProductUomsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProductUomsTable,
      ProductUom,
      $$ProductUomsTableFilterComposer,
      $$ProductUomsTableOrderingComposer,
      $$ProductUomsTableAnnotationComposer,
      $$ProductUomsTableCreateCompanionBuilder,
      $$ProductUomsTableUpdateCompanionBuilder,
      (ProductUom, $$ProductUomsTableReferences),
      ProductUom,
      PrefetchHooks Function({bool productId, bool fromUnitId, bool toUnitId})
    >;
typedef $$DocumentNumberSequencesTableCreateCompanionBuilder =
    DocumentNumberSequencesCompanion Function({
      Value<int> id,
      required String documentType,
      required String prefix,
      Value<String?> suffix,
      Value<int> lastNumber,
      Value<int> padding,
      Value<bool> isActive,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$DocumentNumberSequencesTableUpdateCompanionBuilder =
    DocumentNumberSequencesCompanion Function({
      Value<int> id,
      Value<String> documentType,
      Value<String> prefix,
      Value<String?> suffix,
      Value<int> lastNumber,
      Value<int> padding,
      Value<bool> isActive,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

class $$DocumentNumberSequencesTableFilterComposer
    extends Composer<_$AppDatabase, $DocumentNumberSequencesTable> {
  $$DocumentNumberSequencesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get documentType => $composableBuilder(
    column: $table.documentType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get prefix => $composableBuilder(
    column: $table.prefix,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get suffix => $composableBuilder(
    column: $table.suffix,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastNumber => $composableBuilder(
    column: $table.lastNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get padding => $composableBuilder(
    column: $table.padding,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DocumentNumberSequencesTableOrderingComposer
    extends Composer<_$AppDatabase, $DocumentNumberSequencesTable> {
  $$DocumentNumberSequencesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get documentType => $composableBuilder(
    column: $table.documentType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get prefix => $composableBuilder(
    column: $table.prefix,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get suffix => $composableBuilder(
    column: $table.suffix,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastNumber => $composableBuilder(
    column: $table.lastNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get padding => $composableBuilder(
    column: $table.padding,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DocumentNumberSequencesTableAnnotationComposer
    extends Composer<_$AppDatabase, $DocumentNumberSequencesTable> {
  $$DocumentNumberSequencesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get documentType => $composableBuilder(
    column: $table.documentType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get prefix =>
      $composableBuilder(column: $table.prefix, builder: (column) => column);

  GeneratedColumn<String> get suffix =>
      $composableBuilder(column: $table.suffix, builder: (column) => column);

  GeneratedColumn<int> get lastNumber => $composableBuilder(
    column: $table.lastNumber,
    builder: (column) => column,
  );

  GeneratedColumn<int> get padding =>
      $composableBuilder(column: $table.padding, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$DocumentNumberSequencesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DocumentNumberSequencesTable,
          DocumentNumberSequence,
          $$DocumentNumberSequencesTableFilterComposer,
          $$DocumentNumberSequencesTableOrderingComposer,
          $$DocumentNumberSequencesTableAnnotationComposer,
          $$DocumentNumberSequencesTableCreateCompanionBuilder,
          $$DocumentNumberSequencesTableUpdateCompanionBuilder,
          (
            DocumentNumberSequence,
            BaseReferences<
              _$AppDatabase,
              $DocumentNumberSequencesTable,
              DocumentNumberSequence
            >,
          ),
          DocumentNumberSequence,
          PrefetchHooks Function()
        > {
  $$DocumentNumberSequencesTableTableManager(
    _$AppDatabase db,
    $DocumentNumberSequencesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DocumentNumberSequencesTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$DocumentNumberSequencesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$DocumentNumberSequencesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> documentType = const Value.absent(),
                Value<String> prefix = const Value.absent(),
                Value<String?> suffix = const Value.absent(),
                Value<int> lastNumber = const Value.absent(),
                Value<int> padding = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => DocumentNumberSequencesCompanion(
                id: id,
                documentType: documentType,
                prefix: prefix,
                suffix: suffix,
                lastNumber: lastNumber,
                padding: padding,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String documentType,
                required String prefix,
                Value<String?> suffix = const Value.absent(),
                Value<int> lastNumber = const Value.absent(),
                Value<int> padding = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => DocumentNumberSequencesCompanion.insert(
                id: id,
                documentType: documentType,
                prefix: prefix,
                suffix: suffix,
                lastNumber: lastNumber,
                padding: padding,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DocumentNumberSequencesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DocumentNumberSequencesTable,
      DocumentNumberSequence,
      $$DocumentNumberSequencesTableFilterComposer,
      $$DocumentNumberSequencesTableOrderingComposer,
      $$DocumentNumberSequencesTableAnnotationComposer,
      $$DocumentNumberSequencesTableCreateCompanionBuilder,
      $$DocumentNumberSequencesTableUpdateCompanionBuilder,
      (
        DocumentNumberSequence,
        BaseReferences<
          _$AppDatabase,
          $DocumentNumberSequencesTable,
          DocumentNumberSequence
        >,
      ),
      DocumentNumberSequence,
      PrefetchHooks Function()
    >;
typedef $$PurchasesTableCreateCompanionBuilder =
    PurchasesCompanion Function({
      Value<int> id,
      required String purchaseNumber,
      required int supplierId,
      required DateTime purchaseDate,
      Value<String?> invoiceNumber,
      Value<int> subtotal,
      Value<int> discount,
      Value<int> tax,
      Value<int> total,
      Value<int> paidAmount,
      Value<int> dueAmount,
      Value<String> paymentStatus,
      Value<String?> paymentMethod,
      Value<String?> notes,
      Value<bool> isReturn,
      Value<int?> originalPurchaseId,
      Value<bool> isActive,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$PurchasesTableUpdateCompanionBuilder =
    PurchasesCompanion Function({
      Value<int> id,
      Value<String> purchaseNumber,
      Value<int> supplierId,
      Value<DateTime> purchaseDate,
      Value<String?> invoiceNumber,
      Value<int> subtotal,
      Value<int> discount,
      Value<int> tax,
      Value<int> total,
      Value<int> paidAmount,
      Value<int> dueAmount,
      Value<String> paymentStatus,
      Value<String?> paymentMethod,
      Value<String?> notes,
      Value<bool> isReturn,
      Value<int?> originalPurchaseId,
      Value<bool> isActive,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$PurchasesTableReferences
    extends BaseReferences<_$AppDatabase, $PurchasesTable, Purchase> {
  $$PurchasesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SuppliersTable _supplierIdTable(_$AppDatabase db) =>
      db.suppliers.createAlias('purchase__supplier_id__supplier__id');

  $$SuppliersTableProcessedTableManager get supplierId {
    final $_column = $_itemColumn<int>('supplier_id')!;

    final manager = $$SuppliersTableTableManager(
      $_db,
      $_db.suppliers,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_supplierIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$PurchaseItemsTable, List<PurchaseItem>>
  _purchaseItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.purchaseItems,
    aliasName: 'purchase__id__purchase_item__purchase_id',
  );

  $$PurchaseItemsTableProcessedTableManager get purchaseItemsRefs {
    final manager = $$PurchaseItemsTableTableManager(
      $_db,
      $_db.purchaseItems,
    ).filter((f) => f.purchaseId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_purchaseItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $InventoryTransactionsTable,
    List<InventoryTransaction>
  >
  _inventoryTransactionsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.inventoryTransactions,
        aliasName: 'purchase__id__inventory_transaction__purchase_id',
      );

  $$InventoryTransactionsTableProcessedTableManager
  get inventoryTransactionsRefs {
    final manager = $$InventoryTransactionsTableTableManager(
      $_db,
      $_db.inventoryTransactions,
    ).filter((f) => f.purchaseId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _inventoryTransactionsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PurchasesTableFilterComposer
    extends Composer<_$AppDatabase, $PurchasesTable> {
  $$PurchasesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get purchaseNumber => $composableBuilder(
    column: $table.purchaseNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get purchaseDate => $composableBuilder(
    column: $table.purchaseDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get invoiceNumber => $composableBuilder(
    column: $table.invoiceNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get subtotal => $composableBuilder(
    column: $table.subtotal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get discount => $composableBuilder(
    column: $table.discount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get tax => $composableBuilder(
    column: $table.tax,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get total => $composableBuilder(
    column: $table.total,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get paidAmount => $composableBuilder(
    column: $table.paidAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dueAmount => $composableBuilder(
    column: $table.dueAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get paymentStatus => $composableBuilder(
    column: $table.paymentStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get paymentMethod => $composableBuilder(
    column: $table.paymentMethod,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isReturn => $composableBuilder(
    column: $table.isReturn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get originalPurchaseId => $composableBuilder(
    column: $table.originalPurchaseId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$SuppliersTableFilterComposer get supplierId {
    final $$SuppliersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.supplierId,
      referencedTable: $db.suppliers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SuppliersTableFilterComposer(
            $db: $db,
            $table: $db.suppliers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> purchaseItemsRefs(
    Expression<bool> Function($$PurchaseItemsTableFilterComposer f) f,
  ) {
    final $$PurchaseItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.purchaseItems,
      getReferencedColumn: (t) => t.purchaseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PurchaseItemsTableFilterComposer(
            $db: $db,
            $table: $db.purchaseItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> inventoryTransactionsRefs(
    Expression<bool> Function($$InventoryTransactionsTableFilterComposer f) f,
  ) {
    final $$InventoryTransactionsTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.inventoryTransactions,
          getReferencedColumn: (t) => t.purchaseId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$InventoryTransactionsTableFilterComposer(
                $db: $db,
                $table: $db.inventoryTransactions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$PurchasesTableOrderingComposer
    extends Composer<_$AppDatabase, $PurchasesTable> {
  $$PurchasesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get purchaseNumber => $composableBuilder(
    column: $table.purchaseNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get purchaseDate => $composableBuilder(
    column: $table.purchaseDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get invoiceNumber => $composableBuilder(
    column: $table.invoiceNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get subtotal => $composableBuilder(
    column: $table.subtotal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get discount => $composableBuilder(
    column: $table.discount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get tax => $composableBuilder(
    column: $table.tax,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get total => $composableBuilder(
    column: $table.total,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get paidAmount => $composableBuilder(
    column: $table.paidAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dueAmount => $composableBuilder(
    column: $table.dueAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get paymentStatus => $composableBuilder(
    column: $table.paymentStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get paymentMethod => $composableBuilder(
    column: $table.paymentMethod,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isReturn => $composableBuilder(
    column: $table.isReturn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get originalPurchaseId => $composableBuilder(
    column: $table.originalPurchaseId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$SuppliersTableOrderingComposer get supplierId {
    final $$SuppliersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.supplierId,
      referencedTable: $db.suppliers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SuppliersTableOrderingComposer(
            $db: $db,
            $table: $db.suppliers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PurchasesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PurchasesTable> {
  $$PurchasesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get purchaseNumber => $composableBuilder(
    column: $table.purchaseNumber,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get purchaseDate => $composableBuilder(
    column: $table.purchaseDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get invoiceNumber => $composableBuilder(
    column: $table.invoiceNumber,
    builder: (column) => column,
  );

  GeneratedColumn<int> get subtotal =>
      $composableBuilder(column: $table.subtotal, builder: (column) => column);

  GeneratedColumn<int> get discount =>
      $composableBuilder(column: $table.discount, builder: (column) => column);

  GeneratedColumn<int> get tax =>
      $composableBuilder(column: $table.tax, builder: (column) => column);

  GeneratedColumn<int> get total =>
      $composableBuilder(column: $table.total, builder: (column) => column);

  GeneratedColumn<int> get paidAmount => $composableBuilder(
    column: $table.paidAmount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get dueAmount =>
      $composableBuilder(column: $table.dueAmount, builder: (column) => column);

  GeneratedColumn<String> get paymentStatus => $composableBuilder(
    column: $table.paymentStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get paymentMethod => $composableBuilder(
    column: $table.paymentMethod,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<bool> get isReturn =>
      $composableBuilder(column: $table.isReturn, builder: (column) => column);

  GeneratedColumn<int> get originalPurchaseId => $composableBuilder(
    column: $table.originalPurchaseId,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$SuppliersTableAnnotationComposer get supplierId {
    final $$SuppliersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.supplierId,
      referencedTable: $db.suppliers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SuppliersTableAnnotationComposer(
            $db: $db,
            $table: $db.suppliers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> purchaseItemsRefs<T extends Object>(
    Expression<T> Function($$PurchaseItemsTableAnnotationComposer a) f,
  ) {
    final $$PurchaseItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.purchaseItems,
      getReferencedColumn: (t) => t.purchaseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PurchaseItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.purchaseItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> inventoryTransactionsRefs<T extends Object>(
    Expression<T> Function($$InventoryTransactionsTableAnnotationComposer a) f,
  ) {
    final $$InventoryTransactionsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.inventoryTransactions,
          getReferencedColumn: (t) => t.purchaseId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$InventoryTransactionsTableAnnotationComposer(
                $db: $db,
                $table: $db.inventoryTransactions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$PurchasesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PurchasesTable,
          Purchase,
          $$PurchasesTableFilterComposer,
          $$PurchasesTableOrderingComposer,
          $$PurchasesTableAnnotationComposer,
          $$PurchasesTableCreateCompanionBuilder,
          $$PurchasesTableUpdateCompanionBuilder,
          (Purchase, $$PurchasesTableReferences),
          Purchase,
          PrefetchHooks Function({
            bool supplierId,
            bool purchaseItemsRefs,
            bool inventoryTransactionsRefs,
          })
        > {
  $$PurchasesTableTableManager(_$AppDatabase db, $PurchasesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PurchasesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PurchasesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PurchasesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> purchaseNumber = const Value.absent(),
                Value<int> supplierId = const Value.absent(),
                Value<DateTime> purchaseDate = const Value.absent(),
                Value<String?> invoiceNumber = const Value.absent(),
                Value<int> subtotal = const Value.absent(),
                Value<int> discount = const Value.absent(),
                Value<int> tax = const Value.absent(),
                Value<int> total = const Value.absent(),
                Value<int> paidAmount = const Value.absent(),
                Value<int> dueAmount = const Value.absent(),
                Value<String> paymentStatus = const Value.absent(),
                Value<String?> paymentMethod = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<bool> isReturn = const Value.absent(),
                Value<int?> originalPurchaseId = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => PurchasesCompanion(
                id: id,
                purchaseNumber: purchaseNumber,
                supplierId: supplierId,
                purchaseDate: purchaseDate,
                invoiceNumber: invoiceNumber,
                subtotal: subtotal,
                discount: discount,
                tax: tax,
                total: total,
                paidAmount: paidAmount,
                dueAmount: dueAmount,
                paymentStatus: paymentStatus,
                paymentMethod: paymentMethod,
                notes: notes,
                isReturn: isReturn,
                originalPurchaseId: originalPurchaseId,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String purchaseNumber,
                required int supplierId,
                required DateTime purchaseDate,
                Value<String?> invoiceNumber = const Value.absent(),
                Value<int> subtotal = const Value.absent(),
                Value<int> discount = const Value.absent(),
                Value<int> tax = const Value.absent(),
                Value<int> total = const Value.absent(),
                Value<int> paidAmount = const Value.absent(),
                Value<int> dueAmount = const Value.absent(),
                Value<String> paymentStatus = const Value.absent(),
                Value<String?> paymentMethod = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<bool> isReturn = const Value.absent(),
                Value<int?> originalPurchaseId = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => PurchasesCompanion.insert(
                id: id,
                purchaseNumber: purchaseNumber,
                supplierId: supplierId,
                purchaseDate: purchaseDate,
                invoiceNumber: invoiceNumber,
                subtotal: subtotal,
                discount: discount,
                tax: tax,
                total: total,
                paidAmount: paidAmount,
                dueAmount: dueAmount,
                paymentStatus: paymentStatus,
                paymentMethod: paymentMethod,
                notes: notes,
                isReturn: isReturn,
                originalPurchaseId: originalPurchaseId,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PurchasesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                supplierId = false,
                purchaseItemsRefs = false,
                inventoryTransactionsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (purchaseItemsRefs) db.purchaseItems,
                    if (inventoryTransactionsRefs) db.inventoryTransactions,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (supplierId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.supplierId,
                                    referencedTable: $$PurchasesTableReferences
                                        ._supplierIdTable(db),
                                    referencedColumn: $$PurchasesTableReferences
                                        ._supplierIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (purchaseItemsRefs)
                        await $_getPrefetchedData<
                          Purchase,
                          $PurchasesTable,
                          PurchaseItem
                        >(
                          currentTable: table,
                          referencedTable: $$PurchasesTableReferences
                              ._purchaseItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PurchasesTableReferences(
                                db,
                                table,
                                p0,
                              ).purchaseItemsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.purchaseId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (inventoryTransactionsRefs)
                        await $_getPrefetchedData<
                          Purchase,
                          $PurchasesTable,
                          InventoryTransaction
                        >(
                          currentTable: table,
                          referencedTable: $$PurchasesTableReferences
                              ._inventoryTransactionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PurchasesTableReferences(
                                db,
                                table,
                                p0,
                              ).inventoryTransactionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.purchaseId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$PurchasesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PurchasesTable,
      Purchase,
      $$PurchasesTableFilterComposer,
      $$PurchasesTableOrderingComposer,
      $$PurchasesTableAnnotationComposer,
      $$PurchasesTableCreateCompanionBuilder,
      $$PurchasesTableUpdateCompanionBuilder,
      (Purchase, $$PurchasesTableReferences),
      Purchase,
      PrefetchHooks Function({
        bool supplierId,
        bool purchaseItemsRefs,
        bool inventoryTransactionsRefs,
      })
    >;
typedef $$PurchaseItemsTableCreateCompanionBuilder =
    PurchaseItemsCompanion Function({
      Value<int> id,
      required int purchaseId,
      required int productId,
      Value<int?> variantId,
      required int quantity,
      required int unitId,
      required int purchasePrice,
      Value<int> discount,
      Value<double> taxRate,
      Value<int> taxAmount,
      Value<int> lineTotal,
      Value<int> returnedQuantity,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$PurchaseItemsTableUpdateCompanionBuilder =
    PurchaseItemsCompanion Function({
      Value<int> id,
      Value<int> purchaseId,
      Value<int> productId,
      Value<int?> variantId,
      Value<int> quantity,
      Value<int> unitId,
      Value<int> purchasePrice,
      Value<int> discount,
      Value<double> taxRate,
      Value<int> taxAmount,
      Value<int> lineTotal,
      Value<int> returnedQuantity,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$PurchaseItemsTableReferences
    extends BaseReferences<_$AppDatabase, $PurchaseItemsTable, PurchaseItem> {
  $$PurchaseItemsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $PurchasesTable _purchaseIdTable(_$AppDatabase db) =>
      db.purchases.createAlias('purchase_item__purchase_id__purchase__id');

  $$PurchasesTableProcessedTableManager get purchaseId {
    final $_column = $_itemColumn<int>('purchase_id')!;

    final manager = $$PurchasesTableTableManager(
      $_db,
      $_db.purchases,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_purchaseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ProductsTable _productIdTable(_$AppDatabase db) =>
      db.products.createAlias('purchase_item__product_id__product__id');

  $$ProductsTableProcessedTableManager get productId {
    final $_column = $_itemColumn<int>('product_id')!;

    final manager = $$ProductsTableTableManager(
      $_db,
      $_db.products,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_productIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ProductVariantsTable _variantIdTable(_$AppDatabase db) => db
      .productVariants
      .createAlias('purchase_item__variant_id__product_variant__id');

  $$ProductVariantsTableProcessedTableManager? get variantId {
    final $_column = $_itemColumn<int>('variant_id');
    if ($_column == null) return null;
    final manager = $$ProductVariantsTableTableManager(
      $_db,
      $_db.productVariants,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_variantIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $UnitsTable _unitIdTable(_$AppDatabase db) =>
      db.units.createAlias('purchase_item__unit_id__unit__id');

  $$UnitsTableProcessedTableManager get unitId {
    final $_column = $_itemColumn<int>('unit_id')!;

    final manager = $$UnitsTableTableManager(
      $_db,
      $_db.units,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_unitIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PurchaseItemsTableFilterComposer
    extends Composer<_$AppDatabase, $PurchaseItemsTable> {
  $$PurchaseItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get purchasePrice => $composableBuilder(
    column: $table.purchasePrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get discount => $composableBuilder(
    column: $table.discount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get taxRate => $composableBuilder(
    column: $table.taxRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get taxAmount => $composableBuilder(
    column: $table.taxAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lineTotal => $composableBuilder(
    column: $table.lineTotal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get returnedQuantity => $composableBuilder(
    column: $table.returnedQuantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$PurchasesTableFilterComposer get purchaseId {
    final $$PurchasesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.purchaseId,
      referencedTable: $db.purchases,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PurchasesTableFilterComposer(
            $db: $db,
            $table: $db.purchases,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProductsTableFilterComposer get productId {
    final $$ProductsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableFilterComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProductVariantsTableFilterComposer get variantId {
    final $$ProductVariantsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.variantId,
      referencedTable: $db.productVariants,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductVariantsTableFilterComposer(
            $db: $db,
            $table: $db.productVariants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UnitsTableFilterComposer get unitId {
    final $$UnitsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.unitId,
      referencedTable: $db.units,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UnitsTableFilterComposer(
            $db: $db,
            $table: $db.units,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PurchaseItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $PurchaseItemsTable> {
  $$PurchaseItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get purchasePrice => $composableBuilder(
    column: $table.purchasePrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get discount => $composableBuilder(
    column: $table.discount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get taxRate => $composableBuilder(
    column: $table.taxRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get taxAmount => $composableBuilder(
    column: $table.taxAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lineTotal => $composableBuilder(
    column: $table.lineTotal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get returnedQuantity => $composableBuilder(
    column: $table.returnedQuantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$PurchasesTableOrderingComposer get purchaseId {
    final $$PurchasesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.purchaseId,
      referencedTable: $db.purchases,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PurchasesTableOrderingComposer(
            $db: $db,
            $table: $db.purchases,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProductsTableOrderingComposer get productId {
    final $$ProductsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableOrderingComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProductVariantsTableOrderingComposer get variantId {
    final $$ProductVariantsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.variantId,
      referencedTable: $db.productVariants,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductVariantsTableOrderingComposer(
            $db: $db,
            $table: $db.productVariants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UnitsTableOrderingComposer get unitId {
    final $$UnitsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.unitId,
      referencedTable: $db.units,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UnitsTableOrderingComposer(
            $db: $db,
            $table: $db.units,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PurchaseItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PurchaseItemsTable> {
  $$PurchaseItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<int> get purchasePrice => $composableBuilder(
    column: $table.purchasePrice,
    builder: (column) => column,
  );

  GeneratedColumn<int> get discount =>
      $composableBuilder(column: $table.discount, builder: (column) => column);

  GeneratedColumn<double> get taxRate =>
      $composableBuilder(column: $table.taxRate, builder: (column) => column);

  GeneratedColumn<int> get taxAmount =>
      $composableBuilder(column: $table.taxAmount, builder: (column) => column);

  GeneratedColumn<int> get lineTotal =>
      $composableBuilder(column: $table.lineTotal, builder: (column) => column);

  GeneratedColumn<int> get returnedQuantity => $composableBuilder(
    column: $table.returnedQuantity,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$PurchasesTableAnnotationComposer get purchaseId {
    final $$PurchasesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.purchaseId,
      referencedTable: $db.purchases,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PurchasesTableAnnotationComposer(
            $db: $db,
            $table: $db.purchases,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProductsTableAnnotationComposer get productId {
    final $$ProductsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableAnnotationComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProductVariantsTableAnnotationComposer get variantId {
    final $$ProductVariantsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.variantId,
      referencedTable: $db.productVariants,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductVariantsTableAnnotationComposer(
            $db: $db,
            $table: $db.productVariants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UnitsTableAnnotationComposer get unitId {
    final $$UnitsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.unitId,
      referencedTable: $db.units,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UnitsTableAnnotationComposer(
            $db: $db,
            $table: $db.units,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PurchaseItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PurchaseItemsTable,
          PurchaseItem,
          $$PurchaseItemsTableFilterComposer,
          $$PurchaseItemsTableOrderingComposer,
          $$PurchaseItemsTableAnnotationComposer,
          $$PurchaseItemsTableCreateCompanionBuilder,
          $$PurchaseItemsTableUpdateCompanionBuilder,
          (PurchaseItem, $$PurchaseItemsTableReferences),
          PurchaseItem,
          PrefetchHooks Function({
            bool purchaseId,
            bool productId,
            bool variantId,
            bool unitId,
          })
        > {
  $$PurchaseItemsTableTableManager(_$AppDatabase db, $PurchaseItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PurchaseItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PurchaseItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PurchaseItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> purchaseId = const Value.absent(),
                Value<int> productId = const Value.absent(),
                Value<int?> variantId = const Value.absent(),
                Value<int> quantity = const Value.absent(),
                Value<int> unitId = const Value.absent(),
                Value<int> purchasePrice = const Value.absent(),
                Value<int> discount = const Value.absent(),
                Value<double> taxRate = const Value.absent(),
                Value<int> taxAmount = const Value.absent(),
                Value<int> lineTotal = const Value.absent(),
                Value<int> returnedQuantity = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => PurchaseItemsCompanion(
                id: id,
                purchaseId: purchaseId,
                productId: productId,
                variantId: variantId,
                quantity: quantity,
                unitId: unitId,
                purchasePrice: purchasePrice,
                discount: discount,
                taxRate: taxRate,
                taxAmount: taxAmount,
                lineTotal: lineTotal,
                returnedQuantity: returnedQuantity,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int purchaseId,
                required int productId,
                Value<int?> variantId = const Value.absent(),
                required int quantity,
                required int unitId,
                required int purchasePrice,
                Value<int> discount = const Value.absent(),
                Value<double> taxRate = const Value.absent(),
                Value<int> taxAmount = const Value.absent(),
                Value<int> lineTotal = const Value.absent(),
                Value<int> returnedQuantity = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => PurchaseItemsCompanion.insert(
                id: id,
                purchaseId: purchaseId,
                productId: productId,
                variantId: variantId,
                quantity: quantity,
                unitId: unitId,
                purchasePrice: purchasePrice,
                discount: discount,
                taxRate: taxRate,
                taxAmount: taxAmount,
                lineTotal: lineTotal,
                returnedQuantity: returnedQuantity,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PurchaseItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                purchaseId = false,
                productId = false,
                variantId = false,
                unitId = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (purchaseId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.purchaseId,
                                    referencedTable:
                                        $$PurchaseItemsTableReferences
                                            ._purchaseIdTable(db),
                                    referencedColumn:
                                        $$PurchaseItemsTableReferences
                                            ._purchaseIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (productId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.productId,
                                    referencedTable:
                                        $$PurchaseItemsTableReferences
                                            ._productIdTable(db),
                                    referencedColumn:
                                        $$PurchaseItemsTableReferences
                                            ._productIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (variantId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.variantId,
                                    referencedTable:
                                        $$PurchaseItemsTableReferences
                                            ._variantIdTable(db),
                                    referencedColumn:
                                        $$PurchaseItemsTableReferences
                                            ._variantIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (unitId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.unitId,
                                    referencedTable:
                                        $$PurchaseItemsTableReferences
                                            ._unitIdTable(db),
                                    referencedColumn:
                                        $$PurchaseItemsTableReferences
                                            ._unitIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$PurchaseItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PurchaseItemsTable,
      PurchaseItem,
      $$PurchaseItemsTableFilterComposer,
      $$PurchaseItemsTableOrderingComposer,
      $$PurchaseItemsTableAnnotationComposer,
      $$PurchaseItemsTableCreateCompanionBuilder,
      $$PurchaseItemsTableUpdateCompanionBuilder,
      (PurchaseItem, $$PurchaseItemsTableReferences),
      PurchaseItem,
      PrefetchHooks Function({
        bool purchaseId,
        bool productId,
        bool variantId,
        bool unitId,
      })
    >;
typedef $$InventoryTransactionsTableCreateCompanionBuilder =
    InventoryTransactionsCompanion Function({
      Value<int> id,
      required int productId,
      Value<int?> variantId,
      required String transactionType,
      required int quantity,
      Value<int?> purchaseId,
      required DateTime transactionDate,
      Value<String?> referenceNumber,
      Value<String?> notes,
      Value<DateTime> createdAt,
    });
typedef $$InventoryTransactionsTableUpdateCompanionBuilder =
    InventoryTransactionsCompanion Function({
      Value<int> id,
      Value<int> productId,
      Value<int?> variantId,
      Value<String> transactionType,
      Value<int> quantity,
      Value<int?> purchaseId,
      Value<DateTime> transactionDate,
      Value<String?> referenceNumber,
      Value<String?> notes,
      Value<DateTime> createdAt,
    });

final class $$InventoryTransactionsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $InventoryTransactionsTable,
          InventoryTransaction
        > {
  $$InventoryTransactionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ProductsTable _productIdTable(_$AppDatabase db) =>
      db.products.createAlias('inventory_transaction__product_id__product__id');

  $$ProductsTableProcessedTableManager get productId {
    final $_column = $_itemColumn<int>('product_id')!;

    final manager = $$ProductsTableTableManager(
      $_db,
      $_db.products,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_productIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ProductVariantsTable _variantIdTable(_$AppDatabase db) => db
      .productVariants
      .createAlias('inventory_transaction__variant_id__product_variant__id');

  $$ProductVariantsTableProcessedTableManager? get variantId {
    final $_column = $_itemColumn<int>('variant_id');
    if ($_column == null) return null;
    final manager = $$ProductVariantsTableTableManager(
      $_db,
      $_db.productVariants,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_variantIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $PurchasesTable _purchaseIdTable(_$AppDatabase db) => db.purchases
      .createAlias('inventory_transaction__purchase_id__purchase__id');

  $$PurchasesTableProcessedTableManager? get purchaseId {
    final $_column = $_itemColumn<int>('purchase_id');
    if ($_column == null) return null;
    final manager = $$PurchasesTableTableManager(
      $_db,
      $_db.purchases,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_purchaseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$InventoryTransactionsTableFilterComposer
    extends Composer<_$AppDatabase, $InventoryTransactionsTable> {
  $$InventoryTransactionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get transactionType => $composableBuilder(
    column: $table.transactionType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get transactionDate => $composableBuilder(
    column: $table.transactionDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get referenceNumber => $composableBuilder(
    column: $table.referenceNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ProductsTableFilterComposer get productId {
    final $$ProductsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableFilterComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProductVariantsTableFilterComposer get variantId {
    final $$ProductVariantsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.variantId,
      referencedTable: $db.productVariants,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductVariantsTableFilterComposer(
            $db: $db,
            $table: $db.productVariants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PurchasesTableFilterComposer get purchaseId {
    final $$PurchasesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.purchaseId,
      referencedTable: $db.purchases,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PurchasesTableFilterComposer(
            $db: $db,
            $table: $db.purchases,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$InventoryTransactionsTableOrderingComposer
    extends Composer<_$AppDatabase, $InventoryTransactionsTable> {
  $$InventoryTransactionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get transactionType => $composableBuilder(
    column: $table.transactionType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get transactionDate => $composableBuilder(
    column: $table.transactionDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get referenceNumber => $composableBuilder(
    column: $table.referenceNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProductsTableOrderingComposer get productId {
    final $$ProductsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableOrderingComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProductVariantsTableOrderingComposer get variantId {
    final $$ProductVariantsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.variantId,
      referencedTable: $db.productVariants,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductVariantsTableOrderingComposer(
            $db: $db,
            $table: $db.productVariants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PurchasesTableOrderingComposer get purchaseId {
    final $$PurchasesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.purchaseId,
      referencedTable: $db.purchases,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PurchasesTableOrderingComposer(
            $db: $db,
            $table: $db.purchases,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$InventoryTransactionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $InventoryTransactionsTable> {
  $$InventoryTransactionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get transactionType => $composableBuilder(
    column: $table.transactionType,
    builder: (column) => column,
  );

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<DateTime> get transactionDate => $composableBuilder(
    column: $table.transactionDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get referenceNumber => $composableBuilder(
    column: $table.referenceNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$ProductsTableAnnotationComposer get productId {
    final $$ProductsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableAnnotationComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProductVariantsTableAnnotationComposer get variantId {
    final $$ProductVariantsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.variantId,
      referencedTable: $db.productVariants,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductVariantsTableAnnotationComposer(
            $db: $db,
            $table: $db.productVariants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PurchasesTableAnnotationComposer get purchaseId {
    final $$PurchasesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.purchaseId,
      referencedTable: $db.purchases,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PurchasesTableAnnotationComposer(
            $db: $db,
            $table: $db.purchases,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$InventoryTransactionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $InventoryTransactionsTable,
          InventoryTransaction,
          $$InventoryTransactionsTableFilterComposer,
          $$InventoryTransactionsTableOrderingComposer,
          $$InventoryTransactionsTableAnnotationComposer,
          $$InventoryTransactionsTableCreateCompanionBuilder,
          $$InventoryTransactionsTableUpdateCompanionBuilder,
          (InventoryTransaction, $$InventoryTransactionsTableReferences),
          InventoryTransaction,
          PrefetchHooks Function({
            bool productId,
            bool variantId,
            bool purchaseId,
          })
        > {
  $$InventoryTransactionsTableTableManager(
    _$AppDatabase db,
    $InventoryTransactionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InventoryTransactionsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$InventoryTransactionsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$InventoryTransactionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> productId = const Value.absent(),
                Value<int?> variantId = const Value.absent(),
                Value<String> transactionType = const Value.absent(),
                Value<int> quantity = const Value.absent(),
                Value<int?> purchaseId = const Value.absent(),
                Value<DateTime> transactionDate = const Value.absent(),
                Value<String?> referenceNumber = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => InventoryTransactionsCompanion(
                id: id,
                productId: productId,
                variantId: variantId,
                transactionType: transactionType,
                quantity: quantity,
                purchaseId: purchaseId,
                transactionDate: transactionDate,
                referenceNumber: referenceNumber,
                notes: notes,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int productId,
                Value<int?> variantId = const Value.absent(),
                required String transactionType,
                required int quantity,
                Value<int?> purchaseId = const Value.absent(),
                required DateTime transactionDate,
                Value<String?> referenceNumber = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => InventoryTransactionsCompanion.insert(
                id: id,
                productId: productId,
                variantId: variantId,
                transactionType: transactionType,
                quantity: quantity,
                purchaseId: purchaseId,
                transactionDate: transactionDate,
                referenceNumber: referenceNumber,
                notes: notes,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$InventoryTransactionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({productId = false, variantId = false, purchaseId = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (productId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.productId,
                                    referencedTable:
                                        $$InventoryTransactionsTableReferences
                                            ._productIdTable(db),
                                    referencedColumn:
                                        $$InventoryTransactionsTableReferences
                                            ._productIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (variantId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.variantId,
                                    referencedTable:
                                        $$InventoryTransactionsTableReferences
                                            ._variantIdTable(db),
                                    referencedColumn:
                                        $$InventoryTransactionsTableReferences
                                            ._variantIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (purchaseId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.purchaseId,
                                    referencedTable:
                                        $$InventoryTransactionsTableReferences
                                            ._purchaseIdTable(db),
                                    referencedColumn:
                                        $$InventoryTransactionsTableReferences
                                            ._purchaseIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$InventoryTransactionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $InventoryTransactionsTable,
      InventoryTransaction,
      $$InventoryTransactionsTableFilterComposer,
      $$InventoryTransactionsTableOrderingComposer,
      $$InventoryTransactionsTableAnnotationComposer,
      $$InventoryTransactionsTableCreateCompanionBuilder,
      $$InventoryTransactionsTableUpdateCompanionBuilder,
      (InventoryTransaction, $$InventoryTransactionsTableReferences),
      InventoryTransaction,
      PrefetchHooks Function({bool productId, bool variantId, bool purchaseId})
    >;
typedef $$CurrentStocksTableCreateCompanionBuilder =
    CurrentStocksCompanion Function({
      Value<int> id,
      required int productId,
      Value<int?> variantId,
      Value<int> quantity,
      Value<DateTime> updatedAt,
    });
typedef $$CurrentStocksTableUpdateCompanionBuilder =
    CurrentStocksCompanion Function({
      Value<int> id,
      Value<int> productId,
      Value<int?> variantId,
      Value<int> quantity,
      Value<DateTime> updatedAt,
    });

final class $$CurrentStocksTableReferences
    extends BaseReferences<_$AppDatabase, $CurrentStocksTable, CurrentStock> {
  $$CurrentStocksTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ProductsTable _productIdTable(_$AppDatabase db) =>
      db.products.createAlias('current_stock__product_id__product__id');

  $$ProductsTableProcessedTableManager get productId {
    final $_column = $_itemColumn<int>('product_id')!;

    final manager = $$ProductsTableTableManager(
      $_db,
      $_db.products,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_productIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ProductVariantsTable _variantIdTable(_$AppDatabase db) => db
      .productVariants
      .createAlias('current_stock__variant_id__product_variant__id');

  $$ProductVariantsTableProcessedTableManager? get variantId {
    final $_column = $_itemColumn<int>('variant_id');
    if ($_column == null) return null;
    final manager = $$ProductVariantsTableTableManager(
      $_db,
      $_db.productVariants,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_variantIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CurrentStocksTableFilterComposer
    extends Composer<_$AppDatabase, $CurrentStocksTable> {
  $$CurrentStocksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ProductsTableFilterComposer get productId {
    final $$ProductsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableFilterComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProductVariantsTableFilterComposer get variantId {
    final $$ProductVariantsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.variantId,
      referencedTable: $db.productVariants,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductVariantsTableFilterComposer(
            $db: $db,
            $table: $db.productVariants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CurrentStocksTableOrderingComposer
    extends Composer<_$AppDatabase, $CurrentStocksTable> {
  $$CurrentStocksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProductsTableOrderingComposer get productId {
    final $$ProductsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableOrderingComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProductVariantsTableOrderingComposer get variantId {
    final $$ProductVariantsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.variantId,
      referencedTable: $db.productVariants,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductVariantsTableOrderingComposer(
            $db: $db,
            $table: $db.productVariants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CurrentStocksTableAnnotationComposer
    extends Composer<_$AppDatabase, $CurrentStocksTable> {
  $$CurrentStocksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$ProductsTableAnnotationComposer get productId {
    final $$ProductsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableAnnotationComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProductVariantsTableAnnotationComposer get variantId {
    final $$ProductVariantsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.variantId,
      referencedTable: $db.productVariants,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductVariantsTableAnnotationComposer(
            $db: $db,
            $table: $db.productVariants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CurrentStocksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CurrentStocksTable,
          CurrentStock,
          $$CurrentStocksTableFilterComposer,
          $$CurrentStocksTableOrderingComposer,
          $$CurrentStocksTableAnnotationComposer,
          $$CurrentStocksTableCreateCompanionBuilder,
          $$CurrentStocksTableUpdateCompanionBuilder,
          (CurrentStock, $$CurrentStocksTableReferences),
          CurrentStock,
          PrefetchHooks Function({bool productId, bool variantId})
        > {
  $$CurrentStocksTableTableManager(_$AppDatabase db, $CurrentStocksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CurrentStocksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CurrentStocksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CurrentStocksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> productId = const Value.absent(),
                Value<int?> variantId = const Value.absent(),
                Value<int> quantity = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => CurrentStocksCompanion(
                id: id,
                productId: productId,
                variantId: variantId,
                quantity: quantity,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int productId,
                Value<int?> variantId = const Value.absent(),
                Value<int> quantity = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => CurrentStocksCompanion.insert(
                id: id,
                productId: productId,
                variantId: variantId,
                quantity: quantity,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CurrentStocksTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({productId = false, variantId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (productId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.productId,
                                referencedTable: $$CurrentStocksTableReferences
                                    ._productIdTable(db),
                                referencedColumn: $$CurrentStocksTableReferences
                                    ._productIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (variantId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.variantId,
                                referencedTable: $$CurrentStocksTableReferences
                                    ._variantIdTable(db),
                                referencedColumn: $$CurrentStocksTableReferences
                                    ._variantIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$CurrentStocksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CurrentStocksTable,
      CurrentStock,
      $$CurrentStocksTableFilterComposer,
      $$CurrentStocksTableOrderingComposer,
      $$CurrentStocksTableAnnotationComposer,
      $$CurrentStocksTableCreateCompanionBuilder,
      $$CurrentStocksTableUpdateCompanionBuilder,
      (CurrentStock, $$CurrentStocksTableReferences),
      CurrentStock,
      PrefetchHooks Function({bool productId, bool variantId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CompanySettingsTableTableTableManager get companySettingsTable =>
      $$CompanySettingsTableTableTableManager(_db, _db.companySettingsTable);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db, _db.categories);
  $$SubCategoriesTableTableManager get subCategories =>
      $$SubCategoriesTableTableManager(_db, _db.subCategories);
  $$BrandsTableTableManager get brands =>
      $$BrandsTableTableManager(_db, _db.brands);
  $$UnitsTableTableManager get units =>
      $$UnitsTableTableManager(_db, _db.units);
  $$UomConversionsTableTableManager get uomConversions =>
      $$UomConversionsTableTableManager(_db, _db.uomConversions);
  $$TaxCategoriesTableTableManager get taxCategories =>
      $$TaxCategoriesTableTableManager(_db, _db.taxCategories);
  $$TaxTypesTableTableManager get taxTypes =>
      $$TaxTypesTableTableManager(_db, _db.taxTypes);
  $$TaxCategoryRatesTableTableManager get taxCategoryRates =>
      $$TaxCategoryRatesTableTableManager(_db, _db.taxCategoryRates);
  $$CustomersTableTableManager get customers =>
      $$CustomersTableTableManager(_db, _db.customers);
  $$SuppliersTableTableManager get suppliers =>
      $$SuppliersTableTableManager(_db, _db.suppliers);
  $$ProductsTableTableManager get products =>
      $$ProductsTableTableManager(_db, _db.products);
  $$ProductVariantsTableTableManager get productVariants =>
      $$ProductVariantsTableTableManager(_db, _db.productVariants);
  $$ProductUomsTableTableManager get productUoms =>
      $$ProductUomsTableTableManager(_db, _db.productUoms);
  $$DocumentNumberSequencesTableTableManager get documentNumberSequences =>
      $$DocumentNumberSequencesTableTableManager(
        _db,
        _db.documentNumberSequences,
      );
  $$PurchasesTableTableManager get purchases =>
      $$PurchasesTableTableManager(_db, _db.purchases);
  $$PurchaseItemsTableTableManager get purchaseItems =>
      $$PurchaseItemsTableTableManager(_db, _db.purchaseItems);
  $$InventoryTransactionsTableTableManager get inventoryTransactions =>
      $$InventoryTransactionsTableTableManager(_db, _db.inventoryTransactions);
  $$CurrentStocksTableTableManager get currentStocks =>
      $$CurrentStocksTableTableManager(_db, _db.currentStocks);
}
