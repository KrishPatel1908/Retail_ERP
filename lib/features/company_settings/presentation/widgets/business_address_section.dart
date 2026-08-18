import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../features/master_entry/party/presentation/widgets/party_form_sections.dart';
import '../../../../shared/widgets/labelled_field.dart';

/// "Business Address" section: the company's primary registered address.
class BusinessAddressSection extends StatelessWidget {
  const BusinessAddressSection({
    super.key,
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
              label: 'Address 1',
              isRequired: true,
              hintText: 'Street, building, area',
              controller: addressLine1Controller,
              errorText: addressLine1Error,
              focusNode: addressLine1FocusNode,
              containerKey: addressLine1ContainerKey,
              fieldKey: const ValueKey('company-settings-address-line-1'),
            ),
            LabelledField(
              label: 'Address 2',
              hintText: 'Optional',
              controller: addressLine2Controller,
              errorText: addressLine2Error,
              focusNode: addressLine2FocusNode,
              containerKey: addressLine2ContainerKey,
              fieldKey: const ValueKey('company-settings-address-line-2'),
            ),
          ],
        ),
        const SizedBox(height: 20),
        PartyFormRow(
          children: [
            LabelledField(
              label: 'City',
              isRequired: true,
              hintText: 'e.g. Mumbai',
              controller: cityController,
              errorText: cityError,
              focusNode: cityFocusNode,
              containerKey: cityContainerKey,
              fieldKey: const ValueKey('company-settings-city'),
            ),
            LabelledField(
              label: 'State',
              isRequired: true,
              hintText: 'e.g. Maharashtra',
              controller: stateController,
              errorText: stateError,
              focusNode: stateFocusNode,
              containerKey: stateContainerKey,
              fieldKey: const ValueKey('company-settings-state'),
            ),
          ],
        ),
        const SizedBox(height: 20),
        PartyFormRow(
          children: [
            LabelledField(
              label: 'Pincode',
              isRequired: true,
              hintText: 'e.g. 400001',
              controller: pincodeController,
              errorText: pincodeError,
              focusNode: pincodeFocusNode,
              containerKey: pincodeContainerKey,
              fieldKey: const ValueKey('company-settings-pincode'),
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
              fieldKey: const ValueKey('company-settings-country'),
            ),
          ],
        ),
      ],
    );
  }
}
