import "package:go_router/go_router.dart";
import "package:mochi_ui/mochi_ui.dart";

import "../../shared/utils.dart";

/// A trainer page's frame: its own header, over the page. Standalone, it is a scaffold of its own,
/// pushed over the home shell; otherwise it sits in the shell's body, which has no header for it.
class TrainerFrame extends StatelessWidget {
  const TrainerFrame({
    super.key,
    required this.title,
    required this.standalone,
    this.canPop = true,
    this.actions = const [],
    required this.child,
  });

  final String title;
  final bool standalone;

  /// Whether to have a back button. Standalone pages always do.
  final bool canPop;

  /// The header's buttons.
  final List<MochiAction> actions;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final header = MochiHeader(
      variant: standalone ? .bordered : .plain,
      title: Text(title),
      prefixes: [if (canPop || standalone) .back(onPress: () => context.pop())],
      suffixes: actions,
    );

    final g = context.theme.geometry;
    if (standalone) {
      // The header runs under the status bar and the page behind the header, as in the settings: the
      // pages pad themselves, and so clear the home indicator at the bottom.
      return MochiScaffold(
        extendBody: true,
        padding: .zero,
        header: header,
        // A builder: the header's height is in the media query of the body, not of this widget.
        child: Builder(
          builder: (context) => Padding(
            padding: .only(top: MediaQuery.paddingOf(context).top + g.pagePadding.top),
            child: child,
          ),
        ),
      );
    }

    // A solid fill: the page below would otherwise show through while this one slides in.
    return ColoredBox(
      color: context.colors.background,
      child: Column(
        crossAxisAlignment: .stretch,
        children: [
          Padding(
            padding: .directional(top: g.pagePadding.top, end: g.pagePadding.directional(context).end),
            child: header,
          ),
          Expanded(child: child),
        ],
      ),
    );
  }
}
