import "package:cube_timer/cube_timer.dart";
import "package:cupertino_ui/cupertino_ui.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_svg/flutter_svg.dart";
import "package:forui/forui.dart";
import "package:go_router/go_router.dart";

import "home/sidebar.home.dart";

class PageFrame extends StatelessWidget {
  const PageFrame({super.key, required this.pages, required this.navigationShell});
  final List<({String name, IconData icon, String path})> pages;
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final dao = context.read<AppDatabase>().appStateDao;

    return FScaffold(
      header: Padding(
        padding: theme.headerStyles.nested.padding,
        child: FHeader.nested(
          style: .delta(
            decoration: .shapeDelta(
              color: theme.colors.background,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: theme.colors.border),
                borderRadius: theme.style.borderRadius.md,
              ),
            ),
          ),
          titleAlignment: .center,
          title: FTappable(
            onPress: () => showFDialog(
              context: context,
              builder: (_, style, animation) => PuzzleSelectionDialog(style: style, animation: animation),
            ),
            child: StreamBuilder<AppStateEntry>(
              stream: dao.watch(),
              initialData: null,
              builder: (context, snapshot) {
                // A failed stream is not a slow one. watchSingle() errors when
                // the row it expects is missing, and without this branch that
                // arrives as a spinner that never stops — the same thing the
                // user sees while the first row is still loading.
                if (snapshot.error case final error?) {
                  FlutterError.reportError(
                    FlutterErrorDetails(
                      exception: error,
                      stack: snapshot.stackTrace,
                      library: "mochi cube timer",
                      context: ErrorDescription("watching the app state for the header title"),
                    ),
                  );
                  return Icon(FLucideIcons.triangleAlert, color: theme.colors.destructive);
                }

                final data = snapshot.data;
                if (data == null) return const FCircularProgress();

                return Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: .center,
                  children: [
                    Text(data.puzzle.displayName, style: theme.typography.display.md),
                    Text(
                      "<Session Name>",
                      style: theme.typography.display.sm.copyWith(color: theme.colors.mutedForeground),
                    ),
                  ],
                );
              },
            ),
          ),
          prefixes: [
            FHeaderAction(
              icon: const Icon(FLucideIcons.menu),
              onPress: () => showFSheet(context: context, side: .ltr, builder: (context) => HomeSidebar()),
            ),
          ],
          suffixes: [
            FHeaderAction(
              icon: const Icon(FLucideIcons.shapes),
              onPress: () {
                // TODO: sessions
              },
            ),
          ],
        ),
      ),
      footer: FBottomNavigationBar(
        index: navigationShell.currentIndex,
        onChange: (value) {
          navigationShell.goBranch(value);
        },
        children: pages
            .map((data) => FBottomNavigationBarItem(label: Text(data.name), icon: Icon(data.icon)))
            .toList(),
      ),
      child: navigationShell,
    );
    // );
  }
}

class PuzzleSelectionDialog extends StatelessWidget {
  final FDialogStyleDelta style;
  final Animation<double> animation;
  const PuzzleSelectionDialog({super.key, required this.style, required this.animation});

  void _select(BuildContext context, Puzzle puzzle) {
    context.read<AppDatabase>().appStateDao.setPuzzle(puzzle);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return FDialog(
      style: style,
      animation: animation,
      builder: (context, style) => Padding(
        padding: const .all(20),
        child: Column(
          mainAxisSize: .min,
          spacing: 16,
          children: [
            Padding(
              padding: const .all(8),
              child: DefaultTextStyle.merge(
                style: style.titleTextStyle,
                child: const Text("Select a puzzle"),
              ),
            ),
            // Flexible plus shrinkWrap so the dialog hugs its content, and only
            // scrolls on a screen too short to fit every puzzle. Expanded would
            // stretch it to the full screen height instead.
            Flexible(
              child: GridView.builder(
                shrinkWrap: true,
                padding: .zero,
                itemCount: Puzzle.values.length,
                // mainAxisExtent sets the cell height outright. Without it the
                // delegate falls back to childAspectRatio, which derives the
                // height from the width and makes every other value guesswork.
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisExtent: 92,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 16,
                ),
                // HACK: currently the scrambler of `sq1`, `skewb`, `minx`, `fto`, `777`, `666`, `555`, `444` is not completed, so we return null for them.
                itemBuilder: (context, index) => _PuzzleTile(
                  puzzle: Puzzle.values[index],
                  style: style,
                  onPress:
                      {
                        "sq1",
                        "skewb",
                        "minx",
                        "fto",
                        "777",
                        "666",
                        "555",
                        "444",
                      }.contains(Puzzle.values[index].id)
                      ? null
                      : () => _select(context, Puzzle.values[index]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// One puzzle in the picker: icon over label, greyed out when [onPress] is null.
///
/// Sizing belongs to the grid, not here — the cell arrives with tight
/// constraints, so the icon is given an explicit size and the column centres
/// itself in whatever height the delegate hands over.
class _PuzzleTile extends StatelessWidget {
  const _PuzzleTile({required this.puzzle, required this.style, this.onPress});

  final Puzzle puzzle;
  final FDialogStyle style;
  final VoidCallback? onPress;

  /// Greyscale at half opacity: how a puzzle reads when it has no scrambler yet.
  ///
  /// The first three rows replace every channel with the same luma, which drains
  /// the colour out; the fourth halves the alpha. One matrix rather than a
  /// [ColorFiltered] wrapped in an [Opacity], so a tile costs one save layer
  /// instead of two.
  static const _disabledFilter = ColorFilter.matrix(<double>[
    0.2126, 0.7152, 0.0722, 0, 0, //
    0.2126, 0.7152, 0.0722, 0, 0, //
    0.2126, 0.7152, 0.0722, 0, 0, //
    0, 0, 0, 0.5, 0, //
  ]);

  @override
  Widget build(BuildContext context) {
    Widget content = Column(
      mainAxisAlignment: .center,
      spacing: 4,
      children: [
        SvgPicture.asset("assets/cube_icons/${puzzle.id}.svg", width: 48, height: 48),
        Text(
          puzzle.displayName,
          textAlign: .center,
          maxLines: 2,
          overflow: .ellipsis,
          style: style.bodyTextStyle,
        ),
      ],
    );

    // Filtering the whole tile rather than the icon alone, so the label dims
    // with it and the two never disagree about whether the puzzle is available.
    if (onPress == null) {
      content = ColorFiltered(colorFilter: _disabledFilter, child: content);
    }

    return FTappable(onPress: onPress, semanticsLabel: puzzle.displayName, child: content);
  }
}

// TODO: change the colors of the puzzles according to the theme
class PuzzleColors extends ColorMapper {
  const PuzzleColors({required this.outer, required this.inner, required this.symbol});

  final Color outer, inner, symbol;

  @override
  Color substitute(String? id, String elementName, String attributeName, Color color) {
    if (color == const Color(0xFF3F82FF)) return outer;
    if (color == const Color(0xFF80A8FF)) return inner;
    if (color == const Color(0xFFD3F5FF)) return symbol;
    return color;
  }

  @override
  bool operator ==(Object other) =>
      other is PuzzleColors && other.outer == outer && other.inner == inner && other.symbol == symbol;

  @override
  int get hashCode => Object.hash(outer, inner, symbol);
}
