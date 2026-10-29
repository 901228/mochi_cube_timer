import "package:collection/collection.dart";
import "package:cube_timer/cube_timer.dart";
import "package:flutter/services.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:go_router/go_router.dart";
import "package:mochi_ui/mochi_ui.dart";

import "../../database/dao_provider.dart";
import "../../l10n/l10n.dart";
import "../../shared/puzzles/puzzle_utils.dart";
import "../../shared/utils.dart";
import "../home/puzzle_selection_dialog.dart";
import "algorithm_data/common.dart";

class _Header extends StatelessWidget {
  final String title;
  final bool isAllCollapsed;
  final VoidCallback onToggleAll;

  const _Header({required this.title, required this.isAllCollapsed, required this.onToggleAll});

  @override
  Widget build(BuildContext context) {
    return MochiHeader(
      variant: .bordered,
      title: Text(title),
      prefixes: [.back(onPress: () => context.pop())],
      suffixes: [algorithmsToggleAllAction(context, isAllCollapsed: isAllCollapsed, onPress: onToggleAll)],
    );
  }
}

/// The expand / collapse all button, for this page's headers and [HomeShell]'s.
MochiAction algorithmsToggleAllAction(
  BuildContext context, {
  required bool isAllCollapsed,
  required VoidCallback onPress,
}) => MochiAction(
  icon: isAllCollapsed ? TablerIcons.chevronsDown : TablerIcons.chevronsUp,
  label: isAllCollapsed ? context.l10n.algorithmsExpandAll : context.l10n.algorithmsCollapseAll,
  onPress: onPress,
);

/// What a page tells the header above it: its accordion, and the set it shows if it is one.
typedef AlgorithmsHeaderReport = ({bool isAllCollapsed, VoidCallback toggleAll, String? setName});

/// What the pages tell the header above them ([AlgorithmsStandaloneShell]'s or [HomeShell]'s), so it
/// can show the expand / collapse all button and the set. A page can sit under another, as a set
/// page does under its puzzle's, so the header shows the one reported last.
class AlgorithmsHeaderController extends ChangeNotifier {
  bool _disposed = false;
  final _reports = <Object, AlgorithmsHeaderReport>{};

  /// Empty while no page has anything to show.
  AlgorithmsHeaderReport? get current => _reports.values.lastOrNull;

  void report(Object owner, AlgorithmsHeaderReport report) {
    if (_disposed || _reports[owner] == report) return;
    _reports[owner] = report;
    notifyListeners();
  }

  void clear(Object owner) {
    if (!_disposed && _reports.remove(owner) != null) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}

class AlgorithmsHeaderScope extends InheritedWidget {
  const AlgorithmsHeaderScope({super.key, required this.controller, required super.child});

  final AlgorithmsHeaderController controller;

  /// Not a dependency: the page only reports to it.
  static AlgorithmsHeaderController? maybeOf(BuildContext context) =>
      context.getInheritedWidgetOfExactType<AlgorithmsHeaderScope>()?.controller;

  @override
  bool updateShouldNotify(AlgorithmsHeaderScope oldWidget) => controller != oldWidget.controller;
}

/// For a page to report to the [AlgorithmsHeaderController] above it, if there is one.
mixin _ReportsToHeader<T extends StatefulWidget> on State<T> {
  AlgorithmsHeaderController? _header;

  bool get _isAllCollapsed;
  void _toggleAll();
  String? get _setName => null;

  // After this frame, as the header cannot be rebuilt during one.
  void reportToHeader() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _header?.report(this, (isAllCollapsed: _isAllCollapsed, toggleAll: _toggleAll, setName: _setName));
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _header = AlgorithmsHeaderScope.maybeOf(context);
  }

  @override
  void dispose() {
    final header = _header;
    if (header != null) WidgetsBinding.instance.addPostFrameCallback((_) => header.clear(this));
    super.dispose();
  }
}

/// The standalone algorithms page's frame: a header that stays while the puzzle pages under it
/// change, the same way [HomeShell]'s does.
class AlgorithmsStandaloneShell extends StatefulWidget {
  const AlgorithmsStandaloneShell({super.key, required this.child});

  final Widget child;

  @override
  State<AlgorithmsStandaloneShell> createState() => _AlgorithmsStandaloneShellState();
}

class _AlgorithmsStandaloneShellState extends State<AlgorithmsStandaloneShell> {
  final _accordion = AlgorithmsHeaderController();

  @override
  void dispose() {
    _accordion.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Outside HomeShell, so no AppStateProvider above: watch the state here.
    return StreamBuilder(
      stream: context.read<AppDatabase>().appStateDao.watch(),
      builder: (context, snapshot) {
        final w = streamHandler(
          context,
          snapshot,
          description: "watching the app state for the standalone algorithms page",
        );
        if (w != null) return w;

        return ListenableBuilder(
          listenable: _accordion,
          builder: (context, _) => _build(context, snapshot.data!),
        );
      },
    );
  }

  Widget _build(BuildContext context, AppStateDaoReturn appState) {
    final report = _accordion.current;

    return MochiScaffold(
      // The pages pad themselves, as they do in the home shell.
      padding: .zero,
      header: MochiHeader(
        alignment: .center,
        variant: .bordered,
        prefixes: [.back(onPress: () => context.pop())],
        suffixes: [
          if (report != null)
            algorithmsToggleAllAction(
              context,
              isAllCollapsed: report.isAllCollapsed,
              onPress: report.toggleAll,
            ),
        ],
        title: MochiButton(
          appearance: .soft,
          scaleOnPress: false,
          onPress: () => showMochiModal(
            context,
            title: Text(context.l10n.homeSelectPuzzle),
            body: PuzzleSelectionDialog(
              showKinds: false,
              // `replace`, not `go`: this page was pushed over home, and `go` would drop home.
              onSelect: (puzzle) => context.replace("/algorithms-standalone/${puzzle.id}"),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: DefaultTextHeightBehavior(
              textHeightBehavior: const TextHeightBehavior(
                applyHeightToFirstAscent: false,
                applyHeightToLastDescent: false,
              ),
              child: DefaultTextStyle.merge(
                style: context.theme.typography.title.md,
                child: Text(appState.puzzle.displayName(context.l10n)),
              ),
            ),
          ),
        ),
      ),
      child: AlgorithmsHeaderScope(controller: _accordion, child: widget.child),
    );
  }
}

class AlgorithmsGroupPage extends StatefulWidget {
  final AlgorithmGroups groups;
  final String puzzleId;
  final bool standalone;

  const AlgorithmsGroupPage({
    super.key,
    required this.groups,
    required this.puzzleId,
    required this.standalone,
  });

  @override
  State<AlgorithmsGroupPage> createState() => _AlgorithmsGroupPageState();
}

class _AlgorithmsGroupPageState extends State<AlgorithmsGroupPage>
    with _ReportsToHeader<AlgorithmsGroupPage> {
  late Set<int> _accordionExpanded = widget.groups.mapIndexed((i, _) => i).toSet();
  @override
  bool get _isAllCollapsed => _accordionExpanded.isEmpty;

  void _expandAll() => _accordionExpanded = widget.groups.mapIndexed((i, _) => i).toSet();

  @override
  void _toggleAll() => setState(() => _isAllCollapsed ? _expandAll() : _accordionExpanded.clear());

  // The route reuses this State when only the puzzle changes, so the old indexes would point at
  // other groups.
  @override
  void didUpdateWidget(AlgorithmsGroupPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.puzzleId != widget.puzzleId) _expandAll();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final g = context.theme.geometry;

    // CFOP solves cross on D (white) and finishes the last layer on yellow (cubeColorD).
    final topColor = SettingsProvider.of(context).cubeColorD.toColor();

    reportToHeader();

    return Padding(
      padding: MediaQuery.paddingOf(context),
      child: SingleChildScrollView(
        padding: g.pagePadding,
        child: MochiAccordion(
          multiple: true,
          spacing: g.space.lg,
          contentSpacing: g.space.xs,
          expanded: .lifted(
            value: _accordionExpanded,
            onChanged: (value) {
              setState(() {
                _accordionExpanded = value;
              });
            },
          ),
          items: [
            for (final group in widget.groups)
              MochiAccordionItem(
                title: Text(group.name),
                child: MochiTileGroup(
                  children: [
                    for (final set in group.sets)
                      MochiTile(
                        prefix: SizedBox(
                          width: 44,
                          height: 44,
                          child: set.cases.first.buildDiagram(topColor: topColor),
                        ),
                        title: Text(set.name),
                        subtitle: Text(set.subtitle),
                        details: Text(l10n.algorithmsCasesCount(set.cases.length)),
                        suffix: const Icon(TablerIcons.chevronRight),
                        // Standalone: pushed over the shell (a top-level route); `go` would drop home.
                        onPress: () => widget.standalone
                            ? context.push("/algorithms-standalone/${widget.puzzleId}/${set.id}")
                            : context.go("/algorithms/${widget.puzzleId}/${set.id}"),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Card-grid page (`/algorithms/:puzzle/:set`) showing the cases of one [AlgorithmSet], grouped by
/// category. Each card shows only the diagram and the case name; tapping opens the detail modal.
class AlgorithmSetPage extends StatefulWidget {
  final bool standalone;
  const AlgorithmSetPage({super.key, required this.algorithmSet, this.standalone = true});

  final AlgorithmSet algorithmSet;

  @override
  State<AlgorithmSetPage> createState() => _AlgorithmSetPageState();
}

class _AlgorithmSetPageState extends State<AlgorithmSetPage> with _ReportsToHeader<AlgorithmSetPage> {
  late Set<int> _accordionExpanded = widget.algorithmSet.grouped.mapIndexed((i, _) => i).toSet();

  @override
  bool get _isAllCollapsed => _accordionExpanded.isEmpty;

  @override
  String? get _setName => widget.algorithmSet.name;

  @override
  void _toggleAll() => setState(() {
    _accordionExpanded = _isAllCollapsed ? widget.algorithmSet.grouped.mapIndexed((i, _) => i).toSet() : {};
  });

  @override
  Widget build(BuildContext context) {
    final g = context.theme.geometry;
    final topColor = SettingsProvider.of(context).cubeColorD.toColor();

    reportToHeader();

    final content = SingleChildScrollView(
      // Standalone, the header above is this page's own; otherwise it is the home shell's.
      padding: widget.standalone ? g.pagePadding.copyWith(top: 0) : g.pagePadding,
      child: MochiAccordion(
        multiple: true,
        spacing: g.space.lg,
        contentSpacing: g.space.xs,
        expanded: .lifted(
          value: _accordionExpanded,
          onChanged: (value) {
            setState(() {
              _accordionExpanded = value;
            });
          },
        ),
        items: [
          for (final (groupName, cases) in widget.algorithmSet.grouped)
            MochiAccordionItem(
              title: Text(groupName),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: .zero,
                itemCount: cases.length,
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 112,
                  mainAxisExtent: 120,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemBuilder: (context, index) {
                  final item = cases[index];
                  return _AlgorithmCaseCard(
                    item: item,
                    topColor: topColor,
                    onPress: () => showAlgorithmCaseDetailModal(
                      context,
                      algorithmSet: widget.algorithmSet,
                      item: item,
                      topColor: topColor,
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );

    if (widget.standalone) {
      return MochiScaffold(
        header: _Header(
          title: widget.algorithmSet.name,
          isAllCollapsed: _isAllCollapsed,
          onToggleAll: _toggleAll,
        ),
        child: content,
      );
    }

    // A solid fill: the scaffold's background is behind this page and the puzzle page under it, so
    // without one the page below shows through while this one slides in.
    return Container(
      color: context.colors.background,
      padding: MediaQuery.paddingOf(context),
      child: content,
    );
  }
}

class _AlgorithmCaseCard extends StatelessWidget {
  const _AlgorithmCaseCard({required this.item, required this.topColor, required this.onPress});

  final AlgorithmCase item;
  final Color topColor;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    return MochiCard(
      onPress: onPress,
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: .center,
        spacing: 8,
        children: [
          Expanded(
            child: Center(
              child: AspectRatio(aspectRatio: 1, child: item.buildDiagram(topColor: topColor)),
            ),
          ),
          Text(
            item.name,
            style: context.theme.typography.title.sm,
            maxLines: 1,
            overflow: .ellipsis,
            textAlign: .center,
          ),
        ],
      ),
    );
  }
}

/// Detail modal for one [AlgorithmCase], showing a larger diagram and all of its algorithms.
Future<void> showAlgorithmCaseDetailModal(
  BuildContext context, {
  required AlgorithmSet algorithmSet,
  required AlgorithmCase item,
  required Color topColor,
}) {
  return showMochiModal(
    context,
    title: Text(item.name),
    titleSuffix: Text(
      "${algorithmSet.name} · ${item.group}",
      style: context.theme.typography.body.sm.copyWith(color: context.colors.mutedForeground),
    ),
    body: Column(
      mainAxisSize: .min,
      crossAxisAlignment: .stretch,
      spacing: 20,
      children: [
        Center(
          child: SizedBox(width: 140, height: 140, child: item.buildDiagram(topColor: topColor)),
        ),
        if (item.description case final description?)
          Text(
            description,
            textAlign: .center,
            style: context.theme.typography.body.md.copyWith(color: context.colors.mutedForeground),
          ),
        MochiTileGroup(
          label: Text(context.l10n.algorithmsTitle),
          children: [
            for (var i = 0; i < item.algorithms.length; i++)
              MochiTile(
                title: Text(
                  item.algorithms[i],
                  style: context.theme.typography.body.md.copyWith(fontWeight: i == 0 ? .w600 : .w400),
                ),
                suffix: const Icon(TablerIcons.copy),
                onPress: () async {
                  await Clipboard.setData(ClipboardData(text: item.algorithms[i]));
                  if (context.mounted) {
                    showMochiToast(context, title: Text(context.l10n.algorithmsCopied));
                  }
                },
              ),
          ],
        ),
      ],
    ),
  );
}
