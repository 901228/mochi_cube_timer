import "package:cube_timer/cube_timer.dart";
import "package:flutter/widgets.dart";
import "package:mochi_ui/mochi_ui.dart";

extension PenaltyIcon on Penalty {
  IconData get icon => switch (this) {
    .none => TablerIcons.circleCheck,
    .dnf => TablerIcons.ban,
    .plus2 => TablerIcons.exposurePlus2,
  };

  String get displayName => switch (this) {
    .none => "None",
    .dnf => "DNF",
    .plus2 => "Plus 2 seconds",
  };
}
