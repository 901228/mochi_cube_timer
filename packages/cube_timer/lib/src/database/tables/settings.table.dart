import "package:drift/drift.dart";

import "../../puzzle/colors.dart";
import "converters.dart";

/// Whether the app is light, dark, or follows the system.
enum AppThemeMode { system, light, dark }

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

  /// how the alert is given
  TextColumn get alertTypes =>
      text().map(const AlertTypesConverter()).withDefault(const Constant("text,audio,vibration"))();

  /// whether a new best solve of the session is announced
  BoolColumn get recordBestAlert => boolean().withDefault(const Constant(true))();

  /// whether a new worst solve of the session is announced
  BoolColumn get recordWorstAlert => boolean().withDefault(const Constant(true))();

  /// whether a new best average (Mo3, Ao5, Ao12) of the session is announced
  BoolColumn get recordAverageAlert => boolean().withDefault(const Constant(true))();

  /// locale
  ///
  /// `null` => system default
  TextColumn get locale => text().nullable()();

  /// light, dark, or as the system is
  TextColumn get themeMode => textEnum<AppThemeMode>().withDefault(const Constant("system"))();

  /// the app's primary colour, as int32 ARGB
  ///
  /// `null` => the theme's own
  IntColumn get primaryColor => integer().nullable()();

  /// cube colors
  ///
  /// all colors are stored as int32 in ARGB format, aligned to flutter's Color
  IntColumn get cubeColorU => integer().withDefault(Constant(DefaultColors.cubeColors.U.value))();
  IntColumn get cubeColorR => integer().withDefault(Constant(DefaultColors.cubeColors.R.value))();
  IntColumn get cubeColorF => integer().withDefault(Constant(DefaultColors.cubeColors.F.value))();
  IntColumn get cubeColorD => integer().withDefault(Constant(DefaultColors.cubeColors.D.value))();
  IntColumn get cubeColorL => integer().withDefault(Constant(DefaultColors.cubeColors.L.value))();
  IntColumn get cubeColorB => integer().withDefault(Constant(DefaultColors.cubeColors.B.value))();

  /// pyraminx colors
  IntColumn get pyraminxColorU => integer().withDefault(Constant(DefaultColors.pyraminxColors.U.value))();
  IntColumn get pyraminxColorB => integer().withDefault(Constant(DefaultColors.pyraminxColors.B.value))();
  IntColumn get pyraminxColorR => integer().withDefault(Constant(DefaultColors.pyraminxColors.R.value))();
  IntColumn get pyraminxColorL => integer().withDefault(Constant(DefaultColors.pyraminxColors.L.value))();

  /// megaminx colors, one per face
  IntColumn get megaminxColorU => integer().withDefault(Constant(DefaultColors.megaminxColors.u.value))();
  IntColumn get megaminxColorBL => integer().withDefault(Constant(DefaultColors.megaminxColors.bl.value))();
  IntColumn get megaminxColorBR => integer().withDefault(Constant(DefaultColors.megaminxColors.br.value))();
  IntColumn get megaminxColorR => integer().withDefault(Constant(DefaultColors.megaminxColors.r.value))();
  IntColumn get megaminxColorF => integer().withDefault(Constant(DefaultColors.megaminxColors.f.value))();
  IntColumn get megaminxColorL => integer().withDefault(Constant(DefaultColors.megaminxColors.l.value))();
  IntColumn get megaminxColorD => integer().withDefault(Constant(DefaultColors.megaminxColors.d.value))();
  IntColumn get megaminxColorDR => integer().withDefault(Constant(DefaultColors.megaminxColors.dr.value))();
  IntColumn get megaminxColorDBR => integer().withDefault(Constant(DefaultColors.megaminxColors.dbr.value))();
  IntColumn get megaminxColorB => integer().withDefault(Constant(DefaultColors.megaminxColors.b.value))();
  IntColumn get megaminxColorDBL => integer().withDefault(Constant(DefaultColors.megaminxColors.dbl.value))();
  IntColumn get megaminxColorDL => integer().withDefault(Constant(DefaultColors.megaminxColors.dl.value))();

  /// FTO colors, one per face
  IntColumn get ftoColorU => integer().withDefault(Constant(DefaultColors.ftoColors.u.value))();
  IntColumn get ftoColorR => integer().withDefault(Constant(DefaultColors.ftoColors.r.value))();
  IntColumn get ftoColorF => integer().withDefault(Constant(DefaultColors.ftoColors.f.value))();
  IntColumn get ftoColorL => integer().withDefault(Constant(DefaultColors.ftoColors.l.value))();
  IntColumn get ftoColorB => integer().withDefault(Constant(DefaultColors.ftoColors.b.value))();
  IntColumn get ftoColorBL => integer().withDefault(Constant(DefaultColors.ftoColors.bl.value))();
  IntColumn get ftoColorD => integer().withDefault(Constant(DefaultColors.ftoColors.d.value))();
  IntColumn get ftoColorBR => integer().withDefault(Constant(DefaultColors.ftoColors.br.value))();

  /// clock colors
  IntColumn get clockColorFront => integer().withDefault(Constant(DefaultColors.clockColors.front.value))();
  IntColumn get clockColorBack => integer().withDefault(Constant(DefaultColors.clockColors.back.value))();

  /// timer colors
  IntColumn get timerPressedColor =>
      integer().withDefault(Constant(DefaultColors.timerColors.pressed.value))();
  IntColumn get timerHoldingColor =>
      integer().withDefault(Constant(DefaultColors.timerColors.holding.value))();
  IntColumn get timerAcceptColor => integer().withDefault(Constant(DefaultColors.timerColors.accept.value))();

  /// whether the time is shown while a solve runs, or only `...` until it stops
  BoolColumn get showRunningTime => boolean().withDefault(const Constant(true))();

  /// whether a Stackmat on the audio input starts and stops the solves, the screen then only opening
  /// inspection
  BoolColumn get stackmatEnabled => boolean().withDefault(const Constant(false))();

  /// how many decimals the timer page shows a time with: 1, 2 or 3
  IntColumn get timeDecimals => integer().withDefault(const Constant(2))();

  @override
  Set<Column> get primaryKey => {id};
}
