import "dart:ui";

import "package:flutter/widgets.dart";

/// Slides between branches while keeping every branch attached to the render
/// tree.
///
/// A PageView would drop the pages it scrolls away into its keep-alive bucket,
/// which detaches their render objects. forui's RenderBounce removes its
/// animation listener on detach and never adds it back on attach, so every
/// FTappable in a page that was once offscreen lost its bounce.
class AnimatedBranchContainer extends StatefulWidget {
  const AnimatedBranchContainer({super.key, required this.currentIndex, required this.children});

  final int currentIndex;
  final List<Widget> children;

  @override
  State<AnimatedBranchContainer> createState() => _AnimatedBranchContainerState();
}

class _AnimatedBranchContainerState extends State<AnimatedBranchContainer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 300),
    value: 1,
  );

  /// The page position the running slide started from, which is fractional
  /// when a slide is interrupted by another branch change.
  late double _from = widget.currentIndex.toDouble();

  double get _position =>
      lerpDouble(_from, widget.currentIndex.toDouble(), Curves.easeOutCubic.transform(_controller.value))!;

  @override
  void didUpdateWidget(covariant AnimatedBranchContainer oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.currentIndex != widget.currentIndex) {
      _from = lerpDouble(
        _from,
        oldWidget.currentIndex.toDouble(),
        Curves.easeOutCubic.transform(_controller.value),
      )!;
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRect(
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
  }
}
