import "package:cube_timer/cube_timer.dart";
import "package:flutter/widgets.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:forui/forui.dart";
import "package:go_router/go_router.dart";

import "home/puzzle_selection_dialog.dart";
import "home/session_selection_dialog.dart";
import "home/sidebar.dart";

class PageFrame extends StatelessWidget {
  const PageFrame({super.key, required this.pages, required this.navigationShell});
  final List<({String name, IconData icon, String path})> pages;
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final dao = context.read<AppDatabase>().appStateDao;

    return FScaffold(
      header: Padding(
        padding: theme.headerStyles.nested.padding,
        child: FHeader.nested(
          style: .delta(
            decoration: .shapeDelta(
              color: theme.colors.background,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: theme.colors.border, width: 3),
                borderRadius: theme.style.borderRadius.md,
              ),
            ),
          ),
          titleAlignment: .center,
          title: FTappable(
            onPress: () => showFDialog(
              context: context,
              builder: (_, style, animation) => PuzzleSelectionDialog(style: style, animation: animation),
            ),
            child: StreamBuilder<({Puzzle puzzle, SessionEntry session})>(
              stream: dao.watch(),
              builder: (context, snapshot) {
                if (snapshot.error case final error?) {
                  FlutterError.reportError(
                    FlutterErrorDetails(
                      exception: error,
                      stack: snapshot.stackTrace,
                      library: "mochi cube timer",
                      context: ErrorDescription("watching the app state for the header title"),
                    ),
                  );
                  return Icon(FLucideIcons.triangleAlert, color: theme.colors.destructive);
                }

                final data = snapshot.data;
                if (data == null) return const FCircularProgress();

                return Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: .center,
                  children: [
                    Text(data.puzzle.displayName, style: theme.typography.display.md),
                    Text(
                      data.session.name,
                      style: theme.typography.display.sm.copyWith(color: theme.colors.mutedForeground),
                    ),
                  ],
                );
              },
            ),
          ),
          prefixes: [
            FHeaderAction(
              icon: const Icon(FLucideIcons.menu),
              onPress: () => showFSheet(context: context, side: .ltr, builder: (context) => HomeSidebar()),
            ),
          ],
          suffixes: [
            StreamBuilder<({Puzzle puzzle, SessionEntry session})>(
              stream: dao.watch(),
              builder: (context, snapshot) {
                if (snapshot.error case final error?) {
                  FlutterError.reportError(
                    FlutterErrorDetails(
                      exception: error,
                      stack: snapshot.stackTrace,
                      library: "mochi cube timer",
                      context: ErrorDescription("watching the app state for the header title"),
                    ),
                  );
                  return Icon(FLucideIcons.triangleAlert, color: theme.colors.destructive);
                }

                final data = snapshot.data;
                if (data == null) return const FCircularProgress();

                return FHeaderAction(
                  icon: const Icon(FLucideIcons.shapes),
                  onPress: () => showFDialog(
                    context: context,
                    builder: (_, style, animation) => SessionSelectionDialog(
                      style: style,
                      animation: animation,
                      currentSessionId: data.session.id,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      footer: FBottomNavigationBar(
        index: navigationShell.currentIndex,
        onChange: (value) {
          navigationShell.goBranch(value);
        },
        children: pages
            .map((data) => FBottomNavigationBarItem(label: Text(data.name), icon: Icon(data.icon)))
            .toList(),
      ),
      child: navigationShell,
    );
    // );
  }
}
