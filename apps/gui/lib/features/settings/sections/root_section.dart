import "package:cube_timer/cube_timer.dart";
import "package:go_router/go_router.dart";
import "package:mochi_ui/mochi_ui.dart";

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
          ("General", TablerIcons.settings, "general"),
          ("Timer", TablerIcons.clockHour4, "timer"),
          ("Puzzle", TablerIcons.cube, "puzzle"),
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
