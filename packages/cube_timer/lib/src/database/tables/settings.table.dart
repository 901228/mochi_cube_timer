import "package:drift/drift.dart";

@DataClassName("SettingsEntry")
class Settings extends Table {
  /// id
  IntColumn get id => integer()();

  /// whether to enable inspection
  BoolColumn get inspectionEnabled => boolean().withDefault(const Constant(true))();

  /// inspect duration in seconds
  IntColumn get inspectDuration => integer().withDefault(const Constant(15))();

  /// whether to enable alert
  BoolColumn get alertEnabled => boolean().withDefault(const Constant(true))();

  /// locale
  ///
  /// `null` => system default
  TextColumn get locale => text().nullable()();

  // TODO: colors

  @override
  Set<Column> get primaryKey => {id};
}
