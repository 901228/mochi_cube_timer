import "package:cube_timer/cube_timer.dart";
import "package:flutter/foundation.dart";
import "package:flutter/services.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_tts/flutter_tts.dart";
import "package:mochi_ui/mochi_ui.dart";
import "package:vibration/vibration.dart";

extension AlertTypeName on AlertType {
  String get displayName => switch (this) {
    .text => "Text",
    .audio => "Audio",
    .vibration => "Vibration",
  };

  /// Vibration needs a phone; elsewhere it does nothing. flutter_tts has no Linux voice.
  bool get supported => switch (this) {
    .vibration => !kIsWeb && (defaultTargetPlatform == .iOS || defaultTargetPlatform == .android),
    .audio => kIsWeb || defaultTargetPlatform != .linux,
    .text => true,
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

/// One unbroken buzz, not [HapticFeedback.vibrate], which iOS mutes with the ringer, nor repeated
/// impacts, which feel like separate taps.
Future<void> buzz({required int duration, int amplitude = 255}) async {
  if (await Vibration.hasCustomVibrationsSupport()) {
    await Vibration.vibrate(duration: duration, amplitude: amplitude);
  } else {
    await HapticFeedback.heavyImpact();
  }
}

extension SettingsVibration on SettingsEntry {
  /// Whether the user wants alerts, with vibration among them, where it can be given.
  bool get vibrates =>
      alertEnabled && alertTypes.contains(AlertType.vibration) && AlertType.vibration.supported;
}

/// A buzz per inspection alert, longer and stronger as inspection runs out, so they can be told
/// apart without looking.
Future<void> _buzz(int stage) {
  final (duration, amplitude) = switch (stage) {
    1 => (200, 204),
    2 => (400, 255),
    _ => (1500, 255),
  };
  return buzz(duration: duration, amplitude: amplitude);
}

/// Top-level, so set up on the first alert spoken: iOS keeps speech quiet under the Silent switch unless it
/// plays back, and mixing leaves music the user has on playing.
final Future<FlutterTts> _tts = () async {
  final tts = FlutterTts();
  await tts.setLanguage("en-US");
  await tts.setIosAudioCategory(IosTextToSpeechAudioCategory.playback, [
    IosTextToSpeechAudioCategoryOptions.mixWithOthers,
  ]);
  return tts;
}();

Future<void> speak(String text) async => (await _tts).speak(text);

extension SettingsAudio on SettingsEntry {
  /// Whether the user wants alerts, with audio among them, where it can be given.
  bool get speaks => alertEnabled && alertTypes.contains(AlertType.audio) && AlertType.audio.supported;
}

/// Calls out the time passed, as a judge does; the +2 has its own text and buzz, and nothing to
/// say that the time does not already.
Future<void> _speak(int stage, Duration inspectionDuration) async {
  final (first, second) = TimerConfig.alertTime(inspectionDuration);
  final seconds = switch (stage) {
    1 => first.inSeconds,
    2 => second.inSeconds,
    _ => null,
  };
  if (seconds != null) await speak("$seconds seconds");
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
      final stage = inspectionAlertStage(state, duration);
      final types = settings.alertTypes.where((e) => e.supported);
      if (types.contains(AlertType.vibration)) _buzz(stage);
      if (types.contains(AlertType.audio)) _speak(stage, duration);
    },
    child: child,
  );
}
