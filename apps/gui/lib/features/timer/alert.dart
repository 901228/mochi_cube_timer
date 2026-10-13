import "package:cube_timer/cube_timer.dart";
import "package:flutter/foundation.dart";
import "package:flutter/services.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:mochi_ui/mochi_ui.dart";

extension AlertTypeName on AlertType {
  String get displayName => switch (this) {
    .text => "Text",
    .audio => "Audio",
    .vibration => "Vibration",
  };

  /// Vibration needs a phone; elsewhere HapticFeedback does nothing.
  bool get supported => switch (this) {
    .vibration => !kIsWeb && (defaultTargetPlatform == .iOS || defaultTargetPlatform == .android),
    _ => true,
  };
}

/// How many of the inspection alerts [state] is past: 0, 1 or 2.
int inspectionAlertStage(TimerState state, Duration inspectionDuration) {
  if (state is! TimerRunInInspection) return 0;
  final elapsed = inspectionDuration.inSeconds - (state.inspection / 1000).ceil();
  final (first, second) = TimerConfig.alertTime(inspectionDuration);
  return elapsed >= second.inSeconds ? 2 : (elapsed >= first.inSeconds ? 1 : 0);
}

/// Gives the inspection alerts that are not text, once each as inspection passes them.
///
/// A listener rather than part of a build, which may run any number of times in that second.
class InspectionAlerts extends StatelessWidget {
  const InspectionAlerts({super.key, required this.settings, required this.child});

  final SettingsEntry settings;
  final Widget child;

  @override
  Widget build(BuildContext context) => BlocListener<TimerBloc, TimerState>(
    listenWhen: (previous, current) {
      if (!settings.alertEnabled) return false;
      final duration = context.read<TimerBloc>().runConfig.inspectionDuration;
      return inspectionAlertStage(current, duration) > inspectionAlertStage(previous, duration);
    },
    listener: (context, state) {
      final duration = context.read<TimerBloc>().runConfig.inspectionDuration;
      if (settings.alertTypes.contains(AlertType.vibration)) {
        // The second is the longer buzz, so the two can be told apart without looking.
        inspectionAlertStage(state, duration) == 1 ? HapticFeedback.heavyImpact() : HapticFeedback.vibrate();
      }
      // TODO: audio
    },
    child: child,
  );
}
