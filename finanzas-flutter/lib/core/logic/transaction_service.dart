import 'package:drift/drift.dart' as drift;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/database/app_database.dart';
import '../../core/database/database_providers.dart';
import 'package:uuid/uuid.dart';

class TransactionService {
  final AppDatabase db;

  TransactionService(this.db);

  /// Adds a new transaction and updates the associated account balance.
  Future<void> addTransaction({
    required String title,
    required double amount,
    required String type, // 'income' or 'expense'
    required String categoryId,
    required String accountId,
    DateTime? date,
    String? note,
  }) async {
    await db.transaction(() async {
      // 1. Insert Transaction
      await db.into(db.transactionsTable).insert(TransactionsTableCompanion.insert(
        id: const Uuid().v4(),
        title: title,
        amount: amount,
        type: type,
        categoryId: categoryId,
        accountId: accountId,
        date: date ?? DateTime.now(),
        note: drift.Value(note),
      ));

      // 2. Update Account Balance
      final account = await (db.select(db.accountsTable)..where((t) => t.id.equals(accountId))).getSingle();
      
      double newBalance = account.initialBalance;
      if (type == 'expense') {
        newBalance -= amount;
      } else if (type == 'income') {
        newBalance += amount;
      }

      await (db.update(db.accountsTable)..where((t) => t.id.equals(accountId))).write(
        AccountsTableCompanion(
          initialBalance: drift.Value(newBalance),
        ),
      );
    });
  }
}

final transactionServiceProvider = Provider<TransactionService>((ref) {
  return TransactionService(ref.watch(databaseProvider));
});
