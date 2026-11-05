import "dart:math" as math;

import "package:cube_timer/cube_timer.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:mochi_cube/fto.dart" show ftoFaceNames, ftoFaceNormal, randomFtoScramble;
import "package:mochi_cube/nxn.dart";
import "package:mochi_ui/mochi_ui.dart";

import "../../database/dao_provider.dart";
import "../../l10n/l10n.dart";
import "../../shared/utils.dart";
import "../trainers/trainer_frame.dart";
import "cube_3d_painter.dart";
import "fto_3d_painter.dart";
import "notation.dart";
import "simulator_settings.dart";
import "stickering.dart";
import "sim_move.dart";
import "simulated_cube.dart";
import "simulated_fto.dart";

/// An NxN cube or the FTO to turn by typing moves, any the notation has: rotations, slices and wide turns, each
/// played out in turn, and the puzzle dragged round to look at. `/simulator` in the home shell, `/simulator-standalone`
/// pushed over it.
class SimulatorPage extends StatefulWidget {
  const SimulatorPage({super.key, required this.standalone});

  final bool standalone;

  @override
  State<SimulatorPage> createState() => _SimulatorPageState();
}

class _SimulatorPageState extends State<SimulatorPage> with SingleTickerProviderStateMixin {
  /// The cube's size, or [ftoPuzzle].
  var _size = 3;

  /// A [SimulatedCube] or a [SimulatedFto].
  late Object _puzzle = _fresh();

  /// What is turned first, to set the cube up: not played, and not counted by the slider.
  var _setup = <SimMove>[];

  /// The setup as last read without a mistake, which the moves follow: on the FTO it says how the puzzle is held
  /// for their names.
  var _setupText = "";

  /// The moves played from there.
  var _turns = <SimMove>[];

  /// How many of [_turns] [_puzzle] has had.
  var _index = 0;

  /// The turn being played out, which is [_turns]`[_index]` going forward or the undoing of the one before.
  SimMove? _turn;
  var _startQuarters = 0.0;
  var _backward = false;
  var _playing = false;

  /// Whether typing is ahead of the animation, so turns play faster until it catches up.
  var _catchingUp = false;

  /// The steps asked for while a turn was on, which play next and faster, by whether each goes back.
  final _queued = <bool>[];

  /// Where the moves are once the turn on and the steps queued are done.
  int get _landing =>
      _index +
      (_turn == null ? 0 : (_backward ? -1 : 1)) +
      _queued.fold(0, (n, backward) => n + (backward ? -1 : 1));

  /// Whether the play button started this run, which alone loops when [SettingsEntry.simulatorLoop] says to:
  /// moves played as they are typed do not.
  var _byPlay = false;
  var _showSettings = false;
  var _stickering = Stickering.full;

  /// The faces held on top and in front before the setup, U and F on either puzzle, as indices in
  /// [nxnFaceNames] or [ftoFaceNames]. The top one is also the last layer, for the stages of [_stickering].
  var _top = 0;
  var _front = 2;

  /// The rotation that holds the puzzle so, put unseen before the setup.
  String get _heldAs => _top == 0 && _front == 2
      ? ""
      : _size == ftoPuzzle
      ? "{${ftoFaceNames[_top]},${ftoFaceNames[_front]}}"
      : holdRotation(_top, _front);
  late final _animation = AnimationController(vsync: this)..addStatusListener(_onStatus);
  final _setupField = NotationController();
  final _moves = NotationController();
  String? _setupError;
  String? _error;

  // Looking down on U, F and R, as a cube is usually drawn.
  static const _defaultYaw = math.pi / 5;
  static const _defaultPitch = math.pi / 6;
  double _yaw = _defaultYaw;
  double _pitch = _defaultPitch;

  /// Where the view starts: the FTO straight on, its corner shared by U, F, L and R towards the eye.
  double get _homeYaw => _size == ftoPuzzle ? 0 : _defaultYaw;

  @override
  void dispose() {
    _animation.dispose();
    _setupField.dispose();
    _moves.dispose();
    super.dispose();
  }

  /// The stages there are to grey the puzzle out by: the 3x3x3's and the FTO's, none for the other cubes.
  List<Stickering> get _stages =>
      _size == 3 || _size == ftoPuzzle ? Stickering.of(fto: _size == ftoPuzzle) : const [Stickering.full];

  Object _fresh() => _size == ftoPuzzle ? SimulatedFto() : SimulatedCube(_size);

  void _apply(SimMove move) => switch ((_puzzle, move)) {
    (final SimulatedCube cube, final CubeMove move) => move.turns.forEach(cube.turn),
    (final SimulatedFto fto, _) => fto.turn(move),
    _ => throw StateError("$move is not a move of $_puzzle"),
  };

  /// The puzzle as it is after the setup and the first [k] turns, without playing them.
  void _jump(int k) {
    _animation.stop();
    _puzzle = _fresh();
    for (final t in [..._setup, ..._turns.take(k)]) {
      _apply(t);
    }
    _index = k;
    _turn = null;
    _startQuarters = 0;
    _catchingUp = false;
    _queued.clear();
  }

  String? _errorFor(String text, int size) => invalidTokens(text, size: size).isEmpty ? null : "";

  /// Reads the setup and the moves again, as they were last typed without a mistake.
  void _reread() {
    final (setup, turns) = readSimMoves(
      _size,
      _setupText,
      _error == null ? _moves.text : "",
      heldAs: _heldAs,
    );
    _setup = setup;
    if (_error == null) _turns = turns;
  }

  /// Holds the puzzle with [top] on top and [front] in front, straight away, leaving the moves where they were.
  void _hold(int top, int front) => setState(() {
    _top = top;
    _front = front;
    _playing = false;
    _reread();
    _jump(math.min(_index, _turns.length));
  });

  /// The faces that can be in front with [top] on top, and on the FTO whether each is held with a corner or an
  /// edge in front.
  List<(int, String?)> _frontsFor(int top) => _size == ftoPuzzle
      ? [
          for (var f = 0; f < 8; f++)
            if (_signsApart(top, f) case final apart when apart == 1 || apart == 2)
              (f, apart == 2 ? "CIF" : "EIF"),
        ]
      : [
          for (var f = 0; f < 6; f++)
            if (dot(faceNormals[f], faceNormals[top]) == 0) (f, null),
        ];

  /// How many of the FTO faces' signs differ: one for faces sharing an edge, two a corner, three opposite.
  int _signsApart(int a, int b) {
    final (x, y, z) = ftoFaceNormal[a];
    final (u, v, w) = ftoFaceNormal[b];
    return [x != u, y != v, z != w].where((d) => d).length;
  }

  void _setSize(int size) {
    setState(() {
      if ((size == ftoPuzzle) != (_size == ftoPuzzle)) {
        _yaw = size == ftoPuzzle ? 0 : _defaultYaw;
        _pitch = _defaultPitch;
        _top = 0;
        _front = 2;
      }
      _size = size;
      _setupField.size = size;
      _moves.size = size;
      if (!_stages.contains(_stickering)) _stickering = Stickering.full;
      _playing = false;
      _setupError = _errorFor(_setupField.text, size);
      _error = _errorFor(_moves.text, size);
      _setupText = _setupError == null ? _setupField.text : "";
      _turns = [];
      _reread();
      _jump(_turns.length);
    });
  }

  /// Replaces the moves with [text], showing where they end up rather than playing them.
  void _replace(String text) {
    _moves.text = text;
    _onChanged(text, animate: false);
  }

  /// The setup is [text]: the cube shows it done and the moves wait to be played from there.
  void _onSetupChanged(String text) {
    final error = _errorFor(text, _size);
    if (error != null) {
      setState(() => _setupError = error);
      return;
    }
    setState(() {
      _setupError = null;
      _setupText = text;
      // Read again with the moves, whose names on the FTO depend on how the setup holds it.
      _reread();
      _playing = false;
      _jump(0);
    });
  }

  void _onChanged(String text, {bool animate = true}) {
    final error = _errorFor(text, _size);
    if (error != null) {
      setState(() => _error = error);
      return;
    }
    final turns = readSimMoves(_size, _setupText, text, heldAs: _heldAs).$2;
    setState(() {
      _error = null;
      _queued.clear();
      final old = _turns;
      final typingAhead = animate && (_turn == null ? _index == old.length : !_backward);
      // Typing on at the end plays what was added; adding `2` or `'` to the last move turns it the rest of the way.
      final extended = typingAhead && turns.length > old.length && _sameStart(old, turns);
      final modifiedLast =
          typingAhead &&
          (_turn == null || _index == old.length - 1) &&
          turns.isNotEmpty &&
          turns.length == old.length &&
          _sameStart(old.sublist(0, old.length - 1), turns);
      _turns = turns;
      _byPlay = false;
      if (extended) {
        _playing = true;
        if (_turn != null) {
          _speedUpCurrent();
        } else {
          _next();
        }
      } else if (modifiedLast) {
        final prev = old.last;
        final next = turns.last;
        if (prev == next) {
          // Nothing it turns has changed.
        } else if (prev.sameLayers(next)) {
          if (_turn == null) {
            final delta = next.amount - prev.amount;
            if (delta != 0) {
              _index = turns.length - 1;
              _playing = false;
              _start(next.withAmount(delta), backward: false);
            }
          } else {
            final progress = Curves.easeInOut.transform(_animation.value);
            final current = _startQuarters + (_turn!.amount - _startQuarters) * progress;
            _playing = true;
            _start(next, backward: false, fromQuarters: current);
          }
        } else {
          _jump(turns.length - 1);
          _playing = true;
          _next();
        }
      } else {
        _playing = false;
        _jump(turns.length);
      }
    });
  }

  void _speedUpCurrent() {
    if (_catchingUp || !_animation.isAnimating) return;
    _catchingUp = true;
    final remaining = _animation.duration! * (1 - _animation.value) * 0.45;
    _animation.animateTo(1.0, duration: remaining);
  }

  bool _sameStart(List<SimMove> a, List<SimMove> b) {
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  /// Plays the next turn if it is wanted and none is on.
  void _next() {
    if (_turn != null) return;
    if (_playing && _byPlay && _index >= _turns.length && SettingsProvider.of(context).simulatorLoop) {
      _jump(0);
    }
    if (!_playing || _index >= _turns.length) {
      _playing = false;
      _catchingUp = false;
      return;
    }
    _catchingUp = !_byPlay && _index + 1 < _turns.length;
    _start(_turns[_index], backward: false);
  }

  void _start(SimMove turn, {required bool backward, double fromQuarters = 0}) {
    _turn = backward ? turn.withAmount(-turn.amount) : turn;
    _startQuarters = fromQuarters;
    _backward = backward;
    final span = (_turn!.amount - fromQuarters).abs();
    final pace = _catchingUp ? 280.0 : 615.0;
    final ms = pace * (1 + (span - 1).clamp(0, 10) * 0.5) / SettingsProvider.of(context).simulatorSpeed;
    _animation
      ..duration = Duration(milliseconds: ms.round())
      ..forward(from: 0);
  }

  void _onStatus(AnimationStatus status) {
    if (status != AnimationStatus.completed || _turn == null) return;
    setState(() {
      _apply(_turn!);
      _index += _backward ? -1 : 1;
      _turn = null;
      _startQuarters = 0;
      if (_queued.isEmpty) return _next();
      final backward = _queued.removeAt(0);
      _catchingUp = _queued.isNotEmpty;
      _start(backward ? _turns[_index - 1] : _turns[_index], backward: backward);
    });
  }

  void _togglePlay() => setState(() {
    if (_playing) {
      _playing = false;
      return;
    }
    if (_turns.isEmpty) return;
    if (_index >= _turns.length) _jump(0);
    _playing = true;
    _byPlay = true;
    _next();
  });

  /// Plays one step, or, while a turn is on, hurries it and plays the step after.
  void _step({required bool backward}) {
    if (backward ? _landing == 0 : _landing >= _turns.length) return;
    setState(() {
      _playing = false;
      if (_turn == null) return _start(backward ? _turns[_index - 1] : _turns[_index], backward: backward);
      _queued.add(backward);
      _speedUpCurrent();
    });
  }

  void _seek(int k) => setState(() {
    _playing = false;
    _jump(k);
  });

  void _reset() {
    _setupField.clear();
    _moves.clear();
    setState(() {
      _setup = [];
      _setupError = null;
      _setupText = "";
      _turns = [];
      _playing = false;
      _error = null;
      _jump(0);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final g = context.theme.geometry;
    final settings = SettingsProvider.of(context);
    final fto = _size == ftoPuzzle;
    final colors = fto
        // In ftoFaceNames order: U R F L B BL D BR.
        ? [
            settings.ftoColorU.toColor(),
            settings.ftoColorR.toColor(),
            settings.ftoColorF.toColor(),
            settings.ftoColorL.toColor(),
            settings.ftoColorB.toColor(),
            settings.ftoColorBL.toColor(),
            settings.ftoColorD.toColor(),
            settings.ftoColorBR.toColor(),
          ]
        // In nxnFaceNames order: U R F D L B.
        : [
            settings.cubeColorU.toColor(),
            settings.cubeColorR.toColor(),
            settings.cubeColorF.toColor(),
            settings.cubeColorD.toColor(),
            settings.cubeColorL.toColor(),
            settings.cubeColorB.toColor(),
          ];

    return TrainerFrame(
      title: l10n.simulatorTitle,
      standalone: widget.standalone,
      canPop: false,
      actions: [
        MochiAction(icon: TablerIcons.restore, label: l10n.simulatorReset, onPress: _reset),
        MochiAction(
          icon: TablerIcons.adjustmentsHorizontal,
          label: l10n.simulatorSettings,
          onPress: () => setState(() => _showSettings = !_showSettings),
        ),
      ],
      child: Padding(
        padding: g.pagePadding + .only(bottom: MediaQuery.paddingOf(context).bottom),
        child: Column(
          crossAxisAlignment: .stretch,
          spacing: g.space.md,
          children: [
            Expanded(
              // Beside the cube when there is room, under it otherwise: either way the cube stays in view while
              // the settings change it.
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final wide = constraints.maxWidth >= 720;
                  final panel = _showSettings
                      ? SizedBox(
                          width: wide ? 340 : null,
                          height: wide ? null : constraints.maxHeight * 0.55,
                          child: SingleChildScrollView(
                            child: SimulatorSettingsGroup(
                              settings: settings,
                              dao: context.read<AppDatabase>().settingsDao,
                              onResetView: () => setState(() {
                                _yaw = _homeYaw;
                                _pitch = _defaultPitch;
                              }),
                            ),
                          ),
                        )
                      : null;
                  final view = Expanded(
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: GestureDetector(
                            onPanUpdate: (details) => setState(() {
                              _yaw -= details.delta.dx * 0.01;
                              _pitch = (_pitch + details.delta.dy * 0.01).clamp(-math.pi / 2, math.pi / 2);
                            }),
                            child: AnimatedBuilder(
                              animation: _animation,
                              builder: (context, _) => CustomPaint(
                                size: Size.infinite,
                                painter: switch (_puzzle) {
                                  final SimulatedFto puzzle => Fto3dPainter(
                                    fto: puzzle,
                                    colors: colors,
                                    body: const Color(0xFF1A1A1A),
                                    yaw: _yaw,
                                    pitch: _pitch,
                                    move: _turn,
                                    progress: Curves.easeInOut.transform(_animation.value),
                                    startAmount: _startQuarters,
                                    hintDistance: settings.simulatorHintDistance,
                                    puzzleSize: settings.simulatorCubeSize,
                                    stickerless: settings.simulatorStickerless,
                                    hintLabels: settings.simulatorHintLabels,
                                    isLit: _stickering == Stickering.full
                                        ? null
                                        : (home) => _stickering.litFto(home, lastLayer: _top),
                                  ),
                                  final puzzle => Cube3dPainter(
                                    cube: puzzle as SimulatedCube,
                                    colors: colors,
                                    body: const Color(0xFF1A1A1A),
                                    yaw: _yaw,
                                    pitch: _pitch,
                                    move: _turn as CubeMove?,
                                    progress: Curves.easeInOut.transform(_animation.value),
                                    startQuarters: _startQuarters,
                                    hintDistance: settings.simulatorHintDistance,
                                    cubeSize: settings.simulatorCubeSize,
                                    stickerless: settings.simulatorStickerless,
                                    hintLabels: settings.simulatorHintLabels,
                                    isLit: _stickering == Stickering.full
                                        ? null
                                        : (home, face) => _stickering.lit(_size, home, face, lastLayer: _top),
                                  ),
                                },
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          left: 0,
                          width: 120,
                          child: Column(
                            crossAxisAlignment: .stretch,
                            spacing: g.space.xs,
                            children: [
                              MochiSelect<int>(
                                size: .sm,
                                value: _size,
                                onChanged: _setSize,
                                options: [
                                  for (var n = 2; n <= 7; n++) MochiSelectOption(value: n, label: "${n}x$n"),
                                  const MochiSelectOption(value: ftoPuzzle, label: "FTO"),
                                ],
                              ),
                              if (_stages.length > 1)
                                MochiSelect<Stickering>(
                                  size: .sm,
                                  value: _stickering,
                                  onChanged: (v) => setState(() => _stickering = v),
                                  options: [
                                    for (final v in _stages)
                                      MochiSelectOption(
                                        value: v,
                                        label: v == Stickering.full ? l10n.simulatorStickeringFull : v.label,
                                        group: v.group,
                                      ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                        // How the puzzle is held, which says the last layer too: the face on top.
                        Positioned(
                          top: 0,
                          right: 0,
                          width: 120,
                          child: Column(
                            crossAxisAlignment: .stretch,
                            spacing: g.space.xs,
                            children: [
                              MochiSelect<int>(
                                size: .sm,
                                value: _top,
                                onChanged: (top) {
                                  final fronts = [for (final (f, _) in _frontsFor(top)) f];
                                  _hold(top, fronts.contains(_front) ? _front : fronts.first);
                                },
                                options: [
                                  for (final (i, name) in (fto ? ftoFaceNames : nxnFaceNames).indexed)
                                    MochiSelectOption(value: i, label: l10n.simulatorTop(name)),
                                ],
                              ),
                              MochiSelect<int>(
                                size: .sm,
                                value: _front,
                                onChanged: (front) => _hold(_top, front),
                                options: [
                                  for (final (f, hold) in _frontsFor(_top))
                                    MochiSelectOption(
                                      value: f,
                                      label: l10n.simulatorFront(
                                        [(fto ? ftoFaceNames : nxnFaceNames)[f], ?hold].join(" · "),
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                  return Flex(
                    direction: wide ? Axis.horizontal : Axis.vertical,
                    crossAxisAlignment: .stretch,
                    spacing: g.space.md,
                    children: [view, ?panel],
                  );
                },
              ),
            ),
            AnimatedBuilder(
              animation: _animation,
              builder: (context, _) {
                final p = _turn == null ? 0.0 : (_backward ? -_animation.value : _animation.value);
                return MochiSlider(
                  value: (_index + p).clamp(0, math.max(_turns.length, 1)).toDouble(),
                  max: math.max(_turns.length, 1).toDouble(),
                  divisions: math.max(_turns.length, 1),
                  onChanged: _turns.isEmpty ? null : (v) => _seek(v.round()),
                );
              },
            ),
            Row(
              mainAxisAlignment: .spaceEvenly,
              children: [
                MochiButton.icon(
                  appearance: .ghost,
                  intent: .neutral,
                  icon: Icon(TablerIcons.playerSkipBack),
                  tooltip: l10n.simulatorToStart,
                  enabled: _index > 0,
                  onPress: () => _seek(0),
                ),
                MochiButton.icon(
                  appearance: .ghost,
                  intent: .neutral,
                  icon: Icon(TablerIcons.arrowBackUp),
                  tooltip: l10n.simulatorStepBack,
                  enabled: _landing > 0,
                  onPress: () => _step(backward: true),
                ),
                MochiButton.icon(
                  appearance: .ghost,
                  intent: .neutral,
                  icon: Icon(_playing ? TablerIcons.playerPause : TablerIcons.playerPlay),
                  tooltip: _playing ? l10n.simulatorPause : l10n.simulatorPlay,
                  enabled: _turns.isNotEmpty,
                  onPress: _togglePlay,
                ),
                MochiButton.icon(
                  appearance: .ghost,
                  intent: .neutral,
                  icon: Icon(TablerIcons.arrowForwardUp),
                  tooltip: l10n.simulatorStepForward,
                  enabled: _landing < _turns.length,
                  onPress: () => _step(backward: false),
                ),
                MochiButton.icon(
                  appearance: .ghost,
                  intent: .neutral,
                  icon: Icon(TablerIcons.playerSkipForward),
                  tooltip: l10n.simulatorToEnd,
                  enabled: _index < _turns.length,
                  onPress: () => _seek(_turns.length),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: .start,
              spacing: g.space.sm,
              children: [
                Expanded(
                  child: MochiTextField(
                    controller: _setupField,
                    hint: l10n.simulatorSetupHint,
                    error: _setupError,
                    onChanged: _onSetupChanged,
                  ),
                ),
                MochiButton.icon(
                  intent: .neutral,
                  icon: Icon(TablerIcons.dice),
                  tooltip: l10n.simulatorRandom,
                  onPress: () {
                    // Turned as held, the way the puzzle is picked up.
                    final text = fto
                        ? randomFtoScramble().toString()
                        : randomNxNScramble(_size, length: _size == 3 ? 20 : null).toString();
                    _setupField.text = text;
                    _onSetupChanged(text);
                  },
                ),
              ],
            ),
            Row(
              crossAxisAlignment: .start,
              spacing: g.space.sm,
              children: [
                Expanded(
                  child: MochiTextField(
                    controller: _moves,
                    hint: l10n.simulatorMovesHint,
                    error: _error,
                    onChanged: _onChanged,
                  ),
                ),
                MochiButton.icon(
                  intent: .neutral,
                  icon: Icon(TablerIcons.arrowsExchange),
                  tooltip: l10n.simulatorInverse,
                  enabled: _error == null && _turns.isNotEmpty,
                  onPress: () => _replace(invertNotation(_moves.text, size: _size)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
