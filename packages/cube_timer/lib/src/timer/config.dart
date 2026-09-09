import "package:equatable/equatable.dart";

import "../database/app_database.dart";

class TimerConfig extends Equatable {
  const TimerConfig({
    this.inspectionEnabled = true,
    this.inspectionDuration = const Duration(seconds: 15),
    this.holdDuration = const Duration(milliseconds: 300),
  });

  factory TimerConfig.fromSettings(SettingsEntry s) => TimerConfig(
    inspectionEnabled: s.inspectionEnabled,
    inspectionDuration: Duration(seconds: s.inspectDuration),
    // holdDuration: Duration(seconds: s.holdDuration),
  );

  final bool inspectionEnabled;
  final Duration inspectionDuration;
  final Duration holdDuration;

  /// inspection dnf threshold
  Duration get inspectionDnfThreshold => inspectionDuration + const Duration(seconds: 2);

  @override
  List<Object> get props => [inspectionEnabled, inspectionDuration, holdDuration];
}
