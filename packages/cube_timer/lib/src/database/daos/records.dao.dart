import "package:drift/drift.dart";

import "../../puzzle/puzzle.dart";
import "../app_database.dart";
import "../tables/records.table.dart";

part "records.dao.g.dart";

@DriftAccessor(tables: [Records])
class RecordsDao extends DatabaseAccessor<AppDatabase> with _$RecordsDaoMixin {
  RecordsDao(super.db);

  Stream<List<RecordEntry>> watchSession(String session, Puzzle puzzle, {bool includeArchived = false}) =>
      (select(records)
            ..where((t) {
              final base = t.session.equals(session) & t.puzzle.equals(puzzle.id) & t.deletedAt.isNull();
              if (includeArchived) {
                return base;
              } else {
                return base & t.archived.not();
              }
            })
            ..orderBy([(t) => OrderingTerm.desc(t.datetime)]))
          .watch();

  /// Records a finished solve and returns its id, which the caller needs to
  /// keep: the +2, DNF, comment and delete buttons shown right after a solve
  /// all act on the row just written.
  Future<String> add({
    required String session,
    required Puzzle puzzle,
    required String scramble,
    required int time,
    Penalty penalty = .none,
  }) async {
    final row = await into(records).insertReturning(
      RecordsCompanion.insert(
        session: session,
        puzzle: puzzle,
        scramble: scramble,
        time: time,
        penalty: penalty,
      ),
    );
    return row.id;
  }

  Future<void> _write(String id, RecordsCompanion patch) =>
      (update(records)..where((t) => t.id.equals(id))).write(patch);

  Future<void> setPenalty(String id, Penalty v) => _write(id, RecordsCompanion(penalty: Value(v)));
  Future<void> setComment(String id, String? v) => _write(id, RecordsCompanion(comment: Value(v)));

  Future<void> softDelete(String id) => _write(id, RecordsCompanion(deletedAt: Value(DateTime.now())));
}
