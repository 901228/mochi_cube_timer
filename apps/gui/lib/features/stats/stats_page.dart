import "package:collection/collection.dart";
import "package:cube_timer/cube_timer.dart";
import "package:flutter/widgets.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:mochi_ui/mochi_ui.dart";
import "package:stream_transform/stream_transform.dart";

import "../../database/dao_provider.dart";
import "../../shared/utils.dart";
import "../../theme.dart";

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

typedef _Stats = ({SessionSummary summary, List<double> times});

class _StatsPageState extends State<_StatsPage> {
  late Stream<_Stats> _stream;

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

  Widget _summaryText(double? value, {Color? color}) => Text(
    _statsString(value),
    style: timer.xl6.copyWith(fontWeight: .bold, color: color),
  );

  Widget _timesText(double? value) => Text(_statsString(value), style: timer.xl5.copyWith(fontWeight: .bold));

  Widget _card({required String title, required Widget child}) => MochiCard(
    padding: .all(geometry.space.sm),
    title: Text(title, style: TextStyle(color: colors.mutedForeground)),
    titleGap: 0,
    child: child,
  );

  List<Widget> _bestAo5Times(List<double> values) {
    final sortedValues = values.sorted((a, b) => a.compareTo(b));
    final style = timer.xl3.copyWith(fontWeight: .bold);

    Widget middleText(double? value) => Text(_statsString(value), style: style);

    Widget firstLastText(double? value) =>
        Text("(${_statsString(value)})", style: style.copyWith(color: colors.mutedForeground));

    final smallest = sortedValues.first;
    final largest = sortedValues.last;
    final middle = sortedValues.sublist(1, 4);
    return [firstLastText(smallest), for (final value in middle) middleText(value), firstLastText(largest)];
  }

  @override
  Widget build(BuildContext context) {
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

        final currentStats = [
          ("Mo3", data?.times.mo(3)),
          ("Ao5", data?.times.ao(5)),
          ("Ao12", data?.times.ao(12)),
          ("Ao50", data?.times.ao(50)),
          ("Ao100", data?.times.ao(100)),
        ];
        final summaryStats = [
          ("Solve Mean", data?.summary.mean),
          ("Solve Deviation", data?.summary.deviation),
        ];
        final bestStats = [
          ("Mo3", data?.times.bestMo(3)),
          ("Ao5", data?.times.bestAo(5)),
          ("Ao12", data?.times.bestAo(12)),
        ];
        final bestAo5 = data?.times.bestAoWithList(5);

        return DefaultTextStyle.merge(
          textHeightBehavior: const TextHeightBehavior(
            applyHeightToFirstAscent: false,
            applyHeightToLastDescent: false,
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: geometry.space.sm, vertical: geometry.space.xs),
              child: Column(
                mainAxisSize: .min,
                spacing: geometry.space.sm,
                children: [
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: .stretch,
                      spacing: geometry.space.sm,
                      children: [
                        Flexible(
                          child: _card(
                            title: "Current Stats",
                            child: MochiTileGroup(
                              divider: .none,
                              children: [
                                for (final (label, value) in currentStats)
                                  MochiTile(title: _timesText(value), details: Text(label)),
                              ],
                            ),
                          ),
                        ),
                        Flexible(
                          child: Column(
                            spacing: geometry.space.sm,
                            children: [
                              _card(
                                title: "Solve Count",
                                child: Text(
                                  data?.summary.count.toString() ?? "--",
                                  style: timer.xl6.copyWith(fontWeight: .bold),
                                ),
                              ),
                              for (final (label, value) in summaryStats)
                                _card(title: label, child: _summaryText(value)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: .stretch,
                      spacing: geometry.space.sm,
                      children: [
                        Flexible(
                          child: Column(
                            spacing: geometry.space.sm,
                            children: [
                              MochiCard(
                                color: colors.primary.base,
                                padding: .all(geometry.space.sm),
                                title: Text("Best Single", style: TextStyle(color: colors.foreground)),
                                titleGap: 0,
                                child: _summaryText(data?.summary.best, color: colors.primary.soft),
                              ),
                              _card(
                                title: "Best Stats",
                                child: MochiTileGroup(
                                  divider: .none,
                                  children: [
                                    for (final (label, value) in bestStats)
                                      MochiTile(title: _timesText(value), details: Text(label)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Flexible(
                          child: _card(
                            title: "Best Ao5",
                            child: bestAo5 == null
                                ? Center(child: _timesText(null))
                                : Column(
                                    mainAxisAlignment: .spaceEvenly,
                                    crossAxisAlignment: .start,
                                    children: [
                                      _summaryText(bestAo5.$1, color: colors.primary.base),
                                      SizedBox(height: geometry.space.sm),
                                      ..._bestAo5Times(bestAo5.$2),
                                    ],
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  MochiCard(
                    child: Container(
                      // TODO: graph
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
