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
  String get homeKindPuzzles => 'Puzzles';

  @override
  String get homeKindAlgorithms => 'Algorithms';

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

  @override
  String get timerScrambleCopied => 'Scramble copied';

  @override
  String get algorithmsTitle => 'Algorithms';

  @override
  String get algorithmsSelectSet => 'Select an algorithm set';

  @override
  String algorithmsCasesCount(int count) {
    return '$count cases';
  }

  @override
  String get algorithmsCopied => 'Algorithm copied';

  @override
  String get algorithmsExpandAll => 'Expand all';

  @override
  String get algorithmsCollapseAll => 'Collapse all';

  @override
  String algorithmsNoSets(String puzzle) {
    return 'There are no algorithm sets for $puzzle';
  }

  @override
  String get practiceCrossName => 'Cross';

  @override
  String get practiceCrossDescription => 'Solve just the bottom cross';

  @override
  String get practiceViewList => 'List';

  @override
  String get practiceViewGrid => 'Grid';

  @override
  String get practiceCasesTitle => 'Cases to practise';

  @override
  String practiceCasesCount(int selected, int total) {
    return '$selected of $total cases';
  }

  @override
  String get simulatorTitle => 'Simulator';

  @override
  String get simulatorMovesHint => 'Moves, e.g. R U R\' U\'';

  @override
  String get simulatorToStart => 'To start';

  @override
  String get simulatorStepBack => 'Step back';

  @override
  String get simulatorPlay => 'Play';

  @override
  String get simulatorPause => 'Pause';

  @override
  String get simulatorStepForward => 'Step forward';

  @override
  String get simulatorToEnd => 'To end';

  @override
  String get simulatorSettings => 'Simulator settings';

  @override
  String get simulatorHintDistance => 'Hint sticker distance';

  @override
  String get simulatorHintOff => 'Off';

  @override
  String get simulatorSpeed => 'Turn speed';

  @override
  String get simulatorStickerless => 'Stickerless';

  @override
  String get simulatorLoop => 'Loop';

  @override
  String get simulatorLoopHint => 'After pressing play, start again once done';

  @override
  String get simulatorResetView => 'Reset view';

  @override
  String get simulatorCubeSize => 'Cube size';

  @override
  String get simulatorResetSettings => 'Restore defaults';

  @override
  String get simulatorReset => 'Reset';

  @override
  String simulatorInvalidMove(String move) {
    return 'Can\'t read: $move';
  }

  @override
  String get trainersTitle => 'Trainers';

  @override
  String get trainerPllRecognitionTitle => 'Two-side PLL recognition';

  @override
  String get trainerPllRecognitionDescription => 'Name the PLL case from the front and right sides alone';

  @override
  String trainerAnswerWas(String name) {
    return 'It was $name';
  }

  @override
  String get trainerNext => 'Next';

  @override
  String get trainerTabPractice => 'Practice';

  @override
  String trainerPattern(String group, String rule) {
    return '$group: $rule';
  }

  @override
  String get pllGroupThreeBar => '3-bar';

  @override
  String get pllGroupThreeBarInfo => 'One side is all one colour.';

  @override
  String get pllGroupDoubleLights => 'Double lights';

  @override
  String get pllGroupDoubleLightsInfo =>
      'Both sides have headlights: two corners of one colour with a different edge between them.';

  @override
  String get pllGroupLightsAndBar => 'Lights + 2-bar';

  @override
  String get pllGroupLightsAndBarInfo => 'Headlights on one side and a 2-bar on the other.';

  @override
  String get pllGroupLoneLights => 'Lone lights';

  @override
  String get pllGroupLoneLightsInfo => 'Headlights on one side; the other side has no bar and no lights.';

  @override
  String get pllGroupDoubleBar => 'Double 2-bar';

  @override
  String get pllGroupDoubleBarInfo => 'A 2-bar on each side.';

  @override
  String get pllGroupOutsideBar => 'Outside 2-bar';

  @override
  String get pllGroupOutsideBarInfo => 'Only one 2-bar, at the outer end.';

  @override
  String get pllGroupInsideBar => 'Inside 2-bar';

  @override
  String get pllGroupInsideBarInfo => 'Only one 2-bar, next to the middle of the strip.';

  @override
  String get pllGroupBookends => 'Bookends, no bar';

  @override
  String get pllGroupBookendsInfo => 'No bars or lights, but the two outermost stickers match.';

  @override
  String get pllGroupNoBookends => 'No bookends';

  @override
  String get pllGroupNoBookendsInfo => 'None of the above: the two outermost stickers differ.';

  @override
  String get pllRuleThreeBarHeadlights => 'Headlights on the other side';

  @override
  String get pllRuleThreeBarTwoBar => 'A 2-bar on the other side';

  @override
  String get pllRuleThreeBarFourColours => 'Three different colours on the other side (4 colours in all)';

  @override
  String get pllRuleDoubleLightsChecker => 'Only two colours, in a checkerboard (6-checker)';

  @override
  String get pllRuleDoubleLights21 =>
      '3 colours: the edge of one side matches the corners of the other (2:1)';

  @override
  String get pllRuleDoubleLightsOpposite => '4 colours; each edge is opposite the colour of its lights';

  @override
  String get pllRuleDoubleLightsAdjacent => '4 colours; each edge is adjacent to the colour of its lights';

  @override
  String get pllRuleLightsBarInside3 => 'Inside bar, 3 colours';

  @override
  String get pllRuleLightsBarInside4 => 'Inside bar, 4 colours';

  @override
  String get pllRuleLightsBarOutside3 => 'Outside bar, 3 colours';

  @override
  String get pllRuleLightsBarOutside4 => 'Outside bar, 4 colours';

  @override
  String get pllRuleLoneLights5 => '5-checker';

  @override
  String get pllRuleLoneLights4 => '4-checker';

  @override
  String get pllRuleLoneLightsOpposite => 'The edge between the lights is opposite their colour';

  @override
  String get pllRuleLoneLightsAdjacent =>
      'The edge between the lights is adjacent to their colour (no checker)';

  @override
  String get pllRuleDoubleBarOutside => 'Both bars outside';

  @override
  String get pllRuleDoubleBarInsideBookends => 'Both bars inside, the bookends match';

  @override
  String get pllRuleDoubleBarInsideNone => 'Both bars inside, the bookends differ';

  @override
  String get pllRuleDoubleBarSameBookends => 'Bars on the same side of the strip, the bookends match';

  @override
  String get pllRuleDoubleBarSameNone => 'Bars on the same side of the strip, the bookends differ';

  @override
  String get pllRuleOutsideBarNone => 'The bookends differ';

  @override
  String get pllRuleOutsideBarAdjacentTwice =>
      'Bookends match; one colour appears twice, adjacent to the bar\'s';

  @override
  String get pllRuleOutsideBarOppositeTwice =>
      'Bookends match; one colour appears twice, opposite the bar\'s';

  @override
  String get pllRuleOutsideBarAdjacent =>
      'Bookends match; the sticker next to the bar is adjacent to its colour (4 colours)';

  @override
  String get pllRuleOutsideBarOpposite =>
      'Bookends match; the sticker next to the bar is opposite its colour (4 colours)';

  @override
  String get pllRuleInsideBarAdjacent => 'Bookends match, in a colour adjacent to the bar\'s';

  @override
  String get pllRuleInsideBarOpposite => 'Bookends match, in a colour opposite the bar\'s';

  @override
  String get pllRuleInsideBarNone => 'The bookends differ';

  @override
  String get pllRuleBookends4 => 'A 4-checker between the bookends';

  @override
  String get pllRuleBookendsAdjacentTwice => 'One colour appears twice, adjacent to the bookends\'';

  @override
  String get pllRuleBookendsOppositeTwice => 'One colour appears twice, opposite the bookends\'';

  @override
  String get pllRuleNoBookendsInner4 => 'A 4-checker in the middle';

  @override
  String get pllRuleNoBookendsOuter4 => 'A 4-checker at the outer ends';

  @override
  String get pllRuleNoBookends5 => 'A 5-checker';

  @override
  String get pllGuideIntro =>
      'From the front and right sides alone you can name any PLL. Read the six stickers along the top, left to right, and look for the features below, in order. The first that matches decides the group; then find the line in the group that fits.';

  @override
  String get pllGuideTermsTitle => 'The words';

  @override
  String get pllTermThreeBar => 'One side is all one colour.';

  @override
  String get pllTermHeadlights => 'Two corners of a side are one colour, with a different edge between them.';

  @override
  String get pllTermBar =>
      'Two stickers of a side next to each other are one colour. Inside means it is next to the middle of the strip, outside means it is at an end.';

  @override
  String get pllTermBookends => 'The two outermost stickers, the first and the last, are one colour.';

  @override
  String get pllTermChecker => 'Two colours take turns, four or five stickers in a row.';

  @override
  String get pllTermColoursTitle => 'Adjacent and opposite';

  @override
  String get pllTermColours =>
      'Colours are compared on the cube: opposite colours are on opposite faces (white and yellow, say), and any other two different colours are adjacent.';

  @override
  String get pllGuideOrderTitle => 'The order to look in';

  @override
  String get pllGuideOrder => '1. A 3-bar.\n2. Headlights.\n3. A 2-bar.\n4. Bookends.';

  @override
  String get pllGuideMirrorTitle => 'Mirror images';

  @override
  String get pllGuideMirror =>
      'Every picture counts mirrored too: if it only fits when you read the six stickers from right to left, use the line as if it were drawn that way round.';

  @override
  String get pllGuideLetterTitle => 'Which letter?';

  @override
  String get pllGuideLetter =>
      'Where a line names two cases, such as Ua and Ub, it shows both. They are told apart by which way round the pattern is: the one drawn as it is in the picture, or its mirror image. Two lines need one more look:';

  @override
  String get pllGuideLetterU =>
      '3-bar with headlights (U), 3-bar on the left: if the edge on the right is opposite the 3-bar\'s colour it is Ua, if it is opposite the headlights\' colour it is Ub. With the 3-bar on the right it is the other way round.';

  @override
  String get pllGuideLetterA =>
      'Both bars inside, bookends match (A): if the bookends\' colour is adjacent to the bars\' colour it is Aa, if it is opposite it is Ab.';

  @override
  String get pllGuideCredit => 'After Mark49152\'s Two-Sided PLL Recognition Guide.';

  @override
  String get trainerTabRules => 'Patterns';

  @override
  String get trainerTabAuf => 'AUF';

  @override
  String get trainerTermsInfo => 'The words';

  @override
  String get pllAufIntro =>
      'AUF (Adjust U Face) is the last turn of the top layer that lines it up once the PLL is done. Which way to turn has no fixed answer per case: it depends on the algorithm you use. For many cases the patterns make it obvious; these are the hints for the less obvious ones.';

  @override
  String get pllAufUTitle => 'U: the 2:1 pattern';

  @override
  String get pllAufU1 => 'The odd edge is the opposite colour: the 3-bar is adjacent.';

  @override
  String get pllAufU2 => 'The odd edge is an adjacent colour: the 3-bar is opposite.';

  @override
  String get pllAufGbdTitle => 'Gb/d: opposite lights';

  @override
  String get pllAufGbd => 'The 2-bar touches the side with the 2:1 pattern.';

  @override
  String get pllAufJTitle => 'J: double 2-bar';

  @override
  String get pllAufJ => 'The 3-bar is next to the side whose colours are adjacent.';

  @override
  String get pllAufATitle => 'A: double 2-bar';

  @override
  String get pllAufA => 'The lights are next to the side whose colours are adjacent.';

  @override
  String get pllAufRGacTitle => 'R and Ga/c: bookends';

  @override
  String get pllAufR => 'R: the lights are further from the test pair.';

  @override
  String get pllAufGac => 'Ga/c: the lights are nearer to the test pair.';

  @override
  String get pllAufFTitle => 'F: checkers';

  @override
  String get pllAufF => 'The bar is next to the pair of opposite colours.';
}
