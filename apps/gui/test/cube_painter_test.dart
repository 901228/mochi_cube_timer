import "package:flutter_test/flutter_test.dart";
import "package:mochi_cube_timer_gui/features/algorithms/cube_painter.dart";

void main() {
  test("cube stickers size comes from the U face plus four side rows", () {
    expect(cubeStickersSize("y" * 12), 2);
    expect(cubeStickersSize("y" * 21), 3);
    expect(cubeStickersSize("y" * 32), 4);
    expect(cubeStickersSize("y" * 45), 5);
    expect(() => cubeStickersSize("y" * 20), throwsArgumentError);
  });

  test("corner view size comes from its three faces", () {
    expect(cubeIsoStickersSize("y" * 12), 2);
    expect(cubeIsoStickersSize("y" * 27), 3);
    expect(cubeIsoStickersSize("y" * 75), 5);
    expect(() => cubeIsoStickersSize("y" * 26), throwsArgumentError);
  });

  test("two faces size comes from their two squares", () {
    expect(cubeFaceStickersSize("y" * 8), 2);
    expect(cubeFaceStickersSize("y" * 50), 5);
    expect(() => cubeFaceStickersSize("y" * 27), throwsArgumentError);
  });
}
