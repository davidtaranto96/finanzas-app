import 'package:drift/drift.dart';

@DataClassName('UserProfileEntity')
class UserProfileTable extends Table {
  TextColumn get id => text()();
  TextColumn get name => text().nullable()();
  RealColumn get monthlySalary => real().nullable()();
  IntColumn get payDay => integer().nullable()(); // 1-31
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
