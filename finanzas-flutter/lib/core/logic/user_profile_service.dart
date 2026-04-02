import 'package:drift/drift.dart' as drift;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/app_database.dart';
import '../providers/database_provider.dart';

class UserProfileService {
  final AppDatabase db;
  UserProfileService(this.db);

  static const _defaultId = 'user_profile_singleton';

  /// Gets or creates the single user profile row.
  Future<UserProfileEntity> getOrCreate() async {
    final existing = await (db.select(db.userProfileTable)
          ..where((t) => t.id.equals(_defaultId)))
        .getSingleOrNull();
    if (existing != null) return existing;

    await db.into(db.userProfileTable).insert(
      UserProfileTableCompanion.insert(id: _defaultId),
    );
    return (await (db.select(db.userProfileTable)
          ..where((t) => t.id.equals(_defaultId)))
        .getSingle());
  }

  /// Watch the profile as a stream.
  Stream<UserProfileEntity?> watchProfile() {
    return (db.select(db.userProfileTable)
          ..where((t) => t.id.equals(_defaultId)))
        .watchSingleOrNull();
  }

  Future<void> updateProfile({
    String? name,
    double? monthlySalary,
    int? payDay,
    bool clearSalary = false,
    bool clearPayDay = false,
  }) async {
    // Ensure row exists
    await getOrCreate();

    await (db.update(db.userProfileTable)
          ..where((t) => t.id.equals(_defaultId)))
        .write(UserProfileTableCompanion(
      name: name != null ? drift.Value(name) : const drift.Value.absent(),
      monthlySalary: clearSalary
          ? const drift.Value(null)
          : (monthlySalary != null
              ? drift.Value(monthlySalary)
              : const drift.Value.absent()),
      payDay: clearPayDay
          ? const drift.Value(null)
          : (payDay != null
              ? drift.Value(payDay)
              : const drift.Value.absent()),
    ));
  }
}

final userProfileServiceProvider = Provider<UserProfileService>((ref) {
  return UserProfileService(ref.watch(databaseProvider));
});
