import "package:cube_timer/cube_timer.dart";
import "package:drift/drift.dart" show Value;
import "package:flutter/widgets.dart";
import "package:forui/forui.dart";

import "../../utils.dart";
import "../../widgets.dart";
import "../settings.page.dart";

// Common sticker colors offered as quick picks.
const _presets = [
  Color(0xFFFFFFFF),
  Color(0xFFFFFF00),
  Color(0xFFFFC13D),
  Color(0xFFEE6B6B),
  Color(0xFF00FF7F),
  Color(0xFF1E90FF),
  Color(0xFF9B59B6),
  Color(0xFF000000),
];

class CubeColorsSettingsPage extends StatelessWidget {
  final SettingsEntry settings;
  final SettingsDao dao;
  const CubeColorsSettingsPage({super.key, required this.settings, required this.dao});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: groupSpacing,
      children: [
        FTileGroup(
          label: const Text("Cube"),
          children: [
            _ColorTile(
              title: "Up",
              color: settings.cubeColorU.toColor(),
              defaultColor: DefaultColors.cubeColors.U.toColor(),
              onSubmit: (c) => dao.save(SettingsCompanion(cubeColorU: Value(c.toARGB32()))),
            ),
            _ColorTile(
              title: "Right",
              color: settings.cubeColorR.toColor(),
              defaultColor: DefaultColors.cubeColors.R.toColor(),
              onSubmit: (c) => dao.save(SettingsCompanion(cubeColorR: Value(c.toARGB32()))),
            ),
            _ColorTile(
              title: "Front",
              color: settings.cubeColorF.toColor(),
              defaultColor: DefaultColors.cubeColors.F.toColor(),
              onSubmit: (c) => dao.save(SettingsCompanion(cubeColorF: Value(c.toARGB32()))),
            ),
            _ColorTile(
              title: "Down",
              color: settings.cubeColorD.toColor(),
              defaultColor: DefaultColors.cubeColors.D.toColor(),
              onSubmit: (c) => dao.save(SettingsCompanion(cubeColorD: Value(c.toARGB32()))),
            ),
            _ColorTile(
              title: "Left",
              color: settings.cubeColorL.toColor(),
              defaultColor: DefaultColors.cubeColors.L.toColor(),
              onSubmit: (c) => dao.save(SettingsCompanion(cubeColorL: Value(c.toARGB32()))),
            ),
            _ColorTile(
              title: "Back",
              color: settings.cubeColorB.toColor(),
              defaultColor: DefaultColors.cubeColors.B.toColor(),
              onSubmit: (c) => dao.save(SettingsCompanion(cubeColorB: Value(c.toARGB32()))),
            ),
          ],
        ),

        FTileGroup(
          label: const Text("Pyraminx"),
          children: [
            _ColorTile(
              title: "Up",
              color: settings.pyraminxColorU.toColor(),
              defaultColor: DefaultColors.pyraminxColors.U.toColor(),
              onSubmit: (c) => dao.save(SettingsCompanion(pyraminxColorU: Value(c.toARGB32()))),
            ),
            _ColorTile(
              title: "Back",
              color: settings.pyraminxColorB.toColor(),
              defaultColor: DefaultColors.pyraminxColors.B.toColor(),
              onSubmit: (c) => dao.save(SettingsCompanion(pyraminxColorB: Value(c.toARGB32()))),
            ),
            _ColorTile(
              title: "Right",
              color: settings.pyraminxColorR.toColor(),
              defaultColor: DefaultColors.pyraminxColors.R.toColor(),
              onSubmit: (c) => dao.save(SettingsCompanion(pyraminxColorR: Value(c.toARGB32()))),
            ),
            _ColorTile(
              title: "Left",
              color: settings.pyraminxColorL.toColor(),
              defaultColor: DefaultColors.pyraminxColors.L.toColor(),
              onSubmit: (c) => dao.save(SettingsCompanion(pyraminxColorL: Value(c.toARGB32()))),
            ),
          ],
        ),

        FTileGroup(
          label: const Text("Clock"),
          children: [
            _ColorTile(
              title: "Front",
              color: settings.clockColorFront.toColor(),
              defaultColor: DefaultColors.clockColors.front.toColor(),
              onSubmit: (c) => dao.save(SettingsCompanion(clockColorFront: Value(c.toARGB32()))),
            ),
            _ColorTile(
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

class _ColorTile extends StatelessWidget with FTileMixin {
  final String title;
  final Color color;
  final Color defaultColor;
  final Future<void> Function(Color color) onSubmit;
  const _ColorTile({
    required this.title,
    required this.color,
    required this.defaultColor,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) => SettingsTile(
    title: title,
    suffix: Row(
      mainAxisSize: .min,
      spacing: 8,
      children: [
        Text("#${colorToHex(color)}"),
        ColorSwatchBox(color: color),
      ],
    ),
    onPress: () => showFDialog(
      context: context,
      builder: (_, style, animation) => ColorPickerDialog(
        style: style,
        animation: animation,
        title: title,
        initial: color,
        defaultColor: defaultColor,
        presets: _presets,
        onSubmit: onSubmit,
      ),
    ),
  );
}
