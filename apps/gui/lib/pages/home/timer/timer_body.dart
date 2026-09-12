import "package:cube_timer/cube_timer.dart";
import "package:flutter/services.dart";
import "package:flutter/widgets.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:forui/forui.dart";
import "package:go_router/go_router.dart";

import "../../../theme.dart";
import "../../../utils.dart";
import "../../../widgets.dart";
import "timer_text.dart";

// TODO: push a new page when record started

class TimerBody extends StatelessWidget {
  final Color? color;
  final Color pressedColor;
  final Color holdingColor;
  final Color acceptColor;
  const TimerBody({
    super.key,
    this.color,
    this.pressedColor = const Color.fromARGB(255, 255, 121, 121),
    this.holdingColor = const Color.fromARGB(255, 255, 255, 121),
    this.acceptColor = const Color.fromARGB(255, 32, 226, 100),
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimerBloc, TimerState>(
      buildWhen: (prev, state) => prev.runtimeType != state.runtimeType || prev.hold != state.hold,
      builder: (context, state) {
        return DefaultTextStyle(
          style: context.theme.typography.timer.xl8.copyWith(
            color: switch (state.hold) {
              .armed => acceptColor,
              .waiting => state is TimerRunInInspection ? holdingColor : pressedColor,
              .stopping => pressedColor, // complete and pressed
              .none => state is TimerRunInInspection ? pressedColor : color,
            },
          ),
          child: Focus(
            autofocus: true,
            onFocusChange: (focused) {
              if (!focused) context.read<TimerBloc>().add(TimerPressCanceled());
            },
            onKeyEvent: (node, event) {
              // ignore repeat event
              if (event is KeyRepeatEvent) {
                return .handled;
              }

              switch (event.logicalKey) {
                case .space:
                  switch (event) {
                    case KeyDownEvent():
                      context.read<TimerBloc>().add(TimerPressed());
                    case KeyUpEvent():
                      context.read<TimerBloc>().add(TimerReleased());
                  }
                  return .handled;
                case .escape:
                  switch (event) {
                    case KeyDownEvent():
                      context.read<TimerBloc>().add(TimerReset());
                  }
                  return .handled;
              }

              return .ignored;
            },
            child: Stack(
              children: [
                Positioned.fill(
                  child: FTappable(
                    style: .delta(motion: FTappableMotion.none),
                    behavior: .opaque,
                    onPressDown: (_) {
                      context.read<TimerBloc>().add(TimerPressed());
                    },
                    onPressUp: (_) {
                      context.read<TimerBloc>().add(TimerReleased());
                    },
                    onPressCancel: () {
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
                    child: FButton.icon(
                      onPress: () {
                        context.read<TimerBloc>().add(TimerReset());
                      },
                      child: const Icon(FLucideIcons.xCircle),
                    ),
                  ),
              ],
            ),
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
    final hintTextStyle = context.theme.typography.timer.sm;
    final hintTextColor = colors.disable(hintTextStyle.color ?? colors.foreground);
    final alertTextStyle = context.theme.typography.timer.xl4.copyWith(color: hintTextColor);

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

  Future<String?> _showCommentDialog(BuildContext context, String initComment) {
    String comment = initComment;

    return showFDialog<String?>(
      context: context,
      builder: (context, style, animation) => AdaptiveDialog(
        style: style,
        animation: animation,
        title: Text(initComment.isEmpty ? "Add comment" : "Edit comment"),
        body: FTextField(
          control: .managed(
            initial: TextEditingValue(text: initComment),
            onChange: (value) => comment = value.text,
          ),
          hint: "Comment",
          autofocus: true,
          textInputAction: .done,
          onSubmit: context.pop,
        ),
        actions: [
          FButton(variant: .outline, onPress: () => context.pop(null), child: const Text("Cancel")),
          FButton(variant: .primary, onPress: () => context.pop(comment), child: const Text("Confirm")),
        ],
      ),
    );
  }

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
        FTooltip(
          tipBuilder: (context, controller) => Text("Delete"),
          child: FButton.icon(
            onPress: () async {
              final answer = await showConfirmDialog(
                context,
                title: "Delete record?",
                message: "The current solve will be permanently deleted.",
                confirmLabel: "Delete",
                destructive: true,
              );

              if (answer) bloc.add(TimerDeleteRecord());
            },
            child: Icon(FLucideIcons.x),
          ),
        ),
        FTooltip(
          tipBuilder: (context, controller) => Text("DNF"),
          child: FButton.icon(
            selected: penalty == .dnf,
            onPress: () => bloc.add(TimerChangePenalty(penalty == .dnf ? .none : .dnf)),
            child: Icon(FLucideIcons.ban),
          ),
        ),
        FTooltip(
          tipBuilder: (context, controller) => Text("+2"),
          child: FButton.icon(
            selected: penalty == .plus2,
            onPress: () => bloc.add(TimerChangePenalty(penalty == .plus2 ? .none : .plus2)),
            child: Icon(FLucideIcons.clockPlus),
          ),
        ),
        FTooltip(
          tipBuilder: (context, controller) => Text("Comment"),
          child: FButton.icon(
            onPress: () async {
              final newComment = await _showCommentDialog(context, comment);
              if (newComment == null) return;

              bloc.add(TimerChangeComment(newComment));
            },
            child: Icon(FLucideIcons.messageSquareMore),
          ),
        ),
      ],
    );
  }

  Widget plus2Text(BuildContext context) {
    final colors = context.theme.colors;
    final textStyle = context.theme.typography.timer.xl;
    final textColor = colors.disable(textStyle.color ?? colors.foreground);

    return Text("+2", style: textStyle.copyWith(color: textColor));
  }

  @override
  Widget build(BuildContext context) {
    final duration = context.select((TimerBloc bloc) => Duration(milliseconds: bloc.state.elapsed));
    final penalty = context.select((TimerBloc bloc) => bloc.state.penalty);
    final showActions = context.select(
      (TimerBloc bloc) => bloc.state is TimerRunComplete && bloc.state.hold == .none,
    );

    return TimerText(
      time: penalty == .plus2
          ? Row(
              mainAxisSize: .min,
              crossAxisAlignment: .baseline,
              textBaseline: .ideographic,
              spacing: 16,
              children: [Text((duration + Duration(seconds: 2)).timerString), plus2Text(context)],
            )
          : Text(penalty == .dnf ? "DNF" : duration.timerString),
      action: showActions ? _actions(context, penalty) : null,
    );
  }
}
