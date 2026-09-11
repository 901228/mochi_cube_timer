import "package:mochi_cube/scramblers.dart";

export "package:mochi_cube/scramblers.dart";

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

/// The scrambles shown so far for one puzzle, and which one is current.
///
/// A list plus a cursor, the way cstimer does it: stepping back reads an entry
/// that already exists, so the same scramble comes back rather than a new one,
/// and only stepping forward past the end generates.
///
/// Futures rather than resolved scrambles, since the first scramble of a puzzle
/// is slow enough to want a progress indicator; a future that has already
/// completed resolves at once when stepped back to.
class ScrambleHistory {
  ScrambleHistory(this.puzzle) {
    _entries.add(puzzle.getScramble());
  }

  final Puzzle puzzle;
  final List<Future<Scramble>> _entries = [];

  int _index = 0;

  /// The scramble being shown.
  Future<Scramble> get current => _entries[_index];

  /// Where in the history that is, counting from 1 for a display like "3 / 7".
  int get position => _index + 1;

  int get length => _entries.length;

  bool get hasPrevious => _index > 0;

  /// Step back to the scramble before this one. Does nothing at the start.
  void previous() {
    if (hasPrevious) _index--;
  }

  /// Step forward, generating a new scramble when already at the end.
  void next() {
    _index++;
    if (_index == _entries.length) _entries.add(puzzle.getScramble());
  }
}

/// The penalty for a solve.
enum Penalty { none, plus2, dnf }
