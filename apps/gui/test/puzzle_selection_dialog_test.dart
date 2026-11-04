import "package:cube_timer/cube_timer.dart";
import "package:drift/native.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mochi_cube_timer_gui/database/dao_provider.dart";
import "package:mochi_cube_timer_gui/features/home/puzzle_selection_dialog.dart";
import "package:mochi_cube_timer_gui/l10n/app_localizations.dart";
import "package:mochi_ui/mochi_ui.dart";

void main() {
  testWidgets("the segmented control switches between the puzzles and the algorithm practice", (
    tester,
  ) async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(() => tester.runAsync(db.close));
    final settings = (await tester.runAsync(() => db.settingsDao.watch().first))!;

    await tester.pumpWidget(
      RepositoryProvider.value(
        value: db,
        child: MochiApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale("en"),
          home: SettingsProvider(
            state: settings,
            child: const MochiScaffold(child: PuzzleSelectionDialog()),
          ),
        ),
      ),
    );
    await tester.pump();

    final height = tester.getSize(find.byType(IndexedStack)).height;
    expect(find.text("Megaminx"), findsOneWidget);
    expect(find.text("PLL"), findsNothing);

    await tester.tap(find.text("Algorithms"));
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text("Megaminx"), findsNothing);
    // The sets are folded under their puzzle, none open.
    expect(find.text("PLL"), findsNothing);
    // Not shorter than the puzzles, or the dialog would jump as the tab changes.
    expect(tester.getSize(find.byType(IndexedStack)).height, height);

    await tester.tap(find.text("3x3"));
    await tester.pumpAndSettle();
    expect(find.text("Cross"), findsOneWidget);
    // One puzzle open at a time.
    await tester.tap(find.text("2x2"));
    await tester.pumpAndSettle();
    expect(find.text("PLL"), findsNothing);
    await tester.tap(find.text("3x3"));
    await tester.pumpAndSettle();
    await tester.tap(find.text("PLL"));
    await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 50)));
    final state = (await tester.runAsync(() => db.appStateDao.current))!;
    expect((state.puzzle, state.algorithmSet), (Puzzle.cube3, "pll"));
  });

  testWidgets("the puzzles tab picks a puzzle", (tester) async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(() => tester.runAsync(db.close));
    final settings = (await tester.runAsync(() => db.settingsDao.watch().first))!;
    await tester.pumpWidget(
      RepositoryProvider.value(
        value: db,
        child: MochiApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale("en"),
          home: SettingsProvider(
            state: settings,
            child: const MochiScaffold(child: PuzzleSelectionDialog()),
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.tap(find.text("Algorithms"));
    await tester.pump(const Duration(milliseconds: 500));
    await tester.tap(find.text("Puzzles"));
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text("Megaminx"), findsOneWidget);
  });

  testWidgets("browsing the algorithms hands the set over instead of practising it", (tester) async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(() => tester.runAsync(db.close));
    final settings = (await tester.runAsync(() => db.settingsDao.watch().first))!;
    (Puzzle, String)? picked;
    await tester.pumpWidget(
      RepositoryProvider.value(
        value: db,
        child: MochiApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale("en"),
          home: SettingsProvider(
            state: settings,
            child: MochiScaffold(
              child: PuzzleSelectionDialog(onPickSet: (puzzle, set) => picked = (puzzle, set.id)),
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.tap(find.text("Algorithms"));
    await tester.pump(const Duration(milliseconds: 500));
    await tester.tap(find.text("3x3"));
    await tester.pumpAndSettle();
    // The Cross drill is only for practising.
    expect(find.text("Cross"), findsNothing);
    await tester.tap(find.text("PLL"));
    await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 50)));
    expect(picked, (Puzzle.cube3, "pll"));
    final state = (await tester.runAsync(() => db.appStateDao.current))!;
    expect((state.puzzle, state.algorithmSet), (Puzzle.cube3, null));
  });
}
