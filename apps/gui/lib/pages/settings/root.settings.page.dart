import "package:cupertino_ui/cupertino_ui.dart";
import "package:forui/forui.dart";
import "package:go_router/go_router.dart";

import "../settings.page.dart";

class RootSettingsPage extends StatelessWidget {
  const RootSettingsPage({super.key});

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
      ],
    );
  }
}
