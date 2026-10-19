import "package:flutter/widgets.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mochi_cube_timer_gui/features/timer/timer_text.dart";

void main() {
  // The test font is a square per character, so a text is its length times the size wide.
  Future<Rect> time(WidgetTester tester, String text, {double width = 300}) async {
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: Center(
          child: SizedBox(
            width: width,
            height: 400,
            child: DefaultTextStyle(
              style: const TextStyle(fontSize: 50),
              child: TimerText(time: Text(text)),
            ),
          ),
        ),
      ),
    );
    return tester.getRect(find.text(text));
  }

  testWidgets("a time that fits is shown at its own size", (tester) async {
    final rect = await time(tester, "1.23");

    expect(rect.width, 200);
  });

  testWidgets("a time wider than the screen is scaled down to fit", (tester) async {
    final rect = await time(tester, "12:34:56.78");

    expect(rect.width, lessThanOrEqualTo(300));
    // One line, only smaller: wrapped onto two it would be as tall as it was and half as wide.
    expect(rect.width / rect.height, closeTo(11, 0.01));
    expect(rect.center.dx, closeTo(tester.getCenter(find.byType(SizedBox).first).dx, 0.5));
  });
}
