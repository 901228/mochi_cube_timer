import "package:drift/drift.dart";

import "../app_database.dart";
import "../../timer/alert.dart";
import "../tables/settings.table.dart";

part "settings.dao.g.dart";

@DriftAccessor(tables: [Settings])
class SettingsDao extends DatabaseAccessor<AppDatabase> with _$SettingsDaoMixin {
  SettingsDao(super.db);

  Stream<SettingsEntry> watch() => (select(settings)..where((t) => t.id.equals(0))).watchSingle();

  Future<void> save(SettingsCompanion patch) => (update(settings)..where((t) => t.id.equals(0))).write(patch);

  Future<void> _write(SettingsCompanion patch) =>
      (update(settings)..where((t) => t.id.equals(0))).write(patch);

  Future<void> setInspectionEnabled(bool v) => _write(SettingsCompanion(inspectionEnabled: Value(v)));

  Future<void> setInspectionDuration(Duration d) =>
      _write(SettingsCompanion(inspectDuration: Value(d.inSeconds)));

  Future<void> setAlertEnabled(bool v) => _write(SettingsCompanion(alertEnabled: Value(v)));

  Future<void> setAlertTypes(Set<AlertType> v) => _write(SettingsCompanion(alertTypes: Value(v)));

  Future<void> setRecordBestAlert(bool v) => _write(SettingsCompanion(recordBestAlert: Value(v)));

  Future<void> setRecordWorstAlert(bool v) => _write(SettingsCompanion(recordWorstAlert: Value(v)));

  Future<void> setRecordAverageAlert(bool v) => _write(SettingsCompanion(recordAverageAlert: Value(v)));
}
