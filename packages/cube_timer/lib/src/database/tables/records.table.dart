import "package:drift/drift.dart";
import "package:uuid/uuid.dart";

import "converters.dart";
import "sessions.table.dart";

@DataClassName("RecordEntry")
@TableIndex(name: "records_session_puzzle", columns: {#session, #puzzle, #datetime})
class Records extends Table {
  /// uuid
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();

  /// puzzle
  TextColumn get puzzle => text().map(const PuzzleTypeConverter())();

  /// session id
  TextColumn get session => text().references(Sessions, #id)();

  /// scramble
  TextColumn get scramble => text()();

  /// Raw stopwatch reading in milliseconds, before any penalty is applied.
  IntColumn get time => integer()();

  /// The time the solve was recorded.
  DateTimeColumn get datetime => dateTime().withDefault(currentDateAndTime)();

  /// penalty
  TextColumn get penalty => text().map(const PenaltyTypeConverter())();

  /// comment
  TextColumn get comment => text().nullable()();

  /// Soft delete: set instead of removing the row, so the deletion itself can
  /// travel to other devices. Every query reading solves must exclude these.
  DateTimeColumn get deletedAt => dateTime().nullable()();

  /// archived
  BoolColumn get archived => boolean().withDefault(const Constant(false))();

  /// The algorithm set the solve practised, or null for an ordinary solve; the two are kept apart.
  TextColumn get algorithmSet => text().nullable()();

  /// The case of [algorithmSet] the scramble was made from, or null when it was typed in.
  TextColumn get algorithmCase => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
