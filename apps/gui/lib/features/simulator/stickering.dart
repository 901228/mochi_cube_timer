import "package:mochi_cube/nxn.dart" show nxnFaceNames;

import "simulated_cube.dart";
import "simulated_fto.dart";

/// Which stickers of the puzzle are shown in colour, the rest grey, as the steps of a solve are looked at.
/// A sticker goes by the piece it is on, wherever that piece is now, and by the face it was solved on.
enum Stickering {
  full("Full"),
  cross("Cross", group: "CFOP"),
  f2l("F2L", group: "CFOP"),
  oll("OLL", group: "CFOP"),
  pll("PLL", group: "CFOP"),
  l6x("L6X", group: "Nautilus", fto: true),
  l3c("L3C", group: "Nautilus", fto: true);

  const Stickering(this.label, {this.group, this.fto = false});

  final String label;

  /// The method the step is of, which the menu lists it under; null for [full].
  final String? group;

  /// Whether it is a step of the FTO, rather than of the 3x3x3.
  final bool fto;

  /// The steps there are for the 3x3x3, or for the FTO when [fto].
  static List<Stickering> of({required bool fto}) => [
    full,
    for (final s in values)
      if (s != full && s.fto == fto) s,
  ];

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
    return switch (this) {
      full || l6x || l3c => true,
      // The side and bottom centres to match the edges to, and the bottom edges.
      cross => (onFaces == 1 && !top) || (onFaces == 2 && bottom),
      f2l => !top,
      // Only the last layer's top is left to look at, then its sides too.
      oll => top && face == lastLayer,
      pll => top,
    };
  }

  /// Whether the FTO's sticker solved at facelet [home] is in colour, when the last layer is the one of
  /// [lastLayer], a face of [ftoFaceNames].
  bool litFto(int home, {required int lastLayer}) {
    final last = ftoLayerOf(lastLayer, home) == 0;
    return switch (this) {
      // Its triangles first, then the corners and the rest.
      l6x => last && ftoPieceOf(home) == FtoPiece.centre,
      l3c => last,
      _ => true,
    };
  }
}
