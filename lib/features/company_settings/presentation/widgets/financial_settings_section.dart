import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../features/master_entry/party/presentation/widgets/party_form_sections.dart';
import '../../../../shared/utils/upper_case_text_formatter.dart';
import '../../../../shared/widgets/labelled_dropdown.dart';
import '../../../../shared/widgets/labelled_field.dart';

/// "Financial Settings" section: financial year, currency and rounding.
class FinancialSettingsSection extends StatelessWidget {
  const FinancialSettingsSection({
    super.key,
    required this.financialYearStartMonth,
    required this.onFinancialYearStartMonthChanged,
    this.financialYearStartFocusNode,
    this.financialYearStartContainerKey,
    required this.currencyCodeController,
    this.currencyCodeError,
    this.currencyCodeFocusNode,
    this.currencyCodeContainerKey,
    required this.currencySymbolController,
    this.currencySymbolError,
    this.currencySymbolFocusNode,
    this.currencySymbolContainerKey,
    required this.decimalPlaces,
    required this.onDecimalPlacesChanged,
    this.decimalPlacesFocusNode,
    this.decimalPlacesContainerKey,
  });

  static const List<String> _monthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  static const List<int> _decimalPlacesOptions = [0, 1, 2, 3];

  final int financialYearStartMonth;
  final ValueChanged<int> onFinancialYearStartMonthChanged;
  final FocusNode? financialYearStartFocusNode;
  final Key? financialYearStartContainerKey;

  final TextEditingController currencyCodeController;
  final String? currencyCodeError;
  final FocusNode? currencyCodeFocusNode;
  final Key? currencyCodeContainerKey;

  final TextEditingController currencySymbolController;
  final String? currencySymbolError;
  final FocusNode? currencySymbolFocusNode;
  final Key? currencySymbolContainerKey;

  final int decimalPlaces;
  final ValueChanged<int> onDecimalPlacesChanged;
  final FocusNode? decimalPlacesFocusNode;
  final Key? decimalPlacesContainerKey;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PartyFormRow(
          children: [
            LabelledDropdown<int>(
              label: 'Financial Year Start',
              keyValue: 'company-settings-financial-year',
              value: financialYearStartMonth,
              focusNode: financialYearStartFocusNode,
              containerKey: financialYearStartContainerKey,
              items: [
                for (var month = 1; month <= 12; month++)
                  DropdownMenuItem(
                    value: month,
                    child: Text(_monthNames[month - 1]),
                  ),
              ],
              onChanged: (month) {
                if (month != null) onFinancialYearStartMonthChanged(month);
              },
            ),
            LabelledField(
              label: 'Currency',
              hintText: 'e.g. INR',
              controller: currencyCodeController,
              errorText: currencyCodeError,
              focusNode: currencyCodeFocusNode,
              containerKey: currencyCodeContainerKey,
              fieldKey: const ValueKey('company-settings-currency-code'),
              inputFormatters: [
                const UpperCaseTextFormatter(),
                LengthLimitingTextInputFormatter(3),
              ],
            ),
          ],
        ),
        const SizedBox(height: 20),
        PartyFormRow(
          children: [
            LabelledField(
              label: 'Currency Symbol',
              hintText: 'e.g. \u20B9',
              controller: currencySymbolController,
              errorText: currencySymbolError,
              focusNode: currencySymbolFocusNode,
              containerKey: currencySymbolContainerKey,
              fieldKey: const ValueKey('company-settings-currency-symbol'),
              inputFormatters: [LengthLimitingTextInputFormatter(5)],
            ),
            LabelledDropdown<int>(
              label: 'Decimal Places',
              keyValue: 'company-settings-decimal-places',
              value: decimalPlaces,
              focusNode: decimalPlacesFocusNode,
              containerKey: decimalPlacesContainerKey,
              items: [
                for (final places in _decimalPlacesOptions)
                  DropdownMenuItem(value: places, child: Text('$places')),
              ],
              onChanged: (places) {
                if (places != null) onDecimalPlacesChanged(places);
              },
            ),
          ],
        ),
      ],
    );
  }
}
