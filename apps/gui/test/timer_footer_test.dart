import "package:flutter/widgets.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mochi_cube_timer_gui/features/timer/timer_footer.dart";

void main() {
  // A phone, 390 pt across minus the page's padding, with a picture as wide as the Clock's. The
  // widest English line, "Deviation: 123.45" at 14 pt Comfortaa, measures 122 pt.
  testWidgets("a wide picture leaves the statistics room", (tester) async {
    const stats = Key("stats");
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: Center(
          child: SizedBox(
            width: 358,
            child: TimerFooter(
              left: const SizedBox(key: stats, height: 80),
              picture: AspectRatio(aspectRatio: 2.3, child: Container()),
              right: const SizedBox(height: 80),
            ),
          ),
        ),
      ),
    );

    expect(tester.getSize(find.byKey(stats)).width, greaterThanOrEqualTo(122));
    expect(tester.getSize(find.byType(AspectRatio)).width, lessThanOrEqualTo(358 * 2 / 8));
  });
}
