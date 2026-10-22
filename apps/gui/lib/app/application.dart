import "package:mochi_ui/mochi_ui.dart";

import "../database/dao_provider.dart";
import "../l10n/l10n.dart";
import "../theme/typography_timer.dart";
import "router.dart";

class Application extends StatelessWidget {
  const new({super.key});

  MochiTheme _customTheme(MochiTheme base, Brightness brightness, int? primary) => base.copyWith(
    colors: primary == null ? null : MochiColors.branded(brightness: brightness, primary: Color(primary)),
    extensions: [TimerTypography.standard],
    defaults: MochiDefaults(transition: .slide),
  );

  @override
  Widget build(BuildContext context) {
    final settings = SettingsProvider.of(context);

    return MochiApp.router(
      title: "Mochi Cube Timer",
      routerConfig: router,
      locale: switch (settings.locale) {
        final code? when !systemPicksLanguage => Locale(code),
        _ => null,
      },
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      themeMode: MochiThemeMode.values.byName(settings.themeMode.name),
      lightTheme: _customTheme(MochiTheme.light, .light, settings.primaryColor),
      darkTheme: _customTheme(MochiTheme.dark, .dark, settings.primaryColor),
    );
  }
}
