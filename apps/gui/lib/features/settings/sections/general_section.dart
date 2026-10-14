import "package:cube_timer/cube_timer.dart";
import "package:mochi_ui/mochi_ui.dart";

import "../settings_tile.dart";

class GeneralSettingsSections extends StatelessWidget {
  final SettingsEntry settings;
  final SettingsDao dao;
  const GeneralSettingsSections({super.key, required this.settings, required this.dao});

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
        // TODO: app theme
      ],
    );
  }
}
