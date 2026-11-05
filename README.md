<p align="center"><img src="apps/gui/assets/icon/icon.png" alt="Mochi Cube Timer" width="120"></p>

<h1 align="center">Mochi Cube Timer</h1>

<p align="center">A speedcubing timer and trainer: time your solves, track your progress, and practise algorithms.</p>

<p align="center">English · <a href="README_zh.md">繁體中文</a></p>

## Features

- **Timer**: scrambles for NxN, FTO and more, with Stackmat input support.
- **Records and stats**: sessions, time lists, and graphs of your times and their distribution.
- **Algorithm sets**: browse OLL, PLL, F2L, L3C, L6X and other sets with diagrams, and practise chosen cases.
- **Trainers**: PLL recognition.
- **3D simulator**: turn a NxN cube or an FTO by typing notation, with CFOP and Nautilus stage views, any orientation, and `( )` turns done at once.

The UI is available in English and Traditional Chinese.

## Project layout

| Path | What it is |
| --- | --- |
| `apps/gui` | The Flutter app |
| `apps/tui` | A command-line app (early stage) |
| `packages/cube_timer` | Shared logic and the Drift database |

The app depends on two sibling repositories by relative path, so clone all three side by side:

- [`mochi_ui`](https://github.com/901228/mochi_ui): the widget library
- [`mochi_cube`](https://github.com/901228/mochi_cube): puzzle logic, scramblers and notation

## Getting started

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

The Flutter version is pinned in `.fvmrc`.

Run the tests with `flutter test` in `apps/gui`.

## Building an iOS IPA

The `iOS` GitHub Actions workflow (`.github/workflows/ios.yml`) builds an unsigned IPA, to be signed and sideloaded separately. Start it with:

```sh
gh workflow run ios.yml --ref <branch>
```
