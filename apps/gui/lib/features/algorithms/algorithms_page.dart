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
  final String? title;
  final bool canPop;
  final bool isAllCollapsed;
  final bool isBordered;
  final VoidCallback? onCollapsedAll;
  final VoidCallback? onExpandedAll;

  const _Header({
    this.title,
    this.canPop = false,
    required this.isAllCollapsed,
    this.isBordered = false,
    this.onCollapsedAll,
    this.onExpandedAll,
  });

  @override
  Widget build(BuildContext context) {
    return MochiHeader(
      variant: isBordered ? .bordered : .plain,
      title: title != null ? Text(title!) : Container(),
      prefixes: [if (canPop) .back(onPress: () => context.pop())],
      suffixes: [
        MochiAction(
          icon: isAllCollapsed ? TablerIcons.chevronsDown : TablerIcons.chevronsUp,
          label: isAllCollapsed ? context.l10n.algorithmsExpandAll : context.l10n.algorithmsCollapseAll,
          onPress: () {
            if (isAllCollapsed) {
              onExpandedAll?.call();
            } else {
              onCollapsedAll?.call();
            }
          },
        ),
      ],
    );
  }
}

/// What the page under [AlgorithmsStandaloneShell] tells the shell's header about its accordion,
/// so the header can show the expand / collapse all button. Empty while no page has one.
class _AccordionController extends ChangeNotifier {
  bool _disposed = false;
  bool isAllCollapsed = false;
  VoidCallback? toggleAll;

  void update({required bool isAllCollapsed, required VoidCallback? toggleAll}) {
    if (_disposed || (this.isAllCollapsed == isAllCollapsed && this.toggleAll == toggleAll)) return;
    this.isAllCollapsed = isAllCollapsed;
    this.toggleAll = toggleAll;
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}

class _AccordionScope extends InheritedWidget {
  const _AccordionScope({required this.controller, required super.child});

  final _AccordionController controller;

  /// Not a dependency: the page only reports to it.
  static _AccordionController? maybeOf(BuildContext context) =>
      context.getInheritedWidgetOfExactType<_AccordionScope>()?.controller;

  @override
  bool updateShouldNotify(_AccordionScope oldWidget) => controller != oldWidget.controller;
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
  final _accordion = _AccordionController();

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
    final toggleAll = _accordion.toggleAll;

    return MochiScaffold(
      // The pages pad themselves, as they do in the home shell.
      padding: .zero,
      header: MochiHeader(
        alignment: .center,
        variant: .bordered,
        prefixes: [.back(onPress: () => context.pop())],
        suffixes: [
          if (toggleAll != null)
            MochiAction(
              icon: _accordion.isAllCollapsed ? TablerIcons.chevronsDown : TablerIcons.chevronsUp,
              label: _accordion.isAllCollapsed
                  ? context.l10n.algorithmsExpandAll
                  : context.l10n.algorithmsCollapseAll,
              onPress: toggleAll,
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
      child: _AccordionScope(controller: _accordion, child: widget.child),
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

class _AlgorithmsGroupPageState extends State<AlgorithmsGroupPage> {
  late Set<int> _accordionExpanded = widget.groups.mapIndexed((i, _) => i).toSet();
  bool get _isAllCollapsed => _accordionExpanded.isEmpty;

  _AccordionController? _shellAccordion;

  void _expandAll() => _accordionExpanded = widget.groups.mapIndexed((i, _) => i).toSet();

  void _toggleAll() => setState(() => _isAllCollapsed ? _expandAll() : _accordionExpanded.clear());

  // Tells the shell's header the state after this frame, as it cannot be rebuilt during one.
  void _reportToShell() {
    if (!widget.standalone) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _shellAccordion?.update(isAllCollapsed: _isAllCollapsed, toggleAll: _toggleAll);
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _shellAccordion = _AccordionScope.maybeOf(context);
  }

  // The route reuses this State when only the puzzle changes, so the old indexes would point at
  // other groups.
  @override
  void didUpdateWidget(AlgorithmsGroupPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.puzzleId != widget.puzzleId) _expandAll();
  }

  @override
  void dispose() {
    // The next page reports for itself; until then the header has no button to show.
    final shell = _shellAccordion;
    if (widget.standalone && shell != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (shell.toggleAll == _toggleAll) shell.update(isAllCollapsed: false, toggleAll: null);
      });
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final g = context.theme.geometry;

    // CFOP solves cross on D (white) and finishes the last layer on yellow (cubeColorD).
    final topColor = SettingsProvider.of(context).cubeColorD.toColor();

    _reportToShell();

    final content = SingleChildScrollView(
      // Standalone, the shell's header sits above this; otherwise the row below does.
      padding: widget.standalone ? g.pagePadding : g.pagePadding.copyWith(top: 0),
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
    );

    if (widget.standalone) return content;

    return Column(
      crossAxisAlignment: .stretch,
      children: [
        Padding(
          padding: .directional(top: g.pagePadding.top, end: g.pagePadding.directional(context).end),
          child: _Header(
            isAllCollapsed: _isAllCollapsed,
            onCollapsedAll: _toggleAll,
            onExpandedAll: _toggleAll,
          ),
        ),
        Expanded(child: content),
      ],
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

class _AlgorithmSetPageState extends State<AlgorithmSetPage> {
  late Set<int> _accordionExpanded = widget.algorithmSet.grouped.mapIndexed((i, _) => i).toSet();
  bool get _isAllCollapsed => _accordionExpanded.isEmpty;

  @override
  Widget build(BuildContext context) {
    final g = context.theme.geometry;
    final topColor = SettingsProvider.of(context).cubeColorD.toColor();

    final content = SingleChildScrollView(
      padding: g.pagePadding.copyWith(top: 0),
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

    final header = _Header(
      title: widget.algorithmSet.name,
      canPop: true,
      isAllCollapsed: _isAllCollapsed,
      isBordered: widget.standalone,
      onCollapsedAll: () {
        setState(_accordionExpanded.clear);
      },
      onExpandedAll: () {
        setState(() => _accordionExpanded = widget.algorithmSet.grouped.mapIndexed((i, _) => i).toSet());
      },
    );

    if (widget.standalone) {
      return MochiScaffold(header: header, child: content);
    }

    // A solid fill: the scaffold's background is behind this page and the puzzle page under it, so
    // without one the page below shows through while this one slides in.
    return ColoredBox(
      color: context.colors.background,
      child: Column(
        crossAxisAlignment: .stretch,
        children: [
          Padding(
            padding: .directional(top: g.pagePadding.top, end: g.pagePadding.directional(context).end),
            child: header,
          ),
          // The row took the top inset, so the list must not take it a second time.
          Expanded(child: content),
        ],
      ),
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
