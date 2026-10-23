import "dart:async";

import "package:flutter/foundation.dart" show TargetPlatform, defaultTargetPlatform, kIsWeb, listEquals;
import "package:flutter/services.dart" show DeviceOrientation, SystemChrome;
import "package:flutter/widgets.dart" show BuildContext, MediaQuery, Orientation, Size;
import "package:go_router/go_router.dart";

/// Whether a screen of [size] (logical pixels) is a phone's: one that only the timer may turn on its side.
/// A small desktop window is not one, however it is shaped.
bool isPhone(Size size) =>
    !kIsWeb &&
    const {TargetPlatform.android, TargetPlatform.iOS}.contains(defaultTargetPlatform) &&
    size.shortestSide < 600;

/// The orientations a phone may take on [path]. The timer can lie on its side; every other page was laid
/// out upright only.
List<DeviceOrientation> orientationsFor(String path) => path == "/timer"
    ? const [DeviceOrientation.portraitUp, DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]
    : const [DeviceOrientation.portraitUp];

/// Keeps a phone to the orientations of the page on top of [router], a pushed one included: opening the
/// settings from a timer on its side turns the phone upright again.
void followOrientations(GoRouter router) {
  List<DeviceOrientation>? current;
  void sync() {
    if (router.routerDelegate.currentConfiguration.isEmpty) return;
    final next = orientationsFor(router.state.uri.path);
    if (listEquals(next, current)) return;
    current = next;
    unawaited(SystemChrome.setPreferredOrientations(next));
  }

  router.routerDelegate.addListener(sync);
  sync();
}

/// Whether this is a phone lying on its side, which has no room for the bars it has upright.
bool isSideways(BuildContext context) =>
    isPhone(MediaQuery.sizeOf(context)) && MediaQuery.orientationOf(context) == Orientation.landscape;
