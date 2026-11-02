import "package:drift/drift.dart";

import "converters.dart";

/// The cases of an algorithm set left out of its practice; a set starts with every case in, so cases added
/// to it later are in too.
@DataClassName("PracticeExclusionEntry")
class PracticeExclusions extends Table {
  TextColumn get puzzle => text().map(const PuzzleTypeConverter())();
  TextColumn get algorithmSet => text()();
  TextColumn get algorithmCase => text()();

  @override
  Set<Column> get primaryKey => {puzzle, algorithmSet, algorithmCase};
}
