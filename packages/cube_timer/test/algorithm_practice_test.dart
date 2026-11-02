import "package:cube_timer/cube_timer.dart";
import "package:drift/native.dart";
import "package:test/test.dart";

void main() {
  late AppDatabase db;

  setUp(() => db = AppDatabase(NativeDatabase.memory()));
  tearDown(() => db.close());

  test("the practice of an algorithm set is kept apart from the puzzle's own solves", () async {
    await db.recordsDao.add(session: kDefaultSessionId, puzzle: .cube3, scramble: "R", time: 10000);
    await db.recordsDao.add(
      session: kDefaultSessionId,
      puzzle: .cube3,
      scramble: "U",
      time: 2000,
      algorithmSet: "pll",
      algorithmCase: "ua",
    );

    expect((await db.recordsDao.getSession(kDefaultSessionId, .cube3)).map((r) => r.scramble), ["R"]);
    final practice = await db.recordsDao.getSession(kDefaultSessionId, .cube3, algorithmSet: "pll");
    expect(practice.map((r) => (r.scramble, r.algorithmCase)), [("U", "ua")]);
    expect(await db.recordsDao.watchBest(kDefaultSessionId, .cube3).first, 10000);
    expect(await db.recordsDao.watchBest(kDefaultSessionId, .cube3, algorithmSet: "pll").first, 2000);
    expect(await db.recordsDao.getSession(kDefaultSessionId, .cube3, algorithmSet: "oll"), isEmpty);
  });

  test("picking a puzzle leaves the practice, picking a set starts it", () async {
    await db.appStateDao.setAlgorithmSet(.cube5, "l2c");
    expect(await db.appStateDao.current.then((s) => (s.puzzle, s.algorithmSet)), (Puzzle.cube5, "l2c"));
    await db.appStateDao.setPuzzle(.cube3);
    expect(await db.appStateDao.current.then((s) => (s.puzzle, s.algorithmSet)), (Puzzle.cube3, null));
  });

  test("the cases left out are kept per puzzle and set", () async {
    await db.appStateDao.setExcluded(.cube3, "pll", {"ua", "ub"});
    await db.appStateDao.setExcluded(.cube3, "oll", {"oll-1"});
    await db.appStateDao.setExcluded(.cube3, "pll", {"h"});
    expect(await db.appStateDao.watchExcluded(.cube3, "pll").first, {"h"});
    expect(await db.appStateDao.watchExcluded(.cube3, "oll").first, {"oll-1"});
    expect(await db.appStateDao.watchExcluded(.cube4, "pll").first, isEmpty);
  });
}
