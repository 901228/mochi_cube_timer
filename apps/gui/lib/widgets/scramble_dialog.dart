import "package:cube_timer/cube_timer.dart";
import "package:cupertino_ui/cupertino_ui.dart";
import "package:flutter/gestures.dart" show TapGestureRecognizer;
import "package:forui/forui.dart";

import "cube_2dview.dart";

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
/// Stateful because a tapped span needs a [TapGestureRecognizer], and those
/// have to be disposed.
class ScrambleDialog extends StatefulWidget {
  const ScrambleDialog({
    super.key,
    required this.puzzle,
    required this.scramble,
    required this.style,
    required this.animation,
  });

  final Puzzle puzzle;
  final Scramble scramble;
  final FDialogStyleDelta style;
  final Animation<double> animation;

  @override
  State<ScrambleDialog> createState() => _ScrambleDialogState();
}

class _ScrambleDialogState extends State<ScrambleDialog> {
  /// How many steps are applied, or null for the whole scramble.
  int? _upTo;

  /// The notation, one entry per step that can be stopped at.
  List<String> _steps = const [];

  /// One per step, so a span can be tapped.
  List<TapGestureRecognizer> _recognizers = const [];

  @override
  void initState() {
    super.initState();
    _buildRecognizers();
  }

  @override
  void didUpdateWidget(ScrambleDialog oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.scramble != widget.scramble) {
      _disposeRecognizers();
      _upTo = null;
      _buildRecognizers();
    }
  }

  @override
  void dispose() {
    _disposeRecognizers();
    super.dispose();
  }

  void _buildRecognizers() {
    _steps = widget.puzzle.scrambler.stepsOf(widget.scramble);
    _recognizers = [
      for (var i = 0; i < _steps.length; i++) TapGestureRecognizer()..onTap = () => _select(i + 1),
    ];
  }

  void _disposeRecognizers() {
    for (final recognizer in _recognizers) {
      recognizer.dispose();
    }
    _recognizers = const [];
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
    final upTo = _upTo;
    if (upTo == null) return widget.scramble.state;
    return widget.puzzle.scrambler.stateAfter(widget.scramble, upTo);
  }

  /// The steps as tappable spans.
  Widget _moves(BuildContext context, FDialogStyle style) {
    final theme = context.theme;
    final applied = _upTo ?? _steps.length;

    return Text.rich(
      TextSpan(
        children: [
          for (var i = 0; i < _steps.length; i++) ...[
            if (i > 0) const TextSpan(text: " "),
            TextSpan(
              text: _steps[i],
              recognizer: _recognizers[i],
              style: TextStyle(
                color: i < applied ? theme.colors.foreground : theme.colors.mutedForeground,
                fontWeight: i + 1 == _upTo ? FontWeight.w700 : null,
              ),
            ),
          ],
        ],
      ),
      textAlign: .center,
    );
  }

  @override
  Widget build(BuildContext context) => FDialog(
    style: widget.style,
    animation: widget.animation,
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
            Padding(
              padding: const .all(8),
              child: DefaultTextStyle.merge(style: style.titleTextStyle, child: const Text("Scramble")),
            ),
            _moves(context, style),
            PuzzleStateView(puzzle: widget.puzzle, state: _state),
          ],
        ),
      ),
    ),
  );
}
