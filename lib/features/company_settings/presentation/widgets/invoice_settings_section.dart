import 'package:flutter/material.dart';

import '../../../../features/master_entry/party/presentation/widgets/party_form_sections.dart';
import '../../../../shared/widgets/labelled_field.dart';
import '../../../../shared/widgets/switch_field.dart';

/// "Invoice Settings" section: document text and rendering options for
/// future invoices, receipts and reports.
class InvoiceSettingsSection extends StatelessWidget {
  const InvoiceSettingsSection({
    super.key,
    required this.invoiceFooterController,
    this.invoiceFooterError,
    this.invoiceFooterFocusNode,
    this.invoiceFooterContainerKey,
    required this.invoiceTermsController,
    this.invoiceTermsError,
    this.invoiceTermsFocusNode,
    this.invoiceTermsContainerKey,
    required this.invoiceThankYouController,
    this.invoiceThankYouError,
    this.invoiceThankYouFocusNode,
    this.invoiceThankYouContainerKey,
    required this.showLogoOnInvoice,
    required this.onShowLogoOnInvoiceChanged,
    this.showLogoOnInvoiceFocusNode,
    required this.showBankDetailsOnInvoice,
    required this.onShowBankDetailsOnInvoiceChanged,
    this.showBankDetailsOnInvoiceFocusNode,
    required this.showGstDetailsOnInvoice,
    required this.onShowGstDetailsOnInvoiceChanged,
    this.showGstDetailsOnInvoiceFocusNode,
  });

  final TextEditingController invoiceFooterController;
  final String? invoiceFooterError;
  final FocusNode? invoiceFooterFocusNode;
  final Key? invoiceFooterContainerKey;

  final TextEditingController invoiceTermsController;
  final String? invoiceTermsError;
  final FocusNode? invoiceTermsFocusNode;
  final Key? invoiceTermsContainerKey;

  final TextEditingController invoiceThankYouController;
  final String? invoiceThankYouError;
  final FocusNode? invoiceThankYouFocusNode;
  final Key? invoiceThankYouContainerKey;

  final bool showLogoOnInvoice;
  final ValueChanged<bool> onShowLogoOnInvoiceChanged;
  final FocusNode? showLogoOnInvoiceFocusNode;

  final bool showBankDetailsOnInvoice;
  final ValueChanged<bool> onShowBankDetailsOnInvoiceChanged;
  final FocusNode? showBankDetailsOnInvoiceFocusNode;

  final bool showGstDetailsOnInvoice;
  final ValueChanged<bool> onShowGstDetailsOnInvoiceChanged;
  final FocusNode? showGstDetailsOnInvoiceFocusNode;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LabelledField(
          label: 'Invoice Footer',
          hintText: 'Optional footer text shown at the bottom of invoices',
          maxLines: 3,
          controller: invoiceFooterController,
          errorText: invoiceFooterError,
          focusNode: invoiceFooterFocusNode,
          containerKey: invoiceFooterContainerKey,
          fieldKey: const ValueKey('company-settings-invoice-footer'),
        ),
        const SizedBox(height: 20),
        LabelledField(
          label: 'Terms & Conditions',
          hintText: 'Optional terms shown on invoices',
          maxLines: 3,
          controller: invoiceTermsController,
          errorText: invoiceTermsError,
          focusNode: invoiceTermsFocusNode,
          containerKey: invoiceTermsContainerKey,
          fieldKey: const ValueKey('company-settings-invoice-terms'),
        ),
        const SizedBox(height: 20),
        LabelledField(
          label: 'Thank You Message',
          hintText: 'Optional — e.g. Thank you for your business!',
          maxLines: 2,
          controller: invoiceThankYouController,
          errorText: invoiceThankYouError,
          focusNode: invoiceThankYouFocusNode,
          containerKey: invoiceThankYouContainerKey,
          fieldKey: const ValueKey('company-settings-invoice-thank-you'),
        ),
        const SizedBox(height: 24),
        const PartySectionTitle(title: 'Display Options'),
        const SizedBox(height: 14),
        SwitchField(
          title: 'Show Logo on Invoice',
          description: 'Display the company logo on generated documents.',
          value: showLogoOnInvoice,
          onChanged: onShowLogoOnInvoiceChanged,
          focusNode: showLogoOnInvoiceFocusNode,
        ),
        const SizedBox(height: 12),
        SwitchField(
          title: 'Show Bank Details on Invoice',
          description: 'Display the bank details on generated documents.',
          value: showBankDetailsOnInvoice,
          onChanged: onShowBankDetailsOnInvoiceChanged,
          focusNode: showBankDetailsOnInvoiceFocusNode,
        ),
        const SizedBox(height: 12),
        SwitchField(
          title: 'Show GST Details on Invoice',
          description: 'Display GSTIN and tax details on generated documents.',
          value: showGstDetailsOnInvoice,
          onChanged: onShowGstDetailsOnInvoiceChanged,
          focusNode: showGstDetailsOnInvoiceFocusNode,
        ),
      ],
    );
  }
}
