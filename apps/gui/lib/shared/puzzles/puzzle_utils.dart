import "package:cube_timer/cube_timer.dart";

import "../../l10n/l10n.dart";

extension PuzzleName on Puzzle {
  String displayName(AppLocalizations l10n) => switch (this) {
    .cube2 => l10n.puzzleCube2,
    .cube3 => l10n.puzzleCube3,
    .cube4 => l10n.puzzleCube4,
    .cube5 => l10n.puzzleCube5,
    .cube6 => l10n.puzzleCube6,
    .cube7 => l10n.puzzleCube7,
    .clock => l10n.puzzleClock,
    .fto => l10n.puzzleFto,
    .megaminx => l10n.puzzleMegaminx,
    .pyraminx => l10n.puzzlePyraminx,
    .skewb => l10n.puzzleSkewb,
    .sq1 => l10n.puzzleSquare1,
  };
}
