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
        MochiTileGroup(
          label: const Text("Locale"),
          children: [
            SettingsTile(
              title: "Locale",
              icon: Icon(TablerIcons.language),
              suffix: Icon(TablerIcons.flag), // TODO: get locale icon
            ),
          ],
        ),

        MochiTileGroup(
          label: const Text("Timer"),
          children: [
            SettingsTile(
              title: "Inspection",
              icon: Icon(TablerIcons.clockHour4),
              suffix: Icon(TablerIcons.chevronRight),
              onPress: () => context.push("/settings/inspection"),
            ),
          ],
        ),

        MochiTileGroup(
          label: const Text("Appearance"),
          children: [
            SettingsTile(
              title: "Cube colors",
              icon: Icon(TablerIcons.paint),
              suffix: Icon(TablerIcons.chevronRight),
              onPress: () => context.push("/settings/cube-colors"),
            ),
          ],
        ),
      ],
    );
  }
}
