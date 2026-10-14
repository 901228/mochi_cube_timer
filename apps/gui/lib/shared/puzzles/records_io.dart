import "package:cube_timer/cube_timer.dart";
import "package:file_picker/file_picker.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:mochi_ui/mochi_ui.dart";

import "../utils/csv.dart";

Future<void> exportRecords(BuildContext context, SessionEntry session) async {
  final toastContext = Navigator.of(context, rootNavigator: true).context;
  bool includeDeleted = false;

  final g = context.theme.geometry;

  showMochiModal(
    context,
    title: Column(
      crossAxisAlignment: .start,
      children: [
        const Text("Export session"),
        Text(
          "Export as CSV",
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
              label: const Text("Include deleted records"),
            ),
          ],
        ),
      ),
    ),
    actions: [
      MochiButton(
        prefix: Icon(TablerIcons.check),
        child: Text("Export"),
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
      dialogTitle: "Output session to a csv file",
      fileName: "${session.name}.csv",
      type: .custom,
      allowedExtensions: ["csv"],
      bytes: fileData,
    );

    if (saveFile != null) {
      if (toastContext.mounted) {
        showMochiToast(
          toastContext,
          title: const Text("Session exported"),
          description: Text.rich(
            TextSpan(
              text: "Export session records to ",
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
