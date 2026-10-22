import "package:cube_timer/cube_timer.dart";

extension DurationUtils on Duration {
  /// The time with [decimals] (1 to 3) after the seconds, cut off rather than rounded: a result is
  /// truncated, as the WCA's regulation 9f1 has it, so 1.497 s is 1.49 and not 1.50.
  String timerString({int decimals = 2}) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");

    // Whole numbers throughout, so there is no rounding up into a third digit for 1.996.
    final perSecond = const [1, 10, 100, 1000][decimals];
    final ticks = inMilliseconds.abs() ~/ (1000 ~/ perSecond);
    final fraction = (ticks % perSecond).toString().padLeft(decimals, "0");
    final totalSeconds = ticks ~/ perSecond;
    final hours = totalSeconds ~/ 3600;
    final minutes = totalSeconds ~/ 60 % 60;
    final seconds = totalSeconds % 60;

    final hasMinutes = totalSeconds >= 60;
    final negativeSign = isNegative ? "-" : "";
    final hourPart = hours > 0 ? "$hours:" : "";
    final minutePart = hasMinutes ? "${hours > 0 ? twoDigits(minutes) : minutes}:" : "";
    final secondPart = hasMinutes ? twoDigits(seconds) : "$seconds";

    return "$negativeSign$hourPart$minutePart$secondPart.$fraction";
  }

  String timerDisplayString(Penalty penalty, {int decimals = 2}) => switch (penalty) {
    .none => timerString(decimals: decimals),
    .dnf => "DNF",
    .plus2 => (this + Duration(seconds: 2)).timerString(decimals: decimals),
  };
}

extension DateTimeUtils on DateTime {
  String get monthDayString => "${month.toString().padLeft(2, "0")}/${day.toString().padLeft(2, "0")}";

  String get fullDateString => "$year/${month.toString().padLeft(2, "0")}/${day.toString().padLeft(2, "0")}";
  String get fullDateTimeString =>
      "$fullDateString ${hour.toString().padLeft(2, "0")}:${minute.toString().padLeft(2, "0")}";
}

extension Int2SecondsDuration on int {
  Duration get milliseconds => Duration(milliseconds: this);
}
