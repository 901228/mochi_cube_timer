import "dart:convert" show utf8;

import "package:cube_timer/cube_timer.dart";
import "package:file_picker/file_picker.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:mochi_ui/mochi_ui.dart";

import "../utils/csv.dart";
import "../../l10n/l10n.dart";

/// The rows [parseRecordsCsv] could read, and how many it could not.
typedef ParsedRecords = ({List<RecordImport> records, int skipped});

/// Reads what [exportRecords] writes. Columns are found by header, so their order does not matter;
/// the Session column is ignored, as the records go wherever the caller puts them.
///
/// Throws a [FormatException] if the header lacks a column a record cannot do without.
ParsedRecords parseRecordsCsv(String text) {
  final rows = fromCsv(text).where((r) => r.any((c) => c.toString().trim().isNotEmpty)).toList();
  final header = rows.isEmpty ? <String>[] : [for (final c in rows.first) c.toString().trim().toLowerCase()];
  final index = {
    for (final name in ["puzzle", "scramble", "time", "datetime", "penalty", "comment"])
      name: header.indexOf(name),
  };
  if (["puzzle", "scramble", "time", "datetime"].any((name) => index[name] == -1)) {
    throw const FormatException("Not a records file: needs Puzzle, Scramble, Time and Datetime columns");
  }

  final records = <RecordImport>[];
  var skipped = 0;
  for (final row in rows.skip(1)) {
    String cell(String name) =>
        index[name]! < row.length && index[name]! >= 0 ? row[index[name]!].toString() : "";
    try {
      records.add((
        puzzle: Puzzle.fromId(cell("puzzle")),
        scramble: cell("scramble"),
        time: int.parse(cell("time")),
        datetime: int.parse(cell("datetime")),
        penalty: cell("penalty").isEmpty ? Penalty.none : Penalty.values.byName(cell("penalty")),
        comment: cell("comment").isEmpty ? null : cell("comment"),
      ));
    } on FormatException {
      skipped++;
    } on ArgumentError {
      skipped++;
    }
  }
  return (records: records, skipped: skipped);
}

/// Picks a csv and adds its records to [session], or to a new session named after the file if
/// [session] is null.
Future<void> importRecords(BuildContext context, {SessionEntry? session}) async {
  final toastContext = Navigator.of(context, rootNavigator: true).context;
  final db = context.read<AppDatabase>();

  try {
    final picked = await FilePicker.pickFiles(
      dialogTitle: context.l10n.importPickTitle,
      type: .custom,
      allowedExtensions: ["csv"],
    );
    if (picked.isEmpty) return;

    final file = picked.first;
    final (:records, :skipped) = parseRecordsCsv(utf8.decode(await file.readAsBytes(), allowMalformed: true));
    if (!context.mounted) return;

    final fileName = file.name.replaceFirst(RegExp(r"\.csv$", caseSensitive: false), "");
    final name = session?.name ?? (fileName.isEmpty ? context.l10n.importDefaultName : fileName);
    final answer = await showMochiConfirm(
      context,
      title: context.l10n.importTitle,
      message:
          (session == null
              ? context.l10n.importMessageNew(records.length, name)
              : context.l10n.importMessageExisting(records.length, name)) +
          (skipped > 0 ? context.l10n.importSkipped(skipped) : ""),
      confirmLabel: context.l10n.commonImport,
    );
    if (!answer) return;

    await db.recordsDao.importAll(session?.id ?? await db.sessionsDao.add(name: name), records);
    if (toastContext.mounted) {
      showMochiToast(
        toastContext,
        title: Text(context.l10n.importDone),
        description: Text(context.l10n.importDoneDescription(records.length, name)),
      );
    }
  } on FormatException {
    if (toastContext.mounted) {
      showMochiToast(
        toastContext,
        title: Text(context.l10n.importFailed),
        description: Text(context.l10n.importNotRecords),
      );
    }
  } catch (e) {
    FlutterError.reportError(
      FlutterErrorDetails(exception: e, context: ErrorDescription("Importing records")),
    );
  }
}

Future<void> exportRecords(BuildContext context, SessionEntry session) async {
  final toastContext = Navigator.of(context, rootNavigator: true).context;
  bool includeDeleted = false;

  final g = context.theme.geometry;

  showMochiModal(
    context,
    title: Column(
      crossAxisAlignment: .start,
      children: [
        Text(context.l10n.exportTitle),
        Text(
          context.l10n.exportAsCsv,
          style: context.theme.typography.title.sm.copyWith(color: context.theme.colors.mutedForeground),
        ),
      ],
    ),
    body: Padding(
      padding: .only(top: g.space.xs),
      child: StatefulBuilder(
        builder: (context, setState) => Column(
          crossAxisAlignment: .start,
          spacing: g.space.xs,
          children: [
            MochiCheckbox(
              value: includeDeleted,
              onChanged: (value) => setState(() => includeDeleted = value!),
              label: Text(context.l10n.exportIncludeDeleted),
            ),
          ],
        ),
      ),
    ),
    actions: [
      MochiButton(
        prefix: Icon(TablerIcons.check),
        child: Text(context.l10n.commonExport),
        onPress: () async {
          await _exportRecords(context, toastContext, session, includeDeleted: includeDeleted);

          if (context.mounted) Navigator.of(context, rootNavigator: true).pop(true);
        },
      ),
    ],
  );
}

Future<void> _exportRecords(
  BuildContext context,
  BuildContext toastContext,
  SessionEntry session, {
  bool includeDeleted = false,
}) async {
  final l10n = context.l10n;
  RecordsDao recordsDao = context.read<AppDatabase>().recordsDao;
  AppStateDao appStateDao = context.read<AppDatabase>().appStateDao;

  try {
    final appState = await appStateDao.current;
    final records = await recordsDao.export(session.id, appState.puzzle, includeDeleted: includeDeleted);
    final rows = records.map(
      (e) => [e.session.name, e.puzzle.id, e.scramble, e.time, e.datetime, e.penalty.name, e.comment],
    );

    final fileData = toCsv([
      ["Session", "Puzzle", "Scramble", "Time", "Datetime", "Penalty", "Comment"],
      ...rows,
    ]);

    final saveFile = await FilePicker.saveFile(
      dialogTitle: l10n.exportPickTitle,
      fileName: "${session.name}.csv",
      type: .custom,
      allowedExtensions: ["csv"],
      bytes: fileData,
    );

    if (saveFile != null) {
      if (toastContext.mounted) {
        showMochiToast(
          toastContext,
          title: Text(context.l10n.exportDone),
          description: Text.rich(
            TextSpan(
              text: toastContext.l10n.exportDonePrefix,
              children: [
                TextSpan(
                  text: saveFile.path,
                  style: TextStyle(fontWeight: .bold, color: toastContext.theme.colors.primary.base),
                ),
              ],
            ),
          ),
        );
      }
    } else {
      // User canceled the picker
    }
  } catch (e) {
    FlutterError.reportError(
      FlutterErrorDetails(exception: e, context: ErrorDescription("Exporting a session")),
    );
  }
}
