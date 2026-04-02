import 'package:drift/drift.dart' as drift;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../database/app_database.dart';
import '../database/database_providers.dart';

class BudgetService {
  final AppDatabase db;
  BudgetService(this.db);

  Future<void> addBudget({
    required String categoryName,
    required double limitAmount,
    required bool isFixed,
    required int colorValue,
    required String iconKey,
  }) async {
    await db.transaction(() async {
      final categoryId = const Uuid().v4();
      await db.into(db.categoriesTable).insert(
        CategoriesTableCompanion.insert(
          id: categoryId,
          name: categoryName,
          iconName: iconKey,
          colorValue: colorValue,
          isFixed: drift.Value(isFixed),
        ),
      );
      await db.into(db.budgetsTable).insert(
        BudgetsTableCompanion.insert(
          id: const Uuid().v4(),
          categoryId: categoryId,
          limitAmount: limitAmount,
        ),
      );
    });
  }

  Future<void> updateBudget(
    String budgetId,
    String categoryId, {
    String? categoryName,
    double? limitAmount,
    bool? isFixed,
    int? colorValue,
    String? iconKey,
  }) async {
    await db.transaction(() async {
      await (db.update(db.categoriesTable)
            ..where((t) => t.id.equals(categoryId)))
          .write(CategoriesTableCompanion(
        name: categoryName != null
            ? drift.Value(categoryName)
            : const drift.Value.absent(),
        iconName: iconKey != null
            ? drift.Value(iconKey)
            : const drift.Value.absent(),
        colorValue: colorValue != null
            ? drift.Value(colorValue)
            : const drift.Value.absent(),
        isFixed: isFixed != null
            ? drift.Value(isFixed)
            : const drift.Value.absent(),
      ));
      if (limitAmount != null) {
        await (db.update(db.budgetsTable)
              ..where((t) => t.id.equals(budgetId)))
            .write(BudgetsTableCompanion(
          limitAmount: drift.Value(limitAmount),
        ));
      }
    });
  }

  Future<void> deleteBudget(String budgetId, String categoryId) async {
    await db.transaction(() async {
      await (db.delete(db.budgetsTable)
            ..where((t) => t.id.equals(budgetId)))
          .go();
      await (db.delete(db.categoriesTable)
            ..where((t) => t.id.equals(categoryId)))
          .go();
    });
  }
}

final budgetServiceProvider = Provider<BudgetService>((ref) {
  return BudgetService(ref.watch(databaseProvider));
});
