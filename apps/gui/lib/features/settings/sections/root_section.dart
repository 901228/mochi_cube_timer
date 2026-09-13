import "package:cube_timer/cube_timer.dart";
import "package:flutter/widgets.dart";
import "package:forui/forui.dart";
import "package:go_router/go_router.dart";

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
        FTileGroup(
          label: const Text("Locale"),
          children: [
            SettingsTile(
              title: "Locale",
              icon: Icon(FLucideIcons.languages),
              suffix: Icon(FLucideIcons.flag), // TODO: get locale icon
            ),
          ],
        ),

        FTileGroup(
          label: const Text("Timer"),
          children: [
            SettingsTile(
              title: "Inspection",
              icon: Icon(FLucideIcons.timer),
              suffix: Icon(FLucideIcons.chevronRight),
              onPress: () => context.push("/settings/inspection"),
            ),
          ],
        ),

        FTileGroup(
          label: const Text("Appearance"),
          children: [
            SettingsTile(
              title: "Cube colors",
              icon: Icon(FLucideIcons.paintRoller),
              suffix: Icon(FLucideIcons.chevronRight),
              onPress: () => context.push("/settings/cube-colors"),
            ),
          ],
        ),
      ],
    );
  }
}
