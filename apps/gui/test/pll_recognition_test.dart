import "package:cube_timer/cube_timer.dart";
import "package:drift/native.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mochi_cube_timer_gui/database/dao_provider.dart";
import "package:mochi_cube_timer_gui/features/algorithms/algorithm_data/pll.dart";
import "package:mochi_cube_timer_gui/features/trainers/pll_recognition/pll_recognition_page.dart";
import "package:mochi_cube_timer_gui/features/trainers/pll_recognition/pll_rules.dart";
import "package:mochi_cube_timer_gui/features/trainers/pll_recognition/pll_view.dart";
import "package:mochi_cube_timer_gui/l10n/l10n.dart";
import "package:mochi_ui/mochi_ui.dart";

// Faces, as indices of nxnFaceNames: U R F D L B.
const u = 0, r = 1, f = 2, l = 4;

void main() {
  test("Ua from the front and right is a front edge and a right edge swapped round", () {
    final ua = pllCases.firstWhere((c) => c.id == "ua");
    expect(pllTwoSide(ua.algorithms.first), [f, r, f, r, l, r]);
  });

  test("every look of every PLL case is its own, and the guide names the family of it", () {
    final seen = <String, String>{};
    for (final c in pllCases) {
      for (var before = 0; before < 4; before++) {
        for (var after = 0; after < 4; after++) {
          final look = pllTwoSide(c.algorithms.first, preAuf: before, auf: after);
          // Two cases never look the same from these two sides: the trainer's answer is unique.
          expect(
            seen.putIfAbsent(look.join(), () => c.id),
            c.id,
            reason: "${c.id} looks like ${seen[look.join()]}",
          );

          final match = recognizePll(look);
          expect(match, isNotNull, reason: "${c.id} $before $after: $look");
          expect(
            pllFamilies[match!.rule.family],
            contains(c.id),
            reason: "${c.id} $before $after: ${match.rule}",
          );
          expect(pllCaseOf(look), c.id);
        }
      }
    }
    // 21 cases of 16 looks, less the ones the symmetric cases share.
    expect(seen, hasLength(284));
  });

  test("the sides out of view carry on the strip round the cube", () {
    // Round the layer, a left sticker is followed by a front one, a right sticker by a back one, in the
    // order the faces go round: L F R B.
    const ring = {(4, 2), (2, 1), (1, 5), (5, 4)};
    for (final c in pllCases) {
      for (var before = 0; before < 4; before++) {
        for (var after = 0; after < 4; after++) {
          final look = pllLook(c.algorithms.first, preAuf: before, auf: after);
          expect(ring, contains((look.left[2], look.strip[0])), reason: "${c.id} $before $after");
          expect(ring, contains((look.strip[5], look.back[0])), reason: "${c.id} $before $after");
        }
      }
    }
  });

  test("every rule of the guide is matched by a look, and every family is named", () {
    for (final rule in PllRule.values) {
      expect(pllExamples[rule], isNotEmpty, reason: "$rule");
      for (final example in pllExamples[rule]!) {
        // Something is framed, and it is among what is shown, which is among the six.
        expect(example.framed, isNotEmpty, reason: "$rule");
        expect(example.shown.containsAll(example.framed), isTrue, reason: "$rule");
        expect(example.shown.every((i) => i >= 0 && i < 6), isTrue, reason: "$rule");
      }
    }
    expect({for (final rule in PllRule.values) rule.family}, pllFamilies.keys.toSet());
    expect(pllFamilies.values.expand((ids) => ids).toSet(), pllCases.map((c) => c.id).toSet());
  });

  test("the guide's two exceptions to telling a from b by mirroring hold for every look", () {
    // Faces: R 1, F 2, L 4, B 5.
    bool opposite(int x, int y) => (x - y).abs() == 3;
    for (final c in pllCases) {
      for (var before = 0; before < 4; before++) {
        for (var after = 0; after < 4; after++) {
          final look = pllTwoSide(c.algorithms.first, preAuf: before, auf: after);
          final match = recognizePll(look)!;
          final s = match.mirrored ? look.reversed.toList() : look;

          if (match.rule == PllRule.threeBarHeadlights) {
            // The 3-bar on the left: the edge on the right opposite the bar is Ua, opposite the lights Ub;
            // on the right it is the other way round.
            final oppositeBar = opposite(s[4], s[0]);
            expect(oppositeBar != match.mirrored ? "ua" : "ub", c.id, reason: "$look");
          }
          if (match.rule == PllRule.doubleBarInsideBookends) {
            expect(opposite(s[0], s[1]) ? "ab" : "aa", c.id, reason: "$look");
          }
        }
      }
    }
  });

  testWidgets("answering counts the question, and a wrong answer shows the right one", (tester) async {
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
          home: const PllRecognitionPage(standalone: true),
        ),
      ),
    );
    await tester.pumpAndSettle();
    // The guide is the first tab.
    expect(find.text("Patterns"), findsWidgets);
    await tester.tap(find.text("Practice"));
    await tester.pumpAndSettle();
    expect(find.text("0"), findsNWidgets(2));

    // Ua, or any other: the question is random, so either way is possible.
    await tester.tap(find.text("Ua"));
    await tester.pumpAndSettle();
    expect(find.text("1"), findsOneWidget);
    // The answer is shown when it was wrong. The button for the next question is always laid out.
    if (find.textContaining("It was").evaluate().isNotEmpty) {
      await tester.tap(find.text("Next"));
      await tester.pumpAndSettle();
      expect(find.textContaining("It was"), findsNothing);
    }
  });
}
