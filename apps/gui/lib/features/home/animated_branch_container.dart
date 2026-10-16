import "dart:ui";

import "package:flutter/gestures.dart";
import "package:mochi_ui/mochi_ui.dart";

/// Slides between branches while keeping every branch attached to the render
/// tree.
///
/// A PageView would drop the pages it scrolls away into its keep-alive bucket,
/// which detaches their render objects. forui's RenderBounce removes its
/// animation listener on detach and never adds it back on attach, so every
/// FTappable in a page that was once offscreen lost its bounce.
///
/// A finger can drag the pages too, and they follow it; on lifting, the branch the drag leans towards
/// is handed to [onChanged], which is what moves [currentIndex]. A page's own drags win over it, as
/// they are the nearer to the finger.
class AnimatedBranchContainer extends StatefulWidget {
  const AnimatedBranchContainer({
    super.key,
    required this.currentIndex,
    required this.children,
    this.onChanged,
    this.draggable = true,
  });

  final int currentIndex;
  final List<Widget> children;

  /// Asked to go to a branch when a drag ends past the point of no return.
  final ValueChanged<int>? onChanged;

  /// Whether a finger can drag the pages. Touch only: a mouse has the bottom bar, and a press that
  /// slips a pixel is not a drag.
  final bool draggable;

  @override
  State<AnimatedBranchContainer> createState() => _AnimatedBranchContainerState();
}

class _AnimatedBranchContainerState extends State<AnimatedBranchContainer>
    with SingleTickerProviderStateMixin {
  /// The theme's transition, which the bottom bar's indicator also slides on, so the two move
  /// together.
  late final AnimationController _controller = AnimationController(vsync: this, value: 1);

  Curve _curve = Curves.easeOutCubic;

  /// The page position the running slide started from, which is fractional
  /// when a slide is interrupted by another branch change.
  late double _from = widget.currentIndex.toDouble();

  /// Where the finger has the pages while dragging, null otherwise.
  double? _drag;

  double get _position =>
      _drag ?? lerpDouble(_from, widget.currentIndex.toDouble(), _curve.transform(_controller.value))!;

  /// A third of the width, or a flick, is far enough to turn the page.
  static const _turnFraction = 1 / 3;
  static const _flickVelocity = 700.0;

  void _dragStart(DragStartDetails details) => setState(() => _drag = _position);

  void _dragUpdate(DragUpdateDetails details) {
    final width = context.size?.width;
    final drag = _drag;
    if (width == null || width == 0 || drag == null) return;

    // The pages go the way the finger does, so the position goes the opposite way.
    setState(() => _drag = (drag - details.primaryDelta! / width).clamp(0, widget.children.length - 1));
  }

  void _dragEnd(double velocity) {
    final drag = _drag;
    if (drag == null) return;

    final current = widget.currentIndex;
    final lean = drag - current;
    final direction = velocity.abs() > _flickVelocity ? -velocity.sign : lean.sign;
    final turns = velocity.abs() > _flickVelocity || lean.abs() > _turnFraction;
    final target = turns ? (current + direction.toInt()).clamp(0, widget.children.length - 1) : current;

    // Settled where the finger left them, then slid from there: to the branch, or back to this one.
    _from = drag;
    _controller.value = 0;
    setState(() => _drag = null);
    if (target == current) {
      _controller.forward(from: 0);
    } else {
      widget.onChanged?.call(target);
    }
  }

  @override
  void didUpdateWidget(covariant AnimatedBranchContainer oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.currentIndex != widget.currentIndex) {
      _from = lerpDouble(_from, oldWidget.currentIndex.toDouble(), _curve.transform(_controller.value))!;
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final motion = context.theme.motion;
    _controller.duration = motion.transitionDuration;
    _curve = motion.transitionCurve;
  }

  @override
  Widget build(BuildContext context) {
    final pages = ClipRect(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final position = _position;

          return Stack(
            fit: .expand,
            children: [
              for (final (i, child) in widget.children.indexed)
                Offstage(
                  key: ValueKey(i),
                  offstage: (i - position).abs() >= 1,
                  child: TickerMode(
                    enabled: (i - position).abs() < 1,
                    child: FractionalTranslation(translation: Offset(i - position, 0), child: child),
                  ),
                ),
            ],
          );
        },
      ),
    );

    if (!widget.draggable || widget.onChanged == null) return pages;

    return GestureDetector(
      // Drags on a page's empty parts count too, not only on what it has drawn.
      behavior: HitTestBehavior.translucent,
      supportedDevices: const {PointerDeviceKind.touch, PointerDeviceKind.stylus},
      onHorizontalDragStart: _dragStart,
      onHorizontalDragUpdate: _dragUpdate,
      onHorizontalDragEnd: (details) => _dragEnd(details.primaryVelocity ?? 0),
      onHorizontalDragCancel: () => _dragEnd(0),
      child: pages,
    );
  }
}
