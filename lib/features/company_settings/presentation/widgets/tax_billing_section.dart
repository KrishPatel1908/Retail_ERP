import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../features/master_entry/party/presentation/widgets/party_form_sections.dart';
import '../../../../shared/widgets/labelled_dropdown.dart';
import '../../../../shared/widgets/labelled_field.dart';
import '../../../../shared/widgets/switch_field.dart';
import '../../domain/company_settings_enums.dart';

/// "Tax & Billing" section: default tax treatment and invoice numbering.
///
/// The GST Registered switch reuses the company-level setting from the
/// Company Information section — both switches share the same state.
class TaxBillingSection extends StatelessWidget {
  const TaxBillingSection({
    super.key,
    required this.defaultTaxType,
    required this.onDefaultTaxTypeChanged,
    this.defaultTaxTypeFocusNode,
    this.defaultTaxTypeContainerKey,
    required this.invoicePrefixController,
    this.invoicePrefixError,
    this.invoicePrefixFocusNode,
    this.invoicePrefixContainerKey,
    required this.invoiceStartNumberController,
    this.invoiceStartNumberError,
    this.invoiceStartNumberFocusNode,
    this.invoiceStartNumberContainerKey,
    required this.gstRegistered,
    required this.onGstRegisteredChanged,
  });

  final TaxTreatment defaultTaxType;
  final ValueChanged<TaxTreatment> onDefaultTaxTypeChanged;
  final FocusNode? defaultTaxTypeFocusNode;
  final Key? defaultTaxTypeContainerKey;

  final TextEditingController invoicePrefixController;
  final String? invoicePrefixError;
  final FocusNode? invoicePrefixFocusNode;
  final Key? invoicePrefixContainerKey;

  final TextEditingController invoiceStartNumberController;
  final String? invoiceStartNumberError;
  final FocusNode? invoiceStartNumberFocusNode;
  final Key? invoiceStartNumberContainerKey;

  final bool gstRegistered;
  final ValueChanged<bool> onGstRegisteredChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PartyFormRow(
          children: [
            LabelledDropdown<TaxTreatment>(
              label: 'Default Tax Type',
              keyValue: 'company-settings-tax-type',
              value: defaultTaxType,
              focusNode: defaultTaxTypeFocusNode,
              containerKey: defaultTaxTypeContainerKey,
              items: [
                for (final treatment in TaxTreatment.values)
                  DropdownMenuItem(
                    value: treatment,
                    child: Text(treatment.label),
                  ),
              ],
              onChanged: (treatment) {
                if (treatment != null) onDefaultTaxTypeChanged(treatment);
              },
            ),
            LabelledField(
              label: 'Invoice Prefix',
              isRequired: true,
              hintText: 'e.g. INV',
              controller: invoicePrefixController,
              errorText: invoicePrefixError,
              focusNode: invoicePrefixFocusNode,
              containerKey: invoicePrefixContainerKey,
              fieldKey: const ValueKey('company-settings-invoice-prefix'),
              inputFormatters: [
                LengthLimitingTextInputFormatter(10),
              ],
            ),
          ],
        ),
        const SizedBox(height: 20),
        PartyFormRow(
          children: [
            LabelledField(
              label: 'Starting Invoice Number',
              isRequired: true,
              hintText: 'e.g. 1',
              controller: invoiceStartNumberController,
              errorText: invoiceStartNumberError,
              focusNode: invoiceStartNumberFocusNode,
              containerKey: invoiceStartNumberContainerKey,
              fieldKey: const ValueKey('company-settings-invoice-start'),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(9),
              ],
            ),
            SwitchField(
              title: 'GST Registered',
              description: 'Same setting as in Company Information.',
              value: gstRegistered,
              onChanged: onGstRegisteredChanged,
            ),
          ],
        ),
      ],
    );
  }
}
