import 'package:drift/drift.dart';

@DataClassName('RecurringTransactionEntity')
class RecurringTransactionsTable extends Table {
  TextColumn get id => text()();
  TextColumn get title => text().withLength(min: 1, max: 200)();
  RealColumn get amount => real()();
  TextColumn get type => text()(); // expense, income, transfer
  TextColumn get categoryId => text()();
  TextColumn get accountId => text()();
  TextColumn get note => text().nullable()();
  TextColumn get frequency => text()(); // daily, weekly, biweekly, monthly, yearly
  DateTimeColumn get nextDate => dateTime()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
