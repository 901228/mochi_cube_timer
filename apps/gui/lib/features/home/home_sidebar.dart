import "package:flutter/widgets.dart";
import "package:forui/forui.dart";
import "package:go_router/go_router.dart";

class HomeSidebar extends StatelessWidget {
  const HomeSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return FSidebar(
      header: Padding(
        padding: const .symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Padding(padding: const .fromLTRB(16, 8, 16, 16), child: const Text("Mochi Cube Timer")),
            const FDivider(style: .delta(padding: .value(.zero))),
          ],
        ),
      ),
      children: [
        // FSidebarGroup(
        //   label: const Text("Other"),
        //   children: [FSidebarItem(label: const Text("Hello"), onPress: () {})],
        // ),
        FSidebarGroup(
          children: [
            FSidebarItem(
              label: const Text("Settings"),
              icon: Icon(FLucideIcons.settings),
              onPress: () {
                context.pop();
                context.pushNamed("settings");
              },
            ),
          ],
        ),
      ],
    );
  }
}
