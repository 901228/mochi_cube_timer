import "package:cube_timer/cube_timer.dart";
import "package:flutter/widgets.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:mochi_ui/mochi_ui.dart";

import "../../shared/puzzles.dart";
import "../../shared/utils.dart";
import "../../theme.dart";
import "timer_body.dart";

class TimerPage extends StatelessWidget {
  const TimerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final db = context.read<AppDatabase>();

    return BlocProvider(
      create: (context) => TimerBloc(
        ticker: const Ticker(),
        recordsDao: db.recordsDao,
        config: db.settingsDao.watch().map(
          (settings) => TimerConfig(
            inspectionEnabled: settings.inspectionEnabled,
            inspectionDuration: Duration(seconds: settings.inspectDuration),
          ),
        ),
      ),
      child: StreamBuilder(
        stream: db.settingsDao.watch(),
        builder: (context, snapshot) {
          final w = streamHandler(context, snapshot, description: "watching the settings for the timer page");
          if (w != null) return w;

          final settings = snapshot.data!;
          return StreamBuilder(
            stream: db.appStateDao.watch(),
            builder: (context, snapshot) {
              final w = streamHandler(
                context,
                snapshot,
                description: "watching the app state for the timer page",
              );
              if (w != null) return w;

              final data = snapshot.data!;
              return _TimerView(puzzle: data.puzzle, sessionId: data.session.id, settings: settings);
            },
          );
        },
      ),
    );
  }
}

class _TimerView extends StatefulWidget {
  const _TimerView({required this.puzzle, required this.sessionId, required this.settings});

  final Puzzle puzzle;
  final String sessionId;
  final SettingsEntry settings;

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
      setState(() {
        // change scramble
        _history = ScrambleHistory(widget.puzzle);

        // reset bloc
        context.read<TimerBloc>().add(TimerReset());
      });
    }
  }

  /// Both the scramble text and the thumbnail open the same viewer, so there is
  /// one way a puzzle gets enlarged rather than two that look alike.
  void _showScramble(Scramble scramble) =>
      showScrambleModal(context, puzzle: widget.puzzle, scramble: scramble, settings: widget.settings);

  void _previous() => setState(_history.previous);
  void _next() => setState(_history.next);

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

  void _record(TimerState state) async {
    final bloc = context.read<TimerBloc>();
    final scramble = await _history.current;

    bloc.add(TimerRecorded(sessionId: widget.sessionId, puzzle: widget.puzzle, notation: scramble.notation));

    _next();
    // TODO: break record animation (or notification)
  }

  Widget _withScramble(Widget Function(Scramble scramble) builder) => FutureBuilder(
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
        return const MochiCircularProgress();
      }

      return builder(scramble);
    },
  );

  @override
  Widget build(BuildContext context) {
    return BlocListener<TimerBloc, TimerState>(
      listenWhen: (previous, current) => previous is! TimerRunComplete && current is TimerRunComplete,
      listener: (context, state) => _record(state),
      child: MochiScaffold(
        header: Column(
          mainAxisSize: .min,
          children: [
            _withScramble(
              (scramble) => MochiTappable(
                onPress: () => _showScramble(scramble),
                // The size lives on the DefaultTextStyle rather than on the
                // moves, so a hero's flight can read it off this context and
                // lerp towards the one the dialog uses. The weight is left
                // alone: ScrambleTokens sets its own, the same at both ends.
                builder: (context, value, child) => DefaultTextStyle.merge(
                  style: context.theme.timer.lg,
                  child: ScrambleTokens(
                    puzzle: widget.puzzle,
                    steps: widget.puzzle.scrambler.stepsOf(scramble),
                  ),
                ),
              ),
            ),
            Align(
              alignment: .centerEnd,
              child: MochiActionBar([
                MochiAction(
                  icon: TablerIcons.pencil,
                  label: "Edit scramble",
                  onPress: () {
                    // TODO: manually input the scramble
                  },
                ),
                MochiAction(
                  icon: TablerIcons.chevronLeft,
                  label: "Previous scramble",
                  onPress: _history.hasPrevious ? _previous : null,
                ),
                MochiAction(icon: TablerIcons.chevronRight, label: "Next scramble", onPress: _next),
              ], maxVisible: 3),
            ),
          ],
        ),
        footer: IntrinsicHeight(
          child: Row(
            mainAxisSize: .max,
            mainAxisAlignment: .spaceBetween,
            crossAxisAlignment: .stretch,
            children: [
              // left stats
              Expanded(
                child: Column(
                  mainAxisSize: .min,
                  crossAxisAlignment: .start,
                  textDirection: .ltr,
                  children: [
                    // TODO: stats
                    _statusLine("Deviation", "0.74"),
                    _statusLine("Mean", "1.50"),
                    _statusLine("Best", "0.27"),
                    _statusLine("Count", "6"),
                  ],
                ),
              ),

              // cube 2d view
              _withScramble(
                (scramble) => MochiTappable(
                  onPress: () => _showScramble(scramble),
                  builder: (context, value, child) =>
                      Cube2DView(puzzle: _history.puzzle, state: scramble.state, settings: widget.settings),
                ),
              ),

              // right stats
              Expanded(
                child: Column(
                  mainAxisSize: .min,
                  crossAxisAlignment: .end,
                  textDirection: .ltr,
                  children: [
                    // TODO: stats
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

        child: Center(child: TimerBody()),
      ),
    );
  }
}
