import "package:cube_timer/cube_timer.dart";
import "package:flutter/widgets.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_svg/svg.dart";
import "package:go_router/go_router.dart";
import "package:mochi_ui/mochi_ui.dart";

import "../../shared/puzzles.dart";
import "../../shared/utils.dart";
import "../../theme.dart";

Future<void> showRecordDetailDialog(BuildContext context, {required String recordId}) => showMochiModal(
  context,
  body: RecordDetailDialog(recordId: recordId),
  title: Text("Record Detail"),
  titleSuffix: MochiActionBar([.close(onPress: context.pop)]),
);

class RecordDetailDialog extends StatelessWidget {
  final String recordId;
  const RecordDetailDialog({super.key, required this.recordId});

  Widget _tile({IconData? icon, required Widget body, VoidCallback? onMore}) => MochiTile(
    prefix: icon == null ? null : Icon(icon),
    title: body,
    suffix: onMore == null ? null : MochiButton.icon(onPress: onMore, icon: Icon(TablerIcons.chevronRight)),
  );

  @override
  Widget build(BuildContext context) {
    final dao = context.read<AppDatabase>().recordsDao;

    return StreamBuilder(
      stream: dao.watchRecord(recordId),
      builder: (context, snapshot) {
        final w = streamHandler(
          context,
          snapshot,
          description: "watching the settings for the record detail",
        );
        if (w != null) return w;

        final record = snapshot.data!;
        final scramble = record.puzzle.scrambler.parse(record.scramble);

        final timerText = Text(
          style: context.theme.timer.xl4,
          record.time.milliseconds.timerDisplayString(record.penalty),
        );

        return Column(
          mainAxisSize: .min,
          crossAxisAlignment: .start,
          spacing: 16,
          children: [
            DefaultTextStyle.merge(
              textHeightBehavior: const TextHeightBehavior(
                applyHeightToFirstAscent: false,
                applyHeightToLastDescent: false,
              ),
              child: record.penalty != .plus2
                  ? timerText
                  : Row(
                      mainAxisSize: .min,
                      crossAxisAlignment: .baseline,
                      textBaseline: .ideographic,
                      spacing: 8,
                      children: [
                        timerText,
                        Icon(
                          Penalty.plus2.icon,
                          color: context.theme.colors.mutedForeground,
                          size: context.theme.timer.xl2.fontSize,
                        ),
                      ],
                    ),
            ),
            MochiDivider(),
            Row(
              spacing: 6,
              children: [
                SvgPicture.asset("assets/cube_icons/${record.puzzle.id}.svg", width: 24, height: 24),
                Text(record.puzzle.displayName),

                SizedBox(height: 24, child: MochiDivider(axis: .vertical)),

                Icon(TablerIcons.calendarClock),
                Text(record.datetime.toLocal().fullDateTimeString),
              ],
            ),

            MochiCard(
              titlePrefix: Icon(TablerIcons.box),
              title: Text("Scramble"),
              child: _tile(
                // icon: TablerIcons.box,
                body: DefaultTextStyle(
                  style: context.theme.timer.md,
                  child: ScrambleTokens(
                    alignment: .start,
                    puzzle: record.puzzle,
                    steps: record.puzzle.scrambler.stepsOf(scramble),
                  ),
                ),
                onMore: () => showScrambleModal(context, puzzle: record.puzzle, scramble: scramble),
              ),
            ),

            MochiCard(
              titlePrefix: Icon(TablerIcons.gavel),
              title: Text("Penalty"),
              child: Row(
                spacing: 8,
                children: [
                  for (final penalty in Penalty.values)
                    MochiButton(
                      selected: record.penalty == penalty,
                      appearance: .soft,
                      onPress: () async {
                        await context.read<AppDatabase>().recordsDao.setPenalty(record.id, penalty);
                      },
                      prefix: Icon(penalty.icon),
                      child: Text(penalty.displayName),
                    ),
                ],
              ),
            ),

            MochiCard(
              titlePrefix: Icon(TablerIcons.message),
              title: Text("Comment"),
              titleSuffix: MochiActionBar([
                MochiAction(
                  icon: TablerIcons.edit,
                  label: "Edit comment",
                  onPress: () async {
                    final newComment = await showMochiPrompt(
                      context,
                      title: (record.comment?.isEmpty ?? true) ? "Add comment" : "Edit comment",
                      multiline: true,
                      hint: "Comment",
                      initialValue: record.comment,
                    );
                    if (newComment == null) return;

                    dao.setComment(record.id, newComment);
                  },
                ),
              ]),
              child: record.comment?.isNotEmpty ?? false
                  ? Text("${record.comment}")
                  : Center(child: Text("Comment something...")),
            ),
          ],
        );
      },
    );
  }
}
