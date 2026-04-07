import 'package:drift/drift.dart' as drift;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/app_database.dart';
import '../database/database_providers.dart';
import 'people_service.dart';

/// Servicio de integridad de datos.
/// Detecta y corrige inconsistencias: balances de personas desincronizados,
/// transacciones huérfanas, totales de grupos incorrectos, etc.
///
/// Diseñado para ejecutarse en pull-to-refresh. Es idempotente y seguro.
class DataIntegrityService {
  final AppDatabase db;
  final PeopleService peopleService;

  DataIntegrityService(this.db, this.peopleService);

  /// Ejecuta todas las verificaciones y devuelve un resumen de lo corregido.
  Future<DataIntegrityReport> runFullCheck() async {
    final personsFixed = await peopleService.fixOrphanedPersonBalances();
    final groupsFixed = await _fixGroupTotals();

    return DataIntegrityReport(
      personsFixed: personsFixed,
      groupsFixed: groupsFixed,
    );
  }

  /// Recalcula el total de gastos de cada grupo desde las transacciones reales.
  Future<int> _fixGroupTotals() async {
    int fixed = 0;
    final groups = await db.select(db.groupsTable).get();

    for (final group in groups) {
      final txs = await (db.select(db.transactionsTable)
            ..where((t) => t.groupId.equals(group.id)))
          .get();

      final realTotal = txs.fold(
        0.0,
        (sum, tx) => sum + (tx.sharedTotalAmount ?? tx.amount),
      );

      if ((group.totalGroupExpense - realTotal).abs() > 0.01) {
        await (db.update(db.groupsTable)..where((t) => t.id.equals(group.id)))
            .write(GroupsTableCompanion(
          totalGroupExpense: drift.Value(realTotal),
        ));
        fixed++;
      }
    }
    return fixed;
  }
}

class DataIntegrityReport {
  final int personsFixed;
  final int groupsFixed;

  const DataIntegrityReport({
    required this.personsFixed,
    required this.groupsFixed,
  });

  bool get hadIssues => personsFixed > 0 || groupsFixed > 0;

  @override
  String toString() =>
      'DataIntegrityReport(personas: $personsFixed, grupos: $groupsFixed)';
}

final dataIntegrityServiceProvider = Provider<DataIntegrityService>((ref) {
  return DataIntegrityService(
    ref.watch(databaseProvider),
    ref.watch(peopleServiceProvider),
  );
});
