// ignore_for_file: depend_on_referenced_packages
import "package:cube_timer/cube_timer.dart";
import "package:cube_timer/src/database/tables/converters.dart";
import "package:drift/drift.dart";
import "package:drift_dev/api/migrations_native.dart";
import "package:test/test.dart";

import "generated/schema.dart";
import "generated/schema_v1.dart" as v1;
import "generated/schema_v2.dart" as v2;
import "generated/schema_v3.dart" as v3;
import "generated/schema_v4.dart" as v4;

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  late SchemaVerifier verifier;

  setUpAll(() => verifier = SchemaVerifier(GeneratedHelper()));

  // Every step from every version to every later one ends at the schema the tables declare.
  group("simple database migrations", () {
    const versions = GeneratedHelper.versions;
    for (final (i, fromVersion) in versions.indexed) {
      group("from $fromVersion", () {
        for (final toVersion in versions.skip(i + 1)) {
          test("to $toVersion", () async {
            final schema = await verifier.schemaAt(fromVersion);
            final db = AppDatabase(schema.newConnection());
            await verifier.migrateAndValidate(db, toVersion);
            await db.close();
          });
        }
      });
    }
  });

  test("v1 to v2 keeps the settings and solves, and gives the new settings their defaults", () async {
    // Not the defaults, so a migration that rebuilt the row would show.
    const oldSettings = v1.SettingsData(
      id: 0,
      inspectionEnabled: 0,
      inspectDuration: 8,
      alertEnabled: 0,
      locale: "zh_TW",
      cubeColorU: 0xFF123456,
      cubeColorR: 1,
      cubeColorF: 2,
      cubeColorD: 3,
      cubeColorL: 4,
      cubeColorB: 5,
      pyraminxColorU: 6,
      pyraminxColorB: 7,
      pyraminxColorR: 8,
      pyraminxColorL: 9,
      clockColorFront: 10,
      clockColorBack: 11,
    );
    final expectedSettings = v2.SettingsData(
      id: 0,
      inspectionEnabled: 0,
      inspectDuration: 8,
      alertEnabled: 0,
      alertTypes: "text,vibration",
      locale: "zh_TW",
      cubeColorU: 0xFF123456,
      cubeColorR: 1,
      cubeColorF: 2,
      cubeColorD: 3,
      cubeColorL: 4,
      cubeColorB: 5,
      pyraminxColorU: 6,
      pyraminxColorB: 7,
      pyraminxColorR: 8,
      pyraminxColorL: 9,
      clockColorFront: 10,
      clockColorBack: 11,
      timerPressedColor: DefaultColors.timerColors.pressed,
      timerHoldingColor: DefaultColors.timerColors.holding,
      timerAcceptColor: DefaultColors.timerColors.accept,
    );

    const sessions = [
      (id: kDefaultSessionId, name: "Normal", createdAt: 1000),
      (id: "s2", name: "OH", createdAt: 2000),
    ];
    const record = (
      id: "r1",
      puzzle: "333",
      session: "s2",
      scramble: "R U R' U'",
      time: 12345,
      datetime: 3000,
      penalty: "plus2",
      comment: "nice",
      archived: 1,
    );

    await verifier.testWithDataIntegrity(
      oldVersion: 1,
      newVersion: 2,
      createOld: v1.DatabaseAtV1.new,
      createNew: v2.DatabaseAtV2.new,
      openTestedDatabase: AppDatabase.new,
      createItems: (batch, oldDb) {
        batch.insert(oldDb.settings, oldSettings);
        batch.insertAll(oldDb.sessions, [
          for (final s in sessions) v1.SessionsData(id: s.id, name: s.name, createdAt: s.createdAt),
        ]);
        batch.insert(
          oldDb.appState,
          const v1.AppStateData(id: 0, puzzle: "333", session: "s2", showArchived: 1),
        );
        batch.insert(
          oldDb.records,
          const v1.RecordsData(
            id: "r1",
            puzzle: "333",
            session: "s2",
            scramble: "R U R' U'",
            time: 12345,
            datetime: 3000,
            penalty: "plus2",
            comment: "nice",
            archived: 1,
          ),
        );
      },
      validateItems: (newDb) async {
        expect(await newDb.select(newDb.settings).get(), [expectedSettings]);
        expect(await newDb.select(newDb.sessions).get(), [
          for (final s in sessions) v2.SessionsData(id: s.id, name: s.name, createdAt: s.createdAt),
        ]);
        expect(await newDb.select(newDb.appState).get(), [
          const v2.AppStateData(id: 0, puzzle: "333", session: "s2", showArchived: 1),
        ]);
        expect(await newDb.select(newDb.records).get(), [
          v2.RecordsData(
            id: record.id,
            puzzle: record.puzzle,
            session: record.session,
            scramble: record.scramble,
            time: record.time,
            datetime: record.datetime,
            penalty: record.penalty,
            comment: record.comment,
            archived: record.archived,
          ),
        ]);
      },
    );
  });

  test("v2 to v3 keeps the settings, and announces new bests and worsts by default", () async {
    const old = v2.SettingsData(
      id: 0,
      inspectionEnabled: 0,
      inspectDuration: 8,
      alertEnabled: 0,
      alertTypes: "audio",
      locale: "zh_TW",
      cubeColorU: 0xFF123456,
      cubeColorR: 1,
      cubeColorF: 2,
      cubeColorD: 3,
      cubeColorL: 4,
      cubeColorB: 5,
      pyraminxColorU: 6,
      pyraminxColorB: 7,
      pyraminxColorR: 8,
      pyraminxColorL: 9,
      clockColorFront: 10,
      clockColorBack: 11,
      timerPressedColor: 12,
      timerHoldingColor: 13,
      timerAcceptColor: 14,
    );

    await verifier.testWithDataIntegrity(
      oldVersion: 2,
      newVersion: 3,
      createOld: v2.DatabaseAtV2.new,
      createNew: v3.DatabaseAtV3.new,
      openTestedDatabase: AppDatabase.new,
      createItems: (batch, oldDb) => batch.insert(oldDb.settings, old),
      validateItems: (newDb) async {
        expect(await newDb.select(newDb.settings).get(), [
          v3.SettingsData(
            id: 0,
            inspectionEnabled: 0,
            inspectDuration: 8,
            alertEnabled: 0,
            alertTypes: "audio",
            recordBestAlert: 1,
            recordWorstAlert: 1,
            locale: "zh_TW",
            cubeColorU: 0xFF123456,
            cubeColorR: 1,
            cubeColorF: 2,
            cubeColorD: 3,
            cubeColorL: 4,
            cubeColorB: 5,
            pyraminxColorU: 6,
            pyraminxColorB: 7,
            pyraminxColorR: 8,
            pyraminxColorL: 9,
            clockColorFront: 10,
            clockColorBack: 11,
            timerPressedColor: 12,
            timerHoldingColor: 13,
            timerAcceptColor: 14,
          ),
        ]);
      },
    );
  });

  test("v3 to v4 keeps the settings, and announces new best averages by default", () async {
    const old = v3.SettingsData(
      id: 0,
      inspectionEnabled: 0,
      inspectDuration: 8,
      alertEnabled: 0,
      alertTypes: "audio",
      recordBestAlert: 0,
      recordWorstAlert: 0,
      locale: "zh_TW",
      cubeColorU: 0xFF123456,
      cubeColorR: 1,
      cubeColorF: 2,
      cubeColorD: 3,
      cubeColorL: 4,
      cubeColorB: 5,
      pyraminxColorU: 6,
      pyraminxColorB: 7,
      pyraminxColorR: 8,
      pyraminxColorL: 9,
      clockColorFront: 10,
      clockColorBack: 11,
      timerPressedColor: 12,
      timerHoldingColor: 13,
      timerAcceptColor: 14,
    );

    await verifier.testWithDataIntegrity(
      oldVersion: 3,
      newVersion: 4,
      createOld: v3.DatabaseAtV3.new,
      createNew: v4.DatabaseAtV4.new,
      openTestedDatabase: AppDatabase.new,
      createItems: (batch, oldDb) => batch.insert(oldDb.settings, old),
      validateItems: (newDb) async {
        expect(await newDb.select(newDb.settings).get(), [
          v4.SettingsData(
            id: 0,
            inspectionEnabled: 0,
            inspectDuration: 8,
            alertEnabled: 0,
            alertTypes: "audio",
            recordBestAlert: 0,
            recordWorstAlert: 0,
            recordAverageAlert: 1,
            locale: "zh_TW",
            cubeColorU: 0xFF123456,
            cubeColorR: 1,
            cubeColorF: 2,
            cubeColorD: 3,
            cubeColorL: 4,
            cubeColorB: 5,
            pyraminxColorU: 6,
            pyraminxColorB: 7,
            pyraminxColorR: 8,
            pyraminxColorL: 9,
            clockColorFront: 10,
            clockColorBack: 11,
            timerPressedColor: 12,
            timerHoldingColor: 13,
            timerAcceptColor: 14,
          ),
        ]);
      },
    );
  });

  test("the alert types read back as stored, ignoring names no longer in the enum", () {
    const converter = AlertTypesConverter();
    expect(converter.toSql({AlertType.vibration, AlertType.text}), "text,vibration");
    expect(converter.toSql({}), "");
    expect(converter.fromSql(""), <AlertType>{});
    expect(converter.fromSql("vibration,beep,text"), {AlertType.text, AlertType.vibration});
  });
}
