import "package:cube_timer/cube_timer.dart";
import "package:go_router/go_router.dart";
import "package:mochi_ui/mochi_ui.dart";

import "../../../l10n/l10n.dart";
import "../settings_tile.dart";

class RootSettingsSections extends StatelessWidget {
  final SettingsEntry settings;
  final SettingsDao dao;
  const RootSettingsSections({super.key, required this.settings, required this.dao});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: groupSpacing,
      children: [
        MochiTileGroup(
          label: Text(context.l10n.settingsTimer),
          children: [
            SettingsTile(
              title: context.l10n.settingsInspection,
              icon: Icon(TablerIcons.stopwatch),
              suffix: Icon(TablerIcons.chevronRight),
              onPress: () => context.push("/settings/inspection"),
            ),
            SettingsTile(
              title: context.l10n.settingsTimerBehavior,
              icon: Icon(TablerIcons.clockHour4),
              suffix: Icon(TablerIcons.chevronRight),
              onPress: () => context.push("/settings/timer"),
            ),
            SettingsTile(
              title: context.l10n.settingsTimerAppearance,
              icon: Icon(TablerIcons.clockRecord),
              suffix: Icon(TablerIcons.chevronRight),
              onPress: () => context.push("/settings/timerAppearance"),
            ),
            SettingsTile(
              title: context.l10n.settingsPuzzle,
              icon: Icon(TablerIcons.cube),
              suffix: Icon(TablerIcons.chevronRight),
              onPress: () => context.push("/settings/puzzle"),
            ),
          ],
        ),
        MochiTileGroup(
          label: Text(context.l10n.settingsOther),
          children: [
            SettingsTile(
              title: context.l10n.settingsGeneral,
              icon: Icon(TablerIcons.settings),
              suffix: Icon(TablerIcons.chevronRight),
              onPress: () => context.push("/settings/general"),
            ),
            SettingsTile(
              title: context.l10n.settingsStats,
              icon: Icon(TablerIcons.chartLine),
              suffix: Icon(TablerIcons.chevronRight),
              onPress: () => context.push("/settings/stats"),
            ),
            SettingsTile(
              title: context.l10n.settingsAbout,
              icon: Icon(TablerIcons.infoCircle),
              suffix: Icon(TablerIcons.chevronRight),
              onPress: () => context.push("/settings/about"),
            ),
          ],
        ),
      ],
    );
  }
}
