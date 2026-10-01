import "package:cube_timer/cube_timer.dart";
import "package:flutter/widgets.dart";
import "package:mochi_ui/mochi_ui.dart";

import "cube_2d_view.dart";

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
    this.onHover,
    this.alignment = .center,
  });

  final Puzzle puzzle;
  final List<String> steps;

  final WrapAlignment alignment;

  /// How many moves count as done, or null for all of them.
  final int? applied;

  /// The move that is picked out, counted from 1.
  final int? selected;

  /// Called with the move's index. Null leaves the moves untappable.
  final ValueChanged<int>? onTap;

  /// Called with the index of the move the pointer is over, and with null when
  /// it leaves that move. Null leaves the moves unhoverable.
  ///
  /// Crossing from one move straight into the next reports the leave and the
  /// enter in the same pointer event, so the finished scramble is never drawn
  /// in between.
  final ValueChanged<int?>? onHover;

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
    final hover = onHover;

    // Derived from the size rather than fixed, so the gaps read as spaces at
    // both the page's size and the dialog's.
    final spacing = size * 0.35;
    final runSpacing = size * 0.2;

    // When the moves can be pointed at, the gaps are handed to the moves on
    // either side as padding instead of being left between them. That way a
    // pointer is always either over a move, where hover and tap both land, or
    // clear of the moves altogether; a gap between them would flicker the
    // preview back to the finished scramble while crossing it.
    final interactive = tap != null || hover != null;
    final gap = interactive
        ? EdgeInsets.symmetric(horizontal: spacing / 2, vertical: runSpacing / 2)
        : EdgeInsets.zero;

    return Wrap(
      alignment: alignment,
      spacing: interactive ? 0 : spacing,
      runSpacing: interactive ? 0 : runSpacing,
      children: [
        for (var i = 0; i < steps.length; i++)
          GestureDetector(
            behavior: .opaque,
            onTap: tap == null ? null : () => tap(i),
            child: MouseRegion(
              onEnter: hover == null ? null : (_) => hover(i),
              onExit: hover == null ? null : (_) => hover(null),
              child: Padding(
                padding: gap,
                child: Hero(
                  tag: "scramble-$puzzle-$i",
                  curve: Cube2DView.heroFlightCurve,
                  flightShuttleBuilder: _flight,
                  child: _Token(
                    text: steps[i],
                    style: TextStyle(
                      color: i < done ? theme.colors.foreground : theme.colors.mutedForeground,
                      fontWeight: .w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
