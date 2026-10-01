import "package:cube_timer/cube_timer.dart";
import "package:drift/drift.dart" show Value;
import "package:flutter/widgets.dart";
import "package:mochi_ui/mochi_ui.dart";

import "../../../shared/utils.dart";
import "../settings_tile.dart";

class CubeColorsSettingsSections extends StatelessWidget {
  final SettingsEntry settings;
  final SettingsDao dao;
  const CubeColorsSettingsSections({super.key, required this.settings, required this.dao});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: groupSpacing,
      children: [
        MochiTileGroup(
          label: const Text("Cube"),
          children: [
            ColorTile(
              title: "Up",
              color: settings.cubeColorU.toColor(),
              defaultColor: DefaultColors.cubeColors.U.toColor(),
              onSubmit: (c) => dao.save(SettingsCompanion(cubeColorU: Value(c.toARGB32()))),
            ),
            ColorTile(
              title: "Right",
              color: settings.cubeColorR.toColor(),
              defaultColor: DefaultColors.cubeColors.R.toColor(),
              onSubmit: (c) => dao.save(SettingsCompanion(cubeColorR: Value(c.toARGB32()))),
            ),
            ColorTile(
              title: "Front",
              color: settings.cubeColorF.toColor(),
              defaultColor: DefaultColors.cubeColors.F.toColor(),
              onSubmit: (c) => dao.save(SettingsCompanion(cubeColorF: Value(c.toARGB32()))),
            ),
            ColorTile(
              title: "Down",
              color: settings.cubeColorD.toColor(),
              defaultColor: DefaultColors.cubeColors.D.toColor(),
              onSubmit: (c) => dao.save(SettingsCompanion(cubeColorD: Value(c.toARGB32()))),
            ),
            ColorTile(
              title: "Left",
              color: settings.cubeColorL.toColor(),
              defaultColor: DefaultColors.cubeColors.L.toColor(),
              onSubmit: (c) => dao.save(SettingsCompanion(cubeColorL: Value(c.toARGB32()))),
            ),
            ColorTile(
              title: "Back",
              color: settings.cubeColorB.toColor(),
              defaultColor: DefaultColors.cubeColors.B.toColor(),
              onSubmit: (c) => dao.save(SettingsCompanion(cubeColorB: Value(c.toARGB32()))),
            ),
          ],
        ),

        MochiTileGroup(
          label: const Text("Pyraminx"),
          children: [
            ColorTile(
              title: "Up",
              color: settings.pyraminxColorU.toColor(),
              defaultColor: DefaultColors.pyraminxColors.U.toColor(),
              onSubmit: (c) => dao.save(SettingsCompanion(pyraminxColorU: Value(c.toARGB32()))),
            ),
            ColorTile(
              title: "Back",
              color: settings.pyraminxColorB.toColor(),
              defaultColor: DefaultColors.pyraminxColors.B.toColor(),
              onSubmit: (c) => dao.save(SettingsCompanion(pyraminxColorB: Value(c.toARGB32()))),
            ),
            ColorTile(
              title: "Right",
              color: settings.pyraminxColorR.toColor(),
              defaultColor: DefaultColors.pyraminxColors.R.toColor(),
              onSubmit: (c) => dao.save(SettingsCompanion(pyraminxColorR: Value(c.toARGB32()))),
            ),
            ColorTile(
              title: "Left",
              color: settings.pyraminxColorL.toColor(),
              defaultColor: DefaultColors.pyraminxColors.L.toColor(),
              onSubmit: (c) => dao.save(SettingsCompanion(pyraminxColorL: Value(c.toARGB32()))),
            ),
          ],
        ),

        MochiTileGroup(
          label: const Text("Clock"),
          children: [
            ColorTile(
              title: "Front",
              color: settings.clockColorFront.toColor(),
              defaultColor: DefaultColors.clockColors.front.toColor(),
              onSubmit: (c) => dao.save(SettingsCompanion(clockColorFront: Value(c.toARGB32()))),
            ),
            ColorTile(
              title: "Back",
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
