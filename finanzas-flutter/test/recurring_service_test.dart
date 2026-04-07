import 'package:flutter_test/flutter_test.dart';
import 'package:sencillo/core/database/app_database.dart';
import 'package:sencillo/core/logic/recurring_service.dart';
import 'package:sencillo/core/logic/transaction_service.dart';
import 'helpers/test_database.dart';

void main() {
  late AppDatabase db;
  late RecurringService service;

  setUp(() async {
    db = createTestDatabase();
    final txService = TransactionService(db);
    service = RecurringService(db, txService);

    // Create test account
    await db.into(db.accountsTable).insert(AccountsTableCompanion.insert(
      id: 'test_account',
      name: 'Test Account',
      type: 'cash',
    ));
  });

  tearDown(() async {
    await db.close();
  });

  group('RecurringService', () {
    test('addRecurring creates entry', () async {
      await service.addRecurring(
        title: 'Netflix',
        amount: 5000,
        type: 'expense',
        categoryId: 'entertainment',
        accountId: 'test_account',
        frequency: 'monthly',
        nextDate: DateTime(2026, 5, 1),
      );

      final items = await db.select(db.recurringTransactionsTable).get();
      expect(items.length, 1);
      expect(items.first.title, 'Netflix');
      expect(items.first.frequency, 'monthly');
      expect(items.first.isActive, true);
    });

    test('deleteRecurring removes entry', () async {
      await service.addRecurring(
        title: 'Gym',
        amount: 15000,
        type: 'expense',
        categoryId: 'health',
        accountId: 'test_account',
        frequency: 'monthly',
        nextDate: DateTime(2026, 5, 1),
      );

      final items = await db.select(db.recurringTransactionsTable).get();
      await service.deleteRecurring(items.first.id);

      final after = await db.select(db.recurringTransactionsTable).get();
      expect(after.length, 0);
    });

    test('toggleActive pauses and resumes', () async {
      await service.addRecurring(
        title: 'Spotify',
        amount: 3000,
        type: 'expense',
        categoryId: 'entertainment',
        accountId: 'test_account',
        frequency: 'monthly',
        nextDate: DateTime(2026, 5, 1),
      );

      final items = await db.select(db.recurringTransactionsTable).get();
      expect(items.first.isActive, true);

      await service.toggleActive(items.first.id, false);
      final paused = await db.select(db.recurringTransactionsTable).get();
      expect(paused.first.isActive, false);

      await service.toggleActive(items.first.id, true);
      final resumed = await db.select(db.recurringTransactionsTable).get();
      expect(resumed.first.isActive, true);
    });

    test('processRecurrings creates transactions for past due dates', () async {
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      await service.addRecurring(
        title: 'Daily Coffee',
        amount: 500,
        type: 'expense',
        categoryId: 'food',
        accountId: 'test_account',
        frequency: 'daily',
        nextDate: DateTime(yesterday.year, yesterday.month, yesterday.day),
      );

      final created = await service.processRecurrings();
      expect(created, greaterThanOrEqualTo(1));

      final txs = await db.select(db.transactionsTable).get();
      expect(txs.isNotEmpty, true);
      expect(txs.first.title, 'Daily Coffee');
      expect(txs.first.note, contains('[recurrente]'));
    });

    test('processRecurrings does not process inactive items', () async {
      await service.addRecurring(
        title: 'Paused Sub',
        amount: 1000,
        type: 'expense',
        categoryId: 'entertainment',
        accountId: 'test_account',
        frequency: 'monthly',
        nextDate: DateTime.now().subtract(const Duration(days: 5)),
      );

      final items = await db.select(db.recurringTransactionsTable).get();
      await service.toggleActive(items.first.id, false);

      final created = await service.processRecurrings();
      expect(created, 0);
    });

    test('processRecurrings advances nextDate', () async {
      final threeDaysAgo = DateTime.now().subtract(const Duration(days: 3));
      await service.addRecurring(
        title: 'Weekly task',
        amount: 2000,
        type: 'expense',
        categoryId: 'services',
        accountId: 'test_account',
        frequency: 'weekly',
        nextDate: DateTime(threeDaysAgo.year, threeDaysAgo.month, threeDaysAgo.day),
      );

      await service.processRecurrings();

      final items = await db.select(db.recurringTransactionsTable).get();
      expect(items.first.nextDate.isAfter(DateTime.now().subtract(const Duration(days: 1))), true);
    });
  });
}
