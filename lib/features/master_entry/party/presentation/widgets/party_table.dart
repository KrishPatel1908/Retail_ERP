import 'package:flutter/material.dart';

import '../../../../../app/theme/app_theme.dart';
import '../../../../../shared/widgets/app_data_table.dart';
import '../../../../../shared/widgets/table_action_button.dart';
import '../../domain/party_enums.dart';
import '../../services/party_formatters.dart';
import 'party_status_badge.dart';

/// Shared data table for the customer and supplier list pages.
class PartyTable<T> extends StatelessWidget {
  const PartyTable({
    super.key,
    required this.items,
    required this.totalCount,
    required this.page,
    required this.pageSize,
    required this.onPageChanged,
    required this.onPageSizeChanged,
    required this.codeOf,
    required this.nameOf,
    required this.mobileOf,
    required this.cityOf,
    required this.stateOf,
    required this.openingBalanceOf,
    required this.balanceTypeOf,
    required this.creditLimitOf,
    required this.paymentDueDateOf,
    required this.createdAtOf,
    required this.isActiveOf,
    required this.idOf,
    this.codeHeaderLabel = 'Code',
    this.nameHeaderLabel = 'Name',
    this.onView,
    required this.onEdit,
    required this.onDelete,
    required this.keyPrefix,
    this.sortColumnIndex,
    this.sortAscending = true,
    this.onSort,
    this.isLoading = false,
    this.emptyWidget,
  });

  final List<T> items;
  final int totalCount;
  final int page;
  final int pageSize;
  final ValueChanged<int> onPageChanged;
  final ValueChanged<int> onPageSizeChanged;

  final String Function(T item) codeOf;
  final String Function(T item) nameOf;
  final String? Function(T item) mobileOf;
  final String? Function(T item) cityOf;
  final String? Function(T item) stateOf;
  final int Function(T item) openingBalanceOf;
  final BalanceType Function(T item) balanceTypeOf;
  final int Function(T item) creditLimitOf;
  final DateTime? Function(T item) paymentDueDateOf;
  final DateTime Function(T item) createdAtOf;
  final bool Function(T item) isActiveOf;
  final int Function(T item) idOf;

  final String codeHeaderLabel;
  final String nameHeaderLabel;

  final ValueChanged<T>? onView;
  final ValueChanged<T> onEdit;
  final ValueChanged<T> onDelete;

  /// Prefix for the action-button keys, e.g. `customer` → `edit-customer-3`.
  final String keyPrefix;

  final int? sortColumnIndex;
  final bool sortAscending;
  final void Function(int columnIndex, bool ascending)? onSort;
  final bool isLoading;
  final Widget? emptyWidget;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final normalStyle = textTheme.bodyMedium?.copyWith(
      fontWeight: FontWeight.w400,
      color: AppTheme.textPrimary,
    );
    final mutedStyle = textTheme.bodyMedium?.copyWith(
      fontWeight: FontWeight.w400,
      color: colorScheme.onSurfaceVariant,
    );
    final primaryStyle = textTheme.bodyMedium?.copyWith(
      fontWeight: FontWeight.w600,
      color: AppTheme.textPrimary,
    );
    final monetaryStyle = textTheme.bodyMedium?.copyWith(
      fontWeight: FontWeight.w500,
      color: AppTheme.textPrimary,
    );

    String dash(String? value) =>
        (value == null || value.trim().isEmpty) ? '—' : value.trim();

    String formatDate(DateTime? date) {
      if (date == null) return '—';
      final local = date.toLocal();
      final day = local.day.toString().padLeft(2, '0');
      final month = local.month.toString().padLeft(2, '0');
      final year = local.year;
      return '$day/$month/$year';
    }

    final columns = <AppDataTableColumn<T>>[
      // 1. Action
      AppDataTableColumn<T>(
        label: 'Action',
        width: 140,
        alignment: Alignment.centerLeft,
        cellBuilder: (context, item) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (onView != null) ...[
                TableActionButton(
                  key: ValueKey('view-$keyPrefix-${idOf(item)}'),
                  tooltip: 'View',
                  icon: Icons.visibility_outlined,
                  hoverColor: AppTheme.primary.withValues(alpha: 0.1),
                  iconColor: AppTheme.primary,
                  onPressed: () => onView!(item),
                ),
                const SizedBox(width: 4),
              ],
              TableActionButton(
                key: ValueKey('edit-$keyPrefix-${idOf(item)}'),
                tooltip: 'Edit',
                icon: Icons.edit_outlined,
                hoverColor: AppTheme.primary.withValues(alpha: 0.1),
                iconColor: AppTheme.primary,
                onPressed: () => onEdit(item),
              ),
              const SizedBox(width: 4),
              TableActionButton(
                key: ValueKey('delete-$keyPrefix-${idOf(item)}'),
                tooltip: 'Delete',
                icon: Icons.delete_outline_rounded,
                hoverColor: AppTheme.danger.withValues(alpha: 0.1),
                iconColor: AppTheme.danger,
                onPressed: () => onDelete(item),
              ),
            ],
          );
        },
      ),
      // 2. Code
      AppDataTableColumn<T>(
        label: codeHeaderLabel,
        flex: 2,
        minWidth: 120,
        sortable: true,
        cellBuilder: (context, item) {
          return Text(
            codeOf(item),
            style: primaryStyle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          );
        },
      ),
      // 3. Status
      AppDataTableColumn<T>(
        label: 'Status',
        width: 110,
        cellBuilder: (context, item) {
          return PartyStatusBadge(isActive: isActiveOf(item));
        },
      ),
      // 4. Name
      AppDataTableColumn<T>(
        label: nameHeaderLabel,
        flex: 3,
        minWidth: 160,
        sortable: true,
        cellBuilder: (context, item) {
          return Text(
            nameOf(item),
            style: primaryStyle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          );
        },
      ),
      // 5. Contact No.
      AppDataTableColumn<T>(
        label: 'Contact No.',
        flex: 2,
        minWidth: 120,
        sortable: true,
        cellBuilder: (context, item) {
          final val = mobileOf(item);
          return Text(
            dash(val),
            style: val == null || val.trim().isEmpty ? mutedStyle : normalStyle,
          );
        },
      ),
      // 6. Opening Balance
      AppDataTableColumn<T>(
        label: 'Opening Balance',
        flex: 2,
        minWidth: 140,
        sortable: true,
        cellBuilder: (context, item) {
          return Text(
            PartyFormatters.formatBalance(
              openingBalanceOf(item),
              balanceTypeOf(item),
            ),
            style: monetaryStyle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          );
        },
      ),
      // 7. Payment Due Date
      AppDataTableColumn<T>(
        label: 'Payment Due Date',
        flex: 2,
        minWidth: 130,
        sortable: true,
        cellBuilder: (context, item) {
          final due = paymentDueDateOf(item);
          return Text(
            formatDate(due),
            style: due == null ? mutedStyle : normalStyle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          );
        },
      ),
      // 8. City
      AppDataTableColumn<T>(
        label: 'City',
        flex: 2,
        minWidth: 120,
        sortable: true,
        cellBuilder: (context, item) {
          final val = cityOf(item);
          return Text(
            dash(val),
            style: val == null || val.trim().isEmpty ? mutedStyle : normalStyle,
          );
        },
      ),
      // 9. State
      AppDataTableColumn<T>(
        label: 'State',
        flex: 2,
        minWidth: 120,
        sortable: true,
        cellBuilder: (context, item) {
          final val = stateOf(item);
          return Text(
            dash(val),
            style: val == null || val.trim().isEmpty ? mutedStyle : normalStyle,
          );
        },
      ),
      // 10. Credit Limit
      AppDataTableColumn<T>(
        label: 'Credit Limit',
        flex: 2,
        minWidth: 130,
        sortable: true,
        cellBuilder: (context, item) {
          final limit = creditLimitOf(item);
          return Text(
            limit == 0 ? '₹0.00' : PartyFormatters.formatMoney(limit),
            style: monetaryStyle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          );
        },
      ),
      // 11. Created Date
      AppDataTableColumn<T>(
        label: 'Created Date',
        flex: 2,
        minWidth: 120,
        sortable: true,
        cellBuilder: (context, item) {
          return Text(
            formatDate(createdAtOf(item)),
            style: normalStyle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          );
        },
      ),
    ];

    return AppDataTable<T>(
      items: items,
      columns: columns,
      keyExtractor: (item) => idOf(item),
      sortColumnIndex: sortColumnIndex,
      sortAscending: sortAscending,
      onSort: onSort,
      page: page,
      pageSize: pageSize,
      totalItems: totalCount,
      onPageChanged: onPageChanged,
      onPageSizeChanged: onPageSizeChanged,
      showPagination: true,
      isLoading: isLoading,
      emptyWidget: emptyWidget,
      rowHeight: 52.0,
      headerHeight: 44.0,
      minWidth: 1400.0,
    );
  }
}
