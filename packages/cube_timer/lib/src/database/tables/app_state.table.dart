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

  /// The algorithm set of [puzzle] being practised, or null for ordinary solves.
  TextColumn get algorithmSet => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
