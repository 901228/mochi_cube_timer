import "package:flutter_bloc/flutter_bloc.dart";
import "package:go_router/go_router.dart";
import "package:mochi_ui/mochi_ui.dart";

import "../features/algorithms/algorithm_data.dart";
import "../features/algorithms/algorithms_page.dart";
import "../features/home/animated_branch_container.dart";
import "../features/home/home_shell.dart";
import "../features/records/records_list.dart";
import "../features/records/records_page.dart";
import "../features/settings/settings_page.dart";
import "../features/stats/stats_page.dart";
import "../features/timer/timer_focus.dart";
import "../features/timer/timer_page.dart";

final router = GoRouter(
  initialLocation: "/",
  routes: [
    GoRoute(path: "/", redirect: (_, _) => "/timer"),

    GoRoute(
      path: "/algorithms",
      name: "algorithms",
      pageBuilder: (context, state) => MochiPage(key: state.pageKey, child: const AlgorithmsOverviewPage()),
      routes: [
        GoRoute(
          path: ":puzzle",
          pageBuilder: (context, state) => MochiPage(
            key: state.pageKey,
            child: AlgorithmsOverviewPage(puzzleId: state.pathParameters["puzzle"]),
          ),
          routes: [
            GoRoute(
              path: ":set",
              redirect: (_, state) {
                final puzzleId = state.pathParameters["puzzle"]!;
                final setId = state.pathParameters["set"]!;
                return findAlgorithmSet(puzzleId, setId) != null ? null : "/algorithms";
              },
              pageBuilder: (context, state) {
                final puzzleId = state.pathParameters["puzzle"]!;
                final setId = state.pathParameters["set"]!;
                return MochiPage(
                  key: state.pageKey,
                  child: AlgorithmSetPage(algorithmSet: findAlgorithmSet(puzzleId, setId)!),
                );
              },
            ),
          ],
        ),
      ],
    ),

    GoRoute(
      path: "/settings",
      name: "settings",
      pageBuilder: (context, state) => MochiPage(
        key: state.pageKey,
        child: const SettingsPage(section: "root"),
      ),
      routes: [
        GoRoute(
          path: ":section",
          redirect: (_, state) =>
              settingsSections.containsKey(state.pathParameters["section"]) ? null : "/settings",
          pageBuilder: (context, state) => MochiPage(
            key: state.pageKey,
            child: SettingsPage(section: state.pathParameters["section"]!),
          ),
        ),
      ],
    ),
    StatefulShellRoute(
      pageBuilder: (context, state, navigationShell) => MochiPage(
        key: state.pageKey,
        child: HomeShell(
          pages: [
            (id: "timer", icon: TablerIcons.clockHour4, path: "/timer"),
            (id: "records", icon: TablerIcons.library, path: "/records"),
            (id: "stats", icon: TablerIcons.chartLine, path: "/stats"),
          ],
          navigationShell: navigationShell,
        ),
      ),
      navigatorContainerBuilder: (context, navigationShell, children) => Builder(
        builder: (context) => AnimatedBranchContainer(
          currentIndex: navigationShell.currentIndex,
          // Once a solve is on, a swipe is the shell's no longer: the timer has the screen.
          draggable: !context.watch<TimerFocusCubit>().state,
          onChanged: (index) {
            // As the bottom bar does: a selection is of the page it was made on.
            context.read<RecordSelectionCubit>().clear();
            navigationShell.goBranch(index);
          },
          children: children,
        ),
      ),

      branches: [
        StatefulShellBranch(
          routes: [GoRoute(path: "/timer", name: "timer", builder: (context, state) => TimerPage())],
        ),
        StatefulShellBranch(
          routes: [GoRoute(path: "/records", name: "records", builder: (context, state) => RecordsPage())],
        ),
        StatefulShellBranch(
          routes: [GoRoute(path: "/stats", name: "stats", builder: (context, state) => StatsPage())],
        ),
      ],
    ),
  ],
);
