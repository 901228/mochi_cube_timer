import "package:cube_timer/cube_timer.dart";
import "package:flutter/widgets.dart";

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
    return const SizedBox.shrink();
  }
}

/// A named collection of [AlgorithmCase]s belonging to a [Puzzle] (e.g. 3x3x3 OLL or PLL).
@immutable
class AlgorithmSet {
  const AlgorithmSet({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.puzzle,
    required this.cases,
  });

  final String id;
  final String name;
  final String subtitle;
  final Puzzle puzzle;
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
