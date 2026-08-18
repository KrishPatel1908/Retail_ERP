import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../features/master_entry/party/presentation/widgets/party_form_sections.dart';
import '../../../../shared/utils/upper_case_text_formatter.dart';
import '../../../../shared/widgets/labelled_dropdown.dart';
import '../../../../shared/widgets/labelled_field.dart';
import '../../../../shared/widgets/switch_field.dart';
import '../../domain/company_settings_enums.dart';

/// "Company Information" section: identity, GST registration, contacts.
class CompanyInformationSection extends StatelessWidget {
  const CompanyInformationSection({
    super.key,
    required this.businessNameController,
    this.businessNameError,
    this.businessNameFocusNode,
    this.businessNameContainerKey,
    required this.businessType,
    required this.onBusinessTypeChanged,
    this.businessTypeFocusNode,
    this.businessTypeContainerKey,
    required this.gstRegistered,
    required this.onGstRegisteredChanged,
    this.gstRegisteredFocusNode,
    required this.gstinController,
    this.gstinError,
    this.gstinRequired = false,
    this.gstinFocusNode,
    this.gstinContainerKey,
    required this.panController,
    this.panError,
    this.panFocusNode,
    this.panContainerKey,
    required this.cinController,
    this.cinError,
    this.cinRequired = false,
    this.cinFocusNode,
    this.cinContainerKey,
    required this.phoneController,
    this.phoneError,
    this.phoneFocusNode,
    this.phoneContainerKey,
    required this.emailController,
    this.emailError,
    this.emailFocusNode,
    this.emailContainerKey,
    required this.websiteController,
    this.websiteError,
    this.websiteFocusNode,
    this.websiteContainerKey,
  });

  final TextEditingController businessNameController;
  final String? businessNameError;
  final FocusNode? businessNameFocusNode;
  final Key? businessNameContainerKey;

  final BusinessType businessType;
  final ValueChanged<BusinessType> onBusinessTypeChanged;
  final FocusNode? businessTypeFocusNode;
  final Key? businessTypeContainerKey;

  final bool gstRegistered;
  final ValueChanged<bool> onGstRegisteredChanged;
  final FocusNode? gstRegisteredFocusNode;

  final TextEditingController gstinController;
  final String? gstinError;
  final bool gstinRequired;
  final FocusNode? gstinFocusNode;
  final Key? gstinContainerKey;

  final TextEditingController panController;
  final String? panError;
  final FocusNode? panFocusNode;
  final Key? panContainerKey;

  final TextEditingController cinController;
  final String? cinError;
  final bool cinRequired;
  final FocusNode? cinFocusNode;
  final Key? cinContainerKey;

  final TextEditingController phoneController;
  final String? phoneError;
  final FocusNode? phoneFocusNode;
  final Key? phoneContainerKey;

  final TextEditingController emailController;
  final String? emailError;
  final FocusNode? emailFocusNode;
  final Key? emailContainerKey;

  final TextEditingController websiteController;
  final String? websiteError;
  final FocusNode? websiteFocusNode;
  final Key? websiteContainerKey;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PartyFormRow(
          children: [
            LabelledField(
              label: 'Business Name',
              isRequired: true,
              hintText: 'e.g. Acme Retailers',
              controller: businessNameController,
              errorText: businessNameError,
              focusNode: businessNameFocusNode,
              containerKey: businessNameContainerKey,
              fieldKey: const ValueKey('company-settings-business-name'),
            ),
            LabelledDropdown<BusinessType>(
              label: 'Business Type',
              keyValue: 'company-settings-business-type',
              value: businessType,
              focusNode: businessTypeFocusNode,
              containerKey: businessTypeContainerKey,
              items: [
                for (final type in BusinessType.values)
                  DropdownMenuItem(value: type, child: Text(type.label)),
              ],
              onChanged: (type) {
                if (type != null) onBusinessTypeChanged(type);
              },
            ),
          ],
        ),
        const SizedBox(height: 20),
        PartyFormRow(
          children: [
            SwitchField(
              title: 'GST Registered',
              description: 'Whether your business is registered for GST.',
              value: gstRegistered,
              onChanged: onGstRegisteredChanged,
              focusNode: gstRegisteredFocusNode,
            ),
            LabelledField(
              label: 'GSTIN',
              isRequired: gstinRequired,
              hintText: gstinRequired
                  ? 'Required — e.g. 27ABCDE1234F1Z5'
                  : 'e.g. 27ABCDE1234F1Z5',
              controller: gstinController,
              errorText: gstinError,
              focusNode: gstinFocusNode,
              containerKey: gstinContainerKey,
              fieldKey: const ValueKey('company-settings-gstin'),
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
              controller: panController,
              errorText: panError,
              focusNode: panFocusNode,
              containerKey: panContainerKey,
              fieldKey: const ValueKey('company-settings-pan'),
              inputFormatters: [
                const UpperCaseTextFormatter(),
                LengthLimitingTextInputFormatter(10),
              ],
            ),
            LabelledField(
              label: 'CIN',
              isRequired: cinRequired,
              hintText: 'Optional',
              controller: cinController,
              errorText: cinError,
              focusNode: cinFocusNode,
              containerKey: cinContainerKey,
              fieldKey: const ValueKey('company-settings-cin'),
              inputFormatters: [
                const UpperCaseTextFormatter(),
                LengthLimitingTextInputFormatter(21),
              ],
            ),
          ],
        ),
        const SizedBox(height: 20),
        PartyFormRow(
          children: [
            LabelledField(
              label: 'Phone',
              isRequired: true,
              hintText: 'e.g. 9876543210',
              controller: phoneController,
              errorText: phoneError,
              focusNode: phoneFocusNode,
              containerKey: phoneContainerKey,
              fieldKey: const ValueKey('company-settings-phone'),
              keyboardType: TextInputType.phone,
            ),
            LabelledField(
              label: 'Email',
              hintText: 'name@example.com',
              controller: emailController,
              errorText: emailError,
              focusNode: emailFocusNode,
              containerKey: emailContainerKey,
              fieldKey: const ValueKey('company-settings-email'),
              keyboardType: TextInputType.emailAddress,
            ),
          ],
        ),
        const SizedBox(height: 20),
        PartyFormRow(
          children: [
            LabelledField(
              label: 'Website',
              hintText: 'e.g. www.acme.com',
              controller: websiteController,
              errorText: websiteError,
              focusNode: websiteFocusNode,
              containerKey: websiteContainerKey,
              fieldKey: const ValueKey('company-settings-website'),
              keyboardType: TextInputType.url,
            ),
          ],
        ),
      ],
    );
  }
}
