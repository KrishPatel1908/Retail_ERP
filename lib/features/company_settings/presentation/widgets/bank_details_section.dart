import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../features/master_entry/party/presentation/widgets/party_form_sections.dart';
import '../../../../shared/utils/upper_case_text_formatter.dart';
import '../../../../shared/widgets/labelled_field.dart';

/// "Bank Details" section. Every field is optional; validation only runs
/// when a value is provided.
class BankDetailsSection extends StatelessWidget {
  const BankDetailsSection({
    super.key,
    required this.bankNameController,
    this.bankNameError,
    this.bankNameFocusNode,
    this.bankNameContainerKey,
    required this.bankAccountNameController,
    this.bankAccountNameError,
    this.bankAccountNameFocusNode,
    this.bankAccountNameContainerKey,
    required this.bankAccountNumberController,
    this.bankAccountNumberError,
    this.bankAccountNumberFocusNode,
    this.bankAccountNumberContainerKey,
    required this.bankIfscController,
    this.bankIfscError,
    this.bankIfscFocusNode,
    this.bankIfscContainerKey,
    required this.bankBranchController,
    this.bankBranchError,
    this.bankBranchFocusNode,
    this.bankBranchContainerKey,
    required this.upiIdController,
    this.upiIdError,
    this.upiIdFocusNode,
    this.upiIdContainerKey,
  });

  final TextEditingController bankNameController;
  final String? bankNameError;
  final FocusNode? bankNameFocusNode;
  final Key? bankNameContainerKey;

  final TextEditingController bankAccountNameController;
  final String? bankAccountNameError;
  final FocusNode? bankAccountNameFocusNode;
  final Key? bankAccountNameContainerKey;

  final TextEditingController bankAccountNumberController;
  final String? bankAccountNumberError;
  final FocusNode? bankAccountNumberFocusNode;
  final Key? bankAccountNumberContainerKey;

  final TextEditingController bankIfscController;
  final String? bankIfscError;
  final FocusNode? bankIfscFocusNode;
  final Key? bankIfscContainerKey;

  final TextEditingController bankBranchController;
  final String? bankBranchError;
  final FocusNode? bankBranchFocusNode;
  final Key? bankBranchContainerKey;

  final TextEditingController upiIdController;
  final String? upiIdError;
  final FocusNode? upiIdFocusNode;
  final Key? upiIdContainerKey;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PartyFormRow(
          children: [
            LabelledField(
              label: 'Bank Name',
              hintText: 'e.g. State Bank of India',
              controller: bankNameController,
              errorText: bankNameError,
              focusNode: bankNameFocusNode,
              containerKey: bankNameContainerKey,
              fieldKey: const ValueKey('company-settings-bank-name'),
            ),
            LabelledField(
              label: 'Account Name',
              hintText: 'e.g. Acme Retailers',
              controller: bankAccountNameController,
              errorText: bankAccountNameError,
              focusNode: bankAccountNameFocusNode,
              containerKey: bankAccountNameContainerKey,
              fieldKey: const ValueKey('company-settings-bank-account-name'),
            ),
          ],
        ),
        const SizedBox(height: 20),
        PartyFormRow(
          children: [
            LabelledField(
              label: 'Account Number',
              hintText: 'e.g. 123456789012',
              controller: bankAccountNumberController,
              errorText: bankAccountNumberError,
              focusNode: bankAccountNumberFocusNode,
              containerKey: bankAccountNumberContainerKey,
              fieldKey: const ValueKey('company-settings-bank-account-number'),
              keyboardType: TextInputType.number,
            ),
            LabelledField(
              label: 'IFSC Code',
              hintText: 'e.g. SBIN0001234',
              controller: bankIfscController,
              errorText: bankIfscError,
              focusNode: bankIfscFocusNode,
              containerKey: bankIfscContainerKey,
              fieldKey: const ValueKey('company-settings-bank-ifsc'),
              inputFormatters: [
                const UpperCaseTextFormatter(),
                LengthLimitingTextInputFormatter(11),
              ],
            ),
          ],
        ),
        const SizedBox(height: 20),
        PartyFormRow(
          children: [
            LabelledField(
              label: 'Branch Name',
              hintText: 'e.g. Fort Branch',
              controller: bankBranchController,
              errorText: bankBranchError,
              focusNode: bankBranchFocusNode,
              containerKey: bankBranchContainerKey,
              fieldKey: const ValueKey('company-settings-bank-branch'),
            ),
            LabelledField(
              label: 'UPI ID',
              hintText: 'e.g. acme@upi',
              controller: upiIdController,
              errorText: upiIdError,
              focusNode: upiIdFocusNode,
              containerKey: upiIdContainerKey,
              fieldKey: const ValueKey('company-settings-upi-id'),
            ),
          ],
        ),
      ],
    );
  }
}
