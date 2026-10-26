import "package:collection/collection.dart";
import "package:cube_timer/cube_timer.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:mochi_ui/mochi_ui.dart";
import "package:stream_transform/stream_transform.dart";

import "../../database/dao_provider.dart";
import "../../l10n/l10n.dart";
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

  bool get isDesktop => context.responsive(mobile: false, desktop: true);

  /// A number that counts up from 0, and again whenever what it shows changes to another session,
  /// puzzle or archive view, rather than counting from the previous one's figure.
  Widget _number(
    String id,
    double? value, {
    TextStyle? style,
    String Function(double value)? format,
    Alignment? alignment,
  }) => Align(
    alignment: alignment ?? (isDesktop ? .center : .centerStart),
    child: MochiAnimatedNumber(
      key: ValueKey((widget.sessionId, widget.puzzle, id)),
      value: value,
      format: format ?? (v) => _statsString(v),
      fallback: _statsString(value == null || value.isFinite ? null : value),
      style: style,
    ),
  );

  MochiGeometry get geometry => context.theme.geometry;
  MochiColors get colors => context.theme.colors;
  MochiTypeface get timer => context.theme.timer;

  TextStyle timesStyle({Color? color}) => timer.xl4.copyWith(fontWeight: .bold, color: color);

  Widget _summaryText(String id, double? value, {Color? color, Alignment? alignment}) => _number(
    id,
    value,
    style: timesStyle(color: color),
    alignment: alignment,
  );

  Widget _card({required String title, required Widget child}) => MochiCard(
    elevation: .md,
    padding: .all(geometry.space.sm),
    title: Text(title, style: TextStyle(color: colors.mutedForeground)),
    titleGap: 0,
    child: child,
  );

  Widget _statsTile({required String id, required double? value, required String description}) =>
      DefaultTextHeightBehavior(
        textHeightBehavior: TextHeightBehavior(
          applyHeightToFirstAscent: false,
          applyHeightToLastDescent: false,
        ),
        child: Row(
          mainAxisSize: .max,
          mainAxisAlignment: .spaceBetween,
          children: [
            DefaultTextStyle(
              style: context.theme.typography.body.xs.copyWith(color: colors.mutedForeground),
              child: Text(description),
            ),
            _number(id, value, style: timesStyle()),
          ],
        ),
      );

  List<Widget> _bestAo5Times(List<double> values, int trimPercent) {
    final sortedValues = values.indexed.sorted((a, b) => a.$2.compareTo(b.$2));
    // The solves the average leaves out, at each end.
    final trimmed = {
      for (final e
          in sortedValues
              .take(trimmedCount(values.length, trimPercent))
              .followedBy(sortedValues.reversed.take(trimmedCount(values.length, trimPercent))))
        e.$1,
    };
    final style = timer.xl2.copyWith(fontWeight: .bold);

    Widget timesText(double? value, [bool firstLast = false]) {
      final valueString = _statsString(value);
      return Text(
        firstLast ? "($valueString)" : valueString,
        style: style.copyWith(color: firstLast ? colors.mutedForeground : null),
      );
    }

    return [for (final (i, value) in values.indexed) timesText(value, trimmed.contains(i))];
  }

  @override
  Widget build(BuildContext context) {
    final inset = MediaQuery.paddingOf(context);
    final contentPadding =
        inset +
        context.theme.geometry.pagePadding +
        EdgeInsets.symmetric(horizontal: geometry.space.sm, vertical: geometry.space.xs);

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
        final trim = SettingsProvider.of(context).averageTrim;

        final currentStats = _card(
          title: context.l10n.statsCurrent,
          child: Column(
            mainAxisAlignment: .spaceAround,
            children: [
              ("Mo3", data?.times.mo(3)),
              ("Ao5", data?.times.ao(5, trimPercent: trim)),
              ("Ao12", data?.times.ao(12, trimPercent: trim)),
              ("Ao50", data?.times.ao(50, trimPercent: trim)),
              ("Ao100", data?.times.ao(100, trimPercent: trim)),
            ].map((v) => _statsTile(id: "current ${v.$1}", value: v.$2, description: v.$1)).toList(),
          ),
        );
        final solveCount = _card(
          title: context.l10n.statsSolveCount,
          child: _number(
            "count",
            data?.summary.count.toDouble(),
            style: timer.xl5.copyWith(fontWeight: .bold),
            format: (v) => v.round().toString(),
          ),
        );
        final solveMean = _card(
          title: context.l10n.statsSolveMean,
          child: _summaryText("mean", data?.summary.mean),
        );
        final solveDeviation = _card(
          title: context.l10n.statsSolveDeviation,
          child: _summaryText("deviation", data?.summary.deviation),
        );
        final bestSingle = MochiCard(
          elevation: .md,
          color: colors.primary.base,
          padding: .all(geometry.space.sm),
          title: Text(context.l10n.statsBestSingle, style: TextStyle(color: colors.primary.soft)),
          titleGap: 0,
          child: _summaryText("best", data?.summary.best, color: colors.primary.onBase),
        );
        final bestStats = _card(
          title: context.l10n.statsBestStats,
          child: Column(
            mainAxisAlignment: .spaceAround,
            children: [
              ("Mo3", data?.times.bestMo(3)),
              ("Ao5", data?.times.bestAo(5, trimPercent: trim)),
              ("Ao12", data?.times.bestAo(12, trimPercent: trim)),
              if (isDesktop) ("Ao50", data?.times.bestAo(50, trimPercent: trim)),
              if (isDesktop) ("Ao10", data?.times.bestAo(100, trimPercent: trim)),
            ].map((v) => _statsTile(id: "best ${v.$1}", value: v.$2, description: v.$1)).toList(),
          ),
        );
        final bestAo5Data = data?.times.bestAoWithList(5, trimPercent: trim);
        final bestAo5 = _card(
          title: context.l10n.statsBestAo5,
          child: bestAo5Data == null
              ? Center(child: _summaryText("best ao5", null))
              : Column(
                  mainAxisAlignment: .spaceAround,
                  crossAxisAlignment: .start,
                  children: [
                    _summaryText(
                      "best ao5",
                      bestAo5Data.$1,
                      color: colors.primary.base,
                      alignment: .centerLeft,
                    ),
                    SizedBox(height: geometry.space.xs),
                    ..._bestAo5Times(bestAo5Data.$2, trim),
                  ],
                ),
        );

        // card group
        final best = Row(
          crossAxisAlignment: .stretch,
          spacing: geometry.space.sm,
          children: [
            Expanded(child: currentStats),
            Expanded(
              child: Column(
                mainAxisSize: .max,
                spacing: geometry.space.sm,
                children: [
                  Expanded(child: solveCount),
                  Expanded(child: solveMean),
                  Expanded(child: bestSingle),
                ],
              ),
            ),
          ],
        );
        final recordsGraph = MochiCard(
          elevation: .md,
          title: Text(context.l10n.statsSolveTimes),
          child: TimesGraph(data, aspectRatio: isDesktop ? 3 : 2),
        );
        final distrubutionGraph = MochiCard(
          elevation: .md,
          title: Text(context.l10n.statsDistribution),
          child: TimesDistributionGraph(data, aspectRatio: isDesktop ? 3 : 2),
        );

        return DefaultTextStyle.merge(
          textHeightBehavior: const TextHeightBehavior(
            applyHeightToFirstAscent: false,
            applyHeightToLastDescent: false,
          ),
          child: isDesktop
              ? Padding(
                  padding: contentPadding,
                  child: Row(
                    mainAxisSize: .max,
                    spacing: geometry.space.sm,
                    children: [
                      Flexible(
                        child: Column(
                          mainAxisSize: .max,
                          spacing: geometry.space.sm,
                          children: [
                            Expanded(child: best),
                            distrubutionGraph,
                          ],
                        ),
                      ),
                      Flexible(
                        child: Column(
                          mainAxisSize: .max,
                          spacing: geometry.space.sm,
                          children: [
                            recordsGraph,
                            Expanded(
                              child: Row(
                                crossAxisAlignment: .stretch,
                                spacing: geometry.space.sm,
                                children: [
                                  Expanded(child: bestStats),
                                  Expanded(
                                    child: Column(
                                      mainAxisSize: .max,
                                      spacing: geometry.space.sm,
                                      children: [
                                        Flexible(flex: 1, fit: .tight, child: solveDeviation),
                                        Flexible(flex: 3, fit: .tight, child: bestAo5),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  padding: contentPadding,
                  child: Column(
                    mainAxisSize: .min,
                    spacing: geometry.space.sm,
                    children: [
                      IntrinsicHeight(child: best),
                      recordsGraph,
                      IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: .stretch,
                          spacing: geometry.space.sm,
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisSize: .max,
                                spacing: geometry.space.sm,
                                children: [
                                  Expanded(child: solveDeviation),
                                  Expanded(child: bestStats),
                                ],
                              ),
                            ),
                            Expanded(child: bestAo5),
                          ],
                        ),
                      ),
                      distrubutionGraph,
                    ],
                  ),
                ),
        );
      },
    );
  }
}
