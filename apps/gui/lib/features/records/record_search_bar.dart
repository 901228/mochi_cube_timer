import "package:cube_timer/cube_timer.dart";
import "package:flutter_bloc/flutter_bloc.dart";
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

/// Where the search bar ends, from the top of the screen, once it is laid out; null while it is not on
/// screen. The selection header covers everything down to it.
class SearchBarBottomCubit extends Cubit<double?> {
  SearchBarBottomCubit() : super(null);

  void report(double bottom) => emit(bottom);
}

class RecordSearchBar extends StatefulWidget {
  final ValueChanged<RecordQuery>? onChanged;
  final VoidCallback? onAddRecord;
  final VoidCallback? onArchiveAll;
  final VoidCallback? onDeleteAll;
  final VoidCallback? onExportAll;
  final VoidCallback? onImport;
  const RecordSearchBar({
    super.key,
    this.onChanged,
    required this.onAddRecord,
    required this.onArchiveAll,
    required this.onDeleteAll,
    required this.onExportAll,
    required this.onImport,
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

  void _reportBottom() {
    if (!mounted) return;
    final box = context.findRenderObject();
    if (box is! RenderBox || !box.hasSize) return;
    context.read<SearchBarBottomCubit>().report(box.localToGlobal(Offset(0, box.size.height)).dy);
  }

  @override
  Widget build(BuildContext context) {
    // Only known once laid out, so after this frame.
    WidgetsBinding.instance.addPostFrameCallback((_) => _reportBottom());

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
          MochiActionBar(scaleOnPress: false, maxVisible: 2, [
            MochiAction(icon: TablerIcons.arrowDownToArc, label: "Archive", onPress: widget.onArchiveAll),
            MochiAction(icon: TablerIcons.packageImport, label: "Import", onPress: widget.onImport),
            MochiAction(icon: TablerIcons.packageExport, label: "Export", onPress: widget.onExportAll),
            MochiAction(
              icon: TablerIcons.trashFilled,
              label: "Delete all",
              intent: .danger,
              onPress: widget.onDeleteAll,
            ),
          ]),
        ],
      ),
    );
  }
}
