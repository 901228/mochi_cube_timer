import "package:cube_timer/cube_timer.dart";
import "package:flutter/widgets.dart";
import "package:mochi_ui/mochi_ui/theme/responsive.dart";
import "package:mochi_ui/mochi_ui/theme/theme.dart";
import "package:mochi_ui/mochi_ui/widgets.dart";

import "../../theme.dart";
import "../puzzles.dart";

/// Open the scramble viewer over the current page.
///
/// A sheet on a phone and a dialog from a tablet up, the same split
/// [showMochiModal] makes. The sheet is the ordinary [showMochiSheet]: a hero
/// flying into a panel that slides up from the edge reads as two unrelated
/// motions, so the sheet just slides over the thumbnail. The dialog is where
/// the thumbnail becomes the viewer's puzzle, see [_showScrambleDialog].
Future<void> showScrambleModal(
  BuildContext context, {
  required Puzzle puzzle,
  required Scramble scramble,
  SettingsEntry? settings,
}) {
  final content = ScrambleModalContent(puzzle: puzzle, scramble: scramble, settings: settings);

  return switch (context.responsive<MochiModalForm>(mobile: .sheet, tablet: .dialog)) {
    .dialog => _showScrambleDialog(context, content),
    .sheet => showMochiSheet(
      context,
      builder: (context) => MochiSheet(
        title: const Text("Scramble"),
        semanticLabel: "Scramble",
        safeEdge: false,
        child: content,
      ),
    ),
  };
}

/// Not [showMochiDialog]: its route is a [PopupRoute], and Flutter only flies
/// heroes between [PageRoute]s. That flight is what makes the thumbnail become
/// the viewer's puzzle instead of a second copy of it. So this is a transparent
/// page route dressed as a [MochiDialog], with the theme's barrier and timing.
///
/// Pushed on the root navigator, so the barrier covers the shell's header and
/// footer too rather than only the branch the thumbnail is in. The heroes still
/// fly: a [HeroController] also picks up heroes in a nested navigator, as long
/// as they are on its current [PageRoute].
///
/// Fades rather than scales: the heroes already move the only things that
/// move, and a growing card would land them in a box that is still changing.
Future<void> _showScrambleDialog(BuildContext context, Widget content) {
  final theme = context.theme;
  final shadow = theme.colors.shadow;

  return Navigator.of(context, rootNavigator: true).push(
    PageRouteBuilder<void>(
      opaque: false,
      barrierDismissible: true,
      barrierLabel: theme.strings.dismiss,
      barrierColor: shadow.withValues(alpha: shadow.a * 0.5),
      transitionDuration: theme.motion.transitionDuration,
      reverseTransitionDuration: theme.motion.transitionReverseDuration,
      pageBuilder: (context, _, _) => Center(
        child: MochiDialog(title: const Text("Scramble"), semanticLabel: "Scramble", body: content),
      ),
      transitionsBuilder: (context, animation, _, child) =>
          MochiSurfaceTransition(animation: animation, transition: .fade, scrim: false, child: child),
    ),
  );
}

/// The whole scramble, with a puzzle underneath showing where it has got to.
///
/// Tapping a step draws the puzzle as it stands after it, the way cstimer lets
/// you walk a scramble; tapping the same step again, or anywhere else in the
/// dialog, goes back to the finished scramble.
///
/// The steps come from [Scrambler.stepsOf] rather than from splitting the
/// notation here, so the Clock — whose steps are dial turns and a `y2` rather
/// than moves — walks the same way as the cubes with no special case.
///
/// Stateful only to remember which step is picked; [ScrambleTokens] does the
/// laying out and the tapping.
class ScrambleModalContent extends StatefulWidget {
  const ScrambleModalContent({super.key, required this.puzzle, required this.scramble, this.settings});

  final Puzzle puzzle;
  final Scramble scramble;
  final SettingsEntry? settings;

  @override
  State<ScrambleModalContent> createState() => _ScrambleModalContentState();
}

class _ScrambleModalContentState extends State<ScrambleModalContent> {
  /// How many steps are applied, or null for the whole scramble.
  int? _upTo;

  /// How many steps the move under the pointer would apply, or null when the
  /// pointer is not over the moves.
  ///
  /// Shown over [_upTo] rather than replacing it, so hovering only previews:
  /// moving off the moves returns to whatever was tapped.
  int? _hovered;

  /// What is drawn: the hovered step while there is one, otherwise the tapped one.
  int? get _shown => _hovered ?? _upTo;

  /// The notation, one entry per step that can be stopped at.
  late List<String> _steps = widget.puzzle.scrambler.stepsOf(widget.scramble);

  @override
  void didUpdateWidget(ScrambleModalContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.scramble != widget.scramble) {
      _upTo = null;
      _hovered = null;
      _steps = widget.puzzle.scrambler.stepsOf(widget.scramble);
    }
  }

  /// Tapping the move already selected clears the selection, so the same tap
  /// both enters and leaves the halfway view.
  void _select(int upTo) => setState(() => _upTo = _upTo == upTo ? null : upTo);

  /// Back to the finished scramble.
  ///
  /// Reached by tapping anywhere that is not a move, so getting out of the
  /// halfway view never means hunting for the one move that is selected.
  void _clear() {
    if (_upTo != null) setState(() => _upTo = null);
  }

  /// The state to draw: part way through when a step is selected, otherwise
  /// the finished scramble.
  List<int> get _state {
    final upTo = _shown;
    if (upTo == null) return widget.scramble.state;
    return widget.puzzle.scrambler.stateAfter(widget.scramble, upTo);
  }

  /// The steps as tappable spans.
  Widget _moves(BuildContext context) => DefaultTextStyle(
    style: context.theme.timer.lg,
    child: ScrambleTokens(
      puzzle: widget.puzzle,
      steps: _steps,
      applied: _shown,
      selected: _shown,
      onTap: (index) => _select(index + 1),
      onHover: (index) {
        final hovered = index == null ? null : index + 1;
        if (hovered != _hovered) setState(() => _hovered = hovered);
      },
    ),
  );

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: _clear,
    behavior: HitTestBehavior.opaque,
    child: Padding(
      padding: const .all(20),
      child: Column(
        mainAxisSize: .min,
        spacing: 16,
        children: [
          _moves(context),
          Cube2DView(puzzle: widget.puzzle, state: _state, settings: widget.settings),
        ],
      ),
    ),
  );
}
