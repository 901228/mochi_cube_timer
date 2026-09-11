// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'records.dao.dart';

// ignore_for_file: type=lint
mixin _$RecordsDaoMixin on DatabaseAccessor<AppDatabase> {
  $SessionsTable get sessions => attachedDatabase.sessions;
  $RecordsTable get records => attachedDatabase.records;
  RecordsDaoManager get managers => RecordsDaoManager(this);
}

class RecordsDaoManager {
  final _$RecordsDaoMixin _db;
  RecordsDaoManager(this._db);
  $$SessionsTableTableManager get sessions =>
      $$SessionsTableTableManager(_db.attachedDatabase, _db.sessions);
  $$RecordsTableTableManager get records =>
      $$RecordsTableTableManager(_db.attachedDatabase, _db.records);
}
