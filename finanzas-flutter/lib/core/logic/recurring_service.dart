import 'package:drift/drift.dart' as drift;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../database/app_database.dart';
import '../database/database_providers.dart';
import 'transaction_service.dart';

final recurringServiceProvider = Provider<RecurringService>((ref) {
  final db = ref.watch(databaseProvider);
  final txService = ref.watch(transactionServiceProvider);
  return RecurringService(db, txService);
});

class RecurringService {
  final AppDatabase db;
  final TransactionService txService;

  RecurringService(this.db, this.txService);

  Future<void> addRecurring({
    required String title,
    required double amount,
    required String type,
    required String categoryId,
    required String accountId,
    String? note,
    required String frequency,
    required DateTime nextDate,
  }) async {
    await db.into(db.recurringTransactionsTable).insert(
      RecurringTransactionsTableCompanion.insert(
        id: const Uuid().v4(),
        title: title,
        amount: amount,
        type: type,
        categoryId: categoryId,
        accountId: accountId,
        note: drift.Value(note),
        frequency: frequency,
        nextDate: nextDate,
        createdAt: DateTime.now(),
      ),
    );
  }

  Future<void> updateRecurring({
    required String id,
    String? title,
    double? amount,
    String? type,
    String? categoryId,
    String? accountId,
    String? note,
    String? frequency,
    DateTime? nextDate,
    bool? isActive,
  }) async {
    await (db.update(db.recurringTransactionsTable)
          ..where((t) => t.id.equals(id)))
        .write(RecurringTransactionsTableCompanion(
      title: title != null ? drift.Value(title) : const drift.Value.absent(),
      amount: amount != null ? drift.Value(amount) : const drift.Value.absent(),
      type: type != null ? drift.Value(type) : const drift.Value.absent(),
      categoryId: categoryId != null ? drift.Value(categoryId) : const drift.Value.absent(),
      accountId: accountId != null ? drift.Value(accountId) : const drift.Value.absent(),
      note: note != null ? drift.Value(note) : const drift.Value.absent(),
      frequency: frequency != null ? drift.Value(frequency) : const drift.Value.absent(),
      nextDate: nextDate != null ? drift.Value(nextDate) : const drift.Value.absent(),
      isActive: isActive != null ? drift.Value(isActive) : const drift.Value.absent(),
    ));
  }

  Future<void> deleteRecurring(String id) async {
    await (db.delete(db.recurringTransactionsTable)
          ..where((t) => t.id.equals(id)))
        .go();
  }

  Future<void> toggleActive(String id, bool active) async {
    await updateRecurring(id: id, isActive: active);
  }

  /// Process all active recurring transactions whose nextDate <= today.
  /// Creates the actual transactions and advances nextDate.
  Future<int> processRecurrings() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final items = await (db.select(db.recurringTransactionsTable)
          ..where((t) => t.isActive.equals(true))
          ..where((t) => t.nextDate.isSmallerOrEqualValue(today.add(const Duration(days: 1)))))
        .get();

    int created = 0;
    for (final item in items) {
      var date = item.nextDate;
      // Create transactions for all past due dates up to today
      while (!date.isAfter(today)) {
        await txService.addTransaction(
          title: item.title,
          amount: item.amount,
          type: item.type,
          categoryId: item.categoryId,
          accountId: item.accountId,
          date: date,
          note: item.note != null ? '${item.note} [recurrente]' : '[recurrente]',
        );
        created++;
        date = _advanceDate(date, item.frequency);
      }
      // Update nextDate
      await (db.update(db.recurringTransactionsTable)
            ..where((t) => t.id.equals(item.id)))
          .write(RecurringTransactionsTableCompanion(
        nextDate: drift.Value(date),
      ));
    }
    return created;
  }

  DateTime _advanceDate(DateTime current, String frequency) {
    return switch (frequency) {
      'daily' => current.add(const Duration(days: 1)),
      'weekly' => current.add(const Duration(days: 7)),
      'biweekly' => current.add(const Duration(days: 14)),
      'monthly' => DateTime(current.year, current.month + 1, current.day),
      'yearly' => DateTime(current.year + 1, current.month, current.day),
      _ => DateTime(current.year, current.month + 1, current.day),
    };
  }
}
