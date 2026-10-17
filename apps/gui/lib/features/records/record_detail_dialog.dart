import "package:cube_timer/cube_timer.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_svg/svg.dart";
import "package:go_router/go_router.dart";
import "package:mochi_ui/mochi_ui.dart";

import "../../shared/puzzles.dart";
import "../../shared/utils.dart";
import "../../theme.dart";
import "../../l10n/l10n.dart";
import "../../shared/puzzles/puzzle_utils.dart";

Future<void> showRecordDetailDialog(
  BuildContext context, {
  required String recordId,
  required List<SessionEntry> sessions,
  bool isBest = false,
}) => showMochiModal(
  context,
  body: RecordDetailDialog(recordId: recordId, sessions: sessions, isBest: isBest),
  title: Text(context.l10n.recordDetail),
  titleSuffix: MochiActionBar([.close(onPress: context.pop)]),
  // It ends in plain tiles, and the room under them is better spent on the content.
  safeEdge: false,
);

class RecordDetailDialog extends StatelessWidget {
  final String recordId;

  /// What the record can be moved to.
  final List<SessionEntry> sessions;
  final bool isBest;
  const RecordDetailDialog({super.key, required this.recordId, required this.sessions, this.isBest = false});

  Widget _tile({IconData? icon, required Widget body, VoidCallback? onMore}) => MochiTile(
    prefix: icon == null ? null : Icon(icon),
    title: body,
    suffix: onMore == null ? null : MochiButton.icon(onPress: onMore, icon: Icon(TablerIcons.chevronRight)),
  );

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final timer = context.theme.timer;
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

        final rawTimerText = record.time.milliseconds.timerString;
        final timerText = record.time.milliseconds.timerDisplayString(record.penalty);
        final timerTextStyle = timer.xl4.copyWith(color: c.primary.base);

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
              child: Row(
                mainAxisSize: .max,
                mainAxisAlignment: .spaceBetween,
                crossAxisAlignment: .center,
                children: [
                  record.penalty == .none
                      ? Text(timerText, style: timerTextStyle)
                      : Text.rich(
                          TextSpan(
                            text: "$timerText ",
                            style: timerTextStyle,
                            children: [
                              TextSpan(
                                text: "($rawTimerText)",
                                style: timer.xl.copyWith(color: c.mutedForeground),
                              ),
                            ],
                          ),
                        ),
                  if (isBest) Icon(TablerIcons.trophy, color: c.primary.base, size: timer.xl3.fontSize),
                ],
              ),
            ),
            MochiDivider(),
            Row(
              spacing: 6,
              children: [
                SvgPicture.asset("assets/cube_icons/${record.puzzle.id}.svg", width: 24, height: 24),
                Text(record.puzzle.displayName(context.l10n)),

                SizedBox(height: 24, child: MochiDivider(axis: .vertical)),

                Icon(TablerIcons.calendarClock),
                Text(record.datetime.toLocal().fullDateTimeString),
              ],
            ),

            MochiCard(
              titlePrefix: Icon(TablerIcons.box),
              title: Text(context.l10n.commonScramble),
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
              title: Text(context.l10n.commonPenalty),
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
                      child: Text(penalty.displayName(context.l10n)),
                    ),
                ],
              ),
            ),

            MochiCard(
              titlePrefix: Icon(TablerIcons.message),
              title: Text(context.l10n.commonComment),
              titleSuffix: MochiActionBar([
                MochiAction(
                  icon: TablerIcons.edit,
                  label: context.l10n.recordEditComment,
                  onPress: () async {
                    final newComment = await showMochiPrompt(
                      context,
                      title: (record.comment?.isEmpty ?? true)
                          ? context.l10n.commentAdd
                          : context.l10n.commentEdit,
                      multiline: true,
                      hint: context.l10n.commentHint,
                      initialValue: record.comment,
                    );
                    if (newComment == null) return;

                    dao.setComment(record.id, newComment);
                  },
                ),
              ]),
              child: record.comment?.isNotEmpty ?? false
                  ? Text("${record.comment}")
                  : Center(child: Text(context.l10n.recordCommentEmpty)),
            ),

            // The dialog closes once the record is not where it was opened from: moved or deleted.
            Align(
              alignment: .centerEnd,
              child: MochiActionBar(maxVisible: 3, [
                MochiAction.menu(
                  icon: TablerIcons.arrowsRightLeft,
                  label: context.l10n.commonMoveTo,
                  showLabel: true,
                  children: [
                    for (final session in sessions)
                      MochiAction(
                        icon: TablerIcons.stack,
                        label: session.name,
                        selected: session.id == record.session,
                        onPress: () async {
                          if (session.id == record.session) return;
                          context.pop();
                          await dao.setSession(record.id, session.id);
                          await dao.setArchived(record.id, false);
                        },
                      ),
                  ],
                ),
                MochiAction(
                  icon: record.archived ? TablerIcons.archiveOff : TablerIcons.archive,
                  label: record.archived ? context.l10n.commonUnarchive : context.l10n.commonArchive,
                  showLabel: true,
                  onPress: () => dao.setArchived(record.id, !record.archived),
                ),
                MochiAction(
                  icon: TablerIcons.trash,
                  label: context.l10n.commonDelete,
                  showLabel: true,
                  intent: .danger,
                  onPress: () async {
                    final answer = await showMochiConfirm(
                      context,
                      title: context.l10n.deleteRecordTitle,
                      message: context.l10n.recordDeleteMessage,
                      confirmLabel: context.l10n.commonDelete,
                      destructive: true,
                    );
                    if (!answer || !context.mounted) return;
                    context.pop();
                    await dao.softDelete(record.id);
                  },
                ),
              ]),
            ),
          ],
        );
      },
    );
  }
}
