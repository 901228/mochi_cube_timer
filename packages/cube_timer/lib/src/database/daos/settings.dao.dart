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

  Future<void> setShowRunningTime(bool v) => _write(SettingsCompanion(showRunningTime: Value(v)));

  Future<void> setStackmatEnabled(bool v) => _write(SettingsCompanion(stackmatEnabled: Value(v)));

  Future<void> setTimeDecimals(int v) => _write(SettingsCompanion(timeDecimals: Value(v)));

  Future<void> setHoldDuration(Duration d) =>
      _write(SettingsCompanion(holdDuration: Value(d.inMilliseconds)));

  Future<void> setShowScrambleImage(bool v) => _write(SettingsCompanion(showScrambleImage: Value(v)));

  Future<void> setShowSessionStats(bool v) => _write(SettingsCompanion(showSessionStats: Value(v)));

  Future<void> setShowQuickActions(bool v) => _write(SettingsCompanion(showQuickActions: Value(v)));

  Future<void> setAverageTrim(int percent) => _write(SettingsCompanion(averageTrim: Value(percent)));

  /// A language code such as `zh`; null follows the system.
  Future<void> setLocale(String? v) => _write(SettingsCompanion(locale: Value(v)));

  Future<void> setThemeMode(AppThemeMode v) => _write(SettingsCompanion(themeMode: Value(v)));

  /// Null goes back to the theme's own.
  Future<void> setPrimaryColor(int? argb) => _write(SettingsCompanion(primaryColor: Value(argb)));
}
