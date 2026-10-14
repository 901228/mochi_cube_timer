import "package:cube_timer/cube_timer.dart";
import "package:drift/native.dart";
import "package:test/test.dart";

void main() {
  const before = (solved: 5, best: 9000, worst: 15000);

  group("breakBy", () {
    test("a solve between the best and the worst breaks nothing", () {
      expect(before.breakBy(9000, .none), isNull);
      expect(before.breakBy(15000, .none), isNull);
      expect(before.breakBy(12000, .none), isNull);
    });

    test("a solve beyond either end breaks it, by how far", () {
      expect(before.breakBy(8630, .none), (kind: RecordBreakKind.best, by: 370));
      expect(before.breakBy(16200, .none), (kind: RecordBreakKind.worst, by: 1200));
    });

    test("a +2 counts with its two seconds, and a DNF counts for nothing", () {
      expect(before.breakBy(8000, .plus2), isNull);
      expect(before.breakBy(13500, .plus2), (kind: RecordBreakKind.worst, by: 500));
      expect(before.breakBy(1, .dnf), isNull);
    });

    test("too few solved times to mean anything", () {
      expect((solved: 3, best: 9000, worst: 15000).breakBy(1000, .none), isNull);
      expect((solved: 0, best: null, worst: null).breakBy(1000, .none), isNull);
    });
  });

  test("extremes are of the solved times in the session and puzzle, penalties included", () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final other = await db.sessionsDao.add(name: "other");

    Future<void> add(int time, {Penalty penalty = .none, String? session, Puzzle puzzle = .cube3}) =>
        db.recordsDao.add(
          session: session ?? kDefaultSessionId,
          puzzle: puzzle,
          scramble: "R",
          time: time,
          penalty: penalty,
        );

    expect(await db.recordsDao.extremes(kDefaultSessionId, .cube3), (solved: 0, best: null, worst: null));

    await add(9000);
    await add(8000, penalty: .plus2); // 10000
    await add(1, penalty: .dnf);
    await add(20000, session: other);
    await add(30000, puzzle: .cube2);

    expect(await db.recordsDao.extremes(kDefaultSessionId, .cube3), (solved: 2, best: 9000, worst: 10000));
  });
}
