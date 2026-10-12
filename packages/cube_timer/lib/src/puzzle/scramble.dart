import "package:mochi_cube/scramblers.dart";

import "puzzle.dart";

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

  void add(String scramble) {
    _entries.add(Future.sync(() => puzzle.scrambler.parse(scramble)));
    _index = _entries.length - 1;
  }
}
