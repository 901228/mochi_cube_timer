import "package:collection/collection.dart";
import "package:cube_timer/cube_timer.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:mochi_ui/mochi_ui.dart";
import "package:stream_transform/stream_transform.dart";

import "../../database/dao_provider.dart";
import "../../shared/utils.dart";
import "../../theme.dart";
import "stats_common.dart";
import "times_distribution_graph.dart";
import "times_graph.dart";

class StatsPage extends StatelessWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final data = AppStateProvider.of(context);

    return _StatsPage(puzzle: data.puzzle, sessionId: data.session.id, showArchived: data.showArchived);
  }
}

class _StatsPage extends StatefulWidget {
  final Puzzle puzzle;
  final String sessionId;
  final bool showArchived;
  const _StatsPage({required this.puzzle, required this.sessionId, required this.showArchived});

  @override
  State<_StatsPage> createState() => _StatsPageState();
}

// TODO: number increasing animation ?

class _StatsPageState extends State<_StatsPage> {
  late Stream<StatsReturn> _stream;

  void _watchStats() {
    final dao = context.read<AppDatabase>().recordsDao;
    _stream = dao
        .watchSummary(widget.sessionId, widget.puzzle, showArchived: widget.showArchived)
        .combineLatest(
          dao.watchTimes(widget.sessionId, widget.puzzle, showArchived: widget.showArchived),
          (summary, times) => (summary: summary, times: times),
        );
  }

  @override
  void initState() {
    super.initState();
    _watchStats();
  }

  @override
  void didUpdateWidget(_StatsPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.sessionId != widget.sessionId ||
        oldWidget.puzzle != widget.puzzle ||
        oldWidget.showArchived != widget.showArchived) {
      // update stats
      _watchStats();
    }
  }

  String _statsString(double? value) {
    if (value == null) {
      return "--";
    } else if (value == double.infinity) {
      return "DNF";
    } else {
      return (value / 1000).toStringAsFixed(2);
    }
  }

  MochiGeometry get geometry => context.theme.geometry;
  MochiColors get colors => context.theme.colors;
  MochiTypeface get timer => context.theme.timer;

  TextStyle timesStyle({Color? color}) => timer.xl4.copyWith(fontWeight: .bold, color: color);

  Widget _summaryText(double? value, {Color? color}) =>
      Text(_statsString(value), style: timesStyle(color: color));

  Widget _card({required String title, required Widget child}) => MochiCard(
    elevation: .md,
    padding: .all(geometry.space.sm),
    title: Text(title, style: TextStyle(color: colors.mutedForeground)),
    titleGap: 0,
    child: child,
  );

  Widget _statsTile({required String title, required String description}) => DefaultTextHeightBehavior(
    textHeightBehavior: TextHeightBehavior(applyHeightToFirstAscent: false, applyHeightToLastDescent: false),
    child: Row(
      mainAxisSize: .max,
      mainAxisAlignment: .spaceBetween,
      children: [
        DefaultTextStyle(
          style: context.theme.typography.body.xs.copyWith(color: colors.mutedForeground),
          child: Text(description),
        ),
        DefaultTextStyle.merge(style: timesStyle(), child: Text(title)),
      ],
    ),
  );

  List<Widget> _bestAo5Times(List<double> values) {
    final sortedValues = values.indexed.sorted((a, b) => a.$2.compareTo(b.$2));
    final style = timer.xl2.copyWith(fontWeight: .bold);

    Widget timesText(double? value, [bool firstLast = false]) {
      final valueString = _statsString(value);
      return Text(
        firstLast ? "($valueString)" : valueString,
        style: style.copyWith(color: firstLast ? colors.mutedForeground : null),
      );
    }

    return [
      for (final (i, value) in values.indexed)
        timesText(value, i == sortedValues.first.$1 || i == sortedValues.last.$1),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final inset = MediaQuery.paddingOf(context);

    return StreamBuilder(
      stream: _stream,
      builder: (context, snapshot) {
        final w = streamHandler(
          context,
          snapshot,
          description: "watching the stats for the stats page",
          showCircularProgress: false,
        );
        if (w != null) return w;

        final data = snapshot.data;

        final currentStats = _card(
          title: "Current Stats",
          child: Column(
            mainAxisAlignment: .spaceAround,
            children: [
              ("Mo3", data?.times.mo(3)),
              ("Ao5", data?.times.ao(5)),
              ("Ao12", data?.times.ao(12)),
              ("Ao50", data?.times.ao(50)),
              ("Ao100", data?.times.ao(100)),
            ].map((v) => _statsTile(title: _statsString(v.$2), description: v.$1)).toList(),
          ),
        );
        final solveCount = _card(
          title: "Solve Count",
          child: Text(data?.summary.count.toString() ?? "--", style: timer.xl5.copyWith(fontWeight: .bold)),
        );
        final solveMean = _card(title: "Solve Mean", child: _summaryText(data?.summary.mean));
        final solveDeviation = _card(title: "Solve Deviation", child: _summaryText(data?.summary.deviation));
        final bestSingle = MochiCard(
          elevation: .md,
          color: colors.primary.base,
          padding: .all(geometry.space.sm),
          title: Text("Best Single", style: TextStyle(color: colors.primary.soft)),
          titleGap: 0,
          child: _summaryText(data?.summary.best, color: colors.primary.onBase),
        );
        final bestStats = _card(
          title: "Best Stats",
          child: Column(
            mainAxisAlignment: .spaceAround,
            children: [
              ("Mo3", data?.times.bestMo(3)),
              ("Ao5", data?.times.bestAo(5)),
              ("Ao12", data?.times.bestAo(12)),
            ].map((v) => _statsTile(title: _statsString(v.$2), description: v.$1)).toList(),
          ),
        );
        final bestAo5Data = data?.times.bestAoWithList(5);
        final bestAo5 = _card(
          title: "Best Ao5",
          child: bestAo5Data == null
              ? Center(child: _summaryText(null))
              : Column(
                  mainAxisAlignment: .spaceAround,
                  crossAxisAlignment: .start,
                  children: [
                    _summaryText(bestAo5Data.$1, color: colors.primary.base),
                    SizedBox(height: geometry.space.xs),
                    ..._bestAo5Times(bestAo5Data.$2),
                  ],
                ),
        );

        return DefaultTextStyle.merge(
          textHeightBehavior: const TextHeightBehavior(
            applyHeightToFirstAscent: false,
            applyHeightToLastDescent: false,
          ),
          child: SingleChildScrollView(
            padding:
                inset +
                context.theme.geometry.pagePadding +
                EdgeInsets.symmetric(horizontal: geometry.space.sm, vertical: geometry.space.xs),
            child: Column(
              mainAxisSize: .min,
              spacing: geometry.space.sm,
              children: [
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: .stretch,
                    spacing: geometry.space.sm,
                    children: [
                      Flexible(child: currentStats),
                      Flexible(
                        child: Column(
                          spacing: geometry.space.sm,
                          children: [solveCount, solveMean, bestSingle],
                        ),
                      ),
                    ],
                  ),
                ),
                MochiCard(elevation: .md, title: const Text("Solve Times"), child: TimesGraph(data)),
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: .stretch,
                    spacing: geometry.space.sm,
                    children: [
                      Flexible(
                        child: Column(spacing: geometry.space.sm, children: [solveDeviation, bestStats]),
                      ),
                      Flexible(child: bestAo5),
                    ],
                  ),
                ),
                MochiCard(
                  elevation: .md,
                  title: const Text("Time Distribution"),
                  child: TimesDistributionGraph(data),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
