import "dart:ui" show ImageFilter;

import "package:cube_timer/cube_timer.dart";
import "package:flutter/widgets.dart";
import "package:forui/forui.dart";

import "../../shared/puzzles.dart";

/// How long the viewer takes to arrive and to leave.
const Duration _transition = Duration(milliseconds: 300);

/// Open the scramble viewer over the current page.
///
/// A [PageRoute] rather than [showFDialog], because Flutter only flies heroes
/// between page routes and a dialog route is a [PopupRoute]. That is what makes
/// the thumbnail become the dialog's puzzle instead of a second copy of it: the
/// thumbnail's place is held empty for as long as the viewer is up.
///
/// The dialog's own scale is switched off, since the hero already animates the
/// only thing that moves; leaving it on would land the flight in a card that is
/// still growing.
Future<void> showScrambleDialog(
  BuildContext context, {
  required Puzzle puzzle,
  required Scramble scramble,
  required SettingsEntry settings,
}) {
  final routeStyle = context.theme.dialogRouteStyle;

  return Navigator.of(context).push(
    PageRouteBuilder<void>(
      opaque: false,
      barrierDismissible: true,
      // Longer than a dialog's own 150ms. A dialog only has to appear, and
      // 150ms is right for that; here the moves travel and change size by about
      // a tenth, and nine frames of that reads as a jump rather than a move.
      transitionDuration: _transition,
      reverseTransitionDuration: _transition,
      pageBuilder: (context, animation, _) => Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              behavior: HitTestBehavior.opaque,
              child: FadeTransition(
                opacity: animation,
                child: BackdropFilter(
                  filter: routeStyle.barrierFilter?.call(context, animation.value) ?? ImageFilter.blur(),
                  child: const ColoredBox(color: Color(0x00FFFFFF)),
                ),
              ),
            ),
          ),
          FadeTransition(
            opacity: animation,
            child: ScrambleDialog(puzzle: puzzle, scramble: scramble, settings: settings),
          ),
        ],
      ),
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
class ScrambleDialog extends StatefulWidget {
  const ScrambleDialog({super.key, required this.puzzle, required this.scramble, required this.settings});

  final Puzzle puzzle;
  final Scramble scramble;
  final SettingsEntry settings;

  @override
  State<ScrambleDialog> createState() => _ScrambleDialogState();
}

class _ScrambleDialogState extends State<ScrambleDialog> {
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
  void didUpdateWidget(ScrambleDialog oldWidget) {
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

  /// Fade [child] out ahead of the rest of the dialog on the way out.
  ///
  /// The title labels something the viewer has already decided to leave, so
  /// carrying it all the way down with the card reads as lag. Only the exit is
  /// shaped: coming in it rides the route's own fade like everything else.
  Widget _leavesFirst(BuildContext context, Widget child) {
    final animation = ModalRoute.of(context)?.animation;
    if (animation == null) return child;

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) => Opacity(
        opacity: animation.status == AnimationStatus.reverse
            ? const Interval(0.55, 1).transform(animation.value)
            : 1,
        child: child,
      ),
      child: child,
    );
  }

  /// The steps as tappable spans.
  Widget _moves(BuildContext context, FDialogStyle style) => ScrambleTokens(
    puzzle: widget.puzzle,
    steps: _steps,
    applied: _shown,
    selected: _shown,
    onTap: (index) => _select(index + 1),
    onHover: (index) {
      final hovered = index == null ? null : index + 1;
      if (hovered != _hovered) setState(() => _hovered = hovered);
    },
  );

  @override
  Widget build(BuildContext context) => FDialog(
    // Null: the route fades this in and the hero moves the puzzle, so the
    // dialog animating itself on top of that would be a third thing moving.
    animation: null,
    // The move spans sit deeper in the hit test than this detector, so a tap on
    // a move goes to that move and only the rest of the dialog clears.
    builder: (context, style) => GestureDetector(
      onTap: _clear,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const .all(20),
        child: Column(
          mainAxisSize: .min,
          spacing: 16,
          children: [
            _leavesFirst(
              context,
              Padding(
                padding: const .all(8),
                child: DefaultTextStyle.merge(style: style.titleTextStyle, child: const Text("Scramble")),
              ),
            ),
            _moves(context, style),
            Cube2DView(puzzle: widget.puzzle, state: _state, settings: widget.settings),
          ],
        ),
      ),
    ),
  );
}
