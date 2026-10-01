import "package:cube_timer/cube_timer.dart";
import "package:flutter/gestures.dart";
import "package:flutter/services.dart";
import "package:flutter/widgets.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:go_router/go_router.dart";
import "package:mochi_ui/mochi_ui.dart";

import "../../shared/puzzles.dart";
import "../../shared/utils.dart";
import "../../theme.dart";
import "timer_text.dart";

// TODO: push a new page when record started

class TimerBody extends StatefulWidget {
  final Color? color;
  final Color pressedColor;
  final Color holdingColor;
  final Color acceptColor;
  const TimerBody({
    super.key,
    this.color,
    // TODO: put in settings
    this.pressedColor = const Color.fromARGB(255, 255, 121, 121),
    this.holdingColor = const Color.fromARGB(255, 255, 255, 121),
    this.acceptColor = const Color.fromARGB(255, 32, 226, 100),
  });

  @override
  State<TimerBody> createState() => _TimerBodyState();
}

class _TimerBodyState extends State<TimerBody> {
  /// Whether the space press currently held down was sent to the bloc, so its
  /// release is delivered even if the page stopped being active in between.
  bool _spaceHeld = false;

  /// The pointer driving the timer. Other fingers and non-primary mouse
  /// buttons are ignored so they can't send an extra press or release.
  int? _pointer;

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
        if (event is KeyDownEvent) bloc.add(TimerReset());
        return true;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    final TimerBody(:color, :pressedColor, :holdingColor, :acceptColor) = widget;

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
              Positioned.fill(
                child: Listener(
                  behavior: .opaque,
                  onPointerDown: (e) {
                    if (_pointer != null) return;
                    if (e.kind == .mouse && e.buttons != kPrimaryButton) return;
                    _pointer = e.pointer;
                    context.read<TimerBloc>().add(TimerPressed());
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
                ),
              ),
              state is TimerRunInInspection
                  ? const InspectionText()
                  : (state is TimerInitial || state.hold == .armed
                        ? const IgnorePointer(child: Center(child: Text("0.00")))
                        : const RunTimeText()),
              if (state is TimerRunInInspection || state is TimerRunInProgress)
                Positioned(
                  top: 0,
                  right: 0,
                  child: MochiButton.icon(
                    icon: const Icon(TablerIcons.circleX),
                    onPress: () {
                      context.read<TimerBloc>().add(TimerReset());
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class InspectionText extends StatelessWidget {
  const InspectionText({super.key});

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
      hint: Text("INSPECTION", style: hintTextStyle.copyWith(color: hintTextColor)),
      rightHint: elapsedSeconds == firstAlertTime.inSeconds
          ? Text("${firstAlertTime.inSeconds}s!", style: alertTextStyle)
          : elapsedSeconds == secondAlertTime.inSeconds
          ? Text("${secondAlertTime.inSeconds}s!!", style: alertTextStyle)
          : null,
    );
  }
}

class RunTimeText extends StatelessWidget {
  const RunTimeText({super.key});

  Future<String?> _showCommentDialog(BuildContext context, String initComment) => showMochiPrompt(
    context,
    title: initComment.isEmpty ? "Add comment" : "Edit comment",
    multiline: true,
    hint: "Comment",
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
              title: "Delete record?",
              message: "The current solve will be permanently deleted.",
              confirmLabel: "Delete",
              destructive: true,
            );

            if (answer) bloc.add(TimerDeleteRecord());
          },
          tooltip: "Delete",
          icon: const Icon(TablerIcons.x),
        ),
        MochiButton.icon(
          selected: penalty == .dnf,
          onPress: () => bloc.add(TimerChangePenalty(penalty == .dnf ? .none : .dnf)),
          tooltip: Penalty.dnf.displayName,
          icon: Icon(Penalty.dnf.icon),
        ),
        MochiButton.icon(
          selected: penalty == .plus2,
          onPress: () => bloc.add(TimerChangePenalty(penalty == .plus2 ? .none : .plus2)),
          tooltip: Penalty.plus2.displayName,
          icon: Icon(Penalty.plus2.icon),
        ),
        MochiButton.icon(
          onPress: () async {
            final newComment = await _showCommentDialog(context, comment);
            if (newComment == null) return;

            bloc.add(TimerChangeComment(newComment));
          },
          tooltip: "Comment",
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
      action: showActions ? _actions(context, penalty) : null,
    );
  }
}
