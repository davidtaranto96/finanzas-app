import 'package:flutter_test/flutter_test.dart';
import 'package:sencillo/core/database/app_database.dart';
import 'package:sencillo/core/logic/transaction_service.dart';
import 'helpers/test_database.dart';

void main() {
  late AppDatabase db;
  late TransactionService service;

  setUp(() async {
    db = createTestDatabase();
    service = TransactionService(db);

    // Create a test account
    await db.into(db.accountsTable).insert(AccountsTableCompanion.insert(
      id: 'test_account',
      name: 'Test Account',
      type: 'cash',
    ));
  });

  tearDown(() async {
    await db.close();
  });

  group('TransactionService', () {
    test('addTransaction inserts a transaction', () async {
      await service.addTransaction(
        title: 'Test Expense',
        amount: 500.0,
        type: 'expense',
        categoryId: 'food',
        accountId: 'test_account',
      );

      final txs = await db.select(db.transactionsTable).get();
      expect(txs.length, 1);
      expect(txs.first.title, 'Test Expense');
      expect(txs.first.amount, 500.0);
      expect(txs.first.type, 'expense');
    });

    test('addTransaction with note', () async {
      await service.addTransaction(
        title: 'Lunch',
        amount: 200.0,
        type: 'expense',
        categoryId: 'food',
        accountId: 'test_account',
        note: 'con amigos',
      );

      final txs = await db.select(db.transactionsTable).get();
      expect(txs.first.note, 'con amigos');
    });

    test('addTransaction with custom date', () async {
      final date = DateTime(2026, 3, 15);
      await service.addTransaction(
        title: 'Past tx',
        amount: 100.0,
        type: 'income',
        categoryId: 'salary',
        accountId: 'test_account',
        date: date,
      );

      final txs = await db.select(db.transactionsTable).get();
      expect(txs.first.date.year, 2026);
      expect(txs.first.date.month, 3);
      expect(txs.first.date.day, 15);
    });

    test('updateTransaction updates fields', () async {
      await service.addTransaction(
        title: 'Original',
        amount: 100.0,
        type: 'expense',
        categoryId: 'food',
        accountId: 'test_account',
      );

      final txs = await db.select(db.transactionsTable).get();
      final id = txs.first.id;

      await service.updateTransaction(
        id: id,
        title: 'Updated',
        amount: 200.0,
      );

      final updated = await (db.select(db.transactionsTable)
            ..where((t) => t.id.equals(id)))
          .getSingle();
      expect(updated.title, 'Updated');
      expect(updated.amount, 200.0);
    });

    test('deleteTransaction removes it', () async {
      await service.addTransaction(
        title: 'To Delete',
        amount: 50.0,
        type: 'expense',
        categoryId: 'food',
        accountId: 'test_account',
      );

      final txs = await db.select(db.transactionsTable).get();
      expect(txs.length, 1);

      await service.deleteTransaction(txs.first.id);

      final after = await db.select(db.transactionsTable).get();
      expect(after.length, 0);
    });

    test('duplicateTransaction creates copy', () async {
      await service.addTransaction(
        title: 'Original TX',
        amount: 300.0,
        type: 'expense',
        categoryId: 'transport',
        accountId: 'test_account',
        note: 'uber',
      );

      final txs = await db.select(db.transactionsTable).get();
      await service.duplicateTransaction(txs.first.id);

      final all = await db.select(db.transactionsTable).get();
      expect(all.length, 2);
      expect(all[0].title, 'Original TX');
      expect(all[1].title, 'Original TX');
      expect(all[0].id, isNot(all[1].id));
    });

    test('addRetroactiveTransaction tags with [retroactivo]', () async {
      await service.addRetroactiveTransaction(
        title: 'Old expense',
        amount: 1000.0,
        type: 'expense',
        categoryId: 'food',
        accountId: 'test_account',
        date: DateTime(2026, 1, 15),
        note: 'January expense',
      );

      final txs = await db.select(db.transactionsTable).get();
      expect(txs.first.note, contains('[retroactivo]'));
      expect(txs.first.note, contains('January expense'));
    });
  });
}
