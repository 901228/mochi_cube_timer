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

  /// No description provided for @settingsTimerBehavior.
  ///
  /// In en, this message translates to:
  /// **'Timer Behavior'**
  String get settingsTimerBehavior;

  /// No description provided for @settingsPuzzle.
  ///
  /// In en, this message translates to:
  /// **'Puzzle Color'**
  String get settingsPuzzle;

  /// No description provided for @settingsInspection.
  ///
  /// In en, this message translates to:
  /// **'Inspection Behavior'**
  String get settingsInspection;

  /// No description provided for @settingsTimerAppearance.
  ///
  /// In en, this message translates to:
  /// **'Timer Appearance'**
  String get settingsTimerAppearance;

  /// No description provided for @settingsStats.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get settingsStats;

  /// No description provided for @settingsAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsAbout;

  /// No description provided for @settingsOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get settingsOther;

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

  /// No description provided for @timerInput.
  ///
  /// In en, this message translates to:
  /// **'Timer input'**
  String get timerInput;

  /// No description provided for @timerStackmat.
  ///
  /// In en, this message translates to:
  /// **'Use a Stackmat'**
  String get timerStackmat;

  /// No description provided for @timerStackmatHint.
  ///
  /// In en, this message translates to:
  /// **'The Stackmat on the audio input starts and stops the solves. The screen then only opens inspection.'**
  String get timerStackmatHint;

  /// No description provided for @timerDisplay.
  ///
  /// In en, this message translates to:
  /// **'Time Display'**
  String get timerDisplay;

  /// No description provided for @timerHold.
  ///
  /// In en, this message translates to:
  /// **'Hold to start'**
  String get timerHold;

  /// No description provided for @timerHoldHint.
  ///
  /// In en, this message translates to:
  /// **'How long the screen is held before the timer is ready'**
  String get timerHoldHint;

  /// No description provided for @timerShown.
  ///
  /// In en, this message translates to:
  /// **'Shown on the timer page'**
  String get timerShown;

  /// No description provided for @timerShowScrambleImage.
  ///
  /// In en, this message translates to:
  /// **'Scramble image'**
  String get timerShowScrambleImage;

  /// No description provided for @timerShowScrambleImageHint.
  ///
  /// In en, this message translates to:
  /// **'Show the picture of the scramble'**
  String get timerShowScrambleImageHint;

  /// No description provided for @timerShowSessionStats.
  ///
  /// In en, this message translates to:
  /// **'Session statistics'**
  String get timerShowSessionStats;

  /// No description provided for @timerShowSessionStatsHint.
  ///
  /// In en, this message translates to:
  /// **'Show the statistics of the session'**
  String get timerShowSessionStatsHint;

  /// No description provided for @timerShowQuickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick actions'**
  String get timerShowQuickActions;

  /// No description provided for @timerShowQuickActionsHint.
  ///
  /// In en, this message translates to:
  /// **'Show the penalty, comment and delete buttons after a solve'**
  String get timerShowQuickActionsHint;

  /// No description provided for @statsAverages.
  ///
  /// In en, this message translates to:
  /// **'Averages'**
  String get statsAverages;

  /// No description provided for @statsAverageTrim.
  ///
  /// In en, this message translates to:
  /// **'Average trim'**
  String get statsAverageTrim;

  /// No description provided for @statsAverageTrimHint.
  ///
  /// In en, this message translates to:
  /// **'The share of the solves left out at each end of an average, the best and the worst ones'**
  String get statsAverageTrimHint;

  /// No description provided for @statsAverageTrimOption.
  ///
  /// In en, this message translates to:
  /// **'{percent}%'**
  String statsAverageTrimOption(int percent);

  /// No description provided for @timerDecimals.
  ///
  /// In en, this message translates to:
  /// **'Decimal places'**
  String get timerDecimals;

  /// No description provided for @timerDecimalsHint.
  ///
  /// In en, this message translates to:
  /// **'How many decimals the time on the timer page shows'**
  String get timerDecimalsHint;

  /// No description provided for @timerDecimalsOption.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 decimal} other{{count} decimals}}'**
  String timerDecimalsOption(int count);

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

  /// No description provided for @puzzleFtoColors.
  ///
  /// In en, this message translates to:
  /// **'FTO colors'**
  String get puzzleFtoColors;

  /// No description provided for @puzzleClockColors.
  ///
  /// In en, this message translates to:
  /// **'Clock colors'**
  String get puzzleClockColors;

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

  /// No description provided for @homeKindPuzzles.
  ///
  /// In en, this message translates to:
  /// **'Puzzles'**
  String get homeKindPuzzles;

  /// No description provided for @homeKindAlgorithms.
  ///
  /// In en, this message translates to:
  /// **'Algorithms'**
  String get homeKindAlgorithms;

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

  /// No description provided for @timerScrambleCopied.
  ///
  /// In en, this message translates to:
  /// **'Scramble copied'**
  String get timerScrambleCopied;

  /// No description provided for @algorithmsTitle.
  ///
  /// In en, this message translates to:
  /// **'Algorithms'**
  String get algorithmsTitle;

  /// No description provided for @algorithmsSelectSet.
  ///
  /// In en, this message translates to:
  /// **'Select an algorithm set'**
  String get algorithmsSelectSet;

  /// No description provided for @algorithmsCasesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} cases'**
  String algorithmsCasesCount(int count);

  /// No description provided for @algorithmsCopied.
  ///
  /// In en, this message translates to:
  /// **'Algorithm copied'**
  String get algorithmsCopied;

  /// No description provided for @algorithmsExpandAll.
  ///
  /// In en, this message translates to:
  /// **'Expand all'**
  String get algorithmsExpandAll;

  /// No description provided for @algorithmsCollapseAll.
  ///
  /// In en, this message translates to:
  /// **'Collapse all'**
  String get algorithmsCollapseAll;

  /// No description provided for @algorithmsNoSets.
  ///
  /// In en, this message translates to:
  /// **'There are no algorithm sets for {puzzle}'**
  String algorithmsNoSets(String puzzle);

  /// No description provided for @practiceCrossName.
  ///
  /// In en, this message translates to:
  /// **'Cross'**
  String get practiceCrossName;

  /// No description provided for @practiceCrossDescription.
  ///
  /// In en, this message translates to:
  /// **'Solve just the bottom cross'**
  String get practiceCrossDescription;

  /// No description provided for @practiceViewList.
  ///
  /// In en, this message translates to:
  /// **'List'**
  String get practiceViewList;

  /// No description provided for @practiceViewGrid.
  ///
  /// In en, this message translates to:
  /// **'Grid'**
  String get practiceViewGrid;

  /// No description provided for @practiceCasesTitle.
  ///
  /// In en, this message translates to:
  /// **'Cases to practise'**
  String get practiceCasesTitle;

  /// No description provided for @practiceCasesCount.
  ///
  /// In en, this message translates to:
  /// **'{selected} of {total} cases'**
  String practiceCasesCount(int selected, int total);

  /// No description provided for @simulatorTitle.
  ///
  /// In en, this message translates to:
  /// **'Simulator'**
  String get simulatorTitle;

  /// No description provided for @simulatorMovesHint.
  ///
  /// In en, this message translates to:
  /// **'Moves, e.g. R U R\' U\''**
  String get simulatorMovesHint;

  /// No description provided for @simulatorToStart.
  ///
  /// In en, this message translates to:
  /// **'To start'**
  String get simulatorToStart;

  /// No description provided for @simulatorStepBack.
  ///
  /// In en, this message translates to:
  /// **'Step back'**
  String get simulatorStepBack;

  /// No description provided for @simulatorPlay.
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get simulatorPlay;

  /// No description provided for @simulatorPause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get simulatorPause;

  /// No description provided for @simulatorStepForward.
  ///
  /// In en, this message translates to:
  /// **'Step forward'**
  String get simulatorStepForward;

  /// No description provided for @simulatorToEnd.
  ///
  /// In en, this message translates to:
  /// **'To end'**
  String get simulatorToEnd;

  /// No description provided for @simulatorSettings.
  ///
  /// In en, this message translates to:
  /// **'Simulator settings'**
  String get simulatorSettings;

  /// No description provided for @simulatorHintDistance.
  ///
  /// In en, this message translates to:
  /// **'Hint sticker distance'**
  String get simulatorHintDistance;

  /// No description provided for @simulatorHintOff.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get simulatorHintOff;

  /// No description provided for @simulatorSpeed.
  ///
  /// In en, this message translates to:
  /// **'Turn speed'**
  String get simulatorSpeed;

  /// No description provided for @simulatorStickerless.
  ///
  /// In en, this message translates to:
  /// **'Stickerless'**
  String get simulatorStickerless;

  /// No description provided for @simulatorLoop.
  ///
  /// In en, this message translates to:
  /// **'Loop'**
  String get simulatorLoop;

  /// No description provided for @simulatorLoopHint.
  ///
  /// In en, this message translates to:
  /// **'After pressing play, start again once done'**
  String get simulatorLoopHint;

  /// No description provided for @simulatorResetView.
  ///
  /// In en, this message translates to:
  /// **'Reset view'**
  String get simulatorResetView;

  /// No description provided for @simulatorCubeSize.
  ///
  /// In en, this message translates to:
  /// **'Cube size'**
  String get simulatorCubeSize;

  /// No description provided for @simulatorResetSettings.
  ///
  /// In en, this message translates to:
  /// **'Restore defaults'**
  String get simulatorResetSettings;

  /// No description provided for @simulatorReset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get simulatorReset;

  /// No description provided for @simulatorInvalidMove.
  ///
  /// In en, this message translates to:
  /// **'Can\'t read: {move}'**
  String simulatorInvalidMove(String move);

  /// No description provided for @trainersTitle.
  ///
  /// In en, this message translates to:
  /// **'Trainers'**
  String get trainersTitle;

  /// No description provided for @trainerPllRecognitionTitle.
  ///
  /// In en, this message translates to:
  /// **'Two-side PLL recognition'**
  String get trainerPllRecognitionTitle;

  /// No description provided for @trainerPllRecognitionDescription.
  ///
  /// In en, this message translates to:
  /// **'Name the PLL case from the front and right sides alone'**
  String get trainerPllRecognitionDescription;

  /// No description provided for @trainerAnswerWas.
  ///
  /// In en, this message translates to:
  /// **'It was {name}'**
  String trainerAnswerWas(String name);

  /// No description provided for @trainerNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get trainerNext;

  /// No description provided for @trainerTabPractice.
  ///
  /// In en, this message translates to:
  /// **'Practice'**
  String get trainerTabPractice;

  /// No description provided for @trainerPattern.
  ///
  /// In en, this message translates to:
  /// **'{group}: {rule}'**
  String trainerPattern(String group, String rule);

  /// No description provided for @pllGroupThreeBar.
  ///
  /// In en, this message translates to:
  /// **'3-bar'**
  String get pllGroupThreeBar;

  /// No description provided for @pllGroupThreeBarInfo.
  ///
  /// In en, this message translates to:
  /// **'One side is all one colour.'**
  String get pllGroupThreeBarInfo;

  /// No description provided for @pllGroupDoubleLights.
  ///
  /// In en, this message translates to:
  /// **'Double lights'**
  String get pllGroupDoubleLights;

  /// No description provided for @pllGroupDoubleLightsInfo.
  ///
  /// In en, this message translates to:
  /// **'Both sides have headlights: two corners of one colour with a different edge between them.'**
  String get pllGroupDoubleLightsInfo;

  /// No description provided for @pllGroupLightsAndBar.
  ///
  /// In en, this message translates to:
  /// **'Lights + 2-bar'**
  String get pllGroupLightsAndBar;

  /// No description provided for @pllGroupLightsAndBarInfo.
  ///
  /// In en, this message translates to:
  /// **'Headlights on one side and a 2-bar on the other.'**
  String get pllGroupLightsAndBarInfo;

  /// No description provided for @pllGroupLoneLights.
  ///
  /// In en, this message translates to:
  /// **'Lone lights'**
  String get pllGroupLoneLights;

  /// No description provided for @pllGroupLoneLightsInfo.
  ///
  /// In en, this message translates to:
  /// **'Headlights on one side; the other side has no bar and no lights.'**
  String get pllGroupLoneLightsInfo;

  /// No description provided for @pllGroupDoubleBar.
  ///
  /// In en, this message translates to:
  /// **'Double 2-bar'**
  String get pllGroupDoubleBar;

  /// No description provided for @pllGroupDoubleBarInfo.
  ///
  /// In en, this message translates to:
  /// **'A 2-bar on each side.'**
  String get pllGroupDoubleBarInfo;

  /// No description provided for @pllGroupOutsideBar.
  ///
  /// In en, this message translates to:
  /// **'Outside 2-bar'**
  String get pllGroupOutsideBar;

  /// No description provided for @pllGroupOutsideBarInfo.
  ///
  /// In en, this message translates to:
  /// **'Only one 2-bar, at the outer end.'**
  String get pllGroupOutsideBarInfo;

  /// No description provided for @pllGroupInsideBar.
  ///
  /// In en, this message translates to:
  /// **'Inside 2-bar'**
  String get pllGroupInsideBar;

  /// No description provided for @pllGroupInsideBarInfo.
  ///
  /// In en, this message translates to:
  /// **'Only one 2-bar, next to the middle of the strip.'**
  String get pllGroupInsideBarInfo;

  /// No description provided for @pllGroupBookends.
  ///
  /// In en, this message translates to:
  /// **'Bookends, no bar'**
  String get pllGroupBookends;

  /// No description provided for @pllGroupBookendsInfo.
  ///
  /// In en, this message translates to:
  /// **'No bars or lights, but the two outermost stickers match.'**
  String get pllGroupBookendsInfo;

  /// No description provided for @pllGroupNoBookends.
  ///
  /// In en, this message translates to:
  /// **'No bookends'**
  String get pllGroupNoBookends;

  /// No description provided for @pllGroupNoBookendsInfo.
  ///
  /// In en, this message translates to:
  /// **'None of the above: the two outermost stickers differ.'**
  String get pllGroupNoBookendsInfo;

  /// No description provided for @pllRuleThreeBarHeadlights.
  ///
  /// In en, this message translates to:
  /// **'Headlights on the other side'**
  String get pllRuleThreeBarHeadlights;

  /// No description provided for @pllRuleThreeBarTwoBar.
  ///
  /// In en, this message translates to:
  /// **'A 2-bar on the other side'**
  String get pllRuleThreeBarTwoBar;

  /// No description provided for @pllRuleThreeBarFourColours.
  ///
  /// In en, this message translates to:
  /// **'Three different colours on the other side (4 colours in all)'**
  String get pllRuleThreeBarFourColours;

  /// No description provided for @pllRuleDoubleLightsChecker.
  ///
  /// In en, this message translates to:
  /// **'Only two colours, in a checkerboard (6-checker)'**
  String get pllRuleDoubleLightsChecker;

  /// No description provided for @pllRuleDoubleLights21.
  ///
  /// In en, this message translates to:
  /// **'3 colours: the edge of one side matches the corners of the other (2:1)'**
  String get pllRuleDoubleLights21;

  /// No description provided for @pllRuleDoubleLightsOpposite.
  ///
  /// In en, this message translates to:
  /// **'4 colours; each edge is opposite the colour of its lights'**
  String get pllRuleDoubleLightsOpposite;

  /// No description provided for @pllRuleDoubleLightsAdjacent.
  ///
  /// In en, this message translates to:
  /// **'4 colours; each edge is adjacent to the colour of its lights'**
  String get pllRuleDoubleLightsAdjacent;

  /// No description provided for @pllRuleLightsBarInside3.
  ///
  /// In en, this message translates to:
  /// **'Inside bar, 3 colours'**
  String get pllRuleLightsBarInside3;

  /// No description provided for @pllRuleLightsBarInside4.
  ///
  /// In en, this message translates to:
  /// **'Inside bar, 4 colours'**
  String get pllRuleLightsBarInside4;

  /// No description provided for @pllRuleLightsBarOutside3.
  ///
  /// In en, this message translates to:
  /// **'Outside bar, 3 colours'**
  String get pllRuleLightsBarOutside3;

  /// No description provided for @pllRuleLightsBarOutside4.
  ///
  /// In en, this message translates to:
  /// **'Outside bar, 4 colours'**
  String get pllRuleLightsBarOutside4;

  /// No description provided for @pllRuleLoneLights5.
  ///
  /// In en, this message translates to:
  /// **'5-checker'**
  String get pllRuleLoneLights5;

  /// No description provided for @pllRuleLoneLights4.
  ///
  /// In en, this message translates to:
  /// **'4-checker'**
  String get pllRuleLoneLights4;

  /// No description provided for @pllRuleLoneLightsOpposite.
  ///
  /// In en, this message translates to:
  /// **'The edge between the lights is opposite their colour'**
  String get pllRuleLoneLightsOpposite;

  /// No description provided for @pllRuleLoneLightsAdjacent.
  ///
  /// In en, this message translates to:
  /// **'The edge between the lights is adjacent to their colour (no checker)'**
  String get pllRuleLoneLightsAdjacent;

  /// No description provided for @pllRuleDoubleBarOutside.
  ///
  /// In en, this message translates to:
  /// **'Both bars outside'**
  String get pllRuleDoubleBarOutside;

  /// No description provided for @pllRuleDoubleBarInsideBookends.
  ///
  /// In en, this message translates to:
  /// **'Both bars inside, the bookends match'**
  String get pllRuleDoubleBarInsideBookends;

  /// No description provided for @pllRuleDoubleBarInsideNone.
  ///
  /// In en, this message translates to:
  /// **'Both bars inside, the bookends differ'**
  String get pllRuleDoubleBarInsideNone;

  /// No description provided for @pllRuleDoubleBarSameBookends.
  ///
  /// In en, this message translates to:
  /// **'Bars on the same side of the strip, the bookends match'**
  String get pllRuleDoubleBarSameBookends;

  /// No description provided for @pllRuleDoubleBarSameNone.
  ///
  /// In en, this message translates to:
  /// **'Bars on the same side of the strip, the bookends differ'**
  String get pllRuleDoubleBarSameNone;

  /// No description provided for @pllRuleOutsideBarNone.
  ///
  /// In en, this message translates to:
  /// **'The bookends differ'**
  String get pllRuleOutsideBarNone;

  /// No description provided for @pllRuleOutsideBarAdjacentTwice.
  ///
  /// In en, this message translates to:
  /// **'Bookends match; one colour appears twice, adjacent to the bar\'s'**
  String get pllRuleOutsideBarAdjacentTwice;

  /// No description provided for @pllRuleOutsideBarOppositeTwice.
  ///
  /// In en, this message translates to:
  /// **'Bookends match; one colour appears twice, opposite the bar\'s'**
  String get pllRuleOutsideBarOppositeTwice;

  /// No description provided for @pllRuleOutsideBarAdjacent.
  ///
  /// In en, this message translates to:
  /// **'Bookends match; the sticker next to the bar is adjacent to its colour (4 colours)'**
  String get pllRuleOutsideBarAdjacent;

  /// No description provided for @pllRuleOutsideBarOpposite.
  ///
  /// In en, this message translates to:
  /// **'Bookends match; the sticker next to the bar is opposite its colour (4 colours)'**
  String get pllRuleOutsideBarOpposite;

  /// No description provided for @pllRuleInsideBarAdjacent.
  ///
  /// In en, this message translates to:
  /// **'Bookends match, in a colour adjacent to the bar\'s'**
  String get pllRuleInsideBarAdjacent;

  /// No description provided for @pllRuleInsideBarOpposite.
  ///
  /// In en, this message translates to:
  /// **'Bookends match, in a colour opposite the bar\'s'**
  String get pllRuleInsideBarOpposite;

  /// No description provided for @pllRuleInsideBarNone.
  ///
  /// In en, this message translates to:
  /// **'The bookends differ'**
  String get pllRuleInsideBarNone;

  /// No description provided for @pllRuleBookends4.
  ///
  /// In en, this message translates to:
  /// **'A 4-checker between the bookends'**
  String get pllRuleBookends4;

  /// No description provided for @pllRuleBookendsAdjacentTwice.
  ///
  /// In en, this message translates to:
  /// **'One colour appears twice, adjacent to the bookends\''**
  String get pllRuleBookendsAdjacentTwice;

  /// No description provided for @pllRuleBookendsOppositeTwice.
  ///
  /// In en, this message translates to:
  /// **'One colour appears twice, opposite the bookends\''**
  String get pllRuleBookendsOppositeTwice;

  /// No description provided for @pllRuleNoBookendsInner4.
  ///
  /// In en, this message translates to:
  /// **'A 4-checker in the middle'**
  String get pllRuleNoBookendsInner4;

  /// No description provided for @pllRuleNoBookendsOuter4.
  ///
  /// In en, this message translates to:
  /// **'A 4-checker at the outer ends'**
  String get pllRuleNoBookendsOuter4;

  /// No description provided for @pllRuleNoBookends5.
  ///
  /// In en, this message translates to:
  /// **'A 5-checker'**
  String get pllRuleNoBookends5;

  /// No description provided for @pllGuideIntro.
  ///
  /// In en, this message translates to:
  /// **'From the front and right sides alone you can name any PLL. Read the six stickers along the top, left to right, and look for the features below, in order. The first that matches decides the group; then find the line in the group that fits.'**
  String get pllGuideIntro;

  /// No description provided for @pllGuideTermsTitle.
  ///
  /// In en, this message translates to:
  /// **'The words'**
  String get pllGuideTermsTitle;

  /// No description provided for @pllTermThreeBar.
  ///
  /// In en, this message translates to:
  /// **'One side is all one colour.'**
  String get pllTermThreeBar;

  /// No description provided for @pllTermHeadlights.
  ///
  /// In en, this message translates to:
  /// **'Two corners of a side are one colour, with a different edge between them.'**
  String get pllTermHeadlights;

  /// No description provided for @pllTermBar.
  ///
  /// In en, this message translates to:
  /// **'Two stickers of a side next to each other are one colour. Inside means it is next to the middle of the strip, outside means it is at an end.'**
  String get pllTermBar;

  /// No description provided for @pllTermBookends.
  ///
  /// In en, this message translates to:
  /// **'The two outermost stickers, the first and the last, are one colour.'**
  String get pllTermBookends;

  /// No description provided for @pllTermChecker.
  ///
  /// In en, this message translates to:
  /// **'Two colours take turns, four or five stickers in a row.'**
  String get pllTermChecker;

  /// No description provided for @pllTermColoursTitle.
  ///
  /// In en, this message translates to:
  /// **'Adjacent and opposite'**
  String get pllTermColoursTitle;

  /// No description provided for @pllTermColours.
  ///
  /// In en, this message translates to:
  /// **'Colours are compared on the cube: opposite colours are on opposite faces (white and yellow, say), and any other two different colours are adjacent.'**
  String get pllTermColours;

  /// No description provided for @pllGuideOrderTitle.
  ///
  /// In en, this message translates to:
  /// **'The order to look in'**
  String get pllGuideOrderTitle;

  /// No description provided for @pllGuideOrder.
  ///
  /// In en, this message translates to:
  /// **'1. A 3-bar.\n2. Headlights.\n3. A 2-bar.\n4. Bookends.'**
  String get pllGuideOrder;

  /// No description provided for @pllGuideMirrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Mirror images'**
  String get pllGuideMirrorTitle;

  /// No description provided for @pllGuideMirror.
  ///
  /// In en, this message translates to:
  /// **'Every picture counts mirrored too: if it only fits when you read the six stickers from right to left, use the line as if it were drawn that way round.'**
  String get pllGuideMirror;

  /// No description provided for @pllGuideLetterTitle.
  ///
  /// In en, this message translates to:
  /// **'Which letter?'**
  String get pllGuideLetterTitle;

  /// No description provided for @pllGuideLetter.
  ///
  /// In en, this message translates to:
  /// **'Where a line names two cases, such as Ua and Ub, it shows both. They are told apart by which way round the pattern is: the one drawn as it is in the picture, or its mirror image. Two lines need one more look:'**
  String get pllGuideLetter;

  /// No description provided for @pllGuideLetterU.
  ///
  /// In en, this message translates to:
  /// **'3-bar with headlights (U), 3-bar on the left: if the edge on the right is opposite the 3-bar\'s colour it is Ua, if it is opposite the headlights\' colour it is Ub. With the 3-bar on the right it is the other way round.'**
  String get pllGuideLetterU;

  /// No description provided for @pllGuideLetterA.
  ///
  /// In en, this message translates to:
  /// **'Both bars inside, bookends match (A): if the bookends\' colour is adjacent to the bars\' colour it is Aa, if it is opposite it is Ab.'**
  String get pllGuideLetterA;

  /// No description provided for @pllGuideCredit.
  ///
  /// In en, this message translates to:
  /// **'After Mark49152\'s Two-Sided PLL Recognition Guide.'**
  String get pllGuideCredit;

  /// No description provided for @trainerTabRules.
  ///
  /// In en, this message translates to:
  /// **'Patterns'**
  String get trainerTabRules;

  /// No description provided for @trainerTabAuf.
  ///
  /// In en, this message translates to:
  /// **'AUF'**
  String get trainerTabAuf;

  /// No description provided for @trainerTermsInfo.
  ///
  /// In en, this message translates to:
  /// **'The words'**
  String get trainerTermsInfo;

  /// No description provided for @pllAufIntro.
  ///
  /// In en, this message translates to:
  /// **'AUF (Adjust U Face) is the last turn of the top layer that lines it up once the PLL is done. Which way to turn has no fixed answer per case: it depends on the algorithm you use. For many cases the patterns make it obvious; these are the hints for the less obvious ones.'**
  String get pllAufIntro;

  /// No description provided for @pllAufUTitle.
  ///
  /// In en, this message translates to:
  /// **'U: the 2:1 pattern'**
  String get pllAufUTitle;

  /// No description provided for @pllAufU1.
  ///
  /// In en, this message translates to:
  /// **'The odd edge is the opposite colour: the 3-bar is adjacent.'**
  String get pllAufU1;

  /// No description provided for @pllAufU2.
  ///
  /// In en, this message translates to:
  /// **'The odd edge is an adjacent colour: the 3-bar is opposite.'**
  String get pllAufU2;

  /// No description provided for @pllAufGbdTitle.
  ///
  /// In en, this message translates to:
  /// **'Gb/d: opposite lights'**
  String get pllAufGbdTitle;

  /// No description provided for @pllAufGbd.
  ///
  /// In en, this message translates to:
  /// **'The 2-bar touches the side with the 2:1 pattern.'**
  String get pllAufGbd;

  /// No description provided for @pllAufJTitle.
  ///
  /// In en, this message translates to:
  /// **'J: double 2-bar'**
  String get pllAufJTitle;

  /// No description provided for @pllAufJ.
  ///
  /// In en, this message translates to:
  /// **'The 3-bar is next to the side whose colours are adjacent.'**
  String get pllAufJ;

  /// No description provided for @pllAufATitle.
  ///
  /// In en, this message translates to:
  /// **'A: double 2-bar'**
  String get pllAufATitle;

  /// No description provided for @pllAufA.
  ///
  /// In en, this message translates to:
  /// **'The lights are next to the side whose colours are adjacent.'**
  String get pllAufA;

  /// No description provided for @pllAufRGacTitle.
  ///
  /// In en, this message translates to:
  /// **'R and Ga/c: bookends'**
  String get pllAufRGacTitle;

  /// No description provided for @pllAufR.
  ///
  /// In en, this message translates to:
  /// **'R: the lights are further from the test pair.'**
  String get pllAufR;

  /// No description provided for @pllAufGac.
  ///
  /// In en, this message translates to:
  /// **'Ga/c: the lights are nearer to the test pair.'**
  String get pllAufGac;

  /// No description provided for @pllAufFTitle.
  ///
  /// In en, this message translates to:
  /// **'F: checkers'**
  String get pllAufFTitle;

  /// No description provided for @pllAufF.
  ///
  /// In en, this message translates to:
  /// **'The bar is next to the pair of opposite colours.'**
  String get pllAufF;
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
