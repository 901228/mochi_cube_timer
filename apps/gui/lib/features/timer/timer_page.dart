import "package:cube_timer/cube_timer.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:mochi_ui/mochi_ui.dart";

import "../../database/dao_provider.dart";
import "../../shared/puzzles.dart";
import "../../shared/utils.dart";
import "../../theme.dart";
import "scramble_cubit.dart";
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
          final data = AppStateProvider.of(context);
          return _TimerView(puzzle: data.puzzle, sessionId: data.session.id, settings: settings);
        },
      ),
    );
  }
}

class _TimerView extends StatefulWidget {
  final Puzzle puzzle;
  final String sessionId;
  final SettingsEntry settings;
  const _TimerView({required this.puzzle, required this.sessionId, required this.settings});

  @override
  State<_TimerView> createState() => _TimerViewState();
}

class _TimerViewState extends State<_TimerView> {
  late Stream<SessionSummary> _summary;
  late Stream<List<SolveTime>> _times;

  void _watchStats() {
    final dao = context.read<AppDatabase>().recordsDao;
    _summary = dao.watchSummary(widget.sessionId, widget.puzzle);
    _times = dao.watchTimes(widget.sessionId, widget.puzzle, limit: 50);
  }

  @override
  void initState() {
    super.initState();
    _watchStats();
  }

  @override
  void didUpdateWidget(_TimerView oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.puzzle != widget.puzzle) {
      // the scramble follows the puzzle in ScrambleCubit
      context.read<TimerBloc>().add(TimerReset());
    }

    if (oldWidget.sessionId != widget.sessionId || oldWidget.puzzle != widget.puzzle) {
      // update stats
      _watchStats();
    }
  }

  /// Both the scramble text and the thumbnail open the same viewer, so there is
  /// one way a puzzle gets enlarged rather than two that look alike.
  void _showScramble(Scramble scramble) =>
      showScrambleModal(context, puzzle: widget.puzzle, scramble: scramble, settings: widget.settings);

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
    final scrambles = context.read<ScrambleCubit>();
    final scramble = await scrambles.state;

    bloc.add(TimerRecorded(sessionId: widget.sessionId, puzzle: widget.puzzle, notation: scramble.notation));

    scrambles.next();
    // TODO: break record animation (or notification)
  }

  Widget _withScramble(Widget Function(Scramble scramble) builder) => FutureBuilder(
    // Keyed on the history, so switching puzzles starts a fresh
    // builder. FutureBuilder keeps the old snapshot's data when its
    // future changes, which would pair the previous puzzle's scramble
    // with the new puzzle for a frame.
    key: ValueKey(context.watch<ScrambleCubit>().puzzle),
    future: context.watch<ScrambleCubit>().state,
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

  String _statsDisplay(double? value) {
    if (value == null) return "--";
    if (value == double.infinity) return "DNF";

    return (value / 1000).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    final scrambles = context.watch<ScrambleCubit>();

    return Padding(
      padding: context.theme.geometry.pagePadding,
      child: BlocListener<TimerBloc, TimerState>(
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
                    onPress: () async {
                      final newScramble = await showMochiPrompt(
                        context,
                        title: "Enter scramble",
                        hint: "Scramble",
                      );
                      if (newScramble != null && context.mounted) {
                        context.read<ScrambleCubit>().add(newScramble);
                      }
                    },
                  ),
                  MochiAction(
                    icon: TablerIcons.chevronLeft,
                    label: "Previous scramble",
                    onPress: scrambles.hasPrevious ? scrambles.previous : null,
                  ),
                  MochiAction(
                    icon: TablerIcons.chevronRight,
                    label: "Next scramble",
                    onPress: scrambles.next,
                  ),
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
                  child: StreamBuilder(
                    stream: _summary,
                    builder: (context, snapshot) {
                      final w = streamHandler(
                        context,
                        snapshot,
                        description: "watching the summary of the session",
                      );
                      if (w != null) return w;

                      final summary = snapshot.data!;
                      return Column(
                        mainAxisSize: .min,
                        crossAxisAlignment: .start,
                        textDirection: .ltr,
                        children: [
                          _statusLine("Deviation", _statsDisplay(summary.deviation)),
                          _statusLine("Mean", _statsDisplay(summary.mean)),
                          _statusLine("Best", _statsDisplay(summary.best)),
                          _statusLine("Count", summary.count.toString()),
                        ],
                      );
                    },
                  ),
                ),

                // cube 2d view
                _withScramble(
                  (scramble) => MochiTappable(
                    onPress: () => _showScramble(scramble),
                    builder: (context, value, child) => Cube2DView(
                      puzzle: scrambles.puzzle,
                      state: scramble.state,
                      settings: widget.settings,
                    ),
                  ),
                ),

                // right stats
                Expanded(
                  child: StreamBuilder(
                    stream: _times,
                    builder: (context, snapshot) {
                      final w = streamHandler(
                        context,
                        snapshot,
                        description: "watching the times of the session",
                      );
                      if (w != null) return w;

                      final times = snapshot.data!;
                      return Column(
                        mainAxisSize: .min,
                        crossAxisAlignment: .end,
                        textDirection: .ltr,
                        children: [
                          _statusLine("Mo3", _statsDisplay(times.mo(3))),
                          _statusLine("Ao5", _statsDisplay(times.ao(5))),
                          _statusLine("Ao12", _statsDisplay(times.ao(12))),
                          _statusLine("Ao50", _statsDisplay(times.ao(50))),
                          // _statusLine("Ao100", _statsDisplay(times.ao(100))),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          child: Center(child: TimerBody()),
        ),
      ),
    );
  }
}
