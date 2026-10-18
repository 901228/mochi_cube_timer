import "package:drift/drift.dart";
import "package:uuid/uuid.dart";

import "../puzzle/colors.dart";
import "../puzzle/puzzle.dart";
import "../timer/alert.dart";
import "app_database.steps.dart";
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

  // Bumped with every change to the tables: run `dart run drift_dev make-migrations` before and
  // after, and add the step below.
  @override
  int get schemaVersion => 6;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: stepByStep(
      from1To2: (m, schema) async {
        await m.addColumn(schema.settings, schema.settings.alertTypes);
        await m.addColumn(schema.settings, schema.settings.timerPressedColor);
        await m.addColumn(schema.settings, schema.settings.timerHoldingColor);
        await m.addColumn(schema.settings, schema.settings.timerAcceptColor);
      },
      from2To3: (m, schema) async {
        await m.addColumn(schema.settings, schema.settings.recordBestAlert);
        await m.addColumn(schema.settings, schema.settings.recordWorstAlert);
      },
      from3To4: (m, schema) async {
        await m.addColumn(schema.settings, schema.settings.recordAverageAlert);
      },
      from4To5: (m, schema) async {
        await m.addColumn(schema.settings, schema.settings.themeMode);
        await m.addColumn(schema.settings, schema.settings.primaryColor);
      },
      from5To6: (m, schema) async {
        // Only alert_types' default changed; SQLite cannot alter one in place, so the table is rebuilt.
        await m.alterTable(TableMigration(schema.settings));
      },
    ),
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
