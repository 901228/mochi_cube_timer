import "package:cube_timer/cube_timer.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:mochi_ui/mochi_ui.dart";

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
