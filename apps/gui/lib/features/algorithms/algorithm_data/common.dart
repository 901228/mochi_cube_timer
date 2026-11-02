import "package:flutter/widgets.dart";

import "../cube_painter.dart";
import "../fto_painter.dart";
import "../ll_painter.dart";

/// A single algorithm case (e.g. "OLL 1", "Ua") with its diagram and multiple algorithms.
@immutable
class AlgorithmCase {
  const AlgorithmCase({
    required this.id,
    required this.name,
    required this.group,
    required this.algorithms,
    this.description,
    this.ollMask,
    this.pllArrows,
    this.ftoStickers,
    this.cubeStickers,
    this.isoStickers,
    this.faceStickers,
  });

  final String id;
  final String name;
  final String group;

  /// What the case is, when its name only numbers it.
  final String? description;

  /// One or more algorithms for this case; the first one is the primary algorithm.
  final List<String> algorithms;

  final int? ollMask;
  final List<PllArrow>? pllArrows;

  /// The stickers of an FTO last-layer case, as [FtoCaseDiagram] reads them.
  final String? ftoStickers;

  /// The stickers of an NxN last-layer case, as [CubeCaseDiagram] reads them.
  final String? cubeStickers;

  /// The stickers of an NxN case seen from the front-right corner, as [CubeIsoDiagram] reads them.
  final String? isoStickers;

  /// The stickers of an NxN case that only touches two faces, as [CubeFacesDiagram] reads them.
  final String? faceStickers;

  /// Width over height of [buildDiagram]'s drawing; most are square, a pair of faces stands tall.
  double get diagramAspectRatio => faceStickers == null ? 1 : cubeFacesAspectRatio(faceStickers!);

  Widget buildDiagram({required Color topColor, double arrowStrokeWidth = 12.0}) {
    if (ollMask case final mask?) {
      return CustomPaint(
        painter: OllCasePainter(mask: mask, topColor: topColor),
      );
    }
    if (pllArrows case final arrows?) {
      return CustomPaint(
        painter: PllCasePainter(arrows: arrows, topColor: topColor, strokeWidth: arrowStrokeWidth),
      );
    }
    if (ftoStickers case final stickers?) return FtoCaseDiagram(stickers: stickers);
    if (cubeStickers case final stickers?) return CubeCaseDiagram(stickers: stickers);
    if (isoStickers case final stickers?) return CubeIsoDiagram(stickers: stickers);
    if (faceStickers case final stickers?) return CubeFacesDiagram(stickers: stickers);
    return const SizedBox.shrink();
  }
}

/// A named collection of [AlgorithmCase]s (e.g. 3x3x3 OLL or PLL).
@immutable
class AlgorithmSet {
  const AlgorithmSet({required this.id, required this.name, required this.subtitle, required this.cases});

  final String id;
  final String name;
  final String subtitle;
  final List<AlgorithmCase> cases;

  /// Groups in the order they first appear in [cases].
  List<(String group, List<AlgorithmCase> cases)> get grouped {
    final map = <String, List<AlgorithmCase>>{};
    for (final c in cases) {
      (map[c.group] ??= []).add(c);
    }
    return [for (final e in map.entries) (e.key, e.value)];
  }
}

@immutable
class AlgorithmGroup {
  const AlgorithmGroup({required this.id, required this.name, required this.sets});

  final String id;
  final String name;
  final List<AlgorithmSet> sets;
}

typedef AlgorithmGroups = List<AlgorithmGroup>;

extension AlgorithmGroupsX on AlgorithmGroups {
  List<AlgorithmSet> flatten() => expand((v) => v.sets).toList();
}
