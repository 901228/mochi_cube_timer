import "package:cube_timer/cube_timer.dart";
import "package:flutter/services.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:mochi_ui/mochi_ui.dart";

import "../../database/dao_provider.dart";
import "../../shared/puzzles.dart";
import "../../shared/utils.dart";
import "../../theme.dart";
import "record_detail_dialog.dart";

/// null = not selecting.
class RecordSelectionCubit extends Cubit<Set<String>?> {
  RecordSelectionCubit() : super(null);

  bool get active => state != null;

  Iterable<String> visible = const [];

  void start(String id) => emit({id});
  void toggle(String id) {
    final next = {...?state};
    next.contains(id) ? next.remove(id) : next.add(id);
    emit(next.isEmpty ? null : next);
  }

  void clear() => emit(null);
  void selectAll() => emit(visible.toSet());

  bool get isAllSelected => visible.isNotEmpty && state?.length == visible.length;
  void toggleSelectAll() {
    if (isAllSelected) {
      emit({});
    } else {
      selectAll();
    }
  }
}

extension on Set<String>? {
  bool get active => this != null;
  bool contains(String id) => this?.contains(id) ?? false;
}

class RecordsList extends StatefulWidget {
  final List<RecordEntry> records;

  /// The best time of the session in milliseconds, which the solves that made it are marked with.
  final int? best;
  const RecordsList({super.key, required this.records, this.best});

  @override
  State<RecordsList> createState() => _RecordsListState();
}

class _RecordsListState extends State<RecordsList> {
  List<Widget> _menu(BuildContext context, RecordEntry record) {
    final dao = context.read<AppDatabase>().recordsDao;
    final sessions = SessionsProvider.of(context);
    final appState = AppStateProvider.of(context);

    return [
      MochiMenuItem(
        prefix: const Icon(TablerIcons.listCheck),
        title: const Text("Select"),
        onPress: () {
          context.read<RecordSelectionCubit>().start(record.id);
        },
      ),
      MochiSubmenu(
        prefix: const Icon(TablerIcons.gavel),
        title: const Text("Penalty"),
        menuBuilder: (context) => [
          for (final penalty in Penalty.values)
            MochiMenuItem(
              prefix: Icon(penalty.icon),
              title: Text(penalty.displayName),
              selected: record.penalty == penalty,
              onPress: () async {
                if (record.penalty == penalty) return;
                await dao.setPenalty(record.id, penalty);
              },
            ),
        ],
      ),
      MochiSubmenu(
        prefix: const Icon(TablerIcons.arrowsRightLeft),
        title: const Text("Move to"),
        menuBuilder: (context) => sessions
            .map(
              (e) => MochiMenuItem(
                prefix: const Icon(TablerIcons.stack),
                title: Text(e.name),
                selected: e.id == appState.session.id,
                onPress: () async {
                  if (e.id == appState.session.id) return;
                  await dao.setSession(record.id, e.id);
                  await dao.setArchived(record.id, false);
                },
              ),
            )
            .toList(),
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

  bool _isBest(RecordEntry record) =>
      record.penalty != .dnf && record.time + (record.penalty == .plus2 ? 2000 : 0) == widget.best;

  Widget _recordTile(RecordEntry record) {
    final selected = context.watch<RecordSelectionCubit>().state;
    final controller = context.read<RecordSelectionCubit>();
    final g = context.theme.geometry;

    final isBest = _isBest(record);

    final tile = MochiCard(
      padding: .all(g.space.xs),
      selected: selected.contains(record.id),
      // Straight into selecting, as on a phone's gallery; the menu is for the right click.
      onLongPress: selected.active
          ? null
          : () {
              HapticFeedback.selectionClick();
              controller.start(record.id);
            },
      onPress: () {
        if (selected.active) {
          controller.toggle(record.id);
        } else {
          showRecordDetailDialog(
            context,
            recordId: record.id,
            sessions: SessionsProvider.of(context),
            isBest: isBest,
          );
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
          if (isBest)
            Positioned.directional(
              textDirection: Directionality.of(context),
              end: 0,
              top: 0,
              child: Icon(TablerIcons.trophy, color: context.colors.primary.base, size: 16),
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

    return selected.active
        ? tile
        : MochiContextMenu(longPress: false, menuBuilder: (_) => _menu(context, record), child: tile);
  }

  @override
  Widget build(BuildContext context) {
    final mobile = context.responsive(mobile: true, tablet: false);

    return widget.records.isEmpty
        ? Center(child: Text("No records yet"))
        : DefaultTextStyle.merge(
            textHeightBehavior: const TextHeightBehavior(
              applyHeightToFirstAscent: false,
              applyHeightToLastDescent: false,
            ),
            // The grid scrolls itself, with the padding inside it, so the tiles' shadows are not
            // clipped at its edges and the bottom bar's height is still kept clear.
            child: GridView.builder(
              padding: context.theme.geometry.pagePadding + MediaQuery.paddingOf(context),
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: mobile ? 160 : 180,
                childAspectRatio: mobile ? 1.8 : 2.3,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
              ),
              itemCount: widget.records.length,
              itemBuilder: (context, index) => _recordTile(widget.records[index]),
            ),
          );
  }
}
