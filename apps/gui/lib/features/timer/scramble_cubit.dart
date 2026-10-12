import "package:cube_timer/cube_timer.dart";
import "package:flutter_bloc/flutter_bloc.dart";

/// The current scramble of a puzzle, shared by every page that records a solve.
///
/// Emits [ScrambleHistory.current] whenever it moves, so a page rebuilds on it.
class ScrambleCubit extends Cubit<Future<Scramble>> {
  ScrambleCubit(Puzzle puzzle) : this._(ScrambleHistory(puzzle));
  ScrambleCubit._(this._history) : super(_history.current);

  ScrambleHistory _history;

  Puzzle get puzzle => _history.puzzle;
  bool get hasPrevious => _history.hasPrevious;
  int get position => _history.position;

  /// Starts a fresh history when [puzzle] is another one.
  void usePuzzle(Puzzle puzzle) {
    if (puzzle == this.puzzle) return;
    _history = ScrambleHistory(puzzle);
    emit(_history.current);
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
