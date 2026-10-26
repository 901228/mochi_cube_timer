import "package:cube_timer/cube_timer.dart";
import "package:flutter/services.dart";
import "package:flutter_svg/flutter_svg.dart";
import "package:go_router/go_router.dart";
import "package:mochi_ui/mochi_ui.dart";

import "../../database/dao_provider.dart";
import "../../l10n/l10n.dart";
import "../../shared/puzzles/puzzle_utils.dart";
import "../../shared/utils.dart";
import "algorithm_data.dart";

/// Overview page (`/algorithms`) listing every puzzle that has algorithm sets, or the single-puzzle
/// overview (`/algorithms/:puzzle`) when filtered.
class AlgorithmsOverviewPage extends StatelessWidget {
  const AlgorithmsOverviewPage({super.key, this.puzzleId});

  final String? puzzleId;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    // CFOP solves cross on D (white) and finishes the last layer on yellow (cubeColorD).
    final topColor = SettingsProvider.of(context).cubeColorD.toColor();
    final filterPuzzle = puzzleId == null ? null : Puzzle.values.where((p) => p.id == puzzleId).firstOrNull;
    final puzzles = [
      for (final p in Puzzle.values)
        if ((filterPuzzle == null || p == filterPuzzle) && algorithmSetsForPuzzle(p).isNotEmpty) p,
    ];

    return MochiScaffold(
      extendBody: true,
      header: MochiHeader(
        alignment: .center,
        variant: .bordered,
        prefixes: [.back(onPress: () => context.pop())],
        title: MochiButton(
          appearance: .soft,
          scaleOnPress: false,
          onPress: () => showAlgorithmSetModal(context, currentPuzzle: filterPuzzle),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Text(
              filterPuzzle == null ? l10n.algorithmsTitle : filterPuzzle.displayName(l10n),
              style: context.theme.typography.title.md,
            ),
          ),
        ),
      ),
      child: Builder(
        builder: (context) => SingleChildScrollView(
          padding: MediaQuery.paddingOf(context),
          child: Column(
            crossAxisAlignment: .stretch,
            spacing: 24,
            children: [
              for (final puzzle in puzzles)
                MochiTileGroup(
                  label: Row(
                    mainAxisSize: .min,
                    spacing: 8,
                    children: [
                      SvgPicture.asset("assets/cube_icons/${puzzle.id}.svg", width: 20, height: 20),
                      Text(puzzle.displayName(l10n)),
                    ],
                  ),
                  children: [
                    for (final set in algorithmSetsForPuzzle(puzzle))
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
                        onPress: () => context.push("/algorithms/${puzzle.id}/${set.id}"),
                      ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Card-grid page (`/algorithms/:puzzle/:set`) showing the cases of one [AlgorithmSet], grouped by
/// category. Each card shows only the diagram and the case name; tapping opens the detail modal.
class AlgorithmSetPage extends StatelessWidget {
  const AlgorithmSetPage({super.key, required this.algorithmSet});

  final AlgorithmSet algorithmSet;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final topColor = SettingsProvider.of(context).cubeColorD.toColor();
    final groups = algorithmSet.grouped;

    return MochiScaffold(
      extendBody: true,
      header: MochiHeader(
        alignment: .center,
        variant: .bordered,
        prefixes: [.back(onPress: () => context.pop())],
        title: MochiButton(
          appearance: .soft,
          scaleOnPress: false,
          onPress: () => showAlgorithmSetModal(
            context,
            currentPuzzle: algorithmSet.puzzle,
            currentSet: algorithmSet,
            replaceRoute: true,
          ),
          child: Padding(
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
                    child: Text(algorithmSet.puzzle.displayName(l10n)),
                  ),
                  DefaultTextStyle.merge(
                    style: context.theme.typography.title.sm.copyWith(color: context.colors.mutedForeground),
                    child: Text(algorithmSet.name),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      child: Builder(
        builder: (context) => SingleChildScrollView(
          padding: MediaQuery.paddingOf(context),
          child: Column(
            crossAxisAlignment: .stretch,
            spacing: 24,
            children: [
              for (final (groupName, cases) in groups)
                Column(
                  crossAxisAlignment: .stretch,
                  spacing: 12,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Text(
                        groupName,
                        style: context.theme.typography.title.sm.copyWith(
                          color: context.colors.mutedForeground,
                        ),
                      ),
                    ),
                    GridView.builder(
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
                            algorithmSet: algorithmSet,
                            item: item,
                            topColor: topColor,
                          ),
                        );
                      },
                    ),
                  ],
                ),
            ],
          ),
        ),
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

/// Modal opened by pressing the header title button on `/algorithms` or `/algorithms/:puzzle/:set`
/// to switch between puzzles and their algorithm sets.
Future<void> showAlgorithmSetModal(
  BuildContext context, {
  Puzzle? currentPuzzle,
  AlgorithmSet? currentSet,
  bool replaceRoute = false,
}) {
  return showMochiModal(
    context,
    title: Text(context.l10n.algorithmsSelectSet),
    body: _AlgorithmSetSelector(
      initialPuzzle: currentPuzzle ?? currentSet?.puzzle ?? .cube3,
      currentSet: currentSet,
      replaceRoute: replaceRoute,
    ),
  );
}

class _AlgorithmSetSelector extends StatefulWidget {
  const _AlgorithmSetSelector({
    required this.initialPuzzle,
    required this.currentSet,
    required this.replaceRoute,
  });

  final Puzzle initialPuzzle;
  final AlgorithmSet? currentSet;
  final bool replaceRoute;

  @override
  State<_AlgorithmSetSelector> createState() => _AlgorithmSetSelectorState();
}

class _AlgorithmSetSelectorState extends State<_AlgorithmSetSelector> {
  late Puzzle _puzzle = widget.initialPuzzle;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final topColor = SettingsProvider.of(context).cubeColorD.toColor();
    final puzzlesWithSets = [
      for (final p in Puzzle.values)
        if (algorithmSetsForPuzzle(p).isNotEmpty) p,
    ];
    final sets = algorithmSetsForPuzzle(_puzzle);

    return Column(
      mainAxisSize: .min,
      crossAxisAlignment: .stretch,
      spacing: 16,
      children: [
        if (puzzlesWithSets.length > 1)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final p in puzzlesWithSets)
                MochiButton(
                  size: .sm,
                  intent: p == _puzzle ? .primary : .neutral,
                  appearance: p == _puzzle ? .soft : .outlined,
                  onPress: () => setState(() => _puzzle = p),
                  child: Text(p.displayName(l10n)),
                ),
            ],
          ),
        MochiTileGroup(
          children: [
            for (final set in sets)
              MochiTile(
                selected: set.id == widget.currentSet?.id && set.puzzle == widget.currentSet?.puzzle,
                prefix: SizedBox(
                  width: 36,
                  height: 36,
                  child: set.cases.first.buildDiagram(topColor: topColor),
                ),
                title: Text(set.name),
                subtitle: Text(set.subtitle),
                details: Text(l10n.algorithmsCasesCount(set.cases.length)),
                onPress: () {
                  final path = "/algorithms/${set.puzzle.id}/${set.id}";
                  Navigator.of(context).pop();
                  if (widget.replaceRoute) {
                    context.pushReplacement(path);
                  } else {
                    context.push(path);
                  }
                },
              ),
          ],
        ),
      ],
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
