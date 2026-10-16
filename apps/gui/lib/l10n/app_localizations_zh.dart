// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get languageName => '繁體中文';

  @override
  String get languageFlag => '🇹🇼';

  @override
  String get settingsGeneral => '一般';

  @override
  String get settingsTimer => '計時器';

  @override
  String get settingsPuzzle => '方塊';

  @override
  String get generalLocale => '語言';

  @override
  String get localeSystem => '跟隨系統';

  @override
  String get generalAppearance => '外觀';

  @override
  String get generalTheme => '主題';

  @override
  String get themeSystem => '跟隨系統';

  @override
  String get themeLight => '淺色';

  @override
  String get themeDark => '深色';

  @override
  String get generalPrimaryColor => '主色';

  @override
  String get settingsAbout => '關於';

  @override
  String get aboutVersion => '版本';

  @override
  String get aboutCredits => '致謝';

  @override
  String get aboutFlagsCredit => '國旗 emoji：Twemoji，CC-BY 4.0';

  @override
  String get aboutLicenses => '開放原始碼授權';

  @override
  String get commonCancel => '取消';

  @override
  String get commonSubmit => '確定';

  @override
  String get commonDefault => '預設';

  @override
  String get commonNone => '無';

  @override
  String get alertTypeText => '文字';

  @override
  String get alertTypeAudio => '語音';

  @override
  String get alertTypeVibration => '震動';

  @override
  String get timerInspection => '預備時間';

  @override
  String get timerInspectionDuration => '預備時間長度（秒）';

  @override
  String timerInspectionDurationHint(int seconds) {
    return '預設長度：$seconds 秒';
  }

  @override
  String get timerAlert => '提醒';

  @override
  String get timerAlertTimeLeft => '預備時間提醒';

  @override
  String get timerAlertWhenPrefix => '預備時間經過 ';

  @override
  String get timerAlertWhenAnd => ' 秒和 ';

  @override
  String get timerAlertWhenSuffix => ' 秒時提醒你';

  @override
  String get timerAlertType => '提醒方式';

  @override
  String get timerAlertTypeHint => '選擇計時器如何提醒你';

  @override
  String get timerRecords => '成績';

  @override
  String get timerBestAlert => '最佳成績提醒';

  @override
  String get timerBestAlertHint => '這次成績超越本次練習的最佳時提醒';

  @override
  String get timerWorstAlert => '最差成績提醒';

  @override
  String get timerWorstAlertHint => '這次成績比本次練習的最差還慢時提醒';

  @override
  String get timerAverageAlert => '最佳平均提醒';

  @override
  String get timerAverageAlertHint => 'Mo3、Ao5 或 Ao12 超越本次練習的最佳時提醒';

  @override
  String get timerColors => '顏色';

  @override
  String get timerColorPressed => '按下';

  @override
  String get timerColorHolding => '按住';

  @override
  String get timerColorAccept => '可放開';

  @override
  String get puzzleCubeColors => '方塊顏色';

  @override
  String get puzzlePyraminxColors => '金字塔顏色';

  @override
  String get puzzleClockColors => 'Clock 顏色';

  @override
  String get faceUp => '上';

  @override
  String get faceDown => '下';

  @override
  String get faceLeft => '左';

  @override
  String get faceRight => '右';

  @override
  String get faceFront => '前';

  @override
  String get faceBack => '後';

  @override
  String get penaltyNone => '無';

  @override
  String get penaltyDnf => 'DNF';

  @override
  String get penaltyPlus2 => '加 2 秒';

  @override
  String get ttsLanguage => 'zh-TW';

  @override
  String speakSeconds(String seconds) {
    return '$seconds 秒';
  }

  @override
  String get speakNewBest => '最佳成績';

  @override
  String get speakWorst => '最差成績';

  @override
  String speakAverages(String kinds) {
    return '最佳 $kinds';
  }

  @override
  String get speakAnd => '和';

  @override
  String breakBest(String seconds) {
    return '最佳成績！−$seconds';
  }

  @override
  String breakWorst(String seconds) {
    return '目前最差 +$seconds';
  }

  @override
  String breakAverages(String averages) {
    return '最佳 $averages';
  }

  @override
  String timerScrambleFailed(String error) {
    return '打亂失敗：$error';
  }

  @override
  String get timerRecordAdded => '已新增成績';

  @override
  String get timerEditScramble => '編輯打亂';

  @override
  String get timerEnterScramble => '輸入打亂';

  @override
  String get timerScrambleHint => '打亂';

  @override
  String get timerPreviousScramble => '上一個打亂';

  @override
  String get timerNextScramble => '下一個打亂';

  @override
  String get statDeviation => '標準差';

  @override
  String get statMean => '平均';

  @override
  String get statBest => '最佳';

  @override
  String get statCount => '次數';

  @override
  String get commentAdd => '新增備註';

  @override
  String get commentEdit => '編輯備註';

  @override
  String get commentHint => '備註';

  @override
  String get commentTooltip => '備註';

  @override
  String get deleteRecordTitle => '刪除成績？';

  @override
  String get deleteRecordMessage => '這次的成績會被永久刪除。';

  @override
  String get commonDelete => '刪除';
}
