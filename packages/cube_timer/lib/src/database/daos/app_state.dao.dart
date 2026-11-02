import "package:drift/drift.dart";

import "../../puzzle.dart";
import "../app_database.dart";
import "../tables/app_state.table.dart";
import "../tables/practice_exclusions.table.dart";
import "../tables/sessions.table.dart";

part "app_state.dao.g.dart";

typedef AppStateDaoReturn = ({Puzzle puzzle, String? algorithmSet, SessionEntry session});

@DriftAccessor(tables: [AppState, Sessions, PracticeExclusions])
class AppStateDao extends DatabaseAccessor<AppDatabase> with _$AppStateDaoMixin {
  AppStateDao(super.db);

  Stream<AppStateDaoReturn> watch() {
    final query = select(appState).join([innerJoin(sessions, sessions.id.equalsExp(appState.session))])
      ..where(appState.id.equals(0));

    return query.watchSingle().map(
      (row) => (
        puzzle: row.readTable(appState).puzzle,
        algorithmSet: row.readTable(appState).algorithmSet,
        session: row.readTable(sessions),
      ),
    );
  }

  Future<AppStateDaoReturn> get current async {
    final query = select(appState).join([innerJoin(sessions, sessions.id.equalsExp(appState.session))])
      ..where(appState.id.equals(0));

    final row = await query.getSingle();
    return (
      puzzle: row.readTable(appState).puzzle,
      algorithmSet: row.readTable(appState).algorithmSet,
      session: row.readTable(sessions),
    );
  }

  Future<void> save(AppStateCompanion patch) => (update(appState)..where((t) => t.id.equals(0))).write(patch);

  Future<void> _write(AppStateCompanion patch) =>
      (update(appState)..where((t) => t.id.equals(0))).write(patch);

  /// Ordinary solves of [v], leaving any algorithm set.
  Future<void> setPuzzle(Puzzle v) =>
      _write(AppStateCompanion(puzzle: Value(v), algorithmSet: const Value(null)));

  /// Practice of the algorithm set [setId] of [puzzle].
  Future<void> setAlgorithmSet(Puzzle puzzle, String setId) =>
      _write(AppStateCompanion(puzzle: Value(puzzle), algorithmSet: Value(setId)));

  Future<void> setSession(String v) => _write(AppStateCompanion(session: Value(v)));

  /// The ids of the cases of [setId] left out of its practice.
  Stream<Set<String>> watchExcluded(Puzzle puzzle, String setId) =>
      (select(practiceExclusions)..where((t) => t.puzzle.equals(puzzle.id) & t.algorithmSet.equals(setId)))
          .watch()
          .map((rows) => {for (final r in rows) r.algorithmCase});

  /// Leaves exactly [caseIds] of [setId] out of its practice.
  Future<void> setExcluded(Puzzle puzzle, String setId, Set<String> caseIds) => transaction(() async {
    await (delete(
      practiceExclusions,
    )..where((t) => t.puzzle.equals(puzzle.id) & t.algorithmSet.equals(setId))).go();
    await batch(
      (b) => b.insertAll(practiceExclusions, [
        for (final id in caseIds)
          PracticeExclusionsCompanion.insert(puzzle: puzzle, algorithmSet: setId, algorithmCase: id),
      ]),
    );
  });
}
