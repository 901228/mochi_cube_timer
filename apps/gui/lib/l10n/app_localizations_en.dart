// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get languageName => 'English';

  @override
  String get languageFlag => '🇺🇸';

  @override
  String get settingsGeneral => 'General';

  @override
  String get settingsTimer => 'Timer';

  @override
  String get settingsPuzzle => 'Puzzle';

  @override
  String get generalLocale => 'Locale';

  @override
  String get localeSystem => 'System';

  @override
  String get generalAppearance => 'Appearance';

  @override
  String get generalTheme => 'Theme';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get generalPrimaryColor => 'Primary color';

  @override
  String get settingsAbout => 'About';

  @override
  String get aboutVersion => 'Version';

  @override
  String get aboutCredits => 'Credits';

  @override
  String get aboutFlagsCredit => 'Flag emoji: Twemoji, CC-BY 4.0';

  @override
  String get aboutLicenses => 'Open source licenses';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonSubmit => 'Submit';

  @override
  String get commonDefault => 'Default';

  @override
  String get commonNone => 'None';

  @override
  String get alertTypeText => 'Text';

  @override
  String get alertTypeAudio => 'Audio';

  @override
  String get alertTypeVibration => 'Vibration';

  @override
  String get timerInspection => 'Inspection';

  @override
  String get timerInspectionDuration => 'Inspection duration (seconds)';

  @override
  String timerInspectionDurationHint(int seconds) {
    return 'Default duration: $seconds seconds';
  }

  @override
  String get timerAlert => 'Alert';

  @override
  String get timerAlertTimeLeft => 'Alert time left';

  @override
  String get timerAlertWhenPrefix => 'Timer will alert you once ';

  @override
  String get timerAlertWhenAnd => ' and ';

  @override
  String get timerAlertWhenSuffix => ' seconds of inspection have passed';

  @override
  String get timerAlertType => 'Alert type';

  @override
  String get timerAlertTypeHint => 'Choose how the timer will alert you';

  @override
  String get timerRecords => 'Records';

  @override
  String get timerBestAlert => 'New best alert';

  @override
  String get timerBestAlertHint => 'Announce a solve that beats the best of the session';

  @override
  String get timerWorstAlert => 'New worst alert';

  @override
  String get timerWorstAlertHint => 'Announce a solve that is slower than the worst of the session';

  @override
  String get timerAverageAlert => 'New best average alert';

  @override
  String get timerAverageAlertHint => 'Announce a Mo3, Ao5 or Ao12 that beats the best of the session';

  @override
  String get timerColors => 'Colors';

  @override
  String get timerColorPressed => 'Pressed';

  @override
  String get timerColorHolding => 'Holding';

  @override
  String get timerColorAccept => 'Accept';

  @override
  String get puzzleCubeColors => 'Cube colors';

  @override
  String get puzzlePyraminxColors => 'Pyraminx colors';

  @override
  String get puzzleClockColors => 'Clock colors';

  @override
  String get faceUp => 'Up';

  @override
  String get faceDown => 'Down';

  @override
  String get faceLeft => 'Left';

  @override
  String get faceRight => 'Right';

  @override
  String get faceFront => 'Front';

  @override
  String get faceBack => 'Back';

  @override
  String get penaltyNone => 'None';

  @override
  String get penaltyDnf => 'DNF';

  @override
  String get penaltyPlus2 => 'Plus 2 seconds';

  @override
  String get ttsLanguage => 'en-US';

  @override
  String speakSeconds(String seconds) {
    return '$seconds seconds';
  }

  @override
  String get speakNewBest => 'New best';

  @override
  String get speakWorst => 'Worst solve';

  @override
  String speakAverages(String kinds) {
    return 'New best $kinds';
  }

  @override
  String get speakAnd => ' and ';

  @override
  String breakBest(String seconds) {
    return 'New best! −$seconds';
  }

  @override
  String breakWorst(String seconds) {
    return 'Worst so far +$seconds';
  }

  @override
  String breakAverages(String averages) {
    return 'New best $averages';
  }

  @override
  String timerScrambleFailed(String error) {
    return 'Could not scramble: $error';
  }

  @override
  String get timerRecordAdded => 'Record added';

  @override
  String get timerEditScramble => 'Edit scramble';

  @override
  String get timerEnterScramble => 'Enter scramble';

  @override
  String get timerScrambleHint => 'Scramble';

  @override
  String get timerPreviousScramble => 'Previous scramble';

  @override
  String get timerNextScramble => 'Next scramble';

  @override
  String get statDeviation => 'Deviation';

  @override
  String get statMean => 'Mean';

  @override
  String get statBest => 'Best';

  @override
  String get statCount => 'Count';

  @override
  String get commentAdd => 'Add comment';

  @override
  String get commentEdit => 'Edit comment';

  @override
  String get commentHint => 'Comment';

  @override
  String get commentTooltip => 'Comment';

  @override
  String get deleteRecordTitle => 'Delete record?';

  @override
  String get deleteRecordMessage => 'The current solve will be permanently deleted.';

  @override
  String get commonDelete => 'Delete';
}
