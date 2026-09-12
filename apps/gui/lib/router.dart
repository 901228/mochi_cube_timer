import "package:flutter/widgets.dart";
import "package:forui/forui.dart";
import "package:go_router/go_router.dart";

import "pages/home.page.dart";
import "pages/home/records.page.dart";
import "pages/home/timer/timer.page.dart";
import "pages/settings.page.dart";

final router = GoRouter(
  initialLocation: "/",
  routes: [
    GoRoute(path: "/", redirect: (_, _) => "/timer"),

    GoRoute(
      path: "/settings",
      name: "settings",
      builder: (_, _) => const SettingsPage(section: "root"),
      routes: [
        GoRoute(
          path: ":section",
          redirect: (_, state) =>
              settingsPages.containsKey(state.pathParameters["section"]) ? null : "/settings",
          builder: (_, state) => SettingsPage(section: state.pathParameters["section"]!),
        ),
      ],
    ),

    StatefulShellRoute(
      builder: (context, state, navigationShell) => PageFrame(
        pages: [
          (name: "Timer", icon: FLucideIcons.timer, path: "/timer"),
          (name: "Records", icon: FLucideIcons.library, path: "/records"),
          (name: "Stats", icon: FLucideIcons.chartLine, path: "/stats"),
        ],
        navigationShell: navigationShell,
      ),
      navigatorContainerBuilder: (context, navigationShell, children) =>
          AnimatedBranchContainer(currentIndex: navigationShell.currentIndex, children: children),

      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: "/timer",
              name: "timer",
              builder: (context, state) {
                return TimerPage();
              },
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: "/records",
              name: "records",
              builder: (context, state) {
                return RecordsPage();
              },
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: "/stats",
              name: "stats",
              builder: (context, state) {
                return Center(child: Text("stats"));
              },
            ),
          ],
        ),
      ],
    ),
  ],
);

class _KeepAlive extends StatefulWidget {
  const _KeepAlive({required this.child});
  final Widget child;

  @override
  State<_KeepAlive> createState() => _KeepAliveState();
}

class _KeepAliveState extends State<_KeepAlive> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context); // 這行不能漏
    return widget.child;
  }
}

class AnimatedBranchContainer extends StatefulWidget {
  const AnimatedBranchContainer({super.key, required this.currentIndex, required this.children});

  final int currentIndex;
  final List<Widget> children;

  @override
  State<AnimatedBranchContainer> createState() => _AnimatedBranchContainerState();
}

class _AnimatedBranchContainerState extends State<AnimatedBranchContainer> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();

    _pageController = PageController(initialPage: widget.currentIndex);
  }

  @override
  void didUpdateWidget(covariant AnimatedBranchContainer oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.currentIndex != widget.currentIndex) {
      _pageController.animateToPage(
        widget.currentIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      physics: const NeverScrollableScrollPhysics(),
      children: widget.children.map((c) => _KeepAlive(child: c)).toList(),
    );
  }
}
