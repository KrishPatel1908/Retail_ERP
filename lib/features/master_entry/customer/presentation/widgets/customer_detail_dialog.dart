import 'package:flutter/material.dart';

import '../../../../../app/theme/app_theme.dart';
import '../../../party/presentation/widgets/party_status_badge.dart';
import '../../../party/services/party_formatters.dart';
import '../../domain/entities/customer.dart';

/// Shows a read-only detail dialog for a [Customer].
Future<void> showCustomerDetailDialog(
  BuildContext context, {
  required Customer customer,
  VoidCallback? onEdit,
}) {
  return showDialog<void>(
    context: context,
    builder: (context) =>
        CustomerDetailDialog(customer: customer, onEdit: onEdit),
  );
}

/// Dedicated read-only customer detail dialog widget.
class CustomerDetailDialog extends StatelessWidget {
  const CustomerDetailDialog({super.key, required this.customer, this.onEdit});

  final Customer customer;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    String textOrDash(String? value) {
      if (value == null || value.trim().isEmpty) return '—';
      return value.trim();
    }

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 700, maxHeight: 750),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.person_outline_rounded,
                      color: colorScheme.onPrimaryContainer,
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                customer.customerName,
                                style: textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 12),
                            PartyStatusBadge(isActive: customer.isActive),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Customer Code: ${customer.customerCode}',
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    tooltip: 'Close',
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Divider(height: 1),
              const SizedBox(height: 16),

              // Content Body (Scrollable)
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Section 1: Basic Info
                      _buildSectionTitle(context, 'Basic Info'),
                      const SizedBox(height: 12),
                      _buildGrid([
                        _buildDetailItem(
                          context,
                          'Customer Code',
                          customer.customerCode,
                        ),
                        _buildDetailItem(
                          context,
                          'Customer Name',
                          customer.customerName,
                        ),
                        _buildDetailItem(
                          context,
                          'Status',
                          customer.isActive ? 'Active' : 'Inactive',
                        ),
                      ]),
                      const SizedBox(height: 20),

                      // Section 2: Contact Information
                      _buildSectionTitle(context, 'Contact Information'),
                      const SizedBox(height: 12),
                      _buildGrid([
                        _buildDetailItem(
                          context,
                          'Contact No.',
                          textOrDash(customer.mobile),
                        ),
                        _buildDetailItem(
                          context,
                          'Alternate Mobile',
                          textOrDash(customer.alternateMobile),
                        ),
                        _buildDetailItem(
                          context,
                          'Email',
                          textOrDash(customer.email),
                        ),
                        _buildDetailItem(
                          context,
                          'GST Number',
                          textOrDash(customer.gstNumber),
                        ),
                        _buildDetailItem(
                          context,
                          'PAN',
                          textOrDash(customer.panNumber),
                        ),
                      ]),
                      const SizedBox(height: 20),

                      // Section 3: Address
                      _buildSectionTitle(context, 'Address'),
                      const SizedBox(height: 12),
                      _buildGrid([
                        _buildDetailItem(
                          context,
                          'Address Line 1',
                          textOrDash(customer.addressLine1),
                        ),
                        _buildDetailItem(
                          context,
                          'Address Line 2',
                          textOrDash(customer.addressLine2),
                        ),
                        _buildDetailItem(
                          context,
                          'City',
                          textOrDash(customer.city),
                        ),
                        _buildDetailItem(
                          context,
                          'State',
                          textOrDash(customer.state),
                        ),
                        _buildDetailItem(
                          context,
                          'State Code',
                          textOrDash(customer.stateCode),
                        ),
                        _buildDetailItem(
                          context,
                          'Pincode',
                          textOrDash(customer.pincode),
                        ),
                        _buildDetailItem(
                          context,
                          'Country',
                          textOrDash(customer.country),
                        ),
                      ]),
                      const SizedBox(height: 20),

                      // Section 4: Financial Details
                      _buildSectionTitle(context, 'Financial Details'),
                      const SizedBox(height: 12),
                      _buildGrid([
                        _buildDetailItem(
                          context,
                          'Opening Balance',
                          PartyFormatters.formatBalance(
                            customer.openingBalance,
                            customer.balanceType,
                          ),
                        ),
                        _buildDetailItem(
                          context,
                          'Balance Type',
                          customer.balanceType.label,
                        ),
                        _buildDetailItem(
                          context,
                          'Outstanding Balance',
                          PartyFormatters.formatBalance(
                            customer.outstandingBalance,
                            customer.balanceType,
                          ),
                        ),
                        _buildDetailItem(
                          context,
                          'Payment Due Date',
                          customer.paymentDueDate == null
                              ? '—'
                              : PartyFormatters.formatDate(
                                  customer.paymentDueDate!,
                                ),
                        ),
                        _buildDetailItem(
                          context,
                          'Credit Limit',
                          customer.creditLimit == 0
                              ? '₹0.00'
                              : PartyFormatters.formatMoney(
                                  customer.creditLimit,
                                ),
                        ),
                      ]),
                      const SizedBox(height: 20),

                      // Section 5: Bank Details
                      _buildSectionTitle(context, 'Bank Details'),
                      const SizedBox(height: 12),
                      _buildGrid([
                        _buildDetailItem(
                          context,
                          'Account Name',
                          textOrDash(customer.accountName),
                        ),
                        _buildDetailItem(
                          context,
                          'Account Number',
                          textOrDash(customer.accountNumber),
                        ),
                        _buildDetailItem(
                          context,
                          'Bank Name',
                          textOrDash(customer.bankName),
                        ),
                        _buildDetailItem(
                          context,
                          'Branch Name',
                          textOrDash(customer.branchName),
                        ),
                        _buildDetailItem(
                          context,
                          'IFSC Code',
                          textOrDash(customer.ifscCode),
                        ),
                      ]),
                      const SizedBox(height: 20),

                      // Section 6: System Info
                      _buildSectionTitle(context, 'System Info'),
                      const SizedBox(height: 12),
                      _buildGrid([
                        _buildDetailItem(
                          context,
                          'Created Date',
                          PartyFormatters.formatDateTime(customer.createdAt),
                        ),
                        _buildDetailItem(
                          context,
                          'Updated Date',
                          PartyFormatters.formatDateTime(customer.updatedAt),
                        ),
                      ]),
                      const SizedBox(height: 12),
                      _buildDetailItem(
                        context,
                        'Notes',
                        textOrDash(customer.notes),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Divider(height: 1),
              const SizedBox(height: 16),

              // Footer Actions
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Close'),
                  ),
                  if (onEdit != null) ...[
                    const SizedBox(width: 12),
                    FilledButton.icon(
                      onPressed: onEdit,
                      icon: const Icon(Icons.edit_outlined, size: 18),
                      label: const Text('Edit Customer'),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
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
            color: AppTheme.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildGrid(List<Widget> children) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 480 ? 2 : 1;
        if (crossAxisCount == 1) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var i = 0; i < children.length; i++) ...[
                children[i],
                if (i < children.length - 1) const SizedBox(height: 12),
              ],
            ],
          );
        }

        final rows = <Widget>[];
        for (var i = 0; i < children.length; i += 2) {
          final first = children[i];
          final hasSecond = i + 1 < children.length;
          final second = hasSecond ? children[i + 1] : const SizedBox.shrink();

          rows.add(
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: first),
                const SizedBox(width: 16),
                Expanded(child: second),
              ],
            ),
          );
          if (i + 2 < children.length) {
            rows.add(const SizedBox(height: 12));
          }
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: rows,
        );
      },
    );
  }

  Widget _buildDetailItem(BuildContext context, String label, String value) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
      ],
    );
  }
}
