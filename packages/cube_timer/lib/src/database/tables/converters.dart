import "package:drift/drift.dart";

import "../../puzzle/puzzle.dart";

class PuzzleTypeConverter extends TypeConverter<Puzzle, String> {
  const PuzzleTypeConverter();

  @override
  Puzzle fromSql(String fromDb) => Puzzle.fromId(fromDb);

  @override
  String toSql(Puzzle value) => value.id;
}

class PenaltyTypeConverter extends TypeConverter<Penalty, String> {
  const PenaltyTypeConverter();

  @override
  Penalty fromSql(String fromDb) => Penalty.values.firstWhere((p) => p.name == fromDb);

  @override
  String toSql(Penalty value) => value.name;
}
