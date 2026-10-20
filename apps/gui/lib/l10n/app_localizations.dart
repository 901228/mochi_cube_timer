import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en'), Locale('zh')];

  /// No description provided for @languageName.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageName;

  /// No description provided for @languageFlag.
  ///
  /// In en, this message translates to:
  /// **'🇺🇸'**
  String get languageFlag;

  /// No description provided for @settingsGeneral.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get settingsGeneral;

  /// No description provided for @settingsTimer.
  ///
  /// In en, this message translates to:
  /// **'Timer'**
  String get settingsTimer;

  /// No description provided for @settingsPuzzle.
  ///
  /// In en, this message translates to:
  /// **'Puzzle'**
  String get settingsPuzzle;

  /// No description provided for @generalLocale.
  ///
  /// In en, this message translates to:
  /// **'Locale'**
  String get generalLocale;

  /// No description provided for @localeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get localeSystem;

  /// No description provided for @generalAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get generalAppearance;

  /// No description provided for @generalTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get generalTheme;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @generalPrimaryColor.
  ///
  /// In en, this message translates to:
  /// **'Primary color'**
  String get generalPrimaryColor;

  /// No description provided for @settingsAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsAbout;

  /// No description provided for @aboutVersion.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get aboutVersion;

  /// No description provided for @aboutCredits.
  ///
  /// In en, this message translates to:
  /// **'Credits'**
  String get aboutCredits;

  /// No description provided for @aboutLicenses.
  ///
  /// In en, this message translates to:
  /// **'Open source licenses'**
  String get aboutLicenses;

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @commonSubmit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get commonSubmit;

  /// No description provided for @commonDefault.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get commonDefault;

  /// No description provided for @commonNone.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get commonNone;

  /// No description provided for @alertTypeText.
  ///
  /// In en, this message translates to:
  /// **'Text'**
  String get alertTypeText;

  /// No description provided for @alertTypeAudio.
  ///
  /// In en, this message translates to:
  /// **'Audio'**
  String get alertTypeAudio;

  /// No description provided for @alertTypeVibration.
  ///
  /// In en, this message translates to:
  /// **'Vibration'**
  String get alertTypeVibration;

  /// No description provided for @timerInspection.
  ///
  /// In en, this message translates to:
  /// **'Inspection'**
  String get timerInspection;

  /// No description provided for @timerInspectionDuration.
  ///
  /// In en, this message translates to:
  /// **'Inspection duration (seconds)'**
  String get timerInspectionDuration;

  /// No description provided for @timerInspectionDurationHint.
  ///
  /// In en, this message translates to:
  /// **'Default duration: {seconds} seconds'**
  String timerInspectionDurationHint(int seconds);

  /// No description provided for @timerAlert.
  ///
  /// In en, this message translates to:
  /// **'Alert'**
  String get timerAlert;

  /// No description provided for @timerAlertTimeLeft.
  ///
  /// In en, this message translates to:
  /// **'Alert time left'**
  String get timerAlertTimeLeft;

  /// No description provided for @timerAlertWhenPrefix.
  ///
  /// In en, this message translates to:
  /// **'Timer will alert you once '**
  String get timerAlertWhenPrefix;

  /// No description provided for @timerAlertWhenAnd.
  ///
  /// In en, this message translates to:
  /// **' and '**
  String get timerAlertWhenAnd;

  /// No description provided for @timerAlertWhenSuffix.
  ///
  /// In en, this message translates to:
  /// **' seconds of inspection have passed'**
  String get timerAlertWhenSuffix;

  /// No description provided for @timerAlertType.
  ///
  /// In en, this message translates to:
  /// **'Alert type'**
  String get timerAlertType;

  /// No description provided for @timerAlertTypeHint.
  ///
  /// In en, this message translates to:
  /// **'Choose how the timer will alert you'**
  String get timerAlertTypeHint;

  /// No description provided for @timerDisplay.
  ///
  /// In en, this message translates to:
  /// **'Display'**
  String get timerDisplay;

  /// No description provided for @timerShowRunningTime.
  ///
  /// In en, this message translates to:
  /// **'Show time while timing'**
  String get timerShowRunningTime;

  /// No description provided for @timerShowRunningTimeHint.
  ///
  /// In en, this message translates to:
  /// **'When off, shows ... until the solve stops'**
  String get timerShowRunningTimeHint;

  /// No description provided for @timerRecords.
  ///
  /// In en, this message translates to:
  /// **'Records'**
  String get timerRecords;

  /// No description provided for @timerBestAlert.
  ///
  /// In en, this message translates to:
  /// **'New best alert'**
  String get timerBestAlert;

  /// No description provided for @timerBestAlertHint.
  ///
  /// In en, this message translates to:
  /// **'Announce a solve that beats the best of the session'**
  String get timerBestAlertHint;

  /// No description provided for @timerWorstAlert.
  ///
  /// In en, this message translates to:
  /// **'New worst alert'**
  String get timerWorstAlert;

  /// No description provided for @timerWorstAlertHint.
  ///
  /// In en, this message translates to:
  /// **'Announce a solve that is slower than the worst of the session'**
  String get timerWorstAlertHint;

  /// No description provided for @timerAverageAlert.
  ///
  /// In en, this message translates to:
  /// **'New best average alert'**
  String get timerAverageAlert;

  /// No description provided for @timerAverageAlertHint.
  ///
  /// In en, this message translates to:
  /// **'Announce a Mo3, Ao5 or Ao12 that beats the best of the session'**
  String get timerAverageAlertHint;

  /// No description provided for @timerColors.
  ///
  /// In en, this message translates to:
  /// **'Colors'**
  String get timerColors;

  /// No description provided for @timerColorPressed.
  ///
  /// In en, this message translates to:
  /// **'Pressed'**
  String get timerColorPressed;

  /// No description provided for @timerColorHolding.
  ///
  /// In en, this message translates to:
  /// **'Holding'**
  String get timerColorHolding;

  /// No description provided for @timerColorAccept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get timerColorAccept;

  /// No description provided for @puzzleCubeColors.
  ///
  /// In en, this message translates to:
  /// **'Cube colors'**
  String get puzzleCubeColors;

  /// No description provided for @puzzlePyraminxColors.
  ///
  /// In en, this message translates to:
  /// **'Pyraminx colors'**
  String get puzzlePyraminxColors;

  /// No description provided for @puzzleMegaminxColors.
  ///
  /// In en, this message translates to:
  /// **'Megaminx colors'**
  String get puzzleMegaminxColors;

  /// No description provided for @puzzleClockColors.
  ///
  /// In en, this message translates to:
  /// **'Clock colors'**
  String get puzzleClockColors;

  /// No description provided for @faceUp.
  ///
  /// In en, this message translates to:
  /// **'Up'**
  String get faceUp;

  /// No description provided for @faceDown.
  ///
  /// In en, this message translates to:
  /// **'Down'**
  String get faceDown;

  /// No description provided for @faceLeft.
  ///
  /// In en, this message translates to:
  /// **'Left'**
  String get faceLeft;

  /// No description provided for @faceRight.
  ///
  /// In en, this message translates to:
  /// **'Right'**
  String get faceRight;

  /// No description provided for @faceFront.
  ///
  /// In en, this message translates to:
  /// **'Front'**
  String get faceFront;

  /// No description provided for @faceBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get faceBack;

  /// No description provided for @penaltyNone.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get penaltyNone;

  /// No description provided for @penaltyDnf.
  ///
  /// In en, this message translates to:
  /// **'DNF'**
  String get penaltyDnf;

  /// No description provided for @penaltyPlus2.
  ///
  /// In en, this message translates to:
  /// **'Plus 2 seconds'**
  String get penaltyPlus2;

  /// No description provided for @ttsLanguage.
  ///
  /// In en, this message translates to:
  /// **'en-US'**
  String get ttsLanguage;

  /// No description provided for @speakSeconds.
  ///
  /// In en, this message translates to:
  /// **'{seconds} seconds'**
  String speakSeconds(String seconds);

  /// No description provided for @speakNewBest.
  ///
  /// In en, this message translates to:
  /// **'New best'**
  String get speakNewBest;

  /// No description provided for @speakWorst.
  ///
  /// In en, this message translates to:
  /// **'Worst solve'**
  String get speakWorst;

  /// No description provided for @speakAverages.
  ///
  /// In en, this message translates to:
  /// **'New best {kinds}'**
  String speakAverages(String kinds);

  /// No description provided for @speakAnd.
  ///
  /// In en, this message translates to:
  /// **' and '**
  String get speakAnd;

  /// No description provided for @breakBest.
  ///
  /// In en, this message translates to:
  /// **'New best! −{seconds}'**
  String breakBest(String seconds);

  /// No description provided for @breakWorst.
  ///
  /// In en, this message translates to:
  /// **'Worst so far +{seconds}'**
  String breakWorst(String seconds);

  /// No description provided for @breakAverages.
  ///
  /// In en, this message translates to:
  /// **'New best {averages}'**
  String breakAverages(String averages);

  /// No description provided for @timerScrambleFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not scramble: {error}'**
  String timerScrambleFailed(String error);

  /// No description provided for @timerRecordAdded.
  ///
  /// In en, this message translates to:
  /// **'Record added'**
  String get timerRecordAdded;

  /// No description provided for @timerEditScramble.
  ///
  /// In en, this message translates to:
  /// **'Edit scramble'**
  String get timerEditScramble;

  /// No description provided for @timerEnterScramble.
  ///
  /// In en, this message translates to:
  /// **'Enter scramble'**
  String get timerEnterScramble;

  /// No description provided for @timerScrambleHint.
  ///
  /// In en, this message translates to:
  /// **'Scramble'**
  String get timerScrambleHint;

  /// No description provided for @timerPreviousScramble.
  ///
  /// In en, this message translates to:
  /// **'Previous scramble'**
  String get timerPreviousScramble;

  /// No description provided for @timerNextScramble.
  ///
  /// In en, this message translates to:
  /// **'Next scramble'**
  String get timerNextScramble;

  /// No description provided for @statDeviation.
  ///
  /// In en, this message translates to:
  /// **'SD'**
  String get statDeviation;

  /// No description provided for @statMean.
  ///
  /// In en, this message translates to:
  /// **'Mean'**
  String get statMean;

  /// No description provided for @statBest.
  ///
  /// In en, this message translates to:
  /// **'Best'**
  String get statBest;

  /// No description provided for @statCount.
  ///
  /// In en, this message translates to:
  /// **'Count'**
  String get statCount;

  /// No description provided for @commentAdd.
  ///
  /// In en, this message translates to:
  /// **'Add comment'**
  String get commentAdd;

  /// No description provided for @commentEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit comment'**
  String get commentEdit;

  /// No description provided for @commentHint.
  ///
  /// In en, this message translates to:
  /// **'Comment'**
  String get commentHint;

  /// No description provided for @commentTooltip.
  ///
  /// In en, this message translates to:
  /// **'Comment'**
  String get commentTooltip;

  /// No description provided for @deleteRecordTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete record?'**
  String get deleteRecordTitle;

  /// No description provided for @deleteRecordMessage.
  ///
  /// In en, this message translates to:
  /// **'The current solve will be permanently deleted.'**
  String get deleteRecordMessage;

  /// No description provided for @commonDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get commonDelete;

  /// No description provided for @commonArchive.
  ///
  /// In en, this message translates to:
  /// **'Archive'**
  String get commonArchive;

  /// No description provided for @commonUnarchive.
  ///
  /// In en, this message translates to:
  /// **'Unarchive'**
  String get commonUnarchive;

  /// No description provided for @commonMoveTo.
  ///
  /// In en, this message translates to:
  /// **'Move to'**
  String get commonMoveTo;

  /// No description provided for @commonPenalty.
  ///
  /// In en, this message translates to:
  /// **'Penalty'**
  String get commonPenalty;

  /// No description provided for @commonComment.
  ///
  /// In en, this message translates to:
  /// **'Comment'**
  String get commonComment;

  /// No description provided for @commonScramble.
  ///
  /// In en, this message translates to:
  /// **'Scramble'**
  String get commonScramble;

  /// No description provided for @commonSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get commonSave;

  /// No description provided for @commonExport.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get commonExport;

  /// No description provided for @commonImport.
  ///
  /// In en, this message translates to:
  /// **'Import'**
  String get commonImport;

  /// No description provided for @commonRename.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get commonRename;

  /// No description provided for @commonSelect.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get commonSelect;

  /// No description provided for @commonSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get commonSettings;

  /// No description provided for @commonAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get commonAdd;

  /// No description provided for @commonAny.
  ///
  /// In en, this message translates to:
  /// **'Any'**
  String get commonAny;

  /// No description provided for @recordDetail.
  ///
  /// In en, this message translates to:
  /// **'Record Detail'**
  String get recordDetail;

  /// No description provided for @recordCommentEmpty.
  ///
  /// In en, this message translates to:
  /// **'Comment something...'**
  String get recordCommentEmpty;

  /// No description provided for @recordEditComment.
  ///
  /// In en, this message translates to:
  /// **'Edit comment'**
  String get recordEditComment;

  /// No description provided for @recordDeleteMessage.
  ///
  /// In en, this message translates to:
  /// **'This record will be permanently deleted.'**
  String get recordDeleteMessage;

  /// No description provided for @recordsNone.
  ///
  /// In en, this message translates to:
  /// **'No records yet'**
  String get recordsNone;

  /// No description provided for @recordsDeleteAllTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete all records?'**
  String get recordsDeleteAllTitle;

  /// No description provided for @recordsDeleteAllMessage.
  ///
  /// In en, this message translates to:
  /// **'All solves will be permanently deleted.'**
  String get recordsDeleteAllMessage;

  /// No description provided for @recordsArchiveAllTitle.
  ///
  /// In en, this message translates to:
  /// **'Archive all records?'**
  String get recordsArchiveAllTitle;

  /// No description provided for @recordsArchiveAllMessage.
  ///
  /// In en, this message translates to:
  /// **'All solves will be archived.'**
  String get recordsArchiveAllMessage;

  /// No description provided for @addRecordTitle.
  ///
  /// In en, this message translates to:
  /// **'Add record'**
  String get addRecordTitle;

  /// No description provided for @addRecordInvalidTime.
  ///
  /// In en, this message translates to:
  /// **'Invalid time'**
  String get addRecordInvalidTime;

  /// No description provided for @addRecordSolveTime.
  ///
  /// In en, this message translates to:
  /// **'Solve Time'**
  String get addRecordSolveTime;

  /// No description provided for @addRecordUseCurrent.
  ///
  /// In en, this message translates to:
  /// **'Use current scramble'**
  String get addRecordUseCurrent;

  /// No description provided for @addRecordScrambleRequired.
  ///
  /// In en, this message translates to:
  /// **'Scramble is required'**
  String get addRecordScrambleRequired;

  /// No description provided for @searchAddRecord.
  ///
  /// In en, this message translates to:
  /// **'Add a record'**
  String get searchAddRecord;

  /// No description provided for @searchComments.
  ///
  /// In en, this message translates to:
  /// **'Search comments'**
  String get searchComments;

  /// No description provided for @searchDeleteAll.
  ///
  /// In en, this message translates to:
  /// **'Delete all'**
  String get searchDeleteAll;

  /// No description provided for @sortNewest.
  ///
  /// In en, this message translates to:
  /// **'Newest first'**
  String get sortNewest;

  /// No description provided for @sortOldest.
  ///
  /// In en, this message translates to:
  /// **'Oldest first'**
  String get sortOldest;

  /// No description provided for @sortFastest.
  ///
  /// In en, this message translates to:
  /// **'Fastest first'**
  String get sortFastest;

  /// No description provided for @sortSlowest.
  ///
  /// In en, this message translates to:
  /// **'Slowest first'**
  String get sortSlowest;

  /// No description provided for @sortTooltip.
  ///
  /// In en, this message translates to:
  /// **'Sort: {label}'**
  String sortTooltip(String label);

  /// No description provided for @filterRecords.
  ///
  /// In en, this message translates to:
  /// **'Filter records'**
  String get filterRecords;

  /// No description provided for @filterRecordsActive.
  ///
  /// In en, this message translates to:
  /// **'Filter records ({active} on)'**
  String filterRecordsActive(int active);

  /// No description provided for @filterDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get filterDate;

  /// No description provided for @filterAnyTime.
  ///
  /// In en, this message translates to:
  /// **'Any time'**
  String get filterAnyTime;

  /// No description provided for @filterClear.
  ///
  /// In en, this message translates to:
  /// **'Clear filters'**
  String get filterClear;

  /// No description provided for @statsCurrent.
  ///
  /// In en, this message translates to:
  /// **'Current Stats'**
  String get statsCurrent;

  /// No description provided for @statsSolveCount.
  ///
  /// In en, this message translates to:
  /// **'Solve Count'**
  String get statsSolveCount;

  /// No description provided for @statsSolveMean.
  ///
  /// In en, this message translates to:
  /// **'Solve Mean'**
  String get statsSolveMean;

  /// No description provided for @statsSolveDeviation.
  ///
  /// In en, this message translates to:
  /// **'Solve Deviation'**
  String get statsSolveDeviation;

  /// No description provided for @statsBestSingle.
  ///
  /// In en, this message translates to:
  /// **'Best Single'**
  String get statsBestSingle;

  /// No description provided for @statsBestStats.
  ///
  /// In en, this message translates to:
  /// **'Best Stats'**
  String get statsBestStats;

  /// No description provided for @statsBestAo5.
  ///
  /// In en, this message translates to:
  /// **'Best Ao5'**
  String get statsBestAo5;

  /// No description provided for @statsSolveTimes.
  ///
  /// In en, this message translates to:
  /// **'Solve Times'**
  String get statsSolveTimes;

  /// No description provided for @statsDistribution.
  ///
  /// In en, this message translates to:
  /// **'Time Distribution'**
  String get statsDistribution;

  /// No description provided for @statsNoSolves.
  ///
  /// In en, this message translates to:
  /// **'There is no solve yet'**
  String get statsNoSolves;

  /// No description provided for @statsNotEnough.
  ///
  /// In en, this message translates to:
  /// **'Not enough solves yet'**
  String get statsNotEnough;

  /// No description provided for @statsMedian.
  ///
  /// In en, this message translates to:
  /// **'Median {value}'**
  String statsMedian(String value);

  /// No description provided for @homeSetPenaltyAll.
  ///
  /// In en, this message translates to:
  /// **'Set all records Penalty to {penalty}?'**
  String homeSetPenaltyAll(String penalty);

  /// No description provided for @homeMoveAll.
  ///
  /// In en, this message translates to:
  /// **'Move all records to {name}?'**
  String homeMoveAll(String name);

  /// No description provided for @homeDeselectAll.
  ///
  /// In en, this message translates to:
  /// **'Deselect all'**
  String get homeDeselectAll;

  /// No description provided for @homeSelectAll.
  ///
  /// In en, this message translates to:
  /// **'Select all'**
  String get homeSelectAll;

  /// No description provided for @homeSelectPuzzle.
  ///
  /// In en, this message translates to:
  /// **'Select a puzzle'**
  String get homeSelectPuzzle;

  /// No description provided for @homeShowArchived.
  ///
  /// In en, this message translates to:
  /// **'Show archived records'**
  String get homeShowArchived;

  /// No description provided for @homeSessions.
  ///
  /// In en, this message translates to:
  /// **'Sessions'**
  String get homeSessions;

  /// No description provided for @sessionSelect.
  ///
  /// In en, this message translates to:
  /// **'Select a session'**
  String get sessionSelect;

  /// No description provided for @sessionCreate.
  ///
  /// In en, this message translates to:
  /// **'Create new session'**
  String get sessionCreate;

  /// No description provided for @sessionImport.
  ///
  /// In en, this message translates to:
  /// **'Import to new session'**
  String get sessionImport;

  /// No description provided for @sessionDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete session?'**
  String get sessionDeleteTitle;

  /// No description provided for @sessionDeleteMessage.
  ///
  /// In en, this message translates to:
  /// **'All solves in \"{name}\" will be permanently deleted.'**
  String sessionDeleteMessage(String name);

  /// No description provided for @importPickTitle.
  ///
  /// In en, this message translates to:
  /// **'Pick a csv file of records'**
  String get importPickTitle;

  /// No description provided for @importDefaultName.
  ///
  /// In en, this message translates to:
  /// **'Imported'**
  String get importDefaultName;

  /// No description provided for @importTitle.
  ///
  /// In en, this message translates to:
  /// **'Import records?'**
  String get importTitle;

  /// No description provided for @importMessageNew.
  ///
  /// In en, this message translates to:
  /// **'{count} records will be added to a new session \"{name}\".'**
  String importMessageNew(int count, String name);

  /// No description provided for @importMessageExisting.
  ///
  /// In en, this message translates to:
  /// **'{count} records will be added to \"{name}\".'**
  String importMessageExisting(int count, String name);

  /// No description provided for @importSkipped.
  ///
  /// In en, this message translates to:
  /// **' {skipped} unreadable rows will be skipped.'**
  String importSkipped(int skipped);

  /// No description provided for @importDone.
  ///
  /// In en, this message translates to:
  /// **'Records imported'**
  String get importDone;

  /// No description provided for @importDoneDescription.
  ///
  /// In en, this message translates to:
  /// **'Added {count} records to \"{name}\".'**
  String importDoneDescription(int count, String name);

  /// No description provided for @importFailed.
  ///
  /// In en, this message translates to:
  /// **'Can\'t import this file'**
  String get importFailed;

  /// No description provided for @importNotRecords.
  ///
  /// In en, this message translates to:
  /// **'Not a records file: needs Puzzle, Scramble, Time and Datetime columns'**
  String get importNotRecords;

  /// No description provided for @exportTitle.
  ///
  /// In en, this message translates to:
  /// **'Export session'**
  String get exportTitle;

  /// No description provided for @exportAsCsv.
  ///
  /// In en, this message translates to:
  /// **'Export as CSV'**
  String get exportAsCsv;

  /// No description provided for @exportIncludeDeleted.
  ///
  /// In en, this message translates to:
  /// **'Include deleted records'**
  String get exportIncludeDeleted;

  /// No description provided for @exportPickTitle.
  ///
  /// In en, this message translates to:
  /// **'Output session to a csv file'**
  String get exportPickTitle;

  /// No description provided for @exportDone.
  ///
  /// In en, this message translates to:
  /// **'Session exported'**
  String get exportDone;

  /// No description provided for @exportDonePrefix.
  ///
  /// In en, this message translates to:
  /// **'Export session records to '**
  String get exportDonePrefix;

  /// No description provided for @timerInspectionHint.
  ///
  /// In en, this message translates to:
  /// **'INSPECTION'**
  String get timerInspectionHint;

  /// No description provided for @timerGo.
  ///
  /// In en, this message translates to:
  /// **'GO!'**
  String get timerGo;

  /// No description provided for @navTimer.
  ///
  /// In en, this message translates to:
  /// **'Timer'**
  String get navTimer;

  /// No description provided for @navRecords.
  ///
  /// In en, this message translates to:
  /// **'Records'**
  String get navRecords;

  /// No description provided for @navStats.
  ///
  /// In en, this message translates to:
  /// **'Stats'**
  String get navStats;

  /// No description provided for @puzzleCube2.
  ///
  /// In en, this message translates to:
  /// **'2x2'**
  String get puzzleCube2;

  /// No description provided for @puzzleCube3.
  ///
  /// In en, this message translates to:
  /// **'3x3'**
  String get puzzleCube3;

  /// No description provided for @puzzleCube4.
  ///
  /// In en, this message translates to:
  /// **'4x4'**
  String get puzzleCube4;

  /// No description provided for @puzzleCube5.
  ///
  /// In en, this message translates to:
  /// **'5x5'**
  String get puzzleCube5;

  /// No description provided for @puzzleCube6.
  ///
  /// In en, this message translates to:
  /// **'6x6'**
  String get puzzleCube6;

  /// No description provided for @puzzleCube7.
  ///
  /// In en, this message translates to:
  /// **'7x7'**
  String get puzzleCube7;

  /// No description provided for @puzzleClock.
  ///
  /// In en, this message translates to:
  /// **'Clock'**
  String get puzzleClock;

  /// No description provided for @puzzleFto.
  ///
  /// In en, this message translates to:
  /// **'FTO'**
  String get puzzleFto;

  /// No description provided for @puzzleMegaminx.
  ///
  /// In en, this message translates to:
  /// **'Megaminx'**
  String get puzzleMegaminx;

  /// No description provided for @puzzlePyraminx.
  ///
  /// In en, this message translates to:
  /// **'Pyraminx'**
  String get puzzlePyraminx;

  /// No description provided for @puzzleSkewb.
  ///
  /// In en, this message translates to:
  /// **'Skewb'**
  String get puzzleSkewb;

  /// No description provided for @puzzleSquare1.
  ///
  /// In en, this message translates to:
  /// **'Square-1'**
  String get puzzleSquare1;

  /// No description provided for @timerAlertFirst.
  ///
  /// In en, this message translates to:
  /// **'{seconds}s!'**
  String timerAlertFirst(int seconds);

  /// No description provided for @timerAlertSecond.
  ///
  /// In en, this message translates to:
  /// **'{seconds}s!!'**
  String timerAlertSecond(int seconds);
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
