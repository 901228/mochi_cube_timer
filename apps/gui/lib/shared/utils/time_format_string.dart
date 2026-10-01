import "package:cube_timer/cube_timer.dart";

extension DurationUtils on Duration {
  String get timerString {
    String twoDigits(int n) => n.toString().padLeft(2, "0");

    String negativeSign = isNegative ? "-" : "";
    bool hasHours = inHours > 0;
    String twoDigitHours = hasHours ? "$inHours:" : "";

    bool hasMinutes = inMinutes > 0 || hasHours;
    String twoDigitMinutes = hasMinutes
        ? "${hasHours ? twoDigits(inMinutes.remainder(60).abs()) : inMinutes.toString()}:"
        : "";

    String twoDigitSeconds = hasMinutes ? twoDigits(inSeconds.remainder(60).abs()) : inSeconds.toString();
    String twoDigitMilliseconds = twoDigits((inMilliseconds.remainder(1000).abs() / 10).round());

    return "$negativeSign$twoDigitHours$twoDigitMinutes$twoDigitSeconds.$twoDigitMilliseconds";
  }

  String timerDisplayString(Penalty penalty) => switch (penalty) {
    .none => timerString,
    .dnf => "DNF",
    .plus2 => (this + Duration(seconds: 2)).timerString,
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
