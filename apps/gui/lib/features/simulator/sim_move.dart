import "package:flutter/foundation.dart" show listEquals;
import "package:mochi_cube/fto.dart";
import "package:mochi_cube/nxn.dart";
import "package:vector_math/vector_math_64.dart";

import "notation.dart";
import "simulated_fto.dart";

/// One move the simulator plays, of some layers or of the whole puzzle, and as far as it is written.
sealed class SimMove {
  const SimMove();

  /// How far it turns: quarters on a cube, thirds on the FTO, negative the other way.
  int get amount;

  /// The same layers, turned [amount] instead: the undoing of a move is it turned `-amount`.
  SimMove withAmount(int amount);

  /// Whether [other] turns the same layers, so the two only differ in how far.
  bool sameLayers(SimMove other);
}

/// The layers of a cube along the axis through [face], each turned [amount] times its count in [base]
/// quarters clockwise as seen from [face], the layer at [face] first: on a 3x3x3 `R` is `[1, 0, 0]` once, `R2'`
/// the same -2 times and `(R L')` `[1, 0, 1]`.
final class CubeMove extends SimMove {
  const CubeMove._(this.face, this.base, this.amount);

  /// [turns], all of the axis through the first one's face, made at once on a cube of [size].
  factory CubeMove(int size, List<CubeLayerTurn> turns) {
    final face = turns.first.face;
    final layers = List.filled(size, 0);
    for (final t in turns) {
      // Counted from the other end, and clockwise from there is the other way.
      final flip = t.face != face;
      for (var l = t.lo; l <= t.hi; l++) {
        layers[flip ? size - l : l - 1] += flip ? -t.quarters : t.quarters;
      }
    }
    final (base, amount) = _shape(layers);
    return CubeMove._(face, base, amount);
  }

  final int face;
  final List<int> base;
  @override
  final int amount;

  /// The layers turned, one at a time, each as far as it goes.
  List<CubeLayerTurn> get turns => [
    for (final (l, k) in base.indexed)
      if (k != 0) (face: face, lo: l + 1, hi: l + 1, quarters: k * amount),
  ];

  @override
  CubeMove withAmount(int amount) => CubeMove._(face, base, amount);

  @override
  bool sameLayers(SimMove other) => other is CubeMove && other.face == face && listEquals(other.base, base);

  @override
  bool operator ==(Object other) => other is CubeMove && sameLayers(other) && other.amount == amount;

  @override
  int get hashCode => Object.hash(face, Object.hashAll(base), amount);

  @override
  String toString() => "CubeMove($face, $base x $amount)";
}

/// [layers] as a shape and how many times it is turned: the shape the smallest whole turns that make them, its
/// first turn clockwise.
(List<int>, int) _shape(List<int> layers) {
  var g = layers.fold(0, (g, v) => _gcd(g, v.abs()));
  if (g == 0) g = 1;
  if (layers.firstWhere((v) => v != 0, orElse: () => 1) < 0) g = -g;
  return ([for (final v in layers) v ~/ g], g);
}

/// The three layers of the FTO's axis through [face], by the puzzle's own faces, turned [amount] times
/// [base] thirds clockwise as seen from [face]: the layer at [face], the middle one, then the one at the face
/// opposite. `R` is `(1, 0, 0)` once, `R2'` the same -2 times, `r` `(1, 1, 0)` and `(r R')` `(0, 1, 0)`.
final class FtoMove extends SimMove {
  const FtoMove._(this.face, this.base, this.amount);

  /// [layers] as [FtoMove]s count them: [base] the smallest whole turns of the same shape.
  factory FtoMove(int face, (int, int, int) layers) {
    final (base, amount) = _shape([layers.$1, layers.$2, layers.$3]);
    return FtoMove._(face, (base[0], base[1], base[2]), amount);
  }

  final int face;
  final (int, int, int) base;
  @override
  final int amount;

  /// How far each layer turns, in thirds.
  (int, int, int) get layers => (base.$1 * amount, base.$2 * amount, base.$3 * amount);

  @override
  FtoMove withAmount(int amount) => FtoMove._(face, base, amount);

  @override
  bool sameLayers(SimMove other) => other is FtoMove && other.face == face && other.base == base;

  @override
  bool operator ==(Object other) =>
      other is FtoMove && other.face == face && other.base == base && other.amount == amount;

  @override
  int get hashCode => Object.hash(face, base, amount);

  @override
  String toString() => "FtoMove($face, $layers)";
}

int _gcd(int a, int b) => b == 0 ? a : _gcd(b, a % b);

/// The whole FTO turned from being held as [from] to [to], `{X, Y}` bringing face [up] up and [front] to the
/// front; backwards, with an [amount] of -1, from [to] back to [from].
final class FtoHold extends SimMove {
  const FtoHold(this.up, this.front, this.from, this.to, {this.amount = 1});

  final int up;
  final int front;
  final Matrix3 from;
  final Matrix3 to;
  @override
  final int amount;

  @override
  FtoHold withAmount(int amount) => FtoHold(up, front, from, to, amount: amount);

  @override
  bool sameLayers(SimMove other) => other is FtoHold && other.up == up && other.front == front;

  @override
  bool operator ==(Object other) =>
      other is FtoHold &&
      other.up == up &&
      other.front == front &&
      other.amount == amount &&
      other.from == from &&
      other.to == to;

  @override
  int get hashCode => Object.hash(up, front, amount);
}

/// [setup] and then [moves], read for a cube of [size] or, for [ftoPuzzle], the FTO. Its moves are named as the
/// setup leaves it held, so the two are read as one. [heldAs] goes first, unseen: the rotation that holds the
/// puzzle as picked, which the setup does not count.
///
/// Throws [FormatException] if either cannot be read.
(List<SimMove>, List<SimMove>) readSimMoves(int size, String setup, String moves, {String heldAs = ""}) {
  setup = "$heldAs $setup";
  if (size != ftoPuzzle) {
    // Turns of one axis in brackets go at once; any others are only grouped.
    List<SimMove> read(String text) => [
      for (final group in cubeLayerGroups(text, size: size))
        if (group.every((t) => t.face % 3 == group.first.face % 3))
          CubeMove(size, group)
        else
          for (final t in group) CubeMove(size, [t]),
    ];
    return (read(setup), read(moves));
  }
  final count = ftoNotationSteps(setup).length;
  var hold = ftoHold(0, 2);
  final all = <SimMove>[
    for (final step in ftoNotationSteps("$setup $moves"))
      switch (step) {
        FtoRotation(:final up, :final front) => () {
          final to = ftoHold(up, front);
          final move = FtoHold(up, front, hold, to);
          hold = to;
          return move;
        }(),
        FtoTurn(:final face, :final thirds, :final wide) => () {
          if (wide) hold = hold.multiplied(ftoWholeTurn(face, thirds));
          return FtoMove(face, (thirds, wide ? thirds : 0, 0));
        }(),
        FtoLayers(:final face, :final layers) => () {
          hold = hold.multiplied(ftoWholeTurn(face, layers.$2));
          return FtoMove(face, layers);
        }(),
      },
  ];
  return (all.sublist(0, count), all.sublist(count));
}
