import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../core/database/exceptions/database_exceptions.dart';
import '../../../../shared/utils/form_focus_controller.dart';
import '../../../../shared/widgets/breadcrumbs.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../domain/company_settings_enums.dart';
import '../../domain/company_settings_exceptions.dart';
import '../../domain/entities/company_settings.dart';
import '../../domain/entities/company_settings_draft.dart';
import '../../services/company_banner_storage.dart';
import '../../services/company_logo_picker.dart';
import '../../services/company_logo_storage.dart';
import '../../services/company_settings_service.dart';
import '../../services/company_settings_validator.dart';
import '../widgets/bank_details_section.dart';
import '../widgets/business_address_section.dart';
import '../widgets/company_information_section.dart';
import '../widgets/company_logo_section.dart';
import '../widgets/company_profile_view.dart';
import '../widgets/financial_settings_section.dart';
import '../widgets/settings_section_card.dart';
import '../widgets/settings_skeleton.dart';
import '../widgets/tax_billing_section.dart';

/// The Company Settings page — displays the company profile view and offers
/// an edit form for modifying settings.
///
/// There is exactly one company configuration (id `1`), loaded through the
/// cached [CompanySettingsService] and saved atomically.
class CompanySettingsPage extends StatefulWidget {
  const CompanySettingsPage({
    super.key,
    this.service,
    this.logoPicker,
    this.logoStorage,
    this.bannerStorage,
  });

  /// Test seam: the application-layer service (defaults to the real one).
  final CompanySettingsService? service;

  /// Test seam: the logo file picker (defaults to the native dialog).
  final CompanyLogoPicker? logoPicker;

  /// Test seam: the logo file storage (defaults to the app support dir).
  final CompanyLogoStorage? logoStorage;

  /// Test seam: the banner file storage (defaults to the app support dir).
  final CompanyBannerStorage? bannerStorage;

  @override
  State<CompanySettingsPage> createState() => _CompanySettingsPageState();
}

class _CompanySettingsPageState extends State<CompanySettingsPage> {
  static const _fieldOrder = [
    'businessName',
    'businessType',
    'gstRegistered',
    'gstin',
    'pan',
    'cin',
    'phone',
    'email',
    'website',
    'addressLine1',
    'addressLine2',
    'city',
    'state',
    'pincode',
    'country',
    'taxType',
    'invoicePrefix',
    'invoiceStartNumber',
    'financialYearStart',
    'currencyCode',
    'currencySymbol',
    'decimalPlaces',
    'bankName',
    'bankAccountName',
    'bankAccountNumber',
    'bankIfsc',
    'bankBranch',
    'upiId',
    'save',
  ];

  late final CompanySettingsService _service;
  late final CompanyLogoPicker _logoPicker;
  late final CompanyLogoStorage _logoStorage;
  late final CompanyBannerStorage _bannerStorage;
  late final FormFocusController _focusController;

  bool _loading = true;
  bool _loadFailed = false;
  bool _saving = false;
  bool _isEditing = false;
  Map<String, String?> _errors = const {};

  // Company information.
  late final TextEditingController _businessNameController;
  late final TextEditingController _gstinController;
  late final TextEditingController _panController;
  late final TextEditingController _cinController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  late final TextEditingController _websiteController;
  late BusinessType _businessType;
  late bool _gstRegistered;

  // Business address.
  late final TextEditingController _addressLine1Controller;
  late final TextEditingController _addressLine2Controller;
  late final TextEditingController _cityController;
  late final TextEditingController _stateController;
  late final TextEditingController _pincodeController;
  late final TextEditingController _countryController;

  // Tax & billing.
  late TaxTreatment _defaultTaxType;
  late final TextEditingController _invoicePrefixController;
  late final TextEditingController _invoiceStartNumberController;

  // Financial.
  late int _financialYearStartMonth;
  late final TextEditingController _currencyCodeController;
  late final TextEditingController _currencySymbolController;
  late int _decimalPlaces;

  // Bank details.
  late final TextEditingController _bankNameController;
  late final TextEditingController _bankAccountNameController;
  late final TextEditingController _bankAccountNumberController;
  late final TextEditingController _bankIfscController;
  late final TextEditingController _bankBranchController;
  late final TextEditingController _upiIdController;

  // Logo & Banner.
  String? _logoPath;
  File? _pendingLogoFile;
  String? _bannerPath;
  CompanySettings? _loadedSettings;

  @override
  void initState() {
    super.initState();
    _service = widget.service ?? CompanySettingsService();
    _logoPicker = widget.logoPicker ?? const CompanyLogoPicker();
    _logoStorage = widget.logoStorage ?? CompanyLogoStorage();
    _bannerStorage = widget.bannerStorage ?? CompanyBannerStorage();
    _focusController = FormFocusController(_fieldOrder);

    _businessNameController = TextEditingController();
    _gstinController = TextEditingController();
    _panController = TextEditingController();
    _cinController = TextEditingController();
    _phoneController = TextEditingController();
    _emailController = TextEditingController();
    _websiteController = TextEditingController();
    _businessType = BusinessType.proprietorship;
    _gstRegistered = false;

    _addressLine1Controller = TextEditingController();
    _addressLine2Controller = TextEditingController();
    _cityController = TextEditingController();
    _stateController = TextEditingController();
    _pincodeController = TextEditingController();
    _countryController = TextEditingController(text: 'India');

    _defaultTaxType = TaxTreatment.exclusive;
    _invoicePrefixController = TextEditingController();
    _invoiceStartNumberController = TextEditingController();

    _financialYearStartMonth = 4;
    _currencyCodeController = TextEditingController(text: 'INR');
    _currencySymbolController = TextEditingController(text: '\u20B9');
    _decimalPlaces = 2;

    _bankNameController = TextEditingController();
    _bankAccountNameController = TextEditingController();
    _bankAccountNumberController = TextEditingController();
    _bankIfscController = TextEditingController();
    _bankBranchController = TextEditingController();
    _upiIdController = TextEditingController();

    _load();
  }

  @override
  void dispose() {
    _focusController.dispose();
    _businessNameController.dispose();
    _gstinController.dispose();
    _panController.dispose();
    _cinController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _websiteController.dispose();
    _addressLine1Controller.dispose();
    _addressLine2Controller.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _pincodeController.dispose();
    _countryController.dispose();
    _invoicePrefixController.dispose();
    _invoiceStartNumberController.dispose();
    _currencyCodeController.dispose();
    _currencySymbolController.dispose();
    _bankNameController.dispose();
    _bankAccountNameController.dispose();
    _bankAccountNumberController.dispose();
    _bankIfscController.dispose();
    _bankBranchController.dispose();
    _upiIdController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _loadFailed = false;
    });
    try {
      final settings = await _service.getSettings();
      String? banner;
      try {
        banner = await _bannerStorage.getStoredBannerPath();
      } catch (_) {}

      if (!mounted) return;
      setState(() {
        _populate(settings);
        _bannerPath = banner;
        _loading = false;
        // If company has not been named yet, start in edit mode.
        _isEditing = settings.companyName.isEmpty;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _loadFailed = true;
      });
    }
  }

  void _populate(CompanySettings settings) {
    _loadedSettings = settings;
    _businessNameController.text = settings.companyName;
    _gstinController.text = settings.gstNumber ?? '';
    _panController.text = settings.panNumber ?? '';
    _cinController.text = settings.cin ?? '';
    _phoneController.text = settings.mobile ?? '';
    _emailController.text = settings.email ?? '';
    _websiteController.text = settings.website ?? '';
    _businessType = settings.businessType;
    _gstRegistered = settings.gstRegistered;

    _addressLine1Controller.text = settings.addressLine1 ?? '';
    _addressLine2Controller.text = settings.addressLine2 ?? '';
    _cityController.text = settings.city ?? '';
    _stateController.text = settings.state ?? '';
    _pincodeController.text = settings.pincode ?? '';
    _countryController.text = settings.country ?? 'India';

    _defaultTaxType = settings.defaultTaxType;
    _invoicePrefixController.text = settings.invoicePrefix;
    _invoiceStartNumberController.text = settings.invoiceStartNumber.toString();

    _financialYearStartMonth = settings.financialYearStartMonth;
    _currencyCodeController.text = settings.currencyCode;
    _currencySymbolController.text = settings.currencySymbol;
    _decimalPlaces = settings.decimalPlaces;

    _bankNameController.text = settings.bankName ?? '';
    _bankAccountNameController.text = settings.bankAccountName ?? '';
    _bankAccountNumberController.text = settings.bankAccountNumber ?? '';
    _bankIfscController.text = settings.bankIfsc ?? '';
    _bankBranchController.text = settings.bankBranch ?? '';
    _upiIdController.text = settings.upiId ?? '';

    _logoPath = settings.logoPath;
    _pendingLogoFile = null;
  }

  CompanySettingsDraft _buildDraft() {
    return CompanySettingsDraft(
      businessName: _businessNameController.text,
      legalName: '',
      businessType: _businessType,
      gstRegistered: _gstRegistered,
      gstin: _gstinController.text,
      pan: _panController.text,
      cin: _cinController.text,
      phone: _phoneController.text,
      email: _emailController.text,
      website: _websiteController.text,
      addressLine1: _addressLine1Controller.text,
      addressLine2: _addressLine2Controller.text,
      city: _cityController.text,
      state: _stateController.text,
      pincode: _pincodeController.text,
      country: _countryController.text,
      logoPath: _logoPath,
      defaultTaxType: _defaultTaxType,
      invoicePrefix: _invoicePrefixController.text,
      invoiceStartNumber: _invoiceStartNumberController.text,
      financialYearStartMonth: _financialYearStartMonth,
      currencyCode: _currencyCodeController.text,
      currencySymbol: _currencySymbolController.text,
      decimalPlaces: _decimalPlaces,
      bankName: _bankNameController.text,
      bankAccountName: _bankAccountNameController.text,
      bankAccountNumber: _bankAccountNumberController.text,
      bankIfsc: _bankIfscController.text,
      bankBranch: _bankBranchController.text,
      upiId: _upiIdController.text,
      invoiceFooter: _loadedSettings?.invoiceFooter ?? '',
      invoiceTerms: _loadedSettings?.invoiceTerms ?? '',
      invoiceThankYouMessage: _loadedSettings?.invoiceThankYouMessage ?? '',
      showLogoOnInvoice: _loadedSettings?.showLogoOnInvoice ?? true,
      showBankDetailsOnInvoice:
          _loadedSettings?.showBankDetailsOnInvoice ?? true,
      showGstDetailsOnInvoice: _loadedSettings?.showGstDetailsOnInvoice ?? true,
    );
  }

  Future<void> _pickLogo() async {
    try {
      final file = await _logoPicker.pick();
      if (file == null) return; // Cancelled by the user.
      await _logoStorage.validate(file);
      if (!mounted) return;
      setState(() => _pendingLogoFile = file);
    } on CompanyLogoException catch (error) {
      if (!mounted) return;
      _showMessage(error.message);
    } catch (error) {
      if (!mounted) return;
      _showMessage('Could not read the selected image file. Please try another image.');
    }
  }

  void _removeLogo() {
    setState(() {
      _pendingLogoFile = null;
      _logoPath = null;
    });
  }

  Future<void> _save() async {
    final draft = _buildDraft();
    final errors = CompanySettingsValidator.validate(draft);
    final hasErrors = errors.values.any((error) => error != null);
    if (hasErrors) {
      setState(() => _errors = errors);
      _focusController.focusFirstError(errors);
      return;
    }

    setState(() {
      _saving = true;
      _errors = const {};
    });

    String? storedLogoPath;
    try {
      if (_pendingLogoFile != null) {
        storedLogoPath = await _logoStorage.store(_pendingLogoFile!);
      }
      final finalLogoPath = storedLogoPath ?? _logoPath;
      final saved = await _service.save(draft.withLogoPath(finalLogoPath));

      // Remove the previous logo file when it was replaced or removed.
      final previousLogo = _loadedSettings?.logoPath;
      if (previousLogo != null && previousLogo != finalLogoPath) {
        try {
          await _logoStorage.delete(previousLogo);
        } catch (_) {
          // Best effort — a leftover file never breaks the settings.
        }
      }

      PaintingBinding.instance.imageCache.clear();
      PaintingBinding.instance.imageCache.clearLiveImages();

      if (!mounted) return;
      setState(() {
        _populate(saved);
        _pendingLogoFile = null;
        _isEditing = false;
      });
      _showMessage('Company settings saved successfully.');
    } catch (error) {
      // Roll back the freshly stored logo so a failed save leaves no orphan.
      if (storedLogoPath != null) {
        try {
          await _logoStorage.delete(storedLogoPath);
        } catch (_) {}
      }
      if (!mounted) return;
      final message = switch (error) {
        CompanyLogoException(:final message) => message,
        AppDatabaseException(:final message) => message,
        CompanySettingsValidationException() =>
          'Company settings failed validation. Please review the highlighted fields.',
        _ => 'Failed to save company settings: $error',
      };
      _showMessage(message);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _pickAndSaveLogoDirectly() async {
    try {
      final file = await _logoPicker.pick();
      if (file == null) return;
      await _logoStorage.validate(file);
      final storedPath = await _logoStorage.store(file);

      final baseDraft = _loadedSettings != null
          ? CompanySettingsDraft.fromEntity(_loadedSettings!)
          : _buildDraft();
      final draft = baseDraft.withLogoPath(storedPath);
      final saved = await _service.save(draft);

      final previousLogo = _loadedSettings?.logoPath;
      if (previousLogo != null && previousLogo != storedPath) {
        try {
          await _logoStorage.delete(previousLogo);
        } catch (_) {}
      }

      PaintingBinding.instance.imageCache.clear();
      PaintingBinding.instance.imageCache.clearLiveImages();

      if (!mounted) return;
      setState(() {
        _populate(saved);
        _pendingLogoFile = null;
      });
      _showMessage('Company logo updated successfully.');
    } on CompanyLogoException catch (error) {
      if (!mounted) return;
      _showMessage(error.message);
    } on CompanySettingsValidationException catch (_) {
      if (!mounted) return;
      _showMessage('Please complete required company information in Edit Profile first.');
    } catch (error) {
      if (!mounted) return;
      _showMessage('Failed to update company logo: $error');
    }
  }

  Future<void> _pickAndSaveBanner() async {
    try {
      final file = await _logoPicker.pick();
      if (file == null) return;
      await _bannerStorage.validate(file);
      final storedPath = await _bannerStorage.store(file);

      PaintingBinding.instance.imageCache.clear();
      PaintingBinding.instance.imageCache.clearLiveImages();

      if (!mounted) return;
      setState(() {
        _bannerPath = storedPath;
      });
      _showMessage('Cover photo updated successfully.');
    } on CompanyLogoException catch (error) {
      if (!mounted) return;
      _showMessage(error.message);
    } catch (error) {
      if (!mounted) return;
      _showMessage('Could not update cover photo: $error');
    }
  }

  Future<void> _removeBanner() async {
    try {
      await _bannerStorage.delete();
      PaintingBinding.instance.imageCache.clear();
      PaintingBinding.instance.imageCache.clearLiveImages();

      if (!mounted) return;
      setState(() {
        _bannerPath = null;
      });
      _showMessage('Cover photo removed.');
    } catch (_) {
      if (!mounted) return;
      _showMessage('Could not remove cover photo. Please try again.');
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const SettingsSkeleton();
    if (_loadFailed) return _buildErrorState();
    if (!_isEditing && _loadedSettings != null) {
      return CompanyProfileView(
        settings: _loadedSettings!,
        onEdit: () => setState(() => _isEditing = true),
        onUploadLogo: _pickAndSaveLogoDirectly,
        bannerPath: _bannerPath,
        onUploadBanner: _pickAndSaveBanner,
        onRemoveBanner: _removeBanner,
      );
    }
    return _buildForm(context);
  }

  Widget _buildErrorState() {
    return ColoredBox(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: EmptyState(
        icon: Icons.error_outline_rounded,
        title: 'Could not load company settings',
        message: 'Something went wrong while reading your company '
            'configuration. Please try again.',
        action: FilledButton.icon(
          onPressed: _load,
          icon: const Icon(Icons.refresh_rounded, size: 18),
          label: const Text('Try Again'),
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final canCancel = _loadedSettings != null &&
        _loadedSettings!.companyName.trim().isNotEmpty;

    return ColoredBox(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(32, 28, 32, 32),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 920),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Breadcrumbs(items: ['Master Entry', 'Company Settings']),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Company Settings',
                            style: textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.4,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Manage your company identity, address, tax details, '
                            'and financial settings.',
                            style: textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (canCancel)
                      Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: OutlinedButton.icon(
                          key: const ValueKey('company-settings-cancel'),
                          onPressed: () {
                            setState(() {
                              _populate(_loadedSettings!);
                              _errors = const {};
                              _isEditing = false;
                            });
                          },
                          icon: const Icon(Icons.close_rounded, size: 18),
                          label: const Text('Cancel'),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 24),
                // 1. Company Logo at the TOP.
                SettingsSectionCard(
                  title: 'Company Logo',
                  description: 'Shown on invoices, receipts and reports.',
                  child: CompanyLogoSection(
                    previewPath: _pendingLogoFile?.path ?? _logoPath,
                    busy: _saving,
                    onUpload: _pickLogo,
                    onRemove: _removeLogo,
                  ),
                ),
                const SizedBox(height: 20),
                // 2. Company Information (no Legal Name).
                SettingsSectionCard(
                  title: 'Company Information',
                  description: 'Basic identity of your business, shown '
                      'throughout the ERP.',
                  child: CompanyInformationSection(
                    businessNameController: _businessNameController,
                    businessNameError: _errors['businessName'],
                    businessNameFocusNode: _focusController.node(
                      'businessName',
                    ),
                    businessNameContainerKey: _focusController.key(
                      'businessName',
                    ),
                    businessType: _businessType,
                    onBusinessTypeChanged: (type) =>
                        setState(() => _businessType = type),
                    businessTypeFocusNode: _focusController.node(
                      'businessType',
                    ),
                    businessTypeContainerKey: _focusController.key(
                      'businessType',
                    ),
                    gstRegistered: _gstRegistered,
                    onGstRegisteredChanged: (value) =>
                        setState(() => _gstRegistered = value),
                    gstRegisteredFocusNode: _focusController.node(
                      'gstRegistered',
                    ),
                    gstinController: _gstinController,
                    gstinError: _errors['gstin'],
                    gstinRequired: _gstRegistered,
                    gstinFocusNode: _focusController.node('gstin'),
                    gstinContainerKey: _focusController.key('gstin'),
                    panController: _panController,
                    panError: _errors['pan'],
                    panFocusNode: _focusController.node('pan'),
                    panContainerKey: _focusController.key('pan'),
                    cinController: _cinController,
                    cinError: _errors['cin'],
                    cinRequired: _businessType.requiresCin,
                    cinFocusNode: _focusController.node('cin'),
                    cinContainerKey: _focusController.key('cin'),
                    phoneController: _phoneController,
                    phoneError: _errors['phone'],
                    phoneFocusNode: _focusController.node('phone'),
                    phoneContainerKey: _focusController.key('phone'),
                    emailController: _emailController,
                    emailError: _errors['email'],
                    emailFocusNode: _focusController.node('email'),
                    emailContainerKey: _focusController.key('email'),
                    websiteController: _websiteController,
                    websiteError: _errors['website'],
                    websiteFocusNode: _focusController.node('website'),
                    websiteContainerKey: _focusController.key('website'),
                  ),
                ),
                const SizedBox(height: 20),
                // 3. Business Address (Address 1 & 2).
                SettingsSectionCard(
                  title: 'Business Address',
                  description: 'Primary registered / business address.',
                  child: BusinessAddressSection(
                    addressLine1Controller: _addressLine1Controller,
                    addressLine1Error: _errors['addressLine1'],
                    addressLine1FocusNode: _focusController.node(
                      'addressLine1',
                    ),
                    addressLine1ContainerKey: _focusController.key(
                      'addressLine1',
                    ),
                    addressLine2Controller: _addressLine2Controller,
                    addressLine2Error: _errors['addressLine2'],
                    addressLine2FocusNode: _focusController.node(
                      'addressLine2',
                    ),
                    addressLine2ContainerKey: _focusController.key(
                      'addressLine2',
                    ),
                    cityController: _cityController,
                    cityError: _errors['city'],
                    cityFocusNode: _focusController.node('city'),
                    cityContainerKey: _focusController.key('city'),
                    stateController: _stateController,
                    stateError: _errors['state'],
                    stateFocusNode: _focusController.node('state'),
                    stateContainerKey: _focusController.key('state'),
                    pincodeController: _pincodeController,
                    pincodeError: _errors['pincode'],
                    pincodeFocusNode: _focusController.node('pincode'),
                    pincodeContainerKey: _focusController.key('pincode'),
                    countryController: _countryController,
                    countryError: _errors['country'],
                    countryFocusNode: _focusController.node('country'),
                    countryContainerKey: _focusController.key('country'),
                  ),
                ),
                const SizedBox(height: 20),
                // 4. Tax & Billing.
                SettingsSectionCard(
                  title: 'Tax & Billing',
                  description: 'Default tax treatment and invoice numbering.',
                  child: TaxBillingSection(
                    defaultTaxType: _defaultTaxType,
                    onDefaultTaxTypeChanged: (treatment) =>
                        setState(() => _defaultTaxType = treatment),
                    defaultTaxTypeFocusNode: _focusController.node('taxType'),
                    defaultTaxTypeContainerKey: _focusController.key(
                      'taxType',
                    ),
                    invoicePrefixController: _invoicePrefixController,
                    invoicePrefixError: _errors['invoicePrefix'],
                    invoicePrefixFocusNode: _focusController.node(
                      'invoicePrefix',
                    ),
                    invoicePrefixContainerKey: _focusController.key(
                      'invoicePrefix',
                    ),
                    invoiceStartNumberController: _invoiceStartNumberController,
                    invoiceStartNumberError: _errors['invoiceStartNumber'],
                    invoiceStartNumberFocusNode: _focusController.node(
                      'invoiceStartNumber',
                    ),
                    invoiceStartNumberContainerKey: _focusController.key(
                      'invoiceStartNumber',
                    ),
                    gstRegistered: _gstRegistered,
                    onGstRegisteredChanged: (value) =>
                        setState(() => _gstRegistered = value),
                  ),
                ),
                const SizedBox(height: 20),
                // 5. Financial Settings.
                SettingsSectionCard(
                  title: 'Financial Settings',
                  description: 'Financial year, currency and rounding.',
                  child: FinancialSettingsSection(
                    financialYearStartMonth: _financialYearStartMonth,
                    onFinancialYearStartMonthChanged: (month) => setState(
                      () => _financialYearStartMonth = month,
                    ),
                    financialYearStartFocusNode: _focusController.node(
                      'financialYearStart',
                    ),
                    financialYearStartContainerKey: _focusController.key(
                      'financialYearStart',
                    ),
                    currencyCodeController: _currencyCodeController,
                    currencyCodeError: _errors['currencyCode'],
                    currencyCodeFocusNode: _focusController.node(
                      'currencyCode',
                    ),
                    currencyCodeContainerKey: _focusController.key(
                      'currencyCode',
                    ),
                    currencySymbolController: _currencySymbolController,
                    currencySymbolError: _errors['currencySymbol'],
                    currencySymbolFocusNode: _focusController.node(
                      'currencySymbol',
                    ),
                    currencySymbolContainerKey: _focusController.key(
                      'currencySymbol',
                    ),
                    decimalPlaces: _decimalPlaces,
                    onDecimalPlacesChanged: (places) =>
                        setState(() => _decimalPlaces = places),
                    decimalPlacesFocusNode: _focusController.node(
                      'decimalPlaces',
                    ),
                    decimalPlacesContainerKey: _focusController.key(
                      'decimalPlaces',
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // 6. Bank Details.
                SettingsSectionCard(
                  title: 'Bank Details',
                  description: 'Optional — bank and settlement information.',
                  child: BankDetailsSection(
                    bankNameController: _bankNameController,
                    bankNameError: _errors['bankName'],
                    bankNameFocusNode: _focusController.node('bankName'),
                    bankNameContainerKey: _focusController.key('bankName'),
                    bankAccountNameController: _bankAccountNameController,
                    bankAccountNameError: _errors['bankAccountName'],
                    bankAccountNameFocusNode: _focusController.node(
                      'bankAccountName',
                    ),
                    bankAccountNameContainerKey: _focusController.key(
                      'bankAccountName',
                    ),
                    bankAccountNumberController: _bankAccountNumberController,
                    bankAccountNumberError: _errors['bankAccountNumber'],
                    bankAccountNumberFocusNode: _focusController.node(
                      'bankAccountNumber',
                    ),
                    bankAccountNumberContainerKey: _focusController.key(
                      'bankAccountNumber',
                    ),
                    bankIfscController: _bankIfscController,
                    bankIfscError: _errors['bankIfsc'],
                    bankIfscFocusNode: _focusController.node('bankIfsc'),
                    bankIfscContainerKey: _focusController.key('bankIfsc'),
                    bankBranchController: _bankBranchController,
                    bankBranchError: _errors['bankBranch'],
                    bankBranchFocusNode: _focusController.node('bankBranch'),
                    bankBranchContainerKey: _focusController.key('bankBranch'),
                    upiIdController: _upiIdController,
                    upiIdError: _errors['upiId'],
                    upiIdFocusNode: _focusController.node('upiId'),
                    upiIdContainerKey: _focusController.key('upiId'),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (canCancel) ...[
                      OutlinedButton(
                        onPressed: () {
                          setState(() {
                            _populate(_loadedSettings!);
                            _errors = const {};
                            _isEditing = false;
                          });
                        },
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(width: 12),
                    ],
                    FormFocusController.applyOrder(
                      _focusController.node('save'),
                      FilledButton.icon(
                        key: const ValueKey('company-settings-save'),
                        focusNode: _focusController.node('save'),
                        onPressed: _saving ? null : _save,
                        icon: _saving
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.check_rounded, size: 18),
                        label: const Text('Save Changes'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
