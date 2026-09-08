import "package:drift/drift.dart";

import "../../puzzle.dart";
import "../app_database.dart";
import "../tables/app_state.table.dart";

part "app_state.dao.g.dart";

@DriftAccessor(tables: [AppState])
class AppStateDao extends DatabaseAccessor<AppDatabase> with _$AppStateDaoMixin {
  AppStateDao(super.db);

  Stream<AppStateEntry> watch() => (select(appState)..where((t) => t.id.equals(0))).watchSingle();

  Future<void> save(AppStateCompanion patch) => (update(appState)..where((t) => t.id.equals(0))).write(patch);

  Future<void> _write(AppStateCompanion patch) =>
      (update(appState)..where((t) => t.id.equals(0))).write(patch);

  Future<void> setPuzzle(Puzzle v) => _write(AppStateCompanion(puzzle: Value(v)));

  Future<void> setSession(String v) => _write(AppStateCompanion(session: Value(v)));
}
