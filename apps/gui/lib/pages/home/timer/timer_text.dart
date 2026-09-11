import "package:flutter/widgets.dart";

class TimerText extends StatelessWidget {
  final double spacing;
  final Widget time;
  final Widget? hint;
  final Widget? rightHint;
  final Widget? action;
  const TimerText({super.key, this.spacing = 8, required this.time, this.hint, this.action, this.rightHint});

  @override
  Widget build(BuildContext context) {
    return CustomMultiChildLayout(
      delegate: TimerTextLayoutDelegate(spacing: spacing),
      children: [
        // Only the action slot takes pointers. The readout itself has to let a
        // press fall through to the timer surface painted behind it.
        if (hint != null)
          LayoutId(
            id: TimerTextLayoutDelegate.hintId,
            child: IgnorePointer(child: hint!),
          ),
        LayoutId(
          id: TimerTextLayoutDelegate.timeId,
          child: IgnorePointer(child: time),
        ),
        if (action != null) LayoutId(id: TimerTextLayoutDelegate.actionId, child: action!),
        if (rightHint != null)
          LayoutId(
            id: TimerTextLayoutDelegate.rightHintId,
            child: IgnorePointer(child: rightHint!),
          ),
      ],
    );
  }
}

class TimerTextLayoutDelegate extends MultiChildLayoutDelegate {
  static final String timeId = "time";
  static final String hintId = "hint";
  static final String rightHintId = "rightHint";
  static final String actionId = "action";

  final double spacing;
  TimerTextLayoutDelegate({this.spacing = 8});

  @override
  void performLayout(Size size) {
    // place text in the middle
    final text = layoutChild(timeId, BoxConstraints.loose(size));
    positionChild(timeId, Offset((size.width - text.width) / 2, (size.height - text.height) / 2));

    // place right hint
    if (hasChild(rightHintId)) {
      final rightHint = layoutChild(
        rightHintId,
        BoxConstraints.loose(Size((size.width - text.width) / 2, text.height)),
      );
      positionChild(rightHintId, Offset(size.width - rightHint.width, (size.height - rightHint.height) / 2));
    }

    final remainedSize = Size(size.width, (size.height - text.height) / 2 - spacing);

    // place hint
    if (hasChild(hintId)) {
      final hint = layoutChild(hintId, BoxConstraints.loose(remainedSize));
      positionChild(hintId, Offset((remainedSize.width - hint.width) / 2, remainedSize.height - hint.height));
    }

    // place action
    if (hasChild(actionId)) {
      final action = layoutChild(actionId, BoxConstraints.loose(remainedSize));
      positionChild(
        actionId,
        Offset((remainedSize.width - action.width) / 2, size.height - remainedSize.height),
      );
    }
  }

  @override
  bool shouldRelayout(covariant MultiChildLayoutDelegate oldDelegate) => false;
}
