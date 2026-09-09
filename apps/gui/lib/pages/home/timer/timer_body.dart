import "package:cube_timer/cube_timer.dart";
import "package:cupertino_ui/cupertino_ui.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:forui/forui.dart";

import "../../../theme.dart";
import "timer_text.dart";

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
    this.acceptColor = const Color.fromARGB(255, 99, 252, 152),
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
          child: FTappable(
            style: .delta(motion: FTappableMotion.none),
            child: state is TimerRunInInspection
                ? const InspectionText()
                : (state is TimerInitial || state.hold == .armed
                      ? const Center(child: Text("0.00"))
                      : RunTimeText(showActions: state is TimerRunComplete && state.hold == .none)),
            onPressDown: (_) {
              context.read<TimerBloc>().add(TimerPressed());
            },
            onPressUp: (_) {
              context.read<TimerBloc>().add(TimerReleased());
            },
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

    final hintTextStyle = context.theme.typography.timer.sm;
    final colors = context.theme.colors;

    return TimerText(
      time: Text(displayText),
      hint: Text(
        "INSPECTION",
        style: hintTextStyle.copyWith(color: colors.disable(hintTextStyle.color ?? colors.foreground)),
      ),
    );
  }
}

class RunTimeText extends StatelessWidget {
  final bool showActions;
  const RunTimeText({super.key, this.showActions = false});

  String _durationToString(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");

    String negativeSign = duration.isNegative ? "-" : "";
    bool hasHours = duration.inHours > 0;
    String twoDigitHours = hasHours ? "${duration.inHours}:" : "";

    bool hasMinutes = duration.inMinutes > 0 || hasHours;
    String twoDigitMinutes = hasMinutes
        ? "${hasHours ? twoDigits(duration.inMinutes.remainder(60).abs()) : duration.inMinutes.toString()}:"
        : "";

    String twoDigitSeconds = hasMinutes
        ? twoDigits(duration.inSeconds.remainder(60).abs())
        : duration.inSeconds.toString();
    String twoDigitMilliseconds = twoDigits((duration.inMilliseconds.remainder(1000).abs() / 10).round());

    return "$negativeSign$twoDigitHours$twoDigitMinutes$twoDigitSeconds.$twoDigitMilliseconds";
  }

  Widget _actions() => Row(
    mainAxisSize: .min,
    spacing: 8,
    children: [
      FTooltip(
        tipBuilder: (context, controller) => Text("Delete"),
        child: FButton.icon(
          onPress: () {
            // TODO: delete this record
          },
          child: Icon(FLucideIcons.x),
        ),
      ),
      FTooltip(
        tipBuilder: (context, controller) => Text("DNF"),
        child: FButton.icon(
          onPress: () {
            // TODO: dnf this record
          },
          child: Icon(FLucideIcons.ban),
        ),
      ),
      FTooltip(
        tipBuilder: (context, controller) => Text("+2"),
        child: FButton.icon(
          onPress: () {
            // TODO: add +2 to this record
          },
          child: Icon(FLucideIcons.clockPlus),
        ),
      ),
      FTooltip(
        tipBuilder: (context, controller) => Text("Comment"),
        child: FButton.icon(
          onPress: () {
            // TODO: comment on this record
          },
          child: Icon(FLucideIcons.messageSquareMore),
        ),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    final duration = context.select((TimerBloc bloc) => Duration(milliseconds: bloc.state.elapsed));
    final penalty = context.select((TimerBloc bloc) => bloc.state.penalty);

    return TimerText(
      time: Text(penalty == .dnf ? "DNF" : _durationToString(duration)),
      action: showActions ? _actions() : null,
    );
  }
}
