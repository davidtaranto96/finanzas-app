import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/goal.dart';
import '../../../../core/database/database_providers.dart';

final activeGoalsProvider = Provider<List<Goal>>((ref) {
  return ref.watch(goalsStreamProvider).valueOrNull
      ?.where((g) => !g.isCompleted).toList() ?? [];
});

final completedGoalsProvider = Provider<List<Goal>>((ref) {
  return ref.watch(goalsStreamProvider).valueOrNull
      ?.where((g) => g.isCompleted).toList() ?? [];
});
