import "package:cube_timer/cube_timer.dart";
import "package:flutter/widgets.dart";

class AppStateProvider extends InheritedWidget {
  final AppStateDaoReturn state;
  const AppStateProvider({super.key, required this.state, required super.child}) : super();

  static AppStateDaoReturn of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppStateProvider>()!.state;
  }

  @override
  bool updateShouldNotify(AppStateProvider oldWidget) => true;
}
