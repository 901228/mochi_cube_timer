import "package:collection/collection.dart";
import "package:cube_timer/cube_timer.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:go_router/go_router.dart";
import "package:mochi_ui/mochi_ui.dart";
import "package:stream_transform/stream_transform.dart";

import "../../database/dao_provider.dart";
import "../../shared/puzzles.dart";
import "../../shared/utils.dart";
import "../records/records_list.dart";
import "../timer/scramble_cubit.dart";
import "puzzle_selection_dialog.dart";
import "session_selection_dialog.dart";

class HomeShell extends StatelessWidget {
  const HomeShell({super.key, required this.pages, required this.navigationShell});
  final List<({String name, IconData icon, String path})> pages;
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
        height: 130,
        padding: EdgeInsets.all(context.theme.geometry.space.xs),
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
            child: MochiHeader(
              variant: .plain,
              title: Text("${state!.length} selected"),
              actionSize: .md,
              prefixes: [MochiAction(icon: TablerIcons.x, label: "Cancel", onPress: selection.clear)],
              suffixFoldFrom: .start,
              suffixes: [
                MochiAction.menu(
                  icon: TablerIcons.gavel,
                  label: "Penalty",
                  children: [
                    for (final penalty in Penalty.values)
                      MochiAction(
                        icon: penalty.icon,
                        label: penalty.displayName,
                        onPress: () async {
                          final answer = await showMochiConfirm(
                            context,
                            title: "Set all records Penalty to ${penalty.displayName}?",
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
                  label: "Move To",
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
                              title: "Move all records to ${e.name}?",
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
                    label: "Archive",
                    onPress: () async {
                      final answer = await showMochiConfirm(
                        context,
                        title: "Archive all records?",
                        message: "All solves will be archived.",
                        confirmLabel: "Archive",
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
                  label: "Delete",
                  intent: .danger,
                  onPress: () async {
                    debugPrint("FAQ");
                    final answer = await showMochiConfirm(
                      context,
                      title: "Delete all records?",
                      message: "All solves will be permanently deleted.",
                      confirmLabel: "Delete",
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
                  label: selection.isAllSelected ? "Deselect all" : "Select all",
                  enabled: data != null,
                  onPress: selection.toggleSelectAll,
                ),
              ],
            ),
          ),
        ),
      );
    },
  );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RecordSelectionCubit(),
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
          return MochiScaffold(
            extendBody: true,
            padding: .zero,
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
                        child: DefaultTextHeightBehavior(
                          textHeightBehavior: const TextHeightBehavior(
                            applyHeightToFirstAscent: false,
                            applyHeightToLastDescent: false,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: .center,
                            children: [
                              DefaultTextStyle.merge(
                                style: context.theme.typography.title.md,
                                child: Text(data.appState.puzzle.displayName),
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
                if (pages[navigationShell.currentIndex].name.toLowerCase() != "timer")
                  MochiAction(
                    icon: (data?.appState.showArchived ?? false)
                        ? TablerIcons.archiveFilled
                        : TablerIcons.archive,
                    enabled: data != null,
                    selected: data?.appState.showArchived ?? false,
                    label: "Show archived records",
                    onPress: data == null
                        ? null
                        : () => context.read<AppDatabase>().appStateDao.setShowArchived(
                            !data.appState.showArchived,
                          ),
                  ),
                MochiAction(
                  icon: TablerIcons.stack2,
                  label: "Sessions",
                  onPress: data == null
                      ? null
                      : () => showSessionSelectionDialog(context, sessionId: data.appState.session.id),
                ),
              ],
            ),
            headerOverlay: context.watch<RecordSelectionCubit>().active
                ? _selectionHeader(context, data)
                : null,
            footer: MochiBottomNav<int>(
              value: navigationShell.currentIndex,
              onChanged: (value) {
                navigationShell.goBranch(value);
                context.read<RecordSelectionCubit>().clear();
              },
              items: pages
                  .mapIndexed(
                    (i, data) =>
                        MochiBottomNavItem<int>(value: i, label: Text(data.name), icon: Icon(data.icon)),
                  )
                  .toList(),
            ),
            safeArea: true,
            sidebar: MochiSidebar(
              footer: [
                MochiSidebarItem(
                  label: const Text("Settings"),
                  icon: Icon(TablerIcons.settings),
                  onPress: () {
                    context.pushNamed("settings");
                  },
                ),
              ],
              header: MochiSidebarHeading(Text("Mochi Cube Timer")),
              children: pages
                  .mapIndexed(
                    (i, data) => MochiSidebarItem(
                      icon: Icon(data.icon),
                      label: Text(data.name),
                      onPress: () => navigationShell.goBranch(i),
                      selected: navigationShell.currentIndex == i,
                    ),
                  )
                  .toList(),
            ),
            // Under the scaffold, for MochiScaffold.of: the drawer is not a route to pop.
            drawer: Builder(
              builder: (context) => MochiSidebar(
                children: [
                  MochiSidebarHeading(Text("Mochi Cube Timer")),
                  MochiSidebarItem(
                    label: const Text("Settings"),
                    icon: Icon(TablerIcons.settings),
                    onPress: () {
                      MochiScaffold.of(context).closeDrawer();
                      context.pushNamed("settings");
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
