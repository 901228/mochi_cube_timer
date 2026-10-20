import "package:cube_timer/cube_timer.dart";
import "package:flutter/widgets.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_svg/flutter_svg.dart";
import "package:mochi_ui/mochi_ui/widgets.dart";

import "../../l10n/l10n.dart";
import "../../shared/puzzles/puzzle_utils.dart";

class PuzzleSelectionDialog extends StatelessWidget {
  const PuzzleSelectionDialog({super.key});

  void _select(BuildContext context, Puzzle puzzle) {
    context.read<AppDatabase>().appStateDao.setPuzzle(puzzle);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
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
      // HACK: currently the scrambler of `fto` is not completed, so we return null for them.
      itemBuilder: (context, index) => _PuzzleTile(
        puzzle: Puzzle.values[index],
        onPress: {"fto"}.contains(Puzzle.values[index].id)
            ? null
            : () => _select(context, Puzzle.values[index]),
      ),
    );
  }
}

class _PuzzleTile extends StatelessWidget {
  const _PuzzleTile({required this.puzzle, this.onPress});

  final Puzzle puzzle;
  final VoidCallback? onPress;

  // TODO: add all puzzle scramble and remove this
  /// Greyscale filter
  static const _disabledFilter = ColorFilter.matrix(<double>[
    0.2126, 0.7152, 0.0722, 0, 0, //
    0.2126, 0.7152, 0.0722, 0, 0, //
    0.2126, 0.7152, 0.0722, 0, 0, //
    0, 0, 0, 0.5, 0, //
  ]);

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

    // disabled
    if (onPress == null) {
      content = ColorFiltered(colorFilter: _disabledFilter, child: content);
    }

    return MochiTappable(
      onPress: onPress,
      semanticLabel: puzzle.displayName(context.l10n),
      builder: (_, _, _) => content,
    );
  }
}
