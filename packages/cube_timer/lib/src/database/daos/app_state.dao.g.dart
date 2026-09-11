// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_state.dao.dart';

// ignore_for_file: type=lint
mixin _$AppStateDaoMixin on DatabaseAccessor<AppDatabase> {
  $SessionsTable get sessions => attachedDatabase.sessions;
  $AppStateTable get appState => attachedDatabase.appState;
  AppStateDaoManager get managers => AppStateDaoManager(this);
}

class AppStateDaoManager {
  final _$AppStateDaoMixin _db;
  AppStateDaoManager(this._db);
  $$SessionsTableTableManager get sessions =>
      $$SessionsTableTableManager(_db.attachedDatabase, _db.sessions);
  $$AppStateTableTableManager get appState =>
      $$AppStateTableTableManager(_db.attachedDatabase, _db.appState);
}
