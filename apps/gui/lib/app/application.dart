import "package:cube_timer/cube_timer.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:mochi_ui/mochi_ui.dart";

import "../l10n/l10n.dart";
import "../theme/typography_timer.dart";
import "router.dart";

class Application extends StatelessWidget {
  const new({super.key});

  // The kit's faces with the flags last: no system font can be counted on to draw them (Linux and
  // Windows ones often draw "TW"), and a font tried before the system's is the only way to be sure.
  // Built once, as MochiTheme compares by identity.
  static final _typography = MochiTypography(
    title: MochiTypeface(fontFamily: "Comfortaa", fontFamilyFallback: _fallback, weight: FontWeight.w700),
    body: MochiTypeface(fontFamily: "Comfortaa", fontFamilyFallback: _fallback),
  );
  static const _fallback = ["FakePearl", "TwemojiFlags"];

  MochiTheme _customTheme(MochiTheme base, Brightness brightness, int? primary) => base.copyWith(
    colors: primary == null ? null : MochiColors.branded(brightness: brightness, primary: Color(primary)),
    typography: _typography,
    extensions: [TimerTypography.standard],
    defaults: MochiDefaults(transition: .slide),
  );

  @override
  Widget build(BuildContext context) => StreamBuilder(
    stream: context.read<AppDatabase>().settingsDao.watch(),
    builder: (context, snapshot) {
      // Until the settings are read, the system's theme in the kit's own colours.
      final settings = snapshot.data;
      final primary = settings?.primaryColor;

      return MochiApp.router(
        title: "Mochi Cube Timer",
        routerConfig: router,
        locale: switch (settings?.locale) {
          final code? => Locale(code),
          null => null,
        },
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        themeMode: MochiThemeMode.values.byName((settings?.themeMode ?? AppThemeMode.system).name),
        lightTheme: _customTheme(MochiTheme.light, .light, primary),
        darkTheme: _customTheme(MochiTheme.dark, .dark, primary),
      );
    },
  );
}
