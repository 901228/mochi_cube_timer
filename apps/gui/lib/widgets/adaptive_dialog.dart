import "package:flutter/widgets.dart";
import "package:forui/forui.dart";

class AdaptiveDialog extends StatelessWidget {
  final FDialogStyleDelta style;
  final Animation<double>? animation;
  final Widget title;
  final Widget body;
  final List<Widget> actions;

  const new({
    required this.title,
    required this.body,
    this.actions = const [],
    this.style = const .context(),
    this.animation,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FDialog.adaptive(
      style: style,
      animation: animation,
      constraints: BoxConstraints(
        minWidth: 280,
        maxWidth: 560,
        maxHeight: MediaQuery.sizeOf(context).height / 2,
      ),
      horizontalBuilder: (context, style) {
        final touch = context.platformVariant.touch;
        return Padding(
          padding: touch
              ? const .symmetric(horizontal: 16, vertical: 18)
              : const .symmetric(horizontal: 16, vertical: 14),
          child: Column(
            crossAxisAlignment: .start,
            mainAxisSize: .min,
            children: [
              Padding(
                padding: touch ? const .only(left: 8, right: 8, bottom: 9) : const .only(bottom: 5),
                child: DefaultTextStyle.merge(style: style.titleTextStyle, child: title),
              ),
              SizedBox(height: touch ? 16 : 12),
              Flexible(
                child: Padding(
                  padding: touch ? const .only(left: 8, right: 8, bottom: 20) : const .only(bottom: 16),
                  child: DefaultTextStyle.merge(style: style.bodyTextStyle, child: body),
                ),
              ),
              SizedBox(height: touch ? 20 : 16),
              Row(
                mainAxisAlignment: .end,
                spacing: touch ? 10 : 8,
                children: touch ? [for (final action in actions) Expanded(child: action)] : actions,
              ),
            ],
          ),
        );
      },
      verticalBuilder: (context, style) {
        final touch = context.platformVariant.touch;
        return Padding(
          padding: touch
              ? const .symmetric(horizontal: 16, vertical: 18)
              : const .symmetric(horizontal: 16, vertical: 14),
          child: Column(
            crossAxisAlignment: .start,
            mainAxisSize: .min,
            children: [
              Padding(
                padding: touch
                    ? const .only(left: 8, right: 8, bottom: 9)
                    : const .only(left: 8, right: 8, bottom: 5),
                child: DefaultTextStyle.merge(style: style.titleTextStyle, child: title),
              ),
              SizedBox(height: touch ? 16 : 12),
              Flexible(
                child: Padding(
                  padding: touch
                      ? const .only(left: 8, right: 8, bottom: 20)
                      : const .only(left: 8, right: 8, bottom: 16),
                  child: DefaultTextStyle.merge(style: style.bodyTextStyle, child: body),
                ),
              ),
              SizedBox(height: touch ? 20 : 16),
              Column(mainAxisSize: .min, spacing: touch ? 10 : 8, children: actions),
            ],
          ),
        );
      },
    );
  }
}
