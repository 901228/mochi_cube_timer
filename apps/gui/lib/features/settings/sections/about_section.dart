import "dart:async";

import "package:flutter/foundation.dart" show LicenseEntryWithLineBreaks, LicenseRegistry;
import "package:flutter/services.dart" show rootBundle;
import "package:mochi_ui/mochi_ui.dart";
import "package:package_info_plus/package_info_plus.dart";

import "../../../l10n/l10n.dart";
import "../settings_tile.dart";

/// Puts the licenses of what is bundled beyond Dart packages where [LicenseRegistry] can list them.
void registerLicenses() => LicenseRegistry.addLicense(() async* {
  yield LicenseEntryWithLineBreaks([
    "Twemoji flags (font)",
  ], await rootBundle.loadString("assets/fonts/TwemojiFlags/LICENSE.md"));
});

class AboutSettingsSections extends StatelessWidget {
  const AboutSettingsSections({super.key});

  /// Every package with its licenses' text, as the registry holds them.
  static Future<Map<String, String>> _licenses() async {
    final byPackage = <String, StringBuffer>{};
    await for (final entry in LicenseRegistry.licenses) {
      final text = entry.paragraphs.map((p) => "${"  " * p.indent}${p.text}").join("\n");
      for (final package in entry.packages) {
        (byPackage[package] ??= StringBuffer()).write("$text\n\n${"-" * 40}\n\n");
      }
    }
    return {
      for (final e in byPackage.entries.toList()..sort((a, b) => a.key.compareTo(b.key)))
        e.key: e.value.toString(),
    };
  }

  // Read once: collecting every package's text takes a second or two.
  static Future<Map<String, String>>? _cached;

  void _showLicenses(BuildContext context) {
    showMochiModal(
      context,
      title: Text(context.l10n.aboutLicenses),
      body: FutureBuilder(
        future: _cached ??= _licenses(),
        builder: (context, snapshot) => switch (snapshot.data) {
          null => const Padding(
            padding: EdgeInsets.all(32),
            child: Center(child: MochiCircularProgress()),
          ),
          final licenses => SingleChildScrollView(
            child: MochiTileGroup(
              children: [
                for (final MapEntry(:key, :value) in licenses.entries)
                  SettingsTile(
                    title: key,
                    onPress: () => showMochiModal(
                      context,
                      title: Text(key),
                      body: SingleChildScrollView(child: Text(value)),
                    ),
                  ),
              ],
            ),
          ),
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      spacing: groupSpacing,
      children: [
        MochiTileGroup(
          label: const Text("Mochi Cube Timer"),
          children: [
            SettingsTile(
              title: l10n.aboutVersion,
              suffix: FutureBuilder(
                future: PackageInfo.fromPlatform(),
                builder: (context, snapshot) => Text(switch (snapshot.data) {
                  final info? => "${info.version} (${info.buildNumber})",
                  null => "",
                }),
              ),
            ),
          ],
        ),
        MochiTileGroup(
          label: Text(l10n.aboutCredits),
          children: [
            SettingsTile(title: l10n.aboutFlagsCredit),
            SettingsTile(
              title: l10n.aboutLicenses,
              suffix: Icon(TablerIcons.chevronRight),
              onPress: () => _showLicenses(context),
            ),
          ],
        ),
      ],
    );
  }
}
