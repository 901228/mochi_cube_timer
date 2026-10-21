import "package:cube_timer/cube_timer.dart";
import "package:drift/drift.dart" show Value;
import "package:mochi_ui/mochi_ui.dart";

import "../../../l10n/l10n.dart";
import "../../../shared/utils.dart";
import "../settings_tile.dart";

class PuzzleSettingsSections extends StatefulWidget {
  final SettingsEntry settings;
  final SettingsDao dao;
  const PuzzleSettingsSections({super.key, required this.settings, required this.dao});

  @override
  State<PuzzleSettingsSections> createState() => _PuzzleSettingsSectionsState();
}

class _PuzzleSettingsSectionsState extends State<PuzzleSettingsSections> {
  /// Which puzzle's colours are open, if any. One at a time: the colours of the four puzzles are
  /// twenty-odd rows between them, more than a page wants to show at once.
  int? _open;

  SettingsEntry get settings => widget.settings;
  SettingsDao get dao => widget.dao;

  /// A group whose first row is its heading, a tile like the other settings, and whose colours open
  /// under it.
  Widget _group(int index, String title, List<Widget> tiles) {
    final open = _open == index;
    return MochiTileGroup(
      // The rules are drawn here, between the rows that are shown: the group would put one under
      // the heading even while the colours are folded away.
      divider: MochiTileDivider.none,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SettingsTile(
              title: title,
              suffix: Icon(open ? TablerIcons.chevronUp : TablerIcons.chevronDown),
              onPress: () => setState(() => _open = open ? null : index),
            ),
            MochiReveal(
              expanded: open,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (final tile in tiles) ...[const MochiDivider(), tile],
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      spacing: groupSpacing,
      children: [
        _group(0, l10n.puzzleCubeColors, [
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
        ]),
        _group(1, l10n.puzzlePyraminxColors, [
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
        ]),
        _group(2, l10n.puzzleMegaminxColors, [
          ColorTile(
            title: "U",
            color: settings.megaminxColorU.toColor(),
            defaultColor: DefaultColors.megaminxColors.u.toColor(),
            onSubmit: (c) => dao.save(SettingsCompanion(megaminxColorU: Value(c.toARGB32()))),
          ),
          ColorTile(
            title: "BL",
            color: settings.megaminxColorBL.toColor(),
            defaultColor: DefaultColors.megaminxColors.bl.toColor(),
            onSubmit: (c) => dao.save(SettingsCompanion(megaminxColorBL: Value(c.toARGB32()))),
          ),
          ColorTile(
            title: "BR",
            color: settings.megaminxColorBR.toColor(),
            defaultColor: DefaultColors.megaminxColors.br.toColor(),
            onSubmit: (c) => dao.save(SettingsCompanion(megaminxColorBR: Value(c.toARGB32()))),
          ),
          ColorTile(
            title: "R",
            color: settings.megaminxColorR.toColor(),
            defaultColor: DefaultColors.megaminxColors.r.toColor(),
            onSubmit: (c) => dao.save(SettingsCompanion(megaminxColorR: Value(c.toARGB32()))),
          ),
          ColorTile(
            title: "F",
            color: settings.megaminxColorF.toColor(),
            defaultColor: DefaultColors.megaminxColors.f.toColor(),
            onSubmit: (c) => dao.save(SettingsCompanion(megaminxColorF: Value(c.toARGB32()))),
          ),
          ColorTile(
            title: "L",
            color: settings.megaminxColorL.toColor(),
            defaultColor: DefaultColors.megaminxColors.l.toColor(),
            onSubmit: (c) => dao.save(SettingsCompanion(megaminxColorL: Value(c.toARGB32()))),
          ),
          ColorTile(
            title: "D",
            color: settings.megaminxColorD.toColor(),
            defaultColor: DefaultColors.megaminxColors.d.toColor(),
            onSubmit: (c) => dao.save(SettingsCompanion(megaminxColorD: Value(c.toARGB32()))),
          ),
          ColorTile(
            title: "DR",
            color: settings.megaminxColorDR.toColor(),
            defaultColor: DefaultColors.megaminxColors.dr.toColor(),
            onSubmit: (c) => dao.save(SettingsCompanion(megaminxColorDR: Value(c.toARGB32()))),
          ),
          ColorTile(
            title: "DBR",
            color: settings.megaminxColorDBR.toColor(),
            defaultColor: DefaultColors.megaminxColors.dbr.toColor(),
            onSubmit: (c) => dao.save(SettingsCompanion(megaminxColorDBR: Value(c.toARGB32()))),
          ),
          ColorTile(
            title: "B",
            color: settings.megaminxColorB.toColor(),
            defaultColor: DefaultColors.megaminxColors.b.toColor(),
            onSubmit: (c) => dao.save(SettingsCompanion(megaminxColorB: Value(c.toARGB32()))),
          ),
          ColorTile(
            title: "DBL",
            color: settings.megaminxColorDBL.toColor(),
            defaultColor: DefaultColors.megaminxColors.dbl.toColor(),
            onSubmit: (c) => dao.save(SettingsCompanion(megaminxColorDBL: Value(c.toARGB32()))),
          ),
          ColorTile(
            title: "DL",
            color: settings.megaminxColorDL.toColor(),
            defaultColor: DefaultColors.megaminxColors.dl.toColor(),
            onSubmit: (c) => dao.save(SettingsCompanion(megaminxColorDL: Value(c.toARGB32()))),
          ),
        ]),
        _group(3, l10n.puzzleFtoColors, [
          ColorTile(
            title: "U",
            color: settings.ftoColorU.toColor(),
            defaultColor: DefaultColors.ftoColors.u.toColor(),
            onSubmit: (c) => dao.save(SettingsCompanion(ftoColorU: Value(c.toARGB32()))),
          ),
          ColorTile(
            title: "R",
            color: settings.ftoColorR.toColor(),
            defaultColor: DefaultColors.ftoColors.r.toColor(),
            onSubmit: (c) => dao.save(SettingsCompanion(ftoColorR: Value(c.toARGB32()))),
          ),
          ColorTile(
            title: "F",
            color: settings.ftoColorF.toColor(),
            defaultColor: DefaultColors.ftoColors.f.toColor(),
            onSubmit: (c) => dao.save(SettingsCompanion(ftoColorF: Value(c.toARGB32()))),
          ),
          ColorTile(
            title: "L",
            color: settings.ftoColorL.toColor(),
            defaultColor: DefaultColors.ftoColors.l.toColor(),
            onSubmit: (c) => dao.save(SettingsCompanion(ftoColorL: Value(c.toARGB32()))),
          ),
          ColorTile(
            title: "B",
            color: settings.ftoColorB.toColor(),
            defaultColor: DefaultColors.ftoColors.b.toColor(),
            onSubmit: (c) => dao.save(SettingsCompanion(ftoColorB: Value(c.toARGB32()))),
          ),
          ColorTile(
            title: "BL",
            color: settings.ftoColorBL.toColor(),
            defaultColor: DefaultColors.ftoColors.bl.toColor(),
            onSubmit: (c) => dao.save(SettingsCompanion(ftoColorBL: Value(c.toARGB32()))),
          ),
          ColorTile(
            title: "D",
            color: settings.ftoColorD.toColor(),
            defaultColor: DefaultColors.ftoColors.d.toColor(),
            onSubmit: (c) => dao.save(SettingsCompanion(ftoColorD: Value(c.toARGB32()))),
          ),
          ColorTile(
            title: "BR",
            color: settings.ftoColorBR.toColor(),
            defaultColor: DefaultColors.ftoColors.br.toColor(),
            onSubmit: (c) => dao.save(SettingsCompanion(ftoColorBR: Value(c.toARGB32()))),
          ),
        ]),
        _group(4, l10n.puzzleClockColors, [
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
        ]),
      ],
    );
  }
}
