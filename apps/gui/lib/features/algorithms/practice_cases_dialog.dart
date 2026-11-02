import "package:cube_timer/cube_timer.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:mochi_ui/mochi_ui.dart";

import "../../database/dao_provider.dart";
import "../../l10n/l10n.dart";
import "../../shared/utils.dart";
import "algorithm_data/common.dart";

/// Picks which cases of [set] its practice scrambles come from; each tap is saved as it is made.
Future<void> showPracticeCasesDialog(
  BuildContext context, {
  required Puzzle puzzle,
  required AlgorithmSet set,
}) {
  final dao = context.read<AppDatabase>().appStateDao;
  final topColor = SettingsProvider.of(context).cubeColorD.toColor();
  final tall = set.cases.first.diagramAspectRatio < 1;

  return showMochiModal(
    context,
    title: Text(context.l10n.practiceCasesTitle),
    titleSuffix: Text(
      set.name,
      style: context.theme.typography.body.sm.copyWith(color: context.colors.mutedForeground),
    ),
    body: StreamBuilder(
      stream: dao.watchExcluded(puzzle, set.id),
      builder: (context, snapshot) {
        final excluded = snapshot.data;
        if (excluded == null) return const Center(child: MochiCircularProgress());
        void save(Set<String> next) => dao.setExcluded(puzzle, set.id, next);

        return Column(
          mainAxisSize: .min,
          crossAxisAlignment: .stretch,
          spacing: 16,
          children: [
            Text(
              context.l10n.practiceCasesCount(
                set.cases.where((c) => !excluded.contains(c.id)).length,
                set.cases.length,
              ),
              textAlign: .center,
              style: context.theme.typography.body.md.copyWith(color: context.colors.mutedForeground),
            ),
            for (final (group, cases) in set.grouped) ...[
              Row(
                children: [
                  Expanded(child: Text(group, style: context.theme.typography.title.sm)),
                  if (cases.every((c) => !excluded.contains(c.id)))
                    MochiButton(
                      appearance: .text,
                      size: .sm,
                      onPress: () => save({...excluded, for (final c in cases) c.id}),
                      child: Text(context.l10n.homeDeselectAll),
                    )
                  else
                    MochiButton(
                      appearance: .text,
                      size: .sm,
                      onPress: () => save(excluded.difference({for (final c in cases) c.id})),
                      child: Text(context.l10n.homeSelectAll),
                    ),
                ],
              ),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: .zero,
                itemCount: cases.length,
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 88,
                  mainAxisExtent: tall ? 150 : 96,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemBuilder: (context, index) {
                  final item = cases[index];
                  final included = !excluded.contains(item.id);
                  return MochiCard(
                    selected: included,
                    padding: const EdgeInsets.all(8),
                    onPress: () => save(included ? {...excluded, item.id} : ({...excluded}..remove(item.id))),
                    child: Column(
                      spacing: 4,
                      children: [
                        Expanded(
                          child: Opacity(
                            // Left out reads as faded, so the cases in stand out at a glance.
                            opacity: included ? 1 : 0.35,
                            child: AspectRatio(
                              aspectRatio: item.diagramAspectRatio,
                              child: item.buildDiagram(topColor: topColor),
                            ),
                          ),
                        ),
                        Text(
                          item.name,
                          style: context.theme.typography.body.sm,
                          maxLines: 1,
                          overflow: .ellipsis,
                          textAlign: .center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ],
        );
      },
    ),
  );
}
