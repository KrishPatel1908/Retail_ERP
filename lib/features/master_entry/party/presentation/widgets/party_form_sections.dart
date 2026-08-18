import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../shared/utils/upper_case_text_formatter.dart';
import '../../../../../shared/utils/form_focus_controller.dart';
import '../../../../../shared/widgets/labelled_dropdown.dart';
import '../../../../../shared/widgets/labelled_field.dart';
import '../../domain/party_enums.dart';

/// Renders up to two labelled fields side by side on wide surfaces and
/// stacked on narrow ones, matching the desktop ERP form rhythm.
class PartyFormRow extends StatelessWidget {
  const PartyFormRow({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 520) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var i = 0; i < children.length; i++) ...[
                children[i],
                if (i < children.length - 1) const SizedBox(height: 20),
              ],
            ],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var i = 0; i < children.length; i++) ...[
              Expanded(child: children[i]),
              if (i < children.length - 1) const SizedBox(width: 20),
            ],
          ],
        );
      },
    );
  }
}

/// Small section heading inside a form panel.
class PartySectionTitle extends StatelessWidget {
  const PartySectionTitle({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Icon(Icons.circle, size: 6, color: colorScheme.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
          ),
        ),
      ],
    );
  }
}

/// Contact details block shared by the customer and supplier forms.
class PartyContactFields extends StatelessWidget {
  const PartyContactFields({
    super.key,
    required this.keyPrefix,
    required this.mobileController,
    this.mobileError,
    this.mobileFocusNode,
    this.mobileContainerKey,
    required this.alternateMobileController,
    this.alternateMobileError,
    this.alternateMobileFocusNode,
    this.alternateMobileContainerKey,
    required this.emailController,
    this.emailError,
    this.emailFocusNode,
    this.emailContainerKey,
    required this.gstNumberController,
    this.gstNumberError,
    this.gstNumberFocusNode,
    this.gstNumberContainerKey,
    required this.panNumberController,
    this.panNumberError,
    this.panNumberFocusNode,
    this.panNumberContainerKey,
    this.contactPersonController,
    this.contactPersonError,
    this.contactPersonFocusNode,
    this.contactPersonContainerKey,
    this.mobileLabel = 'Mobile',
  });

  final String keyPrefix;
  final TextEditingController mobileController;
  final String? mobileError;
  final FocusNode? mobileFocusNode;
  final Key? mobileContainerKey;

  final TextEditingController alternateMobileController;
  final String? alternateMobileError;
  final FocusNode? alternateMobileFocusNode;
  final Key? alternateMobileContainerKey;

  final TextEditingController emailController;
  final String? emailError;
  final FocusNode? emailFocusNode;
  final Key? emailContainerKey;

  final TextEditingController gstNumberController;
  final String? gstNumberError;
  final FocusNode? gstNumberFocusNode;
  final Key? gstNumberContainerKey;

  final TextEditingController panNumberController;
  final String? panNumberError;
  final FocusNode? panNumberFocusNode;
  final Key? panNumberContainerKey;

  final TextEditingController? contactPersonController;
  final String? contactPersonError;
  final FocusNode? contactPersonFocusNode;
  final Key? contactPersonContainerKey;

  final String mobileLabel;

  @override
  Widget build(BuildContext context) {
    final contactPerson = contactPersonController;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (contactPerson != null) ...[
          LabelledField(
            label: 'Contact Person',
            hintText: 'e.g. Rajesh Kumar',
            controller: contactPerson,
            errorText: contactPersonError,
            focusNode: contactPersonFocusNode,
            containerKey: contactPersonContainerKey,
            fieldKey: ValueKey('$keyPrefix-contact-person'),
          ),
          const SizedBox(height: 20),
        ],
        PartyFormRow(
          children: [
            LabelledField(
              label: mobileLabel,
              isRequired: true,
              hintText: 'e.g. 9876543210',
              controller: mobileController,
              errorText: mobileError,
              focusNode: mobileFocusNode,
              containerKey: mobileContainerKey,
              fieldKey: ValueKey('$keyPrefix-mobile'),
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
            ),
            LabelledField(
              label: 'Alternate Mobile',
              hintText: 'Optional',
              controller: alternateMobileController,
              errorText: alternateMobileError,
              focusNode: alternateMobileFocusNode,
              containerKey: alternateMobileContainerKey,
              fieldKey: ValueKey('$keyPrefix-alternate-mobile'),
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
            ),
          ],
        ),
        const SizedBox(height: 20),
        PartyFormRow(
          children: [
            LabelledField(
              label: 'Email',
              hintText: 'name@example.com',
              controller: emailController,
              errorText: emailError,
              focusNode: emailFocusNode,
              containerKey: emailContainerKey,
              fieldKey: ValueKey('$keyPrefix-email'),
              keyboardType: TextInputType.emailAddress,
            ),
            LabelledField(
              label: 'GST Number',
              hintText: 'e.g. 27ABCDE1234F1Z5',
              controller: gstNumberController,
              errorText: gstNumberError,
              focusNode: gstNumberFocusNode,
              containerKey: gstNumberContainerKey,
              fieldKey: ValueKey('$keyPrefix-gst'),
              inputFormatters: [
                const UpperCaseTextFormatter(),
                LengthLimitingTextInputFormatter(15),
              ],
            ),
          ],
        ),
        const SizedBox(height: 20),
        PartyFormRow(
          children: [
            LabelledField(
              label: 'PAN',
              hintText: 'e.g. ABCDE1234F',
              controller: panNumberController,
              errorText: panNumberError,
              focusNode: panNumberFocusNode,
              containerKey: panNumberContainerKey,
              fieldKey: ValueKey('$keyPrefix-pan'),
              inputFormatters: [
                const UpperCaseTextFormatter(),
                LengthLimitingTextInputFormatter(10),
              ],
            ),
            const SizedBox.shrink(),
          ],
        ),
      ],
    );
  }
}

/// Address block shared by the customer and supplier forms.
class PartyAddressFields extends StatelessWidget {
  const PartyAddressFields({
    super.key,
    required this.keyPrefix,
    required this.addressLine1Controller,
    this.addressLine1Error,
    this.addressLine1FocusNode,
    this.addressLine1ContainerKey,
    required this.addressLine2Controller,
    this.addressLine2Error,
    this.addressLine2FocusNode,
    this.addressLine2ContainerKey,
    required this.cityController,
    this.cityError,
    this.cityFocusNode,
    this.cityContainerKey,
    required this.stateController,
    this.stateError,
    this.stateFocusNode,
    this.stateContainerKey,
    required this.pincodeController,
    this.pincodeError,
    this.pincodeFocusNode,
    this.pincodeContainerKey,
    required this.countryController,
    this.countryError,
    this.countryFocusNode,
    this.countryContainerKey,
  });

  final String keyPrefix;
  final TextEditingController addressLine1Controller;
  final String? addressLine1Error;
  final FocusNode? addressLine1FocusNode;
  final Key? addressLine1ContainerKey;

  final TextEditingController addressLine2Controller;
  final String? addressLine2Error;
  final FocusNode? addressLine2FocusNode;
  final Key? addressLine2ContainerKey;

  final TextEditingController cityController;
  final String? cityError;
  final FocusNode? cityFocusNode;
  final Key? cityContainerKey;

  final TextEditingController stateController;
  final String? stateError;
  final FocusNode? stateFocusNode;
  final Key? stateContainerKey;

  final TextEditingController pincodeController;
  final String? pincodeError;
  final FocusNode? pincodeFocusNode;
  final Key? pincodeContainerKey;

  final TextEditingController countryController;
  final String? countryError;
  final FocusNode? countryFocusNode;
  final Key? countryContainerKey;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PartyFormRow(
          children: [
            LabelledField(
              label: 'Address Line 1',
              hintText: 'Street, building, area',
              controller: addressLine1Controller,
              errorText: addressLine1Error,
              focusNode: addressLine1FocusNode,
              containerKey: addressLine1ContainerKey,
              fieldKey: ValueKey('$keyPrefix-address-line-1'),
            ),
            LabelledField(
              label: 'Address Line 2',
              hintText: 'Optional',
              controller: addressLine2Controller,
              errorText: addressLine2Error,
              focusNode: addressLine2FocusNode,
              containerKey: addressLine2ContainerKey,
              fieldKey: ValueKey('$keyPrefix-address-line-2'),
            ),
          ],
        ),
        const SizedBox(height: 20),
        PartyFormRow(
          children: [
            LabelledField(
              label: 'City',
              hintText: 'e.g. Mumbai',
              controller: cityController,
              errorText: cityError,
              focusNode: cityFocusNode,
              containerKey: cityContainerKey,
              fieldKey: ValueKey('$keyPrefix-city'),
            ),
            LabelledField(
              label: 'State',
              hintText: 'e.g. Maharashtra',
              controller: stateController,
              errorText: stateError,
              focusNode: stateFocusNode,
              containerKey: stateContainerKey,
              fieldKey: ValueKey('$keyPrefix-state'),
            ),
          ],
        ),
        const SizedBox(height: 20),
        PartyFormRow(
          children: [
            LabelledField(
              label: 'Pincode',
              hintText: 'e.g. 400001',
              controller: pincodeController,
              errorText: pincodeError,
              focusNode: pincodeFocusNode,
              containerKey: pincodeContainerKey,
              fieldKey: ValueKey('$keyPrefix-pincode'),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(6),
              ],
            ),
            LabelledField(
              label: 'Country',
              hintText: 'e.g. India',
              controller: countryController,
              errorText: countryError,
              focusNode: countryFocusNode,
              containerKey: countryContainerKey,
              fieldKey: ValueKey('$keyPrefix-country'),
            ),
          ],
        ),
      ],
    );
  }
}

/// Financial block shared by the customer and supplier forms.
class PartyBalanceFields extends StatelessWidget {
  const PartyBalanceFields({
    super.key,
    required this.keyPrefix,
    required this.openingBalanceController,
    this.openingBalanceError,
    this.openingBalanceFocusNode,
    this.openingBalanceContainerKey,
    required this.balanceType,
    required this.onBalanceTypeChanged,
    this.balanceTypeFocusNode,
    this.balanceTypeContainerKey,
    this.creditLimitController,
    this.creditLimitError,
    this.creditLimitFocusNode,
    this.creditLimitContainerKey,
    this.paymentDueDate,
    this.onPaymentDueDateChanged,
    this.paymentDueDateFocusNode,
    this.paymentDueDateContainerKey,
  });

  final String keyPrefix;
  final TextEditingController openingBalanceController;
  final String? openingBalanceError;
  final FocusNode? openingBalanceFocusNode;
  final Key? openingBalanceContainerKey;

  final BalanceType balanceType;
  final ValueChanged<BalanceType> onBalanceTypeChanged;
  final FocusNode? balanceTypeFocusNode;
  final Key? balanceTypeContainerKey;

  final TextEditingController? creditLimitController;
  final String? creditLimitError;
  final FocusNode? creditLimitFocusNode;
  final Key? creditLimitContainerKey;

  final DateTime? paymentDueDate;
  final ValueChanged<DateTime?>? onPaymentDueDateChanged;
  final FocusNode? paymentDueDateFocusNode;
  final Key? paymentDueDateContainerKey;

  @override
  Widget build(BuildContext context) {
    final creditLimit = creditLimitController;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PartyFormRow(
          children: [
            LabelledField(
              label: 'Opening Balance',
              hintText: 'e.g. 5000',
              controller: openingBalanceController,
              errorText: openingBalanceError,
              focusNode: openingBalanceFocusNode,
              containerKey: openingBalanceContainerKey,
              fieldKey: ValueKey('$keyPrefix-opening-balance'),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
              ],
            ),
            LabelledDropdown<BalanceType>(
              label: 'Balance Type',
              keyValue: '$keyPrefix-balance-type',
              value: balanceType,
              focusNode: balanceTypeFocusNode,
              containerKey: balanceTypeContainerKey,
              items: [
                for (final type in BalanceType.values)
                  DropdownMenuItem(value: type, child: Text(type.label)),
              ],
              onChanged: (type) {
                if (type != null) onBalanceTypeChanged(type);
              },
            ),
          ],
        ),
        const SizedBox(height: 20),
        PartyFormRow(
          children: [
            if (creditLimit != null)
              LabelledField(
                label: 'Credit Limit',
                hintText: 'e.g. 50000',
                controller: creditLimit,
                errorText: creditLimitError,
                focusNode: creditLimitFocusNode,
                containerKey: creditLimitContainerKey,
                fieldKey: ValueKey('$keyPrefix-credit-limit'),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                ],
              )
            else
              const SizedBox.shrink(),
            if (onPaymentDueDateChanged != null)
              PartyPaymentDueDateField(
                keyPrefix: keyPrefix,
                selectedDate: paymentDueDate,
                onDateSelected: onPaymentDueDateChanged!,
                focusNode: paymentDueDateFocusNode,
                containerKey: paymentDueDateContainerKey,
              )
            else
              const SizedBox.shrink(),
          ],
        ),
      ],
    );
  }
}

/// Payment Due Date field widget.
class PartyPaymentDueDateField extends StatelessWidget {
  const PartyPaymentDueDateField({
    super.key,
    required this.keyPrefix,
    required this.selectedDate,
    required this.onDateSelected,
    this.focusNode,
    this.containerKey,
  });

  final String keyPrefix;
  final DateTime? selectedDate;
  final ValueChanged<DateTime?> onDateSelected;
  final FocusNode? focusNode;
  final Key? containerKey;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final formatted = selectedDate == null
        ? ''
        : '${selectedDate!.day.toString().padLeft(2, '0')}/${selectedDate!.month.toString().padLeft(2, '0')}/${selectedDate!.year}';

    return FormFocusController.applyOrder(
      focusNode,
      Container(
        key: containerKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Payment Due Date',
              style: textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 6),
            InkWell(
              focusNode: focusNode,
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: selectedDate ?? DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                  helpText: 'Select payment due date',
                );
                if (picked != null) {
                  onDateSelected(picked);
                }
              },
              borderRadius: BorderRadius.circular(8),
              child: InputDecorator(
                decoration: InputDecoration(
                  hintText: 'e.g. 15/09/2026',
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (selectedDate != null)
                        IconButton(
                          icon: const Icon(Icons.clear_rounded, size: 18),
                          onPressed: () => onDateSelected(null),
                          tooltip: 'Clear date',
                        ),
                      const Icon(Icons.calendar_today_rounded, size: 18),
                      const SizedBox(width: 12),
                    ],
                  ),
                ),
                child: Text(
                  formatted.isEmpty ? 'e.g. 15/09/2026' : formatted,
                  style: textTheme.bodyMedium?.copyWith(
                    color: formatted.isEmpty
                        ? colorScheme.onSurfaceVariant.withValues(alpha: 0.6)
                        : colorScheme.onSurface,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Bank details block shared by customer and supplier forms.
class PartyBankFields extends StatelessWidget {
  const PartyBankFields({
    super.key,
    required this.keyPrefix,
    required this.accountNameController,
    this.accountNameError,
    this.accountNameFocusNode,
    this.accountNameContainerKey,
    required this.accountNumberController,
    this.accountNumberError,
    this.accountNumberFocusNode,
    this.accountNumberContainerKey,
    required this.bankNameController,
    this.bankNameError,
    this.bankNameFocusNode,
    this.bankNameContainerKey,
    required this.branchNameController,
    this.branchNameError,
    this.branchNameFocusNode,
    this.branchNameContainerKey,
    required this.ifscCodeController,
    this.ifscCodeError,
    this.ifscCodeFocusNode,
    this.ifscCodeContainerKey,
  });

  final String keyPrefix;
  final TextEditingController accountNameController;
  final String? accountNameError;
  final FocusNode? accountNameFocusNode;
  final Key? accountNameContainerKey;

  final TextEditingController accountNumberController;
  final String? accountNumberError;
  final FocusNode? accountNumberFocusNode;
  final Key? accountNumberContainerKey;

  final TextEditingController bankNameController;
  final String? bankNameError;
  final FocusNode? bankNameFocusNode;
  final Key? bankNameContainerKey;

  final TextEditingController branchNameController;
  final String? branchNameError;
  final FocusNode? branchNameFocusNode;
  final Key? branchNameContainerKey;

  final TextEditingController ifscCodeController;
  final String? ifscCodeError;
  final FocusNode? ifscCodeFocusNode;
  final Key? ifscCodeContainerKey;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PartyFormRow(
          children: [
            LabelledField(
              label: 'Account Name',
              hintText: 'e.g. Acme Traders',
              controller: accountNameController,
              errorText: accountNameError,
              focusNode: accountNameFocusNode,
              containerKey: accountNameContainerKey,
              fieldKey: ValueKey('$keyPrefix-account-name'),
            ),
            LabelledField(
              label: 'Account Number',
              hintText: 'e.g. 123456789012',
              controller: accountNumberController,
              errorText: accountNumberError,
              focusNode: accountNumberFocusNode,
              containerKey: accountNumberContainerKey,
              fieldKey: ValueKey('$keyPrefix-account-number'),
            ),
          ],
        ),
        const SizedBox(height: 20),
        PartyFormRow(
          children: [
            LabelledField(
              label: 'Bank Name',
              hintText: 'e.g. State Bank of India',
              controller: bankNameController,
              errorText: bankNameError,
              focusNode: bankNameFocusNode,
              containerKey: bankNameContainerKey,
              fieldKey: ValueKey('$keyPrefix-bank-name'),
            ),
            LabelledField(
              label: 'Branch Name',
              hintText: 'e.g. Fort Branch',
              controller: branchNameController,
              errorText: branchNameError,
              focusNode: branchNameFocusNode,
              containerKey: branchNameContainerKey,
              fieldKey: ValueKey('$keyPrefix-branch-name'),
            ),
          ],
        ),
        const SizedBox(height: 20),
        PartyFormRow(
          children: [
            LabelledField(
              label: 'IFSC Code',
              hintText: 'e.g. SBIN0001234',
              controller: ifscCodeController,
              errorText: ifscCodeError,
              focusNode: ifscCodeFocusNode,
              containerKey: ifscCodeContainerKey,
              fieldKey: ValueKey('$keyPrefix-ifsc-code'),
              inputFormatters: [
                const UpperCaseTextFormatter(),
                LengthLimitingTextInputFormatter(11),
              ],
            ),
            const SizedBox.shrink(),
          ],
        ),
      ],
    );
  }
}
