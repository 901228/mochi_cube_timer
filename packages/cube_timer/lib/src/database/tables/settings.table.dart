import "package:drift/drift.dart";

import "../../puzzle/colors.dart";

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

  /// cube colors
  ///
  /// all colors are stored as int32 in ARGB format, aligned to flutter's Color
  IntColumn get cubeColorU => integer().withDefault(Constant(DefaultColors.cubeColors.U))();
  IntColumn get cubeColorR => integer().withDefault(Constant(DefaultColors.cubeColors.R))();
  IntColumn get cubeColorF => integer().withDefault(Constant(DefaultColors.cubeColors.F))();
  IntColumn get cubeColorD => integer().withDefault(Constant(DefaultColors.cubeColors.D))();
  IntColumn get cubeColorL => integer().withDefault(Constant(DefaultColors.cubeColors.L))();
  IntColumn get cubeColorB => integer().withDefault(Constant(DefaultColors.cubeColors.B))();

  /// pyraminx colors
  IntColumn get pyraminxColorU => integer().withDefault(Constant(DefaultColors.pyraminxColors.U))();
  IntColumn get pyraminxColorB => integer().withDefault(Constant(DefaultColors.pyraminxColors.B))();
  IntColumn get pyraminxColorR => integer().withDefault(Constant(DefaultColors.pyraminxColors.R))();
  IntColumn get pyraminxColorL => integer().withDefault(Constant(DefaultColors.pyraminxColors.L))();

  /// clock colors
  IntColumn get clockColorFront => integer().withDefault(Constant(DefaultColors.clockColors.front))();
  IntColumn get clockColorBack => integer().withDefault(Constant(DefaultColors.clockColors.back))();

  @override
  Set<Column> get primaryKey => {id};
}
