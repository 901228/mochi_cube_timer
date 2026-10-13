import "dart:async";

import "package:flutter/widgets.dart";
import "package:flutter_native_splash/flutter_native_splash.dart";

/// The native splash screen, drawn again over [child] until [ready] completes, and then
/// stepped out of the way: the icon grows a little as the whole of it fades.
///
/// It looks exactly as the native one does (the `flutter_native_splash` section of the
/// pubspec), so taking over from it shows no seam. Sits above the app, where there is no theme
/// yet: its colours, and the motion's, are the theme's written out.
class SplashCover extends StatefulWidget {
  const SplashCover({super.key, required this.ready, required this.child});

  /// What the app needs before its first screen is worth showing. An error lets the cover go
  /// too, so the app can say what went wrong.
  final Future<void> ready;
  final Widget child;

  @override
  State<SplashCover> createState() => _SplashCoverState();
}

class _SplashCoverState extends State<SplashCover> with SingleTickerProviderStateMixin {
  static const _latteBase = Color(0xFFEFF1F5);
  static const _mochaBase = Color(0xFF1E1E2E);

  /// As large as the native splash draws it: a 256 px image at 1x.
  static const _iconSize = 256.0;

  // A still start comes first, inside the animation: the app behind builds its first screen and
  // compiles its shaders in those frames, and dropped ones there would make the icon jump.
  static const _hold = 150;
  static const _move = 500;
  static const _start = _hold / (_hold + _move);

  late final _out = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: _hold + _move),
  );
  late final _grow = CurvedAnimation(
    parent: _out,
    curve: const Interval(_start, 1, curve: Curves.easeInOutCubic),
  );
  // Held at full until the icon has visibly grown: faded on the same curve, it was mostly gone
  // before it had grown at all.
  late final _fade = CurvedAnimation(
    parent: _out,
    curve: const Interval(_start + (1 - _start) * 0.35, 1, curve: Curves.easeIn),
  );
  bool _started = false;
  bool _gone = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;

    // Decoded before the native splash goes, or the first frame would be the colour alone.
    final icon = precacheImage(_icon, context, onError: (_, _) {});
    unawaited(Future.wait([widget.ready, icon]).catchError((_) => const <void>[]).whenComplete(_leave));
  }

  void _leave() {
    if (!mounted) return;
    FlutterNativeSplash.remove();
    final dispatcher = View.of(context).platformDispatcher;
    if (dispatcher.accessibilityFeatures.disableAnimations) {
      setState(() => _gone = true);
      return;
    }
    // From the frame that first shows the cover, so none of the fade is spent while the native
    // splash is still up.
    WidgetsBinding.instance.endOfFrame.then((_) {
      if (!mounted) return;
      _out.forward().whenComplete(() {
        if (mounted) setState(() => _gone = true);
      });
    });
  }

  bool get _dark => View.of(context).platformDispatcher.platformBrightness == Brightness.dark;

  AssetImage get _icon => AssetImage(_dark ? "assets/icon/icon_dark.png" : "assets/icon/icon.png");

  @override
  void dispose() {
    _grow.dispose();
    _fade.dispose();
    _out.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_gone) return widget.child;

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Stack(
        fit: StackFit.expand,
        children: [
          widget.child,
          // Takes the presses meant for the app until it has faded.
          AbsorbPointer(
            child: FadeTransition(
              opacity: ReverseAnimation(_fade),
              child: ColoredBox(
                color: _dark ? _mochaBase : _latteBase,
                child: Center(
                  child: ScaleTransition(
                    scale: Tween(begin: 1.0, end: 1.3).animate(_grow),
                    child: Image(image: _icon, width: _iconSize, height: _iconSize),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
