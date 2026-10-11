import "package:cube_timer/cube_timer.dart";
import "package:file_picker/file_picker.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:mochi_ui/mochi_ui.dart";

import "../utils/csv.dart";

// TODO: add a dialog ? (select whether include deleted records & archived records)
void exportRecords(BuildContext context, SessionEntry session) async {
  RecordsDao recordsDao = context.read<AppDatabase>().recordsDao;
  AppStateDao appStateDao = context.read<AppDatabase>().appStateDao;

  try {
    final appState = await appStateDao.current;
    final records = await recordsDao.export(session.id, appState.puzzle);
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
      if (context.mounted) {
        // FIXME: didn't show
        showMochiToast(context, title: Text("Export session records to `${saveFile.path}`"));
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
