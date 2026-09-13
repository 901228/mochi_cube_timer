import "package:cupertino_ui/cupertino_ui.dart";
import "package:forui/forui.dart";

import "../theme.dart";
import "router.dart";

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
