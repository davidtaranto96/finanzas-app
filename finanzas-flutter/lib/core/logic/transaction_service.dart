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

  /// Updates title, amount, and/or note of an existing transaction.
  /// If amount changes, adjusts the account balance accordingly.
  Future<void> updateTransaction({
    required String id,
    String? title,
    double? amount,
    String? note,
  }) async {
    await db.transaction(() async {
      final tx = await (db.select(db.transactionsTable)..where((t) => t.id.equals(id))).getSingle();

      // If amount changed, adjust account balance
      if (amount != null && amount != tx.amount) {
        final account = await (db.select(db.accountsTable)..where((t) => t.id.equals(tx.accountId))).getSingle();
        double balanceAdjust = 0;
        if (tx.type == 'expense') {
          balanceAdjust = tx.amount - amount; // old was subtracted, new needs to be subtracted
        } else if (tx.type == 'income') {
          balanceAdjust = amount - tx.amount; // old was added, new needs to be added
        }
        if (balanceAdjust != 0) {
          await (db.update(db.accountsTable)..where((t) => t.id.equals(tx.accountId))).write(
            AccountsTableCompanion(initialBalance: drift.Value(account.initialBalance + balanceAdjust)),
          );
        }
      }

      await (db.update(db.transactionsTable)..where((t) => t.id.equals(id))).write(
        TransactionsTableCompanion(
          title: title != null ? drift.Value(title) : const drift.Value.absent(),
          amount: amount != null ? drift.Value(amount) : const drift.Value.absent(),
          note: note != null ? drift.Value(note) : const drift.Value.absent(),
        ),
      );
    });
  }

  /// Deletes a transaction and reverses the account balance impact.
  Future<void> deleteTransaction(String id) async {
    await db.transaction(() async {
      final tx = await (db.select(db.transactionsTable)..where((t) => t.id.equals(id))).getSingle();
      final account = await (db.select(db.accountsTable)..where((t) => t.id.equals(tx.accountId))).getSingle();

      // Reverse the balance impact
      double newBalance = account.initialBalance;
      if (tx.type == 'expense') {
        newBalance += tx.amount; // was subtracted, add back
      } else if (tx.type == 'income') {
        newBalance -= tx.amount; // was added, subtract back
      }

      await (db.update(db.accountsTable)..where((t) => t.id.equals(tx.accountId))).write(
        AccountsTableCompanion(initialBalance: drift.Value(newBalance)),
      );

      await (db.delete(db.transactionsTable)..where((t) => t.id.equals(id))).go();
    });
  }

  /// Duplicates a transaction (creates a copy with new id and current date).
  Future<void> duplicateTransaction(String id) async {
    final tx = await (db.select(db.transactionsTable)..where((t) => t.id.equals(id))).getSingle();

    await addTransaction(
      title: tx.title,
      amount: tx.amount,
      type: tx.type,
      categoryId: tx.categoryId,
      accountId: tx.accountId,
      date: DateTime.now(),
      note: tx.note,
    );
  }
}

final transactionServiceProvider = Provider<TransactionService>((ref) {
  return TransactionService(ref.watch(databaseProvider));
});
