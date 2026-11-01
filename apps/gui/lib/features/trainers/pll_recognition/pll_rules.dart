import "../../algorithms/algorithm_data/pll.dart";
import "pll_view.dart";

/// The nine patterns of the two-sided PLL recognition guide, in the order they are looked for.
enum PllGroup {
  threeBar,
  doubleLights,
  lightsAndBar,
  loneLights,
  doubleBar,
  outsideBar,
  insideBar,
  bookends,
  noBookends,
}

/// One line of the guide: what to see, and the family of cases it names. Every one of the 16 looks of
/// every PLL case matches one of them, and the first it matches, in the order of [PllGroup].
///
/// The six stickers read left to right are the corner `a`, the edge `b` and the corner `c` of the left
/// side, then `d`, `e` and `f` of the right. A bar is two of a side's stickers of one colour, an inside
/// one next to the middle of the strip and an outside one at its end; headlights are `a` and `c` (or
/// `d` and `f`) of one colour round another; the bookends are `a` and `f`.
enum PllRule {
  threeBarHeadlights(PllGroup.threeBar, "U"),
  threeBarTwoBar(PllGroup.threeBar, "J"),
  threeBarFourColours(PllGroup.threeBar, "F"),

  doubleLightsChecker(PllGroup.doubleLights, "Z"),
  doubleLights21(PllGroup.doubleLights, "U"),
  doubleLightsOpposite(PllGroup.doubleLights, "H"),
  doubleLightsAdjacent(PllGroup.doubleLights, "Z"),

  lightsBarInside3(PllGroup.lightsAndBar, "T"),
  lightsBarInside4(PllGroup.lightsAndBar, "R"),
  lightsBarOutside3(PllGroup.lightsAndBar, "A"),
  lightsBarOutside4(PllGroup.lightsAndBar, "Ga/c"),

  loneLights5(PllGroup.loneLights, "R"),
  loneLights4(PllGroup.loneLights, "Ga/c"),
  loneLightsOpposite(PllGroup.loneLights, "Gb/d"),
  loneLightsAdjacent(PllGroup.loneLights, "A"),

  doubleBarOutside(PllGroup.doubleBar, "Y"),
  doubleBarInsideBookends(PllGroup.doubleBar, "A"),
  doubleBarInsideNone(PllGroup.doubleBar, "V"),
  doubleBarSameBookends(PllGroup.doubleBar, "J"),
  doubleBarSameNone(PllGroup.doubleBar, "N"),

  outsideBarNone(PllGroup.outsideBar, "V"),
  outsideBarAdjacentTwice(PllGroup.outsideBar, "R"),
  outsideBarOppositeTwice(PllGroup.outsideBar, "Gb/d"),
  outsideBarAdjacent(PllGroup.outsideBar, "T"),
  outsideBarOpposite(PllGroup.outsideBar, "A"),

  insideBarAdjacent(PllGroup.insideBar, "Ga/c"),
  insideBarOpposite(PllGroup.insideBar, "Gb/d"),
  insideBarNone(PllGroup.insideBar, "Y"),

  bookends4(PllGroup.bookends, "F"),
  bookendsAdjacentTwice(PllGroup.bookends, "R"),
  bookendsOppositeTwice(PllGroup.bookends, "Ga/c"),

  noBookendsInner4(PllGroup.noBookends, "V"),
  noBookendsOuter4(PllGroup.noBookends, "Y"),
  noBookends5(PllGroup.noBookends, "E");

  const PllRule(this.group, this.family);

  final PllGroup group;

  /// A key of [pllFamilies].
  final String family;
}

/// The cases a rule can name, by id. A letter pair is two cases that are told apart by which way round
/// the pattern is, the mirror image being the other.
const Map<String, List<String>> pllFamilies = {
  "U": ["ua", "ub"],
  "J": ["ja", "jb"],
  "F": ["f"],
  "Z": ["z"],
  "H": ["h"],
  "T": ["t"],
  "R": ["ra", "rb"],
  "A": ["aa", "ab"],
  "Ga/c": ["ga", "gc"],
  "Gb/d": ["gb", "gd"],
  "Y": ["y"],
  "V": ["v"],
  "N": ["na", "nb"],
  "E": ["e"],
};

/// Which of the side faces (R 1, F 2, L 4, B 5) are opposite each other. Any two others are adjacent.
bool _opposite(int x, int y) => x == 1 && y == 4 || x == 4 && y == 1 || x == 2 && y == 5 || x == 5 && y == 2;

typedef _Test = PllRule? Function(int a, int b, int c, int d, int e, int f, int colours);

PllRule? _threeBar(int a, int b, int c, int d, int e, int f, int colours) {
  if (a != b || b != c) return null;
  if (d == f) return PllRule.threeBarHeadlights;
  if (d == e || e == f) return PllRule.threeBarTwoBar;
  return PllRule.threeBarFourColours;
}

PllRule? _doubleLights(int a, int b, int c, int d, int e, int f, int colours) {
  if (a != c || d != f) return null;
  if (colours == 2) return PllRule.doubleLightsChecker;
  if (colours == 3) return PllRule.doubleLights21;
  return _opposite(b, a) ? PllRule.doubleLightsOpposite : PllRule.doubleLightsAdjacent;
}

PllRule? _lightsAndBar(int a, int b, int c, int d, int e, int f, int colours) {
  if (a != c || d != e && e != f) return null;
  if (d == e) return colours == 3 ? PllRule.lightsBarInside3 : PllRule.lightsBarInside4;
  return colours == 3 ? PllRule.lightsBarOutside3 : PllRule.lightsBarOutside4;
}

PllRule? _loneLights(int a, int b, int c, int d, int e, int f, int colours) {
  if (a != c) return null;
  if (a == e && b == d) return PllRule.loneLights5;
  if (b == d) return PllRule.loneLights4;
  return _opposite(b, a) ? PllRule.loneLightsOpposite : PllRule.loneLightsAdjacent;
}

PllRule? _doubleBar(int a, int b, int c, int d, int e, int f, int colours) {
  if (a != b && b != c || d != e && e != f) return null;
  if (a == b && e == f) return PllRule.doubleBarOutside;
  if (b == c && d == e) {
    return a == f ? PllRule.doubleBarInsideBookends : PllRule.doubleBarInsideNone;
  }
  return a == f ? PllRule.doubleBarSameBookends : PllRule.doubleBarSameNone;
}

PllRule? _outsideBar(int a, int b, int c, int d, int e, int f, int colours) {
  if (a != b) return null;
  if (a != f) return PllRule.outsideBarNone;
  if (c == e) return _opposite(c, a) ? PllRule.outsideBarOppositeTwice : PllRule.outsideBarAdjacentTwice;
  return _opposite(c, a) ? PllRule.outsideBarOpposite : PllRule.outsideBarAdjacent;
}

PllRule? _insideBar(int a, int b, int c, int d, int e, int f, int colours) {
  if (b != c) return null;
  if (a != f) return PllRule.insideBarNone;
  return _opposite(a, b) ? PllRule.insideBarOpposite : PllRule.insideBarAdjacent;
}

PllRule? _bookends(int a, int b, int c, int d, int e, int f, int colours) {
  if (a != f || b != d) return null;
  if (c == e) return PllRule.bookends4;
  return _opposite(b, a) ? PllRule.bookendsOppositeTwice : PllRule.bookendsAdjacentTwice;
}

PllRule? _noBookends(int a, int b, int c, int d, int e, int f, int colours) {
  if (b == d && c == e) return PllRule.noBookendsInner4;
  if (a == e && b == f) return PllRule.noBookendsOuter4;
  if (a == e && b == d) return PllRule.noBookends5;
  return null;
}

// In the order of [PllGroup].
const List<_Test> _tests = [
  _threeBar,
  _doubleLights,
  _lightsAndBar,
  _loneLights,
  _doubleBar,
  _outsideBar,
  _insideBar,
  _bookends,
  _noBookends,
];

/// The first rule that [strip], the faces of the six stickers as `pllTwoSide` gives them, matches,
/// and whether it was read from right to left to match it: the mirror image of the rule's pattern.
({PllRule rule, bool mirrored})? recognizePll(List<int> strip) {
  assert(strip.length == 6 && strip.every((face) => face >= 1 && face != 3 && face <= 5));
  final colours = strip.toSet().length;
  for (final test in _tests) {
    for (final mirrored in [false, true]) {
      final s = mirrored ? strip.reversed.toList() : strip;
      final rule = test(s[0], s[1], s[2], s[3], s[4], s[5], colours);
      if (rule != null) return (rule: rule, mirrored: mirrored);
    }
  }
  return null;
}

typedef _Look = ({String caseId, PllLook look});

/// Every look of every PLL case, by the six stickers [pllTwoSide] gives, in all of the 4 x 4 turns of
/// the top layer before and after the case, joined into a string. No two cases share one.
final Map<String, _Look> _looks = () {
  final looks = <String, _Look>{};
  for (final c in pllCases) {
    for (var before = 0; before < 4; before++) {
      for (var after = 0; after < 4; after++) {
        final look = pllLook(c.algorithms.first, preAuf: before, auf: after);
        looks.putIfAbsent(look.strip.join(), () => (caseId: c.id, look: look));
      }
    }
  }
  return looks;
}();

/// The case [strip] is a look of.
String? pllCaseOf(List<int> strip) => _looks[strip.join()]?.caseId;

typedef _Mask = ({Set<int> shown, Set<int> framed});

const _all = {0, 1, 2, 3, 4, 5};

_Mask _m(Set<int> shown, Set<int> framed) => (shown: shown, framed: framed);

/// What the guide draws for [rule], on the strip [s] read as it is drawn there: the stickers it shows,
/// in colour, and of those the ones that tell it from the other rules of its group. The rest of the
/// stickers do not matter to it. Null if [s] is the mirror image of how the guide draws it.
_Mask? _mask(PllRule rule, List<int> s) => switch (rule) {
  PllRule.threeBarHeadlights => _m({0, 1, 2, 3, 5}, {3, 5}),
  PllRule.threeBarTwoBar => s[3] == s[4] ? _m({0, 1, 2, 3, 4}, {3, 4}) : _m({0, 1, 2, 4, 5}, {4, 5}),
  PllRule.threeBarFourColours => _m(_all, {3, 4, 5}),
  PllRule.doubleLightsChecker => _m(_all, _all),
  PllRule.doubleLightsOpposite || PllRule.doubleLightsAdjacent => _m(_all, {1, 4}),
  PllRule.doubleLights21 => s[4] == s[0] ? _m({0, 2, 3, 4, 5}, {0, 2, 4}) : null,
  PllRule.lightsBarInside3 || PllRule.lightsBarInside4 => _m(_all, {1, 5}),
  PllRule.lightsBarOutside3 || PllRule.lightsBarOutside4 => _m(_all, {1, 3}),
  PllRule.loneLights5 => _m({0, 1, 2, 3, 4}, {0, 1, 2, 3, 4}),
  PllRule.loneLights4 => _m({0, 1, 2, 3}, {0, 1, 2, 3}),
  PllRule.loneLightsOpposite || PllRule.loneLightsAdjacent => _m({0, 1, 2}, {1}),
  PllRule.doubleBarOutside || PllRule.noBookendsOuter4 => _m({0, 1, 4, 5}, {0, 1, 4, 5}),
  PllRule.doubleBarInsideBookends || PllRule.doubleBarInsideNone => _m(_all, {0, 5}),
  PllRule.doubleBarSameBookends ||
  PllRule.doubleBarSameNone => s[0] == s[1] ? _m({0, 1, 3, 4, 5}, {0, 1, 5}) : null,
  PllRule.outsideBarNone => _m({0, 1, 5}, {0, 1, 5}),
  PllRule.outsideBarAdjacentTwice || PllRule.outsideBarOppositeTwice => _m({0, 1, 2, 4, 5}, {2, 4}),
  PllRule.outsideBarAdjacent || PllRule.outsideBarOpposite => _m({0, 1, 2, 5}, {2}),
  PllRule.insideBarAdjacent || PllRule.insideBarOpposite || PllRule.insideBarNone => _m({0, 1, 2, 5}, {0, 5}),
  PllRule.bookends4 || PllRule.noBookendsInner4 => _m(_all, {1, 2, 3, 4}),
  PllRule.bookendsAdjacentTwice || PllRule.bookendsOppositeTwice => _m({0, 1, 3, 5}, {1, 3}),
  PllRule.noBookends5 => _m(_all, {0, 1, 2, 3, 4}),
};

typedef PllExample = ({
  String caseId,
  List<int> strip,
  List<int> left,
  List<int> back,
  bool mirrored,
  Set<int> shown,
  Set<int> framed,
});

/// Every look of every case with the rule that matches it and what the guide draws of it, by the
/// position of the sticker in the strip. `shown` and `framed` are in the guide's way round, which is
/// the look's or its reverse.
final Map<PllRule, List<PllExample>> _allExamples = () {
  final examples = {for (final rule in PllRule.values) rule: <PllExample>[]};
  for (final (:caseId, :look) in _looks.values) {
    final strip = look.strip;
    final match = recognizePll(strip)!;
    final reversed = strip.reversed.toList();
    final ways = match.mirrored ? [(reversed, true), (strip, false)] : [(strip, false), (reversed, true)];
    final (mask, flip) = ways
        .map((way) => (_mask(match.rule, way.$1), way.$2))
        .firstWhere((way) => way.$1 != null);
    Set<int> back(Set<int> set) => flip ? {for (final i in set) 5 - i} : set;
    examples[match.rule]!.add((
      caseId: caseId,
      strip: strip,
      left: look.left,
      back: look.back,
      mirrored: match.mirrored,
      shown: back(mask!.shown),
      framed: back(mask.framed),
    ));
  }
  return examples;
}();

/// Every look a rule matches, with what the guide draws of it.
List<PllExample> pllLooksOf(PllRule rule) => _allExamples[rule]!;

/// A look of a case that [rule] matches, for each case it can name: the first one matched as the
/// rule's pattern is drawn, or failing that its mirror image.
final Map<PllRule, List<PllExample>> pllExamples = {
  for (final rule in PllRule.values)
    rule: {
      for (final example in _allExamples[rule]!)
        // Looks that are drawn as the rule is come after, and so win.
        if (!example.mirrored || !_allExamples[rule]!.any((e) => e.caseId == example.caseId && !e.mirrored))
          example.caseId: example,
    }.values.toList(),
};

/// The one look the guide draws for [rule]: it names two mirror cases at most, and they look alike
/// once the stickers it does not go by are grey.
PllExample pllRuleExample(PllRule rule) {
  final examples = pllExamples[rule]!;
  return examples.firstWhere((example) => !example.mirrored, orElse: () => examples.first);
}
