import "package:mochi_cube/scramblers.dart";

/// The puzzles and drills the app offers, in picker order.
///
/// [id] is the WCA event id and the key in mochi_cube's scrambler maps; the
/// enum lives here rather than in mochi_cube so that library stays open to
/// puzzles this app does not list.
enum Puzzle {
  cube2("222", "2x2 cube"),
  cube3("333", "3x3 cube"),
  cube4("444", "4x4 cube"),
  cube5("555", "5x5 cube"),
  cube6("666", "6x6 cube"),
  cube7("777", "7x7 cube"),
  clock("clock", "Clock"),
  fto("fto", "FTO"),
  megaminx("minx", "Megaminx"),
  pyraminx("pyram", "Pyraminx"),
  skewb("skewb", "Skewb"),
  sq1("sq1", "Square-1");

  const Puzzle(this.id, this.displayName);

  final String id;
  final String displayName;

  static Puzzle fromId(String id) =>
      values.firstWhere((t) => t.id == id, orElse: () => throw ArgumentError("Unknown puzzle: $id"));

  Scrambler get scrambler => puzzleScramblers[id]!;
  Future<Scramble> getScramble() => scrambler.next();
}

/// The penalty for a solve.
enum Penalty { none, plus2, dnf }
