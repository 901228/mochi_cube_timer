import "package:cube_timer/cube_timer.dart";
import "package:drift/native.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mochi_cube_timer_gui/database/dao_provider.dart";
import "package:mochi_cube_timer_gui/features/simulator/simulator_page.dart";
import "package:mochi_cube_timer_gui/l10n/l10n.dart";
import "package:mochi_ui/mochi_ui.dart";
import "package:mochi_cube/nxn.dart";
import "package:mochi_cube_timer_gui/features/simulator/simulated_cube.dart";

SimulatedCube _after(String moves, {int size = 3}) {
  final cube = SimulatedCube(size);
  cubeLayerTurns(moves, size: size).forEach(cube.turn);
  return cube;
}

/// Each sticker's face, by where it is and which way it looks.
Map<(Vec3, Vec3), int> _stickers(SimulatedCube cube) => {
  for (final c in cube.cubies)
    for (final (normal, face) in cube.stickers(c)) (c.position, normal): face,
};

void main() {
  test("a turn four times, or the sexy move six, comes back", () {
    expect(_stickers(_after("R R R R")), _stickers(SimulatedCube(3)));
    expect(_stickers(_after("R U R' U' " * 6)), _stickers(SimulatedCube(3)));
    expect(_after("R U").isSolved, isFalse);
  });

  test("a rotation turns the whole cube, which is still solved", () {
    final cube = _after("x");
    expect(cube.isSolved, isTrue);
    // F's centre comes up to the top.
    final top = cube.cubies.firstWhere((c) => c.position == (0, 2, 0));
    expect(top.home, (0, 0, 2));
  });

  test("wide turns and slices are the face turns and rotations they are made of", () {
    expect(_stickers(_after("r")), _stickers(_after("L x")));
    expect(_stickers(_after("M")), _stickers(_after("R L' x'")));
    expect(_stickers(_after("Rw", size: 4)), _stickers(_after("R 2R", size: 4)));
  });

  test("a count turns that many quarters, the way it is written", () {
    expect(_stickers(_after("R3")), _stickers(_after("R'")));
    expect(_stickers(_after("U'2")), _stickers(_after("U2")));
    expect(cubeLayerTurns("R3 U'2", size: 3).map((t) => t.quarters), [3, -2]);
  });

  test("moves after a rotation turn the layer now on that side", () {
    // After y, the face on the right is the one that was at the back.
    expect(_stickers(_after("y R")), _stickers(_after("B y")));
  });

  testWidgets("typed moves play out, and ones it cannot read are named", (tester) async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(() => tester.runAsync(db.close));
    final settings = (await tester.runAsync(() => db.settingsDao.watch().first))!;

    await tester.binding.setSurfaceSize(const Size(360, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      SettingsProvider(
        state: settings,
        child: MochiApp(
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          locale: const Locale("en"),
          home: const SimulatorPage(standalone: true),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Typing plays on what is typed; what cannot be read is named and leaves the cube as it was.
    await tester.enterText(find.byType(EditableText), "R Q");
    await tester.pumpAndSettle();
    expect(find.text("Can't read: Q"), findsOneWidget);

    await tester.enterText(find.byType(EditableText), "r U M' x");
    await tester.pumpAndSettle();
    expect(find.textContaining("Can't read"), findsNothing);
    // Everything played: the pause button is back to play, and stepping back is possible.
    expect(find.byIcon(TablerIcons.playerPlay), findsOneWidget);

    await tester.tap(find.byIcon(TablerIcons.arrowBackUp));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(TablerIcons.playerSkipBack));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(TablerIcons.playerPlay));
    await tester.pumpAndSettle();
    expect(find.byIcon(TablerIcons.playerPlay), findsOneWidget);
  });

  testWidgets("the settings open beside the cube, and say what is set", (tester) async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(() => tester.runAsync(db.close));
    final settings = (await tester.runAsync(() => db.settingsDao.watch().first))!;

    await tester.binding.setSurfaceSize(const Size(360, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      RepositoryProvider.value(
        value: db,
        child: SettingsProvider(
          state: settings,
          child: MochiApp(
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            locale: const Locale("en"),
            home: const SimulatorPage(standalone: true),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text("Turn speed"), findsNothing);

    await tester.tap(find.byIcon(TablerIcons.adjustmentsHorizontal));
    await tester.pumpAndSettle();
    expect(find.text("Turn speed"), findsOneWidget);
    expect(find.text("Hint letters"), findsOneWidget);
    expect(find.text("1.0x"), findsOneWidget);
    expect(find.text("3.0"), findsOneWidget);
    // The cube is still there to watch.
    expect(find.byType(CustomPaint), findsWidgets);
  });
}
