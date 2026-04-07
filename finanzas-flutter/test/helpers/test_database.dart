import 'package:drift/native.dart';
import 'package:sencillo/core/database/app_database.dart';

/// Creates an in-memory AppDatabase for testing.
AppDatabase createTestDatabase() {
  return AppDatabase.forTesting(NativeDatabase.memory());
}
