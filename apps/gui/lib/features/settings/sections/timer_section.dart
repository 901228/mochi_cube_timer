import "package:cube_timer/cube_timer.dart";
import "package:mochi_ui/mochi_ui.dart";

import "../../../l10n/l10n.dart";
import "../../timer/stackmat_bridge.dart";
import "../settings_tile.dart";

class TimerSettingsSections extends StatelessWidget {
  final SettingsEntry settings;
  final SettingsDao dao;
  const TimerSettingsSections({super.key, required this.settings, required this.dao});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      spacing: groupSpacing,
      children: [
        MochiTileGroup(
          label: Text(l10n.timerInput),
          children: [
            SettingsTile(
              title: l10n.timerHold,
              subtitle: l10n.timerHoldHint,
              suffix: MochiSelect<int>(
                value: settings.holdDuration,
                onChanged: (ms) => dao.setHoldDuration(Duration(milliseconds: ms)),
                options: [
                  for (final ms in const [100, 200, 300, 500, 750, 1000])
                    MochiSelectOption(value: ms, label: "${ms / 1000} s"),
                ],
              ),
            ),
            if (stackmatSupported)
              SettingsTile(
                title: l10n.timerStackmat,
                subtitle: l10n.timerStackmatHint,
                suffix: MochiSwitch(value: settings.stackmatEnabled, onChanged: dao.setStackmatEnabled),
              ),
          ],
        ),

        MochiTileGroup(
          label: Text(l10n.timerRecords),
          children: [
            SettingsTile(
              title: l10n.timerBestAlert,
              subtitle: l10n.timerBestAlertHint,
              suffix: MochiSwitch(value: settings.recordBestAlert, onChanged: dao.setRecordBestAlert),
            ),
            SettingsTile(
              title: l10n.timerWorstAlert,
              subtitle: l10n.timerWorstAlertHint,
              suffix: MochiSwitch(value: settings.recordWorstAlert, onChanged: dao.setRecordWorstAlert),
            ),
            SettingsTile(
              title: l10n.timerAverageAlert,
              subtitle: l10n.timerAverageAlertHint,
              suffix: MochiSwitch(value: settings.recordAverageAlert, onChanged: dao.setRecordAverageAlert),
            ),
          ],
        ),
      ],
    );
  }
}
