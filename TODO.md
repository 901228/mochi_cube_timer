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
4. A "Timer input" setting (Touch / Stackmat): DB v6 with a drift migration, and a migration test.

Estimate: decoder and tests 2h, bloc 2h, setting and permission 1h, then tuning on a phone with a real Stackmat.

## Clock overlaps its statistics

`timer_page.dart` (about lines 290-320): the row is the left statistics (`Expanded`), the `Cube2DView`, then the right statistics. The Clock's scramble drawing has two faces and is wider, so it squeezes the statistics into each other.

Fix: cap the width of the 2D drawing, or draw the Clock smaller. About 30 minutes.

## Landscape

Phones are locked to portrait in `main.dart` (`// shortcut:`), because the timer, records and stats were laid out for upright use only. Adapt them to landscape, then remove the lock.
