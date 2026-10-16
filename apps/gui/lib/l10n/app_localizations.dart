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

  /// No description provided for @aboutFlagsCredit.
  ///
  /// In en, this message translates to:
  /// **'Flag emoji: Twemoji, CC-BY 4.0'**
  String get aboutFlagsCredit;

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
