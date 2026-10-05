import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/search_field.dart';
import '../../../master_entry/customer/data/repositories/customer_repository.dart';
import '../../../master_entry/customer/domain/entities/customer.dart';
import '../../../master_entry/customer/presentation/pages/create_customer_page.dart';

/// Opens the customer selection dialog.
///
/// Returns the selected [Customer], or `null` if the user chose Walk-in Customer.
/// Returns the previous selection if dismissed without making a choice.
Future<Customer?> showCustomerPickerDialog(
  BuildContext context, {
  Customer? currentCustomer,
}) async {
  return showDialog<Customer?>(
    context: context,
    barrierDismissible: true,
    builder: (_) => CustomerPickerDialog(currentCustomer: currentCustomer),
  );
}

class CustomerPickerDialog extends StatefulWidget {
  const CustomerPickerDialog({super.key, this.currentCustomer});

  final Customer? currentCustomer;

  @override
  State<CustomerPickerDialog> createState() => _CustomerPickerDialogState();
}

class _CustomerPickerDialogState extends State<CustomerPickerDialog> {
  final CustomerRepository _repository = CustomerRepository();
  List<Customer> _customers = [];
  bool _loading = true;
  String _query = '';
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _loadCustomers();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _loadCustomers() async {
    setState(() => _loading = true);
    try {
      final page = await _repository.fetchPage(
        query: _query,
        pageSize: 30,
      );
      if (!mounted) return;
      setState(() {
        _customers = page.items.where((c) => c.isActive).toList();
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  void _onSearchChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 250), () {
      _query = query;
      _loadCustomers();
    });
  }

  Future<void> _addNewCustomer() async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) => Dialog(
        clipBehavior: Clip.antiAlias,
        insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 32),
        child: SizedBox(
          width: 860,
          height: 720,
          child: CreateCustomerPage(
            onSave: () {
              Navigator.of(dialogCtx).pop();
              _loadCustomers();
            },
            onCancel: () => Navigator.of(dialogCtx).pop(),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Dialog(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 680, maxHeight: 600),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Select Customer',
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    tooltip: 'Close',
                    onPressed: () => Navigator.of(context).pop(widget.currentCustomer),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Search & Add Actions
              Row(
                children: [
                  Expanded(
                    child: SearchField(
                      hintText: 'Search by name, mobile, code, GST...',
                      onChanged: _onSearchChanged,
                    ),
                  ),
                  const SizedBox(width: 12),
                  FilledButton.icon(
                    onPressed: _addNewCustomer,
                    icon: const Icon(Icons.person_add_rounded, size: 18),
                    label: const Text('New Customer'),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Walk-in Customer Option Banner
              InkWell(
                onTap: () => Navigator.of(context).pop(null),
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: widget.currentCustomer == null
                        ? AppTheme.selected
                        : AppTheme.hover,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: widget.currentCustomer == null
                          ? AppTheme.primary
                          : AppTheme.border,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.directions_walk_rounded,
                        color: widget.currentCustomer == null
                            ? AppTheme.primary
                            : AppTheme.textSecondary,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Walk-in Customer (Default)',
                              style: textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: widget.currentCustomer == null
                                    ? AppTheme.primary
                                    : AppTheme.textPrimary,
                              ),
                            ),
                            Text(
                              'Cash sale without customer account ledger tracking',
                              style: textTheme.bodySmall?.copyWith(
                                color: AppTheme.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (widget.currentCustomer == null)
                        const Icon(
                          Icons.check_circle_rounded,
                          color: AppTheme.primary,
                          size: 20,
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Customers List
              Expanded(
                child: _loading
                    ? const Center(child: CircularProgressIndicator())
                    : _customers.isEmpty
                        ? const Center(
                            child: EmptyState(
                              icon: Icons.person_search_rounded,
                              title: 'No customers found',
                              message: 'Try a different search term or add a new customer.',
                            ),
                          )
                        : Material(
                            color: Colors.transparent,
                            child: ListView.separated(
                            itemCount: _customers.length,
                            separatorBuilder: (_, _) => const Divider(
                              height: 1,
                              color: AppTheme.border,
                            ),
                            itemBuilder: (context, index) {
                              final customer = _customers[index];
                              final isSelected =
                                  widget.currentCustomer?.id == customer.id;

                              final balanceText = customer.outstandingBalance > 0
                                  ? '₹${(customer.outstandingBalance / 100).toStringAsFixed(2)} Dr'
                                  : '₹0.00';

                              return ListTile(
                                selected: isSelected,
                                selectedTileColor: AppTheme.selected,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                leading: CircleAvatar(
                                  backgroundColor: isSelected
                                      ? AppTheme.primary
                                      : AppTheme.hover,
                                  foregroundColor: isSelected
                                      ? Colors.white
                                      : AppTheme.textPrimary,
                                  child: Text(
                                    customer.customerName.isNotEmpty
                                        ? customer.customerName[0].toUpperCase()
                                        : '?',
                                    style: const TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                ),
                                title: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        customer.customerName,
                                        style: textTheme.bodyMedium?.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      balanceText,
                                      style: textTheme.bodySmall?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: customer.outstandingBalance > 0
                                            ? AppTheme.warning
                                            : AppTheme.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                                subtitle: Row(
                                  children: [
                                    Text(
                                      customer.customerCode,
                                      style: textTheme.bodySmall?.copyWith(
                                        color: AppTheme.textSecondary,
                                      ),
                                    ),
                                    if (customer.mobile != null &&
                                        customer.mobile!.isNotEmpty) ...[
                                      const Text(' • '),
                                      Text(
                                        customer.mobile!,
                                        style: textTheme.bodySmall?.copyWith(
                                          color: AppTheme.textSecondary,
                                        ),
                                      ),
                                    ],
                                    if (customer.city != null &&
                                        customer.city!.isNotEmpty) ...[
                                      const Text(' • '),
                                      Text(
                                        customer.city!,
                                        style: textTheme.bodySmall?.copyWith(
                                          color: AppTheme.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                                trailing: isSelected
                                    ? const Icon(
                                        Icons.check_circle_rounded,
                                        color: AppTheme.primary,
                                      )
                                    : OutlinedButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(customer),
                                        child: const Text('Select'),
                                      ),
                                onTap: () => Navigator.of(context).pop(customer),
                              );
                            },
                          ),
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
