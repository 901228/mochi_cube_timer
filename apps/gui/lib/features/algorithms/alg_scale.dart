import "algorithm_data/common.dart";

final _move = RegExp(r"^(?:(\d+)(?:-(\d+))?)?([UDFBLRudfblr])(w?)(2?)('?)$");
final _passThrough = RegExp(r"^[MESxyz]2?'?$");

/// Rewrites a big-cube [alg] written for a [from]x[from] cube so it does the same job on a [to]x[to] cube,
/// in WCA notation: every inner layer of the source becomes the whole inner block of the target, and a block
/// that does not touch the face is written as a wide move cancelled by a narrower one (`2R` on 6x6 is `3Rw R'`).
///
/// `M`/`E`/`S` and rotations pass through unchanged: they already mean "every inner layer" on an even cube and
/// "the middle layer" on an odd one.
// shortcut: only 4x4/5x5 sources (one inner layer per half), extend _mapLayer when a 6x6+ source is added.
String scaleAlg(String alg, {required int from, required int to}) {
  if (from == to) return alg;
  if (from != 4 && from != 5) {
    throw ArgumentError.value(from, "from", "only 4x4 and 5x5 sources are supported");
  }
  if (from.isEven != to.isEven || to < from) {
    throw ArgumentError("cannot scale ${from}x$from to ${to}x$to");
  }

  return alg
      .split(RegExp(r"\s+"))
      .where((t) => t.isNotEmpty)
      .map((token) {
        if (_passThrough.hasMatch(token)) return token;
        final m = _move.firstMatch(token);
        if (m == null) throw FormatException("unsupported move", token);

        final face = m[3]!.toUpperCase();
        final lowercase = m[3] != face;
        final wide = m[4]!.isNotEmpty || lowercase;
        final first = m[1] == null ? 1 : int.parse(m[1]!);
        final int lo;
        final int hi;
        if (m[2] != null) {
          (lo, hi) = (first, int.parse(m[2]!));
        } else if (wide) {
          (lo, hi) = (1, m[1] == null ? 2 : first);
        } else {
          (lo, hi) = (first, first);
        }
        if (lo < 1 || hi > from || lo > hi) throw FormatException("layer out of range", token);

        final suffix = "${m[5]}${m[6]}";
        final newLo = _mapLayer(lo, from, to).$1;
        final newHi = _mapLayer(hi, from, to).$2;
        final outer = _wide(face, newHi) + suffix;
        if (newLo == 1) return outer;
        return "$outer ${_wide(face, newLo - 1)}${_invert(suffix)}";
      })
      .join(" ");
}

/// The layers of the [to]-cube that layer [k] (counted from the turned face) of the [from]-cube stands for.
(int, int) _mapLayer(int k, int from, int to) {
  final mirror = k > (from + 1) ~/ 2;
  if (mirror) {
    final (lo, hi) = _mapLayer(from + 1 - k, from, to);
    return (to + 1 - hi, to + 1 - lo);
  }
  if (k == 1) return (1, 1);
  if (k == 2) return (2, to ~/ 2);
  return ((to + 1) ~/ 2, (to + 1) ~/ 2); // the middle layer of an odd cube
}

String _wide(String face, int layers) => switch (layers) {
  1 => face,
  2 => "${face}w",
  _ => "$layers${face}w",
};

String _invert(String suffix) => switch (suffix) {
  "" => "'",
  "'" => "",
  _ => "2",
};

extension AlgorithmGroupScale on AlgorithmGroup {
  /// This group with every algorithm rewritten by [scaleAlg].
  AlgorithmGroup scaledTo({required int from, required int to}) => AlgorithmGroup(
    id: id,
    name: name,
    sets: [
      for (final s in sets)
        AlgorithmSet(
          id: s.id,
          name: s.name,
          subtitle: s.subtitle,
          cases: [
            for (final c in s.cases)
              AlgorithmCase(
                id: c.id,
                name: c.name,
                group: c.group,
                description: c.description,
                algorithms: [for (final a in c.algorithms) scaleAlg(a, from: from, to: to)],
                ollMask: c.ollMask,
                pllArrows: c.pllArrows,
                ftoStickers: c.ftoStickers,
                cubeStickers: c.cubeStickers == null
                    ? null
                    : scaleStickers(c.cubeStickers!, from: from, to: to),
              ),
          ],
        ),
    ],
  );
}

/// How many rows of the [to]-cube each row of the [from]-cube stands for, as [scaleAlg] sees them.
List<int> _rowSpans(int from, int to) {
  final inner = from.isEven ? to ~/ 2 - 1 : (to - 3) ~/ 2;
  return from.isEven ? [1, inner, inner, 1] : [1, inner, 1, inner, 1];
}

/// Stretches the top view [stickers] of a [from]x[from] cube to [to]x[to]: the inner layers [scaleAlg]
/// moves together become one block, so each of their stickers is repeated across it.
String scaleStickers(String stickers, {required int from, required int to}) {
  if (from == to) return stickers;
  final spans = _rowSpans(from, to);
  final index = [for (var i = 0; i < from; i++) ...List.filled(spans[i], i)];
  final face = from * from;
  final out = StringBuffer();
  for (final r in index) {
    for (final c in index) {
      out.write(stickers[r * from + c]);
    }
  }
  for (var side = 0; side < 4; side++) {
    for (final c in index) {
      out.write(stickers[face + side * from + c]);
    }
  }
  return out.toString();
}
