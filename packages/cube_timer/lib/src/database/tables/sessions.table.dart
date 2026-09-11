import "package:drift/drift.dart";
import "package:uuid/uuid.dart";

const kDefaultSessionId = "default";

@DataClassName("SessionEntry")
class Sessions extends Table {
  /// uuid
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();

  /// session display name
  TextColumn get name => text()();

  /// session creation time
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  /// Soft delete, for the same reason as on Records: the deletion itself has
  /// to reach other devices.
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
