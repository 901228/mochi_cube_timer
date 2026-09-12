import "package:cube_timer/cube_timer.dart";
import "package:flutter/widgets.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:forui/forui.dart";

class RecordsPage extends StatelessWidget {
  const RecordsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final dao = context.read<AppDatabase>().appStateDao;

    return StreamBuilder(
      stream: dao.watch(),
      builder: (context, snapshot) {
        // A failed stream is not a slow one; without this branch it arrives as
        // a spinner that never stops.
        if (snapshot.error case final error?) {
          FlutterError.reportError(
            FlutterErrorDetails(
              exception: error,
              stack: snapshot.stackTrace,
              library: "mochi cube timer",
              context: ErrorDescription("watching the app state for the timer page"),
            ),
          );
          return Center(child: Icon(FLucideIcons.triangleAlert, color: context.theme.colors.destructive));
        }

        final data = snapshot.data;
        if (data == null) return const Center(child: FCircularProgress());

        return _RecordsPage(puzzle: data.puzzle, sessionId: data.session.id);
      },
    );
  }
}

class _RecordsPage extends StatelessWidget {
  final Puzzle puzzle;
  final String sessionId;
  const _RecordsPage({required this.puzzle, required this.sessionId});

  @override
  Widget build(BuildContext context) {
    final dao = context.read<AppDatabase>().recordsDao;

    return StreamBuilder(
      stream: dao.watchSession(sessionId, puzzle),
      builder: (context, snapshot) {
        // A failed stream is not a slow one; without this branch it arrives as
        // a spinner that never stops.
        if (snapshot.error case final error?) {
          FlutterError.reportError(
            FlutterErrorDetails(
              exception: error,
              stack: snapshot.stackTrace,
              library: "mochi cube timer",
              context: ErrorDescription("watching the app state for the timer page"),
            ),
          );
          return Center(child: Icon(FLucideIcons.triangleAlert, color: context.theme.colors.destructive));
        }

        final data = snapshot.data;
        if (data == null) return const Center(child: FCircularProgress());

        return Text(data.map((e) => e.time).toString());
      },
    );
  }
}
