part of "../record_search_bar.dart";

class _RecordSortButton extends StatelessWidget {
  final RecordQuery query;
  final ValueChanged<RecordQuery> onChanged;
  const _RecordSortButton({required this.query, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return MochiPopoverMenu(
      menuBuilder: (context) => RecordSort.values
          .map(
            (sort) => MochiMenuItem(
              prefix: Icon(sort.icon),
              title: Text(sort.label),
              selected: query.sort == sort,
              onPress: () => onChanged(query.copyWith(sort: sort)),
            ),
          )
          .toList(),
      builder: (context, anchor, child) => MochiButton.icon(
        appearance: .ghost,
        scaleOnPress: false,
        size: .sm,
        intent: .neutral,
        onPress: anchor.open,
        icon: Icon(query.sort.icon),
        tooltip: "Sort: ${query.sort.label}",
      ),
    );
  }
}
