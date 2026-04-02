import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/budget.dart';
import '../../../../core/database/database_providers.dart';

final fixedBudgetsProvider = Provider<List<Budget>>((ref) {
  return ref.watch(budgetsStreamProvider).valueOrNull
      ?.where((b) => b.isFixed).toList() ?? [];
});

final variableBudgetsProvider = Provider<List<Budget>>((ref) {
  return ref.watch(budgetsStreamProvider).valueOrNull
      ?.where((b) => !b.isFixed).toList() ?? [];
});

final totalBudgetLimitProvider = Provider<double>((ref) {
  final list = ref.watch(budgetsStreamProvider).valueOrNull ?? [];
  return list.fold(0.0, (double sum, b) => sum + b.limitAmount);
});

final totalBudgetSpentProvider = Provider<double>((ref) {
  final list = ref.watch(budgetsStreamProvider).valueOrNull ?? [];
  return list.fold(0.0, (double sum, b) => sum + b.spentAmount);
});
