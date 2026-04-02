import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'tables/accounts_table.dart';
import 'tables/budgets_table.dart';
import 'tables/categories_table.dart';
import 'tables/goals_table.dart';
import 'tables/groups_table.dart';
import 'tables/persons_table.dart';
import 'tables/transactions_table.dart';
import 'tables/user_profile_table.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [
  AccountsTable,
  CategoriesTable,
  TransactionsTable,
  BudgetsTable,
  GoalsTable,
  PersonsTable,
  GroupsTable,
  UserProfileTable,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 4;

  /// Ensures a default "Efectivo" cash account exists.
  Future<void> ensureDefaultCashAccount() async {
    final existing = await (select(accountsTable)
          ..where((t) => t.isDefault.equals(true) & t.type.equals('cash')))
        .getSingleOrNull();
    if (existing != null) return;

    await into(accountsTable).insert(AccountsTableCompanion.insert(
      id: 'default_cash',
      name: 'Efectivo',
      type: 'cash',
      iconName: const Value('cash'),
      colorValue: const Value(0xFF4CAF50),
      isDefault: const Value(true),
    ));
  }

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (migrator) async {
      await migrator.createAll();
      await ensureDefaultCashAccount();
    },
    onUpgrade: (migrator, from, to) async {
      if (from < 2) {
        await migrator.addColumn(accountsTable, accountsTable.alias);
        await migrator.addColumn(accountsTable, accountsTable.cvu);
      }
      if (from < 3) {
        await migrator.addColumn(goalsTable, goalsTable.iconName);
      }
      if (from < 4) {
        await migrator.createTable(userProfileTable);
        await ensureDefaultCashAccount();
      }
    },
  );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'finanzas_app.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
