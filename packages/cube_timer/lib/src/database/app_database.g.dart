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

  /// current puzzle
  final Puzzle puzzle;

  /// current session, or [kDefaultSessionId] for the default session
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
});
typedef $$AppStateTableUpdateCompanionBuilder = AppStateCompanion Function({
  Value<int> id,
  Value<Puzzle> puzzle,
  Value<String> session,
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
