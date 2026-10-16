import "package:cube_timer/cube_timer.dart";
import "package:mochi_ui/mochi_ui.dart";

import "../../l10n/l10n.dart";

extension PenaltyIcon on Penalty {
  IconData get icon => switch (this) {
    .none => TablerIcons.circleCheck,
    .dnf => TablerIcons.ban,
    .plus2 => TablerIcons.exposurePlus2,
  };

  String displayName(AppLocalizations l10n) => switch (this) {
    .none => l10n.penaltyNone,
    .dnf => l10n.penaltyDnf,
    .plus2 => l10n.penaltyPlus2,
  };
}
