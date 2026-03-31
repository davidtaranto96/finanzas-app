import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_database.dart';
import '../../features/accounts/domain/models/account.dart' as dom;
import '../../features/transactions/domain/models/transaction.dart' as dom_tx;
import '../../features/people/domain/models/person.dart' as dom_p;
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

// Accounts Stream
final accountsStreamProvider = StreamProvider<List<dom.Account>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.select(db.accountsTable).watch().map((entities) {
    return entities.map((e) {
      return dom.Account(
        id: e.id,
        name: e.name,
        type: _parseAccountType(e.type),
        balance: e.initialBalance, // We use initialBalance as the current balance in this schema
        currencyCode: e.currencyCode,
        icon: e.iconName,
        color: e.colorValue != null ? '#${e.colorValue!.toRadixString(16)}' : null,
        isDefault: e.isDefault,
        closingDay: e.closingDay,
        dueDay: e.dueDay,
        creditLimit: e.creditLimit,
        pendingStatementAmount: e.pendingStatementAmount,
        lastClosedDate: e.lastClosedDate,
      );
    }).toList();
  });
});

// Transactions Stream
final transactionsStreamProvider = StreamProvider<List<dom_tx.Transaction>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.select(db.transactionsTable).watch().map((entities) {
    return entities.map((e) {
      return dom_tx.Transaction(
        id: e.id,
        title: e.title,
        amount: e.amount,
        type: _parseTransactionType(e.type),
        categoryId: e.categoryId,
        accountId: e.accountId,
        date: e.date,
        note: e.note,
        personId: e.personId,
        groupId: e.groupId,
        isShared: e.isShared,
        sharedTotalAmount: e.sharedTotalAmount,
        sharedOwnAmount: e.sharedOwnAmount,
        sharedOtherAmount: e.sharedOtherAmount,
        sharedRecovered: e.sharedRecovered,
      );
    }).toList();
  });
});

// People Stream
final peopleStreamProvider = StreamProvider<List<dom_p.Person>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.select(db.personsTable).watch().map((entities) {
    return entities.map((e) {
      return dom_p.Person(
        id: e.id,
        name: e.name,
        alias: e.alias,
        totalBalance: e.totalBalance,
        avatarColor: Color(e.colorValue ?? 0xFF7C6EF7),
      );
    }).toList();
  });
});

final globalPeopleBalanceProvider = Provider<double>((ref) {
  final peopleAsync = ref.watch(peopleStreamProvider);
  return peopleAsync.when(
    data: (list) => list.fold(0.0, (sum, p) => sum + p.totalBalance),
    loading: () => 0.0,
    error: (_, __) => 0.0,
  );
});

dom.AccountType _parseAccountType(String type) {
  return dom.AccountType.values.firstWhere(
    (e) => e.name == type,
    orElse: () => dom.AccountType.bank,
  );
}

dom_tx.TransactionType _parseTransactionType(String type) {
  return dom_tx.TransactionType.values.firstWhere(
    (e) => e.name == type,
    orElse: () => dom_tx.TransactionType.expense,
  );
}
