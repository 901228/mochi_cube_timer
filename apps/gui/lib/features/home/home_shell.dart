import "package:collection/collection.dart";
import "package:cube_timer/cube_timer.dart";
import "package:flutter/widgets.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:go_router/go_router.dart";
import "package:mochi_ui/mochi_ui.dart";

import "../../database/dao_provider.dart";
import "home_sidebar.dart";
import "puzzle_selection_dialog.dart";
import "session_selection_dialog.dart";

class HomeShell extends StatelessWidget {
  const HomeShell({super.key, required this.pages, required this.navigationShell});
  final List<({String name, IconData icon, String path})> pages;
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final dao = context.read<AppDatabase>().appStateDao;

    return StreamBuilder(
      stream: dao.watch(),
      builder: (context, snapshot) {
        // A failed stream is not a slow one; without this branch it arrives as a
        // spinner that never stops.
        if (snapshot.error case final error?) {
          FlutterError.reportError(
            FlutterErrorDetails(
              exception: error,
              stack: snapshot.stackTrace,
              library: "mochi cube timer",
              context: ErrorDescription("watching the app state for the home shell"),
            ),
          );
          return Center(child: Icon(TablerIcons.alertTriangle, color: context.theme.colors.danger.base));
        }

        final data = snapshot.data;
        return MochiScaffold(
          header: MochiHeader(
            alignment: .center,
            variant: .bordered,
            title: MochiButton(
              appearance: .soft,
              scaleOnPress: false,
              onPress: () => showMochiModal(
                context,
                title: const Text("Select a puzzle"),
                body: PuzzleSelectionDialog(),
              ),
              child: data == null
                  ? const Center(child: MochiCircularProgress())
                  : Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: .center,
                        children: [
                          DefaultTextStyle.merge(
                            textHeightBehavior: const TextHeightBehavior(
                              applyHeightToFirstAscent: false,
                              applyHeightToLastDescent: false,
                            ),
                            style: context.theme.typography.title.md,
                            child: Text(data.puzzle.displayName),
                          ),
                          DefaultTextStyle.merge(
                            textHeightBehavior: const TextHeightBehavior(
                              applyHeightToFirstAscent: false,
                              applyHeightToLastDescent: false,
                            ),
                            style: context.theme.typography.title.sm.copyWith(
                              color: context.colors.mutedForeground,
                            ),
                            child: Text(data.session.name),
                          ),
                        ],
                      ),
                    ),
            ),
            prefixes: [
              MochiAction(
                icon: TablerIcons.menu2,
                label: "Menu",
                onPress: () {
                  showMochiSheet(context, side: .left, builder: (context) => HomeSidebar());
                },
              ),
            ],
            suffixes: [
              if (pages[navigationShell.currentIndex].name.toLowerCase() != "timer")
                MochiAction(
                  icon: (data?.showArchived ?? false) ? TablerIcons.archiveFilled : TablerIcons.archive,
                  enabled: data != null,
                  selected: data?.showArchived ?? false,
                  label: "Show archived records",
                  onPress: data == null
                      ? null
                      : () {
                          dao.setShowArchived(!data.showArchived);
                        },
                ),
              MochiAction(
                icon: TablerIcons.stack2,
                label: "Sessions",
                onPress: data == null
                    ? null
                    : () {
                        showSessionSelectionDialog(context, sessionId: data.session.id);
                      },
              ),
            ],
          ),
          footer: MochiBottomNav<int>(
            value: navigationShell.currentIndex,
            onChanged: (value) {
              navigationShell.goBranch(value);
            },
            items: pages
                .mapIndexed(
                  (i, data) =>
                      MochiBottomNavItem<int>(value: i, label: Text(data.name), icon: Icon(data.icon)),
                )
                .toList(),
          ),
          child: data == null
              ? const Center(child: MochiCircularProgress())
              : AppStateProvider(state: data, child: navigationShell),
        );
      },
    );
    // );
  }
}
