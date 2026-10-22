// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $SettingsTable extends Settings
    with TableInfo<$SettingsTable, SettingsEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _inspectionEnabledMeta = const VerificationMeta(
    'inspectionEnabled',
  );
  @override
  late final GeneratedColumn<bool> inspectionEnabled = GeneratedColumn<bool>(
    'inspection_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("inspection_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _inspectDurationMeta = const VerificationMeta(
    'inspectDuration',
  );
  @override
  late final GeneratedColumn<int> inspectDuration = GeneratedColumn<int>(
    'inspect_duration',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(15),
  );
  static const VerificationMeta _alertEnabledMeta = const VerificationMeta(
    'alertEnabled',
  );
  @override
  late final GeneratedColumn<bool> alertEnabled = GeneratedColumn<bool>(
    'alert_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("alert_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  late final GeneratedColumnWithTypeConverter<Set<AlertType>, String>
  alertTypes = GeneratedColumn<String>(
    'alert_types',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant("text,audio,vibration"),
  ).withConverter<Set<AlertType>>($SettingsTable.$converteralertTypes);
  static const VerificationMeta _recordBestAlertMeta = const VerificationMeta(
    'recordBestAlert',
  );
  @override
  late final GeneratedColumn<bool> recordBestAlert = GeneratedColumn<bool>(
    'record_best_alert',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("record_best_alert" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _recordWorstAlertMeta = const VerificationMeta(
    'recordWorstAlert',
  );
  @override
  late final GeneratedColumn<bool> recordWorstAlert = GeneratedColumn<bool>(
    'record_worst_alert',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("record_worst_alert" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _recordAverageAlertMeta =
      const VerificationMeta('recordAverageAlert');
  @override
  late final GeneratedColumn<bool> recordAverageAlert = GeneratedColumn<bool>(
    'record_average_alert',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("record_average_alert" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _localeMeta = const VerificationMeta('locale');
  @override
  late final GeneratedColumn<String> locale = GeneratedColumn<String>(
    'locale',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<AppThemeMode, String> themeMode =
      GeneratedColumn<String>(
        'theme_mode',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant("system"),
      ).withConverter<AppThemeMode>($SettingsTable.$converterthemeMode);
  static const VerificationMeta _primaryColorMeta = const VerificationMeta(
    'primaryColor',
  );
  @override
  late final GeneratedColumn<int> primaryColor = GeneratedColumn<int>(
    'primary_color',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cubeColorUMeta = const VerificationMeta(
    'cubeColorU',
  );
  @override
  late final GeneratedColumn<int> cubeColorU = GeneratedColumn<int>(
    'cube_color_u',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: Constant(DefaultColors.cubeColors.U.value),
  );
  static const VerificationMeta _cubeColorRMeta = const VerificationMeta(
    'cubeColorR',
  );
  @override
  late final GeneratedColumn<int> cubeColorR = GeneratedColumn<int>(
    'cube_color_r',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: Constant(DefaultColors.cubeColors.R.value),
  );
  static const VerificationMeta _cubeColorFMeta = const VerificationMeta(
    'cubeColorF',
  );
  @override
  late final GeneratedColumn<int> cubeColorF = GeneratedColumn<int>(
    'cube_color_f',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: Constant(DefaultColors.cubeColors.F.value),
  );
  static const VerificationMeta _cubeColorDMeta = const VerificationMeta(
    'cubeColorD',
  );
  @override
  late final GeneratedColumn<int> cubeColorD = GeneratedColumn<int>(
    'cube_color_d',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: Constant(DefaultColors.cubeColors.D.value),
  );
  static const VerificationMeta _cubeColorLMeta = const VerificationMeta(
    'cubeColorL',
  );
  @override
  late final GeneratedColumn<int> cubeColorL = GeneratedColumn<int>(
    'cube_color_l',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: Constant(DefaultColors.cubeColors.L.value),
  );
  static const VerificationMeta _cubeColorBMeta = const VerificationMeta(
    'cubeColorB',
  );
  @override
  late final GeneratedColumn<int> cubeColorB = GeneratedColumn<int>(
    'cube_color_b',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: Constant(DefaultColors.cubeColors.B.value),
  );
  static const VerificationMeta _pyraminxColorUMeta = const VerificationMeta(
    'pyraminxColorU',
  );
  @override
  late final GeneratedColumn<int> pyraminxColorU = GeneratedColumn<int>(
    'pyraminx_color_u',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: Constant(DefaultColors.pyraminxColors.U.value),
  );
  static const VerificationMeta _pyraminxColorBMeta = const VerificationMeta(
    'pyraminxColorB',
  );
  @override
  late final GeneratedColumn<int> pyraminxColorB = GeneratedColumn<int>(
    'pyraminx_color_b',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: Constant(DefaultColors.pyraminxColors.B.value),
  );
  static const VerificationMeta _pyraminxColorRMeta = const VerificationMeta(
    'pyraminxColorR',
  );
  @override
  late final GeneratedColumn<int> pyraminxColorR = GeneratedColumn<int>(
    'pyraminx_color_r',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: Constant(DefaultColors.pyraminxColors.R.value),
  );
  static const VerificationMeta _pyraminxColorLMeta = const VerificationMeta(
    'pyraminxColorL',
  );
  @override
  late final GeneratedColumn<int> pyraminxColorL = GeneratedColumn<int>(
    'pyraminx_color_l',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: Constant(DefaultColors.pyraminxColors.L.value),
  );
  static const VerificationMeta _megaminxColorUMeta = const VerificationMeta(
    'megaminxColorU',
  );
  @override
  late final GeneratedColumn<int> megaminxColorU = GeneratedColumn<int>(
    'megaminx_color_u',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: Constant(DefaultColors.megaminxColors.u.value),
  );
  static const VerificationMeta _megaminxColorBLMeta = const VerificationMeta(
    'megaminxColorBL',
  );
  @override
  late final GeneratedColumn<int> megaminxColorBL = GeneratedColumn<int>(
    'megaminx_color_b_l',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: Constant(DefaultColors.megaminxColors.bl.value),
  );
  static const VerificationMeta _megaminxColorBRMeta = const VerificationMeta(
    'megaminxColorBR',
  );
  @override
  late final GeneratedColumn<int> megaminxColorBR = GeneratedColumn<int>(
    'megaminx_color_b_r',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: Constant(DefaultColors.megaminxColors.br.value),
  );
  static const VerificationMeta _megaminxColorRMeta = const VerificationMeta(
    'megaminxColorR',
  );
  @override
  late final GeneratedColumn<int> megaminxColorR = GeneratedColumn<int>(
    'megaminx_color_r',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: Constant(DefaultColors.megaminxColors.r.value),
  );
  static const VerificationMeta _megaminxColorFMeta = const VerificationMeta(
    'megaminxColorF',
  );
  @override
  late final GeneratedColumn<int> megaminxColorF = GeneratedColumn<int>(
    'megaminx_color_f',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: Constant(DefaultColors.megaminxColors.f.value),
  );
  static const VerificationMeta _megaminxColorLMeta = const VerificationMeta(
    'megaminxColorL',
  );
  @override
  late final GeneratedColumn<int> megaminxColorL = GeneratedColumn<int>(
    'megaminx_color_l',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: Constant(DefaultColors.megaminxColors.l.value),
  );
  static const VerificationMeta _megaminxColorDMeta = const VerificationMeta(
    'megaminxColorD',
  );
  @override
  late final GeneratedColumn<int> megaminxColorD = GeneratedColumn<int>(
    'megaminx_color_d',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: Constant(DefaultColors.megaminxColors.d.value),
  );
  static const VerificationMeta _megaminxColorDRMeta = const VerificationMeta(
    'megaminxColorDR',
  );
  @override
  late final GeneratedColumn<int> megaminxColorDR = GeneratedColumn<int>(
    'megaminx_color_d_r',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: Constant(DefaultColors.megaminxColors.dr.value),
  );
  static const VerificationMeta _megaminxColorDBRMeta = const VerificationMeta(
    'megaminxColorDBR',
  );
  @override
  late final GeneratedColumn<int> megaminxColorDBR = GeneratedColumn<int>(
    'megaminx_color_d_b_r',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: Constant(DefaultColors.megaminxColors.dbr.value),
  );
  static const VerificationMeta _megaminxColorBMeta = const VerificationMeta(
    'megaminxColorB',
  );
  @override
  late final GeneratedColumn<int> megaminxColorB = GeneratedColumn<int>(
    'megaminx_color_b',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: Constant(DefaultColors.megaminxColors.b.value),
  );
  static const VerificationMeta _megaminxColorDBLMeta = const VerificationMeta(
    'megaminxColorDBL',
  );
  @override
  late final GeneratedColumn<int> megaminxColorDBL = GeneratedColumn<int>(
    'megaminx_color_d_b_l',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: Constant(DefaultColors.megaminxColors.dbl.value),
  );
  static const VerificationMeta _megaminxColorDLMeta = const VerificationMeta(
    'megaminxColorDL',
  );
  @override
  late final GeneratedColumn<int> megaminxColorDL = GeneratedColumn<int>(
    'megaminx_color_d_l',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: Constant(DefaultColors.megaminxColors.dl.value),
  );
  static const VerificationMeta _ftoColorUMeta = const VerificationMeta(
    'ftoColorU',
  );
  @override
  late final GeneratedColumn<int> ftoColorU = GeneratedColumn<int>(
    'fto_color_u',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: Constant(DefaultColors.ftoColors.u.value),
  );
  static const VerificationMeta _ftoColorRMeta = const VerificationMeta(
    'ftoColorR',
  );
  @override
  late final GeneratedColumn<int> ftoColorR = GeneratedColumn<int>(
    'fto_color_r',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: Constant(DefaultColors.ftoColors.r.value),
  );
  static const VerificationMeta _ftoColorFMeta = const VerificationMeta(
    'ftoColorF',
  );
  @override
  late final GeneratedColumn<int> ftoColorF = GeneratedColumn<int>(
    'fto_color_f',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: Constant(DefaultColors.ftoColors.f.value),
  );
  static const VerificationMeta _ftoColorLMeta = const VerificationMeta(
    'ftoColorL',
  );
  @override
  late final GeneratedColumn<int> ftoColorL = GeneratedColumn<int>(
    'fto_color_l',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: Constant(DefaultColors.ftoColors.l.value),
  );
  static const VerificationMeta _ftoColorBMeta = const VerificationMeta(
    'ftoColorB',
  );
  @override
  late final GeneratedColumn<int> ftoColorB = GeneratedColumn<int>(
    'fto_color_b',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: Constant(DefaultColors.ftoColors.b.value),
  );
  static const VerificationMeta _ftoColorBLMeta = const VerificationMeta(
    'ftoColorBL',
  );
  @override
  late final GeneratedColumn<int> ftoColorBL = GeneratedColumn<int>(
    'fto_color_b_l',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: Constant(DefaultColors.ftoColors.bl.value),
  );
  static const VerificationMeta _ftoColorDMeta = const VerificationMeta(
    'ftoColorD',
  );
  @override
  late final GeneratedColumn<int> ftoColorD = GeneratedColumn<int>(
    'fto_color_d',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: Constant(DefaultColors.ftoColors.d.value),
  );
  static const VerificationMeta _ftoColorBRMeta = const VerificationMeta(
    'ftoColorBR',
  );
  @override
  late final GeneratedColumn<int> ftoColorBR = GeneratedColumn<int>(
    'fto_color_b_r',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: Constant(DefaultColors.ftoColors.br.value),
  );
  static const VerificationMeta _clockColorFrontMeta = const VerificationMeta(
    'clockColorFront',
  );
  @override
  late final GeneratedColumn<int> clockColorFront = GeneratedColumn<int>(
    'clock_color_front',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: Constant(DefaultColors.clockColors.front.value),
  );
  static const VerificationMeta _clockColorBackMeta = const VerificationMeta(
    'clockColorBack',
  );
  @override
  late final GeneratedColumn<int> clockColorBack = GeneratedColumn<int>(
    'clock_color_back',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: Constant(DefaultColors.clockColors.back.value),
  );
  static const VerificationMeta _timerPressedColorMeta = const VerificationMeta(
    'timerPressedColor',
  );
  @override
  late final GeneratedColumn<int> timerPressedColor = GeneratedColumn<int>(
    'timer_pressed_color',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: Constant(DefaultColors.timerColors.pressed.value),
  );
  static const VerificationMeta _timerHoldingColorMeta = const VerificationMeta(
    'timerHoldingColor',
  );
  @override
  late final GeneratedColumn<int> timerHoldingColor = GeneratedColumn<int>(
    'timer_holding_color',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: Constant(DefaultColors.timerColors.holding.value),
  );
  static const VerificationMeta _timerAcceptColorMeta = const VerificationMeta(
    'timerAcceptColor',
  );
  @override
  late final GeneratedColumn<int> timerAcceptColor = GeneratedColumn<int>(
    'timer_accept_color',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: Constant(DefaultColors.timerColors.accept.value),
  );
  static const VerificationMeta _showRunningTimeMeta = const VerificationMeta(
    'showRunningTime',
  );
  @override
  late final GeneratedColumn<bool> showRunningTime = GeneratedColumn<bool>(
    'show_running_time',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("show_running_time" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _stackmatEnabledMeta = const VerificationMeta(
    'stackmatEnabled',
  );
  @override
  late final GeneratedColumn<bool> stackmatEnabled = GeneratedColumn<bool>(
    'stackmat_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("stackmat_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _timeDecimalsMeta = const VerificationMeta(
    'timeDecimals',
  );
  @override
  late final GeneratedColumn<int> timeDecimals = GeneratedColumn<int>(
    'time_decimals',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(2),
  );
  static const VerificationMeta _holdDurationMeta = const VerificationMeta(
    'holdDuration',
  );
  @override
  late final GeneratedColumn<int> holdDuration = GeneratedColumn<int>(
    'hold_duration',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(300),
  );
  static const VerificationMeta _showScrambleImageMeta = const VerificationMeta(
    'showScrambleImage',
  );
  @override
  late final GeneratedColumn<bool> showScrambleImage = GeneratedColumn<bool>(
    'show_scramble_image',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("show_scramble_image" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _showSessionStatsMeta = const VerificationMeta(
    'showSessionStats',
  );
  @override
  late final GeneratedColumn<bool> showSessionStats = GeneratedColumn<bool>(
    'show_session_stats',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("show_session_stats" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _showQuickActionsMeta = const VerificationMeta(
    'showQuickActions',
  );
  @override
  late final GeneratedColumn<bool> showQuickActions = GeneratedColumn<bool>(
    'show_quick_actions',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("show_quick_actions" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _averageTrimMeta = const VerificationMeta(
    'averageTrim',
  );
  @override
  late final GeneratedColumn<int> averageTrim = GeneratedColumn<int>(
    'average_trim',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(5),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    inspectionEnabled,
    inspectDuration,
    alertEnabled,
    alertTypes,
    recordBestAlert,
    recordWorstAlert,
    recordAverageAlert,
    locale,
    themeMode,
    primaryColor,
    cubeColorU,
    cubeColorR,
    cubeColorF,
    cubeColorD,
    cubeColorL,
    cubeColorB,
    pyraminxColorU,
    pyraminxColorB,
    pyraminxColorR,
    pyraminxColorL,
    megaminxColorU,
    megaminxColorBL,
    megaminxColorBR,
    megaminxColorR,
    megaminxColorF,
    megaminxColorL,
    megaminxColorD,
    megaminxColorDR,
    megaminxColorDBR,
    megaminxColorB,
    megaminxColorDBL,
    megaminxColorDL,
    ftoColorU,
    ftoColorR,
    ftoColorF,
    ftoColorL,
    ftoColorB,
    ftoColorBL,
    ftoColorD,
    ftoColorBR,
    clockColorFront,
    clockColorBack,
    timerPressedColor,
    timerHoldingColor,
    timerAcceptColor,
    showRunningTime,
    stackmatEnabled,
    timeDecimals,
    holdDuration,
    showScrambleImage,
    showSessionStats,
    showQuickActions,
    averageTrim,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<SettingsEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('inspection_enabled')) {
      context.handle(
        _inspectionEnabledMeta,
        inspectionEnabled.isAcceptableOrUnknown(
          data['inspection_enabled']!,
          _inspectionEnabledMeta,
        ),
      );
    }
    if (data.containsKey('inspect_duration')) {
      context.handle(
        _inspectDurationMeta,
        inspectDuration.isAcceptableOrUnknown(
          data['inspect_duration']!,
          _inspectDurationMeta,
        ),
      );
    }
    if (data.containsKey('alert_enabled')) {
      context.handle(
        _alertEnabledMeta,
        alertEnabled.isAcceptableOrUnknown(
          data['alert_enabled']!,
          _alertEnabledMeta,
        ),
      );
    }
    if (data.containsKey('record_best_alert')) {
      context.handle(
        _recordBestAlertMeta,
        recordBestAlert.isAcceptableOrUnknown(
          data['record_best_alert']!,
          _recordBestAlertMeta,
        ),
      );
    }
    if (data.containsKey('record_worst_alert')) {
      context.handle(
        _recordWorstAlertMeta,
        recordWorstAlert.isAcceptableOrUnknown(
          data['record_worst_alert']!,
          _recordWorstAlertMeta,
        ),
      );
    }
    if (data.containsKey('record_average_alert')) {
      context.handle(
        _recordAverageAlertMeta,
        recordAverageAlert.isAcceptableOrUnknown(
          data['record_average_alert']!,
          _recordAverageAlertMeta,
        ),
      );
    }
    if (data.containsKey('locale')) {
      context.handle(
        _localeMeta,
        locale.isAcceptableOrUnknown(data['locale']!, _localeMeta),
      );
    }
    if (data.containsKey('primary_color')) {
      context.handle(
        _primaryColorMeta,
        primaryColor.isAcceptableOrUnknown(
          data['primary_color']!,
          _primaryColorMeta,
        ),
      );
    }
    if (data.containsKey('cube_color_u')) {
      context.handle(
        _cubeColorUMeta,
        cubeColorU.isAcceptableOrUnknown(
          data['cube_color_u']!,
          _cubeColorUMeta,
        ),
      );
    }
    if (data.containsKey('cube_color_r')) {
      context.handle(
        _cubeColorRMeta,
        cubeColorR.isAcceptableOrUnknown(
          data['cube_color_r']!,
          _cubeColorRMeta,
        ),
      );
    }
    if (data.containsKey('cube_color_f')) {
      context.handle(
        _cubeColorFMeta,
        cubeColorF.isAcceptableOrUnknown(
          data['cube_color_f']!,
          _cubeColorFMeta,
        ),
      );
    }
    if (data.containsKey('cube_color_d')) {
      context.handle(
        _cubeColorDMeta,
        cubeColorD.isAcceptableOrUnknown(
          data['cube_color_d']!,
          _cubeColorDMeta,
        ),
      );
    }
    if (data.containsKey('cube_color_l')) {
      context.handle(
        _cubeColorLMeta,
        cubeColorL.isAcceptableOrUnknown(
          data['cube_color_l']!,
          _cubeColorLMeta,
        ),
      );
    }
    if (data.containsKey('cube_color_b')) {
      context.handle(
        _cubeColorBMeta,
        cubeColorB.isAcceptableOrUnknown(
          data['cube_color_b']!,
          _cubeColorBMeta,
        ),
      );
    }
    if (data.containsKey('pyraminx_color_u')) {
      context.handle(
        _pyraminxColorUMeta,
        pyraminxColorU.isAcceptableOrUnknown(
          data['pyraminx_color_u']!,
          _pyraminxColorUMeta,
        ),
      );
    }
    if (data.containsKey('pyraminx_color_b')) {
      context.handle(
        _pyraminxColorBMeta,
        pyraminxColorB.isAcceptableOrUnknown(
          data['pyraminx_color_b']!,
          _pyraminxColorBMeta,
        ),
      );
    }
    if (data.containsKey('pyraminx_color_r')) {
      context.handle(
        _pyraminxColorRMeta,
        pyraminxColorR.isAcceptableOrUnknown(
          data['pyraminx_color_r']!,
          _pyraminxColorRMeta,
        ),
      );
    }
    if (data.containsKey('pyraminx_color_l')) {
      context.handle(
        _pyraminxColorLMeta,
        pyraminxColorL.isAcceptableOrUnknown(
          data['pyraminx_color_l']!,
          _pyraminxColorLMeta,
        ),
      );
    }
    if (data.containsKey('megaminx_color_u')) {
      context.handle(
        _megaminxColorUMeta,
        megaminxColorU.isAcceptableOrUnknown(
          data['megaminx_color_u']!,
          _megaminxColorUMeta,
        ),
      );
    }
    if (data.containsKey('megaminx_color_b_l')) {
      context.handle(
        _megaminxColorBLMeta,
        megaminxColorBL.isAcceptableOrUnknown(
          data['megaminx_color_b_l']!,
          _megaminxColorBLMeta,
        ),
      );
    }
    if (data.containsKey('megaminx_color_b_r')) {
      context.handle(
        _megaminxColorBRMeta,
        megaminxColorBR.isAcceptableOrUnknown(
          data['megaminx_color_b_r']!,
          _megaminxColorBRMeta,
        ),
      );
    }
    if (data.containsKey('megaminx_color_r')) {
      context.handle(
        _megaminxColorRMeta,
        megaminxColorR.isAcceptableOrUnknown(
          data['megaminx_color_r']!,
          _megaminxColorRMeta,
        ),
      );
    }
    if (data.containsKey('megaminx_color_f')) {
      context.handle(
        _megaminxColorFMeta,
        megaminxColorF.isAcceptableOrUnknown(
          data['megaminx_color_f']!,
          _megaminxColorFMeta,
        ),
      );
    }
    if (data.containsKey('megaminx_color_l')) {
      context.handle(
        _megaminxColorLMeta,
        megaminxColorL.isAcceptableOrUnknown(
          data['megaminx_color_l']!,
          _megaminxColorLMeta,
        ),
      );
    }
    if (data.containsKey('megaminx_color_d')) {
      context.handle(
        _megaminxColorDMeta,
        megaminxColorD.isAcceptableOrUnknown(
          data['megaminx_color_d']!,
          _megaminxColorDMeta,
        ),
      );
    }
    if (data.containsKey('megaminx_color_d_r')) {
      context.handle(
        _megaminxColorDRMeta,
        megaminxColorDR.isAcceptableOrUnknown(
          data['megaminx_color_d_r']!,
          _megaminxColorDRMeta,
        ),
      );
    }
    if (data.containsKey('megaminx_color_d_b_r')) {
      context.handle(
        _megaminxColorDBRMeta,
        megaminxColorDBR.isAcceptableOrUnknown(
          data['megaminx_color_d_b_r']!,
          _megaminxColorDBRMeta,
        ),
      );
    }
    if (data.containsKey('megaminx_color_b')) {
      context.handle(
        _megaminxColorBMeta,
        megaminxColorB.isAcceptableOrUnknown(
          data['megaminx_color_b']!,
          _megaminxColorBMeta,
        ),
      );
    }
    if (data.containsKey('megaminx_color_d_b_l')) {
      context.handle(
        _megaminxColorDBLMeta,
        megaminxColorDBL.isAcceptableOrUnknown(
          data['megaminx_color_d_b_l']!,
          _megaminxColorDBLMeta,
        ),
      );
    }
    if (data.containsKey('megaminx_color_d_l')) {
      context.handle(
        _megaminxColorDLMeta,
        megaminxColorDL.isAcceptableOrUnknown(
          data['megaminx_color_d_l']!,
          _megaminxColorDLMeta,
        ),
      );
    }
    if (data.containsKey('fto_color_u')) {
      context.handle(
        _ftoColorUMeta,
        ftoColorU.isAcceptableOrUnknown(data['fto_color_u']!, _ftoColorUMeta),
      );
    }
    if (data.containsKey('fto_color_r')) {
      context.handle(
        _ftoColorRMeta,
        ftoColorR.isAcceptableOrUnknown(data['fto_color_r']!, _ftoColorRMeta),
      );
    }
    if (data.containsKey('fto_color_f')) {
      context.handle(
        _ftoColorFMeta,
        ftoColorF.isAcceptableOrUnknown(data['fto_color_f']!, _ftoColorFMeta),
      );
    }
    if (data.containsKey('fto_color_l')) {
      context.handle(
        _ftoColorLMeta,
        ftoColorL.isAcceptableOrUnknown(data['fto_color_l']!, _ftoColorLMeta),
      );
    }
    if (data.containsKey('fto_color_b')) {
      context.handle(
        _ftoColorBMeta,
        ftoColorB.isAcceptableOrUnknown(data['fto_color_b']!, _ftoColorBMeta),
      );
    }
    if (data.containsKey('fto_color_b_l')) {
      context.handle(
        _ftoColorBLMeta,
        ftoColorBL.isAcceptableOrUnknown(
          data['fto_color_b_l']!,
          _ftoColorBLMeta,
        ),
      );
    }
    if (data.containsKey('fto_color_d')) {
      context.handle(
        _ftoColorDMeta,
        ftoColorD.isAcceptableOrUnknown(data['fto_color_d']!, _ftoColorDMeta),
      );
    }
    if (data.containsKey('fto_color_b_r')) {
      context.handle(
        _ftoColorBRMeta,
        ftoColorBR.isAcceptableOrUnknown(
          data['fto_color_b_r']!,
          _ftoColorBRMeta,
        ),
      );
    }
    if (data.containsKey('clock_color_front')) {
      context.handle(
        _clockColorFrontMeta,
        clockColorFront.isAcceptableOrUnknown(
          data['clock_color_front']!,
          _clockColorFrontMeta,
        ),
      );
    }
    if (data.containsKey('clock_color_back')) {
      context.handle(
        _clockColorBackMeta,
        clockColorBack.isAcceptableOrUnknown(
          data['clock_color_back']!,
          _clockColorBackMeta,
        ),
      );
    }
    if (data.containsKey('timer_pressed_color')) {
      context.handle(
        _timerPressedColorMeta,
        timerPressedColor.isAcceptableOrUnknown(
          data['timer_pressed_color']!,
          _timerPressedColorMeta,
        ),
      );
    }
    if (data.containsKey('timer_holding_color')) {
      context.handle(
        _timerHoldingColorMeta,
        timerHoldingColor.isAcceptableOrUnknown(
          data['timer_holding_color']!,
          _timerHoldingColorMeta,
        ),
      );
    }
    if (data.containsKey('timer_accept_color')) {
      context.handle(
        _timerAcceptColorMeta,
        timerAcceptColor.isAcceptableOrUnknown(
          data['timer_accept_color']!,
          _timerAcceptColorMeta,
        ),
      );
    }
    if (data.containsKey('show_running_time')) {
      context.handle(
        _showRunningTimeMeta,
        showRunningTime.isAcceptableOrUnknown(
          data['show_running_time']!,
          _showRunningTimeMeta,
        ),
      );
    }
    if (data.containsKey('stackmat_enabled')) {
      context.handle(
        _stackmatEnabledMeta,
        stackmatEnabled.isAcceptableOrUnknown(
          data['stackmat_enabled']!,
          _stackmatEnabledMeta,
        ),
      );
    }
    if (data.containsKey('time_decimals')) {
      context.handle(
        _timeDecimalsMeta,
        timeDecimals.isAcceptableOrUnknown(
          data['time_decimals']!,
          _timeDecimalsMeta,
        ),
      );
    }
    if (data.containsKey('hold_duration')) {
      context.handle(
        _holdDurationMeta,
        holdDuration.isAcceptableOrUnknown(
          data['hold_duration']!,
          _holdDurationMeta,
        ),
      );
    }
    if (data.containsKey('show_scramble_image')) {
      context.handle(
        _showScrambleImageMeta,
        showScrambleImage.isAcceptableOrUnknown(
          data['show_scramble_image']!,
          _showScrambleImageMeta,
        ),
      );
    }
    if (data.containsKey('show_session_stats')) {
      context.handle(
        _showSessionStatsMeta,
        showSessionStats.isAcceptableOrUnknown(
          data['show_session_stats']!,
          _showSessionStatsMeta,
        ),
      );
    }
    if (data.containsKey('show_quick_actions')) {
      context.handle(
        _showQuickActionsMeta,
        showQuickActions.isAcceptableOrUnknown(
          data['show_quick_actions']!,
          _showQuickActionsMeta,
        ),
      );
    }
    if (data.containsKey('average_trim')) {
      context.handle(
        _averageTrimMeta,
        averageTrim.isAcceptableOrUnknown(
          data['average_trim']!,
          _averageTrimMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SettingsEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SettingsEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      inspectionEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}inspection_enabled'],
      )!,
      inspectDuration: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}inspect_duration'],
      )!,
      alertEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}alert_enabled'],
      )!,
      alertTypes: $SettingsTable.$converteralertTypes.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}alert_types'],
        )!,
      ),
      recordBestAlert: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}record_best_alert'],
      )!,
      recordWorstAlert: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}record_worst_alert'],
      )!,
      recordAverageAlert: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}record_average_alert'],
      )!,
      locale: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}locale'],
      ),
      themeMode: $SettingsTable.$converterthemeMode.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}theme_mode'],
        )!,
      ),
      primaryColor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}primary_color'],
      ),
      cubeColorU: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cube_color_u'],
      )!,
      cubeColorR: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cube_color_r'],
      )!,
      cubeColorF: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cube_color_f'],
      )!,
      cubeColorD: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cube_color_d'],
      )!,
      cubeColorL: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cube_color_l'],
      )!,
      cubeColorB: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cube_color_b'],
      )!,
      pyraminxColorU: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}pyraminx_color_u'],
      )!,
      pyraminxColorB: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}pyraminx_color_b'],
      )!,
      pyraminxColorR: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}pyraminx_color_r'],
      )!,
      pyraminxColorL: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}pyraminx_color_l'],
      )!,
      megaminxColorU: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}megaminx_color_u'],
      )!,
      megaminxColorBL: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}megaminx_color_b_l'],
      )!,
      megaminxColorBR: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}megaminx_color_b_r'],
      )!,
      megaminxColorR: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}megaminx_color_r'],
      )!,
      megaminxColorF: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}megaminx_color_f'],
      )!,
      megaminxColorL: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}megaminx_color_l'],
      )!,
      megaminxColorD: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}megaminx_color_d'],
      )!,
      megaminxColorDR: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}megaminx_color_d_r'],
      )!,
      megaminxColorDBR: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}megaminx_color_d_b_r'],
      )!,
      megaminxColorB: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}megaminx_color_b'],
      )!,
      megaminxColorDBL: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}megaminx_color_d_b_l'],
      )!,
      megaminxColorDL: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}megaminx_color_d_l'],
      )!,
      ftoColorU: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}fto_color_u'],
      )!,
      ftoColorR: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}fto_color_r'],
      )!,
      ftoColorF: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}fto_color_f'],
      )!,
      ftoColorL: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}fto_color_l'],
      )!,
      ftoColorB: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}fto_color_b'],
      )!,
      ftoColorBL: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}fto_color_b_l'],
      )!,
      ftoColorD: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}fto_color_d'],
      )!,
      ftoColorBR: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}fto_color_b_r'],
      )!,
      clockColorFront: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}clock_color_front'],
      )!,
      clockColorBack: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}clock_color_back'],
      )!,
      timerPressedColor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}timer_pressed_color'],
      )!,
      timerHoldingColor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}timer_holding_color'],
      )!,
      timerAcceptColor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}timer_accept_color'],
      )!,
      showRunningTime: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}show_running_time'],
      )!,
      stackmatEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}stackmat_enabled'],
      )!,
      timeDecimals: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}time_decimals'],
      )!,
      holdDuration: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}hold_duration'],
      )!,
      showScrambleImage: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}show_scramble_image'],
      )!,
      showSessionStats: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}show_session_stats'],
      )!,
      showQuickActions: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}show_quick_actions'],
      )!,
      averageTrim: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}average_trim'],
      )!,
    );
  }

  @override
  $SettingsTable createAlias(String alias) {
    return $SettingsTable(attachedDatabase, alias);
  }

  static TypeConverter<Set<AlertType>, String> $converteralertTypes =
      const AlertTypesConverter();
  static JsonTypeConverter2<AppThemeMode, String, String> $converterthemeMode =
      const EnumNameConverter<AppThemeMode>(AppThemeMode.values);
}

class SettingsEntry extends DataClass implements Insertable<SettingsEntry> {
  /// id
  final int id;

  /// whether to enable inspection
  final bool inspectionEnabled;

  /// inspect duration in seconds
  final int inspectDuration;

  /// whether to enable alert
  final bool alertEnabled;

  /// how the alert is given
  final Set<AlertType> alertTypes;

  /// whether a new best solve of the session is announced
  final bool recordBestAlert;

  /// whether a new worst solve of the session is announced
  final bool recordWorstAlert;

  /// whether a new best average (Mo3, Ao5, Ao12) of the session is announced
  final bool recordAverageAlert;

  /// locale
  ///
  /// `null` => system default
  final String? locale;

  /// light, dark, or as the system is
  final AppThemeMode themeMode;

  /// the app's primary colour, as int32 ARGB
  ///
  /// `null` => the theme's own
  final int? primaryColor;

  /// cube colors
  ///
  /// all colors are stored as int32 in ARGB format, aligned to flutter's Color
  final int cubeColorU;
  final int cubeColorR;
  final int cubeColorF;
  final int cubeColorD;
  final int cubeColorL;
  final int cubeColorB;

  /// pyraminx colors
  final int pyraminxColorU;
  final int pyraminxColorB;
  final int pyraminxColorR;
  final int pyraminxColorL;

  /// megaminx colors, one per face
  final int megaminxColorU;
  final int megaminxColorBL;
  final int megaminxColorBR;
  final int megaminxColorR;
  final int megaminxColorF;
  final int megaminxColorL;
  final int megaminxColorD;
  final int megaminxColorDR;
  final int megaminxColorDBR;
  final int megaminxColorB;
  final int megaminxColorDBL;
  final int megaminxColorDL;

  /// FTO colors, one per face
  final int ftoColorU;
  final int ftoColorR;
  final int ftoColorF;
  final int ftoColorL;
  final int ftoColorB;
  final int ftoColorBL;
  final int ftoColorD;
  final int ftoColorBR;

  /// clock colors
  final int clockColorFront;
  final int clockColorBack;

  /// timer colors
  final int timerPressedColor;
  final int timerHoldingColor;
  final int timerAcceptColor;

  /// whether the time is shown while a solve runs, or only `...` until it stops
  final bool showRunningTime;

  /// whether a Stackmat on the audio input starts and stops the solves, the screen then only opening
  /// inspection
  final bool stackmatEnabled;

  /// how many decimals the timer page shows a time with: 1, 2 or 3
  final int timeDecimals;

  /// how long the screen is held, in milliseconds, before it is ready to start a solve
  final int holdDuration;

  /// whether the timer page shows the picture of the scramble
  final bool showScrambleImage;

  /// whether the timer page shows the statistics of the session
  final bool showSessionStats;

  /// whether the buttons under the time (penalty, comment, delete) are shown after a solve
  final bool showQuickActions;

  /// the share of the solves of an average, in percent, left out at each end: the best ones and the
  /// worst ones. Rounded up to a whole solve, so 5 % trims one of an Ao5 and three of an Ao50.
  final int averageTrim;
  const SettingsEntry({
    required this.id,
    required this.inspectionEnabled,
    required this.inspectDuration,
    required this.alertEnabled,
    required this.alertTypes,
    required this.recordBestAlert,
    required this.recordWorstAlert,
    required this.recordAverageAlert,
    this.locale,
    required this.themeMode,
    this.primaryColor,
    required this.cubeColorU,
    required this.cubeColorR,
    required this.cubeColorF,
    required this.cubeColorD,
    required this.cubeColorL,
    required this.cubeColorB,
    required this.pyraminxColorU,
    required this.pyraminxColorB,
    required this.pyraminxColorR,
    required this.pyraminxColorL,
    required this.megaminxColorU,
    required this.megaminxColorBL,
    required this.megaminxColorBR,
    required this.megaminxColorR,
    required this.megaminxColorF,
    required this.megaminxColorL,
    required this.megaminxColorD,
    required this.megaminxColorDR,
    required this.megaminxColorDBR,
    required this.megaminxColorB,
    required this.megaminxColorDBL,
    required this.megaminxColorDL,
    required this.ftoColorU,
    required this.ftoColorR,
    required this.ftoColorF,
    required this.ftoColorL,
    required this.ftoColorB,
    required this.ftoColorBL,
    required this.ftoColorD,
    required this.ftoColorBR,
    required this.clockColorFront,
    required this.clockColorBack,
    required this.timerPressedColor,
    required this.timerHoldingColor,
    required this.timerAcceptColor,
    required this.showRunningTime,
    required this.stackmatEnabled,
    required this.timeDecimals,
    required this.holdDuration,
    required this.showScrambleImage,
    required this.showSessionStats,
    required this.showQuickActions,
    required this.averageTrim,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['inspection_enabled'] = Variable<bool>(inspectionEnabled);
    map['inspect_duration'] = Variable<int>(inspectDuration);
    map['alert_enabled'] = Variable<bool>(alertEnabled);
    {
      map['alert_types'] = Variable<String>(
        $SettingsTable.$converteralertTypes.toSql(alertTypes),
      );
    }
    map['record_best_alert'] = Variable<bool>(recordBestAlert);
    map['record_worst_alert'] = Variable<bool>(recordWorstAlert);
    map['record_average_alert'] = Variable<bool>(recordAverageAlert);
    if (!nullToAbsent || locale != null) {
      map['locale'] = Variable<String>(locale);
    }
    {
      map['theme_mode'] = Variable<String>(
        $SettingsTable.$converterthemeMode.toSql(themeMode),
      );
    }
    if (!nullToAbsent || primaryColor != null) {
      map['primary_color'] = Variable<int>(primaryColor);
    }
    map['cube_color_u'] = Variable<int>(cubeColorU);
    map['cube_color_r'] = Variable<int>(cubeColorR);
    map['cube_color_f'] = Variable<int>(cubeColorF);
    map['cube_color_d'] = Variable<int>(cubeColorD);
    map['cube_color_l'] = Variable<int>(cubeColorL);
    map['cube_color_b'] = Variable<int>(cubeColorB);
    map['pyraminx_color_u'] = Variable<int>(pyraminxColorU);
    map['pyraminx_color_b'] = Variable<int>(pyraminxColorB);
    map['pyraminx_color_r'] = Variable<int>(pyraminxColorR);
    map['pyraminx_color_l'] = Variable<int>(pyraminxColorL);
    map['megaminx_color_u'] = Variable<int>(megaminxColorU);
    map['megaminx_color_b_l'] = Variable<int>(megaminxColorBL);
    map['megaminx_color_b_r'] = Variable<int>(megaminxColorBR);
    map['megaminx_color_r'] = Variable<int>(megaminxColorR);
    map['megaminx_color_f'] = Variable<int>(megaminxColorF);
    map['megaminx_color_l'] = Variable<int>(megaminxColorL);
    map['megaminx_color_d'] = Variable<int>(megaminxColorD);
    map['megaminx_color_d_r'] = Variable<int>(megaminxColorDR);
    map['megaminx_color_d_b_r'] = Variable<int>(megaminxColorDBR);
    map['megaminx_color_b'] = Variable<int>(megaminxColorB);
    map['megaminx_color_d_b_l'] = Variable<int>(megaminxColorDBL);
    map['megaminx_color_d_l'] = Variable<int>(megaminxColorDL);
    map['fto_color_u'] = Variable<int>(ftoColorU);
    map['fto_color_r'] = Variable<int>(ftoColorR);
    map['fto_color_f'] = Variable<int>(ftoColorF);
    map['fto_color_l'] = Variable<int>(ftoColorL);
    map['fto_color_b'] = Variable<int>(ftoColorB);
    map['fto_color_b_l'] = Variable<int>(ftoColorBL);
    map['fto_color_d'] = Variable<int>(ftoColorD);
    map['fto_color_b_r'] = Variable<int>(ftoColorBR);
    map['clock_color_front'] = Variable<int>(clockColorFront);
    map['clock_color_back'] = Variable<int>(clockColorBack);
    map['timer_pressed_color'] = Variable<int>(timerPressedColor);
    map['timer_holding_color'] = Variable<int>(timerHoldingColor);
    map['timer_accept_color'] = Variable<int>(timerAcceptColor);
    map['show_running_time'] = Variable<bool>(showRunningTime);
    map['stackmat_enabled'] = Variable<bool>(stackmatEnabled);
    map['time_decimals'] = Variable<int>(timeDecimals);
    map['hold_duration'] = Variable<int>(holdDuration);
    map['show_scramble_image'] = Variable<bool>(showScrambleImage);
    map['show_session_stats'] = Variable<bool>(showSessionStats);
    map['show_quick_actions'] = Variable<bool>(showQuickActions);
    map['average_trim'] = Variable<int>(averageTrim);
    return map;
  }

  SettingsCompanion toCompanion(bool nullToAbsent) {
    return SettingsCompanion(
      id: Value(id),
      inspectionEnabled: Value(inspectionEnabled),
      inspectDuration: Value(inspectDuration),
      alertEnabled: Value(alertEnabled),
      alertTypes: Value(alertTypes),
      recordBestAlert: Value(recordBestAlert),
      recordWorstAlert: Value(recordWorstAlert),
      recordAverageAlert: Value(recordAverageAlert),
      locale: locale == null && nullToAbsent
          ? const Value.absent()
          : Value(locale),
      themeMode: Value(themeMode),
      primaryColor: primaryColor == null && nullToAbsent
          ? const Value.absent()
          : Value(primaryColor),
      cubeColorU: Value(cubeColorU),
      cubeColorR: Value(cubeColorR),
      cubeColorF: Value(cubeColorF),
      cubeColorD: Value(cubeColorD),
      cubeColorL: Value(cubeColorL),
      cubeColorB: Value(cubeColorB),
      pyraminxColorU: Value(pyraminxColorU),
      pyraminxColorB: Value(pyraminxColorB),
      pyraminxColorR: Value(pyraminxColorR),
      pyraminxColorL: Value(pyraminxColorL),
      megaminxColorU: Value(megaminxColorU),
      megaminxColorBL: Value(megaminxColorBL),
      megaminxColorBR: Value(megaminxColorBR),
      megaminxColorR: Value(megaminxColorR),
      megaminxColorF: Value(megaminxColorF),
      megaminxColorL: Value(megaminxColorL),
      megaminxColorD: Value(megaminxColorD),
      megaminxColorDR: Value(megaminxColorDR),
      megaminxColorDBR: Value(megaminxColorDBR),
      megaminxColorB: Value(megaminxColorB),
      megaminxColorDBL: Value(megaminxColorDBL),
      megaminxColorDL: Value(megaminxColorDL),
      ftoColorU: Value(ftoColorU),
      ftoColorR: Value(ftoColorR),
      ftoColorF: Value(ftoColorF),
      ftoColorL: Value(ftoColorL),
      ftoColorB: Value(ftoColorB),
      ftoColorBL: Value(ftoColorBL),
      ftoColorD: Value(ftoColorD),
      ftoColorBR: Value(ftoColorBR),
      clockColorFront: Value(clockColorFront),
      clockColorBack: Value(clockColorBack),
      timerPressedColor: Value(timerPressedColor),
      timerHoldingColor: Value(timerHoldingColor),
      timerAcceptColor: Value(timerAcceptColor),
      showRunningTime: Value(showRunningTime),
      stackmatEnabled: Value(stackmatEnabled),
      timeDecimals: Value(timeDecimals),
      holdDuration: Value(holdDuration),
      showScrambleImage: Value(showScrambleImage),
      showSessionStats: Value(showSessionStats),
      showQuickActions: Value(showQuickActions),
      averageTrim: Value(averageTrim),
    );
  }

  factory SettingsEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SettingsEntry(
      id: serializer.fromJson<int>(json['id']),
      inspectionEnabled: serializer.fromJson<bool>(json['inspectionEnabled']),
      inspectDuration: serializer.fromJson<int>(json['inspectDuration']),
      alertEnabled: serializer.fromJson<bool>(json['alertEnabled']),
      alertTypes: serializer.fromJson<Set<AlertType>>(json['alertTypes']),
      recordBestAlert: serializer.fromJson<bool>(json['recordBestAlert']),
      recordWorstAlert: serializer.fromJson<bool>(json['recordWorstAlert']),
      recordAverageAlert: serializer.fromJson<bool>(json['recordAverageAlert']),
      locale: serializer.fromJson<String?>(json['locale']),
      themeMode: $SettingsTable.$converterthemeMode.fromJson(
        serializer.fromJson<String>(json['themeMode']),
      ),
      primaryColor: serializer.fromJson<int?>(json['primaryColor']),
      cubeColorU: serializer.fromJson<int>(json['cubeColorU']),
      cubeColorR: serializer.fromJson<int>(json['cubeColorR']),
      cubeColorF: serializer.fromJson<int>(json['cubeColorF']),
      cubeColorD: serializer.fromJson<int>(json['cubeColorD']),
      cubeColorL: serializer.fromJson<int>(json['cubeColorL']),
      cubeColorB: serializer.fromJson<int>(json['cubeColorB']),
      pyraminxColorU: serializer.fromJson<int>(json['pyraminxColorU']),
      pyraminxColorB: serializer.fromJson<int>(json['pyraminxColorB']),
      pyraminxColorR: serializer.fromJson<int>(json['pyraminxColorR']),
      pyraminxColorL: serializer.fromJson<int>(json['pyraminxColorL']),
      megaminxColorU: serializer.fromJson<int>(json['megaminxColorU']),
      megaminxColorBL: serializer.fromJson<int>(json['megaminxColorBL']),
      megaminxColorBR: serializer.fromJson<int>(json['megaminxColorBR']),
      megaminxColorR: serializer.fromJson<int>(json['megaminxColorR']),
      megaminxColorF: serializer.fromJson<int>(json['megaminxColorF']),
      megaminxColorL: serializer.fromJson<int>(json['megaminxColorL']),
      megaminxColorD: serializer.fromJson<int>(json['megaminxColorD']),
      megaminxColorDR: serializer.fromJson<int>(json['megaminxColorDR']),
      megaminxColorDBR: serializer.fromJson<int>(json['megaminxColorDBR']),
      megaminxColorB: serializer.fromJson<int>(json['megaminxColorB']),
      megaminxColorDBL: serializer.fromJson<int>(json['megaminxColorDBL']),
      megaminxColorDL: serializer.fromJson<int>(json['megaminxColorDL']),
      ftoColorU: serializer.fromJson<int>(json['ftoColorU']),
      ftoColorR: serializer.fromJson<int>(json['ftoColorR']),
      ftoColorF: serializer.fromJson<int>(json['ftoColorF']),
      ftoColorL: serializer.fromJson<int>(json['ftoColorL']),
      ftoColorB: serializer.fromJson<int>(json['ftoColorB']),
      ftoColorBL: serializer.fromJson<int>(json['ftoColorBL']),
      ftoColorD: serializer.fromJson<int>(json['ftoColorD']),
      ftoColorBR: serializer.fromJson<int>(json['ftoColorBR']),
      clockColorFront: serializer.fromJson<int>(json['clockColorFront']),
      clockColorBack: serializer.fromJson<int>(json['clockColorBack']),
      timerPressedColor: serializer.fromJson<int>(json['timerPressedColor']),
      timerHoldingColor: serializer.fromJson<int>(json['timerHoldingColor']),
      timerAcceptColor: serializer.fromJson<int>(json['timerAcceptColor']),
      showRunningTime: serializer.fromJson<bool>(json['showRunningTime']),
      stackmatEnabled: serializer.fromJson<bool>(json['stackmatEnabled']),
      timeDecimals: serializer.fromJson<int>(json['timeDecimals']),
      holdDuration: serializer.fromJson<int>(json['holdDuration']),
      showScrambleImage: serializer.fromJson<bool>(json['showScrambleImage']),
      showSessionStats: serializer.fromJson<bool>(json['showSessionStats']),
      showQuickActions: serializer.fromJson<bool>(json['showQuickActions']),
      averageTrim: serializer.fromJson<int>(json['averageTrim']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'inspectionEnabled': serializer.toJson<bool>(inspectionEnabled),
      'inspectDuration': serializer.toJson<int>(inspectDuration),
      'alertEnabled': serializer.toJson<bool>(alertEnabled),
      'alertTypes': serializer.toJson<Set<AlertType>>(alertTypes),
      'recordBestAlert': serializer.toJson<bool>(recordBestAlert),
      'recordWorstAlert': serializer.toJson<bool>(recordWorstAlert),
      'recordAverageAlert': serializer.toJson<bool>(recordAverageAlert),
      'locale': serializer.toJson<String?>(locale),
      'themeMode': serializer.toJson<String>(
        $SettingsTable.$converterthemeMode.toJson(themeMode),
      ),
      'primaryColor': serializer.toJson<int?>(primaryColor),
      'cubeColorU': serializer.toJson<int>(cubeColorU),
      'cubeColorR': serializer.toJson<int>(cubeColorR),
      'cubeColorF': serializer.toJson<int>(cubeColorF),
      'cubeColorD': serializer.toJson<int>(cubeColorD),
      'cubeColorL': serializer.toJson<int>(cubeColorL),
      'cubeColorB': serializer.toJson<int>(cubeColorB),
      'pyraminxColorU': serializer.toJson<int>(pyraminxColorU),
      'pyraminxColorB': serializer.toJson<int>(pyraminxColorB),
      'pyraminxColorR': serializer.toJson<int>(pyraminxColorR),
      'pyraminxColorL': serializer.toJson<int>(pyraminxColorL),
      'megaminxColorU': serializer.toJson<int>(megaminxColorU),
      'megaminxColorBL': serializer.toJson<int>(megaminxColorBL),
      'megaminxColorBR': serializer.toJson<int>(megaminxColorBR),
      'megaminxColorR': serializer.toJson<int>(megaminxColorR),
      'megaminxColorF': serializer.toJson<int>(megaminxColorF),
      'megaminxColorL': serializer.toJson<int>(megaminxColorL),
      'megaminxColorD': serializer.toJson<int>(megaminxColorD),
      'megaminxColorDR': serializer.toJson<int>(megaminxColorDR),
      'megaminxColorDBR': serializer.toJson<int>(megaminxColorDBR),
      'megaminxColorB': serializer.toJson<int>(megaminxColorB),
      'megaminxColorDBL': serializer.toJson<int>(megaminxColorDBL),
      'megaminxColorDL': serializer.toJson<int>(megaminxColorDL),
      'ftoColorU': serializer.toJson<int>(ftoColorU),
      'ftoColorR': serializer.toJson<int>(ftoColorR),
      'ftoColorF': serializer.toJson<int>(ftoColorF),
      'ftoColorL': serializer.toJson<int>(ftoColorL),
      'ftoColorB': serializer.toJson<int>(ftoColorB),
      'ftoColorBL': serializer.toJson<int>(ftoColorBL),
      'ftoColorD': serializer.toJson<int>(ftoColorD),
      'ftoColorBR': serializer.toJson<int>(ftoColorBR),
      'clockColorFront': serializer.toJson<int>(clockColorFront),
      'clockColorBack': serializer.toJson<int>(clockColorBack),
      'timerPressedColor': serializer.toJson<int>(timerPressedColor),
      'timerHoldingColor': serializer.toJson<int>(timerHoldingColor),
      'timerAcceptColor': serializer.toJson<int>(timerAcceptColor),
      'showRunningTime': serializer.toJson<bool>(showRunningTime),
      'stackmatEnabled': serializer.toJson<bool>(stackmatEnabled),
      'timeDecimals': serializer.toJson<int>(timeDecimals),
      'holdDuration': serializer.toJson<int>(holdDuration),
      'showScrambleImage': serializer.toJson<bool>(showScrambleImage),
      'showSessionStats': serializer.toJson<bool>(showSessionStats),
      'showQuickActions': serializer.toJson<bool>(showQuickActions),
      'averageTrim': serializer.toJson<int>(averageTrim),
    };
  }

  SettingsEntry copyWith({
    int? id,
    bool? inspectionEnabled,
    int? inspectDuration,
    bool? alertEnabled,
    Set<AlertType>? alertTypes,
    bool? recordBestAlert,
    bool? recordWorstAlert,
    bool? recordAverageAlert,
    Value<String?> locale = const Value.absent(),
    AppThemeMode? themeMode,
    Value<int?> primaryColor = const Value.absent(),
    int? cubeColorU,
    int? cubeColorR,
    int? cubeColorF,
    int? cubeColorD,
    int? cubeColorL,
    int? cubeColorB,
    int? pyraminxColorU,
    int? pyraminxColorB,
    int? pyraminxColorR,
    int? pyraminxColorL,
    int? megaminxColorU,
    int? megaminxColorBL,
    int? megaminxColorBR,
    int? megaminxColorR,
    int? megaminxColorF,
    int? megaminxColorL,
    int? megaminxColorD,
    int? megaminxColorDR,
    int? megaminxColorDBR,
    int? megaminxColorB,
    int? megaminxColorDBL,
    int? megaminxColorDL,
    int? ftoColorU,
    int? ftoColorR,
    int? ftoColorF,
    int? ftoColorL,
    int? ftoColorB,
    int? ftoColorBL,
    int? ftoColorD,
    int? ftoColorBR,
    int? clockColorFront,
    int? clockColorBack,
    int? timerPressedColor,
    int? timerHoldingColor,
    int? timerAcceptColor,
    bool? showRunningTime,
    bool? stackmatEnabled,
    int? timeDecimals,
    int? holdDuration,
    bool? showScrambleImage,
    bool? showSessionStats,
    bool? showQuickActions,
    int? averageTrim,
  }) => SettingsEntry(
    id: id ?? this.id,
    inspectionEnabled: inspectionEnabled ?? this.inspectionEnabled,
    inspectDuration: inspectDuration ?? this.inspectDuration,
    alertEnabled: alertEnabled ?? this.alertEnabled,
    alertTypes: alertTypes ?? this.alertTypes,
    recordBestAlert: recordBestAlert ?? this.recordBestAlert,
    recordWorstAlert: recordWorstAlert ?? this.recordWorstAlert,
    recordAverageAlert: recordAverageAlert ?? this.recordAverageAlert,
    locale: locale.present ? locale.value : this.locale,
    themeMode: themeMode ?? this.themeMode,
    primaryColor: primaryColor.present ? primaryColor.value : this.primaryColor,
    cubeColorU: cubeColorU ?? this.cubeColorU,
    cubeColorR: cubeColorR ?? this.cubeColorR,
    cubeColorF: cubeColorF ?? this.cubeColorF,
    cubeColorD: cubeColorD ?? this.cubeColorD,
    cubeColorL: cubeColorL ?? this.cubeColorL,
    cubeColorB: cubeColorB ?? this.cubeColorB,
    pyraminxColorU: pyraminxColorU ?? this.pyraminxColorU,
    pyraminxColorB: pyraminxColorB ?? this.pyraminxColorB,
    pyraminxColorR: pyraminxColorR ?? this.pyraminxColorR,
    pyraminxColorL: pyraminxColorL ?? this.pyraminxColorL,
    megaminxColorU: megaminxColorU ?? this.megaminxColorU,
    megaminxColorBL: megaminxColorBL ?? this.megaminxColorBL,
    megaminxColorBR: megaminxColorBR ?? this.megaminxColorBR,
    megaminxColorR: megaminxColorR ?? this.megaminxColorR,
    megaminxColorF: megaminxColorF ?? this.megaminxColorF,
    megaminxColorL: megaminxColorL ?? this.megaminxColorL,
    megaminxColorD: megaminxColorD ?? this.megaminxColorD,
    megaminxColorDR: megaminxColorDR ?? this.megaminxColorDR,
    megaminxColorDBR: megaminxColorDBR ?? this.megaminxColorDBR,
    megaminxColorB: megaminxColorB ?? this.megaminxColorB,
    megaminxColorDBL: megaminxColorDBL ?? this.megaminxColorDBL,
    megaminxColorDL: megaminxColorDL ?? this.megaminxColorDL,
    ftoColorU: ftoColorU ?? this.ftoColorU,
    ftoColorR: ftoColorR ?? this.ftoColorR,
    ftoColorF: ftoColorF ?? this.ftoColorF,
    ftoColorL: ftoColorL ?? this.ftoColorL,
    ftoColorB: ftoColorB ?? this.ftoColorB,
    ftoColorBL: ftoColorBL ?? this.ftoColorBL,
    ftoColorD: ftoColorD ?? this.ftoColorD,
    ftoColorBR: ftoColorBR ?? this.ftoColorBR,
    clockColorFront: clockColorFront ?? this.clockColorFront,
    clockColorBack: clockColorBack ?? this.clockColorBack,
    timerPressedColor: timerPressedColor ?? this.timerPressedColor,
    timerHoldingColor: timerHoldingColor ?? this.timerHoldingColor,
    timerAcceptColor: timerAcceptColor ?? this.timerAcceptColor,
    showRunningTime: showRunningTime ?? this.showRunningTime,
    stackmatEnabled: stackmatEnabled ?? this.stackmatEnabled,
    timeDecimals: timeDecimals ?? this.timeDecimals,
    holdDuration: holdDuration ?? this.holdDuration,
    showScrambleImage: showScrambleImage ?? this.showScrambleImage,
    showSessionStats: showSessionStats ?? this.showSessionStats,
    showQuickActions: showQuickActions ?? this.showQuickActions,
    averageTrim: averageTrim ?? this.averageTrim,
  );
  SettingsEntry copyWithCompanion(SettingsCompanion data) {
    return SettingsEntry(
      id: data.id.present ? data.id.value : this.id,
      inspectionEnabled: data.inspectionEnabled.present
          ? data.inspectionEnabled.value
          : this.inspectionEnabled,
      inspectDuration: data.inspectDuration.present
          ? data.inspectDuration.value
          : this.inspectDuration,
      alertEnabled: data.alertEnabled.present
          ? data.alertEnabled.value
          : this.alertEnabled,
      alertTypes: data.alertTypes.present
          ? data.alertTypes.value
          : this.alertTypes,
      recordBestAlert: data.recordBestAlert.present
          ? data.recordBestAlert.value
          : this.recordBestAlert,
      recordWorstAlert: data.recordWorstAlert.present
          ? data.recordWorstAlert.value
          : this.recordWorstAlert,
      recordAverageAlert: data.recordAverageAlert.present
          ? data.recordAverageAlert.value
          : this.recordAverageAlert,
      locale: data.locale.present ? data.locale.value : this.locale,
      themeMode: data.themeMode.present ? data.themeMode.value : this.themeMode,
      primaryColor: data.primaryColor.present
          ? data.primaryColor.value
          : this.primaryColor,
      cubeColorU: data.cubeColorU.present
          ? data.cubeColorU.value
          : this.cubeColorU,
      cubeColorR: data.cubeColorR.present
          ? data.cubeColorR.value
          : this.cubeColorR,
      cubeColorF: data.cubeColorF.present
          ? data.cubeColorF.value
          : this.cubeColorF,
      cubeColorD: data.cubeColorD.present
          ? data.cubeColorD.value
          : this.cubeColorD,
      cubeColorL: data.cubeColorL.present
          ? data.cubeColorL.value
          : this.cubeColorL,
      cubeColorB: data.cubeColorB.present
          ? data.cubeColorB.value
          : this.cubeColorB,
      pyraminxColorU: data.pyraminxColorU.present
          ? data.pyraminxColorU.value
          : this.pyraminxColorU,
      pyraminxColorB: data.pyraminxColorB.present
          ? data.pyraminxColorB.value
          : this.pyraminxColorB,
      pyraminxColorR: data.pyraminxColorR.present
          ? data.pyraminxColorR.value
          : this.pyraminxColorR,
      pyraminxColorL: data.pyraminxColorL.present
          ? data.pyraminxColorL.value
          : this.pyraminxColorL,
      megaminxColorU: data.megaminxColorU.present
          ? data.megaminxColorU.value
          : this.megaminxColorU,
      megaminxColorBL: data.megaminxColorBL.present
          ? data.megaminxColorBL.value
          : this.megaminxColorBL,
      megaminxColorBR: data.megaminxColorBR.present
          ? data.megaminxColorBR.value
          : this.megaminxColorBR,
      megaminxColorR: data.megaminxColorR.present
          ? data.megaminxColorR.value
          : this.megaminxColorR,
      megaminxColorF: data.megaminxColorF.present
          ? data.megaminxColorF.value
          : this.megaminxColorF,
      megaminxColorL: data.megaminxColorL.present
          ? data.megaminxColorL.value
          : this.megaminxColorL,
      megaminxColorD: data.megaminxColorD.present
          ? data.megaminxColorD.value
          : this.megaminxColorD,
      megaminxColorDR: data.megaminxColorDR.present
          ? data.megaminxColorDR.value
          : this.megaminxColorDR,
      megaminxColorDBR: data.megaminxColorDBR.present
          ? data.megaminxColorDBR.value
          : this.megaminxColorDBR,
      megaminxColorB: data.megaminxColorB.present
          ? data.megaminxColorB.value
          : this.megaminxColorB,
      megaminxColorDBL: data.megaminxColorDBL.present
          ? data.megaminxColorDBL.value
          : this.megaminxColorDBL,
      megaminxColorDL: data.megaminxColorDL.present
          ? data.megaminxColorDL.value
          : this.megaminxColorDL,
      ftoColorU: data.ftoColorU.present ? data.ftoColorU.value : this.ftoColorU,
      ftoColorR: data.ftoColorR.present ? data.ftoColorR.value : this.ftoColorR,
      ftoColorF: data.ftoColorF.present ? data.ftoColorF.value : this.ftoColorF,
      ftoColorL: data.ftoColorL.present ? data.ftoColorL.value : this.ftoColorL,
      ftoColorB: data.ftoColorB.present ? data.ftoColorB.value : this.ftoColorB,
      ftoColorBL: data.ftoColorBL.present
          ? data.ftoColorBL.value
          : this.ftoColorBL,
      ftoColorD: data.ftoColorD.present ? data.ftoColorD.value : this.ftoColorD,
      ftoColorBR: data.ftoColorBR.present
          ? data.ftoColorBR.value
          : this.ftoColorBR,
      clockColorFront: data.clockColorFront.present
          ? data.clockColorFront.value
          : this.clockColorFront,
      clockColorBack: data.clockColorBack.present
          ? data.clockColorBack.value
          : this.clockColorBack,
      timerPressedColor: data.timerPressedColor.present
          ? data.timerPressedColor.value
          : this.timerPressedColor,
      timerHoldingColor: data.timerHoldingColor.present
          ? data.timerHoldingColor.value
          : this.timerHoldingColor,
      timerAcceptColor: data.timerAcceptColor.present
          ? data.timerAcceptColor.value
          : this.timerAcceptColor,
      showRunningTime: data.showRunningTime.present
          ? data.showRunningTime.value
          : this.showRunningTime,
      stackmatEnabled: data.stackmatEnabled.present
          ? data.stackmatEnabled.value
          : this.stackmatEnabled,
      timeDecimals: data.timeDecimals.present
          ? data.timeDecimals.value
          : this.timeDecimals,
      holdDuration: data.holdDuration.present
          ? data.holdDuration.value
          : this.holdDuration,
      showScrambleImage: data.showScrambleImage.present
          ? data.showScrambleImage.value
          : this.showScrambleImage,
      showSessionStats: data.showSessionStats.present
          ? data.showSessionStats.value
          : this.showSessionStats,
      showQuickActions: data.showQuickActions.present
          ? data.showQuickActions.value
          : this.showQuickActions,
      averageTrim: data.averageTrim.present
          ? data.averageTrim.value
          : this.averageTrim,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SettingsEntry(')
          ..write('id: $id, ')
          ..write('inspectionEnabled: $inspectionEnabled, ')
          ..write('inspectDuration: $inspectDuration, ')
          ..write('alertEnabled: $alertEnabled, ')
          ..write('alertTypes: $alertTypes, ')
          ..write('recordBestAlert: $recordBestAlert, ')
          ..write('recordWorstAlert: $recordWorstAlert, ')
          ..write('recordAverageAlert: $recordAverageAlert, ')
          ..write('locale: $locale, ')
          ..write('themeMode: $themeMode, ')
          ..write('primaryColor: $primaryColor, ')
          ..write('cubeColorU: $cubeColorU, ')
          ..write('cubeColorR: $cubeColorR, ')
          ..write('cubeColorF: $cubeColorF, ')
          ..write('cubeColorD: $cubeColorD, ')
          ..write('cubeColorL: $cubeColorL, ')
          ..write('cubeColorB: $cubeColorB, ')
          ..write('pyraminxColorU: $pyraminxColorU, ')
          ..write('pyraminxColorB: $pyraminxColorB, ')
          ..write('pyraminxColorR: $pyraminxColorR, ')
          ..write('pyraminxColorL: $pyraminxColorL, ')
          ..write('megaminxColorU: $megaminxColorU, ')
          ..write('megaminxColorBL: $megaminxColorBL, ')
          ..write('megaminxColorBR: $megaminxColorBR, ')
          ..write('megaminxColorR: $megaminxColorR, ')
          ..write('megaminxColorF: $megaminxColorF, ')
          ..write('megaminxColorL: $megaminxColorL, ')
          ..write('megaminxColorD: $megaminxColorD, ')
          ..write('megaminxColorDR: $megaminxColorDR, ')
          ..write('megaminxColorDBR: $megaminxColorDBR, ')
          ..write('megaminxColorB: $megaminxColorB, ')
          ..write('megaminxColorDBL: $megaminxColorDBL, ')
          ..write('megaminxColorDL: $megaminxColorDL, ')
          ..write('ftoColorU: $ftoColorU, ')
          ..write('ftoColorR: $ftoColorR, ')
          ..write('ftoColorF: $ftoColorF, ')
          ..write('ftoColorL: $ftoColorL, ')
          ..write('ftoColorB: $ftoColorB, ')
          ..write('ftoColorBL: $ftoColorBL, ')
          ..write('ftoColorD: $ftoColorD, ')
          ..write('ftoColorBR: $ftoColorBR, ')
          ..write('clockColorFront: $clockColorFront, ')
          ..write('clockColorBack: $clockColorBack, ')
          ..write('timerPressedColor: $timerPressedColor, ')
          ..write('timerHoldingColor: $timerHoldingColor, ')
          ..write('timerAcceptColor: $timerAcceptColor, ')
          ..write('showRunningTime: $showRunningTime, ')
          ..write('stackmatEnabled: $stackmatEnabled, ')
          ..write('timeDecimals: $timeDecimals, ')
          ..write('holdDuration: $holdDuration, ')
          ..write('showScrambleImage: $showScrambleImage, ')
          ..write('showSessionStats: $showSessionStats, ')
          ..write('showQuickActions: $showQuickActions, ')
          ..write('averageTrim: $averageTrim')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    inspectionEnabled,
    inspectDuration,
    alertEnabled,
    alertTypes,
    recordBestAlert,
    recordWorstAlert,
    recordAverageAlert,
    locale,
    themeMode,
    primaryColor,
    cubeColorU,
    cubeColorR,
    cubeColorF,
    cubeColorD,
    cubeColorL,
    cubeColorB,
    pyraminxColorU,
    pyraminxColorB,
    pyraminxColorR,
    pyraminxColorL,
    megaminxColorU,
    megaminxColorBL,
    megaminxColorBR,
    megaminxColorR,
    megaminxColorF,
    megaminxColorL,
    megaminxColorD,
    megaminxColorDR,
    megaminxColorDBR,
    megaminxColorB,
    megaminxColorDBL,
    megaminxColorDL,
    ftoColorU,
    ftoColorR,
    ftoColorF,
    ftoColorL,
    ftoColorB,
    ftoColorBL,
    ftoColorD,
    ftoColorBR,
    clockColorFront,
    clockColorBack,
    timerPressedColor,
    timerHoldingColor,
    timerAcceptColor,
    showRunningTime,
    stackmatEnabled,
    timeDecimals,
    holdDuration,
    showScrambleImage,
    showSessionStats,
    showQuickActions,
    averageTrim,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SettingsEntry &&
          other.id == this.id &&
          other.inspectionEnabled == this.inspectionEnabled &&
          other.inspectDuration == this.inspectDuration &&
          other.alertEnabled == this.alertEnabled &&
          other.alertTypes == this.alertTypes &&
          other.recordBestAlert == this.recordBestAlert &&
          other.recordWorstAlert == this.recordWorstAlert &&
          other.recordAverageAlert == this.recordAverageAlert &&
          other.locale == this.locale &&
          other.themeMode == this.themeMode &&
          other.primaryColor == this.primaryColor &&
          other.cubeColorU == this.cubeColorU &&
          other.cubeColorR == this.cubeColorR &&
          other.cubeColorF == this.cubeColorF &&
          other.cubeColorD == this.cubeColorD &&
          other.cubeColorL == this.cubeColorL &&
          other.cubeColorB == this.cubeColorB &&
          other.pyraminxColorU == this.pyraminxColorU &&
          other.pyraminxColorB == this.pyraminxColorB &&
          other.pyraminxColorR == this.pyraminxColorR &&
          other.pyraminxColorL == this.pyraminxColorL &&
          other.megaminxColorU == this.megaminxColorU &&
          other.megaminxColorBL == this.megaminxColorBL &&
          other.megaminxColorBR == this.megaminxColorBR &&
          other.megaminxColorR == this.megaminxColorR &&
          other.megaminxColorF == this.megaminxColorF &&
          other.megaminxColorL == this.megaminxColorL &&
          other.megaminxColorD == this.megaminxColorD &&
          other.megaminxColorDR == this.megaminxColorDR &&
          other.megaminxColorDBR == this.megaminxColorDBR &&
          other.megaminxColorB == this.megaminxColorB &&
          other.megaminxColorDBL == this.megaminxColorDBL &&
          other.megaminxColorDL == this.megaminxColorDL &&
          other.ftoColorU == this.ftoColorU &&
          other.ftoColorR == this.ftoColorR &&
          other.ftoColorF == this.ftoColorF &&
          other.ftoColorL == this.ftoColorL &&
          other.ftoColorB == this.ftoColorB &&
          other.ftoColorBL == this.ftoColorBL &&
          other.ftoColorD == this.ftoColorD &&
          other.ftoColorBR == this.ftoColorBR &&
          other.clockColorFront == this.clockColorFront &&
          other.clockColorBack == this.clockColorBack &&
          other.timerPressedColor == this.timerPressedColor &&
          other.timerHoldingColor == this.timerHoldingColor &&
          other.timerAcceptColor == this.timerAcceptColor &&
          other.showRunningTime == this.showRunningTime &&
          other.stackmatEnabled == this.stackmatEnabled &&
          other.timeDecimals == this.timeDecimals &&
          other.holdDuration == this.holdDuration &&
          other.showScrambleImage == this.showScrambleImage &&
          other.showSessionStats == this.showSessionStats &&
          other.showQuickActions == this.showQuickActions &&
          other.averageTrim == this.averageTrim);
}

class SettingsCompanion extends UpdateCompanion<SettingsEntry> {
  final Value<int> id;
  final Value<bool> inspectionEnabled;
  final Value<int> inspectDuration;
  final Value<bool> alertEnabled;
  final Value<Set<AlertType>> alertTypes;
  final Value<bool> recordBestAlert;
  final Value<bool> recordWorstAlert;
  final Value<bool> recordAverageAlert;
  final Value<String?> locale;
  final Value<AppThemeMode> themeMode;
  final Value<int?> primaryColor;
  final Value<int> cubeColorU;
  final Value<int> cubeColorR;
  final Value<int> cubeColorF;
  final Value<int> cubeColorD;
  final Value<int> cubeColorL;
  final Value<int> cubeColorB;
  final Value<int> pyraminxColorU;
  final Value<int> pyraminxColorB;
  final Value<int> pyraminxColorR;
  final Value<int> pyraminxColorL;
  final Value<int> megaminxColorU;
  final Value<int> megaminxColorBL;
  final Value<int> megaminxColorBR;
  final Value<int> megaminxColorR;
  final Value<int> megaminxColorF;
  final Value<int> megaminxColorL;
  final Value<int> megaminxColorD;
  final Value<int> megaminxColorDR;
  final Value<int> megaminxColorDBR;
  final Value<int> megaminxColorB;
  final Value<int> megaminxColorDBL;
  final Value<int> megaminxColorDL;
  final Value<int> ftoColorU;
  final Value<int> ftoColorR;
  final Value<int> ftoColorF;
  final Value<int> ftoColorL;
  final Value<int> ftoColorB;
  final Value<int> ftoColorBL;
  final Value<int> ftoColorD;
  final Value<int> ftoColorBR;
  final Value<int> clockColorFront;
  final Value<int> clockColorBack;
  final Value<int> timerPressedColor;
  final Value<int> timerHoldingColor;
  final Value<int> timerAcceptColor;
  final Value<bool> showRunningTime;
  final Value<bool> stackmatEnabled;
  final Value<int> timeDecimals;
  final Value<int> holdDuration;
  final Value<bool> showScrambleImage;
  final Value<bool> showSessionStats;
  final Value<bool> showQuickActions;
  final Value<int> averageTrim;
  const SettingsCompanion({
    this.id = const Value.absent(),
    this.inspectionEnabled = const Value.absent(),
    this.inspectDuration = const Value.absent(),
    this.alertEnabled = const Value.absent(),
    this.alertTypes = const Value.absent(),
    this.recordBestAlert = const Value.absent(),
    this.recordWorstAlert = const Value.absent(),
    this.recordAverageAlert = const Value.absent(),
    this.locale = const Value.absent(),
    this.themeMode = const Value.absent(),
    this.primaryColor = const Value.absent(),
    this.cubeColorU = const Value.absent(),
    this.cubeColorR = const Value.absent(),
    this.cubeColorF = const Value.absent(),
    this.cubeColorD = const Value.absent(),
    this.cubeColorL = const Value.absent(),
    this.cubeColorB = const Value.absent(),
    this.pyraminxColorU = const Value.absent(),
    this.pyraminxColorB = const Value.absent(),
    this.pyraminxColorR = const Value.absent(),
    this.pyraminxColorL = const Value.absent(),
    this.megaminxColorU = const Value.absent(),
    this.megaminxColorBL = const Value.absent(),
    this.megaminxColorBR = const Value.absent(),
    this.megaminxColorR = const Value.absent(),
    this.megaminxColorF = const Value.absent(),
    this.megaminxColorL = const Value.absent(),
    this.megaminxColorD = const Value.absent(),
    this.megaminxColorDR = const Value.absent(),
    this.megaminxColorDBR = const Value.absent(),
    this.megaminxColorB = const Value.absent(),
    this.megaminxColorDBL = const Value.absent(),
    this.megaminxColorDL = const Value.absent(),
    this.ftoColorU = const Value.absent(),
    this.ftoColorR = const Value.absent(),
    this.ftoColorF = const Value.absent(),
    this.ftoColorL = const Value.absent(),
    this.ftoColorB = const Value.absent(),
    this.ftoColorBL = const Value.absent(),
    this.ftoColorD = const Value.absent(),
    this.ftoColorBR = const Value.absent(),
    this.clockColorFront = const Value.absent(),
    this.clockColorBack = const Value.absent(),
    this.timerPressedColor = const Value.absent(),
    this.timerHoldingColor = const Value.absent(),
    this.timerAcceptColor = const Value.absent(),
    this.showRunningTime = const Value.absent(),
    this.stackmatEnabled = const Value.absent(),
    this.timeDecimals = const Value.absent(),
    this.holdDuration = const Value.absent(),
    this.showScrambleImage = const Value.absent(),
    this.showSessionStats = const Value.absent(),
    this.showQuickActions = const Value.absent(),
    this.averageTrim = const Value.absent(),
  });
  SettingsCompanion.insert({
    this.id = const Value.absent(),
    this.inspectionEnabled = const Value.absent(),
    this.inspectDuration = const Value.absent(),
    this.alertEnabled = const Value.absent(),
    this.alertTypes = const Value.absent(),
    this.recordBestAlert = const Value.absent(),
    this.recordWorstAlert = const Value.absent(),
    this.recordAverageAlert = const Value.absent(),
    this.locale = const Value.absent(),
    this.themeMode = const Value.absent(),
    this.primaryColor = const Value.absent(),
    this.cubeColorU = const Value.absent(),
    this.cubeColorR = const Value.absent(),
    this.cubeColorF = const Value.absent(),
    this.cubeColorD = const Value.absent(),
    this.cubeColorL = const Value.absent(),
    this.cubeColorB = const Value.absent(),
    this.pyraminxColorU = const Value.absent(),
    this.pyraminxColorB = const Value.absent(),
    this.pyraminxColorR = const Value.absent(),
    this.pyraminxColorL = const Value.absent(),
    this.megaminxColorU = const Value.absent(),
    this.megaminxColorBL = const Value.absent(),
    this.megaminxColorBR = const Value.absent(),
    this.megaminxColorR = const Value.absent(),
    this.megaminxColorF = const Value.absent(),
    this.megaminxColorL = const Value.absent(),
    this.megaminxColorD = const Value.absent(),
    this.megaminxColorDR = const Value.absent(),
    this.megaminxColorDBR = const Value.absent(),
    this.megaminxColorB = const Value.absent(),
    this.megaminxColorDBL = const Value.absent(),
    this.megaminxColorDL = const Value.absent(),
    this.ftoColorU = const Value.absent(),
    this.ftoColorR = const Value.absent(),
    this.ftoColorF = const Value.absent(),
    this.ftoColorL = const Value.absent(),
    this.ftoColorB = const Value.absent(),
    this.ftoColorBL = const Value.absent(),
    this.ftoColorD = const Value.absent(),
    this.ftoColorBR = const Value.absent(),
    this.clockColorFront = const Value.absent(),
    this.clockColorBack = const Value.absent(),
    this.timerPressedColor = const Value.absent(),
    this.timerHoldingColor = const Value.absent(),
    this.timerAcceptColor = const Value.absent(),
    this.showRunningTime = const Value.absent(),
    this.stackmatEnabled = const Value.absent(),
    this.timeDecimals = const Value.absent(),
    this.holdDuration = const Value.absent(),
    this.showScrambleImage = const Value.absent(),
    this.showSessionStats = const Value.absent(),
    this.showQuickActions = const Value.absent(),
    this.averageTrim = const Value.absent(),
  });
  static Insertable<SettingsEntry> custom({
    Expression<int>? id,
    Expression<bool>? inspectionEnabled,
    Expression<int>? inspectDuration,
    Expression<bool>? alertEnabled,
    Expression<String>? alertTypes,
    Expression<bool>? recordBestAlert,
    Expression<bool>? recordWorstAlert,
    Expression<bool>? recordAverageAlert,
    Expression<String>? locale,
    Expression<String>? themeMode,
    Expression<int>? primaryColor,
    Expression<int>? cubeColorU,
    Expression<int>? cubeColorR,
    Expression<int>? cubeColorF,
    Expression<int>? cubeColorD,
    Expression<int>? cubeColorL,
    Expression<int>? cubeColorB,
    Expression<int>? pyraminxColorU,
    Expression<int>? pyraminxColorB,
    Expression<int>? pyraminxColorR,
    Expression<int>? pyraminxColorL,
    Expression<int>? megaminxColorU,
    Expression<int>? megaminxColorBL,
    Expression<int>? megaminxColorBR,
    Expression<int>? megaminxColorR,
    Expression<int>? megaminxColorF,
    Expression<int>? megaminxColorL,
    Expression<int>? megaminxColorD,
    Expression<int>? megaminxColorDR,
    Expression<int>? megaminxColorDBR,
    Expression<int>? megaminxColorB,
    Expression<int>? megaminxColorDBL,
    Expression<int>? megaminxColorDL,
    Expression<int>? ftoColorU,
    Expression<int>? ftoColorR,
    Expression<int>? ftoColorF,
    Expression<int>? ftoColorL,
    Expression<int>? ftoColorB,
    Expression<int>? ftoColorBL,
    Expression<int>? ftoColorD,
    Expression<int>? ftoColorBR,
    Expression<int>? clockColorFront,
    Expression<int>? clockColorBack,
    Expression<int>? timerPressedColor,
    Expression<int>? timerHoldingColor,
    Expression<int>? timerAcceptColor,
    Expression<bool>? showRunningTime,
    Expression<bool>? stackmatEnabled,
    Expression<int>? timeDecimals,
    Expression<int>? holdDuration,
    Expression<bool>? showScrambleImage,
    Expression<bool>? showSessionStats,
    Expression<bool>? showQuickActions,
    Expression<int>? averageTrim,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (inspectionEnabled != null) 'inspection_enabled': inspectionEnabled,
      if (inspectDuration != null) 'inspect_duration': inspectDuration,
      if (alertEnabled != null) 'alert_enabled': alertEnabled,
      if (alertTypes != null) 'alert_types': alertTypes,
      if (recordBestAlert != null) 'record_best_alert': recordBestAlert,
      if (recordWorstAlert != null) 'record_worst_alert': recordWorstAlert,
      if (recordAverageAlert != null)
        'record_average_alert': recordAverageAlert,
      if (locale != null) 'locale': locale,
      if (themeMode != null) 'theme_mode': themeMode,
      if (primaryColor != null) 'primary_color': primaryColor,
      if (cubeColorU != null) 'cube_color_u': cubeColorU,
      if (cubeColorR != null) 'cube_color_r': cubeColorR,
      if (cubeColorF != null) 'cube_color_f': cubeColorF,
      if (cubeColorD != null) 'cube_color_d': cubeColorD,
      if (cubeColorL != null) 'cube_color_l': cubeColorL,
      if (cubeColorB != null) 'cube_color_b': cubeColorB,
      if (pyraminxColorU != null) 'pyraminx_color_u': pyraminxColorU,
      if (pyraminxColorB != null) 'pyraminx_color_b': pyraminxColorB,
      if (pyraminxColorR != null) 'pyraminx_color_r': pyraminxColorR,
      if (pyraminxColorL != null) 'pyraminx_color_l': pyraminxColorL,
      if (megaminxColorU != null) 'megaminx_color_u': megaminxColorU,
      if (megaminxColorBL != null) 'megaminx_color_b_l': megaminxColorBL,
      if (megaminxColorBR != null) 'megaminx_color_b_r': megaminxColorBR,
      if (megaminxColorR != null) 'megaminx_color_r': megaminxColorR,
      if (megaminxColorF != null) 'megaminx_color_f': megaminxColorF,
      if (megaminxColorL != null) 'megaminx_color_l': megaminxColorL,
      if (megaminxColorD != null) 'megaminx_color_d': megaminxColorD,
      if (megaminxColorDR != null) 'megaminx_color_d_r': megaminxColorDR,
      if (megaminxColorDBR != null) 'megaminx_color_d_b_r': megaminxColorDBR,
      if (megaminxColorB != null) 'megaminx_color_b': megaminxColorB,
      if (megaminxColorDBL != null) 'megaminx_color_d_b_l': megaminxColorDBL,
      if (megaminxColorDL != null) 'megaminx_color_d_l': megaminxColorDL,
      if (ftoColorU != null) 'fto_color_u': ftoColorU,
      if (ftoColorR != null) 'fto_color_r': ftoColorR,
      if (ftoColorF != null) 'fto_color_f': ftoColorF,
      if (ftoColorL != null) 'fto_color_l': ftoColorL,
      if (ftoColorB != null) 'fto_color_b': ftoColorB,
      if (ftoColorBL != null) 'fto_color_b_l': ftoColorBL,
      if (ftoColorD != null) 'fto_color_d': ftoColorD,
      if (ftoColorBR != null) 'fto_color_b_r': ftoColorBR,
      if (clockColorFront != null) 'clock_color_front': clockColorFront,
      if (clockColorBack != null) 'clock_color_back': clockColorBack,
      if (timerPressedColor != null) 'timer_pressed_color': timerPressedColor,
      if (timerHoldingColor != null) 'timer_holding_color': timerHoldingColor,
      if (timerAcceptColor != null) 'timer_accept_color': timerAcceptColor,
      if (showRunningTime != null) 'show_running_time': showRunningTime,
      if (stackmatEnabled != null) 'stackmat_enabled': stackmatEnabled,
      if (timeDecimals != null) 'time_decimals': timeDecimals,
      if (holdDuration != null) 'hold_duration': holdDuration,
      if (showScrambleImage != null) 'show_scramble_image': showScrambleImage,
      if (showSessionStats != null) 'show_session_stats': showSessionStats,
      if (showQuickActions != null) 'show_quick_actions': showQuickActions,
      if (averageTrim != null) 'average_trim': averageTrim,
    });
  }

  SettingsCompanion copyWith({
    Value<int>? id,
    Value<bool>? inspectionEnabled,
    Value<int>? inspectDuration,
    Value<bool>? alertEnabled,
    Value<Set<AlertType>>? alertTypes,
    Value<bool>? recordBestAlert,
    Value<bool>? recordWorstAlert,
    Value<bool>? recordAverageAlert,
    Value<String?>? locale,
    Value<AppThemeMode>? themeMode,
    Value<int?>? primaryColor,
    Value<int>? cubeColorU,
    Value<int>? cubeColorR,
    Value<int>? cubeColorF,
    Value<int>? cubeColorD,
    Value<int>? cubeColorL,
    Value<int>? cubeColorB,
    Value<int>? pyraminxColorU,
    Value<int>? pyraminxColorB,
    Value<int>? pyraminxColorR,
    Value<int>? pyraminxColorL,
    Value<int>? megaminxColorU,
    Value<int>? megaminxColorBL,
    Value<int>? megaminxColorBR,
    Value<int>? megaminxColorR,
    Value<int>? megaminxColorF,
    Value<int>? megaminxColorL,
    Value<int>? megaminxColorD,
    Value<int>? megaminxColorDR,
    Value<int>? megaminxColorDBR,
    Value<int>? megaminxColorB,
    Value<int>? megaminxColorDBL,
    Value<int>? megaminxColorDL,
    Value<int>? ftoColorU,
    Value<int>? ftoColorR,
    Value<int>? ftoColorF,
    Value<int>? ftoColorL,
    Value<int>? ftoColorB,
    Value<int>? ftoColorBL,
    Value<int>? ftoColorD,
    Value<int>? ftoColorBR,
    Value<int>? clockColorFront,
    Value<int>? clockColorBack,
    Value<int>? timerPressedColor,
    Value<int>? timerHoldingColor,
    Value<int>? timerAcceptColor,
    Value<bool>? showRunningTime,
    Value<bool>? stackmatEnabled,
    Value<int>? timeDecimals,
    Value<int>? holdDuration,
    Value<bool>? showScrambleImage,
    Value<bool>? showSessionStats,
    Value<bool>? showQuickActions,
    Value<int>? averageTrim,
  }) {
    return SettingsCompanion(
      id: id ?? this.id,
      inspectionEnabled: inspectionEnabled ?? this.inspectionEnabled,
      inspectDuration: inspectDuration ?? this.inspectDuration,
      alertEnabled: alertEnabled ?? this.alertEnabled,
      alertTypes: alertTypes ?? this.alertTypes,
      recordBestAlert: recordBestAlert ?? this.recordBestAlert,
      recordWorstAlert: recordWorstAlert ?? this.recordWorstAlert,
      recordAverageAlert: recordAverageAlert ?? this.recordAverageAlert,
      locale: locale ?? this.locale,
      themeMode: themeMode ?? this.themeMode,
      primaryColor: primaryColor ?? this.primaryColor,
      cubeColorU: cubeColorU ?? this.cubeColorU,
      cubeColorR: cubeColorR ?? this.cubeColorR,
      cubeColorF: cubeColorF ?? this.cubeColorF,
      cubeColorD: cubeColorD ?? this.cubeColorD,
      cubeColorL: cubeColorL ?? this.cubeColorL,
      cubeColorB: cubeColorB ?? this.cubeColorB,
      pyraminxColorU: pyraminxColorU ?? this.pyraminxColorU,
      pyraminxColorB: pyraminxColorB ?? this.pyraminxColorB,
      pyraminxColorR: pyraminxColorR ?? this.pyraminxColorR,
      pyraminxColorL: pyraminxColorL ?? this.pyraminxColorL,
      megaminxColorU: megaminxColorU ?? this.megaminxColorU,
      megaminxColorBL: megaminxColorBL ?? this.megaminxColorBL,
      megaminxColorBR: megaminxColorBR ?? this.megaminxColorBR,
      megaminxColorR: megaminxColorR ?? this.megaminxColorR,
      megaminxColorF: megaminxColorF ?? this.megaminxColorF,
      megaminxColorL: megaminxColorL ?? this.megaminxColorL,
      megaminxColorD: megaminxColorD ?? this.megaminxColorD,
      megaminxColorDR: megaminxColorDR ?? this.megaminxColorDR,
      megaminxColorDBR: megaminxColorDBR ?? this.megaminxColorDBR,
      megaminxColorB: megaminxColorB ?? this.megaminxColorB,
      megaminxColorDBL: megaminxColorDBL ?? this.megaminxColorDBL,
      megaminxColorDL: megaminxColorDL ?? this.megaminxColorDL,
      ftoColorU: ftoColorU ?? this.ftoColorU,
      ftoColorR: ftoColorR ?? this.ftoColorR,
      ftoColorF: ftoColorF ?? this.ftoColorF,
      ftoColorL: ftoColorL ?? this.ftoColorL,
      ftoColorB: ftoColorB ?? this.ftoColorB,
      ftoColorBL: ftoColorBL ?? this.ftoColorBL,
      ftoColorD: ftoColorD ?? this.ftoColorD,
      ftoColorBR: ftoColorBR ?? this.ftoColorBR,
      clockColorFront: clockColorFront ?? this.clockColorFront,
      clockColorBack: clockColorBack ?? this.clockColorBack,
      timerPressedColor: timerPressedColor ?? this.timerPressedColor,
      timerHoldingColor: timerHoldingColor ?? this.timerHoldingColor,
      timerAcceptColor: timerAcceptColor ?? this.timerAcceptColor,
      showRunningTime: showRunningTime ?? this.showRunningTime,
      stackmatEnabled: stackmatEnabled ?? this.stackmatEnabled,
      timeDecimals: timeDecimals ?? this.timeDecimals,
      holdDuration: holdDuration ?? this.holdDuration,
      showScrambleImage: showScrambleImage ?? this.showScrambleImage,
      showSessionStats: showSessionStats ?? this.showSessionStats,
      showQuickActions: showQuickActions ?? this.showQuickActions,
      averageTrim: averageTrim ?? this.averageTrim,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (inspectionEnabled.present) {
      map['inspection_enabled'] = Variable<bool>(inspectionEnabled.value);
    }
    if (inspectDuration.present) {
      map['inspect_duration'] = Variable<int>(inspectDuration.value);
    }
    if (alertEnabled.present) {
      map['alert_enabled'] = Variable<bool>(alertEnabled.value);
    }
    if (alertTypes.present) {
      map['alert_types'] = Variable<String>(
        $SettingsTable.$converteralertTypes.toSql(alertTypes.value),
      );
    }
    if (recordBestAlert.present) {
      map['record_best_alert'] = Variable<bool>(recordBestAlert.value);
    }
    if (recordWorstAlert.present) {
      map['record_worst_alert'] = Variable<bool>(recordWorstAlert.value);
    }
    if (recordAverageAlert.present) {
      map['record_average_alert'] = Variable<bool>(recordAverageAlert.value);
    }
    if (locale.present) {
      map['locale'] = Variable<String>(locale.value);
    }
    if (themeMode.present) {
      map['theme_mode'] = Variable<String>(
        $SettingsTable.$converterthemeMode.toSql(themeMode.value),
      );
    }
    if (primaryColor.present) {
      map['primary_color'] = Variable<int>(primaryColor.value);
    }
    if (cubeColorU.present) {
      map['cube_color_u'] = Variable<int>(cubeColorU.value);
    }
    if (cubeColorR.present) {
      map['cube_color_r'] = Variable<int>(cubeColorR.value);
    }
    if (cubeColorF.present) {
      map['cube_color_f'] = Variable<int>(cubeColorF.value);
    }
    if (cubeColorD.present) {
      map['cube_color_d'] = Variable<int>(cubeColorD.value);
    }
    if (cubeColorL.present) {
      map['cube_color_l'] = Variable<int>(cubeColorL.value);
    }
    if (cubeColorB.present) {
      map['cube_color_b'] = Variable<int>(cubeColorB.value);
    }
    if (pyraminxColorU.present) {
      map['pyraminx_color_u'] = Variable<int>(pyraminxColorU.value);
    }
    if (pyraminxColorB.present) {
      map['pyraminx_color_b'] = Variable<int>(pyraminxColorB.value);
    }
    if (pyraminxColorR.present) {
      map['pyraminx_color_r'] = Variable<int>(pyraminxColorR.value);
    }
    if (pyraminxColorL.present) {
      map['pyraminx_color_l'] = Variable<int>(pyraminxColorL.value);
    }
    if (megaminxColorU.present) {
      map['megaminx_color_u'] = Variable<int>(megaminxColorU.value);
    }
    if (megaminxColorBL.present) {
      map['megaminx_color_b_l'] = Variable<int>(megaminxColorBL.value);
    }
    if (megaminxColorBR.present) {
      map['megaminx_color_b_r'] = Variable<int>(megaminxColorBR.value);
    }
    if (megaminxColorR.present) {
      map['megaminx_color_r'] = Variable<int>(megaminxColorR.value);
    }
    if (megaminxColorF.present) {
      map['megaminx_color_f'] = Variable<int>(megaminxColorF.value);
    }
    if (megaminxColorL.present) {
      map['megaminx_color_l'] = Variable<int>(megaminxColorL.value);
    }
    if (megaminxColorD.present) {
      map['megaminx_color_d'] = Variable<int>(megaminxColorD.value);
    }
    if (megaminxColorDR.present) {
      map['megaminx_color_d_r'] = Variable<int>(megaminxColorDR.value);
    }
    if (megaminxColorDBR.present) {
      map['megaminx_color_d_b_r'] = Variable<int>(megaminxColorDBR.value);
    }
    if (megaminxColorB.present) {
      map['megaminx_color_b'] = Variable<int>(megaminxColorB.value);
    }
    if (megaminxColorDBL.present) {
      map['megaminx_color_d_b_l'] = Variable<int>(megaminxColorDBL.value);
    }
    if (megaminxColorDL.present) {
      map['megaminx_color_d_l'] = Variable<int>(megaminxColorDL.value);
    }
    if (ftoColorU.present) {
      map['fto_color_u'] = Variable<int>(ftoColorU.value);
    }
    if (ftoColorR.present) {
      map['fto_color_r'] = Variable<int>(ftoColorR.value);
    }
    if (ftoColorF.present) {
      map['fto_color_f'] = Variable<int>(ftoColorF.value);
    }
    if (ftoColorL.present) {
      map['fto_color_l'] = Variable<int>(ftoColorL.value);
    }
    if (ftoColorB.present) {
      map['fto_color_b'] = Variable<int>(ftoColorB.value);
    }
    if (ftoColorBL.present) {
      map['fto_color_b_l'] = Variable<int>(ftoColorBL.value);
    }
    if (ftoColorD.present) {
      map['fto_color_d'] = Variable<int>(ftoColorD.value);
    }
    if (ftoColorBR.present) {
      map['fto_color_b_r'] = Variable<int>(ftoColorBR.value);
    }
    if (clockColorFront.present) {
      map['clock_color_front'] = Variable<int>(clockColorFront.value);
    }
    if (clockColorBack.present) {
      map['clock_color_back'] = Variable<int>(clockColorBack.value);
    }
    if (timerPressedColor.present) {
      map['timer_pressed_color'] = Variable<int>(timerPressedColor.value);
    }
    if (timerHoldingColor.present) {
      map['timer_holding_color'] = Variable<int>(timerHoldingColor.value);
    }
    if (timerAcceptColor.present) {
      map['timer_accept_color'] = Variable<int>(timerAcceptColor.value);
    }
    if (showRunningTime.present) {
      map['show_running_time'] = Variable<bool>(showRunningTime.value);
    }
    if (stackmatEnabled.present) {
      map['stackmat_enabled'] = Variable<bool>(stackmatEnabled.value);
    }
    if (timeDecimals.present) {
      map['time_decimals'] = Variable<int>(timeDecimals.value);
    }
    if (holdDuration.present) {
      map['hold_duration'] = Variable<int>(holdDuration.value);
    }
    if (showScrambleImage.present) {
      map['show_scramble_image'] = Variable<bool>(showScrambleImage.value);
    }
    if (showSessionStats.present) {
      map['show_session_stats'] = Variable<bool>(showSessionStats.value);
    }
    if (showQuickActions.present) {
      map['show_quick_actions'] = Variable<bool>(showQuickActions.value);
    }
    if (averageTrim.present) {
      map['average_trim'] = Variable<int>(averageTrim.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsCompanion(')
          ..write('id: $id, ')
          ..write('inspectionEnabled: $inspectionEnabled, ')
          ..write('inspectDuration: $inspectDuration, ')
          ..write('alertEnabled: $alertEnabled, ')
          ..write('alertTypes: $alertTypes, ')
          ..write('recordBestAlert: $recordBestAlert, ')
          ..write('recordWorstAlert: $recordWorstAlert, ')
          ..write('recordAverageAlert: $recordAverageAlert, ')
          ..write('locale: $locale, ')
          ..write('themeMode: $themeMode, ')
          ..write('primaryColor: $primaryColor, ')
          ..write('cubeColorU: $cubeColorU, ')
          ..write('cubeColorR: $cubeColorR, ')
          ..write('cubeColorF: $cubeColorF, ')
          ..write('cubeColorD: $cubeColorD, ')
          ..write('cubeColorL: $cubeColorL, ')
          ..write('cubeColorB: $cubeColorB, ')
          ..write('pyraminxColorU: $pyraminxColorU, ')
          ..write('pyraminxColorB: $pyraminxColorB, ')
          ..write('pyraminxColorR: $pyraminxColorR, ')
          ..write('pyraminxColorL: $pyraminxColorL, ')
          ..write('megaminxColorU: $megaminxColorU, ')
          ..write('megaminxColorBL: $megaminxColorBL, ')
          ..write('megaminxColorBR: $megaminxColorBR, ')
          ..write('megaminxColorR: $megaminxColorR, ')
          ..write('megaminxColorF: $megaminxColorF, ')
          ..write('megaminxColorL: $megaminxColorL, ')
          ..write('megaminxColorD: $megaminxColorD, ')
          ..write('megaminxColorDR: $megaminxColorDR, ')
          ..write('megaminxColorDBR: $megaminxColorDBR, ')
          ..write('megaminxColorB: $megaminxColorB, ')
          ..write('megaminxColorDBL: $megaminxColorDBL, ')
          ..write('megaminxColorDL: $megaminxColorDL, ')
          ..write('ftoColorU: $ftoColorU, ')
          ..write('ftoColorR: $ftoColorR, ')
          ..write('ftoColorF: $ftoColorF, ')
          ..write('ftoColorL: $ftoColorL, ')
          ..write('ftoColorB: $ftoColorB, ')
          ..write('ftoColorBL: $ftoColorBL, ')
          ..write('ftoColorD: $ftoColorD, ')
          ..write('ftoColorBR: $ftoColorBR, ')
          ..write('clockColorFront: $clockColorFront, ')
          ..write('clockColorBack: $clockColorBack, ')
          ..write('timerPressedColor: $timerPressedColor, ')
          ..write('timerHoldingColor: $timerHoldingColor, ')
          ..write('timerAcceptColor: $timerAcceptColor, ')
          ..write('showRunningTime: $showRunningTime, ')
          ..write('stackmatEnabled: $stackmatEnabled, ')
          ..write('timeDecimals: $timeDecimals, ')
          ..write('holdDuration: $holdDuration, ')
          ..write('showScrambleImage: $showScrambleImage, ')
          ..write('showSessionStats: $showSessionStats, ')
          ..write('showQuickActions: $showQuickActions, ')
          ..write('averageTrim: $averageTrim')
          ..write(')'))
        .toString();
  }
}

class $SessionsTable extends Sessions
    with TableInfo<$SessionsTable, SessionEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: () => const Uuid().v4(),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, createdAt, deletedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<SessionEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SessionEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SessionEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $SessionsTable createAlias(String alias) {
    return $SessionsTable(attachedDatabase, alias);
  }
}

class SessionEntry extends DataClass implements Insertable<SessionEntry> {
  /// uuid
  final String id;

  /// session display name
  final String name;

  /// session creation time
  final DateTime createdAt;

  /// Soft delete, for the same reason as on Records: the deletion itself has
  /// to reach other devices.
  final DateTime? deletedAt;
  const SessionEntry({
    required this.id,
    required this.name,
    required this.createdAt,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  SessionsCompanion toCompanion(bool nullToAbsent) {
    return SessionsCompanion(
      id: Value(id),
      name: Value(name),
      createdAt: Value(createdAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory SessionEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SessionEntry(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  SessionEntry copyWith({
    String? id,
    String? name,
    DateTime? createdAt,
    Value<DateTime?> deletedAt = const Value.absent(),
  }) => SessionEntry(
    id: id ?? this.id,
    name: name ?? this.name,
    createdAt: createdAt ?? this.createdAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  SessionEntry copyWithCompanion(SessionsCompanion data) {
    return SessionEntry(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SessionEntry(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, createdAt, deletedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SessionEntry &&
          other.id == this.id &&
          other.name == this.name &&
          other.createdAt == this.createdAt &&
          other.deletedAt == this.deletedAt);
}

class SessionsCompanion extends UpdateCompanion<SessionEntry> {
  final Value<String> id;
  final Value<String> name;
  final Value<DateTime> createdAt;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const SessionsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SessionsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.createdAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : name = Value(name);
  static Insertable<SessionEntry> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (createdAt != null) 'created_at': createdAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SessionsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<DateTime>? createdAt,
    Value<DateTime?>? deletedAt,
    Value<int>? rowid,
  }) {
    return SessionsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SessionsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AppStateTable extends AppState
    with TableInfo<$AppStateTable, AppStateEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppStateTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<Puzzle, String> puzzle =
      GeneratedColumn<String>(
        'puzzle',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant("333"),
      ).withConverter<Puzzle>($AppStateTable.$converterpuzzle);
  static const VerificationMeta _sessionMeta = const VerificationMeta(
    'session',
  );
  @override
  late final GeneratedColumn<String> session = GeneratedColumn<String>(
    'session',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES sessions (id)',
    ),
    defaultValue: const Constant(kDefaultSessionId),
  );
  static const VerificationMeta _showArchivedMeta = const VerificationMeta(
    'showArchived',
  );
  @override
  late final GeneratedColumn<bool> showArchived = GeneratedColumn<bool>(
    'show_archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("show_archived" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [id, puzzle, session, showArchived];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_state';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppStateEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('session')) {
      context.handle(
        _sessionMeta,
        session.isAcceptableOrUnknown(data['session']!, _sessionMeta),
      );
    }
    if (data.containsKey('show_archived')) {
      context.handle(
        _showArchivedMeta,
        showArchived.isAcceptableOrUnknown(
          data['show_archived']!,
          _showArchivedMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AppStateEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppStateEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      puzzle: $AppStateTable.$converterpuzzle.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}puzzle'],
        )!,
      ),
      session: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session'],
      )!,
      showArchived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}show_archived'],
      )!,
    );
  }

  @override
  $AppStateTable createAlias(String alias) {
    return $AppStateTable(attachedDatabase, alias);
  }

  static TypeConverter<Puzzle, String> $converterpuzzle =
      const PuzzleTypeConverter();
}

class AppStateEntry extends DataClass implements Insertable<AppStateEntry> {
  final int id;

  /// current puzzle
  final Puzzle puzzle;

  /// current session, or [kDefaultSessionId] for the default session
  final String session;

  /// show recent or archived records in records page
  final bool showArchived;
  const AppStateEntry({
    required this.id,
    required this.puzzle,
    required this.session,
    required this.showArchived,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    {
      map['puzzle'] = Variable<String>(
        $AppStateTable.$converterpuzzle.toSql(puzzle),
      );
    }
    map['session'] = Variable<String>(session);
    map['show_archived'] = Variable<bool>(showArchived);
    return map;
  }

  AppStateCompanion toCompanion(bool nullToAbsent) {
    return AppStateCompanion(
      id: Value(id),
      puzzle: Value(puzzle),
      session: Value(session),
      showArchived: Value(showArchived),
    );
  }

  factory AppStateEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppStateEntry(
      id: serializer.fromJson<int>(json['id']),
      puzzle: serializer.fromJson<Puzzle>(json['puzzle']),
      session: serializer.fromJson<String>(json['session']),
      showArchived: serializer.fromJson<bool>(json['showArchived']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'puzzle': serializer.toJson<Puzzle>(puzzle),
      'session': serializer.toJson<String>(session),
      'showArchived': serializer.toJson<bool>(showArchived),
    };
  }

  AppStateEntry copyWith({
    int? id,
    Puzzle? puzzle,
    String? session,
    bool? showArchived,
  }) => AppStateEntry(
    id: id ?? this.id,
    puzzle: puzzle ?? this.puzzle,
    session: session ?? this.session,
    showArchived: showArchived ?? this.showArchived,
  );
  AppStateEntry copyWithCompanion(AppStateCompanion data) {
    return AppStateEntry(
      id: data.id.present ? data.id.value : this.id,
      puzzle: data.puzzle.present ? data.puzzle.value : this.puzzle,
      session: data.session.present ? data.session.value : this.session,
      showArchived: data.showArchived.present
          ? data.showArchived.value
          : this.showArchived,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppStateEntry(')
          ..write('id: $id, ')
          ..write('puzzle: $puzzle, ')
          ..write('session: $session, ')
          ..write('showArchived: $showArchived')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, puzzle, session, showArchived);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppStateEntry &&
          other.id == this.id &&
          other.puzzle == this.puzzle &&
          other.session == this.session &&
          other.showArchived == this.showArchived);
}

class AppStateCompanion extends UpdateCompanion<AppStateEntry> {
  final Value<int> id;
  final Value<Puzzle> puzzle;
  final Value<String> session;
  final Value<bool> showArchived;
  const AppStateCompanion({
    this.id = const Value.absent(),
    this.puzzle = const Value.absent(),
    this.session = const Value.absent(),
    this.showArchived = const Value.absent(),
  });
  AppStateCompanion.insert({
    this.id = const Value.absent(),
    this.puzzle = const Value.absent(),
    this.session = const Value.absent(),
    this.showArchived = const Value.absent(),
  });
  static Insertable<AppStateEntry> custom({
    Expression<int>? id,
    Expression<String>? puzzle,
    Expression<String>? session,
    Expression<bool>? showArchived,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (puzzle != null) 'puzzle': puzzle,
      if (session != null) 'session': session,
      if (showArchived != null) 'show_archived': showArchived,
    });
  }

  AppStateCompanion copyWith({
    Value<int>? id,
    Value<Puzzle>? puzzle,
    Value<String>? session,
    Value<bool>? showArchived,
  }) {
    return AppStateCompanion(
      id: id ?? this.id,
      puzzle: puzzle ?? this.puzzle,
      session: session ?? this.session,
      showArchived: showArchived ?? this.showArchived,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (puzzle.present) {
      map['puzzle'] = Variable<String>(
        $AppStateTable.$converterpuzzle.toSql(puzzle.value),
      );
    }
    if (session.present) {
      map['session'] = Variable<String>(session.value);
    }
    if (showArchived.present) {
      map['show_archived'] = Variable<bool>(showArchived.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppStateCompanion(')
          ..write('id: $id, ')
          ..write('puzzle: $puzzle, ')
          ..write('session: $session, ')
          ..write('showArchived: $showArchived')
          ..write(')'))
        .toString();
  }
}

class $RecordsTable extends Records with TableInfo<$RecordsTable, RecordEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: () => const Uuid().v4(),
  );
  @override
  late final GeneratedColumnWithTypeConverter<Puzzle, String> puzzle =
      GeneratedColumn<String>(
        'puzzle',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<Puzzle>($RecordsTable.$converterpuzzle);
  static const VerificationMeta _sessionMeta = const VerificationMeta(
    'session',
  );
  @override
  late final GeneratedColumn<String> session = GeneratedColumn<String>(
    'session',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES sessions (id)',
    ),
  );
  static const VerificationMeta _scrambleMeta = const VerificationMeta(
    'scramble',
  );
  @override
  late final GeneratedColumn<String> scramble = GeneratedColumn<String>(
    'scramble',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timeMeta = const VerificationMeta('time');
  @override
  late final GeneratedColumn<int> time = GeneratedColumn<int>(
    'time',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _datetimeMeta = const VerificationMeta(
    'datetime',
  );
  @override
  late final GeneratedColumn<DateTime> datetime = GeneratedColumn<DateTime>(
    'datetime',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  late final GeneratedColumnWithTypeConverter<Penalty, String> penalty =
      GeneratedColumn<String>(
        'penalty',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<Penalty>($RecordsTable.$converterpenalty);
  static const VerificationMeta _commentMeta = const VerificationMeta(
    'comment',
  );
  @override
  late final GeneratedColumn<String> comment = GeneratedColumn<String>(
    'comment',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _archivedMeta = const VerificationMeta(
    'archived',
  );
  @override
  late final GeneratedColumn<bool> archived = GeneratedColumn<bool>(
    'archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("archived" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    puzzle,
    session,
    scramble,
    time,
    datetime,
    penalty,
    comment,
    deletedAt,
    archived,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'records';
  @override
  VerificationContext validateIntegrity(
    Insertable<RecordEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('session')) {
      context.handle(
        _sessionMeta,
        session.isAcceptableOrUnknown(data['session']!, _sessionMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionMeta);
    }
    if (data.containsKey('scramble')) {
      context.handle(
        _scrambleMeta,
        scramble.isAcceptableOrUnknown(data['scramble']!, _scrambleMeta),
      );
    } else if (isInserting) {
      context.missing(_scrambleMeta);
    }
    if (data.containsKey('time')) {
      context.handle(
        _timeMeta,
        time.isAcceptableOrUnknown(data['time']!, _timeMeta),
      );
    } else if (isInserting) {
      context.missing(_timeMeta);
    }
    if (data.containsKey('datetime')) {
      context.handle(
        _datetimeMeta,
        datetime.isAcceptableOrUnknown(data['datetime']!, _datetimeMeta),
      );
    }
    if (data.containsKey('comment')) {
      context.handle(
        _commentMeta,
        comment.isAcceptableOrUnknown(data['comment']!, _commentMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('archived')) {
      context.handle(
        _archivedMeta,
        archived.isAcceptableOrUnknown(data['archived']!, _archivedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RecordEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecordEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      puzzle: $RecordsTable.$converterpuzzle.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}puzzle'],
        )!,
      ),
      session: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session'],
      )!,
      scramble: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}scramble'],
      )!,
      time: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}time'],
      )!,
      datetime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}datetime'],
      )!,
      penalty: $RecordsTable.$converterpenalty.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}penalty'],
        )!,
      ),
      comment: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}comment'],
      ),
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      archived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}archived'],
      )!,
    );
  }

  @override
  $RecordsTable createAlias(String alias) {
    return $RecordsTable(attachedDatabase, alias);
  }

  static TypeConverter<Puzzle, String> $converterpuzzle =
      const PuzzleTypeConverter();
  static TypeConverter<Penalty, String> $converterpenalty =
      const PenaltyTypeConverter();
}

class RecordEntry extends DataClass implements Insertable<RecordEntry> {
  /// uuid
  final String id;

  /// puzzle
  final Puzzle puzzle;

  /// session id
  final String session;

  /// scramble
  final String scramble;

  /// Raw stopwatch reading in milliseconds, before any penalty is applied.
  final int time;

  /// The time the solve was recorded.
  final DateTime datetime;

  /// penalty
  final Penalty penalty;

  /// comment
  final String? comment;

  /// Soft delete: set instead of removing the row, so the deletion itself can
  /// travel to other devices. Every query reading solves must exclude these.
  final DateTime? deletedAt;

  /// archived
  final bool archived;
  const RecordEntry({
    required this.id,
    required this.puzzle,
    required this.session,
    required this.scramble,
    required this.time,
    required this.datetime,
    required this.penalty,
    this.comment,
    this.deletedAt,
    required this.archived,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    {
      map['puzzle'] = Variable<String>(
        $RecordsTable.$converterpuzzle.toSql(puzzle),
      );
    }
    map['session'] = Variable<String>(session);
    map['scramble'] = Variable<String>(scramble);
    map['time'] = Variable<int>(time);
    map['datetime'] = Variable<DateTime>(datetime);
    {
      map['penalty'] = Variable<String>(
        $RecordsTable.$converterpenalty.toSql(penalty),
      );
    }
    if (!nullToAbsent || comment != null) {
      map['comment'] = Variable<String>(comment);
    }
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['archived'] = Variable<bool>(archived);
    return map;
  }

  RecordsCompanion toCompanion(bool nullToAbsent) {
    return RecordsCompanion(
      id: Value(id),
      puzzle: Value(puzzle),
      session: Value(session),
      scramble: Value(scramble),
      time: Value(time),
      datetime: Value(datetime),
      penalty: Value(penalty),
      comment: comment == null && nullToAbsent
          ? const Value.absent()
          : Value(comment),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      archived: Value(archived),
    );
  }

  factory RecordEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecordEntry(
      id: serializer.fromJson<String>(json['id']),
      puzzle: serializer.fromJson<Puzzle>(json['puzzle']),
      session: serializer.fromJson<String>(json['session']),
      scramble: serializer.fromJson<String>(json['scramble']),
      time: serializer.fromJson<int>(json['time']),
      datetime: serializer.fromJson<DateTime>(json['datetime']),
      penalty: serializer.fromJson<Penalty>(json['penalty']),
      comment: serializer.fromJson<String?>(json['comment']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      archived: serializer.fromJson<bool>(json['archived']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'puzzle': serializer.toJson<Puzzle>(puzzle),
      'session': serializer.toJson<String>(session),
      'scramble': serializer.toJson<String>(scramble),
      'time': serializer.toJson<int>(time),
      'datetime': serializer.toJson<DateTime>(datetime),
      'penalty': serializer.toJson<Penalty>(penalty),
      'comment': serializer.toJson<String?>(comment),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'archived': serializer.toJson<bool>(archived),
    };
  }

  RecordEntry copyWith({
    String? id,
    Puzzle? puzzle,
    String? session,
    String? scramble,
    int? time,
    DateTime? datetime,
    Penalty? penalty,
    Value<String?> comment = const Value.absent(),
    Value<DateTime?> deletedAt = const Value.absent(),
    bool? archived,
  }) => RecordEntry(
    id: id ?? this.id,
    puzzle: puzzle ?? this.puzzle,
    session: session ?? this.session,
    scramble: scramble ?? this.scramble,
    time: time ?? this.time,
    datetime: datetime ?? this.datetime,
    penalty: penalty ?? this.penalty,
    comment: comment.present ? comment.value : this.comment,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    archived: archived ?? this.archived,
  );
  RecordEntry copyWithCompanion(RecordsCompanion data) {
    return RecordEntry(
      id: data.id.present ? data.id.value : this.id,
      puzzle: data.puzzle.present ? data.puzzle.value : this.puzzle,
      session: data.session.present ? data.session.value : this.session,
      scramble: data.scramble.present ? data.scramble.value : this.scramble,
      time: data.time.present ? data.time.value : this.time,
      datetime: data.datetime.present ? data.datetime.value : this.datetime,
      penalty: data.penalty.present ? data.penalty.value : this.penalty,
      comment: data.comment.present ? data.comment.value : this.comment,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      archived: data.archived.present ? data.archived.value : this.archived,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecordEntry(')
          ..write('id: $id, ')
          ..write('puzzle: $puzzle, ')
          ..write('session: $session, ')
          ..write('scramble: $scramble, ')
          ..write('time: $time, ')
          ..write('datetime: $datetime, ')
          ..write('penalty: $penalty, ')
          ..write('comment: $comment, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('archived: $archived')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    puzzle,
    session,
    scramble,
    time,
    datetime,
    penalty,
    comment,
    deletedAt,
    archived,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecordEntry &&
          other.id == this.id &&
          other.puzzle == this.puzzle &&
          other.session == this.session &&
          other.scramble == this.scramble &&
          other.time == this.time &&
          other.datetime == this.datetime &&
          other.penalty == this.penalty &&
          other.comment == this.comment &&
          other.deletedAt == this.deletedAt &&
          other.archived == this.archived);
}

class RecordsCompanion extends UpdateCompanion<RecordEntry> {
  final Value<String> id;
  final Value<Puzzle> puzzle;
  final Value<String> session;
  final Value<String> scramble;
  final Value<int> time;
  final Value<DateTime> datetime;
  final Value<Penalty> penalty;
  final Value<String?> comment;
  final Value<DateTime?> deletedAt;
  final Value<bool> archived;
  final Value<int> rowid;
  const RecordsCompanion({
    this.id = const Value.absent(),
    this.puzzle = const Value.absent(),
    this.session = const Value.absent(),
    this.scramble = const Value.absent(),
    this.time = const Value.absent(),
    this.datetime = const Value.absent(),
    this.penalty = const Value.absent(),
    this.comment = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.archived = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RecordsCompanion.insert({
    this.id = const Value.absent(),
    required Puzzle puzzle,
    required String session,
    required String scramble,
    required int time,
    this.datetime = const Value.absent(),
    required Penalty penalty,
    this.comment = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.archived = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : puzzle = Value(puzzle),
       session = Value(session),
       scramble = Value(scramble),
       time = Value(time),
       penalty = Value(penalty);
  static Insertable<RecordEntry> custom({
    Expression<String>? id,
    Expression<String>? puzzle,
    Expression<String>? session,
    Expression<String>? scramble,
    Expression<int>? time,
    Expression<DateTime>? datetime,
    Expression<String>? penalty,
    Expression<String>? comment,
    Expression<DateTime>? deletedAt,
    Expression<bool>? archived,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (puzzle != null) 'puzzle': puzzle,
      if (session != null) 'session': session,
      if (scramble != null) 'scramble': scramble,
      if (time != null) 'time': time,
      if (datetime != null) 'datetime': datetime,
      if (penalty != null) 'penalty': penalty,
      if (comment != null) 'comment': comment,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (archived != null) 'archived': archived,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RecordsCompanion copyWith({
    Value<String>? id,
    Value<Puzzle>? puzzle,
    Value<String>? session,
    Value<String>? scramble,
    Value<int>? time,
    Value<DateTime>? datetime,
    Value<Penalty>? penalty,
    Value<String?>? comment,
    Value<DateTime?>? deletedAt,
    Value<bool>? archived,
    Value<int>? rowid,
  }) {
    return RecordsCompanion(
      id: id ?? this.id,
      puzzle: puzzle ?? this.puzzle,
      session: session ?? this.session,
      scramble: scramble ?? this.scramble,
      time: time ?? this.time,
      datetime: datetime ?? this.datetime,
      penalty: penalty ?? this.penalty,
      comment: comment ?? this.comment,
      deletedAt: deletedAt ?? this.deletedAt,
      archived: archived ?? this.archived,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (puzzle.present) {
      map['puzzle'] = Variable<String>(
        $RecordsTable.$converterpuzzle.toSql(puzzle.value),
      );
    }
    if (session.present) {
      map['session'] = Variable<String>(session.value);
    }
    if (scramble.present) {
      map['scramble'] = Variable<String>(scramble.value);
    }
    if (time.present) {
      map['time'] = Variable<int>(time.value);
    }
    if (datetime.present) {
      map['datetime'] = Variable<DateTime>(datetime.value);
    }
    if (penalty.present) {
      map['penalty'] = Variable<String>(
        $RecordsTable.$converterpenalty.toSql(penalty.value),
      );
    }
    if (comment.present) {
      map['comment'] = Variable<String>(comment.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (archived.present) {
      map['archived'] = Variable<bool>(archived.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecordsCompanion(')
          ..write('id: $id, ')
          ..write('puzzle: $puzzle, ')
          ..write('session: $session, ')
          ..write('scramble: $scramble, ')
          ..write('time: $time, ')
          ..write('datetime: $datetime, ')
          ..write('penalty: $penalty, ')
          ..write('comment: $comment, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('archived: $archived, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SettingsTable settings = $SettingsTable(this);
  late final $SessionsTable sessions = $SessionsTable(this);
  late final $AppStateTable appState = $AppStateTable(this);
  late final $RecordsTable records = $RecordsTable(this);
  late final Index recordsSessionPuzzle = Index(
    'records_session_puzzle',
    'CREATE INDEX records_session_puzzle ON records (session, puzzle, datetime)',
  );
  late final SettingsDao settingsDao = SettingsDao(this as AppDatabase);
  late final AppStateDao appStateDao = AppStateDao(this as AppDatabase);
  late final RecordsDao recordsDao = RecordsDao(this as AppDatabase);
  late final SessionsDao sessionsDao = SessionsDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    settings,
    sessions,
    appState,
    records,
    recordsSessionPuzzle,
  ];
}

typedef $$SettingsTableCreateCompanionBuilder = SettingsCompanion Function({
  Value<int> id,
  Value<bool> inspectionEnabled,
  Value<int> inspectDuration,
  Value<bool> alertEnabled,
  Value<Set<AlertType>> alertTypes,
  Value<bool> recordBestAlert,
  Value<bool> recordWorstAlert,
  Value<bool> recordAverageAlert,
  Value<String?> locale,
  Value<AppThemeMode> themeMode,
  Value<int?> primaryColor,
  Value<int> cubeColorU,
  Value<int> cubeColorR,
  Value<int> cubeColorF,
  Value<int> cubeColorD,
  Value<int> cubeColorL,
  Value<int> cubeColorB,
  Value<int> pyraminxColorU,
  Value<int> pyraminxColorB,
  Value<int> pyraminxColorR,
  Value<int> pyraminxColorL,
  Value<int> megaminxColorU,
  Value<int> megaminxColorBL,
  Value<int> megaminxColorBR,
  Value<int> megaminxColorR,
  Value<int> megaminxColorF,
  Value<int> megaminxColorL,
  Value<int> megaminxColorD,
  Value<int> megaminxColorDR,
  Value<int> megaminxColorDBR,
  Value<int> megaminxColorB,
  Value<int> megaminxColorDBL,
  Value<int> megaminxColorDL,
  Value<int> ftoColorU,
  Value<int> ftoColorR,
  Value<int> ftoColorF,
  Value<int> ftoColorL,
  Value<int> ftoColorB,
  Value<int> ftoColorBL,
  Value<int> ftoColorD,
  Value<int> ftoColorBR,
  Value<int> clockColorFront,
  Value<int> clockColorBack,
  Value<int> timerPressedColor,
  Value<int> timerHoldingColor,
  Value<int> timerAcceptColor,
  Value<bool> showRunningTime,
  Value<bool> stackmatEnabled,
  Value<int> timeDecimals,
  Value<int> holdDuration,
  Value<bool> showScrambleImage,
  Value<bool> showSessionStats,
  Value<bool> showQuickActions,
  Value<int> averageTrim,
});
typedef $$SettingsTableUpdateCompanionBuilder = SettingsCompanion Function({
  Value<int> id,
  Value<bool> inspectionEnabled,
  Value<int> inspectDuration,
  Value<bool> alertEnabled,
  Value<Set<AlertType>> alertTypes,
  Value<bool> recordBestAlert,
  Value<bool> recordWorstAlert,
  Value<bool> recordAverageAlert,
  Value<String?> locale,
  Value<AppThemeMode> themeMode,
  Value<int?> primaryColor,
  Value<int> cubeColorU,
  Value<int> cubeColorR,
  Value<int> cubeColorF,
  Value<int> cubeColorD,
  Value<int> cubeColorL,
  Value<int> cubeColorB,
  Value<int> pyraminxColorU,
  Value<int> pyraminxColorB,
  Value<int> pyraminxColorR,
  Value<int> pyraminxColorL,
  Value<int> megaminxColorU,
  Value<int> megaminxColorBL,
  Value<int> megaminxColorBR,
  Value<int> megaminxColorR,
  Value<int> megaminxColorF,
  Value<int> megaminxColorL,
  Value<int> megaminxColorD,
  Value<int> megaminxColorDR,
  Value<int> megaminxColorDBR,
  Value<int> megaminxColorB,
  Value<int> megaminxColorDBL,
  Value<int> megaminxColorDL,
  Value<int> ftoColorU,
  Value<int> ftoColorR,
  Value<int> ftoColorF,
  Value<int> ftoColorL,
  Value<int> ftoColorB,
  Value<int> ftoColorBL,
  Value<int> ftoColorD,
  Value<int> ftoColorBR,
  Value<int> clockColorFront,
  Value<int> clockColorBack,
  Value<int> timerPressedColor,
  Value<int> timerHoldingColor,
  Value<int> timerAcceptColor,
  Value<bool> showRunningTime,
  Value<bool> stackmatEnabled,
  Value<int> timeDecimals,
  Value<int> holdDuration,
  Value<bool> showScrambleImage,
  Value<bool> showSessionStats,
  Value<bool> showQuickActions,
  Value<int> averageTrim,
});

class $$SettingsTableFilterComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get inspectionEnabled => $composableBuilder(
    column: $table.inspectionEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get inspectDuration => $composableBuilder(
    column: $table.inspectDuration,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get alertEnabled => $composableBuilder(
    column: $table.alertEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<Set<AlertType>, Set<AlertType>, String>
  get alertTypes => $composableBuilder(
    column: $table.alertTypes,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<bool> get recordBestAlert => $composableBuilder(
    column: $table.recordBestAlert,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get recordWorstAlert => $composableBuilder(
    column: $table.recordWorstAlert,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get recordAverageAlert => $composableBuilder(
    column: $table.recordAverageAlert,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get locale => $composableBuilder(
    column: $table.locale,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<AppThemeMode, AppThemeMode, String>
  get themeMode => $composableBuilder(
    column: $table.themeMode,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get primaryColor => $composableBuilder(
    column: $table.primaryColor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cubeColorU => $composableBuilder(
    column: $table.cubeColorU,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cubeColorR => $composableBuilder(
    column: $table.cubeColorR,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cubeColorF => $composableBuilder(
    column: $table.cubeColorF,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cubeColorD => $composableBuilder(
    column: $table.cubeColorD,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cubeColorL => $composableBuilder(
    column: $table.cubeColorL,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cubeColorB => $composableBuilder(
    column: $table.cubeColorB,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pyraminxColorU => $composableBuilder(
    column: $table.pyraminxColorU,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pyraminxColorB => $composableBuilder(
    column: $table.pyraminxColorB,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pyraminxColorR => $composableBuilder(
    column: $table.pyraminxColorR,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pyraminxColorL => $composableBuilder(
    column: $table.pyraminxColorL,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get megaminxColorU => $composableBuilder(
    column: $table.megaminxColorU,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get megaminxColorBL => $composableBuilder(
    column: $table.megaminxColorBL,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get megaminxColorBR => $composableBuilder(
    column: $table.megaminxColorBR,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get megaminxColorR => $composableBuilder(
    column: $table.megaminxColorR,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get megaminxColorF => $composableBuilder(
    column: $table.megaminxColorF,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get megaminxColorL => $composableBuilder(
    column: $table.megaminxColorL,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get megaminxColorD => $composableBuilder(
    column: $table.megaminxColorD,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get megaminxColorDR => $composableBuilder(
    column: $table.megaminxColorDR,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get megaminxColorDBR => $composableBuilder(
    column: $table.megaminxColorDBR,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get megaminxColorB => $composableBuilder(
    column: $table.megaminxColorB,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get megaminxColorDBL => $composableBuilder(
    column: $table.megaminxColorDBL,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get megaminxColorDL => $composableBuilder(
    column: $table.megaminxColorDL,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ftoColorU => $composableBuilder(
    column: $table.ftoColorU,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ftoColorR => $composableBuilder(
    column: $table.ftoColorR,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ftoColorF => $composableBuilder(
    column: $table.ftoColorF,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ftoColorL => $composableBuilder(
    column: $table.ftoColorL,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ftoColorB => $composableBuilder(
    column: $table.ftoColorB,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ftoColorBL => $composableBuilder(
    column: $table.ftoColorBL,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ftoColorD => $composableBuilder(
    column: $table.ftoColorD,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ftoColorBR => $composableBuilder(
    column: $table.ftoColorBR,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get clockColorFront => $composableBuilder(
    column: $table.clockColorFront,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get clockColorBack => $composableBuilder(
    column: $table.clockColorBack,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get timerPressedColor => $composableBuilder(
    column: $table.timerPressedColor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get timerHoldingColor => $composableBuilder(
    column: $table.timerHoldingColor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get timerAcceptColor => $composableBuilder(
    column: $table.timerAcceptColor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get showRunningTime => $composableBuilder(
    column: $table.showRunningTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get stackmatEnabled => $composableBuilder(
    column: $table.stackmatEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get timeDecimals => $composableBuilder(
    column: $table.timeDecimals,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get holdDuration => $composableBuilder(
    column: $table.holdDuration,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get showScrambleImage => $composableBuilder(
    column: $table.showScrambleImage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get showSessionStats => $composableBuilder(
    column: $table.showSessionStats,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get showQuickActions => $composableBuilder(
    column: $table.showQuickActions,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get averageTrim => $composableBuilder(
    column: $table.averageTrim,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get inspectionEnabled => $composableBuilder(
    column: $table.inspectionEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get inspectDuration => $composableBuilder(
    column: $table.inspectDuration,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get alertEnabled => $composableBuilder(
    column: $table.alertEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get alertTypes => $composableBuilder(
    column: $table.alertTypes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get recordBestAlert => $composableBuilder(
    column: $table.recordBestAlert,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get recordWorstAlert => $composableBuilder(
    column: $table.recordWorstAlert,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get recordAverageAlert => $composableBuilder(
    column: $table.recordAverageAlert,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get locale => $composableBuilder(
    column: $table.locale,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get themeMode => $composableBuilder(
    column: $table.themeMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get primaryColor => $composableBuilder(
    column: $table.primaryColor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cubeColorU => $composableBuilder(
    column: $table.cubeColorU,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cubeColorR => $composableBuilder(
    column: $table.cubeColorR,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cubeColorF => $composableBuilder(
    column: $table.cubeColorF,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cubeColorD => $composableBuilder(
    column: $table.cubeColorD,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cubeColorL => $composableBuilder(
    column: $table.cubeColorL,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cubeColorB => $composableBuilder(
    column: $table.cubeColorB,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pyraminxColorU => $composableBuilder(
    column: $table.pyraminxColorU,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pyraminxColorB => $composableBuilder(
    column: $table.pyraminxColorB,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pyraminxColorR => $composableBuilder(
    column: $table.pyraminxColorR,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pyraminxColorL => $composableBuilder(
    column: $table.pyraminxColorL,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get megaminxColorU => $composableBuilder(
    column: $table.megaminxColorU,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get megaminxColorBL => $composableBuilder(
    column: $table.megaminxColorBL,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get megaminxColorBR => $composableBuilder(
    column: $table.megaminxColorBR,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get megaminxColorR => $composableBuilder(
    column: $table.megaminxColorR,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get megaminxColorF => $composableBuilder(
    column: $table.megaminxColorF,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get megaminxColorL => $composableBuilder(
    column: $table.megaminxColorL,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get megaminxColorD => $composableBuilder(
    column: $table.megaminxColorD,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get megaminxColorDR => $composableBuilder(
    column: $table.megaminxColorDR,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get megaminxColorDBR => $composableBuilder(
    column: $table.megaminxColorDBR,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get megaminxColorB => $composableBuilder(
    column: $table.megaminxColorB,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get megaminxColorDBL => $composableBuilder(
    column: $table.megaminxColorDBL,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get megaminxColorDL => $composableBuilder(
    column: $table.megaminxColorDL,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ftoColorU => $composableBuilder(
    column: $table.ftoColorU,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ftoColorR => $composableBuilder(
    column: $table.ftoColorR,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ftoColorF => $composableBuilder(
    column: $table.ftoColorF,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ftoColorL => $composableBuilder(
    column: $table.ftoColorL,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ftoColorB => $composableBuilder(
    column: $table.ftoColorB,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ftoColorBL => $composableBuilder(
    column: $table.ftoColorBL,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ftoColorD => $composableBuilder(
    column: $table.ftoColorD,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ftoColorBR => $composableBuilder(
    column: $table.ftoColorBR,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get clockColorFront => $composableBuilder(
    column: $table.clockColorFront,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get clockColorBack => $composableBuilder(
    column: $table.clockColorBack,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get timerPressedColor => $composableBuilder(
    column: $table.timerPressedColor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get timerHoldingColor => $composableBuilder(
    column: $table.timerHoldingColor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get timerAcceptColor => $composableBuilder(
    column: $table.timerAcceptColor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get showRunningTime => $composableBuilder(
    column: $table.showRunningTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get stackmatEnabled => $composableBuilder(
    column: $table.stackmatEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get timeDecimals => $composableBuilder(
    column: $table.timeDecimals,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get holdDuration => $composableBuilder(
    column: $table.holdDuration,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get showScrambleImage => $composableBuilder(
    column: $table.showScrambleImage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get showSessionStats => $composableBuilder(
    column: $table.showSessionStats,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get showQuickActions => $composableBuilder(
    column: $table.showQuickActions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get averageTrim => $composableBuilder(
    column: $table.averageTrim,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<bool> get inspectionEnabled => $composableBuilder(
    column: $table.inspectionEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<int> get inspectDuration => $composableBuilder(
    column: $table.inspectDuration,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get alertEnabled => $composableBuilder(
    column: $table.alertEnabled,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<Set<AlertType>, String> get alertTypes =>
      $composableBuilder(
        column: $table.alertTypes,
        builder: (column) => column,
      );

  GeneratedColumn<bool> get recordBestAlert => $composableBuilder(
    column: $table.recordBestAlert,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get recordWorstAlert => $composableBuilder(
    column: $table.recordWorstAlert,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get recordAverageAlert => $composableBuilder(
    column: $table.recordAverageAlert,
    builder: (column) => column,
  );

  GeneratedColumn<String> get locale =>
      $composableBuilder(column: $table.locale, builder: (column) => column);

  GeneratedColumnWithTypeConverter<AppThemeMode, String> get themeMode =>
      $composableBuilder(column: $table.themeMode, builder: (column) => column);

  GeneratedColumn<int> get primaryColor => $composableBuilder(
    column: $table.primaryColor,
    builder: (column) => column,
  );

  GeneratedColumn<int> get cubeColorU => $composableBuilder(
    column: $table.cubeColorU,
    builder: (column) => column,
  );

  GeneratedColumn<int> get cubeColorR => $composableBuilder(
    column: $table.cubeColorR,
    builder: (column) => column,
  );

  GeneratedColumn<int> get cubeColorF => $composableBuilder(
    column: $table.cubeColorF,
    builder: (column) => column,
  );

  GeneratedColumn<int> get cubeColorD => $composableBuilder(
    column: $table.cubeColorD,
    builder: (column) => column,
  );

  GeneratedColumn<int> get cubeColorL => $composableBuilder(
    column: $table.cubeColorL,
    builder: (column) => column,
  );

  GeneratedColumn<int> get cubeColorB => $composableBuilder(
    column: $table.cubeColorB,
    builder: (column) => column,
  );

  GeneratedColumn<int> get pyraminxColorU => $composableBuilder(
    column: $table.pyraminxColorU,
    builder: (column) => column,
  );

  GeneratedColumn<int> get pyraminxColorB => $composableBuilder(
    column: $table.pyraminxColorB,
    builder: (column) => column,
  );

  GeneratedColumn<int> get pyraminxColorR => $composableBuilder(
    column: $table.pyraminxColorR,
    builder: (column) => column,
  );

  GeneratedColumn<int> get pyraminxColorL => $composableBuilder(
    column: $table.pyraminxColorL,
    builder: (column) => column,
  );

  GeneratedColumn<int> get megaminxColorU => $composableBuilder(
    column: $table.megaminxColorU,
    builder: (column) => column,
  );

  GeneratedColumn<int> get megaminxColorBL => $composableBuilder(
    column: $table.megaminxColorBL,
    builder: (column) => column,
  );

  GeneratedColumn<int> get megaminxColorBR => $composableBuilder(
    column: $table.megaminxColorBR,
    builder: (column) => column,
  );

  GeneratedColumn<int> get megaminxColorR => $composableBuilder(
    column: $table.megaminxColorR,
    builder: (column) => column,
  );

  GeneratedColumn<int> get megaminxColorF => $composableBuilder(
    column: $table.megaminxColorF,
    builder: (column) => column,
  );

  GeneratedColumn<int> get megaminxColorL => $composableBuilder(
    column: $table.megaminxColorL,
    builder: (column) => column,
  );

  GeneratedColumn<int> get megaminxColorD => $composableBuilder(
    column: $table.megaminxColorD,
    builder: (column) => column,
  );

  GeneratedColumn<int> get megaminxColorDR => $composableBuilder(
    column: $table.megaminxColorDR,
    builder: (column) => column,
  );

  GeneratedColumn<int> get megaminxColorDBR => $composableBuilder(
    column: $table.megaminxColorDBR,
    builder: (column) => column,
  );

  GeneratedColumn<int> get megaminxColorB => $composableBuilder(
    column: $table.megaminxColorB,
    builder: (column) => column,
  );

  GeneratedColumn<int> get megaminxColorDBL => $composableBuilder(
    column: $table.megaminxColorDBL,
    builder: (column) => column,
  );

  GeneratedColumn<int> get megaminxColorDL => $composableBuilder(
    column: $table.megaminxColorDL,
    builder: (column) => column,
  );

  GeneratedColumn<int> get ftoColorU =>
      $composableBuilder(column: $table.ftoColorU, builder: (column) => column);

  GeneratedColumn<int> get ftoColorR =>
      $composableBuilder(column: $table.ftoColorR, builder: (column) => column);

  GeneratedColumn<int> get ftoColorF =>
      $composableBuilder(column: $table.ftoColorF, builder: (column) => column);

  GeneratedColumn<int> get ftoColorL =>
      $composableBuilder(column: $table.ftoColorL, builder: (column) => column);

  GeneratedColumn<int> get ftoColorB =>
      $composableBuilder(column: $table.ftoColorB, builder: (column) => column);

  GeneratedColumn<int> get ftoColorBL => $composableBuilder(
    column: $table.ftoColorBL,
    builder: (column) => column,
  );

  GeneratedColumn<int> get ftoColorD =>
      $composableBuilder(column: $table.ftoColorD, builder: (column) => column);

  GeneratedColumn<int> get ftoColorBR => $composableBuilder(
    column: $table.ftoColorBR,
    builder: (column) => column,
  );

  GeneratedColumn<int> get clockColorFront => $composableBuilder(
    column: $table.clockColorFront,
    builder: (column) => column,
  );

  GeneratedColumn<int> get clockColorBack => $composableBuilder(
    column: $table.clockColorBack,
    builder: (column) => column,
  );

  GeneratedColumn<int> get timerPressedColor => $composableBuilder(
    column: $table.timerPressedColor,
    builder: (column) => column,
  );

  GeneratedColumn<int> get timerHoldingColor => $composableBuilder(
    column: $table.timerHoldingColor,
    builder: (column) => column,
  );

  GeneratedColumn<int> get timerAcceptColor => $composableBuilder(
    column: $table.timerAcceptColor,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get showRunningTime => $composableBuilder(
    column: $table.showRunningTime,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get stackmatEnabled => $composableBuilder(
    column: $table.stackmatEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<int> get timeDecimals => $composableBuilder(
    column: $table.timeDecimals,
    builder: (column) => column,
  );

  GeneratedColumn<int> get holdDuration => $composableBuilder(
    column: $table.holdDuration,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get showScrambleImage => $composableBuilder(
    column: $table.showScrambleImage,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get showSessionStats => $composableBuilder(
    column: $table.showSessionStats,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get showQuickActions => $composableBuilder(
    column: $table.showQuickActions,
    builder: (column) => column,
  );

  GeneratedColumn<int> get averageTrim => $composableBuilder(
    column: $table.averageTrim,
    builder: (column) => column,
  );
}

class $$SettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SettingsTable,
          SettingsEntry,
          $$SettingsTableFilterComposer,
          $$SettingsTableOrderingComposer,
          $$SettingsTableAnnotationComposer,
          $$SettingsTableCreateCompanionBuilder,
          $$SettingsTableUpdateCompanionBuilder,
          (
            SettingsEntry,
            BaseReferences<_$AppDatabase, $SettingsTable, SettingsEntry>,
          ),
          SettingsEntry,
          PrefetchHooks Function()
        > {
  $$SettingsTableTableManager(_$AppDatabase db, $SettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<bool> inspectionEnabled = const Value.absent(),
                Value<int> inspectDuration = const Value.absent(),
                Value<bool> alertEnabled = const Value.absent(),
                Value<Set<AlertType>> alertTypes = const Value.absent(),
                Value<bool> recordBestAlert = const Value.absent(),
                Value<bool> recordWorstAlert = const Value.absent(),
                Value<bool> recordAverageAlert = const Value.absent(),
                Value<String?> locale = const Value.absent(),
                Value<AppThemeMode> themeMode = const Value.absent(),
                Value<int?> primaryColor = const Value.absent(),
                Value<int> cubeColorU = const Value.absent(),
                Value<int> cubeColorR = const Value.absent(),
                Value<int> cubeColorF = const Value.absent(),
                Value<int> cubeColorD = const Value.absent(),
                Value<int> cubeColorL = const Value.absent(),
                Value<int> cubeColorB = const Value.absent(),
                Value<int> pyraminxColorU = const Value.absent(),
                Value<int> pyraminxColorB = const Value.absent(),
                Value<int> pyraminxColorR = const Value.absent(),
                Value<int> pyraminxColorL = const Value.absent(),
                Value<int> megaminxColorU = const Value.absent(),
                Value<int> megaminxColorBL = const Value.absent(),
                Value<int> megaminxColorBR = const Value.absent(),
                Value<int> megaminxColorR = const Value.absent(),
                Value<int> megaminxColorF = const Value.absent(),
                Value<int> megaminxColorL = const Value.absent(),
                Value<int> megaminxColorD = const Value.absent(),
                Value<int> megaminxColorDR = const Value.absent(),
                Value<int> megaminxColorDBR = const Value.absent(),
                Value<int> megaminxColorB = const Value.absent(),
                Value<int> megaminxColorDBL = const Value.absent(),
                Value<int> megaminxColorDL = const Value.absent(),
                Value<int> ftoColorU = const Value.absent(),
                Value<int> ftoColorR = const Value.absent(),
                Value<int> ftoColorF = const Value.absent(),
                Value<int> ftoColorL = const Value.absent(),
                Value<int> ftoColorB = const Value.absent(),
                Value<int> ftoColorBL = const Value.absent(),
                Value<int> ftoColorD = const Value.absent(),
                Value<int> ftoColorBR = const Value.absent(),
                Value<int> clockColorFront = const Value.absent(),
                Value<int> clockColorBack = const Value.absent(),
                Value<int> timerPressedColor = const Value.absent(),
                Value<int> timerHoldingColor = const Value.absent(),
                Value<int> timerAcceptColor = const Value.absent(),
                Value<bool> showRunningTime = const Value.absent(),
                Value<bool> stackmatEnabled = const Value.absent(),
                Value<int> timeDecimals = const Value.absent(),
                Value<int> holdDuration = const Value.absent(),
                Value<bool> showScrambleImage = const Value.absent(),
                Value<bool> showSessionStats = const Value.absent(),
                Value<bool> showQuickActions = const Value.absent(),
                Value<int> averageTrim = const Value.absent(),
              }) => SettingsCompanion(
                id: id,
                inspectionEnabled: inspectionEnabled,
                inspectDuration: inspectDuration,
                alertEnabled: alertEnabled,
                alertTypes: alertTypes,
                recordBestAlert: recordBestAlert,
                recordWorstAlert: recordWorstAlert,
                recordAverageAlert: recordAverageAlert,
                locale: locale,
                themeMode: themeMode,
                primaryColor: primaryColor,
                cubeColorU: cubeColorU,
                cubeColorR: cubeColorR,
                cubeColorF: cubeColorF,
                cubeColorD: cubeColorD,
                cubeColorL: cubeColorL,
                cubeColorB: cubeColorB,
                pyraminxColorU: pyraminxColorU,
                pyraminxColorB: pyraminxColorB,
                pyraminxColorR: pyraminxColorR,
                pyraminxColorL: pyraminxColorL,
                megaminxColorU: megaminxColorU,
                megaminxColorBL: megaminxColorBL,
                megaminxColorBR: megaminxColorBR,
                megaminxColorR: megaminxColorR,
                megaminxColorF: megaminxColorF,
                megaminxColorL: megaminxColorL,
                megaminxColorD: megaminxColorD,
                megaminxColorDR: megaminxColorDR,
                megaminxColorDBR: megaminxColorDBR,
                megaminxColorB: megaminxColorB,
                megaminxColorDBL: megaminxColorDBL,
                megaminxColorDL: megaminxColorDL,
                ftoColorU: ftoColorU,
                ftoColorR: ftoColorR,
                ftoColorF: ftoColorF,
                ftoColorL: ftoColorL,
                ftoColorB: ftoColorB,
                ftoColorBL: ftoColorBL,
                ftoColorD: ftoColorD,
                ftoColorBR: ftoColorBR,
                clockColorFront: clockColorFront,
                clockColorBack: clockColorBack,
                timerPressedColor: timerPressedColor,
                timerHoldingColor: timerHoldingColor,
                timerAcceptColor: timerAcceptColor,
                showRunningTime: showRunningTime,
                stackmatEnabled: stackmatEnabled,
                timeDecimals: timeDecimals,
                holdDuration: holdDuration,
                showScrambleImage: showScrambleImage,
                showSessionStats: showSessionStats,
                showQuickActions: showQuickActions,
                averageTrim: averageTrim,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<bool> inspectionEnabled = const Value.absent(),
                Value<int> inspectDuration = const Value.absent(),
                Value<bool> alertEnabled = const Value.absent(),
                Value<Set<AlertType>> alertTypes = const Value.absent(),
                Value<bool> recordBestAlert = const Value.absent(),
                Value<bool> recordWorstAlert = const Value.absent(),
                Value<bool> recordAverageAlert = const Value.absent(),
                Value<String?> locale = const Value.absent(),
                Value<AppThemeMode> themeMode = const Value.absent(),
                Value<int?> primaryColor = const Value.absent(),
                Value<int> cubeColorU = const Value.absent(),
                Value<int> cubeColorR = const Value.absent(),
                Value<int> cubeColorF = const Value.absent(),
                Value<int> cubeColorD = const Value.absent(),
                Value<int> cubeColorL = const Value.absent(),
                Value<int> cubeColorB = const Value.absent(),
                Value<int> pyraminxColorU = const Value.absent(),
                Value<int> pyraminxColorB = const Value.absent(),
                Value<int> pyraminxColorR = const Value.absent(),
                Value<int> pyraminxColorL = const Value.absent(),
                Value<int> megaminxColorU = const Value.absent(),
                Value<int> megaminxColorBL = const Value.absent(),
                Value<int> megaminxColorBR = const Value.absent(),
                Value<int> megaminxColorR = const Value.absent(),
                Value<int> megaminxColorF = const Value.absent(),
                Value<int> megaminxColorL = const Value.absent(),
                Value<int> megaminxColorD = const Value.absent(),
                Value<int> megaminxColorDR = const Value.absent(),
                Value<int> megaminxColorDBR = const Value.absent(),
                Value<int> megaminxColorB = const Value.absent(),
                Value<int> megaminxColorDBL = const Value.absent(),
                Value<int> megaminxColorDL = const Value.absent(),
                Value<int> ftoColorU = const Value.absent(),
                Value<int> ftoColorR = const Value.absent(),
                Value<int> ftoColorF = const Value.absent(),
                Value<int> ftoColorL = const Value.absent(),
                Value<int> ftoColorB = const Value.absent(),
                Value<int> ftoColorBL = const Value.absent(),
                Value<int> ftoColorD = const Value.absent(),
                Value<int> ftoColorBR = const Value.absent(),
                Value<int> clockColorFront = const Value.absent(),
                Value<int> clockColorBack = const Value.absent(),
                Value<int> timerPressedColor = const Value.absent(),
                Value<int> timerHoldingColor = const Value.absent(),
                Value<int> timerAcceptColor = const Value.absent(),
                Value<bool> showRunningTime = const Value.absent(),
                Value<bool> stackmatEnabled = const Value.absent(),
                Value<int> timeDecimals = const Value.absent(),
                Value<int> holdDuration = const Value.absent(),
                Value<bool> showScrambleImage = const Value.absent(),
                Value<bool> showSessionStats = const Value.absent(),
                Value<bool> showQuickActions = const Value.absent(),
                Value<int> averageTrim = const Value.absent(),
              }) => SettingsCompanion.insert(
                id: id,
                inspectionEnabled: inspectionEnabled,
                inspectDuration: inspectDuration,
                alertEnabled: alertEnabled,
                alertTypes: alertTypes,
                recordBestAlert: recordBestAlert,
                recordWorstAlert: recordWorstAlert,
                recordAverageAlert: recordAverageAlert,
                locale: locale,
                themeMode: themeMode,
                primaryColor: primaryColor,
                cubeColorU: cubeColorU,
                cubeColorR: cubeColorR,
                cubeColorF: cubeColorF,
                cubeColorD: cubeColorD,
                cubeColorL: cubeColorL,
                cubeColorB: cubeColorB,
                pyraminxColorU: pyraminxColorU,
                pyraminxColorB: pyraminxColorB,
                pyraminxColorR: pyraminxColorR,
                pyraminxColorL: pyraminxColorL,
                megaminxColorU: megaminxColorU,
                megaminxColorBL: megaminxColorBL,
                megaminxColorBR: megaminxColorBR,
                megaminxColorR: megaminxColorR,
                megaminxColorF: megaminxColorF,
                megaminxColorL: megaminxColorL,
                megaminxColorD: megaminxColorD,
                megaminxColorDR: megaminxColorDR,
                megaminxColorDBR: megaminxColorDBR,
                megaminxColorB: megaminxColorB,
                megaminxColorDBL: megaminxColorDBL,
                megaminxColorDL: megaminxColorDL,
                ftoColorU: ftoColorU,
                ftoColorR: ftoColorR,
                ftoColorF: ftoColorF,
                ftoColorL: ftoColorL,
                ftoColorB: ftoColorB,
                ftoColorBL: ftoColorBL,
                ftoColorD: ftoColorD,
                ftoColorBR: ftoColorBR,
                clockColorFront: clockColorFront,
                clockColorBack: clockColorBack,
                timerPressedColor: timerPressedColor,
                timerHoldingColor: timerHoldingColor,
                timerAcceptColor: timerAcceptColor,
                showRunningTime: showRunningTime,
                stackmatEnabled: stackmatEnabled,
                timeDecimals: timeDecimals,
                holdDuration: holdDuration,
                showScrambleImage: showScrambleImage,
                showSessionStats: showSessionStats,
                showQuickActions: showQuickActions,
                averageTrim: averageTrim,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SettingsTable, SettingsEntry>(table),
                  BaseReferences<_$AppDatabase, $SettingsTable, SettingsEntry>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SettingsTable,
      SettingsEntry,
      $$SettingsTableFilterComposer,
      $$SettingsTableOrderingComposer,
      $$SettingsTableAnnotationComposer,
      $$SettingsTableCreateCompanionBuilder,
      $$SettingsTableUpdateCompanionBuilder,
      (
        SettingsEntry,
        BaseReferences<_$AppDatabase, $SettingsTable, SettingsEntry>,
      ),
      SettingsEntry,
      PrefetchHooks Function()
    >;
typedef $$SessionsTableCreateCompanionBuilder = SessionsCompanion Function({
  Value<String> id,
  required String name,
  Value<DateTime> createdAt,
  Value<DateTime?> deletedAt,
  Value<int> rowid,
});
typedef $$SessionsTableUpdateCompanionBuilder = SessionsCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<DateTime> createdAt,
  Value<DateTime?> deletedAt,
  Value<int> rowid,
});

final class $$SessionsTableReferences
    extends BaseReferences<_$AppDatabase, $SessionsTable, SessionEntry> {
  $$SessionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$AppStateTable, List<AppStateEntry>>
  _appStateRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.appState,
    aliasName: 'sessions__id__app_state__session',
  );

  $$AppStateTableProcessedTableManager get appStateRefs {
    final manager = $$AppStateTableTableManager(
      $_db,
      $_db.appState,
    ).filter((f) => f.session.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_appStateRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$RecordsTable, List<RecordEntry>>
  _recordsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.records,
    aliasName: 'sessions__id__records__session',
  );

  $$RecordsTableProcessedTableManager get recordsRefs {
    final manager = $$RecordsTableTableManager(
      $_db,
      $_db.records,
    ).filter((f) => f.session.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_recordsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SessionsTableFilterComposer
    extends Composer<_$AppDatabase, $SessionsTable> {
  $$SessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> appStateRefs(
    Expression<bool> Function($$AppStateTableFilterComposer f) f,
  ) {
    final $$AppStateTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.appState,
      getReferencedColumn: (t) => t.session,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AppStateTableFilterComposer(
            $db: $db,
            $table: $db.appState,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> recordsRefs(
    Expression<bool> Function($$RecordsTableFilterComposer f) f,
  ) {
    final $$RecordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.records,
      getReferencedColumn: (t) => t.session,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecordsTableFilterComposer(
            $db: $db,
            $table: $db.records,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $SessionsTable> {
  $$SessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SessionsTable> {
  $$SessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  Expression<T> appStateRefs<T extends Object>(
    Expression<T> Function($$AppStateTableAnnotationComposer a) f,
  ) {
    final $$AppStateTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.appState,
      getReferencedColumn: (t) => t.session,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AppStateTableAnnotationComposer(
            $db: $db,
            $table: $db.appState,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> recordsRefs<T extends Object>(
    Expression<T> Function($$RecordsTableAnnotationComposer a) f,
  ) {
    final $$RecordsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.records,
      getReferencedColumn: (t) => t.session,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecordsTableAnnotationComposer(
            $db: $db,
            $table: $db.records,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SessionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SessionsTable,
          SessionEntry,
          $$SessionsTableFilterComposer,
          $$SessionsTableOrderingComposer,
          $$SessionsTableAnnotationComposer,
          $$SessionsTableCreateCompanionBuilder,
          $$SessionsTableUpdateCompanionBuilder,
          (SessionEntry, $$SessionsTableReferences),
          SessionEntry,
          PrefetchHooks Function({bool appStateRefs, bool recordsRefs})
        > {
  $$SessionsTableTableManager(_$AppDatabase db, $SessionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SessionsCompanion(
                id: id,
                name: name,
                createdAt: createdAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required String name,
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SessionsCompanion.insert(
                id: id,
                name: name,
                createdAt: createdAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SessionsTable, SessionEntry>(table),
                  $$SessionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({appStateRefs = false, recordsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (appStateRefs) db.appState,
                if (recordsRefs) db.records,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (appStateRefs)
                    await $_getPrefetchedData<
                      SessionEntry,
                      $SessionsTable,
                      AppStateEntry
                    >(
                      currentTable: table,
                      referencedTable: $$SessionsTableReferences
                          ._appStateRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$SessionsTableReferences(db, table, p0).appStateRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.session == item.id),
                      typedResults: items,
                    ),
                  if (recordsRefs)
                    await $_getPrefetchedData<
                      SessionEntry,
                      $SessionsTable,
                      RecordEntry
                    >(
                      currentTable: table,
                      referencedTable: $$SessionsTableReferences
                          ._recordsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$SessionsTableReferences(db, table, p0).recordsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.session == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$SessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SessionsTable,
      SessionEntry,
      $$SessionsTableFilterComposer,
      $$SessionsTableOrderingComposer,
      $$SessionsTableAnnotationComposer,
      $$SessionsTableCreateCompanionBuilder,
      $$SessionsTableUpdateCompanionBuilder,
      (SessionEntry, $$SessionsTableReferences),
      SessionEntry,
      PrefetchHooks Function({bool appStateRefs, bool recordsRefs})
    >;
typedef $$AppStateTableCreateCompanionBuilder = AppStateCompanion Function({
  Value<int> id,
  Value<Puzzle> puzzle,
  Value<String> session,
  Value<bool> showArchived,
});
typedef $$AppStateTableUpdateCompanionBuilder = AppStateCompanion Function({
  Value<int> id,
  Value<Puzzle> puzzle,
  Value<String> session,
  Value<bool> showArchived,
});

final class $$AppStateTableReferences
    extends BaseReferences<_$AppDatabase, $AppStateTable, AppStateEntry> {
  $$AppStateTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SessionsTable _sessionTable(_$AppDatabase db) =>
      db.sessions.createAlias('app_state__session__sessions__id');

  $$SessionsTableProcessedTableManager get session {
    final $_column = $_itemColumn<String>('session')!;

    final manager = $$SessionsTableTableManager(
      $_db,
      $_db.sessions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sessionTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$AppStateTableFilterComposer
    extends Composer<_$AppDatabase, $AppStateTable> {
  $$AppStateTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<Puzzle, Puzzle, String> get puzzle =>
      $composableBuilder(
        column: $table.puzzle,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<bool> get showArchived => $composableBuilder(
    column: $table.showArchived,
    builder: (column) => ColumnFilters(column),
  );

  $$SessionsTableFilterComposer get session {
    final $$SessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.session,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableFilterComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AppStateTableOrderingComposer
    extends Composer<_$AppDatabase, $AppStateTable> {
  $$AppStateTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get puzzle => $composableBuilder(
    column: $table.puzzle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get showArchived => $composableBuilder(
    column: $table.showArchived,
    builder: (column) => ColumnOrderings(column),
  );

  $$SessionsTableOrderingComposer get session {
    final $$SessionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.session,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableOrderingComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AppStateTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppStateTable> {
  $$AppStateTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Puzzle, String> get puzzle =>
      $composableBuilder(column: $table.puzzle, builder: (column) => column);

  GeneratedColumn<bool> get showArchived => $composableBuilder(
    column: $table.showArchived,
    builder: (column) => column,
  );

  $$SessionsTableAnnotationComposer get session {
    final $$SessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.session,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AppStateTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppStateTable,
          AppStateEntry,
          $$AppStateTableFilterComposer,
          $$AppStateTableOrderingComposer,
          $$AppStateTableAnnotationComposer,
          $$AppStateTableCreateCompanionBuilder,
          $$AppStateTableUpdateCompanionBuilder,
          (AppStateEntry, $$AppStateTableReferences),
          AppStateEntry,
          PrefetchHooks Function({bool session})
        > {
  $$AppStateTableTableManager(_$AppDatabase db, $AppStateTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppStateTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppStateTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppStateTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<Puzzle> puzzle = const Value.absent(),
                Value<String> session = const Value.absent(),
                Value<bool> showArchived = const Value.absent(),
              }) => AppStateCompanion(
                id: id,
                puzzle: puzzle,
                session: session,
                showArchived: showArchived,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<Puzzle> puzzle = const Value.absent(),
                Value<String> session = const Value.absent(),
                Value<bool> showArchived = const Value.absent(),
              }) => AppStateCompanion.insert(
                id: id,
                puzzle: puzzle,
                session: session,
                showArchived: showArchived,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AppStateTable, AppStateEntry>(table),
                  $$AppStateTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({session = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (session) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.session,
                        referencedTable: $$AppStateTableReferences
                            ._sessionTable(db),
                        referencedColumn: $$AppStateTableReferences
                            ._sessionTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$AppStateTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppStateTable,
      AppStateEntry,
      $$AppStateTableFilterComposer,
      $$AppStateTableOrderingComposer,
      $$AppStateTableAnnotationComposer,
      $$AppStateTableCreateCompanionBuilder,
      $$AppStateTableUpdateCompanionBuilder,
      (AppStateEntry, $$AppStateTableReferences),
      AppStateEntry,
      PrefetchHooks Function({bool session})
    >;
typedef $$RecordsTableCreateCompanionBuilder = RecordsCompanion Function({
  Value<String> id,
  required Puzzle puzzle,
  required String session,
  required String scramble,
  required int time,
  Value<DateTime> datetime,
  required Penalty penalty,
  Value<String?> comment,
  Value<DateTime?> deletedAt,
  Value<bool> archived,
  Value<int> rowid,
});
typedef $$RecordsTableUpdateCompanionBuilder = RecordsCompanion Function({
  Value<String> id,
  Value<Puzzle> puzzle,
  Value<String> session,
  Value<String> scramble,
  Value<int> time,
  Value<DateTime> datetime,
  Value<Penalty> penalty,
  Value<String?> comment,
  Value<DateTime?> deletedAt,
  Value<bool> archived,
  Value<int> rowid,
});

final class $$RecordsTableReferences
    extends BaseReferences<_$AppDatabase, $RecordsTable, RecordEntry> {
  $$RecordsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SessionsTable _sessionTable(_$AppDatabase db) =>
      db.sessions.createAlias('records__session__sessions__id');

  $$SessionsTableProcessedTableManager get session {
    final $_column = $_itemColumn<String>('session')!;

    final manager = $$SessionsTableTableManager(
      $_db,
      $_db.sessions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sessionTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$RecordsTableFilterComposer
    extends Composer<_$AppDatabase, $RecordsTable> {
  $$RecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<Puzzle, Puzzle, String> get puzzle =>
      $composableBuilder(
        column: $table.puzzle,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get scramble => $composableBuilder(
    column: $table.scramble,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get time => $composableBuilder(
    column: $table.time,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get datetime => $composableBuilder(
    column: $table.datetime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<Penalty, Penalty, String> get penalty =>
      $composableBuilder(
        column: $table.penalty,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get comment => $composableBuilder(
    column: $table.comment,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get archived => $composableBuilder(
    column: $table.archived,
    builder: (column) => ColumnFilters(column),
  );

  $$SessionsTableFilterComposer get session {
    final $$SessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.session,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableFilterComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $RecordsTable> {
  $$RecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get puzzle => $composableBuilder(
    column: $table.puzzle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get scramble => $composableBuilder(
    column: $table.scramble,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get time => $composableBuilder(
    column: $table.time,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get datetime => $composableBuilder(
    column: $table.datetime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get penalty => $composableBuilder(
    column: $table.penalty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get comment => $composableBuilder(
    column: $table.comment,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get archived => $composableBuilder(
    column: $table.archived,
    builder: (column) => ColumnOrderings(column),
  );

  $$SessionsTableOrderingComposer get session {
    final $$SessionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.session,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableOrderingComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecordsTable> {
  $$RecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Puzzle, String> get puzzle =>
      $composableBuilder(column: $table.puzzle, builder: (column) => column);

  GeneratedColumn<String> get scramble =>
      $composableBuilder(column: $table.scramble, builder: (column) => column);

  GeneratedColumn<int> get time =>
      $composableBuilder(column: $table.time, builder: (column) => column);

  GeneratedColumn<DateTime> get datetime =>
      $composableBuilder(column: $table.datetime, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Penalty, String> get penalty =>
      $composableBuilder(column: $table.penalty, builder: (column) => column);

  GeneratedColumn<String> get comment =>
      $composableBuilder(column: $table.comment, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<bool> get archived =>
      $composableBuilder(column: $table.archived, builder: (column) => column);

  $$SessionsTableAnnotationComposer get session {
    final $$SessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.session,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RecordsTable,
          RecordEntry,
          $$RecordsTableFilterComposer,
          $$RecordsTableOrderingComposer,
          $$RecordsTableAnnotationComposer,
          $$RecordsTableCreateCompanionBuilder,
          $$RecordsTableUpdateCompanionBuilder,
          (RecordEntry, $$RecordsTableReferences),
          RecordEntry,
          PrefetchHooks Function({bool session})
        > {
  $$RecordsTableTableManager(_$AppDatabase db, $RecordsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<Puzzle> puzzle = const Value.absent(),
                Value<String> session = const Value.absent(),
                Value<String> scramble = const Value.absent(),
                Value<int> time = const Value.absent(),
                Value<DateTime> datetime = const Value.absent(),
                Value<Penalty> penalty = const Value.absent(),
                Value<String?> comment = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<bool> archived = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RecordsCompanion(
                id: id,
                puzzle: puzzle,
                session: session,
                scramble: scramble,
                time: time,
                datetime: datetime,
                penalty: penalty,
                comment: comment,
                deletedAt: deletedAt,
                archived: archived,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required Puzzle puzzle,
                required String session,
                required String scramble,
                required int time,
                Value<DateTime> datetime = const Value.absent(),
                required Penalty penalty,
                Value<String?> comment = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<bool> archived = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RecordsCompanion.insert(
                id: id,
                puzzle: puzzle,
                session: session,
                scramble: scramble,
                time: time,
                datetime: datetime,
                penalty: penalty,
                comment: comment,
                deletedAt: deletedAt,
                archived: archived,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RecordsTable, RecordEntry>(table),
                  $$RecordsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({session = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (session) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.session,
                        referencedTable: $$RecordsTableReferences._sessionTable(
                          db,
                        ),
                        referencedColumn: $$RecordsTableReferences
                            ._sessionTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$RecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RecordsTable,
      RecordEntry,
      $$RecordsTableFilterComposer,
      $$RecordsTableOrderingComposer,
      $$RecordsTableAnnotationComposer,
      $$RecordsTableCreateCompanionBuilder,
      $$RecordsTableUpdateCompanionBuilder,
      (RecordEntry, $$RecordsTableReferences),
      RecordEntry,
      PrefetchHooks Function({bool session})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SettingsTableTableManager get settings =>
      $$SettingsTableTableManager(_db, _db.settings);
  $$SessionsTableTableManager get sessions =>
      $$SessionsTableTableManager(_db, _db.sessions);
  $$AppStateTableTableManager get appState =>
      $$AppStateTableTableManager(_db, _db.appState);
  $$RecordsTableTableManager get records =>
      $$RecordsTableTableManager(_db, _db.records);
}
