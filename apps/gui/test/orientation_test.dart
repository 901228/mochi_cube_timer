import "package:flutter/services.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mochi_cube_timer_gui/app/orientation.dart";
import "package:mochi_ui/mochi_ui.dart";

void main() {
  test("only the timer turns on its side", () {
    expect(orientationsFor("/timer"), contains(DeviceOrientation.landscapeLeft));
    for (final path in ["/records", "/stats", "/settings", "/settings/timer"]) {
      expect(orientationsFor(path), [DeviceOrientation.portraitUp], reason: path);
    }
  });

  testWidgets("the page is not built again when the bar and the sidebar go", (tester) async {
    Widget scaffold({required bool sideways}) => MochiApp(
      home: MochiScaffold(
        footer: sideways ? null : const Text("bar"),
        sidebar: sideways ? null : const Text("sidebar"),
        drawer: Text(sideways ? "sidebar in the drawer" : "drawer"),
        child: const _Page(),
      ),
    );

    await tester.pumpWidget(scaffold(sideways: false));
    final before = tester.state<_PageState>(find.byType(_Page));

    await tester.pumpWidget(scaffold(sideways: true));
    await tester.pumpAndSettle();
    expect(find.text("bar"), findsNothing);
    expect(tester.state<_PageState>(find.byType(_Page)), same(before));
  });
}

class _Page extends StatefulWidget {
  const _Page();

  @override
  State<_Page> createState() => _PageState();
}

class _PageState extends State<_Page> {
  @override
  Widget build(BuildContext context) => const Text("timer");
}
