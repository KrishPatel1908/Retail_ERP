import '../../../party/domain/party_enums.dart';

/// Domain model of a customer.
///
/// This is the only shape the presentation layer sees. Drift row classes are
/// mapped to this entity inside the repository, so no Drift type ever leaks
/// into UI code. Monetary values are stored as paise.
class Customer {
  const Customer({
    required this.id,
    required this.customerCode,
    required this.customerName,
    this.mobile,
    this.alternateMobile,
    this.email,
    this.gstNumber,
    this.panNumber,
    this.addressLine1,
    this.addressLine2,
    this.city,
    this.state,
    this.stateCode,
    this.country,
    this.pincode,
    required this.creditLimit,
    required this.openingBalance,
    required this.balanceType,
    required this.outstandingBalance,
    this.paymentDueDate,
    this.accountName,
    this.accountNumber,
    this.bankName,
    this.branchName,
    this.ifscCode,
    this.notes,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;

  /// Auto-generated, unique code (e.g. `CUS00001`).
  final String customerCode;

  final String customerName;

  final String? mobile;
  final String? alternateMobile;
  final String? email;
  final String? gstNumber;
  final String? panNumber;
  final String? addressLine1;
  final String? addressLine2;
  final String? city;
  final String? state;

  /// Two-digit state code derived from the GST number (kept for future GST
  /// reports; not edited through the UI).
  final String? stateCode;

  final String? country;
  final String? pincode;

  /// Maximum credit allowed, in paise.
  final int creditLimit;

  /// Opening balance, in paise.
  final int openingBalance;

  final BalanceType balanceType;

  /// Cached balance maintained by the future transaction engine; initialised
  /// from the opening balance at creation.
  final int outstandingBalance;

  final DateTime? paymentDueDate;

  final String? accountName;
  final String? accountNumber;
  final String? bankName;
  final String? branchName;
  final String? ifscCode;

  final String? notes;

  final bool isActive;

  final DateTime createdAt;
  final DateTime updatedAt;
}
