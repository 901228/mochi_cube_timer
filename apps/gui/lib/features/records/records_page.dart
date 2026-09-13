import "package:cube_timer/cube_timer.dart";
import "package:flutter/widgets.dart";
import "package:flutter_bloc/flutter_bloc.dart";

import "../../shared/utils.dart";

class RecordsPage extends StatelessWidget {
  const RecordsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final dao = context.read<AppDatabase>().appStateDao;

    return StreamBuilder(
      stream: dao.watch(),
      builder: (context, snapshot) {
        final w = streamHandler(
          context,
          snapshot,
          description: "watching the app state for the records page",
        );
        if (w != null) return w;

        final data = snapshot.data!;
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

    // TODO: records list

    return StreamBuilder(
      stream: dao.watchSession(sessionId, puzzle),
      builder: (context, snapshot) {
        final w = streamHandler(context, snapshot, description: "watching the records of the session");
        if (w != null) return w;

        final data = snapshot.data!;
        return Text(data.map((e) => e.time).toString());
      },
    );
  }
}
