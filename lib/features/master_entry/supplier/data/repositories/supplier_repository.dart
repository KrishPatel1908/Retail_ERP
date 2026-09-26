import 'package:drift/drift.dart';

import 'package:retail_erp/core/database/app_database.dart' as db;
import 'package:retail_erp/core/database/exceptions/database_exceptions.dart';

import '../../../party/data/party_repository_base.dart';
import '../../../party/domain/party_enums.dart';
import '../../../party/domain/party_query.dart';
import '../../../party/services/party_code_generator.dart';
import '../../domain/entities/supplier.dart';
import '../../domain/exceptions/supplier_exceptions.dart';

/// Data access for suppliers.
///
/// The single entry point the presentation layer uses to read and write
/// suppliers. Drift types never leak past this class: callers receive and
/// return [Supplier] domain entities only. List queries are paginated,
/// filtered and sorted in the database so the module stays fast with large
/// supplier bases.
class SupplierRepository extends PartyRepositoryBase {
  SupplierRepository({super.database});

  static const String _codePrefix = 'SUP';

  // --- Listing -------------------------------------------------------------

  /// Returns one page of suppliers matching [query], [filters] and [sort].
  ///
  /// [query] searches code, business name, mobile, GST number and city
  /// case-insensitively. [page] is 1-based and [pageSize] the number of rows
  /// per page.
  Future<PartyPage<Supplier>> fetchPage({
    String query = '',
    PartyFilters filters = const PartyFilters(),
    PartySortColumn sort = PartySortColumn.name,
    bool sortAscending = true,
    int page = 1,
    int pageSize = 25,
  }) async {
    final effectivePage = page < 1 ? 1 : page;
    final t = database.suppliers;
    final predicate = partyPredicate(
      code: t.supplierCode,
      name: t.supplierName,
      mobile: t.mobile,
      gst: t.gstNumber,
      city: t.city,
      state: t.state,
      isActive: t.isActive,
      createdAt: t.createdAt,
      email: t.email,
      pan: t.panNumber,
      addressLine1: t.addressLine1,
      addressLine2: t.addressLine2,
      pincode: t.pincode,
      contactPerson: t.contactPerson,
      openingBalance: t.openingBalance,
      balanceType: t.balanceType,
      paymentDueDate: t.paymentDueDate,
      normalizedQuery: query,
      filters: filters,
    );

    // Count query (only the aggregate, never the rows).
    final countExpr = t.id.count();
    final countQuery = database.selectOnly(database.suppliers)
      ..addColumns([countExpr]);
    if (predicate != null) countQuery.where(predicate);
    final total = (await countQuery.get()).single.read(countExpr) ?? 0;

    // Page query.
    final rowsQuery = database.select(database.suppliers);
    if (predicate != null) rowsQuery.where((_) => predicate);
    rowsQuery
      ..orderBy([
        (_) => partyOrderBy(
          code: t.supplierCode,
          name: t.supplierName,
          mobile: t.mobile,
          city: t.city,
          state: t.state,
          openingBalance: t.openingBalance,
          paymentDueDate: t.paymentDueDate,
          creditLimit: t.creditLimit,
          createdAt: t.createdAt,
          sort: sort,
          ascending: sortAscending,
        ),
      ])
      ..limit(pageSize, offset: (effectivePage - 1) * pageSize);

    final rows = await rowsQuery.get();
    return PartyPage(items: rows.map(_toEntity).toList(), totalCount: total);
  }

  /// Distinct, non-empty cities, case-insensitively sorted — for the city
  /// filter dropdown.
  Future<List<String>> distinctCities() {
    return distinctTextValues(table: 'supplier', column: 'city');
  }

  /// Distinct, non-empty states, case-insensitively sorted — for the state
  /// filter dropdown.
  Future<List<String>> distinctStates() {
    return distinctTextValues(table: 'supplier', column: 'state');
  }

  // --- Duplicate checks ----------------------------------------------------

  /// Whether another supplier already uses this GST number
  /// (case-insensitive). Blank values never collide.
  Future<bool> existsByGstNumber(String? gstNumber, {int? excludeId}) {
    final normalized = normalizeOptional(gstNumber)?.toLowerCase();
    if (normalized == null) return Future.value(false);
    return _existsWhere(
      (t) => t.gstNumber.lower().equals(normalized),
      excludeId: excludeId,
    );
  }

  /// Whether another supplier already uses this email (case-insensitive).
  /// Blank values never collide.
  Future<bool> existsByEmail(String? email, {int? excludeId}) {
    final normalized = normalizeOptional(email)?.toLowerCase();
    if (normalized == null) return Future.value(false);
    return _existsWhere(
      (t) => t.email.lower().equals(normalized),
      excludeId: excludeId,
    );
  }

  Future<bool> _existsWhere(
    Expression<bool> Function(db.$SuppliersTable t) matches, {
    int? excludeId,
  }) async {
    final t = database.suppliers;
    final condition = excludeId == null
        ? matches(t)
        : matches(t) & t.id.isNotValue(excludeId);
    final row = await (database.selectOnly(t)
          ..addColumns([t.id])
          ..where(condition)
          ..limit(1))
        .getSingleOrNull();
    return row != null;
  }

  // --- Mutations -----------------------------------------------------------

  /// Creates a supplier and returns the stored entity.
  ///
  /// The supplier code is generated sequentially and the row inserted inside
  /// one transaction, so two rapid creates can never compute the same code.
  /// Throws [SupplierDuplicateException] when the GST number or email is
  /// already taken.
  Future<Supplier> createSupplier({
    required String supplierName,
    String? contactPerson,
    String? mobile,
    String? alternateMobile,
    String? email,
    String? gstNumber,
    String? panNumber,
    String? addressLine1,
    String? addressLine2,
    String? city,
    String? state,
    String? stateCode,
    String? country,
    String? pincode,
    int creditLimit = 0,
    int openingBalance = 0,
    BalanceType balanceType = BalanceType.debit,
    DateTime? paymentDueDate,
    String? paymentTerms,
    String? accountName,
    String? accountNumber,
    String? bankName,
    String? branchName,
    String? ifscCode,
    String? notes,
    bool isActive = true,
  }) async {
    final trimmedName = supplierName.trim();
    final normalizedGst = normalizeOptional(gstNumber)?.toUpperCase();
    final normalizedEmail = normalizeOptional(email)?.toLowerCase();
    final normalizedPan = normalizeOptional(panNumber)?.toUpperCase();
    final normalizedIfsc = normalizeOptional(ifscCode)?.toUpperCase();

    await _rejectDuplicates(normalizedGst, normalizedEmail);

    try {
      final id = await database.transaction(() async {
        final code = await PartyCodeGenerator.nextCode(
          database,
          table: 'supplier',
          column: 'supplier_code',
          prefix: _codePrefix,
        );
        return database
            .into(database.suppliers)
            .insert(
              db.SuppliersCompanion.insert(
                supplierCode: code,
                supplierName: trimmedName,
                contactPerson: Value(normalizeOptional(contactPerson)),
                gstNumber: Value(normalizedGst),
                panNumber: Value(normalizedPan),
                mobile: Value(normalizeOptional(mobile)),
                alternateMobile: Value(normalizeOptional(alternateMobile)),
                email: Value(normalizedEmail),
                addressLine1: Value(normalizeOptional(addressLine1)),
                addressLine2: Value(normalizeOptional(addressLine2)),
                city: Value(normalizeOptional(city)),
                state: Value(normalizeOptional(state)),
                stateCode: Value(normalizeOptional(stateCode)),
                country: Value(normalizeOptional(country)),
                pincode: Value(normalizeOptional(pincode)),
                creditLimit: Value(creditLimit),
                openingBalance: Value(openingBalance),
                outstandingBalance: Value(openingBalance),
                balanceType: Value(balanceType.dbValue),
                paymentDueDate: Value(paymentDueDate),
                paymentTerms: Value(normalizeOptional(paymentTerms)),
                accountName: Value(normalizeOptional(accountName)),
                accountNumber: Value(normalizeOptional(accountNumber)),
                bankName: Value(normalizeOptional(bankName)),
                branchName: Value(normalizeOptional(branchName)),
                ifscCode: Value(normalizedIfsc),
                notes: Value(normalizeOptional(notes)),
                isActive: Value(isActive),
              ),
            );
      });
      return _toEntity(await _getById(id));
    } on Exception catch (error, stackTrace) {
      // A race between the pre-check and the insert lands here.
      if (isUniqueViolation(error)) {
        await _rejectDuplicates(normalizedGst, normalizedEmail);
      }
      throw DatabaseOperationException(
        'Failed to create supplier.',
        cause: error,
        stackTrace: stackTrace,
      );
    }
  }

  /// Updates an existing supplier and returns the updated entity.
  ///
  /// Throws [SupplierDuplicateException] when the new GST number or email
  /// collides with another supplier, and [SupplierNotFoundException] when the
  /// supplier no longer exists.
  Future<Supplier> updateSupplier(
    int id, {
    required String supplierName,
    String? contactPerson,
    String? mobile,
    String? alternateMobile,
    String? email,
    String? gstNumber,
    String? panNumber,
    String? addressLine1,
    String? addressLine2,
    String? city,
    String? state,
    String? stateCode,
    String? country,
    String? pincode,
    int creditLimit = 0,
    int openingBalance = 0,
    BalanceType balanceType = BalanceType.debit,
    DateTime? paymentDueDate,
    String? paymentTerms,
    String? accountName,
    String? accountNumber,
    String? bankName,
    String? branchName,
    String? ifscCode,
    String? notes,
    bool? isActive,
  }) async {
    final trimmedName = supplierName.trim();
    final normalizedGst = normalizeOptional(gstNumber)?.toUpperCase();
    final normalizedEmail = normalizeOptional(email)?.toLowerCase();
    final normalizedPan = normalizeOptional(panNumber)?.toUpperCase();
    final normalizedIfsc = normalizeOptional(ifscCode)?.toUpperCase();

    await _rejectDuplicates(normalizedGst, normalizedEmail, excludeId: id);

    try {
      final updatedRows =
          await (database.update(
            database.suppliers,
          )..where((t) => t.id.equals(id))).write(
            db.SuppliersCompanion(
              supplierName: Value(trimmedName),
              contactPerson: Value(normalizeOptional(contactPerson)),
              gstNumber: Value(normalizedGst),
              panNumber: Value(normalizedPan),
              mobile: Value(normalizeOptional(mobile)),
              alternateMobile: Value(normalizeOptional(alternateMobile)),
              email: Value(normalizedEmail),
              addressLine1: Value(normalizeOptional(addressLine1)),
              addressLine2: Value(normalizeOptional(addressLine2)),
              city: Value(normalizeOptional(city)),
              state: Value(normalizeOptional(state)),
              stateCode: Value(normalizeOptional(stateCode)),
              country: Value(normalizeOptional(country)),
              pincode: Value(normalizeOptional(pincode)),
              creditLimit: Value(creditLimit),
              openingBalance: Value(openingBalance),
              balanceType: Value(balanceType.dbValue),
              paymentDueDate: Value(paymentDueDate),
              paymentTerms: Value(normalizeOptional(paymentTerms)),
              accountName: Value(normalizeOptional(accountName)),
              accountNumber: Value(normalizeOptional(accountNumber)),
              bankName: Value(normalizeOptional(bankName)),
              branchName: Value(normalizeOptional(branchName)),
              ifscCode: Value(normalizedIfsc),
              notes: Value(normalizeOptional(notes)),
              isActive: isActive == null
                  ? const Value.absent()
                  : Value(isActive),
              updatedAt: Value(DateTime.now()),
            ),
          );
      if (updatedRows == 0) {
        throw SupplierNotFoundException(id);
      }
      return _toEntity(await _getById(id));
    } on SupplierNotFoundException {
      rethrow;
    } on Exception catch (error, stackTrace) {
      if (isUniqueViolation(error)) {
        await _rejectDuplicates(normalizedGst, normalizedEmail, excludeId: id);
      }
      throw DatabaseOperationException(
        'Failed to update supplier.',
        cause: error,
        stackTrace: stackTrace,
      );
    }
  }

  /// Permanently deletes a supplier.
  ///
  /// Throws [SupplierInUseException] when the supplier is referenced by
  /// transactions (purchases, payments, ledger). Those tables do not exist
  /// yet; [SupplierInUseException] is the single, future-proof guard the
  /// transaction modules will hook into.
  Future<void> deleteSupplier(int id) async {
    if (await _countTransactionReferences(id) > 0) {
      throw const SupplierInUseException();
    }
    try {
      await (database.delete(
        database.suppliers,
      )..where((t) => t.id.equals(id))).go();
    } on Exception catch (error, stackTrace) {
      if (isForeignKeyViolation(error)) {
        throw const SupplierInUseException();
      }
      throw DatabaseOperationException(
        'Failed to delete supplier.',
        cause: error,
        stackTrace: stackTrace,
      );
    }
  }

  // --- Internals -----------------------------------------------------------

  Future<void> _rejectDuplicates(
    String? normalizedGst,
    String? normalizedEmail, {
    int? excludeId,
  }) async {
    if (normalizedGst != null &&
        await existsByGstNumber(normalizedGst, excludeId: excludeId)) {
      throw const SupplierDuplicateException(SupplierDuplicateField.gstNumber);
    }
    if (normalizedEmail != null &&
        await existsByEmail(normalizedEmail, excludeId: excludeId)) {
      throw const SupplierDuplicateException(SupplierDuplicateField.email);
    }
  }

  /// All active suppliers sorted alphabetically by name.
  Future<List<Supplier>> fetchAllActive() async {
    final rows = await (database.select(database.suppliers)
          ..where((t) => t.isActive.equals(true))
          ..orderBy([(t) => OrderingTerm.asc(t.supplierName.lower())]))
        .get();
    return rows.map((r) => _toEntity(r)).toList();
  }

  /// Number of transactions referencing this supplier across purchases,
  /// purchase returns, and purchase financial transactions.
  Future<int> _countTransactionReferences(int id) async {
    final purchaseCount = await (database.selectOnly(database.purchases)
          ..addColumns([database.purchases.id.count()])
          ..where(database.purchases.supplierId.equals(id)))
        .map((row) => row.read(database.purchases.id.count()) ?? 0)
        .getSingle();

    final returnCount = await (database.selectOnly(database.purchaseReturns)
          ..addColumns([database.purchaseReturns.id.count()])
          ..where(database.purchaseReturns.supplierId.equals(id)))
        .map((row) => row.read(database.purchaseReturns.id.count()) ?? 0)
        .getSingle();

    final txnCount = await (database.selectOnly(database.purchaseTransactions)
          ..addColumns([database.purchaseTransactions.id.count()])
          ..where(database.purchaseTransactions.supplierId.equals(id)))
        .map((row) => row.read(database.purchaseTransactions.id.count()) ?? 0)
        .getSingle();

    return purchaseCount + returnCount + txnCount;
  }

  Future<db.Supplier> _getById(int id) async {
    final row = await (database.select(
      database.suppliers,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
    if (row == null) throw SupplierNotFoundException(id);
    return row;
  }

  Supplier _toEntity(db.Supplier row) {
    return Supplier(
      id: row.id,
      supplierCode: row.supplierCode,
      supplierName: row.supplierName,
      contactPerson: row.contactPerson,
      mobile: row.mobile,
      alternateMobile: row.alternateMobile,
      email: row.email,
      gstNumber: row.gstNumber,
      panNumber: row.panNumber,
      addressLine1: row.addressLine1,
      addressLine2: row.addressLine2,
      city: row.city,
      state: row.state,
      stateCode: row.stateCode,
      country: row.country,
      pincode: row.pincode,
      creditLimit: row.creditLimit,
      openingBalance: row.openingBalance,
      balanceType: BalanceType.fromDbValue(row.balanceType),
      outstandingBalance: row.outstandingBalance,
      paymentDueDate: row.paymentDueDate,
      paymentTerms: row.paymentTerms,
      accountName: row.accountName,
      accountNumber: row.accountNumber,
      bankName: row.bankName,
      branchName: row.branchName,
      ifscCode: row.ifscCode,
      notes: row.notes,
      isActive: row.isActive,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }
}
