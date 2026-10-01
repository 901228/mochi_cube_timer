import "package:cube_timer/cube_timer.dart";
import "package:flutter/widgets.dart";
import "package:mochi_ui/mochi_ui.dart";

import "../../shared/puzzles.dart";

part "search_bar/record_filter_button.dart";
part "search_bar/record_sort_button.dart";

extension on RecordSort {
  String get label => switch (this) {
    .newest => "Newest first",
    .oldest => "Oldest first",
    .fastest => "Fastest first",
    .slowest => "Slowest first",
  };

  IconData get icon => switch (this) {
    .newest => TablerIcons.calendarDown,
    .oldest => TablerIcons.calendarUp,
    .fastest => TablerIcons.clockDown,
    .slowest => TablerIcons.clockUp,
  };
}

extension on RecordQuery {
  MochiDateRange? get dates => (from != null && to != null) ? MochiDateRange(from!, to) : null;
}

class RecordSearchBar extends StatefulWidget {
  final ValueChanged<RecordQuery>? onChanged;
  final VoidCallback? onAddRecord;
  final VoidCallback? onArchiveAll;
  final VoidCallback? onDeleteAll;
  const RecordSearchBar({
    super.key,
    this.onChanged,
    required this.onAddRecord,
    required this.onArchiveAll,
    required this.onDeleteAll,
  });

  @override
  State<RecordSearchBar> createState() => _RecordSearchBarState();
}

class _RecordSearchBarState extends State<RecordSearchBar> {
  RecordQuery _query = const RecordQuery();

  void _update(RecordQuery query) {
    setState(() => _query = query);
    widget.onChanged?.call(query);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const .all(8.0),
      child: Row(
        mainAxisSize: .max,
        spacing: 8,
        children: [
          MochiButton.icon(
            appearance: .ghost,
            scaleOnPress: false,
            size: .sm,
            intent: .neutral,
            icon: Icon(TablerIcons.squarePlus),
            tooltip: "Add a record",
            onPress: widget.onAddRecord,
          ),
          Expanded(
            child: MochiSearchBar(
              hint: "Search comments",
              onSearch: (text) => _update(_query.copyWith(comment: text)),
              suffix: Row(
                mainAxisSize: .min,
                children: [
                  _RecordFilterButton(query: _query, onChanged: _update),
                  _RecordSortButton(query: _query, onChanged: _update),
                ],
              ),
            ),
          ),
          MochiActionBar(scaleOnPress: false, [
            MochiAction(
              icon: TablerIcons.trashFilled,
              label: "Delete all records",
              onPress: widget.onDeleteAll,
            ),
            MochiAction(
              icon: TablerIcons.arrowDownToArc,
              label: "Archive all records",
              onPress: widget.onArchiveAll,
            ),
          ]),
        ],
      ),
    );
  }
}
