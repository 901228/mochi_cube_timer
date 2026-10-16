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
        for (final (title, icon, section) in [
          (context.l10n.settingsGeneral, TablerIcons.settings, "general"),
          (context.l10n.settingsTimer, TablerIcons.clockHour4, "timer"),
          (context.l10n.settingsPuzzle, TablerIcons.cube, "puzzle"),
          (context.l10n.settingsAbout, TablerIcons.infoCircle, "about"),
        ])
          MochiTileGroup(
            label: Text(title),
            children: [
              SettingsTile(
                title: title,
                icon: Icon(icon),
                suffix: Icon(TablerIcons.chevronRight),
                onPress: () => context.push("/settings/$section"),
              ),
            ],
          ),
      ],
    );
  }
}
