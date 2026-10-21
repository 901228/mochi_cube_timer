import "dart:ui";

import "package:cube_timer/cube_timer.dart";

extension Int2Color on int {
  Color toColor() => Color(this);
}

extension DefaultColorsPreset2Color on DefaultColorsPreset {
  Color toColor() => Color(value);
}
