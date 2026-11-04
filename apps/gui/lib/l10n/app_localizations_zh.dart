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
  String get settingsTimerBehavior => '計時';

  @override
  String get settingsPuzzle => '方塊顏色';

  @override
  String get settingsInspection => '觀察';

  @override
  String get settingsTimerAppearance => '計時器外觀';

  @override
  String get settingsStats => '統計';

  @override
  String get settingsAbout => '關於';

  @override
  String get settingsOther => '其他';

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
  String get timerDisplay => '時間顯示';

  @override
  String get timerHold => '按住開始';

  @override
  String get timerHoldHint => '按住螢幕多久之後，計時器才會準備好';

  @override
  String get timerShown => '計時頁顯示';

  @override
  String get timerShowScrambleImage => '轉亂圖';

  @override
  String get timerShowScrambleImageHint => '顯示轉亂的圖';

  @override
  String get timerShowSessionStats => 'Session 統計';

  @override
  String get timerShowSessionStatsHint => '顯示這個 session 的統計';

  @override
  String get timerShowQuickActions => '快速操作';

  @override
  String get timerShowQuickActionsHint => '完成一把後，顯示罰時、備註和刪除的按鈕';

  @override
  String get statsAverages => '平均';

  @override
  String get statsAverageTrim => '平均去頭尾';

  @override
  String get statsAverageTrimHint => '平均兩端各去掉的比例，也就是最好和最差的幾把';

  @override
  String statsAverageTrimOption(int percent) {
    return '$percent%';
  }

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
  String get homeKindPuzzles => '方塊';

  @override
  String get homeKindAlgorithms => '公式練習';

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

  @override
  String get timerScrambleCopied => '已複製轉亂';

  @override
  String get algorithmsTitle => '公式';

  @override
  String get algorithmsSelectSet => '選擇公式集';

  @override
  String algorithmsCasesCount(int count) {
    return '$count 種情況';
  }

  @override
  String get algorithmsCopied => '已複製公式';

  @override
  String get algorithmsExpandAll => '全部展開';

  @override
  String get algorithmsCollapseAll => '全部收合';

  @override
  String algorithmsNoSets(String puzzle) {
    return '$puzzle 目前沒有公式集';
  }

  @override
  String get practiceCrossName => 'Cross';

  @override
  String get practiceCrossDescription => '只解底層十字';

  @override
  String get practiceViewList => '列表';

  @override
  String get practiceViewGrid => '格狀';

  @override
  String get practiceCasesTitle => '要練習的 case';

  @override
  String practiceCasesCount(int selected, int total) {
    return '已選 $selected / $total 個 case';
  }

  @override
  String get simulatorTitle => '模擬';

  @override
  String get simulatorMovesHint => '輸入轉動，例如 R U R\' U\'';

  @override
  String get simulatorToStart => '回到開頭';

  @override
  String get simulatorStepBack => '上一步';

  @override
  String get simulatorPlay => '播放';

  @override
  String get simulatorPause => '暫停';

  @override
  String get simulatorStepForward => '下一步';

  @override
  String get simulatorToEnd => '跳到結尾';

  @override
  String get simulatorSettings => '模擬設定';

  @override
  String get simulatorHintDistance => '提示貼紙距離';

  @override
  String get simulatorHintOff => '關閉';

  @override
  String get simulatorSpeed => '轉動速度';

  @override
  String get simulatorStickerless => '無貼紙';

  @override
  String get simulatorLoop => '循環播放';

  @override
  String get simulatorLoopHint => '按下播放後，播完會從頭再播';

  @override
  String get simulatorResetView => '重置視角';

  @override
  String get simulatorCubeSize => '方塊大小';

  @override
  String get simulatorResetSettings => '恢復預設';

  @override
  String get simulatorHintLabels => '提示字母';

  @override
  String get simulatorRandom => '隨機打亂';

  @override
  String get simulatorInverse => '反轉公式';

  @override
  String get simulatorReset => '重置';

  @override
  String simulatorInvalidMove(String move) {
    return '無法辨識：$move';
  }

  @override
  String get trainersTitle => '練習器';

  @override
  String get trainerPllRecognitionTitle => 'PLL 兩面辨識';

  @override
  String get trainerPllRecognitionDescription => '只看前、右兩面，判斷是哪個 PLL';

  @override
  String trainerAnswerWas(String name) {
    return '答案是 $name';
  }

  @override
  String get trainerNext => '下一題';

  @override
  String get trainerTabPractice => '練習';

  @override
  String trainerPattern(String group, String rule) {
    return '$group：$rule';
  }

  @override
  String get pllGroupThreeBar => '3-bar';

  @override
  String get pllGroupThreeBarInfo => '其中一側三個貼紙同色。';

  @override
  String get pllGroupDoubleLights => '雙燈';

  @override
  String get pllGroupDoubleLightsInfo => '兩側都有 headlights：左右兩個角同色，中間夾著不同色的邊。';

  @override
  String get pllGroupLightsAndBar => '一側 headlights＋另一側 2-bar';

  @override
  String get pllGroupLightsAndBarInfo => '一側是 headlights，另一側是 2-bar。';

  @override
  String get pllGroupLoneLights => '單側 headlights';

  @override
  String get pllGroupLoneLightsInfo => '一側是 headlights，另一側沒有 bar 也沒有 headlights。';

  @override
  String get pllGroupDoubleBar => '兩側都有 2-bar';

  @override
  String get pllGroupDoubleBarInfo => '兩側各有一個 2-bar。';

  @override
  String get pllGroupOutsideBar => '只有外側 2-bar';

  @override
  String get pllGroupOutsideBarInfo => '只有一個 2-bar，在外側。';

  @override
  String get pllGroupInsideBar => '只有內側 2-bar';

  @override
  String get pllGroupInsideBarInfo => '只有一個 2-bar，在靠近中間（兩面交界）的內側。';

  @override
  String get pllGroupBookends => '只有 bookends';

  @override
  String get pllGroupBookendsInfo => '沒有 bar 或 headlights，但最外側兩個貼紙同色。';

  @override
  String get pllGroupNoBookends => '什麼都沒有';

  @override
  String get pllGroupNoBookendsInfo => '以上都沒有：最外側兩個貼紙不同色。';

  @override
  String get pllRuleThreeBarHeadlights => '另一側是 headlights';

  @override
  String get pllRuleThreeBarTwoBar => '另一側是 2-bar';

  @override
  String get pllRuleThreeBarFourColours => '另一側三個貼紙都不同色（共 4 色）';

  @override
  String get pllRuleDoubleLightsChecker => '只有兩種顏色，棋盤狀交替（6-checker）';

  @override
  String get pllRuleDoubleLights21 => '3 色：一側的邊跟另一側的角同色（2:1）';

  @override
  String get pllRuleDoubleLightsOpposite => '4 色；兩條邊都是各自那對燈的對色';

  @override
  String get pllRuleDoubleLightsAdjacent => '4 色；兩條邊都是各自那對燈的相鄰色';

  @override
  String get pllRuleLightsBarInside3 => '2-bar 在內側，共 3 色';

  @override
  String get pllRuleLightsBarInside4 => '2-bar 在內側，共 4 色';

  @override
  String get pllRuleLightsBarOutside3 => '2-bar 在外側，共 3 色';

  @override
  String get pllRuleLightsBarOutside4 => '2-bar 在外側，共 4 色';

  @override
  String get pllRuleLoneLights5 => '5-checker（五個貼紙交替）';

  @override
  String get pllRuleLoneLights4 => '4-checker（四個貼紙交替）';

  @override
  String get pllRuleLoneLightsOpposite => '兩盞燈中間的邊是燈色的對色';

  @override
  String get pllRuleLoneLightsAdjacent => '兩盞燈中間的邊是燈色的相鄰色（沒有 checker）';

  @override
  String get pllRuleDoubleBarOutside => '兩個 2-bar 都在外側';

  @override
  String get pllRuleDoubleBarInsideBookends => '兩個 2-bar 都在內側，bookends 同色';

  @override
  String get pllRuleDoubleBarInsideNone => '兩個 2-bar 都在內側，bookends 不同色';

  @override
  String get pllRuleDoubleBarSameBookends => '兩個 2-bar 偏同一邊（一內一外），bookends 同色';

  @override
  String get pllRuleDoubleBarSameNone => '兩個 2-bar 偏同一邊（一內一外），bookends 不同色';

  @override
  String get pllRuleOutsideBarNone => 'bookends 不同色';

  @override
  String get pllRuleOutsideBarAdjacentTwice => 'bookends 同色；有一個顏色出現兩次，且是 2-bar 顏色的相鄰色';

  @override
  String get pllRuleOutsideBarOppositeTwice => 'bookends 同色；有一個顏色出現兩次，且是 2-bar 顏色的對色';

  @override
  String get pllRuleOutsideBarAdjacent => 'bookends 同色；緊鄰 2-bar 的貼紙是 2-bar 顏色的相鄰色（共 4 色）';

  @override
  String get pllRuleOutsideBarOpposite => 'bookends 同色；緊鄰 2-bar 的貼紙是 2-bar 顏色的對色（共 4 色）';

  @override
  String get pllRuleInsideBarAdjacent => 'bookends 同色，且是 2-bar 顏色的相鄰色';

  @override
  String get pllRuleInsideBarOpposite => 'bookends 同色，且是 2-bar 顏色的對色';

  @override
  String get pllRuleInsideBarNone => 'bookends 不同色';

  @override
  String get pllRuleBookends4 => 'bookends 之間是 4-checker';

  @override
  String get pllRuleBookendsAdjacentTwice => '有一個顏色出現兩次，且是 bookends 顏色的相鄰色';

  @override
  String get pllRuleBookendsOppositeTwice => '有一個顏色出現兩次，且是 bookends 顏色的對色';

  @override
  String get pllRuleNoBookendsInner4 => '中間是 4-checker';

  @override
  String get pllRuleNoBookendsOuter4 => '外側是 4-checker';

  @override
  String get pllRuleNoBookends5 => '5-checker（五個貼紙交替）';

  @override
  String get pllGuideIntro => '只看前、右兩面就能判斷任何一個 PLL。把頂排的六個貼紙由左到右讀過去，依序找下面的特徵：第一個符合的就決定是哪一組，再從那一組裡找符合的那一行。';

  @override
  String get pllGuideTermsTitle => '名詞';

  @override
  String get pllTermThreeBar => '同一面的三個貼紙同色。';

  @override
  String get pllTermHeadlights => '同一面左右兩個角同色，中間夾著不同色的邊。';

  @override
  String get pllTermBar => '同一面相鄰的兩個貼紙同色。靠近中間（兩面交界）的叫內側（inside），在最外端的叫外側（outside）。';

  @override
  String get pllTermBookends => '最外側的兩個貼紙（第一個和最後一個）同色。';

  @override
  String get pllTermChecker => '兩種顏色輪流出現，連續四個或五個貼紙。';

  @override
  String get pllTermColoursTitle => '相鄰色與對色';

  @override
  String get pllTermColours => '顏色是跟方塊本身比的：對色是相對兩面的顏色（例如白和黃），其他兩個不同的顏色就是相鄰色。';

  @override
  String get pllGuideOrderTitle => '看的順序';

  @override
  String get pllGuideOrder => '1. 3-bar\n2. headlights\n3. 2-bar\n4. bookends';

  @override
  String get pllGuideMirrorTitle => '鏡像';

  @override
  String get pllGuideMirror => '每張圖也可以左右鏡像：如果要把六個貼紙由右往左讀才符合，就把那一行也左右翻過來看。';

  @override
  String get pllGuideLetterTitle => 'a 還是 b？';

  @override
  String get pllGuideLetter => '一行有兩個 case（例如 Ua 和 Ub）時，兩個都會畫出來，差別在圖案的方向：照圖的方向，或是它的鏡像。有兩行需要多看一眼：';

  @override
  String get pllGuideLetterU =>
      '3-bar 加 headlights（U），3-bar 在左邊：右邊那條邊是 3-bar 顏色的對色就是 Ua，是 headlights 顏色的對色就是 Ub；3-bar 在右邊則相反。';

  @override
  String get pllGuideLetterA => '兩個 2-bar 都在內側且 bookends 同色（A）：bookends 的顏色是 2-bar 顏色的相鄰色就是 Aa，是對色就是 Ab。';

  @override
  String get pllGuideCredit => '參考 Mark49152 的 Two-Sided PLL Recognition Guide。';

  @override
  String get trainerTabRules => '規則';

  @override
  String get trainerTabAuf => 'AUF';

  @override
  String get trainerTermsInfo => '名詞說明';

  @override
  String get pllAufIntro =>
      'AUF（Adjust U Face）是 PLL 做完後，最後轉 U 層把頂層對齊的那一步。轉哪個方向沒有固定答案，要看你用的公式。多數 case 從圖案就看得出來，下面是比較不明顯的幾個提示。';

  @override
  String get pllAufUTitle => 'U：2:1 pattern';

  @override
  String get pllAufU1 => '落單的邊是對色：3-bar 在相鄰的那面。';

  @override
  String get pllAufU2 => '落單的邊是相鄰色：3-bar 在對面。';

  @override
  String get pllAufGbdTitle => 'Gb/d：對色的 lights';

  @override
  String get pllAufGbd => '2-bar 靠著有 2:1 pattern 的那一面。';

  @override
  String get pllAufJTitle => 'J：雙 2-bar';

  @override
  String get pllAufJ => '3-bar 靠著顏色相鄰的那一面。';

  @override
  String get pllAufATitle => 'A：雙 2-bar';

  @override
  String get pllAufA => 'lights 靠著顏色相鄰的那一面。';

  @override
  String get pllAufRGacTitle => 'R 與 Ga/c：bookends';

  @override
  String get pllAufR => 'R：lights 離判斷用的那一對貼紙比較遠。';

  @override
  String get pllAufGac => 'Ga/c：lights 離判斷用的那一對貼紙比較近。';

  @override
  String get pllAufFTitle => 'F：checker';

  @override
  String get pllAufF => '2-bar 靠著顏色相對的那一對。';
}
