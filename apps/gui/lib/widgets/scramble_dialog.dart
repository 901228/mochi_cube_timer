import "dart:ui" show ImageFilter;

import "package:cube_timer/cube_timer.dart";
import "package:flutter/widgets.dart";
import "package:forui/forui.dart";

import "cube_2dview.dart";

/// The scramble as one widget per move, laid out so it can wrap between them.
///
/// A [Wrap] rather than a [Text.rich] for two reasons.
///
/// A line can only break between children, so a move is never split down the
/// middle — nothing guarantees that `U'` or `ALL2+` survives a text layout's
/// own line breaking, and a scramble that wrapped there would read as a
/// different move.
///
/// And each move gets its own [Hero], so flying between the page and the
/// viewer moves boxes rather than reflowing a paragraph. The two ends break
/// their lines in different places, which is unfixable as long as a whole
/// block of text is being morphed; as separate moves it stops mattering,
/// because the break points only decide where each box is going.
class ScrambleTokens extends StatelessWidget {
  const ScrambleTokens({
    super.key,
    required this.puzzle,
    required this.steps,
    this.applied,
    this.selected,
    this.onTap,
  });

  final Puzzle puzzle;
  final List<String> steps;

  /// How many moves count as done, or null for all of them.
  final int? applied;

  /// The move that is picked out, counted from 1.
  final int? selected;

  /// Called with the move's index. Null leaves the moves untappable.
  final ValueChanged<int>? onTap;

  /// A move on its own never wraps, so a flight only has to carry one end's
  /// style to the other's.
  ///
  /// The *whole* style, size and colour and weight together: a move that is
  /// greyed out or picked out in the dialog is neither of those on the page, and
  /// reading only the inherited size would drop those differences for the length
  /// of the flight and snap them back on landing.
  static Widget _flight(
    BuildContext flightContext,
    Animation<double> animation,
    HeroFlightDirection direction,
    BuildContext fromContext,
    BuildContext toContext,
  ) {
    final from = _styleOf(fromContext);
    final to = _styleOf(toContext);
    final text = ((fromContext.widget as Hero).child as _Token).text;

    // A pop's animation counts down: it starts at one and finishes at zero,
    // while a push runs the other way. Both end at [toContext], so the style
    // has to be read towards it from whichever end the clock is at, or the
    // flight arrives wearing the style it set out in and swaps on the last
    // frame.
    final pop = direction == HeroFlightDirection.pop;

    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        final t = pop ? 1 - animation.value : animation.value;
        return DefaultTextStyle(style: TextStyle.lerp(from, to, t)!, child: Text(text));
      },
    );
  }

  /// What one end of a flight actually draws: the size it inherits, with the
  /// move's own colour and weight over the top.
  static TextStyle _styleOf(BuildContext context) {
    final token = (context.widget as Hero).child as _Token;
    return DefaultTextStyle.of(context).style.merge(token.style);
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final style = DefaultTextStyle.of(context).style;
    final size = style.fontSize ?? 14;
    final done = applied ?? steps.length;
    final tap = onTap;

    return Wrap(
      alignment: .center,
      // Derived from the size rather than fixed, so the gaps read as spaces at
      // both the page's size and the dialog's.
      spacing: size * 0.35,
      runSpacing: size * 0.2,
      children: [
        for (var i = 0; i < steps.length; i++)
          GestureDetector(
            behavior: .opaque,
            onTap: tap == null ? null : () => tap(i),
            child: Hero(
              tag: "scramble-$puzzle-$i",
              curve: heroFlightCurve,
              flightShuttleBuilder: _flight,
              child: _Token(
                text: steps[i],
                style: TextStyle(
                  color: i < done ? theme.colors.foreground : theme.colors.mutedForeground,
                  // Stated at both ends rather than inherited, so a flight
                  // never has to change it. Comfortaa is a static family, so
                  // TextStyle.lerp can only step between the weights that
                  // exist; with the two sizes only 10% apart there is no
                  // movement to hide those steps behind.
                  fontWeight: i + 1 == selected ? FontWeight.w700 : FontWeight.w600,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

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
Future<void> showScrambleDialog(BuildContext context, {required Puzzle puzzle, required Scramble scramble}) {
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
            child: ScrambleDialog(puzzle: puzzle, scramble: scramble),
          ),
        ],
      ),
    ),
  );
}

/// One move.
///
/// Holds its own [style] rather than handing it straight to the [Text], so a
/// hero flight can read what this end draws instead of guessing from what the
/// move inherits. Picking a move changes the colour and the weight, and those
/// ease rather than switch, so walking a scramble does not flicker.
class _Token extends StatelessWidget {
  const _Token({required this.text, required this.style});

  final String text;
  final TextStyle style;

  @override
  Widget build(BuildContext context) => AnimatedDefaultTextStyle(
    duration: const Duration(milliseconds: 120),
    style: DefaultTextStyle.of(context).style.merge(style),
    child: Text(text),
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
  const ScrambleDialog({super.key, required this.puzzle, required this.scramble});

  final Puzzle puzzle;
  final Scramble scramble;

  @override
  State<ScrambleDialog> createState() => _ScrambleDialogState();
}

class _ScrambleDialogState extends State<ScrambleDialog> {
  /// How many steps are applied, or null for the whole scramble.
  int? _upTo;

  /// The notation, one entry per step that can be stopped at.
  late List<String> _steps = widget.puzzle.scrambler.stepsOf(widget.scramble);

  @override
  void didUpdateWidget(ScrambleDialog oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.scramble != widget.scramble) {
      _upTo = null;
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
    final upTo = _upTo;
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
    applied: _upTo,
    selected: _upTo,
    onTap: (index) => _select(index + 1),
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
            PuzzleStateView(puzzle: widget.puzzle, state: _state, heroTag: puzzleHeroTag(widget.puzzle)),
          ],
        ),
      ),
    ),
  );
}
