import "package:cube_timer/cube_timer.dart";
import "package:cupertino_ui/cupertino_ui.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_web_plugins/url_strategy.dart";
import "package:forui/forui.dart";
import "package:go_router/go_router.dart";

import "database/connection.dart";
import "router.dart";
import "theme.dart";

void main() {
  // web url
  usePathUrlStrategy();
  GoRouter.optionURLReflectsImperativeAPIs = true;

  WidgetsFlutterBinding.ensureInitialized();

  // database
  final db = AppDatabase(openConnection());

  runApp(RepositoryProvider.value(value: db, child: const Application()));
}

class Application extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) => CupertinoApp.router(
    debugShowCheckedModeBanner: false,
    // TODO: replace with your application's supported locales.
    supportedLocales: FLocalizations.supportedLocales,
    // TODO: add your application's localizations delegates.
    localizationsDelegates: const [...FLocalizations.localizationsDelegates],
    builder: (context, child) => FTheme(
      data: CupertinoTheme.brightnessOf(context) == Brightness.dark ? darkTheme : lightTheme,
      child: FToaster(child: FTooltipGroup(child: child!)),
    ),
    routerConfig: router,
  );
}
