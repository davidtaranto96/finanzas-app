import 'package:drift/drift.dart' as drift;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/database/app_database.dart';
import '../../core/database/database_providers.dart';
import 'package:uuid/uuid.dart';

class PeopleService {
  final AppDatabase db;

  PeopleService(this.db);

  /// Liquidates (pays) a debt with a person.
  /// If amount > 0, they paid us (MP increases).
  /// If amount < 0, we paid them (MP decreases).
  Future<void> liquidateDebt({
    required String personId,
    required double amount,
    required String accountId,
  }) async {
    await db.transaction(() async {
      // 1. Update Person Balance
      final person = await (db.select(db.personsTable)..where((t) => t.id.equals(personId))).getSingle();
      await (db.update(db.personsTable)..where((t) => t.id.equals(personId))).write(
        PersonsTableCompanion(
          totalBalance: drift.Value(person.totalBalance - amount),
        ),
      );

      // 2. Update Account Balance
      final account = await (db.select(db.accountsTable)..where((t) => t.id.equals(accountId))).getSingle();
      await (db.update(db.accountsTable)..where((t) => t.id.equals(accountId))).write(
        AccountsTableCompanion(
          initialBalance: drift.Value(account.initialBalance + amount),
        ),
      );

      // 3. Record Transaction
      await db.into(db.transactionsTable).insert(TransactionsTableCompanion.insert(
        id: const Uuid().v4(),
        title: 'Liquidación: ${person.name}',
        amount: amount.abs(),
        type: amount > 0 ? 'income' : 'expense',
        categoryId: 'cat_peer_to_peer',
        accountId: accountId,
        date: DateTime.now(),
        personId: drift.Value(personId),
      ));
    });
  }
}

final peopleServiceProvider = Provider<PeopleService>((ref) {
  return PeopleService(ref.watch(databaseProvider));
});
