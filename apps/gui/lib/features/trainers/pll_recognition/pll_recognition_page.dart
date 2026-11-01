import "dart:math";

import "package:mochi_ui/mochi_ui.dart";

import "../../../l10n/l10n.dart";
import "../../algorithms/algorithm_data/common.dart";
import "../../algorithms/algorithm_data/pll.dart";
import "../trainer_frame.dart";
import "pll_guide.dart";
import "pll_labels.dart";
import "pll_rules.dart";
import "pll_view.dart";
import "two_side_painter.dart";

/// Two-sided PLL recognition: how it is done, and a case as seen from the front and right sides
/// alone, to say which of the 21 it is.
class PllRecognitionPage extends StatefulWidget {
  const PllRecognitionPage({super.key, required this.standalone});

  final bool standalone;

  @override
  State<PllRecognitionPage> createState() => _PllRecognitionPageState();
}

class _PllRecognitionPageState extends State<PllRecognitionPage> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final g = context.theme.geometry;

    return TrainerFrame(
      title: l10n.trainerPllRecognitionTitle,
      standalone: widget.standalone,
      actions: [
        MochiAction(
          icon: TablerIcons.infoCircle,
          label: l10n.trainerTermsInfo,
          showLabel: true,
          onPress: () => showPllTerms(context),
        ),
      ],
      child: Column(
        crossAxisAlignment: .stretch,
        children: [
          Padding(
            padding: .symmetric(horizontal: g.pagePadding.horizontal / 2),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: MochiSegmentedControl<int>(
                  value: _tab,
                  onChanged: (tab) => setState(() => _tab = tab),
                  children: [
                    MochiSegment(value: 0, label: Text(l10n.trainerTabRules)),
                    MochiSegment(value: 1, label: Text(l10n.trainerTabAuf)),
                    MochiSegment(value: 2, label: Text(l10n.trainerTabPractice)),
                  ],
                ),
              ),
            ),
          ),
          // Both stay alive, so the score is not lost on a look at the guide.
          Expanded(
            child: IndexedStack(index: _tab, children: const [PllRulesTab(), PllAufTab(), _Practice()]),
          ),
        ],
      ),
    );
  }
}

typedef _Question = ({AlgorithmCase answer, List<int> stickers, PllRule rule});

class _Practice extends StatefulWidget {
  const _Practice();

  @override
  State<_Practice> createState() => _PracticeState();
}

class _PracticeState extends State<_Practice> {
  final _random = Random();
  late _Question _question = _next();
  int _correct = 0;
  int _wrongCount = 0;

  /// The wrong case that was picked: the answer stays up until the next question is asked for.
  AlgorithmCase? _wrong;

  _Question _next() {
    final answer = pllCases[_random.nextInt(pllCases.length)];
    final stickers = pllTwoSide(
      answer.algorithms.first,
      preAuf: _random.nextInt(4),
      auf: _random.nextInt(4),
      rotation: _random.nextInt(4),
    );
    return (answer: answer, stickers: stickers, rule: recognizePll(stickers)!.rule);
  }

  void _pick(AlgorithmCase picked) {
    if (_wrong != null) return;
    setState(() {
      if (picked.id == _question.answer.id) {
        _correct++;
        _question = _next();
      } else {
        _wrongCount++;
        _wrong = picked;
      }
    });
  }

  void _skip() => setState(() {
    _wrong = null;
    _question = _next();
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final g = context.theme.geometry;
    final colors = context.colors;
    final wrong = _wrong;

    final groups = <String, List<AlgorithmCase>>{};
    for (final c in pllCases) {
      (groups[c.group] ??= []).add(c);
    }

    final score = context.theme.typography.title.lg;

    // The question is at the top and the answers at the bottom, so they do not move when the answer is
    // shown between them: the page does not scroll, and the answer does, if it is too long for the room.
    return Padding(
      padding: g.pagePadding + .only(bottom: MediaQuery.paddingOf(context).bottom),
      child: Column(
        crossAxisAlignment: .stretch,
        spacing: g.space.lg,
        children: [
          // Right on the left, wrong on the right.
          Row(
            mainAxisAlignment: .center,
            spacing: g.space.xs,
            children: [
              Text("$_correct", style: score.copyWith(color: context.theme.colors.success.base)),
              Text("/", style: score.copyWith(color: colors.mutedForeground)),
              Text("$_wrongCount", style: score.copyWith(color: context.theme.colors.danger.base)),
            ],
          ),
          // As large as it may be, and smaller on a screen that is too short for it.
          Flexible(
            flex: 3,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 360),
                child: AspectRatio(
                  aspectRatio: twoSideAspectRatio,
                  child: TwoSideDiagram(stickers: _question.stickers),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: SingleChildScrollView(
              child: wrong == null
                  ? null
                  : Column(
                      spacing: g.space.xs,
                      children: [
                        Text(
                          l10n.trainerAnswerWas(_question.answer.name),
                          textAlign: .center,
                          style: context.theme.typography.title.lg,
                        ),
                        Text(
                          l10n.trainerPattern(
                            pllGroupTitle(l10n, _question.rule.group),
                            pllRuleLabel(l10n, _question.rule),
                          ),
                          textAlign: .center,
                          style: context.theme.typography.title.sm.copyWith(color: colors.mutedForeground),
                        ),
                        MochiButton(onPress: _skip, child: Text(l10n.trainerNext)),
                      ],
                    ),
            ),
          ),
          for (final MapEntry(key: group, value: cases) in groups.entries)
            Column(
              crossAxisAlignment: .start,
              spacing: g.space.xs,
              children: [
                Text(group, style: context.theme.typography.title.sm.copyWith(color: colors.mutedForeground)),
                Wrap(
                  spacing: g.space.xs,
                  runSpacing: g.space.xs,
                  children: [
                    for (final c in cases)
                      MochiButton(
                        appearance: .soft,
                        intent: wrong == null
                            ? .neutral
                            : c.id == _question.answer.id
                            ? .success
                            : c.id == wrong.id
                            ? .danger
                            : .neutral,
                        onPress: () => _pick(c),
                        child: Text(c.name),
                      ),
                  ],
                ),
              ],
            ),
        ],
      ),
    );
  }
}
