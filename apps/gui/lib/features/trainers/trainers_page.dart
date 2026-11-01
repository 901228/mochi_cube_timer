import "package:go_router/go_router.dart";
import "package:mochi_ui/mochi_ui.dart";

import "../../l10n/l10n.dart";
import "trainer_frame.dart";

/// The list of trainers: practice that is not a case from a set to look up, but a skill to drill.
/// `/trainers` in the home shell, `/trainers-standalone` pushed over it.
class TrainersPage extends StatelessWidget {
  const TrainersPage({super.key, required this.standalone});

  final bool standalone;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final g = context.theme.geometry;

    final trainers = [
      (
        path: "pll-recognition",
        icon: TablerIcons.eye,
        title: l10n.trainerPllRecognitionTitle,
        description: l10n.trainerPllRecognitionDescription,
      ),
    ];

    return TrainerFrame(
      title: l10n.trainersTitle,
      standalone: standalone,
      canPop: false,
      child: SingleChildScrollView(
        padding: g.pagePadding + .only(bottom: MediaQuery.paddingOf(context).bottom),
        child: MochiTileGroup(
          children: [
            for (final trainer in trainers)
              MochiTile(
                prefix: Icon(trainer.icon),
                title: Text(trainer.title),
                subtitle: Text(trainer.description),
                suffix: const Icon(TablerIcons.chevronRight),
                // Standalone: pushed over the shell (a top-level route); `go` would drop home.
                onPress: () => standalone
                    ? context.push("/trainers-standalone/${trainer.path}")
                    : context.go("/trainers/${trainer.path}"),
              ),
          ],
        ),
      ),
    );
  }
}
