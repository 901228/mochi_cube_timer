import "package:mochi_cube/fto.dart";
import "package:mochi_cube/nxn.dart";
import "package:mochi_ui/mochi_ui.dart";

import "simulated_cube.dart";

/// The size the simulator takes to mean the FTO rather than a cube.
const ftoPuzzle = 0;

/// The moves of [notation] undone: in the opposite order, each turned the other way. Brackets are dropped and
/// the moves spaced out, as [cubeLayerTurns] reads them. Moves are not checked, so one that cannot be read
/// stays as it was; so does an FTO's `{X, Y}`, which says how to hold it, not how it was turned.
String invertNotation(String notation, {int size = 3}) {
  final tokens = [for (final m in _tokenSpan.allMatches(notation)) m[0]!];
  return tokens.reversed.map(size == ftoPuzzle ? _invertFto : _invert).join(" ");
}

String _invertFto(String token) => token.startsWith("{")
    ? token
    : token.contains("'")
    ? token.replaceFirst("'", "")
    : "$token'";

String _invert(String token) {
  if (token.contains("'")) return token.replaceFirst("'", "");
  // The turn and its depth or width, then the count: the prime goes between them.
  final m = RegExp(r"^(\d*[A-Za-z]w?)(\d*)$").firstMatch(token);
  return m == null ? token : "${m[1]}'${m[2]}";
}

/// The rotation that holds a cube with the face [top] on top and [front] facing the eye, both indices in
/// [nxnFaceNames], from U on top and F in front; [front] must be next to [top].
String holdRotation(int top, int front) => _holds[(top, front)]!;

final Map<(int, int), String> _holds = () {
  final holds = <(int, int), String>{};
  final turns = [
    for (final axis in ["x", "y", "z"])
      for (final amount in ["", "'", "2"]) "$axis$amount",
  ];
  // The shortest first, so a hold one rotation away is written as that one.
  for (final rotation in [
    "",
    ...turns,
    for (final a in turns)
      for (final b in turns) "$a $b",
  ]) {
    final cube = SimulatedCube(3);
    for (final turn in cubeLayerTurns(rotation, size: 3)) {
      cube.turn(turn);
    }
    int faceAt(Vec3 position) {
      final (x, y, z) = cube.cubies.firstWhere((c) => c.position == position).home;
      return faceNormals.indexOf((x ~/ 2, y ~/ 2, z ~/ 2));
    }

    holds.putIfAbsent((faceAt((0, 2, 0)), faceAt((0, 0, 2))), () => rotation);
  }
  return holds;
}();

/// The tokens in [notation] that cannot be read on a cube of [size], or the FTO for [ftoPuzzle], in the order
/// they appear.
List<String> invalidTokens(String notation, {required int size}) => [
  for (final m in _tokenSpan.allMatches(notation))
    if (!_isValidToken(m[0]!, size)) m[0]!,
];

bool _isValidToken(String token, int size) {
  try {
    size == ftoPuzzle ? ftoNotationSteps(token) : cubeLayerTurns(token, size: size);
    return true;
  } on FormatException {
    return false;
  }
}

/// A move, or an FTO's `{X, Y}` with any spaces in it.
final _tokenSpan = RegExp(r"\{[^}]*\}|[^\s()\[\]]+");

/// A [TextEditingController] that marks in danger red any move that cannot be read for [size].
class NotationController extends TextEditingController {
  NotationController({this._size = 3});

  int _size;
  int get size => _size;
  set size(int value) {
    if (_size == value) return;
    _size = value;
    notifyListeners();
  }

  @override
  TextSpan buildTextSpan({required BuildContext context, TextStyle? style, required bool withComposing}) {
    final danger = context.theme.colors.of(MochiIntent.danger).base;
    final badStyle = (style ?? const TextStyle()).copyWith(
      color: danger,
      decoration: TextDecoration.underline,
      decorationColor: danger,
    );
    final spans = <InlineSpan>[];
    var cursor = 0;
    for (final m in _tokenSpan.allMatches(text)) {
      if (m.start > cursor) spans.add(TextSpan(text: text.substring(cursor, m.start)));
      final token = m[0]!;
      spans.add(TextSpan(text: token, style: _isValidToken(token, _size) ? null : badStyle));
      cursor = m.end;
    }
    if (cursor < text.length) spans.add(TextSpan(text: text.substring(cursor)));
    return TextSpan(style: style, children: spans);
  }
}
