import "package:cube_timer/cube_timer.dart";
import "package:flutter/widgets.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:mochi_ui/mochi_ui.dart";

import "../../shared/puzzles.dart";
import "../../shared/utils.dart";
import "../../theme.dart";
import "record_detail_dialog.dart";

class RecordsList extends StatefulWidget {
  final List<RecordEntry> records;
  const RecordsList({super.key, required this.records});

  @override
  State<RecordsList> createState() => _RecordsListState();
}

class _RecordsListState extends State<RecordsList> {
  bool isSelectionMode = false;
  Set<String> selected = {};

  // TODO: popup a toast ahead the outer scaffold header within selection mode

  List<Widget> _menu(BuildContext context, RecordEntry record) {
    final dao = context.read<AppDatabase>().recordsDao;

    MochiMenuItem penaltyItem(Penalty penalty) => MochiMenuItem(
      prefix: Icon(penalty.icon),
      title: Text(penalty.displayName),
      selected: record.penalty == penalty,
      onPress: () async {
        if (record.penalty == penalty) return;
        await dao.setPenalty(record.id, penalty);
      },
    );

    return [
      MochiMenuItem(
        prefix: const Icon(TablerIcons.listCheck),
        title: const Text("Select"),
        onPress: () {
          setState(() {
            isSelectionMode = true;
            selected.add(record.id);
          });
        },
      ),
      MochiSubmenu(
        prefix: const Icon(TablerIcons.gavel),
        title: const Text("Penalty"),
        menuBuilder: (context) => [penaltyItem(.none), penaltyItem(.dnf), penaltyItem(.plus2)],
      ),
      MochiSubmenu(
        prefix: const Icon(TablerIcons.arrowsRightLeft),
        title: const Text("Move to"),
        menuBuilder: (context) => [
          // TODO: sessions
        ],
      ),
      MochiMenuItem(
        prefix: Icon(record.archived ? TablerIcons.archiveOff : TablerIcons.archive),
        title: Text(record.archived ? "Unarchive" : "Archive"),
        onPress: () {
          context.read<AppDatabase>().recordsDao.setArchived(record.id, !record.archived);
        },
      ),

      MochiMenuDivider(),

      MochiMenuItem(
        intent: .danger,
        prefix: const Icon(TablerIcons.trash),
        title: const Text("Delete"),
        onPress: () async {
          final answer = await showMochiConfirm(
            context,
            title: "Delete record?",
            message: "This record will be permanently deleted.",
            confirmLabel: "Delete",
            destructive: true,
          );
          if (answer) {
            await dao.softDelete(record.id);
          }
        },
      ),
    ];
  }

  Widget _recordTile(RecordEntry record) {
    final tile = MochiCard(
      padding: .all(10),
      selected: selected.contains(record.id),
      onPress: () {
        if (isSelectionMode) {
          setState(() {
            if (selected.contains(record.id)) {
              selected.remove(record.id);
              if (selected.isEmpty) {
                isSelectionMode = false;
              }
            } else {
              selected.add(record.id);
            }
          });
        } else {
          showRecordDetailDialog(context, recordId: record.id);
        }
      },
      child: Stack(
        alignment: .center,
        fit: .loose,
        clipBehavior: .none,
        children: [
          Text(record.time.milliseconds.timerDisplayString(record.penalty), style: context.theme.timer.lg),
          Positioned.directional(
            textDirection: Directionality.of(context),
            start: 0,
            top: 0,
            child: Text(record.datetime.toLocal().monthDayString),
          ),
          if (record.penalty == .plus2)
            Positioned.directional(
              textDirection: Directionality.of(context),
              end: 0,
              child: Icon(
                Penalty.plus2.icon,
                color: context.colors.mutedForeground,
                size: context.theme.timer.md.fontSize,
              ),
            ),
          if (record.comment?.isNotEmpty ?? false)
            Positioned.directional(
              start: 0,
              bottom: 0,
              textDirection: Directionality.of(context),
              child: Icon(TablerIcons.message),
            ),
        ],
      ),
    );

    return isSelectionMode
        ? tile
        : MochiContextMenu(longPress: true, menuBuilder: (context) => _menu(context, record), child: tile);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle.merge(
      textHeightBehavior: const TextHeightBehavior(
        applyHeightToFirstAscent: false,
        applyHeightToLastDescent: false,
      ),
      child: GridView(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
          childAspectRatio: 2.6,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
        ),
        shrinkWrap: true,
        children: widget.records.map(_recordTile).toList(),
      ),
    );
  }
}
