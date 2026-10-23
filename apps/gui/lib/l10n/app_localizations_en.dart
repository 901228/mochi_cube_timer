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
  String get settingsTimerBehavior => 'Timer Behavior';

  @override
  String get settingsPuzzle => 'Puzzle Color';

  @override
  String get settingsInspection => 'Inspection Behavior';

  @override
  String get settingsTimerAppearance => 'Timer Appearance';

  @override
  String get settingsStats => 'Statistics';

  @override
  String get settingsAbout => 'About';

  @override
  String get settingsOther => 'Other';

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
  String get aboutVersion => 'Version';

  @override
  String get aboutCredits => 'Credits';

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
  String get timerInput => 'Timer input';

  @override
  String get timerStackmat => 'Use a Stackmat';

  @override
  String get timerStackmatHint =>
      'The Stackmat on the audio input starts and stops the solves. The screen then only opens inspection.';

  @override
  String get timerDisplay => 'Time Display';

  @override
  String get timerHold => 'Hold to start';

  @override
  String get timerHoldHint => 'How long the screen is held before the timer is ready';

  @override
  String get timerShown => 'Shown on the timer page';

  @override
  String get timerShowScrambleImage => 'Scramble image';

  @override
  String get timerShowScrambleImageHint => 'Show the picture of the scramble';

  @override
  String get timerShowSessionStats => 'Session statistics';

  @override
  String get timerShowSessionStatsHint => 'Show the statistics of the session';

  @override
  String get timerShowQuickActions => 'Quick actions';

  @override
  String get timerShowQuickActionsHint => 'Show the penalty, comment and delete buttons after a solve';

  @override
  String get statsAverages => 'Averages';

  @override
  String get statsAverageTrim => 'Average trim';

  @override
  String get statsAverageTrimHint =>
      'The share of the solves left out at each end of an average, the best and the worst ones';

  @override
  String statsAverageTrimOption(int percent) {
    return '$percent%';
  }

  @override
  String get timerDecimals => 'Decimal places';

  @override
  String get timerDecimalsHint => 'How many decimals the time on the timer page shows';

  @override
  String timerDecimalsOption(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count decimals',
      one: '1 decimal',
    );
    return '$_temp0';
  }

  @override
  String get timerShowRunningTime => 'Show time while timing';

  @override
  String get timerShowRunningTimeHint => 'When off, shows ... until the solve stops';

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
  String get puzzleMegaminxColors => 'Megaminx colors';

  @override
  String get puzzleFtoColors => 'FTO colors';

  @override
  String get puzzleClockColors => 'Clock colors';

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
  String get statDeviation => 'SD';

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

  @override
  String get commonArchive => 'Archive';

  @override
  String get commonUnarchive => 'Unarchive';

  @override
  String get commonMoveTo => 'Move to';

  @override
  String get commonPenalty => 'Penalty';

  @override
  String get commonComment => 'Comment';

  @override
  String get commonScramble => 'Scramble';

  @override
  String get commonSave => 'Save';

  @override
  String get commonExport => 'Export';

  @override
  String get commonImport => 'Import';

  @override
  String get commonRename => 'Rename';

  @override
  String get commonSelect => 'Select';

  @override
  String get commonSettings => 'Settings';

  @override
  String get commonAdd => 'Add';

  @override
  String get commonAny => 'Any';

  @override
  String get recordDetail => 'Record Detail';

  @override
  String get recordCommentEmpty => 'Comment something...';

  @override
  String get recordEditComment => 'Edit comment';

  @override
  String get recordDeleteMessage => 'This record will be permanently deleted.';

  @override
  String get recordsNone => 'No records yet';

  @override
  String get recordsDeleteAllTitle => 'Delete all records?';

  @override
  String get recordsDeleteAllMessage => 'All solves will be permanently deleted.';

  @override
  String get recordsArchiveAllTitle => 'Archive all records?';

  @override
  String get recordsArchiveAllMessage => 'All solves will be archived.';

  @override
  String get addRecordTitle => 'Add record';

  @override
  String get addRecordInvalidTime => 'Invalid time';

  @override
  String get addRecordSolveTime => 'Solve Time';

  @override
  String get addRecordUseCurrent => 'Use current scramble';

  @override
  String get addRecordScrambleRequired => 'Scramble is required';

  @override
  String get searchAddRecord => 'Add a record';

  @override
  String get searchComments => 'Search comments';

  @override
  String get searchDeleteAll => 'Delete all';

  @override
  String get sortNewest => 'Newest first';

  @override
  String get sortOldest => 'Oldest first';

  @override
  String get sortFastest => 'Fastest first';

  @override
  String get sortSlowest => 'Slowest first';

  @override
  String sortTooltip(String label) {
    return 'Sort: $label';
  }

  @override
  String get filterRecords => 'Filter records';

  @override
  String filterRecordsActive(int active) {
    return 'Filter records ($active on)';
  }

  @override
  String get filterDate => 'Date';

  @override
  String get filterAnyTime => 'Any time';

  @override
  String get filterClear => 'Clear filters';

  @override
  String get statsCurrent => 'Current Stats';

  @override
  String get statsSolveCount => 'Solve Count';

  @override
  String get statsSolveMean => 'Solve Mean';

  @override
  String get statsSolveDeviation => 'Solve Deviation';

  @override
  String get statsBestSingle => 'Best Single';

  @override
  String get statsBestStats => 'Best Stats';

  @override
  String get statsBestAo5 => 'Best Ao5';

  @override
  String get statsSolveTimes => 'Solve Times';

  @override
  String get statsDistribution => 'Time Distribution';

  @override
  String get statsNoSolves => 'There is no solve yet';

  @override
  String get statsNotEnough => 'Not enough solves yet';

  @override
  String statsMedian(String value) {
    return 'Median $value';
  }

  @override
  String homeSetPenaltyAll(String penalty) {
    return 'Set all records Penalty to $penalty?';
  }

  @override
  String homeMoveAll(String name) {
    return 'Move all records to $name?';
  }

  @override
  String get homeDeselectAll => 'Deselect all';

  @override
  String get homeSelectAll => 'Select all';

  @override
  String get homeSelectPuzzle => 'Select a puzzle';

  @override
  String get homeShowArchived => 'Show archived records';

  @override
  String get homeSessions => 'Sessions';

  @override
  String get sessionSelect => 'Select a session';

  @override
  String get sessionCreate => 'Create new session';

  @override
  String get sessionImport => 'Import to new session';

  @override
  String get sessionDeleteTitle => 'Delete session?';

  @override
  String sessionDeleteMessage(String name) {
    return 'All solves in \"$name\" will be permanently deleted.';
  }

  @override
  String get importPickTitle => 'Pick a csv file of records';

  @override
  String get importDefaultName => 'Imported';

  @override
  String get importTitle => 'Import records?';

  @override
  String importMessageNew(int count, String name) {
    return '$count records will be added to a new session \"$name\".';
  }

  @override
  String importMessageExisting(int count, String name) {
    return '$count records will be added to \"$name\".';
  }

  @override
  String importSkipped(int skipped) {
    return ' $skipped unreadable rows will be skipped.';
  }

  @override
  String get importDone => 'Records imported';

  @override
  String importDoneDescription(int count, String name) {
    return 'Added $count records to \"$name\".';
  }

  @override
  String get importFailed => 'Can\'t import this file';

  @override
  String get importNotRecords => 'Not a records file: needs Puzzle, Scramble, Time and Datetime columns';

  @override
  String get exportTitle => 'Export session';

  @override
  String get exportAsCsv => 'Export as CSV';

  @override
  String get exportIncludeDeleted => 'Include deleted records';

  @override
  String get exportPickTitle => 'Output session to a csv file';

  @override
  String get exportDone => 'Session exported';

  @override
  String get exportDonePrefix => 'Export session records to ';

  @override
  String get timerInspectionHint => 'INSPECTION';

  @override
  String get timerGo => 'GO!';

  @override
  String get navTimer => 'Timer';

  @override
  String get navRecords => 'Records';

  @override
  String get navStats => 'Stats';

  @override
  String get puzzleCube2 => '2x2';

  @override
  String get puzzleCube3 => '3x3';

  @override
  String get puzzleCube4 => '4x4';

  @override
  String get puzzleCube5 => '5x5';

  @override
  String get puzzleCube6 => '6x6';

  @override
  String get puzzleCube7 => '7x7';

  @override
  String get puzzleClock => 'Clock';

  @override
  String get puzzleFto => 'FTO';

  @override
  String get puzzleMegaminx => 'Megaminx';

  @override
  String get puzzlePyraminx => 'Pyraminx';

  @override
  String get puzzleSkewb => 'Skewb';

  @override
  String get puzzleSquare1 => 'Square-1';

  @override
  String timerAlertFirst(int seconds) {
    return '${seconds}s!';
  }

  @override
  String timerAlertSecond(int seconds) {
    return '${seconds}s!!';
  }
}
