import "package:cube_timer/cube_timer.dart";
import "package:flutter/foundation.dart" show kIsWeb;
import "package:mochi_ui/mochi_ui.dart";

import "../../../l10n/l10n.dart";
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

        // A Stackmat is an audio input, which the web has no way to listen to.
        if (!kIsWeb)
          MochiTileGroup(
            label: Text(l10n.timerInput),
            children: [
              SettingsTile(
                title: l10n.timerStackmat,
                subtitle: l10n.timerStackmatHint,
                suffix: MochiSwitch(value: settings.stackmatEnabled, onChanged: dao.setStackmatEnabled),
              ),
            ],
          ),
      ],
    );
  }
}
