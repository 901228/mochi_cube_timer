import "package:mochi_ui/mochi_ui.dart";

class HomeSidebar extends StatelessWidget {
  const HomeSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return MochiSidebar(
      header: MochiSidebarHeading(const Text("Mochi Cube Timer")),
      children: [
        // MochiSidebarGroup(
        //   label: const Text("Other"),
        //   children: [
        //     MochiSidebarItem(icon: Icon(TablerIcons.accessPoint), label: const Text("Hello"), onPress: () {}),
        //   ],
        // ),
        MochiSidebarGroup(children: []),
      ],
    );
  }
}
