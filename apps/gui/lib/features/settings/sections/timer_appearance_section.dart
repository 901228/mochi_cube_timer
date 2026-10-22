import "package:cube_timer/cube_timer.dart";
import "package:drift/drift.dart" show Value;
import "package:mochi_ui/mochi_ui.dart";

import "../../../l10n/l10n.dart";
import "../../../shared/utils.dart";
import "../settings_tile.dart";

class TimerAppearanceSettingsSections extends StatelessWidget {
  final SettingsEntry settings;
  final SettingsDao dao;
  const TimerAppearanceSettingsSections({super.key, required this.settings, required this.dao});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      spacing: groupSpacing,
      children: [
        MochiTileGroup(
          label: Text(l10n.timerDisplay),
          children: [
            SettingsTile(
              title: l10n.timerShowRunningTime,
              subtitle: l10n.timerShowRunningTimeHint,
              suffix: MochiSwitch(value: settings.showRunningTime, onChanged: dao.setShowRunningTime),
            ),
            SettingsTile(
              title: l10n.timerDecimals,
              subtitle: l10n.timerDecimalsHint,
              suffix: MochiSelect<int>(
                value: settings.timeDecimals,
                onChanged: dao.setTimeDecimals,
                options: [
                  for (final n in const [1, 2, 3])
                    MochiSelectOption(value: n, label: l10n.timerDecimalsOption(n)),
                ],
              ),
            ),
          ],
        ),

        MochiTileGroup(
          label: Text(l10n.timerColors),
          children: [
            ColorTile(
              title: l10n.timerColorPressed,
              color: settings.timerPressedColor.toColor(),
              defaultColor: DefaultColors.timerColors.pressed.toColor(),
              onSubmit: (c) => dao.save(SettingsCompanion(timerPressedColor: Value(c.toARGB32()))),
            ),
            ColorTile(
              title: l10n.timerColorHolding,
              color: settings.timerHoldingColor.toColor(),
              defaultColor: DefaultColors.timerColors.holding.toColor(),
              onSubmit: (c) => dao.save(SettingsCompanion(timerHoldingColor: Value(c.toARGB32()))),
            ),
            ColorTile(
              title: l10n.timerColorAccept,
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
