import "package:mochi_cube/scramblers.dart";

/// The puzzles and drills the app offers, in picker order.
///
/// [id] is the WCA event id and the key in mochi_cube's scrambler maps; the
/// enum lives here rather than in mochi_cube so that library stays open to
/// puzzles this app does not list.
enum Puzzle {
  cube2("222"),
  cube3("333"),
  cube4("444"),
  cube5("555"),
  cube6("666"),
  cube7("777"),
  clock("clock"),
  fto("fto"),
  megaminx("minx"),
  pyraminx("pyram"),
  skewb("skewb"),
  sq1("sq1");

  const Puzzle(this.id);

  final String id;

  static Puzzle fromId(String id) =>
      values.firstWhere((t) => t.id == id, orElse: () => throw ArgumentError("Unknown puzzle: $id"));

  Scrambler get scrambler => puzzleScramblers[id]!;
  Future<Scramble> getScramble() => scrambler.nextInBackground();
}

/// The penalty for a solve.
enum Penalty { none, plus2, dnf }
