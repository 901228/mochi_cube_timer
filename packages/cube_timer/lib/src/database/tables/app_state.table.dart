import "package:drift/drift.dart";

import "../../../cube_timer.dart";

class PuzzleTypeConverter extends TypeConverter<Puzzle, String> {
  const PuzzleTypeConverter();

  @override
  Puzzle fromSql(String fromDb) => Puzzle.fromId(fromDb);

  @override
  String toSql(Puzzle value) => value.id;
}

/// What the app remembers between launches, as opposed to what the user set.
///
/// Single row, id 0, the same shape as [Settings]. Nothing here belongs on the
/// settings page: it is state the UI wrote as a side effect of being used.
@DataClassName("AppStateEntry")
class AppState extends Table {
  IntColumn get id => integer()();

  /// The puzzle whose scrambles are showing.
  TextColumn get puzzle => text().map(const PuzzleTypeConverter()).withDefault(const Constant("333"))();

  TextColumn get session => text().withDefault(const Constant("normal"))();

  @override
  Set<Column> get primaryKey => {id};
}
