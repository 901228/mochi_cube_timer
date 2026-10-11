import "package:cube_timer/cube_timer.dart";
import "package:flutter/widgets.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:mochi_ui/mochi_ui.dart";

import "../../database/dao_provider.dart";
import "../../shared/puzzles.dart";
import "../../shared/utils.dart";
import "record_search_bar.dart";
import "records_list.dart";

class RecordsPage extends StatelessWidget {
  const RecordsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final data = AppStateProvider.of(context);
    return _RecordsPage(puzzle: data.puzzle, session: data.session, showArchived: data.showArchived);
  }
}

class _RecordsPage extends StatefulWidget {
  final Puzzle puzzle;
  final SessionEntry session;
  final bool showArchived;
  const _RecordsPage({required this.puzzle, required this.session, required this.showArchived});

  @override
  State<_RecordsPage> createState() => _RecordsPageState();
}

class _RecordsPageState extends State<_RecordsPage> {
  RecordsDao get recordsDao => context.read<AppDatabase>().recordsDao;

  RecordQuery _query = const RecordQuery();
  late Stream<List<RecordEntry>> _stream;

  void _watchSession() {
    _stream = recordsDao.watchSession(
      widget.session.id,
      widget.puzzle,
      showArchived: widget.showArchived,
      query: _query,
    );
  }

  @override
  void initState() {
    super.initState();
    _watchSession();
  }

  @override
  void didUpdateWidget(_RecordsPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.session.id != widget.session.id ||
        oldWidget.puzzle != widget.puzzle ||
        oldWidget.showArchived != widget.showArchived) {
      _watchSession();
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _stream,
      builder: (context, snapshot) {
        final w = streamHandler(context, snapshot, description: "watching the records of the session");
        if (w != null) return w;

        final records = snapshot.data!;

        return Column(
          mainAxisSize: .max,
          spacing: 8,
          children: [
            RecordSearchBar(
              onChanged: (value) {
                setState(() {
                  _query = value;
                  _watchSession();
                });
              },
              onAddRecord: () async {
                showMochiModal(context);
                // TODO: manually add record
              },
              onArchiveAll: records.every((e) => e.archived)
                  ? null
                  : () async {
                      final answer = await showMochiConfirm(
                        context,
                        title: "Archive all records?",
                        message: "All solves will be archived.",
                        confirmLabel: "Archive",
                      );
                      if (answer) {
                        await recordsDao.archiveAll(records.map((e) => e.id).toList());
                      }
                    },
              onDeleteAll: records.isEmpty
                  ? null
                  : () async {
                      final answer = await showMochiConfirm(
                        context,
                        title: "Delete all records?",
                        message: "All solves will be permanently deleted.",
                        confirmLabel: "Delete",
                        destructive: true,
                      );
                      if (answer) {
                        await recordsDao.deleteAll(records.map((e) => e.id).toList());
                      }
                    },
              onExportAll: records.isEmpty ? null : () => exportRecords(context, widget.session),
            ),

            Expanded(
              child: SingleChildScrollView(child: RecordsList(records: records)),
            ),
          ],
        );
      },
    );
  }
}
