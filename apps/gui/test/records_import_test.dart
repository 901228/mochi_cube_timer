import "package:cube_timer/cube_timer.dart";
import "package:drift/native.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mochi_cube_timer_gui/shared/puzzles.dart";
import "package:mochi_cube_timer_gui/shared/utils/csv.dart";

void main() {
  test("what is exported is read back, with the bom, quotes and an empty comment", () {
    final bytes = toCsv([
      ["Session", "Puzzle", "Scramble", "Time", "Datetime", "Penalty", "Comment"],
      ["a", "333", "R U R'", 9876, 1700000000000, "plus2", 'said "wow", twice'],
      ["a", "333", "F2 B2", 12000, 1700000001000, "none", null],
    ]);
    final parsed = parseRecordsCsv(String.fromCharCodes(bytes.sublist(3))); // utf8 of ascii

    expect(parsed.skipped, 0);
    expect(parsed.records.map((r) => (r.puzzle, r.scramble, r.time, r.penalty, r.comment)), [
      (Puzzle.cube3, "R U R'", 9876, Penalty.plus2, 'said "wow", twice'),
      (Puzzle.cube3, "F2 B2", 12000, Penalty.none, null),
    ]);
    expect(parsed.records.first.datetime, 1700000000000);
  });

  test("rows that cannot be read are counted, not fatal", () {
    final parsed = parseRecordsCsv(
      "Puzzle,Scramble,Time,Datetime\n333,R,100,1\nnope,R,100,1\n333,R,abc,1\n\n333,U,200,2\n",
    );
    expect(parsed.records.map((r) => r.time), [100, 200]);
    expect(parsed.skipped, 2);
  });

  test("a file without the needed columns is refused", () {
    expect(() => parseRecordsCsv("Name,Score\na,1\n"), throwsFormatException);
    expect(() => parseRecordsCsv(""), throwsFormatException);
  });

  test("importAll adds the rows to the session, as new records", () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final session = await db.sessionsDao.add(name: "s");
    final parsed = parseRecordsCsv("Puzzle,Scramble,Time,Datetime\n333,R,100,1700000000000\n");

    await db.recordsDao.importAll(session, parsed.records);
    await db.recordsDao.importAll(session, parsed.records);

    final rows = await db.recordsDao.getSession(session, Puzzle.cube3);
    expect(rows.length, 2);
    expect(rows.first.datetime.millisecondsSinceEpoch, 1700000000000);
    expect(rows.first.id, isNot(rows.last.id));
  });
}
