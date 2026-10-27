import "package:cube_timer/cube_timer.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:go_router/go_router.dart";
import "package:mochi_ui/mochi_ui.dart";

import "../features/algorithms/algorithm_data.dart";
import "../features/algorithms/algorithms_page.dart";
import "../features/home/animated_branch_container.dart";
import "../features/home/home_shell.dart";
import "../l10n/l10n.dart";
import "../shared/puzzles/puzzle_utils.dart";
import "../features/records/records_page.dart";
import "../features/settings/settings_page.dart";
import "../features/stats/stats_page.dart";
import "../features/timer/timer_focus.dart";
import "../features/timer/timer_page.dart";

String _algorithmsPath({required bool standalone}) => standalone ? "algorithms-standalone" : "algorithms";

GoRoute _algorithmSetRoute(String path, {required bool standalone}) => GoRoute(
  path: path,
  redirect: (_, state) {
    final puzzleId = state.pathParameters["puzzle"]!;
    final setId = state.pathParameters["set"]!;
    return algorithmSets.findSet(puzzleId, setId: setId) != null
        ? null
        : "/${_algorithmsPath(standalone: standalone)}/$puzzleId";
  },
  pageBuilder: (context, state) {
    final puzzleId = state.pathParameters["puzzle"]!;
    final setId = state.pathParameters["set"]!;
    return MochiPage(
      key: state.pageKey,
      child: AlgorithmSetPage(
        algorithmSet: algorithmSets.findSet(puzzleId, setId: setId)!,
        standalone: standalone,
      ),
    );
  },
);

GoRoute algorithmsRouter({required bool standalone}) {
  final path = _algorithmsPath(standalone: standalone);

  return GoRoute(
    path: "/$path",
    name: path,
    // Only the bare path: a parent's redirect also runs for its children, and would pull them back.
    redirect: (_, state) => state.uri.path == "/$path" ? "/$path/${Puzzle.cube3.id}" : null,
    routes: [
      GoRoute(
        path: ":puzzle",
        pageBuilder: (context, state) {
          final puzzleId = state.pathParameters["puzzle"]!;

          final page = algorithmSets.containsKey(puzzleId)
              ? AlgorithmsGroupPage(
                  standalone: standalone,
                  puzzleId: puzzleId,
                  groups: algorithmSets[puzzleId]!,
                )
              : Center(
                  child: Text(
                    context.l10n.algorithmsNoSets(
                      Puzzle.values.where((p) => p.id == puzzleId).firstOrNull?.displayName(context.l10n) ??
                          puzzleId,
                    ),
                    style: context.theme.typography.title.xl,
                  ),
                );

          // Standalone puzzles swap under the shell's header, which stays put.
          return standalone
              ? MochiPage(key: state.pageKey, transition: .fade, child: page)
              : NoTransitionPage(key: state.pageKey, child: page);
        },
        // Standalone sets are a top-level route instead, so they cover the header too.
        routes: [if (!standalone) _algorithmSetRoute(":set", standalone: false)],
      ),
    ],
  );
}

final router = GoRouter(
  initialLocation: "/",
  routes: [
    GoRoute(path: "/", redirect: (_, _) => "/timer"),

    // Before the shell below, which would otherwise match the set's path as far as the puzzle.
    _algorithmSetRoute("/algorithms-standalone/:puzzle/:set", standalone: true),
    ShellRoute(
      pageBuilder: (context, state, child) => MochiPage(
        key: state.pageKey,
        child: AlgorithmsStandaloneShell(child: child),
      ),
      routes: [algorithmsRouter(standalone: true)],
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
        builder: (context) {
          final isMobile = context.responsive(mobile: true, tablet: false);
          if (!isMobile) {
            return IndexedStack(index: navigationShell.currentIndex, children: children);
          }

          return AnimatedBranchContainer(
            currentIndex: navigationShell.currentIndex,
            // Once a solve is on, a swipe is the shell's no longer: the timer has the screen.
            draggable: !context.watch<TimerFocusCubit>().state,
            onChanged: (index) {
              navigationShell.goBranch(index);
            },
            children: children,
          );
        },
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
        StatefulShellBranch(routes: [algorithmsRouter(standalone: false)]),
      ],
    ),
  ],
);
