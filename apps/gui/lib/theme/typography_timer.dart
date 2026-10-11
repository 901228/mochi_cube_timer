import "package:mochi_ui/mochi_ui.dart";

@immutable
class TimerTypography extends MochiThemeExtension<TimerTypography> {
  const TimerTypography(this.typeface);

  /// Built once: MochiTheme compares by identity, so a fresh instance per build would restart
  /// the theme animation on every rebuild.
  static final standard = TimerTypography(
    MochiTypeface(
      fontFamily: "Rubik",
      fontFamilyFallback: const ["FakePearl"],
      fontFeatures: const [FontFeature.tabularFigures()],
    ),
  );

  final MochiTypeface typeface;

  // A font family has nothing between two values: it swaps half way through a theme change.
  @override
  TimerTypography lerp(TimerTypography other, double t) => t < 0.5 ? this : other;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is TimerTypography && identical(typeface, other.typeface);

  @override
  int get hashCode => typeface.hashCode;
}

extension TimerTypefaceOf on MochiTheme {
  MochiTypeface get timer => extension<TimerTypography>().typeface;
}
