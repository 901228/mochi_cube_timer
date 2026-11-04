import "package:cube_timer/cube_timer.dart";
import "package:drift/native.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mochi_cube_timer_gui/database/dao_provider.dart";
import "package:mochi_cube_timer_gui/features/simulator/notation.dart";
import "package:mochi_cube_timer_gui/features/simulator/simulator_page.dart";
import "package:mochi_cube_timer_gui/features/simulator/stickering.dart";
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

  test("each stage of the solve shows its own stickers", () {
    final cube = SimulatedCube(3);
    int shown(Stickering s) => [
      for (final c in cube.cubies)
        for (final (_, face) in cube.stickers(c))
          if (s.lit(3, c.home, face)) 1,
    ].length;
    expect(
      {for (final s in Stickering.values) s: shown(s)},
      {
        Stickering.full: 54,
        // The five centres but the top one, and the four bottom edges.
        Stickering.cross: 5 + 8,
        // All but the 21 of the top layer, its centre too.
        Stickering.f2l: 33,
        // The nine on top.
        Stickering.oll: 9,
        // The top layer, sides and all.
        Stickering.pll: 21,
      },
    );
  });

  test("the last layer is the one of the face picked, whatever way the cube is held", () {
    int shown(Stickering s, SimulatedCube cube, int lastLayer) => [
      for (final c in cube.cubies)
        for (final (_, face) in cube.stickers(c))
          if (s.lit(3, c.home, face, lastLayer: lastLayer)) 1,
    ].length;
    // The cube is solved however it is held, and the stages are of its pieces: D as the last layer is U as it is
    // from the other side, so the counts are the same, and a rotation first changes nothing.
    for (final stage in Stickering.values) {
      expect(shown(stage, _after("x2"), 3), shown(stage, SimulatedCube(3), 0), reason: "$stage");
    }
    // The top layer's pieces are dim in F2L, and the bottom's are not.
    final cube = SimulatedCube(3);
    final topEdge = cube.cubies.firstWhere((c) => c.home == (0, 2, 2));
    final bottomEdge = cube.cubies.firstWhere((c) => c.home == (0, -2, 2));
    expect(Stickering.f2l.lit(3, topEdge.home, 2, lastLayer: 3), isTrue);
    expect(Stickering.f2l.lit(3, bottomEdge.home, 2, lastLayer: 3), isFalse);
  });

  test("an orientation goes first in the setup, in the place of the one before it", () {
    expect(withOrientation("R U", previous: "", rotation: "z2"), "z2 R U");
    expect(withOrientation("z2 R U", previous: "z2", rotation: "y"), "y R U");
    expect(withOrientation("z2 R U", previous: "z2", rotation: ""), "R U");
    expect(withOrientation("", previous: "", rotation: "x2"), "x2");
    // Held as it says, the faces are where it names: x2 puts D on top.
    final cube = _after("x2");
    expect(cube.cubies.firstWhere((c) => c.position == (0, 2, 0)).home, (0, -2, 0));
  });

  test("inverting reverses the moves and turns each the other way", () {
    expect(invertNotation("R U R' U'"), "U R U' R'");
    expect(invertNotation("(R2 F3) M' r2'"), "r2 M F'3 R'2");
    // Undone, the cube is as it was.
    const moves = "R U2 F' L3 r M' x";
    expect(_stickers(_after("$moves ${invertNotation(moves)}")), _stickers(SimulatedCube(3)));
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
    await tester.enterText(find.byType(EditableText).last, "R Q");
    await tester.pumpAndSettle();
    expect(find.text("Can't read: Q"), findsOneWidget);

    await tester.enterText(find.byType(EditableText).last, "r U M' x");
    await tester.pumpAndSettle();
    expect(find.textContaining("Can't read"), findsNothing);
    // Everything played: the pause button is back to play, and stepping back is possible.
    expect(find.byIcon(TablerIcons.playerPlay), findsOneWidget);

    // The moves are the second box, under the setup; inverting rewrites it.
    final moves = find.byType(EditableText).last;
    String text(Finder box) => tester.widget<EditableText>(box).controller.text;
    await tester.tap(find.byIcon(TablerIcons.arrowsExchange));
    await tester.pumpAndSettle();
    expect(text(moves), invertNotation("r U M' x"));

    // A random scramble goes into the setup, which the slider does not count.
    await tester.tap(find.byIcon(TablerIcons.dice));
    await tester.pumpAndSettle();
    expect(text(find.byType(EditableText).first).split(" "), hasLength(20));
    expect(tester.widget<MochiSlider>(find.byType(MochiSlider)).max, 4);
    await tester.enterText(find.byType(EditableText).first, "R Q");
    await tester.pumpAndSettle();
    expect(find.text("Can't read: Q"), findsOneWidget);
    await tester.enterText(find.byType(EditableText).first, "R U");
    await tester.pumpAndSettle();
    expect(find.textContaining("Can't read"), findsNothing);
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
