import "package:mochi_cube/nxn.dart" show nxnFaceNames;

import "simulated_cube.dart";

/// Which stickers of the cube are shown in colour, the rest dimmed, as the steps of a CFOP solve are looked at.
/// A sticker goes by the piece it is on, wherever that piece is now, and by the face it was solved on.
enum Stickering {
  full("Full"),
  cross("Cross"),
  f2l("F2L"),
  oll("OLL"),
  pll("PLL");

  const Stickering(this.label);

  final String label;

  /// Whether the sticker of the piece solved at [home] that was solved on the face [face] (an index in
  /// [nxnFaceNames]) is in colour, on a cube of [size] whose last layer is the one of [lastLayer], also an index
  /// there, and whose cross is on the opposite one.
  bool lit(int size, Vec3 home, int face, {int lastLayer = 0}) {
    final edge = size - 1;
    // Centres are on one face, edges and corners on two or three.
    final onFaces = [home.$1, home.$2, home.$3].where((c) => c.abs() == edge).length;
    final along = dot(faceNormals[lastLayer], home);
    final top = along == edge;
    final bottom = along == -edge;
    final firstTwoLayers = !top || onFaces == 1;
    return switch (this) {
      full => true,
      cross => onFaces == 1 || (onFaces == 2 && bottom),
      f2l => firstTwoLayers,
      // The last layer's stickers are all that is left to look at: its top ones, not its sides.
      oll => firstTwoLayers || face == lastLayer,
      pll => face != lastLayer || onFaces == 1,
    };
  }
}
