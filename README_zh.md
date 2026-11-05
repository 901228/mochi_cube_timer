<p align="center"><img src="apps/gui/assets/icon/icon.png" alt="Mochi Cube Timer" width="120"></p>

<h1 align="center">Mochi Cube Timer</h1>

<p align="center">魔術方塊計時與練習工具：計時、追蹤進步、練習公式。</p>

<p align="center"><a href="README.md">English</a> · 繁體中文</p>

## 功能

- **計時器**：支援 NxN、FTO 等打亂，可接 Stackmat。
- **紀錄與統計**：Session、時間列表，以及成績與分布圖。
- **公式集**：瀏覽 OLL、PLL、F2L、L3C、L6X 等公式與圖示，並可挑選案例練習。
- **訓練**：PLL 辨識。
- **3D 模擬器**：輸入記號轉動 NxN 方塊或 FTO，可切換 CFOP、Nautilus 階段檢視、任意朝向，並支援 `( )` 同時轉。

介面支援英文與繁體中文。

## 專案結構

| 路徑 | 說明 |
| --- | --- |
| `apps/gui` | Flutter App |
| `apps/tui` | 命令列程式（早期階段） |
| `packages/cube_timer` | 共用邏輯與 Drift 資料庫 |

App 以相對路徑依賴兩個同層的 repo，請三個一起 clone 到同一個資料夾：

- [`mochi_ui`](https://github.com/901228/mochi_ui)：元件庫
- [`mochi_cube`](https://github.com/901228/mochi_cube)：方塊邏輯、打亂與記號

## 開始使用

```sh
mkdir mochi && cd mochi
git clone git@github.com:901228/mochi_cube_timer.git
git clone git@github.com:901228/mochi_ui.git
git clone git@github.com:901228/mochi_cube.git

cd mochi_cube_timer
flutter pub get
cd apps/gui
flutter run
```

Flutter 版本固定在 `.fvmrc`。

在 `apps/gui` 執行 `flutter test` 跑測試。

## 建置 iOS IPA

GitHub Actions 的 `iOS` workflow（`.github/workflows/ios.yml`）會建置未簽名的 IPA，之後另外簽名並側載。啟動方式：

```sh
gh workflow run ios.yml --ref <branch>
```
