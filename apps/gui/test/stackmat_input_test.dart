import "dart:typed_data";

import "package:flutter_test/flutter_test.dart";
import "package:mochi_cube_timer_gui/features/timer/stackmat_input.dart";

void main() {
  test("16 bit little endian samples read as -1 to 1", () {
    final samples = Pcm16Samples().read(Uint8List.fromList([0x00, 0x40, 0x00, 0xC0, 0xFF, 0x7F, 0x00, 0x80]));

    expect(samples, [0.5, -0.5, 32767 / 32768, -1.0]);
  });

  test("a sample split between two chunks is read once, whole", () {
    final reader = Pcm16Samples();

    expect(reader.read(Uint8List.fromList([0x00, 0x40, 0x00])), [0.5]);
    expect(reader.read(Uint8List.fromList([0xC0, 0x00])), [-0.5]);
    expect(reader.read(Uint8List.fromList([0x40])), [0.5]);
  });
}
