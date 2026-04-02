import 'package:drift/drift.dart' as drift;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../database/app_database.dart';
import '../database/database_providers.dart';

class GoalService {
  final AppDatabase db;
  GoalService(this.db);

  Future<void> addGoal({
    required String name,
    required double targetAmount,
    required int colorValue,
    String iconName = 'flag',
    DateTime? deadline,
  }) async {
    await db.into(db.goalsTable).insert(
      GoalsTableCompanion.insert(
        id: const Uuid().v4(),
        name: name,
        targetAmount: targetAmount,
        colorValue: colorValue,
        iconName: drift.Value(iconName),
        deadline: deadline != null
            ? drift.Value(deadline)
            : const drift.Value.absent(),
      ),
    );
  }

  Future<void> updateGoal(
    String id, {
    String? name,
    double? targetAmount,
    double? currentAmount,
    int? colorValue,
    String? iconName,
    DateTime? deadline,
    bool clearDeadline = false,
  }) async {
    await (db.update(db.goalsTable)..where((t) => t.id.equals(id))).write(
      GoalsTableCompanion(
        name: name != null ? drift.Value(name) : const drift.Value.absent(),
        targetAmount: targetAmount != null
            ? drift.Value(targetAmount)
            : const drift.Value.absent(),
        currentAmount: currentAmount != null
            ? drift.Value(currentAmount)
            : const drift.Value.absent(),
        colorValue: colorValue != null
            ? drift.Value(colorValue)
            : const drift.Value.absent(),
        iconName: iconName != null
            ? drift.Value(iconName)
            : const drift.Value.absent(),
        deadline: clearDeadline
            ? const drift.Value(null)
            : (deadline != null
                ? drift.Value(deadline)
                : const drift.Value.absent()),
      ),
    );
  }

  Future<void> deleteGoal(String id) async {
    await (db.delete(db.goalsTable)..where((t) => t.id.equals(id))).go();
  }
}

final goalServiceProvider = Provider<GoalService>((ref) {
  return GoalService(ref.watch(databaseProvider));
});
