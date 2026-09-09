part of "../theme.dart";

/// Hand-edited from the Forui CLI output. Regenerating with
/// "dart forui theme create --preset cdbbbc" will overwrite this file.

const _fontFamily = "Comfortaa";
const _timerFontFamily = "Rubik";
const _fontFamilyFallback = ["NotoSansTC"];

FTypography _typography({required FColors colors, required bool touch}) => FTypography(
  display: FTypeface.inherit(
    colors: colors,
    touch: touch,
    fontFamily: _fontFamily,
    fontFamilyFallback: _fontFamilyFallback,
  ),
  body: FTypeface.inherit(
    colors: colors,
    touch: touch,
    fontFamily: _fontFamily,
    fontFamilyFallback: _fontFamilyFallback,
  ),
  extensions: [
    TimerTypeface(
      typeface: _timer(colors: colors, touch: touch),
    ),
  ],
);

/// A tabular-figure typeface for timer readouts and stat tables.
///
/// Rubik's digits are proportional by default (0.220em spread), so [FontFeature.tabularFigures]
/// is mandatory here — swapping the family alone will not stop the digits from jittering.
class TimerTypeface extends FScalableExtension<TimerTypeface> {
  final FTypeface typeface;

  const TimerTypeface({required this.typeface});

  @override
  TimerTypeface copyWith({FTypeface? typeface}) => TimerTypeface(typeface: typeface ?? this.typeface);

  @override
  TimerTypeface lerp(TimerTypeface? other, double t) {
    if (other is! TimerTypeface) return this;
    return TimerTypeface(typeface: typeface.lerp(other.typeface, t));
  }

  @override
  TimerTypeface scale({double sizeScalar = 1}) =>
      TimerTypeface(typeface: typeface.scale(sizeScalar: sizeScalar));
}

/// Convenient access to the tabular-figure typeface.
extension TimerTypography on FTypography {
  FTypeface get timer => extension<TimerTypeface>().typeface;
}

FTypeface _timer({required FColors colors, required bool touch}) {
  const features = [FontFeature.tabularFigures()];

  final base = FTypeface.inherit(
    colors: colors,
    touch: touch,
    fontFamily: _timerFontFamily,
    fontFamilyFallback: _fontFamilyFallback,
  );

  return FTypeface(
    fontFamily: base.fontFamily,
    fontFamilyFallback: base.fontFamilyFallback,
    xs3: base.xs3.copyWith(fontFeatures: features),
    xs2: base.xs2.copyWith(fontFeatures: features),
    xs: base.xs.copyWith(fontFeatures: features),
    sm: base.sm.copyWith(fontFeatures: features),
    md: base.md.copyWith(fontFeatures: features),
    lg: base.lg.copyWith(fontFeatures: features),
    xl: base.xl.copyWith(fontFeatures: features),
    xl2: base.xl2.copyWith(fontFeatures: features),
    xl3: base.xl3.copyWith(fontFeatures: features),
    xl4: base.xl4.copyWith(fontFeatures: features),
    xl5: base.xl5.copyWith(fontFeatures: features),
    xl6: base.xl6.copyWith(fontFeatures: features),
    xl7: base.xl7.copyWith(fontFeatures: features),
    xl8: base.xl8.copyWith(fontFeatures: features),
  );
}
