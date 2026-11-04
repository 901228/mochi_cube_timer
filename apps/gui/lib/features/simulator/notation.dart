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
