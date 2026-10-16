import "package:cube_timer/cube_timer.dart";
import "package:drift/drift.dart" show Value;
import "package:mochi_ui/mochi_ui.dart";

import "../../../l10n/l10n.dart";
import "../../../shared/utils.dart";
import "../settings_tile.dart";

class PuzzleSettingsSections extends StatelessWidget {
  final SettingsEntry settings;
  final SettingsDao dao;
  const PuzzleSettingsSections({super.key, required this.settings, required this.dao});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      spacing: groupSpacing,
      children: [
        MochiTileGroup(
          label: Text(l10n.puzzleCubeColors),
          children: [
            ColorTile(
              title: l10n.faceUp,
              color: settings.cubeColorU.toColor(),
              defaultColor: DefaultColors.cubeColors.U.toColor(),
              onSubmit: (c) => dao.save(SettingsCompanion(cubeColorU: Value(c.toARGB32()))),
            ),
            ColorTile(
              title: l10n.faceRight,
              color: settings.cubeColorR.toColor(),
              defaultColor: DefaultColors.cubeColors.R.toColor(),
              onSubmit: (c) => dao.save(SettingsCompanion(cubeColorR: Value(c.toARGB32()))),
            ),
            ColorTile(
              title: l10n.faceFront,
              color: settings.cubeColorF.toColor(),
              defaultColor: DefaultColors.cubeColors.F.toColor(),
              onSubmit: (c) => dao.save(SettingsCompanion(cubeColorF: Value(c.toARGB32()))),
            ),
            ColorTile(
              title: l10n.faceDown,
              color: settings.cubeColorD.toColor(),
              defaultColor: DefaultColors.cubeColors.D.toColor(),
              onSubmit: (c) => dao.save(SettingsCompanion(cubeColorD: Value(c.toARGB32()))),
            ),
            ColorTile(
              title: l10n.faceLeft,
              color: settings.cubeColorL.toColor(),
              defaultColor: DefaultColors.cubeColors.L.toColor(),
              onSubmit: (c) => dao.save(SettingsCompanion(cubeColorL: Value(c.toARGB32()))),
            ),
            ColorTile(
              title: l10n.faceBack,
              color: settings.cubeColorB.toColor(),
              defaultColor: DefaultColors.cubeColors.B.toColor(),
              onSubmit: (c) => dao.save(SettingsCompanion(cubeColorB: Value(c.toARGB32()))),
            ),
          ],
        ),

        MochiTileGroup(
          label: Text(l10n.puzzlePyraminxColors),
          children: [
            ColorTile(
              title: l10n.faceUp,
              color: settings.pyraminxColorU.toColor(),
              defaultColor: DefaultColors.pyraminxColors.U.toColor(),
              onSubmit: (c) => dao.save(SettingsCompanion(pyraminxColorU: Value(c.toARGB32()))),
            ),
            ColorTile(
              title: l10n.faceBack,
              color: settings.pyraminxColorB.toColor(),
              defaultColor: DefaultColors.pyraminxColors.B.toColor(),
              onSubmit: (c) => dao.save(SettingsCompanion(pyraminxColorB: Value(c.toARGB32()))),
            ),
            ColorTile(
              title: l10n.faceRight,
              color: settings.pyraminxColorR.toColor(),
              defaultColor: DefaultColors.pyraminxColors.R.toColor(),
              onSubmit: (c) => dao.save(SettingsCompanion(pyraminxColorR: Value(c.toARGB32()))),
            ),
            ColorTile(
              title: l10n.faceLeft,
              color: settings.pyraminxColorL.toColor(),
              defaultColor: DefaultColors.pyraminxColors.L.toColor(),
              onSubmit: (c) => dao.save(SettingsCompanion(pyraminxColorL: Value(c.toARGB32()))),
            ),
          ],
        ),

        MochiTileGroup(
          label: Text(l10n.puzzleClockColors),
          children: [
            ColorTile(
              title: l10n.faceFront,
              color: settings.clockColorFront.toColor(),
              defaultColor: DefaultColors.clockColors.front.toColor(),
              onSubmit: (c) => dao.save(SettingsCompanion(clockColorFront: Value(c.toARGB32()))),
            ),
            ColorTile(
              title: l10n.faceBack,
              color: settings.clockColorBack.toColor(),
              defaultColor: DefaultColors.clockColors.back.toColor(),
              onSubmit: (c) => dao.save(SettingsCompanion(clockColorBack: Value(c.toARGB32()))),
            ),
          ],
        ),
      ],
    );
  }
}
