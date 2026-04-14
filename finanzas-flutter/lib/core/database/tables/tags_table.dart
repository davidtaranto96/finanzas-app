import 'package:drift/drift.dart';

/// Custom tags for transactions (e.g. "viaje", "negocio", "freelance").
@DataClassName('TagEntry')
class TagsTable extends Table {
  TextColumn get id => text()();
  TextColumn get name => text().withLength(min: 1, max: 50)();
  IntColumn get colorValue => integer().nullable()();
  TextColumn get iconName => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Junction table: many-to-many between transactions and tags.
@DataClassName('TransactionTagEntry')
class TransactionTagsTable extends Table {
  TextColumn get transactionId => text()();
  TextColumn get tagId => text()();

  @override
  Set<Column> get primaryKey => {transactionId, tagId};
}
