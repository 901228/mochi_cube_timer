import "package:mochi_ui/mochi_ui.dart";

import "../../../l10n/l10n.dart";
import "flat_strip.dart";
import "pll_labels.dart";
import "pll_rules.dart";

/// The stickers of the pictures of the words: the front's colour, and the ones that do not matter, which
/// are drawn grey.
const _f = 2;
const _x = -1;

Widget _page(BuildContext context, {required List<Widget> children}) {
  final g = context.theme.geometry;
  return SingleChildScrollView(
    padding: g.pagePadding + .only(bottom: MediaQuery.paddingOf(context).bottom),
    child: Column(crossAxisAlignment: .stretch, spacing: g.space.lg, children: children),
  );
}

/// [children] in rows of as many columns as fit [minWidth] each. Every card is
/// [minWidth] wide, unless there is only room for one, which has all of it, and the cards of a row are
/// as tall as the tallest.
Widget _columns(BuildContext context, {required double minWidth, required List<Widget> children}) {
  final gap = context.theme.geometry.space.xs;
  return LayoutBuilder(
    builder: (context, constraints) {
      final columns = ((constraints.maxWidth + gap) ~/ (minWidth + gap)).clamp(1, children.length);
      final width = columns == 1 ? constraints.maxWidth : minWidth;
      // The block is as wide as its full rows, and in the middle: a last row with fewer cards starts
      // at the left of the block, so the space at the two sides stays the same.
      return Center(
        child: SizedBox(
          width: width * columns + gap * (columns - 1),
          child: Column(
            crossAxisAlignment: .start,
            spacing: gap,
            children: [
              for (var i = 0; i < children.length; i += columns)
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: .stretch,
                    spacing: gap,
                    children: [
                      for (final child in children.skip(i).take(columns))
                        SizedBox(width: width, child: child),
                    ],
                  ),
                ),
            ],
          ),
        ),
      );
    },
  );
}

TextStyle _muted(BuildContext context) =>
    context.theme.typography.title.sm.copyWith(color: context.colors.mutedForeground);

/// The words of the guide, with a picture of each, in a modal.
Future<void> showPllTerms(BuildContext context) {
  final l10n = context.l10n;
  return showMochiModal(
    context,
    title: Text(l10n.pllGuideTermsTitle),
    body: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: .stretch,
        spacing: 16,
        children: [
          _Term(
            title: "3-bar",
            body: l10n.pllTermThreeBar,
            strips: const [
              [_f, _f, _f, _x, _x, _x],
            ],
          ),
          _Term(
            title: "Headlights",
            body: l10n.pllTermHeadlights,
            strips: const [
              [_f, _x, _f, _x, _x, _x],
            ],
          ),
          _Term(
            title: "2-bar",
            body: l10n.pllTermBar,
            strips: const [
              [_f, _f, _x, _x, _x, _x],
              [_x, _f, _f, _x, _x, _x],
            ],
          ),
          _Term(
            title: "Bookends",
            body: l10n.pllTermBookends,
            strips: const [
              [_f, _x, _x, _x, _x, _f],
            ],
          ),
          _Term(
            title: "Checker",
            body: l10n.pllTermChecker,
            strips: [pllExamples[PllRule.loneLights5]!.first.strip],
          ),
          _Term(title: l10n.pllTermColoursTitle, body: l10n.pllTermColours, strips: const []),
          _Term(title: l10n.pllGuideOrderTitle, body: l10n.pllGuideOrder, strips: const []),
          _Term(title: l10n.pllGuideMirrorTitle, body: l10n.pllGuideMirror, strips: const []),
        ],
      ),
    ),
  );
}

/// The nine groups of patterns, each in a box, with a row of buttons that jump to each.
class PllRulesTab extends StatefulWidget {
  const PllRulesTab({super.key});

  @override
  State<PllRulesTab> createState() => _PllRulesTabState();
}

class _PllRulesTabState extends State<PllRulesTab> {
  final _keys = [for (final _ in PllGroup.values) GlobalKey()];

  void _jump(int i) {
    final target = _keys[i].currentContext;
    if (target != null) {
      Scrollable.ensureVisible(target, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final g = context.theme.geometry;

    return Column(
      crossAxisAlignment: .stretch,
      children: [
        SingleChildScrollView(
          scrollDirection: .horizontal,
          // Room under the buttons for the scroll bar, and over them for the tabs.
          padding: .fromLTRB(g.pagePadding.left, g.space.sm, g.pagePadding.right, g.space.sm),
          child: Row(
            spacing: g.space.xs,
            children: [
              for (final (i, group) in PllGroup.values.indexed)
                MochiButton(
                  appearance: .soft,
                  onPress: () => _jump(i),
                  child: Text(pllGroupTitle(l10n, group)),
                ),
            ],
          ),
        ),
        Expanded(
          child: _page(
            context,
            children: [
              Text(l10n.pllGuideIntro),
              _columns(
                context,
                minWidth: 340,
                children: [
                  for (final (i, group) in PllGroup.values.indexed) _GroupBox(key: _keys[i], group: group),
                ],
              ),
              Text(l10n.pllGuideCredit, style: _muted(context)),
            ],
          ),
        ),
      ],
    );
  }
}

/// What a group has in common, as the guide draws it above the group: the stickers that are there, in
/// the colours of two faces, and the ones that are not, grey.
const _schematic = {
  PllGroup.threeBar: [2, 2, 2, -1, -1, -1],
  PllGroup.doubleLights: [2, -1, 2, 1, -1, 1],
  PllGroup.lightsAndBar: [2, -1, 2, 1, 1, -1],
  PllGroup.loneLights: [2, -1, 2, -1, -1, -1],
  PllGroup.doubleBar: [2, 2, -1, -1, 1, 1],
  PllGroup.outsideBar: [2, 2, -1, -1, -1, -1],
  PllGroup.insideBar: [-1, 2, 2, -1, -1, -1],
  PllGroup.bookends: [2, -1, -1, -1, -1, 2],
  PllGroup.noBookends: [2, -1, -1, -1, -1, 1],
};

Set<int> _framedOf(List<int> stickers) => {
  for (final (i, sticker) in stickers.indexed)
    if (sticker >= 0) i,
};

/// A group of patterns: one line to a rule, with a look of it and the cases it names.
class _GroupBox extends StatelessWidget {
  const _GroupBox({super.key, required this.group});

  final PllGroup group;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return MochiCard(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: .stretch,
        spacing: 8,
        children: [
          Row(
            spacing: 12,
            children: [
              Expanded(child: Text(pllGroupTitle(l10n, group), style: context.theme.typography.title.lg)),
              SizedBox(
                width: 120,
                child: FlatStrip(stickers: _schematic[group]!, framed: _framedOf(_schematic[group]!)),
              ),
            ],
          ),
          Text(pllGroupInfo(l10n, group), style: _muted(context)),
          for (final rule in PllRule.values.where((rule) => rule.group == group)) _RuleRow(rule: rule),
        ],
      ),
    );
  }
}

/// A rule: what to see, framed, and the cases it is.
class _RuleRow extends StatelessWidget {
  const _RuleRow({required this.rule});

  final PllRule rule;

  @override
  Widget build(BuildContext context) {
    final example = pllRuleExample(rule);
    return Row(
      spacing: 12,
      children: [
        SizedBox(
          width: 120,
          child: FlatStrip(stickers: example.strip, shown: example.shown, framed: example.framed),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Text(rule.family, style: context.theme.typography.title.md),
              Text(pllRuleLabel(context.l10n, rule), style: context.theme.typography.body.sm),
            ],
          ),
        ),
      ],
    );
  }
}

bool _bar3(List<int> r) => r[0] == r[1] && r[1] == r[2];
bool _bar2(List<int> r) => (r[0] == r[1]) != (r[1] == r[2]);
bool _lights(List<int> r) => r[0] == r[2] && r[1] != r[0];

/// A rule of a hint, and what to look for on the sides out of view.
typedef _Aim = (PllRule, bool Function(List<int>));

/// Which way to AUF, and which of two mirror cases it is.
class PllAufTab extends StatelessWidget {
  const PllAufTab({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final g = context.theme.geometry;

    // What a hint says is to be found on the side that is out of view, and where to find it.
    final hints = <(String, List<_Aim>, List<String>)>[
      (l10n.pllAufUTitle, [(PllRule.doubleLights21, _bar3)], [l10n.pllAufU1, l10n.pllAufU2]),
      (l10n.pllAufGbdTitle, [(PllRule.loneLightsOpposite, _bar2)], [l10n.pllAufGbd]),
      (l10n.pllAufJTitle, [(PllRule.doubleBarSameBookends, _bar3)], [l10n.pllAufJ]),
      (l10n.pllAufATitle, [(PllRule.doubleBarInsideBookends, _lights)], [l10n.pllAufA]),
      (
        l10n.pllAufRGacTitle,
        [(PllRule.bookendsAdjacentTwice, _lights), (PllRule.bookendsOppositeTwice, _lights)],
        [l10n.pllAufR, l10n.pllAufGac],
      ),
      (l10n.pllAufFTitle, [(PllRule.bookends4, _bar3)], [l10n.pllAufF]),
    ];

    return _page(
      context,
      children: [
        Text(l10n.pllAufIntro),
        Column(
          crossAxisAlignment: .stretch,
          spacing: g.space.xs,
          children: [
            Text(l10n.pllGuideLetterTitle, style: context.theme.typography.title.lg),
            Text(l10n.pllGuideLetter),
            Text(l10n.pllGuideLetterU),
            Text(l10n.pllGuideLetterA),
          ],
        ),
        _columns(
          context,
          minWidth: 280,
          children: [
            for (final (title, aims, lines) in hints)
              MochiCard(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: .stretch,
                  spacing: 8,
                  children: [
                    Text(title, style: context.theme.typography.title.md),
                    for (final (rule, found) in aims) ..._aufRows(rule, found),
                    for (final line in lines) Text(line, style: context.theme.typography.body.sm),
                  ],
                ),
              ),
          ],
        ),
        Text(l10n.pllGuideCredit, style: _muted(context)),
      ],
    );
  }
}

/// The looks of [rule] that have what [found] looks for on one of the sides out of view and not the
/// other, one for each side, each with an arrow to that side and its stickers.
Iterable<Widget> _aufRows(PllRule rule, bool Function(List<int>) found) sync* {
  final looks = pllLooksOf(rule);
  for (final onLeft in [true, false]) {
    final example = looks.where((e) => found(onLeft ? e.left : e.back) && !found(onLeft ? e.back : e.left));
    if (example.isNotEmpty) yield _AufRow(example: example.first, onLeft: onLeft);
  }
}

/// A look, with an arrow to the side out of view that is to be looked at, and what is on it.
class _AufRow extends StatelessWidget {
  const _AufRow({required this.example, required this.onLeft});

  final PllExample example;
  final bool onLeft;

  @override
  Widget build(BuildContext context) {
    final hidden = Expanded(flex: 30, child: FlatStrip(stickers: onLeft ? example.left : example.back));
    final strip = Expanded(
      flex: 63,
      child: FlatStrip(stickers: example.strip, shown: example.shown, framed: example.framed),
    );
    final arrow = Icon(onLeft ? TablerIcons.arrowLeft : TablerIcons.arrowRight, size: 18);
    return Row(
      spacing: 4,
      children: [
        ...onLeft ? [hidden, arrow, strip] : [strip, arrow, hidden],
      ],
    );
  }
}

/// A word of the guide, with what it looks like.
class _Term extends StatelessWidget {
  const _Term({required this.title, required this.body, required this.strips});

  final String title;
  final String body;
  final List<List<int>> strips;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: .start,
      spacing: 12,
      children: [
        if (strips.isNotEmpty)
          SizedBox(
            width: 120,
            child: Column(spacing: 4, children: [for (final strip in strips) FlatStrip(stickers: strip)]),
          ),
        Expanded(
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Text(title, style: context.theme.typography.title.sm),
              Text(body),
            ],
          ),
        ),
      ],
    );
  }
}
