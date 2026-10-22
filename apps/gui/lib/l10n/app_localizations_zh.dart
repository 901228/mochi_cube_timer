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
  String get timerInspection => '觀察';

  @override
  String get timerInspectionDuration => '觀察時間（秒）';

  @override
  String timerInspectionDurationHint(int seconds) {
    return '預設：$seconds 秒';
  }

  @override
  String get timerAlert => '提醒';

  @override
  String get timerAlertTimeLeft => '觀察時間提醒';

  @override
  String get timerAlertWhenPrefix => '觀察時間經過 ';

  @override
  String get timerAlertWhenAnd => ' 秒和 ';

  @override
  String get timerAlertWhenSuffix => ' 秒時提醒你';

  @override
  String get timerAlertType => '提醒方式';

  @override
  String get timerAlertTypeHint => '選擇計時器如何提醒你';

  @override
  String get timerInput => '計時輸入';

  @override
  String get timerStackmat => '使用 Stackmat';

  @override
  String get timerStackmatHint => '由音訊輸入的 Stackmat 開始與停止計時，螢幕只會開啟觀察時間。';

  @override
  String get timerDisplay => '顯示';

  @override
  String get timerDecimals => '小數位數';

  @override
  String get timerDecimalsHint => '計時頁顯示時間的小數位數';

  @override
  String timerDecimalsOption(int count) {
    return '$count 位';
  }

  @override
  String get timerShowRunningTime => '計時時顯示時間';

  @override
  String get timerShowRunningTimeHint => '關閉時計時中顯示 ...，停止後才顯示時間';

  @override
  String get timerRecords => '最佳成績';

  @override
  String get timerBestAlert => '最佳成績提醒';

  @override
  String get timerBestAlertHint => '這次成績超越本階段的最佳時提醒';

  @override
  String get timerWorstAlert => '最差成績提醒';

  @override
  String get timerWorstAlertHint => '這次成績比本階段的最差還慢時提醒';

  @override
  String get timerAverageAlert => '最佳平均提醒';

  @override
  String get timerAverageAlertHint => 'Mo3、Ao5 或 Ao12 超越本階段的最佳時提醒';

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
  String get puzzleMegaminxColors => '五魔方顏色';

  @override
  String get puzzleFtoColors => 'FTO 顏色';

  @override
  String get puzzleClockColors => '魔錶顏色';

  @override
  String get faceFront => '前';

  @override
  String get faceBack => '後';

  @override
  String get penaltyNone => '無';

  @override
  String get penaltyDnf => 'DNF';

  @override
  String get penaltyPlus2 => '加罰 2 秒';

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
    return '轉亂失敗：$error';
  }

  @override
  String get timerRecordAdded => '已新增成績';

  @override
  String get timerEditScramble => '編輯轉亂';

  @override
  String get timerEnterScramble => '輸入轉亂';

  @override
  String get timerScrambleHint => '轉亂';

  @override
  String get timerPreviousScramble => '上一個轉亂';

  @override
  String get timerNextScramble => '下一個轉亂';

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

  @override
  String get commonArchive => '封存';

  @override
  String get commonUnarchive => '取消封存';

  @override
  String get commonMoveTo => '移動到';

  @override
  String get commonPenalty => '處罰';

  @override
  String get commonComment => '備註';

  @override
  String get commonScramble => '轉亂';

  @override
  String get commonSave => '儲存';

  @override
  String get commonExport => '匯出';

  @override
  String get commonImport => '匯入';

  @override
  String get commonRename => '重新命名';

  @override
  String get commonSelect => '選取';

  @override
  String get commonSettings => '設定';

  @override
  String get commonAdd => '新增';

  @override
  String get commonAny => '不限';

  @override
  String get recordDetail => '成績';

  @override
  String get recordCommentEmpty => '寫點備註吧⋯⋯';

  @override
  String get recordEditComment => '編輯備註';

  @override
  String get recordDeleteMessage => '這筆成績會被永久刪除。';

  @override
  String get recordsNone => '還沒有成績';

  @override
  String get recordsDeleteAllTitle => '刪除全部成績？';

  @override
  String get recordsDeleteAllMessage => '所有成績會被永久刪除。';

  @override
  String get recordsArchiveAllTitle => '封存全部成績？';

  @override
  String get recordsArchiveAllMessage => '所有成績都會被封存。';

  @override
  String get addRecordTitle => '新增成績';

  @override
  String get addRecordInvalidTime => '時間格式不正確';

  @override
  String get addRecordSolveTime => '還原時間';

  @override
  String get addRecordUseCurrent => '使用目前的轉亂';

  @override
  String get addRecordScrambleRequired => '請輸入轉亂';

  @override
  String get searchAddRecord => '新增成績';

  @override
  String get searchComments => '搜尋備註';

  @override
  String get searchDeleteAll => '全部刪除';

  @override
  String get sortNewest => '最新優先';

  @override
  String get sortOldest => '最舊優先';

  @override
  String get sortFastest => '最快優先';

  @override
  String get sortSlowest => '最慢優先';

  @override
  String sortTooltip(String label) {
    return '排序：$label';
  }

  @override
  String get filterRecords => '篩選成績';

  @override
  String filterRecordsActive(int active) {
    return '篩選成績（已套用 $active 項）';
  }

  @override
  String get filterDate => '日期';

  @override
  String get filterAnyTime => '不限時間';

  @override
  String get filterClear => '清除篩選';

  @override
  String get statsCurrent => '目前統計';

  @override
  String get statsSolveCount => '還原次數';

  @override
  String get statsSolveMean => '平均';

  @override
  String get statsSolveDeviation => '標準差';

  @override
  String get statsBestSingle => '最佳單次';

  @override
  String get statsBestStats => '最佳統計';

  @override
  String get statsBestAo5 => '最佳 Ao5';

  @override
  String get statsSolveTimes => '還原時間';

  @override
  String get statsDistribution => '時間分布';

  @override
  String get statsNoSolves => '還沒有成績';

  @override
  String get statsNotEnough => '成績還不夠多';

  @override
  String statsMedian(String value) {
    return '中位數 $value';
  }

  @override
  String homeSetPenaltyAll(String penalty) {
    return '把全部成績的處罰改成$penalty？';
  }

  @override
  String homeMoveAll(String name) {
    return '把全部成績移到 $name？';
  }

  @override
  String get homeDeselectAll => '取消全選';

  @override
  String get homeSelectAll => '全選';

  @override
  String get homeSelectPuzzle => '選擇項目';

  @override
  String get homeShowArchived => '顯示已封存的成績';

  @override
  String get homeSessions => '階段';

  @override
  String get sessionSelect => '選擇階段';

  @override
  String get sessionCreate => '建立新階段';

  @override
  String get sessionImport => '匯入成新階段';

  @override
  String get sessionDeleteTitle => '刪除階段？';

  @override
  String sessionDeleteMessage(String name) {
    return '「$name」裡的所有成績會被永久刪除。';
  }

  @override
  String get importPickTitle => '選擇成績的 csv 檔';

  @override
  String get importDefaultName => '匯入';

  @override
  String get importTitle => '匯入成績？';

  @override
  String importMessageNew(int count, String name) {
    return '$count 筆成績會加入新的階段「$name」。';
  }

  @override
  String importMessageExisting(int count, String name) {
    return '$count 筆成績會加入「$name」。';
  }

  @override
  String importSkipped(int skipped) {
    return '有 $skipped 列無法讀取，會略過。';
  }

  @override
  String get importDone => '已匯入成績';

  @override
  String importDoneDescription(int count, String name) {
    return '已將 $count 筆成績加入「$name」。';
  }

  @override
  String get importFailed => '無法匯入這個檔案';

  @override
  String get importNotRecords => '不是成績檔：需要 Puzzle、Scramble、Time 和 Datetime 欄位';

  @override
  String get exportTitle => '匯出階段';

  @override
  String get exportAsCsv => '匯出成 CSV';

  @override
  String get exportIncludeDeleted => '包含已刪除的成績';

  @override
  String get exportPickTitle => '將階段輸出成 csv 檔';

  @override
  String get exportDone => '已匯出階段';

  @override
  String get exportDonePrefix => '階段的成績已匯出到 ';

  @override
  String get timerInspectionHint => '觀察';

  @override
  String get timerGo => '開始！';

  @override
  String get navTimer => '計時';

  @override
  String get navRecords => '紀錄';

  @override
  String get navStats => '統計';

  @override
  String get puzzleCube2 => '二階';

  @override
  String get puzzleCube3 => '三階';

  @override
  String get puzzleCube4 => '四階';

  @override
  String get puzzleCube5 => '五階';

  @override
  String get puzzleCube6 => '六階';

  @override
  String get puzzleCube7 => '七階';

  @override
  String get puzzleClock => '魔錶';

  @override
  String get puzzleFto => 'FTO';

  @override
  String get puzzleMegaminx => '五魔方';

  @override
  String get puzzlePyraminx => '金字塔';

  @override
  String get puzzleSkewb => '斜轉';

  @override
  String get puzzleSquare1 => 'Square-1';

  @override
  String timerAlertFirst(int seconds) {
    return '$seconds秒!';
  }

  @override
  String timerAlertSecond(int seconds) {
    return '$seconds秒!!';
  }
}
