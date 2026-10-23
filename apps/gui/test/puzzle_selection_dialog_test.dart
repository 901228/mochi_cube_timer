import "package:cube_timer/cube_timer.dart";
import "package:drift/native.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mochi_cube_timer_gui/features/home/puzzle_selection_dialog.dart";
import "package:mochi_cube_timer_gui/l10n/app_localizations.dart";
import "package:mochi_ui/mochi_ui.dart";

void main() {
  testWidgets("the segmented control switches between the puzzles and the algorithm practice", (
    tester,
  ) async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(() => tester.runAsync(db.close));

    await tester.pumpWidget(
      RepositoryProvider.value(
        value: db,
        child: MochiApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale("en"),
          home: const MochiScaffold(child: PuzzleSelectionDialog()),
        ),
      ),
    );
    await tester.pump();

    final height = tester.getSize(find.byType(IndexedStack)).height;
    expect(find.text("3x3"), findsOneWidget);
    expect(find.text("Algorithm practice is not available yet"), findsNothing);

    await tester.tap(find.text("Algorithms"));
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text("3x3"), findsNothing);
    expect(find.text("Algorithm practice is not available yet"), findsOneWidget);
    // Not shorter than the puzzles, or the dialog would jump as the tab changes.
    expect(tester.getSize(find.byType(IndexedStack)).height, height);

    await tester.tap(find.text("Puzzles"));
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text("3x3"), findsOneWidget);
  });
}
