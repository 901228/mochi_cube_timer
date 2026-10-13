import "package:drift/drift.dart";

import "../../puzzle/puzzle.dart";
import "../../timer/alert.dart";

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

/// Stored by name, comma separated, so reordering the enum does not change what is read back;
/// a name no longer in it is dropped.
class AlertTypesConverter extends TypeConverter<Set<AlertType>, String> {
  const AlertTypesConverter();

  @override
  Set<AlertType> fromSql(String fromDb) => {
    for (final name in fromDb.split(",")) ?AlertType.values.asNameMap()[name],
  };

  @override
  String toSql(Set<AlertType> value) => AlertType.values.where(value.contains).map((e) => e.name).join(",");
}
