import "package:cube_timer/cube_timer.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_svg/flutter_svg.dart";
import "package:mochi_ui/mochi_ui.dart";

import "../../database/dao_provider.dart";
import "../../l10n/l10n.dart";
import "../../shared/utils.dart";
import "../algorithms/algorithm_data.dart";
import "../algorithms/algorithm_data/common.dart";
import "../algorithms/cube_painter.dart";
import "../algorithms/practice_scramble.dart";
import "../../shared/puzzles/puzzle_utils.dart";

enum _Kind { puzzles, algorithms }

/// The width of the room at each end of the switch, for the layout button.
const _buttonRoom = 40.0;

class PuzzleSelectionDialog extends StatefulWidget {
  final void Function(Puzzle puzzle)? onSelect;

  /// Whether the puzzles / algorithms switch is shown; off, only the puzzles are.
  final bool showKinds;

  /// The puzzle and algorithm set (or drill) in use: the dialog opens on the algorithms when practising, and
  /// with that puzzle's sets open, or the current puzzle's when not.
  final Puzzle? current;
  final String? currentSet;
  const PuzzleSelectionDialog({
    super.key,
    this.onSelect,
    this.showKinds = true,
    this.current,
    this.currentSet,
  });

  @override
  State<PuzzleSelectionDialog> createState() => _PuzzleSelectionDialogState();
}

class _PuzzleSelectionDialogState extends State<PuzzleSelectionDialog> {
  late _Kind _kind = widget.currentSet == null ? .puzzles : .algorithms;

  /// Whether the sets are laid out as a grid rather than a list; kept for the session, not saved.
  static bool _grid = true;

  /// The heading of the current puzzle's sets, which the list opens scrolled to.
  final _currentKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    if (_kind == .algorithms) _scrollToCurrent();
  }

  void _scrollToCurrent() => WidgetsBinding.instance.addPostFrameCallback((_) {
    final context = _currentKey.currentContext;
    if (context != null) Scrollable.ensureVisible(context, alignment: 0);
  });

  void _select(BuildContext context, Puzzle puzzle) {
    context.read<AppDatabase>().appStateDao.setPuzzle(puzzle);
    Navigator.of(context).pop();

    widget.onSelect?.call(puzzle);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    if (!widget.showKinds) return _puzzles();

    return Column(
      mainAxisSize: .min,
      spacing: 16,
      children: [
        // The same room at both ends, so the switch stays centred with the layout button at one of them.
        Row(
          spacing: 8,
          children: [
            const SizedBox(width: _buttonRoom),
            Expanded(
              child: MochiSegmentedControl<_Kind>(
                value: _kind,
                onChanged: (kind) {
                  setState(() => _kind = kind);
                  if (kind == .algorithms) _scrollToCurrent();
                },
                children: [
                  MochiSegment(value: .puzzles, label: Text(l10n.homeKindPuzzles)),
                  MochiSegment(value: .algorithms, label: Text(l10n.homeKindAlgorithms)),
                ],
              ),
            ),
            SizedBox(
              width: _buttonRoom,
              child: _kind == .algorithms
                  ? MochiButton.icon(
                      appearance: .ghost,
                      semanticLabel: _grid ? l10n.practiceViewList : l10n.practiceViewGrid,
                      onPress: () => setState(() => _grid = !_grid),
                      icon: Icon(_grid ? TablerIcons.list : TablerIcons.layoutGrid),
                    )
                  : null,
            ),
          ],
        ),
        // Both stay in the tree, so the dialog is as tall as the puzzles make it for either tab; the longer
        // list of sets scrolls in that room.
        IndexedStack(
          index: _kind.index,
          alignment: .center,
          clipBehavior: Clip.none,
          children: [
            _puzzles(),
            // Reaches out to the modal's edge, with the room inside the scroll, so the scrollbar is not on the sets.
            Builder(
              builder: (context) {
                final inset = MochiModalInset.of(context);
                return Positioned(
                  left: -inset,
                  right: -inset,
                  top: 0,
                  bottom: 0,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: inset),
                    child: _algorithms(context),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  /// The algorithm sets there are scrambles for, by puzzle: picking one practises its cases, its solves kept
  /// apart from the puzzle's own.
  Widget _algorithms(BuildContext context) {
    final topColor = SettingsProvider.of(context).cubeColorD.toColor();
    final entries = [
      for (final entry in algorithmSets.entries)
        if (canPractice(entry.key)) entry,
    ];
    void pick(String id, String set) {
      context.read<AppDatabase>().appStateDao.setAlgorithmSet(Puzzle.fromId(id), set);
      Navigator.of(context).pop();
    }

    // Every way to pick, as (diagram, name, subtitle, what picking does).
    List<(Widget, String, String?, VoidCallback)> choices(String id, List<AlgorithmSet> sets) => [
      if (id == "333")
        (
          // The cross from the front-right corner: the two edges in sight below their centres.
          const AspectRatio(
            aspectRatio: 1,
            child: CubeIsoDiagram(
              stickers:
                  "lllllllll"
                  "llllgllgl"
                  "llllollol",
            ),
          ),
          context.l10n.practiceCrossName,
          context.l10n.practiceCrossDescription,
          () => pick(id, crossDrillId),
        ),
      for (final set in sets)
        (
          AspectRatio(
            aspectRatio: set.cases.first.diagramAspectRatio,
            child: set.cases.first.buildDiagram(topColor: topColor),
          ),
          set.name,
          set.subtitle,
          () => pick(id, set.id),
        ),
    ];

    return Column(
      mainAxisSize: .min,
      crossAxisAlignment: .stretch,
      children: [
        MochiAccordion(
          expanded: .managed(
            initial: {entries.indexWhere((e) => e.key == widget.current?.id)}.difference({-1}),
          ),
          items: [
            for (final MapEntry(key: id, value: groups) in entries)
              MochiAccordionItem(
                title: Row(
                  key: id == widget.current?.id ? _currentKey : null,
                  spacing: 12,
                  children: [
                    SvgPicture.asset("assets/cube_icons/$id.svg", width: 28, height: 28),
                    Text(Puzzle.fromId(id).displayName(context.l10n)),
                  ],
                ),
                child: _grid
                    ? GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: .zero,
                        crossAxisCount: 3,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                        childAspectRatio: 1,
                        children: [
                          for (final (diagram, name, _, onPress) in choices(id, groups.flatten()))
                            MochiTappable(
                              onPress: onPress,
                              semanticLabel: name,
                              builder: (_, _, _) => Column(
                                mainAxisAlignment: .center,
                                spacing: 6,
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 8),
                                      child: Center(child: diagram),
                                    ),
                                  ),
                                  Text(name, textAlign: .center, maxLines: 1, overflow: .ellipsis),
                                ],
                              ),
                            ),
                        ],
                      )
                    : MochiTileGroup(
                        children: [
                          for (final (diagram, name, subtitle, onPress) in choices(id, groups.flatten()))
                            MochiTile(
                              prefix: SizedBox(width: 36, height: 36, child: diagram),
                              title: Text(name),
                              subtitle: subtitle == null ? null : Text(subtitle),
                              onPress: onPress,
                            ),
                        ],
                      ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _puzzles() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: .zero,
      itemCount: Puzzle.values.length,
      // mainAxisExtent sets the cell height outright. Without it the
      // delegate falls back to childAspectRatio, which derives the
      // height from the width and makes every other value guesswork.
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisExtent: 92,
        crossAxisSpacing: 8,
        mainAxisSpacing: 16,
      ),
      itemBuilder: (context, index) =>
          _PuzzleTile(puzzle: Puzzle.values[index], onPress: () => _select(context, Puzzle.values[index])),
    );
  }
}

class _PuzzleTile extends StatelessWidget {
  const _PuzzleTile({required this.puzzle, required this.onPress});

  final Puzzle puzzle;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    Widget content = Column(
      mainAxisAlignment: .center,
      spacing: 4,
      children: [
        SvgPicture.asset("assets/cube_icons/${puzzle.id}.svg", width: 48, height: 48),
        Text(puzzle.displayName(context.l10n), textAlign: .center, maxLines: 2, overflow: .ellipsis),
      ],
    );

    return MochiTappable(
      onPress: onPress,
      semanticLabel: puzzle.displayName(context.l10n),
      builder: (_, _, _) => content,
    );
  }
}
