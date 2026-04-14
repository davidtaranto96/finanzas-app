import 'package:drift/drift.dart';

/// Friend requests between users (for social features).
@DataClassName('FriendRequestEntry')
class FriendRequestsTable extends Table {
  TextColumn get id => text()();
  TextColumn get fromUserId => text()(); // sender uid
  TextColumn get toUserId => text()(); // receiver uid
  TextColumn get fromDisplayName => text().nullable()();
  TextColumn get fromPhotoUrl => text().nullable()();
  TextColumn get status => text().withDefault(const Constant('pending'))(); // pending, accepted, rejected
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get respondedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
