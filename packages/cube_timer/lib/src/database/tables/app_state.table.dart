import "package:drift/drift.dart";

import "converters.dart";
import "sessions.table.dart";

@DataClassName("AppStateEntry")
class AppState extends Table {
  IntColumn get id => integer()();

  /// current puzzle
  TextColumn get puzzle => text().map(const PuzzleTypeConverter()).withDefault(const Constant("333"))();

  /// current session, or [kDefaultSessionId] for the default session
  TextColumn get session => text().references(Sessions, #id).withDefault(const Constant(kDefaultSessionId))();

  /// show recent or archived records in records page
  BoolColumn get showArchived => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
