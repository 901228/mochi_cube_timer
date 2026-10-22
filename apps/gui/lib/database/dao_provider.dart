import "package:cube_timer/cube_timer.dart";
import "package:flutter/widgets.dart";

class AppStateProvider extends InheritedWidget {
  final AppStateDaoReturn state;
  const AppStateProvider({super.key, required this.state, required super.child}) : super();

  static AppStateDaoReturn of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppStateProvider>()!.state;
  }

  @override
  bool updateShouldNotify(AppStateProvider oldWidget) => state != oldWidget.state;
}

class SessionsProvider extends InheritedWidget {
  final List<SessionEntry> state;
  const SessionsProvider({super.key, required this.state, required super.child}) : super();

  static List<SessionEntry> of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<SessionsProvider>()!.state;
  }

  @override
  bool updateShouldNotify(SessionsProvider oldWidget) => state != oldWidget.state;
}

/// The settings, for everything under [SettingsScope].
class SettingsProvider extends InheritedWidget {
  final SettingsEntry state;
  const SettingsProvider({super.key, required this.state, required super.child}) : super();

  /// The settings now, and the caller is rebuilt when they change.
  static SettingsEntry of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<SettingsProvider>()!.state;
  }

  @override
  bool updateShouldNotify(SettingsProvider oldWidget) => state != oldWidget.state;
}

/// Follows the settings in [stream] and gives them to [child] through [SettingsProvider].
///
/// Held above the app itself, so what the app is built from (its theme and language) and every
/// screen, sheet and dialog under it read one copy instead of each watching the database. Until the
/// first settings arrive it shows nothing, which the splash cover hides.
class SettingsScope extends StatelessWidget {
  const SettingsScope({super.key, required this.stream, required this.child});

  final Stream<SettingsEntry> stream;
  final Widget child;

  @override
  Widget build(BuildContext context) => StreamBuilder(
    stream: stream,
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        Error.throwWithStackTrace(snapshot.error!, snapshot.stackTrace ?? StackTrace.empty);
      }
      final settings = snapshot.data;
      return settings == null ? const SizedBox.shrink() : SettingsProvider(state: settings, child: child);
    },
  );
}
