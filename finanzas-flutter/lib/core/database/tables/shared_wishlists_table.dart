import 'package:drift/drift.dart';

/// Shared wishlist items visible to friends (for gift suggestions).
@DataClassName('SharedWishlistEntry')
class SharedWishlistsTable extends Table {
  TextColumn get id => text()();
  TextColumn get ownerUserId => text()(); // who owns the wish
  TextColumn get wishlistItemId => text()(); // FK to wishlist_table
  TextColumn get title => text().withLength(min: 1, max: 200)();
  RealColumn get estimatedCost => real().withDefault(const Constant(0))();
  TextColumn get url => text().nullable()();
  TextColumn get note => text().nullable()(); // public note for friends
  BoolColumn get isVisible => boolean().withDefault(const Constant(true))(); // owner can hide
  TextColumn get claimedByUserId => text().nullable()(); // friend who claimed to gift this
  DateTimeColumn get sharedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
