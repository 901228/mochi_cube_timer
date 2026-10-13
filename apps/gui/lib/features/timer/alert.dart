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

/// How many of the inspection alerts [state] is past: 0 to 3, the last being the +2 at the end.
int inspectionAlertStage(TimerState state, Duration inspectionDuration) {
  if (state is! TimerRunInInspection) return 0;
  final left = (state.inspection / 1000).ceil();
  if (left <= 0) return 3;
  final elapsed = inspectionDuration.inSeconds - left;
  final (first, second) = TimerConfig.alertTime(inspectionDuration);
  return elapsed >= second.inSeconds ? 2 : (elapsed >= first.inSeconds ? 1 : 0);
}

/// Impacts rather than [HapticFeedback.vibrate], which iOS mutes with the ringer; the count tells
/// the alerts apart without looking.
Future<void> _buzz(int times) async {
  for (var i = 0; i < times; i++) {
    if (i > 0) await Future<void>.delayed(const Duration(milliseconds: 80));
    await HapticFeedback.heavyImpact();
  }
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
        _buzz(const [0, 1, 2, 4][inspectionAlertStage(state, duration)]);
      }
      // TODO: audio
    },
    child: child,
  );
}
