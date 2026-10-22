import "package:cube_timer/cube_timer.dart";
import "package:mochi_ui/mochi_ui.dart";

import "../../../l10n/l10n.dart";
import "../settings_tile.dart";

class StatsSettingsSections extends StatelessWidget {
  final SettingsEntry settings;
  final SettingsDao dao;
  const StatsSettingsSections({super.key, required this.settings, required this.dao});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      spacing: groupSpacing,
      children: [
        // TODO: session stats, max dnf attempts
      ],
    );
  }
}
