# TODO

## Stackmat timer

Time solves with a physical Stackmat timer, read from its audio output (3.5mm cable into the microphone or line-in). Only Stackmat for now; Bluetooth timers (GAN, QiYi) are not planned until there is one to test with.

Decided:
- A solve made with a Stackmat takes the Stackmat's time, not the app's own.

Open:
- Where to choose between the Stackmat and pressing the screen: a setting under Timer, or on the timer page itself.

Protocol, as csTimer reads it (`src/js/hardware/stackmat.js`):
- 1200 baud serial over audio, 8 data bits, idle level high.
- A packet is 9 or 10 characters: a state character, the digits, a checksum, then a line end.
  - State: ` ` running, `S` stopped, `I` idle, `L` / `R` one hand, `C` both hands, `A` green light.
  - Digits: minutes, seconds (2), then hundredths (2) or milliseconds (3, in the 10 character packet).
  - Checksum: 64 plus the sum of the digits, as a character, third from the end.
- Time is `minutes * 60000 + seconds * 1000 + fraction`.

Plan:
1. Read the microphone as PCM with the `record` package (stream); add the microphone permission on iOS and Android.
2. A decoder in `packages/cube_timer`, plain Dart so it can be tested on made-up signals: edge detection, bits to bytes, packet and checksum.
3. Feed its states to `TimerBloc`: hands on is a press, green light is armed, running starts, stopped records the Stackmat's time.
4. A "Timer input" setting (Touch / Stackmat): DB v8 with a drift migration, and a migration test.

Estimate: decoder and tests 2h, bloc 2h, setting and permission 1h, then tuning on a phone with a real Stackmat.

Open on the phone (iOS):
- The app gets no signal from the Stackmat, and neither does csTimer on the same phone, so the adapter (3.5mm to Lightning/USB-C, with the microphone line) is the first suspect. Get another adapter, check that csTimer works with it, and only then debug the app. On Linux it works with a split microphone/output cable.
- The Android microphone permission (`RECORD_AUDIO`) is not in the manifest yet.

## Landscape

Phones are locked to portrait in `main.dart` (`// shortcut:`), because the timer, records and stats were laid out for upright use only. Adapt them to landscape, then remove the lock.

## Import csTimer and Twisty Timer solves

Read the export files of csTimer and Twisty Timer, as the CSV import (`records_io.dart`) already reads this app's own. First look at a real export of each to see what they hold (times, penalties, scrambles, dates, comments, sessions), and how their puzzles and sessions map onto ours.

## 公式

### 公式練習（PLL, OLL, ...）（twisty timer裡叫做訓練器）

要可以選擇公式練習模式，相當於是另一種puzzle這樣，同一個session切割開來

#### 其他練習模式

cross, F2L, ...

### 公式資料庫（連線speedcubedb？）

顯示公式庫、解法（skewb, FTO, sq1）等等

### 其他

2 side PLL recognization

## 其他

+ 自動解cross？
+ 複製scramble

## settings

要加的設定
+ hold to start：按住多久才算準備好，現在固定 0.3 秒（`TimerConfig.holdDuration`，bloc 已經在用）。只差設定欄位和介面，要有 DB migration，`fromSettings` 裡已經留了註解行
+ scramble image：計時頁顯示或隱藏打亂圖的開關
+ session stats：計時頁顯示或隱藏目前 session 統計（Mo3、Ao5、Ao12、Ao50 等）的開關
+ quick action buttons：完成一把後出現的按鈕（OK、+2、DNF、備註、刪除）的開關
+ average trim：平均去掉最好和最差各幾把。現在固定是 5% 無條件進位（`records.dao.dart` 的 `ao`、`bestAo`，Ao5 和 Ao12 都去掉 1 把），要改成可設定的數量；`mo` 不去頭尾，維持原樣
+ max dnf attempts / DNFs disqualify average：一個平均最多容許幾個 DNF。現在是去頭尾後還剩 DNF 才整個平均算 DNF（`_trimmedMean` 裡的無限大），等於容許的 DNF 數就是 trim 數；做了 average trim 之後這兩個要一起設計，不然 trim 變大會讓容許的 DNF 跟著變多

## UI

desktop的responsive UI
