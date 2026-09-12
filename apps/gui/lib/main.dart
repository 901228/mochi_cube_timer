import "dart:async";

import "package:cube_timer/cube_timer.dart";
import "package:cupertino_ui/cupertino_ui.dart";
import "package:flutter/foundation.dart" show kIsWeb;
import "package:flutter/services.dart" show BrowserContextMenu, rootBundle;
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

  // A long press opens the browser's own context menu, which cancels Flutter's long press gesture.
  if (kIsWeb) unawaited(BrowserContextMenu.disableContextMenu());

  // The scramblers build their tables on the first scramble of a puzzle, which
  // on the web is a second or more with the only thread blocked and no frames
  // going out. We ship them built instead; awaiting an asset leaves the frame
  // free, and a file we do not have falls back to building as before.
  useTableBytesLoader((name) async {
    try {
      final data = await rootBundle.load("assets/tables/$name");
      return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    } on FlutterError {
      return null;
    }
  });

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
