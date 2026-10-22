import "dart:async";

import "package:flutter/widgets.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mochi_cube_timer_gui/app/splash_cover.dart";

void main() {
  Widget host(Future<void> ready) => SplashCover(
    ready: ready,
    child: const Directionality(textDirection: TextDirection.ltr, child: Text("app")),
  );

  testWidgets("covers the app until it is ready, then fades out of the way", (tester) async {
    final ready = Completer<void>();
    await tester.pumpWidget(host(ready.future));
    // The icon decodes for real, off the fake clock.
    await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 100)));
    await tester.pump();
    expect(find.byType(Image), findsOneWidget);

    ready.complete();
    await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 50)));
    await tester.pumpAndSettle();
    expect(find.byType(Image), findsNothing);
    expect(find.text("app"), findsOneWidget);
  });

  testWidgets("an app that failed to get ready is shown anyway", (tester) async {
    final ready = Completer<void>();
    await tester.pumpWidget(host(ready.future));
    ready.completeError(StateError("no database"));
    await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 100)));
    await tester.pumpAndSettle();
    expect(find.byType(Image), findsNothing);
  });

  testWidgets("the app is not built again when the cover goes", (tester) async {
    final ready = Completer<void>();
    await tester.pumpWidget(SplashCover(ready: ready.future, child: const _Counter()));
    await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 100)));
    await tester.pump();
    final before = tester.state<_CounterState>(find.byType(_Counter));

    ready.complete();
    await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 50)));
    await tester.pumpAndSettle();
    expect(find.byType(Image), findsNothing);
    expect(tester.state<_CounterState>(find.byType(_Counter)), same(before));
  });
}

class _Counter extends StatefulWidget {
  const _Counter();

  @override
  State<_Counter> createState() => _CounterState();
}

class _CounterState extends State<_Counter> {
  @override
  Widget build(BuildContext context) =>
      const Directionality(textDirection: TextDirection.ltr, child: Text("app"));
}
