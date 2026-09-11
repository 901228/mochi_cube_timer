import "../puzzle/puzzle.dart";
import "app_database.dart";

/// The two times a solve has: what the stopwatch read, and what it counts as.
///
/// Keeping the penalty arithmetic here means no caller has to remember that a
/// +2 is stored unapplied — [finalTime] is the only number statistics, personal
/// bests and averages should ever see.
extension RecordEntryTimes on RecordEntry {
  /// The stopwatch reading on its own, for showing the user what the penalty
  /// was applied to.
  Duration get rawTime => Duration(milliseconds: time);

  /// The time the solve counts as, or `null` for a DNF.
  ///
  /// A DNF has no time to compare, so it is absent rather than a sentinel like
  /// zero or infinity. Averages have to make their own decision about it —
  /// WCA rules count it as the worst solve, and a mean cannot be taken at all.
  Duration? get finalTime => switch (penalty) {
    Penalty.none => rawTime,
    Penalty.plus2 => rawTime + const Duration(seconds: 2),
    Penalty.dnf => null,
  };
}
