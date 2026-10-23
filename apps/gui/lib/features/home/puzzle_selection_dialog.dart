import "package:cube_timer/cube_timer.dart";
import "package:flutter/widgets.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_svg/flutter_svg.dart";
import "package:mochi_ui/mochi_ui/widgets.dart";

import "../../l10n/l10n.dart";
import "../../shared/puzzles/puzzle_utils.dart";

enum _Kind { puzzles, algorithms }

class PuzzleSelectionDialog extends StatefulWidget {
  const PuzzleSelectionDialog({super.key});

  @override
  State<PuzzleSelectionDialog> createState() => _PuzzleSelectionDialogState();
}

class _PuzzleSelectionDialogState extends State<PuzzleSelectionDialog> {
  _Kind _kind = .puzzles;

  void _select(BuildContext context, Puzzle puzzle) {
    context.read<AppDatabase>().appStateDao.setPuzzle(puzzle);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      mainAxisSize: .min,
      spacing: 16,
      children: [
        MochiSegmentedControl<_Kind>(
          value: _kind,
          onChanged: (kind) => setState(() => _kind = kind),
          children: [
            MochiSegment(value: .puzzles, label: Text(l10n.homeKindPuzzles)),
            MochiSegment(value: .algorithms, label: Text(l10n.homeKindAlgorithms)),
          ],
        ),
        switch (_kind) {
          .puzzles => _puzzles(),
          .algorithms => _algorithms(l10n),
        },
      ],
    );
  }

  /// The practice modes come with the algorithm sets; until those exist the tab only says so.
  Widget _algorithms(AppLocalizations l10n) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 32),
    child: Text(l10n.homeAlgorithmsSoon, textAlign: .center),
  );

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
