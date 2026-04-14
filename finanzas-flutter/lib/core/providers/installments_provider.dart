import 'package:drift/drift.dart' as drift;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../database/app_database.dart';
import '../providers/database_provider.dart';

/// Stream of all installments
final installmentsStreamProvider = StreamProvider<List<InstallmentEntry>>((ref) {
  final db = ref.watch(databaseProvider);
  return (db.select(db.installmentsTable)
        ..orderBy([(t) => drift.OrderingTerm.asc(t.startDate)]))
      .watch();
});

/// Installments for a specific account
final accountInstallmentsProvider =
    Provider.family<List<InstallmentEntry>, String>((ref, accountId) {
  final all = ref.watch(installmentsStreamProvider).valueOrNull ?? [];
  return all.where((i) => i.accountId == accountId).toList();
});

/// Total pending installment amount across all credit cards
final totalPendingInstallmentsProvider = Provider<double>((ref) {
  final all = ref.watch(installmentsStreamProvider).valueOrNull ?? [];
  double total = 0;
  for (final i in all) {
    final remaining = i.totalInstallments - i.paidInstallments;
    total += remaining * i.installmentAmount;
  }
  return total;
});

/// Service for CRUD operations on installments
class InstallmentService {
  final AppDatabase db;
  const InstallmentService(this.db);

  Future<void> add({
    required String accountId,
    required String title,
    required double totalAmount,
    required int totalInstallments,
    required double installmentAmount,
    int paidInstallments = 0,
    DateTime? startDate,
    String? note,
  }) async {
    await db.into(db.installmentsTable).insert(
      InstallmentsTableCompanion.insert(
        id: const Uuid().v4(),
        accountId: accountId,
        title: title,
        totalAmount: totalAmount,
        totalInstallments: totalInstallments,
        installmentAmount: installmentAmount,
        paidInstallments: drift.Value(paidInstallments),
        startDate: startDate ?? DateTime.now(),
        note: drift.Value(note),
      ),
    );
  }

  Future<void> markPaid(String id) async {
    final entry = await (db.select(db.installmentsTable)
          ..where((t) => t.id.equals(id)))
        .getSingle();
    final newPaid = entry.paidInstallments + 1;
    await (db.update(db.installmentsTable)..where((t) => t.id.equals(id)))
        .write(InstallmentsTableCompanion(
            paidInstallments: drift.Value(newPaid)));
  }

  Future<void> delete(String id) async {
    await (db.delete(db.installmentsTable)..where((t) => t.id.equals(id)))
        .go();
  }

  Future<void> update({
    required String id,
    String? title,
    int? paidInstallments,
    String? note,
  }) async {
    await (db.update(db.installmentsTable)..where((t) => t.id.equals(id)))
        .write(InstallmentsTableCompanion(
      title: title != null ? drift.Value(title) : const drift.Value.absent(),
      paidInstallments: paidInstallments != null
          ? drift.Value(paidInstallments)
          : const drift.Value.absent(),
      note: note != null ? drift.Value(note) : const drift.Value.absent(),
    ));
  }
}

final installmentServiceProvider = Provider<InstallmentService>((ref) {
  return InstallmentService(ref.read(databaseProvider));
});
