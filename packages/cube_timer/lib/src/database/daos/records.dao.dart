import "package:drift/drift.dart";

import "../../puzzle/puzzle.dart";
import "../app_database.dart";
import "../tables/records.table.dart";

part "records.dao.g.dart";

enum RecordSort { newest, oldest, fastest, slowest }

class RecordQuery {
  final String comment;
  final Set<Penalty> penalties;
  final DateTime? from, to;
  final RecordSort sort;

  const RecordQuery({this.comment = "", this.penalties = const {}, this.from, this.to, this.sort = .newest});

  /// How many filters are on, for the filter button. The comment and the sort have their own UI.
  int get activeFilters => (penalties.isEmpty ? 0 : 1) + ((from == null && to == null) ? 0 : 1);

  RecordQuery copyWith({String? comment, Set<Penalty>? penalties, RecordSort? sort}) => RecordQuery(
    comment: comment ?? this.comment,
    penalties: penalties ?? this.penalties,
    from: from,
    to: to,
    sort: sort ?? this.sort,
  );

  /// Separate from [copyWith] so that null can clear the range.
  RecordQuery withDates(DateTime? from, DateTime? to) =>
      RecordQuery(comment: comment, penalties: penalties, from: from, to: to, sort: sort);

  RecordQuery clearFilters() => RecordQuery(comment: comment, sort: sort);
}

extension on RecordSort {
  List<OrderingTerm Function($RecordsTable)> get orderBy => switch (this) {
    .newest => [(t) => .desc(t.datetime)],
    .oldest => [(t) => .asc(t.datetime)],
    .fastest => [
      (t) => .asc(t.penalty.equalsValue(Penalty.dnf)),
      (t) => .asc(
        CaseWhenExpression(
          cases: [CaseWhen(t.penalty.equalsValue(Penalty.plus2), then: t.time + const Constant(2000))],
          orElse: t.time,
        ),
      ),
    ],
    .slowest => [
      (t) => .desc(t.penalty.equalsValue(Penalty.dnf)),
      (t) => .desc(
        CaseWhenExpression(
          cases: [CaseWhen(t.penalty.equalsValue(Penalty.plus2), then: t.time + const Constant(2000))],
          orElse: t.time,
        ),
      ),
    ],
  };
}

@DriftAccessor(tables: [Records])
class RecordsDao extends DatabaseAccessor<AppDatabase> with _$RecordsDaoMixin {
  RecordsDao(super.db);

  Selectable<RecordEntry> _query(
    String session,
    Puzzle puzzle, {
    bool showArchived = false,
    RecordQuery query = const RecordQuery(),
  }) => select(records)
    ..where((t) {
      var e = t.session.equals(session) & t.puzzle.equals(puzzle.id) & t.deletedAt.isNull();
      if (showArchived) {
        e = e & t.archived;
      } else {
        e = e & t.archived.not();
      }

      if (query.comment.isNotEmpty) e &= t.comment.like("%${query.comment}%");
      if (query.penalties.isNotEmpty) e &= t.penalty.isInValues(query.penalties);
      if (query.from != null) e &= t.datetime.isBiggerOrEqualValue(query.from!);
      if (query.to != null) {
        e &= t.datetime.isSmallerThanValue(query.to!.add(const Duration(days: 1)));
      }

      return e;
    })
    ..orderBy(query.sort.orderBy);

  Stream<List<RecordEntry>> watchSession(
    String session,
    Puzzle puzzle, {
    bool showArchived = false,
    RecordQuery query = const RecordQuery(),
  }) => _query(session, puzzle, showArchived: showArchived, query: query).watch();

  Future<List<RecordEntry>> getSession(
    String session,
    Puzzle puzzle, {
    bool showArchived = false,
    RecordQuery query = const RecordQuery(),
  }) => _query(session, puzzle, showArchived: showArchived, query: query).get();

  /// watch single record
  Stream<RecordEntry> watchRecord(String id) =>
      (select(records)..where((t) => t.id.equals(id))).watchSingle();

  /// Records a finished solve and returns its id, which the caller needs to
  /// keep: the +2, DNF, comment and delete buttons shown right after a solve
  /// all act on the row just written.
  Future<String> add({
    required String session,
    required Puzzle puzzle,
    required String scramble,
    required int time,
    Penalty penalty = .none,
  }) async {
    final row = await into(records).insertReturning(
      RecordsCompanion.insert(
        session: session,
        puzzle: puzzle,
        scramble: scramble,
        time: time,
        penalty: penalty,
      ),
    );
    return row.id;
  }

  Future<void> _write(String id, RecordsCompanion patch) =>
      (update(records)..where((t) => t.id.equals(id))).write(patch);
  Future<void> _writeAll(List<String> ids, RecordsCompanion patch) =>
      (update(records)..where((t) => t.id.isIn(ids))).write(patch);

  Future<void> setPenalty(String id, Penalty v) => _write(id, RecordsCompanion(penalty: Value(v)));
  Future<void> setComment(String id, String? v) => _write(id, RecordsCompanion(comment: Value(v)));
  Future<void> setArchived(String id, bool v) => _write(id, RecordsCompanion(archived: Value(v)));

  Future<void> softDelete(String id) => _write(id, RecordsCompanion(deletedAt: Value(DateTime.now())));

  Future<void> archiveAll(List<String> ids) async => _writeAll(ids, RecordsCompanion(archived: Value(true)));
  Future<void> deleteAll(List<String> ids) async =>
      _writeAll(ids, RecordsCompanion(deletedAt: Value(DateTime.now())));
}
