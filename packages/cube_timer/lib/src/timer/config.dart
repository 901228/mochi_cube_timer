import "package:equatable/equatable.dart";

import "../database/app_database.dart";

class TimerConfig extends Equatable {
  const TimerConfig({this.inspectionEnabled = true, this.inspectionDuration = const Duration(seconds: 15)});

  factory TimerConfig.fromSettings(SettingsEntry s) => TimerConfig(
    inspectionEnabled: s.inspectionEnabled,
    inspectionDuration: Duration(seconds: s.inspectDuration),
  );

  final bool inspectionEnabled;
  final Duration inspectionDuration;

  /// inspection dnf threshold
  Duration get inspectionDnfThreshold => inspectionDuration + const Duration(seconds: 2);

  @override
  List<Object> get props => [inspectionEnabled, inspectionDuration];
}
