import "package:cube_timer/cube_timer.dart";
import "package:mochi_ui/mochi_ui.dart";

import "../../../l10n/l10n.dart";
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

  static const _system = "system";

  /// A language's name with its flag, in its own words, as it is on the list.
  static String _named(Locale locale) {
    final l10n = lookupAppLocalizations(locale);
    return "${l10n.languageFlag} ${l10n.languageName}";
  }

  Future<void> _chooseLocale(BuildContext context) async {
    final l10n = context.l10n;
    final answer = await showMochiChoice<String>(
      context,
      title: l10n.generalLocale,
      selected: settings.locale ?? _system,
      choices: [
        MochiChoice(value: _system, label: l10n.localeSystem),
        for (final locale in AppLocalizations.supportedLocales)
          MochiChoice(value: locale.languageCode, label: _named(locale)),
      ],
    );
    if (answer != null) await dao.setLocale(answer == _system ? null : answer);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    // Each theme has its own blue, so "default" is the one on screen, and choosing it stores nothing.
    final themePrimary =
        (context.colors.brightness == .dark ? MochiColors.dark : MochiColors.light).primary.base;
    // The language in use, which on "System" is the one the system's turned out to be.
    final current = Localizations.localeOf(context);

    return Column(
      spacing: groupSpacing,
      children: [
        MochiTileGroup(
          label: Text(l10n.generalLocale),
          children: [
            SettingsTile(
              title: l10n.generalLocale,
              suffix: Text(
                settings.locale == null ? "${l10n.localeSystem} · ${l10n.languageFlag}" : _named(current),
              ),
              onPress: () => _chooseLocale(context),
            ),
          ],
        ),
        MochiTileGroup(
          label: Text(l10n.generalAppearance),
          children: [
            SettingsTile(
              title: l10n.generalTheme,
              suffix: MochiSegmentedControl<AppThemeMode>(
                expanded: false,
                size: .sm,
                value: settings.themeMode,
                onChanged: dao.setThemeMode,
                children: [
                  MochiSegment(value: .system, label: Text(l10n.themeSystem)),
                  MochiSegment(value: .light, label: Text(l10n.themeLight)),
                  MochiSegment(value: .dark, label: Text(l10n.themeDark)),
                ],
              ),
            ),
            ColorTile(
              title: l10n.generalPrimaryColor,
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
