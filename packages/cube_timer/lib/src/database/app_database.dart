import "package:drift/drift.dart";
import "package:uuid/uuid.dart";

import "../puzzle/colors.dart";
import "../puzzle/puzzle.dart";
import "daos/app_state.dao.dart";
import "daos/records.dao.dart";
import "daos/sessions.dao.dart";
import "daos/settings.dao.dart";
import "tables/app_state.table.dart";
import "tables/converters.dart";
import "tables/records.table.dart";
import "tables/sessions.table.dart";
import "tables/settings.table.dart";

part "app_database.g.dart";

@DriftDatabase(
  tables: [Settings, AppState, Records, Sessions],
  daos: [SettingsDao, AppStateDao, RecordsDao, SessionsDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  @override
  // Stays at 1 until the first release; until then the schema is changed in
  // place and local databases are deleted rather than migrated.
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    beforeOpen: (_) async {
      // Off by default in SQLite, so the references() on Records and AppState
      // would otherwise be documentation rather than a constraint.
      await customStatement("PRAGMA foreign_keys = ON");

      await into(settings).insert(const SettingsCompanion(id: Value(0)), mode: .insertOrIgnore);
      await into(sessions).insert(
        SessionsCompanion.insert(id: const Value(kDefaultSessionId), name: "Normal"),
        mode: .insertOrIgnore,
      );
      await into(appState).insert(const AppStateCompanion(id: Value(0)), mode: .insertOrIgnore);
    },
  );
}
