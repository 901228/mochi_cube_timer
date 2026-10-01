import "package:drift/drift.dart";

import "../../puzzle.dart";
import "../app_database.dart";
import "../tables/app_state.table.dart";
import "../tables/sessions.table.dart";

part "app_state.dao.g.dart";

typedef AppStateDaoReturn = ({Puzzle puzzle, SessionEntry session, bool showArchived});

@DriftAccessor(tables: [AppState, Sessions])
class AppStateDao extends DatabaseAccessor<AppDatabase> with _$AppStateDaoMixin {
  AppStateDao(super.db);

  Stream<AppStateDaoReturn> watch() {
    final query = select(appState).join([innerJoin(sessions, sessions.id.equalsExp(appState.session))])
      ..where(appState.id.equals(0));

    return query.watchSingle().map(
      (row) => (
        puzzle: row.readTable(appState).puzzle,
        session: row.readTable(sessions),
        showArchived: row.readTable(appState).showArchived,
      ),
    );
  }

  Future<AppStateDaoReturn> get current async {
    final query = select(appState).join([innerJoin(sessions, sessions.id.equalsExp(appState.session))])
      ..where(appState.id.equals(0));

    final row = await query.getSingle();
    return (
      puzzle: row.readTable(appState).puzzle,
      session: row.readTable(sessions),
      showArchived: row.readTable(appState).showArchived,
    );
  }

  Future<void> save(AppStateCompanion patch) => (update(appState)..where((t) => t.id.equals(0))).write(patch);

  Future<void> _write(AppStateCompanion patch) =>
      (update(appState)..where((t) => t.id.equals(0))).write(patch);

  Future<void> setPuzzle(Puzzle v) => _write(AppStateCompanion(puzzle: Value(v)));
  Future<void> setSession(String v) => _write(AppStateCompanion(session: Value(v)));
  Future<void> setShowArchived(bool v) => _write(AppStateCompanion(showArchived: Value(v)));
}
