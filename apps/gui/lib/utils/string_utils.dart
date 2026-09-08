import "package:characters/characters.dart";

extension StringCase on String {
  String get capitalized => switch (characters.take(1)) {
    final first when first.isEmpty => this,
    final first => (first.toUpperCase() + characters.skip(1)).string,
  };
}
