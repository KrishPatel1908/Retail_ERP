import 'package:flutter/material.dart';

import '../../../../../core/database/exceptions/database_exceptions.dart';
import '../../../../../shared/utils/form_focus_controller.dart';
import '../../../../../shared/widgets/breadcrumbs.dart';
import '../../../../../shared/widgets/content_panel.dart';
import '../../../../../shared/widgets/labelled_field.dart';
import '../../../../../shared/widgets/switch_field.dart';
import '../../data/repositories/customer_repository.dart';
import '../../domain/entities/customer.dart';
import '../../domain/exceptions/customer_exceptions.dart';
import '../../../party/domain/party_enums.dart';
import '../../../party/presentation/widgets/party_form_sections.dart';
import '../../../party/services/party_formatters.dart';
import '../../services/customer_validator.dart';

/// "Create / Edit Customer" form page.
class CreateCustomerPage extends StatefulWidget {
  const CreateCustomerPage({
    super.key,
    required this.onSave,
    required this.onCancel,
    this.customer,
  });

  final VoidCallback onSave;
  final VoidCallback onCancel;
  final Customer? customer;

  @override
  State<CreateCustomerPage> createState() => _CreateCustomerPageState();
}

class _CreateCustomerPageState extends State<CreateCustomerPage> {
  late final CustomerRepository _repository;
  late final FormFocusController _focusController;

  static const _fieldOrder = [
    'name',
    'mobile',
    'alternateMobile',
    'email',
    'gst',
    'pan',
    'addressLine1',
    'addressLine2',
    'city',
    'state',
    'pincode',
    'country',
    'openingBalance',
    'balanceType',
    'paymentDueDate',
    'creditLimit',
    'accountName',
    'accountNumber',
    'bankName',
    'branchName',
    'ifscCode',
    'active',
    'notes',
    'cancel',
    'save',
  ];

  late final TextEditingController _nameController;
  late final TextEditingController _mobileController;
  late final TextEditingController _alternateMobileController;
  late final TextEditingController _emailController;
  late final TextEditingController _gstController;
  late final TextEditingController _panController;
  late final TextEditingController _addressLine1Controller;
  late final TextEditingController _addressLine2Controller;
  late final TextEditingController _cityController;
  late final TextEditingController _stateController;
  late final TextEditingController _pincodeController;
  late final TextEditingController _countryController;
  late final TextEditingController _openingBalanceController;
  late final TextEditingController _creditLimitController;
  late final TextEditingController _accountNameController;
  late final TextEditingController _accountNumberController;
  late final TextEditingController _bankNameController;
  late final TextEditingController _branchNameController;
  late final TextEditingController _ifscCodeController;
  late final TextEditingController _notesController;

  late BalanceType _balanceType;
  late DateTime? _paymentDueDate;
  late bool _active;

  Map<String, String?> _errors = const {};
  bool _saving = false;

  bool get _isEditing => widget.customer != null;

  @override
  void initState() {
    super.initState();
    _repository = CustomerRepository();
    _focusController = FormFocusController(_fieldOrder);

    final customer = widget.customer;
    _nameController = TextEditingController(text: customer?.customerName);
    _mobileController = TextEditingController(text: customer?.mobile);
    _alternateMobileController = TextEditingController(
      text: customer?.alternateMobile,
    );
    _emailController = TextEditingController(text: customer?.email);
    _gstController = TextEditingController(text: customer?.gstNumber);
    _panController = TextEditingController(text: customer?.panNumber);
    _addressLine1Controller = TextEditingController(
      text: customer?.addressLine1,
    );
    _addressLine2Controller = TextEditingController(
      text: customer?.addressLine2,
    );
    _cityController = TextEditingController(text: customer?.city);
    _stateController = TextEditingController(text: customer?.state);
    _pincodeController = TextEditingController(text: customer?.pincode);
    _countryController = TextEditingController(text: customer?.country);
    _openingBalanceController = TextEditingController(
      text: customer == null || customer.openingBalance == 0
          ? ''
          : _formatPaise(customer.openingBalance),
    );
    _creditLimitController = TextEditingController(
      text: customer == null || customer.creditLimit == 0
          ? ''
          : _formatPaise(customer.creditLimit),
    );
    _accountNameController = TextEditingController(text: customer?.accountName);
    _accountNumberController = TextEditingController(
      text: customer?.accountNumber,
    );
    _bankNameController = TextEditingController(text: customer?.bankName);
    _branchNameController = TextEditingController(text: customer?.branchName);
    _ifscCodeController = TextEditingController(text: customer?.ifscCode);
    _notesController = TextEditingController(text: customer?.notes);
    _balanceType = customer?.balanceType ?? BalanceType.debit;
    _paymentDueDate = customer?.paymentDueDate;
    _active = customer?.isActive ?? true;
  }

  static String _formatPaise(int paise) {
    final rupees = paise / 100;
    final text = rupees == rupees.roundToDouble()
        ? rupees.round().toString()
        : rupees.toStringAsFixed(2);
    return text;
  }

  @override
  void dispose() {
    _focusController.dispose();
    _nameController.dispose();
    _mobileController.dispose();
    _alternateMobileController.dispose();
    _emailController.dispose();
    _gstController.dispose();
    _panController.dispose();
    _addressLine1Controller.dispose();
    _addressLine2Controller.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _pincodeController.dispose();
    _countryController.dispose();
    _openingBalanceController.dispose();
    _creditLimitController.dispose();
    _accountNameController.dispose();
    _accountNumberController.dispose();
    _bankNameController.dispose();
    _branchNameController.dispose();
    _ifscCodeController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    final mobile = _mobileController.text.trim();
    final alternateMobile = _alternateMobileController.text.trim();
    final email = _emailController.text.trim();
    final gst = _gstController.text.trim().toUpperCase();
    final pan = _panController.text.trim().toUpperCase();
    final addressLine1 = _addressLine1Controller.text.trim();
    final addressLine2 = _addressLine2Controller.text.trim();
    final city = _cityController.text.trim();
    final state = _stateController.text.trim();
    final pincode = _pincodeController.text.trim();
    final country = _countryController.text.trim();
    final openingBalanceText = _openingBalanceController.text.trim();
    final creditLimitText = _creditLimitController.text.trim();
    final accountName = _accountNameController.text.trim();
    final accountNumber = _accountNumberController.text.trim();
    final bankName = _bankNameController.text.trim();
    final branchName = _branchNameController.text.trim();
    final ifscCode = _ifscCodeController.text.trim().toUpperCase();
    final notes = _notesController.text.trim();

    final errors = <String, String?>{
      'name': CustomerValidator.validateName(name),
      'mobile': CustomerValidator.validateMobile(mobile),
      'alternateMobile': CustomerValidator.validateAlternateMobile(
        alternateMobile,
      ),
      'email': CustomerValidator.validateEmail(email),
      'gst': CustomerValidator.validateGstNumber(gst),
      'pan': CustomerValidator.validatePanNumber(pan),
      'addressLine1': CustomerValidator.validateOptional(
        addressLine1,
        label: 'Address line 1',
      ),
      'addressLine2': CustomerValidator.validateOptional(
        addressLine2,
        label: 'Address line 2',
      ),
      'city': CustomerValidator.validateOptional(city, label: 'City'),
      'state': CustomerValidator.validateOptional(state, label: 'State'),
      'pincode': CustomerValidator.validatePincode(pincode),
      'country': CustomerValidator.validateOptional(country, label: 'Country'),
      'openingBalance': CustomerValidator.validateAmount(
        openingBalanceText,
        label: 'Opening balance',
      ),
      'creditLimit': CustomerValidator.validateAmount(
        creditLimitText,
        label: 'Credit limit',
      ),
      'accountName': CustomerValidator.validateAccountName(accountName),
      'accountNumber': CustomerValidator.validateAccountNumber(accountNumber),
      'bankName': CustomerValidator.validateBankName(bankName),
      'branchName': CustomerValidator.validateBranchName(branchName),
      'ifscCode': CustomerValidator.validateIfscCode(ifscCode),
      'notes': CustomerValidator.validateNotes(notes),
    };

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

    final openingBalance =
        PartyFormatters.parseRupeesToPaise(openingBalanceText) ?? 0;
    final creditLimit =
        PartyFormatters.parseRupeesToPaise(creditLimitText) ?? 0;

    try {
      if (_isEditing) {
        await _repository.updateCustomer(
          widget.customer!.id,
          customerName: name,
          mobile: mobile,
          alternateMobile: alternateMobile,
          email: email,
          gstNumber: gst,
          panNumber: pan,
          addressLine1: addressLine1,
          addressLine2: addressLine2,
          city: city,
          state: state,
          country: country,
          pincode: pincode,
          creditLimit: creditLimit,
          openingBalance: openingBalance,
          balanceType: _balanceType,
          paymentDueDate: _paymentDueDate,
          accountName: accountName,
          accountNumber: accountNumber,
          bankName: bankName,
          branchName: branchName,
          ifscCode: ifscCode,
          notes: notes,
          isActive: _active,
        );
      } else {
        await _repository.createCustomer(
          customerName: name,
          mobile: mobile,
          alternateMobile: alternateMobile,
          email: email,
          gstNumber: gst,
          panNumber: pan,
          addressLine1: addressLine1,
          addressLine2: addressLine2,
          city: city,
          state: state,
          country: country,
          pincode: pincode,
          creditLimit: creditLimit,
          openingBalance: openingBalance,
          balanceType: _balanceType,
          paymentDueDate: _paymentDueDate,
          accountName: accountName,
          accountNumber: accountNumber,
          bankName: bankName,
          branchName: branchName,
          ifscCode: ifscCode,
          notes: notes,
          isActive: _active,
        );
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              _isEditing
                  ? 'Customer updated successfully.'
                  : 'Customer created successfully.',
            ),
          ),
        );
      widget.onSave();
    } on CustomerDuplicateException catch (exception) {
      if (!mounted) return;
      final duplicateErrors = {
        ..._errors,
        exception.field.formField: exception.message,
      };
      setState(() {
        _saving = false;
        _errors = duplicateErrors;
      });
      _focusController.focusFirstError(duplicateErrors);
    } on CustomerNotFoundException {
      if (!mounted) return;
      _showFailure('This customer no longer exists. Please try again.');
    } on AppDatabaseException catch (error) {
      _showFailure('Failed to save customer. ${error.message}');
    } catch (_) {
      _showFailure('Failed to save customer. Please try again.');
    }
  }

  void _showFailure(String message) {
    if (!mounted) return;
    setState(() => _saving = false);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final title = _isEditing ? 'Edit Customer' : 'Create Customer';
    final subtitle = _isEditing
        ? 'Update the details of this customer.'
        : 'Add a new customer to your sales ledger.';

    return ColoredBox(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(32, 28, 32, 28),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: FocusTraversalGroup(
              policy: OrderedTraversalPolicy(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Breadcrumbs(
                    items: ['Master Entry', 'Customer Master', title],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    title,
                    style: textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.4,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ContentPanel(
                    padding: const EdgeInsets.all(28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        LabelledField(
                          label: 'Customer Name',
                          isRequired: true,
                          hintText: 'e.g. Acme Traders',
                          controller: _nameController,
                          errorText: _errors['name'],
                          focusNode: _focusController.node('name'),
                          containerKey: _focusController.key('name'),
                          fieldKey: const ValueKey('customer-name'),
                        ),
                        const SizedBox(height: 20),
                        const PartySectionTitle(title: 'Contact Information'),
                        const SizedBox(height: 16),
                        PartyContactFields(
                          keyPrefix: 'customer',
                          mobileController: _mobileController,
                          mobileError: _errors['mobile'],
                          mobileFocusNode: _focusController.node('mobile'),
                          mobileContainerKey: _focusController.key('mobile'),
                          alternateMobileController: _alternateMobileController,
                          alternateMobileError: _errors['alternateMobile'],
                          alternateMobileFocusNode: _focusController.node(
                            'alternateMobile',
                          ),
                          alternateMobileContainerKey: _focusController.key(
                            'alternateMobile',
                          ),
                          emailController: _emailController,
                          emailError: _errors['email'],
                          emailFocusNode: _focusController.node('email'),
                          emailContainerKey: _focusController.key('email'),
                          gstNumberController: _gstController,
                          gstNumberError: _errors['gst'],
                          gstNumberFocusNode: _focusController.node('gst'),
                          gstNumberContainerKey: _focusController.key('gst'),
                          panNumberController: _panController,
                          panNumberError: _errors['pan'],
                          panNumberFocusNode: _focusController.node('pan'),
                          panNumberContainerKey: _focusController.key('pan'),
                        ),
                        const SizedBox(height: 24),
                        const PartySectionTitle(title: 'Address'),
                        const SizedBox(height: 16),
                        PartyAddressFields(
                          keyPrefix: 'customer',
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
                        const SizedBox(height: 24),
                        const PartySectionTitle(title: 'Financial Details'),
                        const SizedBox(height: 16),
                        PartyBalanceFields(
                          keyPrefix: 'customer',
                          openingBalanceController: _openingBalanceController,
                          openingBalanceError: _errors['openingBalance'],
                          openingBalanceFocusNode: _focusController.node(
                            'openingBalance',
                          ),
                          openingBalanceContainerKey: _focusController.key(
                            'openingBalance',
                          ),
                          balanceType: _balanceType,
                          onBalanceTypeChanged: (type) =>
                              setState(() => _balanceType = type),
                          balanceTypeFocusNode: _focusController.node(
                            'balanceType',
                          ),
                          balanceTypeContainerKey: _focusController.key(
                            'balanceType',
                          ),
                          creditLimitController: _creditLimitController,
                          creditLimitError: _errors['creditLimit'],
                          creditLimitFocusNode: _focusController.node(
                            'creditLimit',
                          ),
                          creditLimitContainerKey: _focusController.key(
                            'creditLimit',
                          ),
                          paymentDueDate: _paymentDueDate,
                          onPaymentDueDateChanged: (date) =>
                              setState(() => _paymentDueDate = date),
                          paymentDueDateFocusNode: _focusController.node(
                            'paymentDueDate',
                          ),
                          paymentDueDateContainerKey: _focusController.key(
                            'paymentDueDate',
                          ),
                        ),
                        const SizedBox(height: 24),
                        const PartySectionTitle(title: 'Bank Details'),
                        const SizedBox(height: 16),
                        PartyBankFields(
                          keyPrefix: 'customer',
                          accountNameController: _accountNameController,
                          accountNameError: _errors['accountName'],
                          accountNameFocusNode: _focusController.node(
                            'accountName',
                          ),
                          accountNameContainerKey: _focusController.key(
                            'accountName',
                          ),
                          accountNumberController: _accountNumberController,
                          accountNumberError: _errors['accountNumber'],
                          accountNumberFocusNode: _focusController.node(
                            'accountNumber',
                          ),
                          accountNumberContainerKey: _focusController.key(
                            'accountNumber',
                          ),
                          bankNameController: _bankNameController,
                          bankNameError: _errors['bankName'],
                          bankNameFocusNode: _focusController.node('bankName'),
                          bankNameContainerKey: _focusController.key(
                            'bankName',
                          ),
                          branchNameController: _branchNameController,
                          branchNameError: _errors['branchName'],
                          branchNameFocusNode: _focusController.node(
                            'branchName',
                          ),
                          branchNameContainerKey: _focusController.key(
                            'branchName',
                          ),
                          ifscCodeController: _ifscCodeController,
                          ifscCodeError: _errors['ifscCode'],
                          ifscCodeFocusNode: _focusController.node('ifscCode'),
                          ifscCodeContainerKey: _focusController.key(
                            'ifscCode',
                          ),
                        ),
                        const SizedBox(height: 20),
                        SwitchField(
                          title: 'Active',
                          description: 'New customers are enabled by default.',
                          value: _active,
                          onChanged: (value) => setState(() => _active = value),
                          focusNode: _focusController.node('active'),
                        ),
                        const SizedBox(height: 20),
                        LabelledField(
                          label: 'Notes',
                          hintText: 'Optional notes',
                          maxLines: 3,
                          controller: _notesController,
                          errorText: _errors['notes'],
                          focusNode: _focusController.node('notes'),
                          containerKey: _focusController.key('notes'),
                          fieldKey: const ValueKey('customer-notes'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      FormFocusController.applyOrder(
                        _focusController.node('cancel'),
                        OutlinedButton(
                          focusNode: _focusController.node('cancel'),
                          onPressed: _saving ? null : widget.onCancel,
                          child: const Text('Cancel'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      FormFocusController.applyOrder(
                        _focusController.node('save'),
                        FilledButton.icon(
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
                          label: const Text('Save'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
