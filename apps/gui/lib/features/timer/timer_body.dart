import "package:cube_timer/cube_timer.dart";
import "package:flutter/foundation.dart";
import "package:flutter/gestures.dart";
import "package:flutter/services.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:go_router/go_router.dart";
import "package:mochi_ui/mochi_ui.dart";

import "../../shared/puzzles.dart";
import "../../shared/utils.dart";
import "../../theme.dart";
import "record_break.dart";
import "timer_focus.dart";
import "timer_text.dart";
import "../../l10n/l10n.dart";

class TimerBody extends StatefulWidget {
  final Color? color;
  final SettingsEntry settings;

  /// Whether inspection shows its alerts as text.
  final bool alertText;

  /// What the solve just finished broke, if anything.
  final ValueListenable<RecordBreak?> recordBreak;

  /// The best averages it set, if any.
  final ValueListenable<List<AverageBreak>> averageBreaks;
  const TimerBody({
    super.key,
    this.color,
    this.alertText = true,
    required this.settings,
    required this.recordBreak,
    required this.averageBreaks,
  });

  @override
  State<TimerBody> createState() => _TimerBodyState();
}

class _TimerBodyState extends State<TimerBody> {
  /// Whether the space press currently held down was sent to the bloc, so its
  /// release is delivered even if the page stopped being active in between.
  bool _spaceHeld = false;

  @override
  void initState() {
    super.initState();
    // Listen app-wide instead of through a Focus: clicking any button moves
    // focus away and never brings it back, which left the keys dead.
    HardwareKeyboard.instance.addHandler(_handleKey);
  }

  @override
  void dispose() {
    HardwareKeyboard.instance.removeHandler(_handleKey);
    super.dispose();
  }

  /// The timer takes keys only while its branch is shown and no dialog, sheet
  /// or page sits on top of it, in the branch navigator or the root one.
  bool get _active {
    final shell = StatefulNavigationShell.maybeOf(context);
    if (shell == null) return false;

    final branch = shell.widget.route.branches[shell.currentIndex];
    return branch.navigatorKey.currentState == Navigator.of(context) &&
        (ModalRoute.of(context)?.isCurrent ?? false) &&
        (ModalRoute.of(shell.context)?.isCurrent ?? false);
  }

  bool _handleKey(KeyEvent event) {
    if (!mounted) return false;
    final bloc = context.read<TimerBloc>();

    if (event.logicalKey == LogicalKeyboardKey.space && event is KeyUpEvent && _spaceHeld) {
      _spaceHeld = false;
      bloc.add(TimerReleased());
      return true;
    }

    if (!_active) return false;

    switch (event.logicalKey) {
      case LogicalKeyboardKey.space:
        // Also swallows repeats, so a focused button never sees the space.
        if (event is KeyDownEvent) {
          _spaceHeld = true;
          bloc.add(TimerPressed());
        }
        return true;
      case LogicalKeyboardKey.escape:
        if (event is KeyDownEvent) bloc.add(TimerCanceled());
        return true;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    final TimerBody(:color, :settings, :alertText, :recordBreak, :averageBreaks) = widget;

    final pressedColor = settings.timerPressedColor.toColor();
    final holdingColor = settings.timerHoldingColor.toColor();
    final acceptColor = settings.timerAcceptColor.toColor();

    return BlocBuilder<TimerBloc, TimerState>(
      buildWhen: (prev, state) => prev.runtimeType != state.runtimeType || prev.hold != state.hold,
      builder: (context, state) {
        return DefaultTextStyle(
          style: context.theme.timer.xl8.copyWith(
            color: switch (state.hold) {
              .armed => acceptColor,
              .waiting => state is TimerRunInInspection ? holdingColor : pressedColor,
              .stopping => pressedColor, // complete and pressed
              .none => state is TimerRunInInspection ? pressedColor : (color ?? context.colors.foreground),
            },
          ),
          textHeightBehavior: const TextHeightBehavior(
            applyHeightToFirstAscent: false,
            applyHeightToLastDescent: false,
          ),
          child: Stack(
            children: [
              Positioned.fill(child: RecordRipple(record: recordBreak)),
              const Positioned.fill(child: TimerPressArea()),
              state is TimerRunInInspection
                  ? InspectionText(alertText: alertText)
                  : (state is TimerInitial || state.hold == .armed
                        ? const IgnorePointer(child: Center(child: Text("0.00")))
                        : RunTimeText(recordBreak: recordBreak, averageBreaks: averageBreaks)),
            ],
          ),
        );
      },
    );
  }
}

/// Takes the presses that drive the timer.
class TimerPressArea extends StatefulWidget {
  const TimerPressArea({super.key});

  @override
  State<TimerPressArea> createState() => _TimerPressAreaState();
}

class _TimerPressAreaState extends State<TimerPressArea> {
  /// The pointer driving the timer. Other fingers and non-primary mouse
  /// buttons are ignored so they can't send an extra press or release.
  int? _pointer;

  /// Where that pointer came down, to tell a press from the start of a swipe.
  Offset _down = Offset.zero;

  @override
  Widget build(BuildContext context) => Listener(
    behavior: .opaque,
    onPointerDown: (e) {
      if (_pointer != null) return;
      if (e.kind == .mouse && e.buttons != kPrimaryButton) return;
      _pointer = e.pointer;
      _down = e.position;
      context.read<TimerBloc>().add(TimerPressed());
    },
    onPointerMove: (e) {
      if (e.pointer != _pointer || e.kind == .mouse) return;
      // A swipe turns the page rather than driving the timer, until a solve is on and holding still
      // is the point; the pages' own drag listens to the same finger without telling this.
      if (context.read<TimerFocusCubit>().state || (e.position.dx - _down.dx).abs() < kTouchSlop) return;
      _pointer = null;
      context.read<TimerBloc>().add(TimerPressCanceled());
    },
    onPointerUp: (e) {
      if (e.pointer != _pointer) return;
      _pointer = null;
      context.read<TimerBloc>().add(TimerReleased());
    },
    onPointerCancel: (e) {
      if (e.pointer != _pointer) return;
      _pointer = null;
      context.read<TimerBloc>().add(TimerPressCanceled());
    },
    child: const SizedBox.expand(),
  );
}

class InspectionText extends StatelessWidget {
  const InspectionText({super.key, this.alertText = true});

  final bool alertText;

  @override
  Widget build(BuildContext context) {
    // Ceiling, not truncation: `~/` rounds toward zero, so it maps both 0.3s
    // and -0.3s to 0 and the countdown never shows a negative second.
    final seconds = context.select((TimerBloc bloc) => (bloc.state.inspection / 1000).ceil());
    final displayText = (seconds <= 0) ? "+2" : seconds.toString();

    // alert
    final inspectionDuration = context.select((TimerBloc bloc) => bloc.runConfig.inspectionDuration);
    final elapsedSeconds = inspectionDuration.inSeconds - seconds;
    final (firstAlertTime, secondAlertTime) = TimerConfig.alertTime(inspectionDuration);

    final colors = context.theme.colors;
    final hintTextStyle = context.theme.timer.sm;
    final hintTextColor = colors.mutedForeground;
    final alertTextStyle = context.theme.timer.xl4.copyWith(color: hintTextColor);

    return TimerText(
      time: Text(displayText),
      hint: Text(context.l10n.timerInspectionHint, style: hintTextStyle.copyWith(color: hintTextColor)),
      rightHint: !alertText
          ? null
          : seconds <= 0
          ? Text(context.l10n.timerGo, style: alertTextStyle)
          : elapsedSeconds == firstAlertTime.inSeconds
          ? Text(context.l10n.timerAlertFirst(firstAlertTime.inSeconds), style: alertTextStyle)
          : elapsedSeconds == secondAlertTime.inSeconds
          ? Text(context.l10n.timerAlertSecond(secondAlertTime.inSeconds), style: alertTextStyle)
          : null,
    );
  }
}

class RunTimeText extends StatelessWidget {
  const RunTimeText({super.key, required this.recordBreak, required this.averageBreaks});

  final ValueListenable<RecordBreak?> recordBreak;
  final ValueListenable<List<AverageBreak>> averageBreaks;

  Future<String?> _showCommentDialog(BuildContext context, String initComment) => showMochiPrompt(
    context,
    title: initComment.isEmpty ? context.l10n.commentAdd : context.l10n.commentEdit,
    multiline: true,
    hint: context.l10n.commentHint,
    initialValue: initComment,
  );

  Widget _actions(BuildContext context, Penalty penalty) {
    final bloc = context.read<TimerBloc>();
    final comment = context.select(
      (TimerBloc bloc) => switch (bloc.state) {
        TimerRunComplete(:final comment) => comment,
        _ => "",
      },
    );

    return Row(
      mainAxisSize: .min,
      spacing: 8,
      children: [
        MochiButton.icon(
          onPress: () async {
            final answer = await showMochiConfirm(
              context,
              title: context.l10n.deleteRecordTitle,
              message: context.l10n.deleteRecordMessage,
              confirmLabel: context.l10n.commonDelete,
              destructive: true,
            );

            if (answer) bloc.add(TimerDeleteRecord());
          },
          tooltip: context.l10n.commonDelete,
          icon: const Icon(TablerIcons.x),
        ),
        MochiButton.icon(
          selected: penalty == .dnf,
          onPress: () => bloc.add(TimerChangePenalty(penalty == .dnf ? .none : .dnf)),
          tooltip: Penalty.dnf.displayName(context.l10n),
          icon: Icon(Penalty.dnf.icon),
        ),
        MochiButton.icon(
          selected: penalty == .plus2,
          onPress: () => bloc.add(TimerChangePenalty(penalty == .plus2 ? .none : .plus2)),
          tooltip: Penalty.plus2.displayName(context.l10n),
          icon: Icon(Penalty.plus2.icon),
        ),
        MochiButton.icon(
          onPress: () async {
            final newComment = await _showCommentDialog(context, comment);
            if (newComment == null) return;

            bloc.add(TimerChangeComment(newComment));
          },
          tooltip: context.l10n.commentTooltip,
          icon: const Icon(TablerIcons.message),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final duration = context.select((TimerBloc bloc) => Duration(milliseconds: bloc.state.elapsed));
    final penalty = context.select((TimerBloc bloc) => bloc.state.penalty);
    final showActions = context.select(
      (TimerBloc bloc) => bloc.state is TimerRunComplete && bloc.state.hold == .none,
    );

    final timeText = Text(duration.timerDisplayString(penalty));

    return TimerText(
      time: penalty == .plus2
          ? Row(
              mainAxisSize: .min,
              crossAxisAlignment: .baseline,
              textBaseline: .ideographic,
              spacing: 16,
              children: [
                timeText,
                Icon(
                  Penalty.plus2.icon,
                  color: context.colors.mutedForeground,
                  size: context.theme.timer.xl4.fontSize,
                ),
              ],
            )
          : timeText,
      hint: ListenableBuilder(
        listenable: Listenable.merge([recordBreak, averageBreaks]),
        builder: (context, _) {
          final record = recordBreak.value;
          final averages = averageBreaks.value;
          final style = context.theme.timer.sm;
          return Column(
            mainAxisSize: .min,
            children: [
              if (record != null)
                Text(
                  recordBreakText(record, context.l10n),
                  style: style.copyWith(
                    color: record.kind == .best
                        ? context.colors.primary.base
                        : context.colors.mutedForeground,
                  ),
                ),
              if (averages.isNotEmpty)
                Text(
                  averageBreakText(averages, context.l10n),
                  style: style.copyWith(color: context.colors.primary.base),
                ),
            ],
          );
        },
      ),
      action: showActions ? _actions(context, penalty) : null,
    );
  }
}
