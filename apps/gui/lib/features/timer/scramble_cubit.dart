import "dart:math";

import "package:cube_timer/cube_timer.dart";
import "package:flutter_bloc/flutter_bloc.dart";

import "../algorithms/algorithm_data/common.dart";
import "../algorithms/practice_scramble.dart";

/// The current scramble of a puzzle, shared by every page that records a solve.
///
/// Emits [ScrambleHistory.current] whenever it moves, so a page rebuilds on it.
class ScrambleCubit extends Cubit<Future<Scramble>> {
  ScrambleCubit(Puzzle puzzle) : this._(ScrambleHistory(puzzle));
  ScrambleCubit._(this._history) : super(_history.current);

  ScrambleHistory _history;
  AlgorithmSet? _practice;
  Set<String> _excluded = const {};

  /// The case each practice scramble was made from.
  final _cases = Expando<String>();
  final _random = Random();

  Puzzle get puzzle => _history.puzzle;
  bool get hasPrevious => _history.hasPrevious;
  int get position => _history.position;

  /// The id of the case [scramble] was made from, or null if it was not made from one.
  String? caseOf(Future<Scramble> scramble) => _cases[scramble];

  /// Starts a fresh history when [puzzle] is another one, or the practice of another [practice] set or
  /// another choice of its cases, with all but the [excluded] ones.
  void usePuzzle(Puzzle puzzle, {AlgorithmSet? practice, Set<String> excluded = const {}}) {
    if (puzzle == this.puzzle &&
        practice?.id == _practice?.id &&
        excluded.length == _excluded.length &&
        excluded.containsAll(_excluded)) {
      return;
    }
    _practice = practice;
    _excluded = excluded;
    _history = ScrambleHistory(
      puzzle,
      generate: practice == null ? null : () => _practiceScramble(puzzle, practice),
    );
    emit(_history.current);
  }

  Future<Scramble> _practiceScramble(Puzzle puzzle, AlgorithmSet set) {
    final included = [
      for (final c in set.cases)
        if (!_excluded.contains(c.id)) c,
    ];
    // With every case left out, the practice goes on with them all rather than none.
    final cases = included.isEmpty ? set.cases : included;
    final item = cases[_random.nextInt(cases.length)];
    final scramble = Future.sync(
      () => puzzle.scrambler.parse(
        puzzle.id == "fto"
            ? ftoPracticeScramble(item)
            : practiceScramble(item, practiceCubeSize(puzzle.id)!, auf: set.lastLayer, random: _random),
      ),
    );
    _cases[scramble] = item.id;
    return scramble;
  }

  void previous() {
    _history.previous();
    emit(_history.current);
  }

  void next() {
    _history.next();
    emit(_history.current);
  }

  void add(String scramble) {
    _history.add(scramble);
    emit(_history.current);
  }
}
