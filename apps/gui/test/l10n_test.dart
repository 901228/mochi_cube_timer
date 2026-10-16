import "package:flutter/widgets.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mochi_cube_timer_gui/l10n/l10n.dart";

void main() {
  test("every language has a name and a flag of its own, for the list of languages", () {
    final names = <String>{};
    for (final locale in AppLocalizations.supportedLocales) {
      final l10n = lookupAppLocalizations(locale);
      expect(l10n.languageName, isNotEmpty, reason: "$locale");
      expect(l10n.languageFlag, isNotEmpty, reason: "$locale");
      names.add(l10n.languageName);
    }
    expect(names.length, AppLocalizations.supportedLocales.length);
  });

  test("English and Chinese are the languages there are", () {
    expect(AppLocalizations.supportedLocales, [const Locale("en"), const Locale("zh")]);
    expect(lookupAppLocalizations(const Locale("zh")).settingsGeneral, "一般");
  });
}
