import "dart:async";

import "package:cube_timer/cube_timer.dart";
import "package:drift/native.dart";
import "package:flutter/widgets.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mochi_cube_timer_gui/database/dao_provider.dart";

void main() {
  testWidgets("shows nothing until the settings arrive, then gives them to what is under it", (tester) async {
    final db = AppDatabase(NativeDatabase.memory());
    final settings = (await tester.runAsync(() => db.settingsDao.watch().first))!;
    final controller = StreamController<SettingsEntry>();
    addTearDown(controller.close);

    var builds = 0;
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: SettingsScope(
          stream: controller.stream,
          child: Builder(
            builder: (context) {
              builds++;
              return Text("${SettingsProvider.of(context).timeDecimals}");
            },
          ),
        ),
      ),
    );
    expect(find.byType(Text), findsNothing);

    controller.add(settings.copyWith(timeDecimals: 2));
    await tester.pump(const Duration(milliseconds: 1));
    expect(find.text("2"), findsOneWidget);

    controller.add(settings.copyWith(timeDecimals: 3));
    await tester.pump(const Duration(milliseconds: 1));
    expect(find.text("3"), findsOneWidget);

    // The same settings again are not a change, so nothing under it is rebuilt for them.
    final before = builds;
    controller.add(settings.copyWith(timeDecimals: 3));
    await tester.pump(const Duration(milliseconds: 1));
    expect(builds, before);

    await tester.runAsync(db.close);
  });
}
