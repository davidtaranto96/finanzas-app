import 'package:drift/drift.dart';

/// Scheduled future payments (rent, services, subscriptions with specific dates).
@DataClassName('ScheduledPaymentEntry')
class ScheduledPaymentsTable extends Table {
  TextColumn get id => text()();
  TextColumn get title => text().withLength(min: 1, max: 200)();
  RealColumn get amount => real()();
  TextColumn get accountId => text().nullable()(); // preferred account
  TextColumn get categoryId => text().nullable()();
  DateTimeColumn get dueDate => dateTime()(); // next due date
  TextColumn get frequency => text().withDefault(const Constant('monthly'))(); // once, weekly, monthly, yearly
  BoolColumn get autoPay => boolean().withDefault(const Constant(false))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  TextColumn get note => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
