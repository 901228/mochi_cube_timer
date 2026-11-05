import "package:cube_timer/cube_timer.dart";
import "package:drift/native.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mochi_cube_timer_gui/database/dao_provider.dart";
import "package:mochi_cube_timer_gui/features/simulator/cube_3d_painter.dart";
import "package:mochi_cube_timer_gui/features/simulator/fto_3d_painter.dart";
import "package:mochi_cube_timer_gui/features/simulator/notation.dart";
import "package:mochi_cube_timer_gui/features/simulator/simulator_page.dart";
import "package:mochi_cube_timer_gui/features/simulator/stickering.dart";
import "package:mochi_cube_timer_gui/l10n/l10n.dart";
import "package:mochi_ui/mochi_ui.dart";
import "package:mochi_cube/nxn.dart";
import "package:mochi_cube_timer_gui/features/simulator/sim_move.dart";
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
      {for (final s in Stickering.of(fto: false)) s: shown(s)},
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

  test("a hold is the rotation that puts the faces picked on top and in front", () {
    expect(holdRotation(0, 2), "");
    expect(holdRotation(0, 1), "y");
    // Every face on top, with each of the four next to it in front.
    for (var top = 0; top < 6; top++) {
      for (var front = 0; front < 6; front++) {
        if (dot(faceNormals[top], faceNormals[front]) != 0) continue;
        final cube = _after(holdRotation(top, front));
        expect(cube.cubies.firstWhere((c) => c.position == (0, 2, 0)).home, _times2(faceNormals[top]));
        expect(cube.cubies.firstWhere((c) => c.position == (0, 0, 2)).home, _times2(faceNormals[front]));
      }
    }
  });

  test("inverting reverses the moves and turns each the other way", () {
    expect(invertNotation("R U R' U'"), "U R U' R'");
    expect(invertNotation("(R2 F3) M' r2'"), "r2 M F'3 R'2");
    // Undone, the cube is as it was.
    const moves = "R U2 F' L3 r M' x";
    expect(_stickers(_after("$moves ${invertNotation(moves)}")), _stickers(SimulatedCube(3)));
  });

  test("turns of one axis in brackets turn at once, others are only grouped", () {
    final (_, moves) = readSimMoves(4, "", "(R L') (r R') (R U) (x 2L)");
    expect(
      [for (final m in moves.cast<CubeMove>()) m.base],
      [
        [1, 0, 0, 1],
        [0, 1, 0, 0],
        [1, 0, 0, 0],
        [1, 0, 0, 0],
        [1, 1, 0, 1],
      ],
    );
    final cube = SimulatedCube(4);
    for (final m in moves.cast<CubeMove>()) {
      m.turns.forEach(cube.turn);
    }
    expect(_stickers(cube), _stickers(_after("R L' r R' R U x 2L", size: 4)));
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

    // Typing plays on what is typed; what cannot be read is underlined in red and leaves the cube as it was.
    List<String?> underlined(Finder box) {
      final controller = tester.widget<EditableText>(box).controller as NotationController;
      final span = controller.buildTextSpan(context: tester.element(box), withComposing: false);
      return [
        for (final child in span.children!.whereType<TextSpan>())
          if (child.style?.decoration == TextDecoration.underline) child.text,
      ];
    }

    await tester.enterText(find.byType(EditableText).last, "R Q W");
    await tester.pumpAndSettle();
    expect(tester.widget<MochiTextField>(find.byType(MochiTextField).last).error, "");
    expect(underlined(find.byType(EditableText).last), ["Q", "W"]);

    await tester.enterText(find.byType(EditableText).last, "r U M' x");
    await tester.pumpAndSettle();
    expect(tester.widget<MochiTextField>(find.byType(MochiTextField).last).error, isNull);
    // Everything played: the pause button is back to play, and stepping back is possible.
    expect(find.byIcon(TablerIcons.playerPlay), findsOneWidget);

    // Turning the last move into R2 plays only the extra quarter turn, and mid-turn edits continue from where it was.
    CustomPainter? painter() => tester
        .widget<CustomPaint>(
          find.descendant(of: find.byType(GestureDetector).first, matching: find.byType(CustomPaint)),
        )
        .painter;
    await tester.tap(find.byIcon(TablerIcons.restore));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(EditableText).last, "R");
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
    await tester.enterText(find.byType(EditableText).last, "R2");
    await tester.pump();
    expect(
      painter(),
      isA<Cube3dPainter>()
          .having((p) => p.move?.amount, "amount", 2)
          .having((p) => p.startQuarters, "startQuarters", greaterThan(0)),
    );
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(EditableText).last, "R'");
    await tester.pump();
    expect(painter(), isA<Cube3dPainter>().having((p) => p.move?.amount, "amount", -3));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(EditableText).last, "r U M' x");
    await tester.pumpAndSettle();

    // Stepping while a turn is on hurries it and plays the next one straight after.
    for (final icon in [TablerIcons.arrowBackUp, TablerIcons.arrowForwardUp]) {
      await tester.tap(find.byIcon(icon));
      await tester.pump(const Duration(milliseconds: 50));
      await tester.tap(find.byIcon(icon));
      await tester.pumpAndSettle();
      expect(
        _stickers((painter()! as Cube3dPainter).cube),
        _stickers(_after(icon == TablerIcons.arrowBackUp ? "r U" : "r U M' x")),
      );
    }

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
    expect(underlined(find.byType(EditableText).first), ["Q"]);
    await tester.enterText(find.byType(EditableText).first, "R U");
    await tester.pumpAndSettle();
    expect(underlined(find.byType(EditableText).first), isEmpty);
    expect(find.byIcon(TablerIcons.playerPlay), findsOneWidget);

    await tester.tap(find.byIcon(TablerIcons.arrowBackUp));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(TablerIcons.playerSkipBack));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(TablerIcons.playerPlay));
    await tester.pumpAndSettle();
    expect(find.byIcon(TablerIcons.playerPlay), findsOneWidget);

    // Picking another size re-reads the moves for it: M is not on a 2x2.
    expect(find.text("3x3"), findsOneWidget);
    await tester.tap(find.text("3x3"));
    await tester.pumpAndSettle();
    await tester.tap(find.text("2x2").last);
    await tester.pumpAndSettle();
    expect(underlined(find.byType(EditableText).last), ["M"]);
    // And stage stickering is only for the 3x3.
    expect(find.text("Full"), findsNothing);
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

  testWidgets("the FTO is picked like a size, and turns, rotates and inverts", (tester) async {
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

    tester.widget<MochiSelect<int>>(find.byType(MochiSelect<int>).first).onChanged!(ftoPuzzle);
    await tester.pumpAndSettle();
    CustomPainter? painter() => tester
        .widget<CustomPaint>(
          find.descendant(of: find.byType(GestureDetector).first, matching: find.byType(CustomPaint)),
        )
        .painter;
    expect(painter(), isA<Fto3dPainter>());
    // Its own stages, and held by the faces it has.
    expect(
      [
        for (final o in tester.widget<MochiSelect<Stickering>>(find.byType(MochiSelect<Stickering>)).options)
          o.value,
      ],
      [Stickering.full, Stickering.l6x, Stickering.l3c],
    );
    final front = tester.widget<MochiSelect<int>>(find.byType(MochiSelect<int>).last);
    expect(front.options, hasLength(6));

    final moves = find.byType(EditableText).last;
    await tester.enterText(moves, "{U, R} r BR2 Q");
    await tester.pumpAndSettle();
    expect(tester.widget<MochiTextField>(find.byType(MochiTextField).last).error, "");

    await tester.enterText(moves, "{U, R} r BR2");
    await tester.pumpAndSettle();
    expect(tester.widget<MochiTextField>(find.byType(MochiTextField).last).error, isNull);
    await tester.tap(find.byIcon(TablerIcons.arrowsExchange));
    await tester.pumpAndSettle();
    expect(tester.widget<EditableText>(moves).controller.text, "BR2' r' {U, R}");
  });
}

Vec3 _times2(Vec3 v) => (v.$1 * 2, v.$2 * 2, v.$3 * 2);
