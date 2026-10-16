import "package:cube_timer/cube_timer.dart";
import "package:mochi_ui/mochi_ui.dart";

import "../settings_tile.dart";

class GeneralSettingsSections extends StatelessWidget {
  final SettingsEntry settings;
  final SettingsDao dao;
  const GeneralSettingsSections({super.key, required this.settings, required this.dao});

  // Catppuccin Latte's accents, the family the kit's own blue is from.
  static const _primaryPresets = [
    Color(0xFF1E66F5), // blue
    Color(0xFF8839EF), // mauve
    Color(0xFFEA76CB), // pink
    Color(0xFFD20F39), // red
    Color(0xFFFE640B), // peach
    Color(0xFFDF8E1D), // yellow
    Color(0xFF40A02B), // green
    Color(0xFF179299), // teal
  ];

  @override
  Widget build(BuildContext context) {
    // Each theme has its own blue, so "default" is the one on screen, and choosing it stores nothing.
    final themePrimary =
        (context.colors.brightness == .dark ? MochiColors.dark : MochiColors.light).primary.base;

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
          label: const Text("Appearance"),
          children: [
            SettingsTile(
              title: "Theme",
              icon: Icon(TablerIcons.sunMoon),
              suffix: MochiSegmentedControl<AppThemeMode>(
                expanded: false,
                size: .sm,
                value: settings.themeMode,
                onChanged: dao.setThemeMode,
                children: const [
                  MochiSegment(value: .system, label: Text("System")),
                  MochiSegment(value: .light, label: Text("Light")),
                  MochiSegment(value: .dark, label: Text("Dark")),
                ],
              ),
            ),
            ColorTile(
              title: "Primary color",
              color: context.colors.primary.base,
              defaultColor: themePrimary,
              presets: _primaryPresets,
              onSubmit: (c) => dao.setPrimaryColor(c == themePrimary ? null : c.toARGB32()),
            ),
          ],
        ),
      ],
    );
  }
}
