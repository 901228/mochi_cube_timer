import "dart:async";
import "dart:ui" show PlatformDispatcher;

import "package:cube_timer/cube_timer.dart";
import "package:flutter/foundation.dart" show kIsWeb;
import "package:flutter/services.dart" show BrowserContextMenu, DeviceOrientation, SystemChrome, rootBundle;
import "package:flutter/widgets.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_native_splash/flutter_native_splash.dart";
import "package:flutter_web_plugins/url_strategy.dart";
import "package:go_router/go_router.dart";

import "app/application.dart";
import "app/splash_cover.dart";
import "database/connection.dart";
import "database/dao_provider.dart";

void main() {
  // web url
  usePathUrlStrategy();
  GoRouter.optionURLReflectsImperativeAPIs = true;

  // Kept up until SplashCover, drawn the same, takes over from it.
  FlutterNativeSplash.preserve(widgetsBinding: WidgetsFlutterBinding.ensureInitialized());

  // shortcut: a phone is held upright only, as the pages are laid out for that and the timer, records
  // and stats were never looked at wide; adapt them to landscape, then drop this and let it turn.
  final view = PlatformDispatcher.instance.views.first;
  if (!kIsWeb && view.physicalSize.shortestSide / view.devicePixelRatio < 600) {
    unawaited(SystemChrome.setPreferredOrientations(const [DeviceOrientation.portraitUp]));
  }

  // A long press opens the browser's own context menu, which cancels Flutter's long press gesture.
  if (kIsWeb) unawaited(BrowserContextMenu.disableContextMenu());

  // The scramblers build their tables on the first scramble of a puzzle, which
  // blocks the only thread for up to a second or more with no frames going out,
  // worst on the web. We ship them built on every platform instead; awaiting an
  // asset leaves the frame free, and a file we do not have, or one with the wrong
  // version, falls back to building as before.
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

  runApp(
    RepositoryProvider.value(
      value: db,
      child: SplashCover(
        ready: Future.wait([db.appStateDao.watch().first, db.settingsDao.watch().first]),
        child: SettingsScope(stream: db.settingsDao.watch(), child: const Application()),
      ),
    ),
  );
}
