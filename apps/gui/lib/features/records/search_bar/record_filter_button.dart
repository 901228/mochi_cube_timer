part of "../record_search_bar.dart";

class _RecordFilterButton extends StatelessWidget {
  final RecordQuery query;
  final ValueChanged<RecordQuery> onChanged;
  const _RecordFilterButton({required this.query, required this.onChanged});

  Widget _buttonBase({FocusNode? focusNode, VoidCallback? onPress}) {
    final active = query.activeFilters;

    return MochiButton.icon(
      appearance: .ghost,
      intent: .neutral,
      size: .sm,
      focusNode: focusNode,
      selected: active > 0,
      icon: Icon(active == 0 ? TablerIcons.filter2 : TablerIcons.filter2Check),
      tooltip: active == 0 ? "Filter records" : "Filter records ($active on)",
      onPress: onPress,
    );
  }

  @override
  Widget build(BuildContext context) {
    final useSheet = context.responsive(mobile: true, tablet: false);

    if (useSheet) {
      return _buttonBase(
        onPress: () => showMochiSheet<void>(
          context,
          builder: (context) => MochiSheet(
            semanticLabel: "Filter records",
            child: _FilterPanel(query: query, onChanged: onChanged),
          ),
        ),
      );
    }

    return MochiPopover(
      padding: .all(12),
      align: .end,
      constraints: const BoxConstraints(minWidth: 280, maxWidth: 320),
      popoverBuilder: (context) => _FilterPanel(query: query, onChanged: onChanged),
      builder: (context, anchor, _) => _buttonBase(focusNode: anchor.focusNode, onPress: anchor.toggle),
    );
  }
}

class _FilterPanel extends StatefulWidget {
  final RecordQuery query;
  final ValueChanged<RecordQuery> onChanged;
  const _FilterPanel({required this.query, required this.onChanged});

  @override
  State<_FilterPanel> createState() => _FilterPanelState();
}

class _FilterPanelState extends State<_FilterPanel> {
  late RecordQuery _query = widget.query;

  void _update(RecordQuery query) {
    setState(() => _query = query);
    widget.onChanged(query);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: .min,
      crossAxisAlignment: .stretch,
      spacing: 12,
      children: [
        MochiMultiSelect(
          label: const Text("Penalty"),
          hint: "Any",
          values: _query.penalties,
          onChanged: (value) => _update(_query.copyWith(penalties: value)),
          options: Penalty.values
              .map(
                (e) => MochiSelectOption(prefix: Icon(e.icon), value: e, label: e.displayName(context.l10n)),
              )
              .toList(),
        ),
        MochiDatePicker.range(
          label: const Text("Date"),
          hint: "Any time",
          value: _query.dates,
          last: DateTime.now(),
          onChanged: (range) => _update(_query.withDates(range.start, range.end)),
        ),
        Align(
          alignment: .centerRight,
          child: MochiButton(
            appearance: .ghost,
            prefix: const Icon(TablerIcons.filterOff),
            enabled: _query.activeFilters > 0,
            onPress: () => _update(_query.clearFilters()),
            child: const Text("Clear filters"),
          ),
        ),
      ],
    );
  }
}
