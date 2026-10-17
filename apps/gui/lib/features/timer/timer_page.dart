import "package:cube_timer/cube_timer.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:mochi_ui/mochi_ui.dart";

import "../../database/dao_provider.dart";
import "../../l10n/l10n.dart";
import "../../shared/puzzles.dart";
import "../../shared/utils.dart";
import "../../theme.dart";
import "../records/search_bar/record_add_dialog.dart";
import "alert.dart";
import "scramble_cubit.dart";
import "timer_body.dart";
import "timer_focus.dart";

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

  /// What the solve on screen broke; the timer shows it and rings for it.
  final _recordBreak = ValueNotifier<RecordBreak?>(null);

  /// The best averages it set, which the timer shows and the statistics beside it light up.
  final _averageBreaks = ValueNotifier<List<AverageBreak>>(const []);

  @override
  void dispose() {
    _recordBreak.dispose();
    _averageBreaks.dispose();
    super.dispose();
  }

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

  Widget _statusLine(String label, String value, {bool highlight = false}) {
    final style = context.theme.typography.body.sm.copyWith(
      fontFeatures: const [FontFeature.tabularFigures()],
      color: highlight ? context.colors.primary.base : null,
      fontWeight: highlight ? .bold : null,
      decoration: highlight ? .underline : null,
    );
    return Row(
      mainAxisSize: .min,
      children: [
        Text("$label:", style: style),
        const SizedBox(width: 8),
        Text(value, style: style),
      ],
    );
  }

  void _record(TimerState state) async {
    final bloc = context.read<TimerBloc>();
    final scrambles = context.read<ScrambleCubit>();
    final dao = context.read<AppDatabase>().recordsDao;
    final scramble = await scrambles.state;
    // Read before the solve is written, or it would be compared with itself.
    final extremes = await dao.extremes(widget.sessionId, widget.puzzle);
    final times = await dao.watchTimes(widget.sessionId, widget.puzzle).first;

    bloc.add(TimerRecorded(sessionId: widget.sessionId, puzzle: widget.puzzle, notation: scramble.notation));

    scrambles.next();
    _announce(
      bloc,
      extremes.breakBy(state.elapsed, state.penalty),
      averageBreaks(times, (
        time: (state.elapsed + (state.penalty == .plus2 ? 2000 : 0)).toDouble(),
        isDnf: state.penalty == .dnf,
      )),
    );
  }

  void _announce(TimerBloc bloc, RecordBreak? record, List<AverageBreak> averages) {
    final settings = widget.settings;
    final l10n = context.l10n;
    // The solve may have been reset while it was being looked up, and its record shown to the next.
    if (!mounted || bloc.state is! TimerRunComplete) return;

    final said = <String>[];
    if (record != null && (record.kind == .best ? settings.recordBestAlert : settings.recordWorstAlert)) {
      _recordBreak.value = record;
      said.add(record.kind == .best ? l10n.speakNewBest : l10n.speakWorst);
      if (record.kind == .best && settings.vibrates) buzz(duration: 100);
    }
    // Only shown and said, not buzzed: a best average is not the thing to look up from the cube for.
    if (settings.recordAverageAlert) {
      _averageBreaks.value = averages;
      if (averages.isNotEmpty) {
        said.add(l10n.speakAverages(averages.map((b) => b.kind.label).join(l10n.speakAnd)));
      }
    }
    // One sentence, as a second would cut off the first.
    if (said.isNotEmpty && settings.speaks) {
      speak(said.join(". "), l10n);
    }
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
        return Text(context.l10n.timerScrambleFailed("${snapshot.error}"));
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

    Widget page(bool running) => Padding(
      padding: context.theme.geometry.pagePadding,
      child: BlocListener<TimerBloc, TimerState>(
        listenWhen: (previous, current) => previous is! TimerRunComplete && current is TimerRunComplete,
        listener: (context, state) => _record(state),
        child: MochiScaffold(
          immersive: running,
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
              Row(
                mainAxisSize: .max,
                mainAxisAlignment: .spaceBetween,
                children: [
                  MochiButton.icon(
                    size: .sm,
                    intent: .neutral,
                    icon: Icon(TablerIcons.squarePlus),
                    tooltip: context.l10n.searchAddRecord,
                    onPress: () async {
                      final answer = await showAddRecordModal(context);
                      if (answer == null) return;

                      if (context.mounted) {
                        showMochiToast(context, title: Text(context.l10n.timerRecordAdded));
                      }
                    },
                  ),
                  MochiActionBar([
                    MochiAction(
                      icon: TablerIcons.pencil,
                      label: context.l10n.timerEditScramble,
                      onPress: () async {
                        final newScramble = await showMochiPrompt(
                          context,
                          title: context.l10n.timerEnterScramble,
                          hint: context.l10n.timerScrambleHint,
                        );
                        if (newScramble != null && context.mounted) {
                          context.read<ScrambleCubit>().add(newScramble);
                        }
                      },
                    ),
                    MochiAction(
                      icon: TablerIcons.chevronLeft,
                      label: context.l10n.timerPreviousScramble,
                      onPress: scrambles.hasPrevious ? scrambles.previous : null,
                    ),
                    MochiAction(
                      icon: TablerIcons.chevronRight,
                      label: context.l10n.timerNextScramble,
                      onPress: scrambles.next,
                    ),
                  ], maxVisible: 3),
                ],
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
                          _statusLine(context.l10n.statDeviation, _statsDisplay(summary.deviation)),
                          _statusLine(context.l10n.statMean, _statsDisplay(summary.mean)),
                          _statusLine(context.l10n.statBest, _statsDisplay(summary.best)),
                          _statusLine(context.l10n.statCount, summary.count.toString()),
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
                      return ValueListenableBuilder(
                        valueListenable: _averageBreaks,
                        builder: (context, broken, _) {
                          Widget average(AverageKind kind) => _statusLine(
                            kind.label,
                            _statsDisplay(kind.of(times)),
                            highlight: broken.any((b) => b.kind == kind),
                          );

                          return Column(
                            mainAxisSize: .min,
                            crossAxisAlignment: .end,
                            textDirection: .ltr,
                            children: [
                              average(.mo3),
                              average(.ao5),
                              average(.ao12),
                              _statusLine("Ao50", _statsDisplay(times.ao(50))),
                              // _statusLine("Ao100", _statsDisplay(times.ao(100))),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          child: Center(
            child: TimerBody(
              alertText: widget.settings.alertEnabled && widget.settings.alertTypes.contains(AlertType.text),
              settings: widget.settings,
              recordBreak: _recordBreak,
              averageBreaks: _averageBreaks,
            ),
          ),
        ),
      ),
    );

    return BlocListener<TimerBloc, TimerState>(
      listenWhen: (previous, current) => previous.runtimeType != current.runtimeType,
      listener: (context, state) {
        context.read<TimerFocusCubit>().follow(state);
        if (state is! TimerRunComplete) {
          _recordBreak.value = null;
          _averageBreaks.value = const [];
        }
      },
      child: InspectionAlerts(
        settings: widget.settings,
        child: BlocBuilder<TimerFocusCubit, bool>(
          builder: (context, running) => Stack(
            children: [
              page(running),
              // While a solve runs, a press anywhere stops it, not only on the time. Kept on the
              // tree so the press that stops it is still let go here.
              Positioned.fill(
                child: IgnorePointer(ignoring: !running, child: const TimerPressArea()),
              ),
              if (running)
                Positioned(
                  top: 0,
                  right: 0,
                  child: SafeArea(
                    child: Padding(
                      padding: context.theme.geometry.pagePadding,
                      child: MochiButton.icon(
                        icon: const Icon(TablerIcons.circleX),
                        onPress: () => context.read<TimerBloc>().add(TimerCanceled()),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
