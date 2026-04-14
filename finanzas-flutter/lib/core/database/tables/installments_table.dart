import 'package:drift/drift.dart';

/// Tracks credit card installment plans (cuotas).
/// Each row = one purchase split into installments.
@DataClassName('InstallmentEntry')
class InstallmentsTable extends Table {
  TextColumn get id => text()();
  TextColumn get accountId => text()(); // credit card account
  TextColumn get title => text().withLength(min: 1, max: 200)();
  RealColumn get totalAmount => real()(); // total purchase amount
  IntColumn get totalInstallments => integer()(); // e.g. 12
  IntColumn get paidInstallments => integer().withDefault(const Constant(0))();
  RealColumn get installmentAmount => real()(); // monthly amount
  DateTimeColumn get startDate => dateTime()(); // first installment
  TextColumn get note => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
