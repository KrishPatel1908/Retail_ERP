import 'package:drift/drift.dart';

/// Document number sequences (approved blueprint §4.1).
///
/// One row per document type (INVOICE, PURCHASE, RECEIPT, ...). The next
/// number is allocated atomically inside the document transaction.
@DataClassName('DocumentNumberSequence')
class DocumentNumberSequences extends Table {
  /// SQL table name from the approved blueprint.
  @override
  String get tableName => 'document_number_sequence';

  IntColumn get id => integer().autoIncrement()();
  TextColumn get documentType => text().unique()();
  TextColumn get prefix => text()();
  TextColumn get suffix => text().nullable()();
  IntColumn get lastNumber => integer().withDefault(const Constant(0))();
  IntColumn get padding => integer().withDefault(const Constant(4))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
