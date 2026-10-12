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
