import "package:cube_timer/cube_timer.dart";
import "package:flutter/services.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:mochi_ui/mochi_ui.dart";

import "../../../database/dao_provider.dart";
import "../../../shared/puzzles.dart";
import "../../timer/scramble_cubit.dart";
import "../../../l10n/l10n.dart";

/// `ss.xxx`, `m:ss.xxx` or `h:mm:ss.xxx`; the fraction is up to 3 digits.
final _solveTime = RegExp(r"^(?:(?:(\d+):)?(\d+):)?(\d+)(?:\.(\d{1,3}))?$");

/// A prefix of [_solveTime], so a half-typed time like `1:` or `12.` is kept.
final _partialSolveTime = RegExp(r"^(?:\d+:){0,2}\d*(?:\.\d{0,3})?$");

/// Milliseconds, or null when [text] is not a whole solve time.
int? parseSolveTime(String text) {
  final m = _solveTime.firstMatch(text);
  if (m == null) return null;
  final h = int.parse(m[1] ?? "0"), min = int.parse(m[2] ?? "0"), s = int.parse(m[3]!);
  if (m[2] != null && s >= 60 || m[1] != null && min >= 60) return null;
  final ms = int.parse((m[4] ?? "").padRight(3, "0"));
  return ((h * 60 + min) * 60 + s) * 1000 + ms;
}

/// The values filled in by [FormState.save], so read them only after it.
class AddRecordValueHolder {
  int? time;
  bool useCurrentScramble = true;

  /// Null when [useCurrentScramble].
  Scramble? scramble;
  Penalty penalty = .none;
  String? comment;
}

Future<bool?> showAddRecordModal(BuildContext context) {
  final appState = AppStateProvider.of(context);
  final AddRecordValueHolder valueHolder = AddRecordValueHolder();
  final formKey = GlobalKey<FormState>();
  final recordsDao = context.read<AppDatabase>().recordsDao;
  // read here: the modal is pushed on the root navigator, above the shell that provides it
  final scrambles = context.read<ScrambleCubit>();

  return showMochiModal(
    context,
    title: Text(context.l10n.addRecordTitle),
    body: Form(key: formKey, child: _AddRecordModalContent(valueHolder, appState.puzzle)),
    actions: [
      MochiButton(
        prefix: Icon(TablerIcons.check),
        child: Text(context.l10n.commonAdd),
        onPress: () async {
          final form = formKey.currentState!;
          if (!form.validate()) return;
          form.save();

          final scramble = valueHolder.scramble ?? await scrambles.state;
          await recordsDao.add(
            session: appState.session.id,
            puzzle: appState.puzzle,
            scramble: scramble.notation,
            time: valueHolder.time!,
            penalty: valueHolder.penalty,
            comment: valueHolder.comment,
          );
          // the current scramble is used up, like after a timed solve
          if (valueHolder.useCurrentScramble) scrambles.next();

          if (context.mounted) Navigator.of(context, rootNavigator: true).pop(true);
        },
      ),
    ],
  );
}

class _AddRecordModalContent extends StatefulWidget {
  final AddRecordValueHolder valueHolder;
  final Puzzle puzzle;
  const _AddRecordModalContent(this.valueHolder, this.puzzle);

  @override
  State<_AddRecordModalContent> createState() => _AddRecordModalContentState();
}

class _AddRecordModalContentState extends State<_AddRecordModalContent> {
  Widget _label({required IconData icon, required String title}) => Text.rich(
    TextSpan(
      children: [
        WidgetSpan(child: Icon(icon, size: context.theme.typography.body.md.fontSize)),
        TextSpan(text: " $title"),
      ],
    ),
    textHeightBehavior: TextHeightBehavior(applyHeightToFirstAscent: false, applyHeightToLastDescent: false),
  );

  @override
  Widget build(BuildContext context) {
    final g = context.theme.geometry;

    return Column(
      mainAxisSize: .min,
      crossAxisAlignment: .start,
      spacing: g.space.sm,
      children: [
        FormField<String>(
          validator: (value) =>
              parseSolveTime(value ?? "") == null ? context.l10n.addRecordInvalidTime : null,
          onSaved: (value) => widget.valueHolder.time = parseSolveTime(value!)!,
          builder: (field) => MochiTextField(
            hint: context.l10n.addRecordSolveTime,
            autofocus: true,
            error: field.errorText,
            inputFormatters: [
              TextInputFormatter.withFunction(
                (old, next) => _partialSolveTime.hasMatch(next.text) ? next : old,
              ),
            ],
            onChanged: field.didChange,
          ),
        ),

        MochiDivider(),

        Column(
          mainAxisSize: .min,
          crossAxisAlignment: .start,
          spacing: g.space.md,
          children: [
            Column(
              mainAxisSize: .min,
              crossAxisAlignment: .start,
              spacing: g.space.xs2,
              children: [
                MochiFieldFrame(
                  label: _label(icon: TablerIcons.box, title: context.l10n.commonScramble),
                  child: MochiCheckbox(
                    value: widget.valueHolder.useCurrentScramble,
                    onChanged: (value) => setState(() => widget.valueHolder.useCurrentScramble = value!),
                    label: Text(context.l10n.addRecordUseCurrent),
                  ),
                ),
                MochiReveal(
                  expanded: !widget.valueHolder.useCurrentScramble,
                  child: FormField<String>(
                    validator: (value) {
                      if (widget.valueHolder.useCurrentScramble) return null;
                      if (value == null || value.trim().isEmpty) {
                        return context.l10n.addRecordScrambleRequired;
                      }
                      try {
                        widget.puzzle.scrambler.parse(value);
                        return null;
                      } on FormatException catch (e) {
                        return e.message;
                      }
                    },
                    onSaved: (value) => widget.valueHolder.scramble = widget.valueHolder.useCurrentScramble
                        ? null
                        : widget.puzzle.scrambler.parse(value!),
                    builder: (field) => MochiTextField(
                      hint: context.l10n.commonScramble,
                      enabled: !widget.valueHolder.useCurrentScramble,
                      error: field.errorText,
                      onChanged: field.didChange,
                    ),
                  ),
                ),
              ],
            ),
            MochiSelect(
              label: _label(icon: TablerIcons.gavel, title: context.l10n.commonPenalty),
              value: widget.valueHolder.penalty,
              onChanged: (value) => setState(() => widget.valueHolder.penalty = value),
              options: Penalty.values
                  .map((e) => MochiSelectOption(value: e, label: e.displayName(context.l10n)))
                  .toList(),
            ),
            MochiTextField.multiline(
              label: _label(icon: TablerIcons.message, title: context.l10n.commonComment),
              hint: context.l10n.commentHint,
              onChanged: (value) => widget.valueHolder.comment = value.isEmpty ? null : value,
            ),
          ],
        ),
      ],
    );
  }
}
