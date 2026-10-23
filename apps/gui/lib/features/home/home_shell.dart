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
import "../records/record_search_bar.dart";
import "../records/records_list.dart";
import "../timer/scramble_cubit.dart";
import "../timer/timer_focus.dart";
import "puzzle_selection_dialog.dart";
import "session_selection_dialog.dart";

class HomeShell extends StatelessWidget {
  const HomeShell({super.key, required this.pages, required this.navigationShell});
  final List<({String id, IconData icon, String path})> pages;
  final StatefulNavigationShell navigationShell;

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
        padding: EdgeInsets.all(context.theme.geometry.space.xs)
            .copyWith(top: MediaQuery.paddingOf(context).top + context.theme.geometry.space.xs),
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
                  if (!(data?.appState.showArchived ?? false))
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

  /// The pages, the algorithms and the settings, beside the content or, given [close], in the drawer it
  /// shuts before going anywhere.
  Widget _sidebar(BuildContext context, {VoidCallback? close}) {
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
        ...pages.mapIndexed(
          (i, data) => MochiSidebarItem(
            icon: Icon(data.icon),
            label: Text(_pageLabel(context, data.id)),
            onPress: then(() => navigationShell.goBranch(i)),
            selected: navigationShell.currentIndex == i,
          ),
        ),

        MochiDivider(),
        MochiSidebarItem(
          icon: Icon(TablerIcons.cubeSpark),
          label: Text("Algorithms"),
          onPress: then(() {
            // TODO: algorithms page
            // context.pushNamed("algorithms");
          }),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => RecordSelectionCubit()),
        BlocProvider(create: (context) => TimerFocusCubit()),
        BlocProvider(create: (context) => SearchBarBottomCubit()),
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
          final sideways =
              isPhone(MediaQuery.sizeOf(context)) && MediaQuery.orientationOf(context) == .landscape;
          return MochiScaffold(
            extendBody: true,
            immersive: context.watch<TimerFocusCubit>().state,
            padding: .zero,
            header: MochiHeader(
              alignment: .center,
              variant: .bordered,
              title: MochiButton(
                appearance: .soft,
                scaleOnPress: false,
                onPress: () => showMochiModal(
                  context,
                  title: Text(context.l10n.homeSelectPuzzle),
                  body: PuzzleSelectionDialog(),
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
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: .center,
                            spacing: 2,
                            children: [
                              DefaultTextStyle.merge(
                                style: context.theme.typography.title.md,
                                child: Text(data.appState.puzzle.displayName(context.l10n)),
                              ),
                              DefaultTextStyle.merge(
                                style: context.theme.typography.title.sm.copyWith(
                                  color: context.colors.mutedForeground,
                                ),
                                child: Text(data.appState.session.name),
                              ),
                            ],
                          ),
                        ),
                      ),
              ),
              suffixes: [
                if (pages[navigationShell.currentIndex].id != "timer")
                  MochiAction(
                    icon: (data?.appState.showArchived ?? false)
                        ? TablerIcons.archiveFilled
                        : TablerIcons.archive,
                    enabled: data != null,
                    selected: data?.appState.showArchived ?? false,
                    label: context.l10n.homeShowArchived,
                    onPress: data == null
                        ? null
                        : () => context.read<AppDatabase>().appStateDao.setShowArchived(
                            !data.appState.showArchived,
                          ),
                  ),
                MochiAction(
                  icon: TablerIcons.stack2,
                  label: context.l10n.homeSessions,
                  onPress: data == null
                      ? null
                      : () => showSessionSelectionDialog(context, sessionId: data.appState.session.id),
                ),
              ],
            ),
            headerOverlay: context.watch<RecordSelectionCubit>().active
                ? _selectionHeader(context, data)
                : null,
            footer: sideways
                ? null
                : MochiBottomNav<int>(
                    value: navigationShell.currentIndex,
                    onChanged: (value) {
                      navigationShell.goBranch(value);
                      context.read<RecordSelectionCubit>().clear();
                    },
                    items: pages
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
            sidebar: sideways ? null : _sidebar(context),
            // Under the scaffold, for MochiScaffold.of: the drawer is not a route to pop.
            drawer: Builder(
              builder: (context) => sideways
                  ? _sidebar(context, close: MochiScaffold.of(context).closeDrawer)
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
                        MochiSidebarItem(
                          icon: Icon(TablerIcons.cubeSpark),
                          label: Text("Algorithms"),
                          onPress: () {
                            MochiScaffold.of(context).closeDrawer();
                            // TODO: algorithms page
                            // context.pushNamed("algorithms");
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
                      child: _ScrambleScope(puzzle: data.appState.puzzle, child: navigationShell),
                    ),
                  ),
          );
        },
      ),
    );
    // );
  }
}

String _pageLabel(BuildContext context, String id) => switch (id) {
  "timer" => context.l10n.navTimer,
  "records" => context.l10n.navRecords,
  _ => context.l10n.navStats,
};

/// Provides the [ScrambleCubit], following the puzzle without rebuilding the pages under it.
class _ScrambleScope extends StatefulWidget {
  const _ScrambleScope({required this.puzzle, required this.child});
  final Puzzle puzzle;
  final Widget child;

  @override
  State<_ScrambleScope> createState() => _ScrambleScopeState();
}

class _ScrambleScopeState extends State<_ScrambleScope> {
  late final _cubit = ScrambleCubit(widget.puzzle);

  @override
  void didUpdateWidget(_ScrambleScope old) {
    super.didUpdateWidget(old);
    _cubit.usePuzzle(widget.puzzle);
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => BlocProvider.value(value: _cubit, child: widget.child);
}
