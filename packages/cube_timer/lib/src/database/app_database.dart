import "package:drift/drift.dart";

import "../puzzle/puzzle.dart";
import "daos/app_state.dao.dart";
import "daos/settings.dao.dart";
import "tables/app_state.table.dart";
import "tables/settings.table.dart";

part "app_database.g.dart";

@DriftDatabase(tables: [Settings, AppState], daos: [SettingsDao, AppStateDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) async {
      if (from < 2) await m.createTable(appState);
    },
    // Both tables hold one row, at id 0. Seeding here rather than in onCreate
    // covers every way in: a fresh database, one upgraded from a version
    // without the table, and one whose row went missing. The DAOs read with
    // watchSingle(), which errors rather than waits when the row is not there.
    beforeOpen: (_) async {
      await into(settings).insert(const SettingsCompanion(id: Value(0)), mode: .insertOrIgnore);
      await into(appState).insert(const AppStateCompanion(id: Value(0)), mode: .insertOrIgnore);
    },
  );
}
