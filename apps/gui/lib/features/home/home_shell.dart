import "dart:async";

import "package:collection/collection.dart";
import "package:cube_timer/cube_timer.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:go_router/go_router.dart";
import "package:mochi_ui/mochi_ui.dart";
import "package:stream_transform/stream_transform.dart";

import "../../app/orientation.dart";
import "../../database/dao_provider.dart";
import "../../l10n/l10n.dart";
import "../../shared/puzzles.dart";
import "../../shared/puzzles/puzzle_utils.dart";
import "../../shared/utils.dart";
import "../algorithms/algorithm_data.dart";
import "../algorithms/algorithm_data/common.dart";
import "../algorithms/algorithms_page.dart";
import "../algorithms/practice_cases_dialog.dart";
import "../algorithms/practice_scramble.dart";
import "../records/record_search_bar.dart";
import "../records/records_list.dart";
import "../timer/scramble_cubit.dart";
import "../timer/timer_focus.dart";
import "puzzle_selection_dialog.dart";
import "session_selection_dialog.dart";

class HomeShell extends StatefulWidget {
  const HomeShell({super.key, required this.pages, required this.navigationShell});
  final List<({String id, IconData icon, String path})> pages;
  final StatefulNavigationShell navigationShell;

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  late final _recordSelectionCubit = RecordSelectionCubit();
  late final _showArchivedCubit = ShowArchivedCubit();
  late final _timerFocusCubit = TimerFocusCubit();
  late final _searchBarBottomCubit = SearchBarBottomCubit();
  final _algorithmsHeader = AlgorithmsHeaderController();

  /// Where the algorithms branch was last seen, to tell whether it is still on the current puzzle.
  String? _algorithmsLocation;

  @override
  void didUpdateWidget(HomeShell oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.navigationShell.currentIndex != widget.navigationShell.currentIndex) {
      _recordSelectionCubit.clear();
    }
  }

  @override
  void dispose() {
    _recordSelectionCubit.close();
    _showArchivedCubit.close();
    _timerFocusCubit.close();
    _searchBarBottomCubit.close();
    _algorithmsHeader.dispose();
    super.dispose();
  }

  Widget _selectionHeader(
    BuildContext context,
    ({AppStateDaoReturn appState, List<SessionEntry> sessions})? data,
  ) => BlocBuilder<RecordSelectionCubit, Set<String>?>(
    buildWhen: (_, next) => next != null,
    builder: (context, state) {
      final recordsDao = context.read<AppDatabase>().recordsDao;
      final selection = context.read<RecordSelectionCubit>();

      return Container(
        // Down to the search bar's bottom plus a few px, so the edge does not line up with it.
        height: switch (context.watch<SearchBarBottomCubit>().state) {
          final bottom? => bottom + 8,
          null => null,
        },
        // Under the status bar, which the overlay has to clear by itself with `extendBody`.
        padding: EdgeInsets.all(g.space.xs).copyWith(top: MediaQuery.paddingOf(context).top + g.space.xs),
        child: MochiCard(
          appearance: .elevated,
          elevation: .lg,
          padding: .zero,
          intent: .info,
          selected: true,
          child: DefaultTextHeightBehavior(
            textHeightBehavior: TextHeightBehavior(
              applyHeightToFirstAscent: false,
              applyHeightToLastDescent: false,
            ),
            // A plain header adds the status bar's room to its own top; the card already clears it.
            child: MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: MochiHeader(
                variant: .plain,
                title: Text("${state!.length} selected"),
                actionSize: .md,
                prefixes: [
                  MochiAction(
                    icon: TablerIcons.x,
                    label: context.l10n.commonCancel,
                    onPress: selection.clear,
                  ),
                ],
                suffixFoldFrom: .start,
                suffixes: [
                  MochiAction.menu(
                    icon: TablerIcons.gavel,
                    label: context.l10n.commonPenalty,
                    children: [
                      for (final penalty in Penalty.values)
                        MochiAction(
                          icon: penalty.icon,
                          label: penalty.displayName(context.l10n),
                          onPress: () async {
                            final answer = await showMochiConfirm(
                              context,
                              title: context.l10n.homeSetPenaltyAll(penalty.displayName(context.l10n)),
                            );
                            if (answer) {
                              await recordsDao.setPenaltyAll(state, penalty);
                              if (context.mounted) {
                                selection.clear();
                              }
                            }
                          },
                        ),
                    ],
                  ),
                  MochiAction.menu(
                    icon: TablerIcons.arrowsRightLeft,
                    label: context.l10n.commonMoveTo,
                    children: (data?.sessions ?? <SessionEntry>[])
                        .map(
                          (e) => MochiAction(
                            icon: TablerIcons.stack,
                            label: e.name,
                            selected: e.id == data?.appState.session.id,
                            onPress: () async {
                              if (e.id == data?.appState.session.id) return;

                              final answer = await showMochiConfirm(
                                context,
                                title: context.l10n.homeMoveAll(e.name),
                              );
                              if (answer) {
                                await recordsDao.setSessionAll(state, e.id);
                                await recordsDao.setArchivedAll(state, false);
                                if (context.mounted) {
                                  selection.clear();
                                }
                              }
                            },
                          ),
                        )
                        .toList(),
                  ),
                  if (!context.watch<ShowArchivedCubit>().state)
                    MochiAction(
                      icon: TablerIcons.arrowDownToArc,
                      label: context.l10n.commonArchive,
                      onPress: () async {
                        final answer = await showMochiConfirm(
                          context,
                          title: context.l10n.recordsArchiveAllTitle,
                          message: context.l10n.recordsArchiveAllMessage,
                          confirmLabel: context.l10n.commonArchive,
                        );
                        if (answer) {
                          await recordsDao.setArchivedAll(state, true);
                          if (context.mounted) {
                            selection.clear();
                          }
                        }
                      },
                    ),
                  MochiAction(
                    icon: TablerIcons.trash,
                    label: context.l10n.commonDelete,
                    intent: .danger,
                    onPress: () async {
                      final answer = await showMochiConfirm(
                        context,
                        title: context.l10n.recordsDeleteAllTitle,
                        message: context.l10n.recordsDeleteAllMessage,
                        confirmLabel: context.l10n.commonDelete,
                        destructive: true,
                      );
                      if (answer) {
                        await recordsDao.deleteAll(state);
                        if (context.mounted) {
                          selection.clear();
                        }
                      }
                    },
                  ),
                  MochiAction(
                    icon: selection.isAllSelected ? TablerIcons.deselect : TablerIcons.selectAll,
                    label: selection.isAllSelected
                        ? context.l10n.homeDeselectAll
                        : context.l10n.homeSelectAll,
                    enabled: data != null,
                    onPress: selection.toggleSelectAll,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );

  MochiGeometry get g => context.theme.geometry;

  /// From another page the algorithms come back to where they were left, set and all, unless that was on
  /// another puzzle; on them, or from another puzzle's, they go to the top of [puzzle].
  void _openAlgorithms(BuildContext context, Puzzle puzzle) {
    final leftOn = _algorithmsLocation == null ? null : Uri.parse(_algorithmsLocation!).pathSegments;
    final onThisPuzzle = leftOn != null && leftOn.length > 1 && leftOn[1] == puzzle.id;
    if (widget.navigationShell.currentIndex != 3 && onThisPuzzle) {
      widget.navigationShell.goBranch(3);
    } else {
      context.go("/algorithms/${puzzle.id}");
    }
  }

  /// The pages, the algorithms and the settings, beside the content or, given [close], in the drawer it
  /// shuts before going anywhere. The algorithms open on [puzzle], which is not known until the app
  /// state has arrived.
  Widget _sidebar(BuildContext context, {required Puzzle? puzzle, VoidCallback? close}) {
    VoidCallback then(VoidCallback go) => () {
      close?.call();
      go();
    };

    return MochiSidebar(
      size: .lg,
      footer: [
        MochiSidebarItem(
          label: Text(context.l10n.commonSettings),
          icon: Icon(TablerIcons.settings),
          onPress: then(() => context.pushNamed("settings")),
        ),
      ],
      header: MochiSidebarHeading(Text("Mochi Cube Timer")),
      children: [
        ...widget.pages.mapIndexed(
          (i, data) => MochiSidebarItem(
            icon: Icon(data.icon),
            label: Text(_pageLabel(context, data.id)),
            onPress: then(() => widget.navigationShell.goBranch(i)),
            selected: widget.navigationShell.currentIndex == i,
          ),
        ),

        MochiDivider(gap: g.space.xs2, indent: g.space.xs),

        MochiSidebarItem(
          icon: Icon(TablerIcons.cubeSpark),
          label: Text(context.l10n.algorithmsTitle),
          selected: widget.navigationShell.currentIndex == 3,
          onPress: puzzle == null ? null : then(() => _openAlgorithms(context, puzzle)),
        ),
        MochiSidebarItem(
          icon: Icon(TablerIcons.barbell),
          label: Text(context.l10n.trainersTitle),
          selected: widget.navigationShell.currentIndex == 4,
          // From another page the branch comes back to where it was left; on it, the item goes to its top.
          onPress: then(
            () => widget.navigationShell.currentIndex == 4
                ? context.go("/trainers")
                : widget.navigationShell.goBranch(4),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.navigationShell.currentIndex == 3) {
      _algorithmsLocation = widget.navigationShell.shellRouteContext.routerState.uri.path;
    }
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _recordSelectionCubit),
        BlocProvider.value(value: _showArchivedCubit),
        BlocProvider.value(value: _timerFocusCubit),
        BlocProvider.value(value: _searchBarBottomCubit),
      ],
      child: StreamBuilder(
        stream: context.read<AppDatabase>().appStateDao.watch().combineLatest(
          context.read<AppDatabase>().sessionsDao.watchAll(),
          (appState, sessions) => (appState: appState, sessions: sessions),
        ),
        builder: (context, snapshot) {
          final w = streamHandler(
            context,
            snapshot,
            description: "watching the app state and sessions for the home shell",
            showCircularProgress: false,
          );
          if (w != null) return w;

          final data = snapshot.data;
          final sideways = isSideways(context);
          return ListenableBuilder(
            listenable: _algorithmsHeader,
            builder: (context, _) {
              final algorithms = widget.navigationShell.currentIndex == 3 ? _algorithmsHeader.current : null;
              final practice = data?.appState.algorithmSet == null
                  ? null
                  : algorithmSets.findSet(data!.appState.puzzle.id, setId: data.appState.algorithmSet);
              final puzzleName = data == null
                  ? ""
                  : [
                      data.appState.puzzle.displayName(context.l10n),
                      ?practice?.name,
                      if (data.appState.algorithmSet == crossDrillId) context.l10n.practiceCrossName,
                    ].join(" · ");
              return MochiScaffold(
                extendBody: true,
                immersive: context.watch<TimerFocusCubit>().state,
                padding: .zero,
                // The trainers draw their own, as there is no puzzle or session to pick for them.
                header: widget.navigationShell.currentIndex == 4
                    ? null
                    : MochiHeader(
                        alignment: .center,
                        variant: .bordered,
                        prefixes: [if (algorithms?.setName != null) .back(onPress: () => context.pop())],
                        title: _titleWithSet(
                          context,
                          algorithms?.setName,
                          MochiButton(
                            appearance: .soft,
                            scaleOnPress: false,
                            onPress: () => showMochiModal(
                              context,
                              title: Text(context.l10n.homeSelectPuzzle),
                              body: PuzzleSelectionDialog(
                                current: data?.appState.puzzle,
                                currentSet: data?.appState.algorithmSet,
                                // TODO: enable algorithm list, them click the algorithm and go to the corresponding page
                                showKinds: widget.navigationShell.currentIndex != 3,
                                onSelect: (puzzle) {
                                  if (widget.navigationShell.currentIndex == 3) {
                                    context.go("/algorithms/${puzzle.id}");
                                  }
                                },
                              ),
                            ),
                            child: data == null
                                ? const Center(child: MochiCircularProgress())
                                : Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 2),
                                    child: DefaultTextHeightBehavior(
                                      textHeightBehavior: const TextHeightBehavior(
                                        applyHeightToFirstAscent: false,
                                        applyHeightToLastDescent: false,
                                      ),
                                      child: algorithms == null
                                          ? Column(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment: .center,
                                              spacing: 2,
                                              children: [
                                                DefaultTextStyle.merge(
                                                  style: context.theme.typography.title.md,
                                                  child: Text(puzzleName),
                                                ),
                                                DefaultTextStyle.merge(
                                                  style: context.theme.typography.title.sm.copyWith(
                                                    color: context.colors.mutedForeground,
                                                  ),
                                                  child: Text(data.appState.session.name),
                                                ),
                                              ],
                                            )
                                          : DefaultTextStyle.merge(
                                              style: context.theme.typography.title.md,
                                              child: Text(data.appState.puzzle.displayName(context.l10n)),
                                            ),
                                    ),
                                  ),
                          ),
                        ),
                        suffixes: [
                          if (algorithms != null)
                            algorithmsToggleAllAction(
                              context,
                              isAllCollapsed: algorithms.isAllCollapsed,
                              onPress: algorithms.toggleAll,
                            ),
                          if (widget.navigationShell.currentIndex != 3 &&
                              widget.pages.length > widget.navigationShell.currentIndex &&
                              widget.pages[widget.navigationShell.currentIndex].id != "timer")
                            MochiAction(
                              icon: context.watch<ShowArchivedCubit>().state
                                  ? TablerIcons.archiveFilled
                                  : TablerIcons.archive,
                              selected: context.watch<ShowArchivedCubit>().state,
                              label: context.l10n.homeShowArchived,
                              onPress: context.read<ShowArchivedCubit>().toggle,
                            ),
                          if (widget.navigationShell.currentIndex != 3 &&
                              practice != null &&
                              widget.pages.length > widget.navigationShell.currentIndex &&
                              widget.pages[widget.navigationShell.currentIndex].id == "timer")
                            MochiAction(
                              icon: TablerIcons.listCheck,
                              label: context.l10n.practiceCasesTitle,
                              onPress: () => showPracticeCasesDialog(
                                context,
                                puzzle: data!.appState.puzzle,
                                set: practice,
                              ),
                            ),
                          if (widget.navigationShell.currentIndex != 3)
                            MochiAction(
                              icon: TablerIcons.stack2,
                              label: context.l10n.homeSessions,
                              onPress: data == null
                                  ? null
                                  : () => showSessionSelectionDialog(
                                      context,
                                      sessionId: data.appState.session.id,
                                    ),
                            ),
                        ],
                      ),
                headerOverlay: context.watch<RecordSelectionCubit>().active
                    ? _selectionHeader(context, data)
                    : null,
                footer: sideways
                    ? null
                    : MochiBottomNav<int>(
                        value: widget.navigationShell.currentIndex,
                        onChanged: (value) => widget.navigationShell.goBranch(value),
                        items: widget.pages
                            .mapIndexed(
                              (i, data) => MochiBottomNavItem<int>(
                                value: i,
                                label: Text(_pageLabel(context, data.id)),
                                icon: Icon(data.icon),
                              ),
                            )
                            .toList(),
                      ),
                safeArea: true,
                // A phone on its side has no room for the bar along the bottom or a sidebar beside the timer:
                // the menu button pulls out what the sidebar holds instead.
                sidebar: sideways ? null : _sidebar(context, puzzle: data?.appState.puzzle),
                // Under the scaffold, for MochiScaffold.of: the drawer is not a route to pop.
                drawer: Builder(
                  builder: (context) => sideways
                      ? _sidebar(
                          context,
                          puzzle: data?.appState.puzzle,
                          close: MochiScaffold.of(context).closeDrawer,
                        )
                      : MochiSidebar(
                          size: .lg,
                          footer: [
                            MochiSidebarItem(
                              label: Text(context.l10n.commonSettings),
                              icon: Icon(TablerIcons.settings),
                              onPress: () {
                                MochiScaffold.of(context).closeDrawer();
                                context.pushNamed("settings");
                              },
                            ),
                          ],
                          header: MochiSidebarHeading(Text("Mochi Cube Timer")),
                          children: [
                            MochiSidebarItem(
                              icon: Icon(TablerIcons.clockHour4),
                              label: Text("Timer"),
                              selected: true,
                              onPress: MochiScaffold.of(context).closeDrawer,
                            ),

                            MochiDivider(gap: g.space.xs2, indent: g.space.xs),

                            MochiSidebarItem(
                              icon: Icon(TablerIcons.cubeSpark),
                              label: Text(context.l10n.algorithmsTitle),
                              onPress: data == null
                                  ? null
                                  : () {
                                      MochiScaffold.of(context).closeDrawer();
                                      context.push("/algorithms-standalone/${data.appState.puzzle.id}");
                                    },
                            ),
                            MochiSidebarItem(
                              icon: Icon(TablerIcons.barbell),
                              label: Text(context.l10n.trainersTitle),
                              onPress: () {
                                MochiScaffold.of(context).closeDrawer();
                                context.push("/trainers-standalone");
                              },
                            ),
                          ],
                        ),
                ),
                child: data == null
                    ? const Center(child: MochiCircularProgress())
                    : AppStateProvider(
                        state: data.appState,
                        child: SessionsProvider(
                          state: data.sessions,
                          child: AlgorithmsHeaderScope(
                            controller: _algorithmsHeader,
                            child: _ScrambleScope(
                              puzzle: data.appState.puzzle,
                              practice: practice,
                              child: widget.navigationShell,
                            ),
                          ),
                        ),
                      ),
              );
            },
          );
        },
      ),
    );
  }
}

/// The puzzle button, and after it the set the algorithms page is on, if it is on one.
Widget _titleWithSet(BuildContext context, String? setName, Widget button) {
  if (setName == null) return button;
  return Row(
    mainAxisSize: .min,
    children: [
      Flexible(child: button),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Text(
          "/",
          style: context.theme.typography.title.md.copyWith(color: context.colors.mutedForeground),
        ),
      ),
      Flexible(
        child: Text(setName, style: context.theme.typography.title.md, overflow: .ellipsis),
      ),
    ],
  );
}

String _pageLabel(BuildContext context, String id) => switch (id) {
  "timer" => context.l10n.navTimer,
  "records" => context.l10n.navRecords,
  _ => context.l10n.navStats,
};

/// Provides the [ScrambleCubit], following the puzzle without rebuilding the pages under it.
class _ScrambleScope extends StatefulWidget {
  const _ScrambleScope({required this.puzzle, required this.practice, required this.child});
  final Puzzle puzzle;

  /// The algorithm set being practised, whose scrambles come from the cases picked for it.
  final AlgorithmSet? practice;
  final Widget child;

  @override
  State<_ScrambleScope> createState() => _ScrambleScopeState();
}

class _ScrambleScopeState extends State<_ScrambleScope> {
  late final _cubit = ScrambleCubit(widget.puzzle);
  StreamSubscription<Set<String>>? _excluded;

  @override
  void initState() {
    super.initState();
    _follow();
  }

  @override
  void didUpdateWidget(_ScrambleScope old) {
    super.didUpdateWidget(old);
    if (old.puzzle != widget.puzzle || old.practice?.id != widget.practice?.id) _follow();
  }

  /// Follows the puzzle, and for a practice the cases picked for it too.
  void _follow() {
    _excluded?.cancel();
    _excluded = null;
    final practice = widget.practice;
    _cubit.usePuzzle(widget.puzzle, practice: practice);
    if (practice == null) return;
    _excluded = context
        .read<AppDatabase>()
        .appStateDao
        .watchExcluded(widget.puzzle, practice.id)
        .listen((excluded) => _cubit.usePuzzle(widget.puzzle, practice: practice, excluded: excluded));
  }

  @override
  void dispose() {
    _excluded?.cancel();
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => BlocProvider.value(value: _cubit, child: widget.child);
}
