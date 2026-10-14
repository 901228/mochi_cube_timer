import "package:cube_timer/cube_timer.dart";
import "package:drift/drift.dart" show Value;
import "package:mochi_ui/mochi_ui.dart";

import "../../../shared/utils.dart";
import "../settings_tile.dart";

class TimerColorsSettingsSections extends StatelessWidget {
  final SettingsEntry settings;
  final SettingsDao dao;
  const TimerColorsSettingsSections({super.key, required this.settings, required this.dao});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: groupSpacing,
      children: [
        MochiTileGroup(
          label: const Text("Timer Colors"),
          children: [
            ColorTile(
              title: "Timer Pressed Color",
              color: settings.timerPressedColor.toColor(),
              defaultColor: DefaultColors.timerColors.pressed.toColor(),
              onSubmit: (c) => dao.save(SettingsCompanion(timerPressedColor: Value(c.toARGB32()))),
            ),
            ColorTile(
              title: "Timer Holding Color",
              color: settings.timerHoldingColor.toColor(),
              defaultColor: DefaultColors.timerColors.holding.toColor(),
              onSubmit: (c) => dao.save(SettingsCompanion(timerHoldingColor: Value(c.toARGB32()))),
            ),
            ColorTile(
              title: "Timer Accept Color",
              color: settings.timerAcceptColor.toColor(),
              defaultColor: DefaultColors.timerColors.accept.toColor(),
              onSubmit: (c) => dao.save(SettingsCompanion(timerAcceptColor: Value(c.toARGB32()))),
            ),
          ],
        ),
      ],
    );
  }
}
