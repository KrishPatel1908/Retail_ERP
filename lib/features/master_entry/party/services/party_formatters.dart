import '../domain/party_enums.dart';

/// Pure formatting helpers shared by the customer and supplier modules.
///
/// All monetary values are stored as paise (integers) following the ERP
/// convention; only the presentation layer formats them back to rupees.
abstract final class PartyFormatters {
  static const String _rupee = '₹';

  /// Formats an amount stored in paise as Indian rupees, e.g. `₹12,345.67`.
  static String formatMoney(int paise) {
    final sign = paise < 0 ? '-' : '';
    final abs = paise.abs();
    final rupees = abs ~/ 100;
    final remaining = abs % 100;
    return '$sign$_rupee${_groupIndian(rupees.toString())}.'
        '${remaining.toString().padLeft(2, '0')}';
  }

  /// Formats an opening balance with its Dr/Cr suffix, e.g. `₹12,345.67 Dr`.
  ///
  /// A zero balance is shown without a suffix.
  static String formatBalance(int paise, BalanceType balanceType) {
    final amount = formatMoney(paise);
    if (paise == 0) return amount;
    return '$amount ${balanceType.shortLabel}';
  }

  /// Parses a user-entered rupee amount ("1234", "1,234.5") into paise.
  ///
  /// Returns `null` for blank input or anything that is not a non-negative
  /// amount with at most two decimal places.
  static int? parseRupeesToPaise(String input) {
    final normalized = input.trim().replaceAll(',', '');
    if (normalized.isEmpty) return null;
    final match = RegExp(r'^(\d+)(\.(\d{1,2}))?$').firstMatch(normalized);
    if (match == null) return null;
    final rupees = int.parse(match.group(1)!);
    final decimal = match.group(3);
    final paise = decimal == null ? 0 : int.parse(decimal.padRight(2, '0'));
    return rupees * 100 + paise;
  }

  /// Formats a [DateTime] into a clean readable string, e.g. `09 Aug 2026, 05:30 PM`.
  static String formatDateTime(DateTime dateTime) {
    final local = dateTime.toLocal();
    final day = local.day.toString().padLeft(2, '0');
    final monthNames = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final month = monthNames[local.month - 1];
    final year = local.year;
    final hourInt = local.hour % 12 == 0 ? 12 : local.hour % 12;
    final hour = hourInt.toString().padLeft(2, '0');
    final minute = local.minute.toString().padLeft(2, '0');
    final period = local.hour >= 12 ? 'PM' : 'AM';
    return '$day $month $year, $hour:$minute $period';
  }

  /// Formats a [DateTime] into a clean date string, e.g. `09/08/2026`.
  static String formatDate(DateTime dateTime) {
    final local = dateTime.toLocal();
    final day = local.day.toString().padLeft(2, '0');
    final month = local.month.toString().padLeft(2, '0');
    final year = local.year;
    return '$day/$month/$year';
  }

  /// Indian digit grouping: the last three digits, then groups of two.
  static String _groupIndian(String digits) {
    if (digits.length <= 3) return digits;
    final lastThree = digits.substring(digits.length - 3);
    var rest = digits.substring(0, digits.length - 3);
    final groups = <String>[];
    while (rest.length > 2) {
      groups.insert(0, rest.substring(rest.length - 2));
      rest = rest.substring(0, rest.length - 2);
    }
    if (rest.isNotEmpty) groups.insert(0, rest);
    return '${groups.join(',')},$lastThree';
  }
}
