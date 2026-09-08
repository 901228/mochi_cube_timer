import "package:cube_timer/cube_timer.dart";
import "package:cupertino_ui/cupertino_ui.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:forui/forui.dart";

import "../../widgets/cube_2dview.dart";
import "../../widgets/scramble_dialog.dart";

class TimerPage extends StatelessWidget {
  const TimerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final dao = context.read<AppDatabase>().appStateDao;

    return StreamBuilder<AppStateEntry>(
      stream: dao.watch(),
      builder: (context, snapshot) {
        // A failed stream is not a slow one; without this branch it arrives as
        // a spinner that never stops.
        if (snapshot.error case final error?) {
          FlutterError.reportError(
            FlutterErrorDetails(
              exception: error,
              stack: snapshot.stackTrace,
              library: "mochi cube timer",
              context: ErrorDescription("watching the app state for the timer page"),
            ),
          );
          return Center(child: Icon(FLucideIcons.triangleAlert, color: context.theme.colors.destructive));
        }

        final data = snapshot.data;
        if (data == null) return const Center(child: FCircularProgress());

        return _TimerView(puzzle: data.puzzle);
      },
    );
  }
}

class _TimerView extends StatefulWidget {
  const _TimerView({required this.puzzle});

  final Puzzle puzzle;

  @override
  State<_TimerView> createState() => _TimerViewState();
}

class _TimerViewState extends State<_TimerView> {
  late ScrambleHistory _history;

  @override
  void initState() {
    super.initState();
    _history = ScrambleHistory(widget.puzzle);
  }

  @override
  void didUpdateWidget(_TimerView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.puzzle != widget.puzzle) {
      setState(() => _history = ScrambleHistory(widget.puzzle));
    }
  }

  /// Both the scramble text and the thumbnail open the same viewer, so there is
  /// one way a puzzle gets enlarged rather than two that look alike.
  void _showScramble(Scramble scramble) =>
      showScrambleDialog(context, puzzle: widget.puzzle, scramble: scramble);

  void _previous() => setState(_history.previous);
  void _next() => setState(_history.next);

  FHeaderActionStyle get action => context.theme.headerStyles.nested.actionStyle;
  double get spacing => context.theme.headerStyles.nested.actionSpacing;
  Widget _actionButton(IconData icon, VoidCallback? onPress) => FTappable(
    style: action.tappableStyle,
    onPress: onPress,
    child: Padding(
      padding: action.padding,
      child: IconTheme(
        data: onPress == null
            ? (action.iconStyle.variants[FTappableVariant.disabled] ?? action.iconStyle.base)
            : action.iconStyle.base,
        child: Icon(icon),
      ),
    ),
  );

  Widget _statusLine(String label, String value) => Row(
    mainAxisSize: .min,
    children: [
      Text(
        "$label:",
        style: context.theme.typography.body.sm.copyWith(fontFeatures: const [FontFeature.tabularFigures()]),
      ),
      const SizedBox(width: 8),
      Text(
        value,
        style: context.theme.typography.body.sm.copyWith(fontFeatures: const [FontFeature.tabularFigures()]),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return FScaffold(
      childPad: false,
      header: Padding(
        padding: context.theme.style.pagePadding,
        child: Column(
          mainAxisSize: .min,
          children: [
            FutureBuilder(
              // Keyed on the history, so switching puzzles starts a fresh
              // builder. FutureBuilder keeps the old snapshot's data when its
              // future changes, which would pair the previous puzzle's scramble
              // with the new puzzle for a frame.
              key: ObjectKey(_history),
              future: _history.current,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text("打亂失敗：${snapshot.error}");
                }

                final scramble = snapshot.data;
                if (scramble == null) {
                  return const FCircularProgress();
                }

                return FTappable(
                  onPress: () => _showScramble(scramble),
                  // The size lives on the DefaultTextStyle rather than on the
                  // moves, so a hero's flight can read it off this context and
                  // lerp towards the one the dialog uses. The weight is left
                  // alone: ScrambleTokens sets its own, the same at both ends.
                  child: DefaultTextStyle.merge(
                    style: context.theme.typography.display.lg,
                    child: ScrambleTokens(
                      puzzle: widget.puzzle,
                      steps: widget.puzzle.scrambler.stepsOf(scramble),
                    ),
                  ),
                );
              },
            ),
            Row(
              mainAxisSize: .max,
              mainAxisAlignment: .end,
              children: [
                _actionButton(FLucideIcons.pencil, () {
                  // TODO: manually input the scramble
                }),
                _actionButton(FLucideIcons.chevronLeft, _history.hasPrevious ? _previous : null),
                _actionButton(FLucideIcons.chevronRight, _next),
              ],
            ),
          ],
        ),
      ),
      footer: IntrinsicHeight(
        child: Row(
          mainAxisSize: .max,
          mainAxisAlignment: .spaceBetween,
          crossAxisAlignment: .stretch,
          children: [
            Expanded(
              child: Column(
                mainAxisSize: .min,
                crossAxisAlignment: .start,
                textDirection: .ltr,
                children: [
                  _statusLine("Deviation", "0.74"),
                  _statusLine("Mean", "1.50"),
                  _statusLine("Best", "0.27"),
                  _statusLine("Count", "6"),
                ],
              ),
            ),
            Cube2DView(history: _history, onPress: _showScramble),
            Expanded(
              child: Column(
                mainAxisSize: .min,
                crossAxisAlignment: .end,
                textDirection: .ltr,
                children: [
                  _statusLine("Ao5", "1.43"),
                  _statusLine("Ao12", "--"),
                  _statusLine("Ao50", "--"),
                  _statusLine("Ao100", "--"),
                ],
              ),
            ),
          ],
        ),
      ),
      child: Container(color: Color(0xff00ff00), alignment: .center, child: Text("0.000")),
    );
  }
}
