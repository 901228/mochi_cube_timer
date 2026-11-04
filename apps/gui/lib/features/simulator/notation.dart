import "package:mochi_cube/nxn.dart";
import "package:mochi_ui/mochi_ui.dart";

/// The moves of [notation] undone: in the opposite order, each turned the other way. Brackets are dropped and
/// the moves spaced out, as [cubeLayerTurns] reads them. Moves are not checked, so one that cannot be read
/// stays as it was.
String invertNotation(String notation) {
  final tokens = notation.split(RegExp(r"[\s()\[\]]+")).where((t) => t.isNotEmpty);
  return tokens.toList().reversed.map(_invert).join(" ");
}

String _invert(String token) {
  if (token.contains("'")) return token.replaceFirst("'", "");
  // The turn and its depth or width, then the count: the prime goes between them.
  final m = RegExp(r"^(\d*[A-Za-z]w?)(\d*)$").firstMatch(token);
  return m == null ? token : "${m[1]}'${m[2]}";
}

/// How the cube is held, as the rotation that holds it so from white (U) on top and green (F) in front, and the
/// faces that end up on top and in front.
typedef Orientation = ({String rotation, String top, String front});

const orientations = <Orientation>[
  (rotation: "", top: "U", front: "F"),
  (rotation: "y", top: "U", front: "R"),
  (rotation: "y2", top: "U", front: "B"),
  (rotation: "y'", top: "U", front: "L"),
  (rotation: "z2", top: "D", front: "F"),
  (rotation: "x2", top: "D", front: "B"),
];

/// [setup] held as [rotation]: the rotation goes first, in the place of [previous], the one put there before,
/// and the rest of the setup stays.
// shortcut: a rotation the user typed over or moved is not recognised, and is left in the setup; the new one
// goes in front of it.
String withOrientation(String setup, {required String previous, required String rotation}) {
  final rest = (previous.isNotEmpty && setup.startsWith(previous) ? setup.substring(previous.length) : setup)
      .trim();
  return [rotation, rest].where((part) => part.isNotEmpty).join(" ");
}

/// The tokens in [notation] that [cubeLayerTurns] cannot read on a cube of [size], in the order they appear.
List<String> invalidTokens(String notation, {required int size}) => [
  for (final m in _tokenSpan.allMatches(notation))
    if (!_isValidToken(m[0]!, size)) m[0]!,
];

bool _isValidToken(String token, int size) {
  try {
    cubeLayerTurns(token, size: size);
    return true;
  } on FormatException {
    return false;
  }
}

final _tokenSpan = RegExp(r"[^\s()\[\]]+");

/// A [TextEditingController] that marks in danger red any move [cubeLayerTurns] cannot read for [size].
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
