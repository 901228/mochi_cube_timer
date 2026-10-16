import "package:flutter_test/flutter_test.dart";
import "package:mochi_cube_timer_gui/features/home/animated_branch_container.dart";
import "package:mochi_ui/mochi_ui.dart";

void main() {
  Widget app({required List<int> asked, bool draggable = true, int current = 0}) => MochiApp(
    themeMode: MochiThemeMode.light,
    // The test screen is 800 wide, and the container takes all of it.
    home: AnimatedBranchContainer(
      currentIndex: current,
      draggable: draggable,
      onChanged: asked.add,
      children: const [Text("one"), Text("two"), Text("three")],
    ),
  );

  testWidgets("dragging a third of the width or more asks for the next branch", (tester) async {
    final asked = <int>[];
    await tester.pumpWidget(app(asked: asked));

    await tester.drag(find.byType(AnimatedBranchContainer), const Offset(-400, 0));
    await tester.pumpAndSettle();

    expect(asked, [1]);
  });

  testWidgets("a short drag springs back and asks for nothing", (tester) async {
    final asked = <int>[];
    await tester.pumpWidget(app(asked: asked));

    await tester.drag(find.byType(AnimatedBranchContainer), const Offset(-100, 0));
    await tester.pumpAndSettle();

    expect(asked, isEmpty);
    expect(tester.getTopLeft(find.text("one")).dx, lessThan(800));
  });

  testWidgets("there is no branch past either end", (tester) async {
    final asked = <int>[];
    await tester.pumpWidget(app(asked: asked));
    await tester.drag(find.byType(AnimatedBranchContainer), const Offset(300, 0));
    await tester.pumpAndSettle();
    expect(asked, isEmpty);

    await tester.pumpWidget(app(asked: asked, current: 2));
    await tester.pumpAndSettle();
    await tester.drag(find.byType(AnimatedBranchContainer), const Offset(-300, 0));
    await tester.pumpAndSettle();
    expect(asked, isEmpty);
  });

  testWidgets("a container that is not draggable ignores the finger", (tester) async {
    final asked = <int>[];
    await tester.pumpWidget(app(asked: asked, draggable: false));

    await tester.drag(find.byType(AnimatedBranchContainer), const Offset(-300, 0));
    await tester.pumpAndSettle();

    expect(asked, isEmpty);
  });
}
