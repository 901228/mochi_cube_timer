import "package:cube_timer/cube_timer.dart";
import "package:drift/native.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mochi_cube_timer_gui/database/dao_provider.dart";
import "package:mochi_cube_timer_gui/features/algorithms/algorithm_data.dart";
import "package:mochi_cube_timer_gui/features/algorithms/algorithm_data/oll.dart";
import "package:mochi_cube_timer_gui/features/algorithms/algorithm_data/pll.dart";
import "package:mochi_cube_timer_gui/features/algorithms/algorithms_page.dart";
import "package:mochi_cube_timer_gui/l10n/l10n.dart";
import "package:mochi_ui/mochi_ui.dart";

void main() {
  test("all 57 OLL masks have 9 stickers oriented on the last layer and are distinct", () {
    expect(ollCases, hasLength(57));
    expect(pllCases, hasLength(21));

    final seen = <int, String>{};
    for (final c in ollCases) {
      final mask = c.ollMask!;
      expect(mask & (1 << 4), isNonZero, reason: "${c.name} should keep U centre oriented");
      var count = 0;
      for (var i = 0; i < 21; i++) {
        if ((mask & (1 << i)) != 0) count++;
      }
      expect(
        count,
        9,
        reason: "${c.name} (${c.algorithms.first}) should have 9 U-coloured LL stickers, got $count",
      );
      expect(seen[mask], isNull, reason: "${c.name} has the same mask as ${seen[mask]}");
      seen[mask] = c.name;
    }
  });

  test("FTO L6X has 35 distinct cases, each with three stickers of every face and an algorithm", () {
    final cases = algorithmSets.findSet("fto", setId: "l6x")!.cases;
    expect(cases, hasLength(35));

    final seen = <String>{};
    for (final c in cases) {
      final stickers = c.ftoStickers!;
      expect(stickers.split("")..sort(), "ggglllooo".split("")..sort(), reason: c.name);
      expect(seen.add(stickers), isTrue, reason: "${c.name} repeats another case's stickers");
      expect(c.algorithms, isNotEmpty, reason: c.name);
    }
  });

  test("FTO L3C has its 5 cases with every sticker known, and shares the Nautilus group with L6X", () {
    final cases = algorithmSets.findSet("fto", setId: "l3c")!.cases;
    expect(cases, hasLength(5));
    expect(algorithmSets["fto"], hasLength(1));
    expect(algorithmSets["fto"]!.single.sets.map((s) => s.id), ["l6x", "l3c"]);
    for (final c in cases) {
      expect(c.ftoStickers, matches(r"^[yoglrbp]{21}$"), reason: c.name);
      expect(c.algorithms, isNotEmpty, reason: c.name);
    }
  });

  testWidgets("tapping a case card opens the detail modal with its algorithms", (tester) async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(() => tester.runAsync(db.close));
    final settings = (await tester.runAsync(() => db.settingsDao.watch().first))!;

    await tester.pumpWidget(
      SettingsProvider(
        state: settings,
        child: MochiApp(
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          locale: const Locale("en"),
          home: AlgorithmSetPage(algorithmSet: algorithmSets.findSet("333", setId: "pll")!),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text("Ua"), findsOneWidget);
    expect(find.text("R U' R U R U R U' R' U' R2"), findsNothing);

    await tester.tap(find.text("Ua"));
    await tester.pumpAndSettle();

    expect(find.text("R U' R U R U R U' R' U' R2"), findsOneWidget);
    expect(find.text("M2 U M U2 M' U M2"), findsOneWidget);
  });
}
