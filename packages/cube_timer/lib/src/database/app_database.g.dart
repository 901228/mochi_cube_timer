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
  List<GeneratedColumn> get $columns => [
    id,
    inspectionEnabled,
    inspectDuration,
    alertEnabled,
    locale,
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
    if (data.containsKey('locale')) {
      context.handle(
        _localeMeta,
        locale.isAcceptableOrUnknown(data['locale']!, _localeMeta),
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
      locale: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}locale'],
      ),
    );
  }

  @override
  $SettingsTable createAlias(String alias) {
    return $SettingsTable(attachedDatabase, alias);
  }
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

  /// locale
  ///
  /// `null` => system default
  final String? locale;
  const SettingsEntry({
    required this.id,
    required this.inspectionEnabled,
    required this.inspectDuration,
    required this.alertEnabled,
    this.locale,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['inspection_enabled'] = Variable<bool>(inspectionEnabled);
    map['inspect_duration'] = Variable<int>(inspectDuration);
    map['alert_enabled'] = Variable<bool>(alertEnabled);
    if (!nullToAbsent || locale != null) {
      map['locale'] = Variable<String>(locale);
    }
    return map;
  }

  SettingsCompanion toCompanion(bool nullToAbsent) {
    return SettingsCompanion(
      id: Value(id),
      inspectionEnabled: Value(inspectionEnabled),
      inspectDuration: Value(inspectDuration),
      alertEnabled: Value(alertEnabled),
      locale: locale == null && nullToAbsent
          ? const Value.absent()
          : Value(locale),
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
      locale: serializer.fromJson<String?>(json['locale']),
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
      'locale': serializer.toJson<String?>(locale),
    };
  }

  SettingsEntry copyWith({
    int? id,
    bool? inspectionEnabled,
    int? inspectDuration,
    bool? alertEnabled,
    Value<String?> locale = const Value.absent(),
  }) => SettingsEntry(
    id: id ?? this.id,
    inspectionEnabled: inspectionEnabled ?? this.inspectionEnabled,
    inspectDuration: inspectDuration ?? this.inspectDuration,
    alertEnabled: alertEnabled ?? this.alertEnabled,
    locale: locale.present ? locale.value : this.locale,
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
      locale: data.locale.present ? data.locale.value : this.locale,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SettingsEntry(')
          ..write('id: $id, ')
          ..write('inspectionEnabled: $inspectionEnabled, ')
          ..write('inspectDuration: $inspectDuration, ')
          ..write('alertEnabled: $alertEnabled, ')
          ..write('locale: $locale')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, inspectionEnabled, inspectDuration, alertEnabled, locale);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SettingsEntry &&
          other.id == this.id &&
          other.inspectionEnabled == this.inspectionEnabled &&
          other.inspectDuration == this.inspectDuration &&
          other.alertEnabled == this.alertEnabled &&
          other.locale == this.locale);
}

class SettingsCompanion extends UpdateCompanion<SettingsEntry> {
  final Value<int> id;
  final Value<bool> inspectionEnabled;
  final Value<int> inspectDuration;
  final Value<bool> alertEnabled;
  final Value<String?> locale;
  const SettingsCompanion({
    this.id = const Value.absent(),
    this.inspectionEnabled = const Value.absent(),
    this.inspectDuration = const Value.absent(),
    this.alertEnabled = const Value.absent(),
    this.locale = const Value.absent(),
  });
  SettingsCompanion.insert({
    this.id = const Value.absent(),
    this.inspectionEnabled = const Value.absent(),
    this.inspectDuration = const Value.absent(),
    this.alertEnabled = const Value.absent(),
    this.locale = const Value.absent(),
  });
  static Insertable<SettingsEntry> custom({
    Expression<int>? id,
    Expression<bool>? inspectionEnabled,
    Expression<int>? inspectDuration,
    Expression<bool>? alertEnabled,
    Expression<String>? locale,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (inspectionEnabled != null) 'inspection_enabled': inspectionEnabled,
      if (inspectDuration != null) 'inspect_duration': inspectDuration,
      if (alertEnabled != null) 'alert_enabled': alertEnabled,
      if (locale != null) 'locale': locale,
    });
  }

  SettingsCompanion copyWith({
    Value<int>? id,
    Value<bool>? inspectionEnabled,
    Value<int>? inspectDuration,
    Value<bool>? alertEnabled,
    Value<String?>? locale,
  }) {
    return SettingsCompanion(
      id: id ?? this.id,
      inspectionEnabled: inspectionEnabled ?? this.inspectionEnabled,
      inspectDuration: inspectDuration ?? this.inspectDuration,
      alertEnabled: alertEnabled ?? this.alertEnabled,
      locale: locale ?? this.locale,
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
    if (locale.present) {
      map['locale'] = Variable<String>(locale.value);
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
          ..write('locale: $locale')
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
    defaultValue: const Constant("normal"),
  );
  @override
  List<GeneratedColumn> get $columns => [id, puzzle, session];
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

  /// The puzzle whose scrambles are showing.
  final Puzzle puzzle;
  final String session;
  const AppStateEntry({
    required this.id,
    required this.puzzle,
    required this.session,
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
    return map;
  }

  AppStateCompanion toCompanion(bool nullToAbsent) {
    return AppStateCompanion(
      id: Value(id),
      puzzle: Value(puzzle),
      session: Value(session),
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
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'puzzle': serializer.toJson<Puzzle>(puzzle),
      'session': serializer.toJson<String>(session),
    };
  }

  AppStateEntry copyWith({int? id, Puzzle? puzzle, String? session}) =>
      AppStateEntry(
        id: id ?? this.id,
        puzzle: puzzle ?? this.puzzle,
        session: session ?? this.session,
      );
  AppStateEntry copyWithCompanion(AppStateCompanion data) {
    return AppStateEntry(
      id: data.id.present ? data.id.value : this.id,
      puzzle: data.puzzle.present ? data.puzzle.value : this.puzzle,
      session: data.session.present ? data.session.value : this.session,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppStateEntry(')
          ..write('id: $id, ')
          ..write('puzzle: $puzzle, ')
          ..write('session: $session')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, puzzle, session);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppStateEntry &&
          other.id == this.id &&
          other.puzzle == this.puzzle &&
          other.session == this.session);
}

class AppStateCompanion extends UpdateCompanion<AppStateEntry> {
  final Value<int> id;
  final Value<Puzzle> puzzle;
  final Value<String> session;
  const AppStateCompanion({
    this.id = const Value.absent(),
    this.puzzle = const Value.absent(),
    this.session = const Value.absent(),
  });
  AppStateCompanion.insert({
    this.id = const Value.absent(),
    this.puzzle = const Value.absent(),
    this.session = const Value.absent(),
  });
  static Insertable<AppStateEntry> custom({
    Expression<int>? id,
    Expression<String>? puzzle,
    Expression<String>? session,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (puzzle != null) 'puzzle': puzzle,
      if (session != null) 'session': session,
    });
  }

  AppStateCompanion copyWith({
    Value<int>? id,
    Value<Puzzle>? puzzle,
    Value<String>? session,
  }) {
    return AppStateCompanion(
      id: id ?? this.id,
      puzzle: puzzle ?? this.puzzle,
      session: session ?? this.session,
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
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppStateCompanion(')
          ..write('id: $id, ')
          ..write('puzzle: $puzzle, ')
          ..write('session: $session')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SettingsTable settings = $SettingsTable(this);
  late final $AppStateTable appState = $AppStateTable(this);
  late final SettingsDao settingsDao = SettingsDao(this as AppDatabase);
  late final AppStateDao appStateDao = AppStateDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [settings, appState];
}

typedef $$SettingsTableCreateCompanionBuilder = SettingsCompanion Function({
  Value<int> id,
  Value<bool> inspectionEnabled,
  Value<int> inspectDuration,
  Value<bool> alertEnabled,
  Value<String?> locale,
});
typedef $$SettingsTableUpdateCompanionBuilder = SettingsCompanion Function({
  Value<int> id,
  Value<bool> inspectionEnabled,
  Value<int> inspectDuration,
  Value<bool> alertEnabled,
  Value<String?> locale,
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

  ColumnFilters<String> get locale => $composableBuilder(
    column: $table.locale,
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

  ColumnOrderings<String> get locale => $composableBuilder(
    column: $table.locale,
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

  GeneratedColumn<String> get locale =>
      $composableBuilder(column: $table.locale, builder: (column) => column);
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
                Value<String?> locale = const Value.absent(),
              }) => SettingsCompanion(
                id: id,
                inspectionEnabled: inspectionEnabled,
                inspectDuration: inspectDuration,
                alertEnabled: alertEnabled,
                locale: locale,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<bool> inspectionEnabled = const Value.absent(),
                Value<int> inspectDuration = const Value.absent(),
                Value<bool> alertEnabled = const Value.absent(),
                Value<String?> locale = const Value.absent(),
              }) => SettingsCompanion.insert(
                id: id,
                inspectionEnabled: inspectionEnabled,
                inspectDuration: inspectDuration,
                alertEnabled: alertEnabled,
                locale: locale,
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
typedef $$AppStateTableCreateCompanionBuilder = AppStateCompanion Function({
  Value<int> id,
  Value<Puzzle> puzzle,
  Value<String> session,
});
typedef $$AppStateTableUpdateCompanionBuilder = AppStateCompanion Function({
  Value<int> id,
  Value<Puzzle> puzzle,
  Value<String> session,
});

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

  ColumnFilters<String> get session => $composableBuilder(
    column: $table.session,
    builder: (column) => ColumnFilters(column),
  );
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

  ColumnOrderings<String> get session => $composableBuilder(
    column: $table.session,
    builder: (column) => ColumnOrderings(column),
  );
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

  GeneratedColumn<String> get session =>
      $composableBuilder(column: $table.session, builder: (column) => column);
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
          (
            AppStateEntry,
            BaseReferences<_$AppDatabase, $AppStateTable, AppStateEntry>,
          ),
          AppStateEntry,
          PrefetchHooks Function()
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
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<Puzzle> puzzle = const Value.absent(),
            Value<String> session = const Value.absent(),
          }) => AppStateCompanion(id: id, puzzle: puzzle, session: session),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<Puzzle> puzzle = const Value.absent(),
                Value<String> session = const Value.absent(),
              }) => AppStateCompanion.insert(
                id: id,
                puzzle: puzzle,
                session: session,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AppStateTable, AppStateEntry>(table),
                  BaseReferences<_$AppDatabase, $AppStateTable, AppStateEntry>(
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
      (
        AppStateEntry,
        BaseReferences<_$AppDatabase, $AppStateTable, AppStateEntry>,
      ),
      AppStateEntry,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SettingsTableTableManager get settings =>
      $$SettingsTableTableManager(_db, _db.settings);
  $$AppStateTableTableManager get appState =>
      $$AppStateTableTableManager(_db, _db.appState);
}
