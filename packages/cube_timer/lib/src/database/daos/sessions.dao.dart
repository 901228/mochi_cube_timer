import "package:drift/drift.dart";

import "../app_database.dart";
import "../tables/sessions.table.dart";

part "sessions.dao.g.dart";

@DriftAccessor(tables: [Sessions])
class SessionsDao extends DatabaseAccessor<AppDatabase> with _$SessionsDaoMixin {
  SessionsDao(super.db);

  /// Every session still alive, oldest first, for the picker.
  Stream<List<SessionEntry>> watchAll() =>
      (select(sessions)
            ..where((t) => t.deletedAt.isNull())
            ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
          .watch();

  Future<String> add({required String name}) async {
    final row = await into(sessions).insertReturning(SessionsCompanion.insert(name: name));
    return row.id;
  }

  Future<void> _write(String id, SessionsCompanion patch) =>
      (update(sessions)..where((t) => t.id.equals(id))).write(patch);

  Future<void> setName(String id, String name) => _write(id, SessionsCompanion(name: Value(name)));
  Future<void> softDelete(String id) => _write(id, SessionsCompanion(deletedAt: Value(DateTime.now())));
}
