# TODO

## Stackmat 計時器

透過實體 Stackmat 計時器的音訊輸出（3.5mm 線接麥克風或 line-in）計時。目前只支援 Stackmat；藍牙計時器（GAN、QiYi）等手邊有設備可以測試時再考慮。

已決定：
- 使用 Stackmat 完成的還原，時間以 Stackmat 讀數為準，而非 App 自己的計時。
- ~~在哪裡切換 Stackmat 與觸控螢幕~~：已做成「計時器輸入」的設定開關。

通訊協定（照 csTimer 的 `src/js/hardware/stackmat.js` 解析）：
- 音訊上跑 1200 baud 序列訊號，8 data bits，閒置時為高電位。
- 每個封包為 9 或 10 個字元：狀態字元、數字、checksum，最後是換行。
  - 狀態：` ` 計時中、`S` 停止、`I` 閒置、`L` / `R` 單手放上、`C` 雙手放上、`A` 綠燈亮。
  - 數字：分（1 碼）、秒（2 碼）、百分之一秒（2 碼）或毫秒（3 碼，10 字元封包）。
  - Checksum：64 加上所有數字總和對應的字元（倒數第 3 個字元）。
- 時間計算為 `分 * 60000 + 秒 * 1000 + 小數部分`。

手機支援（目前關閉，僅開放桌面版，`stackmat_bridge.dart:12`）：
- 目前這個 App 跟 csTimer 在手機上都收不到訊號。需要先換一條轉接頭，先用 csTimer 測試通過後，再回來除錯 App。Linux 上用音源分接線可正常運作。
- Android：`AndroidManifest.xml` 尚未加入 `RECORD_AUDIO` 權限。
- iOS：`NSMicrophoneUsageDescription` 在 `ios-mic` 分支上，尚未合併。

## 匯入 csTimer 與 Twisty Timer 紀錄

讀取 csTimer 與 Twisty Timer 的匯出檔，比照現有的 CSV 匯入（`records_io.dart`）。動工前先找兩者的真實匯出檔來看裡面的格式（時間、懲罰、打亂、日期、備註、session），以及它們的方塊種類與 session 如何對應到我們的系統。

## 公式

### 公式練習（訓練器）

- [x] 選擇公式練習模式（同一個 session 依練習集分開紀錄）
- [x] Cross 練習模式
- [x] F2L 等公式集練習（隨公式庫的各個公式集一起提供）
- [x] 兩面 PLL 辨識（2-side PLL recognition）
- [ ] 練習打亂不要只是公式倒過來：把挑定的案例丟給 `mochi_cube` 的 min2phase 求解，得到不同於公式反轉的打亂（目前 `practice_scramble.dart` 直接反轉公式，看久了會認得出來）。`mochi_cube` 的 `pllPracticeScramble` / `ollPracticeScramble` 只能隨機整組，不能指定案例，所以 app 沒用它們。

### 公式資料庫（SpeedCubeDB）

- [x] 公式庫與圖示
- [ ] 解法說明（Skewb、FTO、Square-1）
- [ ] 排序公式、自行輸入公式

## 3D 模擬器

- 立體貼紙：把目前的「無貼紙」開關換成「立體貼紙」（貼紙有厚度、方塊有鏤空等外觀），可能之後會做。
- 手指滑動轉層：先不做，之後再說。
- 圖片匯出：把模擬的畫面存成圖片（PNG），可能之後會做。

## UI 與其他

- 桌面版的響應式 UI（Desktop responsive UI）
- 自動解 Cross？
- ~~DNF 上限 / DNF 直接判平均 DNF~~：不做，DNF 規則維持去頭尾後還剩 DNF 才算 DNF。

## 程式碼內的 TODO

- `apps/gui/lib/features/records/records_page.dart:13`：紀錄頁支援 tile 列表模式（`TODO: tile list mode`）。
- `apps/gui/android/app/build.gradle.kts:18, 34`：設定專屬的 Android Application ID 與 release 簽章設定。

## 技術債與 Shortcut（已知限制，按需升級）

### `mochi_cube_timer`
- `apps/gui/linux/runner/my_application.cc:60`：Impeller 在 Flutter 3.49 之前於 Linux 上沒有 MSAA（flutter#191379），斜線邊緣會有鋸齒，目前手動停用 Impeller；等 Flutter 3.49 穩定後移除。
- `apps/gui/lib/features/algorithms/alg_scale.dart:12`：高階公式縮放目前只支援從 4x4 / 5x5 來源放大（每半邊只有一層內層）；若之後加入 6x6 以上的公式來源，需擴充 `_mapLayer`。
- `apps/gui/lib/features/simulator/notation.dart:34`：模擬器朝向選單只會替換自己上次填入的前綴；若使用者手動改寫或移動了該旋轉，再選新朝向時不會辨識舊旋轉，而是直接加在最前面。

### `mochi_cube`
- `lib/nxn/cube.dart:92`、`lib/megaminx/cube.dart:100`：`fromFaceletString` 未檢查貼紙狀態是否能透過合法轉動達成（目前僅供繪圖，不影響使用；若之後加入求解器需逐塊檢查）。
- `lib/nxn/scramble.dart:28`：`NxNTurns` 檢查無效步時，未考慮高度對稱狀態下繞不同軸旋轉後等價的極端情況（測試中與 TNoodle 比對結果一致；若發現差異再改為比對完整狀態）。
- `lib/nxn/scramble.dart:108`：高階隨機打亂未檢查 WCA 4b3「一步可還原需重抽」（60 步以上無廢步在實務上不會發生；若之後用於極短打亂需補求解器檢查）。
- `lib/fto/search.dart:194`：FTO 隨機打亂未檢查 WCA 4b3 最少兩步的限制（隨機狀態落在兩步內的機率約 $10^{-28}$）。
- `lib/square1/search.dart:295`：Square-1 打亂的 11 步下限是用搜尋找到的解長（上界）檢查，而非最佳解；解長通常在 24 步左右，極少數低於 11 步的狀態可能通過，若需嚴格證明可移植 `sq12phase` 的 `solutionOpt`。

## 告一段落

- 寫 README
- 加上 Android、Linux 的 release CI build
