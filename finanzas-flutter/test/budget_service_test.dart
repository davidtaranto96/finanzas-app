import 'package:flutter_test/flutter_test.dart';
import 'package:sencillo/core/database/app_database.dart';
import 'package:sencillo/core/logic/budget_service.dart';
import 'helpers/test_database.dart';

void main() {
  late AppDatabase db;
  late BudgetService service;

  setUp(() async {
    db = createTestDatabase();
    service = BudgetService(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('BudgetService', () {
    test('addBudgetForCategory creates budget and category', () async {
      await service.addBudgetForCategory(
        categoryId: 'food',
        categoryName: 'Comida',
        limitAmount: 50000.0,
        isFixed: false,
        colorValue: 0xFFFF8A65,
        iconKey: 'restaurant',
      );

      final budgets = await db.select(db.budgetsTable).get();
      expect(budgets.length, 1);
      expect(budgets.first.categoryId, 'food');
      expect(budgets.first.limitAmount, 50000.0);

      final cats = await db.select(db.categoriesTable).get();
      final foodCat = cats.where((c) => c.id == 'food').firstOrNull;
      expect(foodCat, isNotNull);
      expect(foodCat!.name, 'Comida');
    });

    test('addBudget creates category with UUID', () async {
      final budgetId = await service.addBudget(
        categoryName: 'Gaming',
        limitAmount: 10000.0,
        isFixed: true,
        colorValue: 0xFF4FC3F7,
        iconKey: 'sports_esports',
      );

      final budgets = await db.select(db.budgetsTable).get();
      expect(budgets.length, 1);
      expect(budgets.first.id, budgetId);
      expect(budgets.first.limitAmount, 10000.0);
    });

    test('updateBudget modifies limit', () async {
      await service.addBudgetForCategory(
        categoryId: 'transport',
        categoryName: 'Transporte',
        limitAmount: 20000.0,
        isFixed: false,
        colorValue: 0xFF4FC3F7,
        iconKey: 'directions_car',
      );

      final budgets = await db.select(db.budgetsTable).get();
      await service.updateBudget(
        budgets.first.id,
        'transport',
        limitAmount: 30000.0,
      );

      final updated = await db.select(db.budgetsTable).get();
      expect(updated.first.limitAmount, 30000.0);
    });

    test('deleteBudget removes budget and category', () async {
      await service.addBudgetForCategory(
        categoryId: 'entertainment',
        categoryName: 'Entretenimiento',
        limitAmount: 15000.0,
        isFixed: false,
        colorValue: 0xFFBA68C8,
        iconKey: 'movie',
      );

      final budgets = await db.select(db.budgetsTable).get();
      await service.deleteBudget(budgets.first.id, 'entertainment');

      final after = await db.select(db.budgetsTable).get();
      expect(after.length, 0);

      final cats = await db.select(db.categoriesTable).get();
      final found = cats.where((c) => c.id == 'entertainment');
      expect(found.isEmpty, true);
    });
  });
}
