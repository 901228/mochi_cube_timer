import "dart:math" as math;

import "package:collection/collection.dart" show lowerBound;
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

Expression<int> _effective($RecordsTable t) => CaseWhenExpression(
  cases: [CaseWhen(t.penalty.equalsValue(Penalty.plus2), then: t.time + const Constant(2000))],
  orElse: t.time,
);

Expression<bool> _scope($RecordsTable t, String session, Puzzle puzzle, {bool showArchived = false}) =>
    t.session.equals(session) &
    t.puzzle.equals(puzzle.id) &
    t.deletedAt.isNull() &
    t.archived.equals(showArchived);

extension on RecordSort {
  List<OrderingTerm Function($RecordsTable)> get orderBy => switch (this) {
    .newest => [(t) => .desc(t.datetime)],
    .oldest => [(t) => .asc(t.datetime)],
    .fastest => [(t) => .asc(t.penalty.equalsValue(Penalty.dnf)), (t) => .asc(_effective(t))],
    .slowest => [(t) => .desc(t.penalty.equalsValue(Penalty.dnf)), (t) => .desc(_effective(t))],
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
      Expression<bool> base = _scope(t, session, puzzle, showArchived: showArchived);

      if (query.comment.isNotEmpty) base &= t.comment.like("%${query.comment}%");
      if (query.penalties.isNotEmpty) base &= t.penalty.isInValues(query.penalties);
      if (query.from != null) base &= t.datetime.isBiggerOrEqualValue(query.from!);
      if (query.to != null) {
        base &= t.datetime.isSmallerThanValue(query.to!.add(const Duration(days: 1)));
      }

      return base;
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
    String? comment,
  }) async {
    final row = await into(records).insertReturning(
      RecordsCompanion.insert(
        session: session,
        puzzle: puzzle,
        scramble: scramble,
        time: time,
        penalty: penalty,
        comment: Value(comment),
      ),
    );
    return row.id;
  }
}

extension RecordsDaoModify on RecordsDao {
  Future<void> _write(String id, RecordsCompanion patch) =>
      (update(records)..where((t) => t.id.equals(id))).write(patch);
  Future<void> _writeAll(Iterable<String> ids, RecordsCompanion patch) =>
      (update(records)..where((t) => t.id.isIn(ids))).write(patch);

  Future<void> setPenalty(String id, Penalty v) => _write(id, RecordsCompanion(penalty: Value(v)));
  Future<void> setSession(String id, String v) => _write(id, RecordsCompanion(session: Value(v)));
  Future<void> setComment(String id, String? v) => _write(id, RecordsCompanion(comment: Value(v)));
  Future<void> setArchived(String id, bool v) => _write(id, RecordsCompanion(archived: Value(v)));

  Future<void> softDelete(String id) => _write(id, RecordsCompanion(deletedAt: Value(DateTime.now())));

  Future<void> setArchivedAll(Iterable<String> ids, bool v) async =>
      _writeAll(ids, RecordsCompanion(archived: Value(v)));
  Future<void> deleteAll(Iterable<String> ids) async =>
      _writeAll(ids, RecordsCompanion(deletedAt: Value(DateTime.now())));
  Future<void> setPenaltyAll(Iterable<String> ids, Penalty v) =>
      _writeAll(ids, RecordsCompanion(penalty: Value(v)));
  Future<void> setSessionAll(Iterable<String> ids, String v) =>
      _writeAll(ids, RecordsCompanion(session: Value(v)));
}

typedef SessionSummary = ({int count, double? mean, double? deviation, double? best});

typedef SolveTime = ({double time, bool isDnf});

extension SolveTimeValue on SolveTime {
  double get value => isDnf ? double.infinity : time;
}

extension RecordsDaoStatistics on RecordsDao {
  Stream<SessionSummary> watchSummary(String session, Puzzle puzzle, {bool showArchived = false}) {
    final eff = _effective(records);
    final solved = records.penalty.equalsValue(Penalty.dnf).not();

    final count = records.id.count();
    final solvedCount = records.id.count(filter: solved);
    final mean = eff.avg(filter: solved);
    final meanSq = (eff * eff).avg(filter: solved);
    final best = eff.min(filter: solved);

    final q = selectOnly(records)
      ..addColumns([count, solvedCount, mean, meanSq, best])
      ..where(_scope(records, session, puzzle, showArchived: showArchived));

    return q.watchSingle().map((r) {
      final n = r.read(solvedCount)!;
      final m = r.read(mean);
      final m2 = r.read(meanSq);
      // sample standard deviation: divided by n-1
      final sd = (n > 1 && m != null && m2 != null)
          ? math.sqrt(math.max(0, (m2 - m * m) * n / (n - 1)))
          : null;
      return (count: r.read(count)!, mean: m, deviation: sd, best: r.read(best)?.toDouble());
    });
  }

  Stream<List<SolveTime>> watchTimes(String session, Puzzle puzzle, {bool showArchived = false, int? limit}) {
    final eff = _effective(records);
    final q = selectOnly(records)
      ..addColumns([eff, records.penalty])
      ..where(_scope(records, session, puzzle, showArchived: showArchived))
      ..orderBy([OrderingTerm.desc(records.datetime)]);
    if (limit != null) q.limit(limit);

    return q.watch().map(
      (rows) => [
        for (final r in rows)
          (time: r.read(eff)!.toDouble(), isDnf: r.readWithConverter(records.penalty) == .dnf),
      ],
    );
  }

  static double? _trimmedMean(List<SolveTime> latestFirst, int n, {required int trim}) {
    if (latestFirst.length < n) return null;
    final xs = latestFirst.take(n).map((s) => s.value).toList()..sort();
    final kept = xs.sublist(trim, n - trim);
    return kept.fold(0.0, (a, b) => a + b) / kept.length; // a DNF left after trimming makes the sum infinite
  }

  /// Best trimmed mean over every run of [n] consecutive solves, or null if there are fewer than [n].
  /// Keeps the window sorted and swaps one value per step, so each step costs O(n), not O(n log n).
  static (double, List<double>)? _bestTrimmedMean(List<SolveTime> times, int n, {required int trim}) {
    if (times.length < n) return null;

    final window = times.take(n).map((s) => s.value).toList()..sort();
    var bestMean = double.infinity;
    var bestStart = 0;
    for (var i = 0; ; i++) {
      var sum = 0.0;
      for (var j = trim; j < n - trim; j++) {
        sum += window[j];
      }
      final mean = sum / (n - 2 * trim);
      if (mean < bestMean) {
        bestMean = mean;
        bestStart = i;
      }

      if (i + n >= times.length) {
        return (bestMean, times.sublist(bestStart, bestStart + n).map((e) => e.value).toList());
      }
      window.removeAt(lowerBound(window, times[i].value));
      final next = times[i + n].value;
      window.insert(lowerBound(window, next), next);
    }
  }

  static double? mo(List<SolveTime> t, int n) => _trimmedMean(t, n, trim: 0);
  static double? ao(List<SolveTime> t, int n) => _trimmedMean(t, n, trim: (n * 0.05).ceil());
  static double? bestMo(List<SolveTime> t, int n) => _bestTrimmedMean(t, n, trim: 0)?.$1;
  static double? bestAo(List<SolveTime> t, int n) => _bestTrimmedMean(t, n, trim: (n * 0.05).ceil())?.$1;
  static (double, List<double>)? bestAoWithList(List<SolveTime> t, int n) =>
      _bestTrimmedMean(t, n, trim: (n * 0.05).ceil());
}

extension StatisticsRecordTimeList on List<SolveTime> {
  double? mo(int n) => RecordsDaoStatistics.mo(this, n);
  double? ao(int n) => RecordsDaoStatistics.ao(this, n);
  double? bestMo(int n) => RecordsDaoStatistics.bestMo(this, n);
  double? bestAo(int n) => RecordsDaoStatistics.bestAo(this, n);
  (double, List<double>)? bestAoWithList(int n) => RecordsDaoStatistics.bestAoWithList(this, n);
}

typedef RecordExport = ({
  String? comment,
  int datetime,
  String id,
  Penalty penalty,
  Puzzle puzzle,
  String scramble,
  SessionEntry session,
  int time,
});

extension RecordsDaoData on RecordsDao {
  Future<List<RecordExport>> export(String session, Puzzle puzzle, {bool includeDeleted = false}) =>
      (select(records)..where((t) {
            Expression<bool> base = t.session.equals(session) & t.puzzle.equals(puzzle.id);
            if (!includeDeleted) {
              base &= t.deletedAt.isNull();
            }

            return base;
          }))
          .join([innerJoin(sessions, sessions.id.equalsExp(records.session))])
          .map((row) {
            final record = row.readTable(records);
            final session = row.readTable(sessions);

            return (
              id: record.id,
              puzzle: record.puzzle,
              session: session,
              scramble: record.scramble,
              time: record.time,
              datetime: record.datetime.millisecondsSinceEpoch,
              penalty: record.penalty,
              comment: record.comment,
            );
          })
          .get();
}
