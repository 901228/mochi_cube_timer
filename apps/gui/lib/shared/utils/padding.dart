import "package:flutter/widgets.dart";

extension PaddingUtils on EdgeInsetsGeometry {
  ({double start, double end, double top, double bottom}) directional(BuildContext context) {
    final dir = Directionality.of(context);
    final resolvedPadding = resolve(dir);

    return (
      start: dir == .ltr ? resolvedPadding.left : resolvedPadding.right,
      end: dir == .ltr ? resolvedPadding.right : resolvedPadding.left,
      top: resolvedPadding.top,
      bottom: resolvedPadding.bottom,
    );
  }
}
