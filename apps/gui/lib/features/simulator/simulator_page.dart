import "dart:math" as math;

import "package:cube_timer/cube_timer.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:mochi_cube/nxn.dart";
import "package:mochi_ui/mochi_ui.dart";

import "../../database/dao_provider.dart";
import "../../l10n/l10n.dart";
import "../../shared/utils.dart";
import "../trainers/trainer_frame.dart";
import "cube_3d_painter.dart";
import "notation.dart";
import "simulator_settings.dart";
import "stickering.dart";
import "simulated_cube.dart";

/// A 3x3 to turn by typing moves, any the notation has: rotations, slices and wide turns, each played out
/// in turn, and the cube dragged round to look at. `/simulator` in the home shell, `/simulator-standalone`
/// pushed over it.
class SimulatorPage extends StatefulWidget {
  const SimulatorPage({super.key, required this.standalone});

  final bool standalone;

  @override
  State<SimulatorPage> createState() => _SimulatorPageState();
}

class _SimulatorPageState extends State<SimulatorPage> with SingleTickerProviderStateMixin {
  static const _size = 3;

  var _cube = SimulatedCube(_size);

  /// What is turned first, to set the cube up: not played, and not counted by the slider.
  var _setup = <CubeLayerTurn>[];

  /// The moves played from there.
  var _turns = <CubeLayerTurn>[];

  /// How many of [_turns] [_cube] has had.
  var _index = 0;

  /// The turn being played out, which is [_turns]`[_index]` going forward or the undoing of the one before.
  CubeLayerTurn? _turn;
  var _backward = false;
  var _playing = false;

  /// Whether the play button started this run, which alone loops when [SettingsEntry.simulatorLoop] says to:
  /// moves played as they are typed do not.
  var _byPlay = false;
  var _showSettings = false;
  var _stickering = Stickering.full;

  /// The orientation picked and the rotation it put at the start of the setup.
  var _orientation = 0;
  var _heldAs = "";
  late final _animation = AnimationController(vsync: this)..addStatusListener(_onStatus);
  final _setupField = TextEditingController();
  final _moves = TextEditingController();
  String? _setupError;
  String? _error;

  // Looking down on U, F and R, as a cube is usually drawn.
  static const _defaultYaw = math.pi / 5;
  static const _defaultPitch = math.pi / 6;
  double _yaw = _defaultYaw;
  double _pitch = _defaultPitch;

  @override
  void dispose() {
    _animation.dispose();
    _setupField.dispose();
    _moves.dispose();
    super.dispose();
  }

  /// The cube as it is after the setup and the first [k] turns, without playing them.
  void _jump(int k) {
    _animation.stop();
    _cube = SimulatedCube(_size);
    for (final t in [..._setup, ..._turns.take(k)]) {
      _cube.turn(t);
    }
    _index = k;
    _turn = null;
  }

  /// Replaces the moves with [text], showing where they end up rather than playing them.
  void _replace(String text) {
    _moves.text = text;
    _onChanged(text, animate: false);
  }

  /// The setup is [text]: the cube shows it done and the moves wait to be played from there.
  void _onSetupChanged(String text) {
    final List<CubeLayerTurn> turns;
    try {
      turns = cubeLayerTurns(text, size: _size);
    } on FormatException catch (e) {
      setState(
        () => _setupError = context.l10n.simulatorInvalidMove(e.message.replaceFirst("Invalid move: ", "")),
      );
      return;
    }
    setState(() {
      _setupError = null;
      _setup = turns;
      _playing = false;
      _jump(0);
    });
  }

  void _onChanged(String text, {bool animate = true}) {
    final List<CubeLayerTurn> turns;
    try {
      turns = cubeLayerTurns(text, size: _size);
    } on FormatException catch (e) {
      setState(
        () => _error = context.l10n.simulatorInvalidMove(e.message.replaceFirst("Invalid move: ", "")),
      );
      return;
    }
    setState(() {
      _error = null;
      final old = _turns;
      // Typing on at the end plays what was added; any other edit shows where the moves end up.
      final extended =
          animate &&
          _index == old.length &&
          _turn == null &&
          turns.length > old.length &&
          _sameStart(old, turns);
      _turns = turns;
      _byPlay = false;
      if (extended) {
        _playing = true;
        _next();
      } else {
        _playing = false;
        _jump(turns.length);
      }
    });
  }

  bool _sameStart(List<CubeLayerTurn> a, List<CubeLayerTurn> b) {
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
      return;
    }
    _start(_turns[_index], backward: false);
  }

  void _start(CubeLayerTurn turn, {required bool backward}) {
    _turn = backward ? (face: turn.face, lo: turn.lo, hi: turn.hi, quarters: -turn.quarters) : turn;
    _backward = backward;
    // Quicker while playing on, so a whole scramble does not drag.
    final ms = 615 * (1 + (turn.quarters.abs() - 1) * 0.5) / SettingsProvider.of(context).simulatorSpeed;
    _animation
      ..duration = Duration(milliseconds: ms.round())
      ..forward(from: 0);
  }

  void _onStatus(AnimationStatus status) {
    if (status != AnimationStatus.completed || _turn == null) return;
    setState(() {
      _cube.turn(_turn!);
      _index += _backward ? -1 : 1;
      _turn = null;
      _next();
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

  void _step({required bool backward}) {
    if (_turn != null) return;
    if (backward ? _index == 0 : _index >= _turns.length) return;
    setState(() {
      _playing = false;
      _start(backward ? _turns[_index - 1] : _turns[_index], backward: backward);
    });
  }

  void _seek(int k) => setState(() {
    _playing = false;
    _jump(k);
  });

  void _reset() {
    _setupField.clear();
    _moves.clear();
    _heldAs = "";
    setState(() {
      _orientation = 0;
      _setup = [];
      _setupError = null;
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
    // In nxnFaceNames order: U R F D L B.
    final colors = [
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
                                _yaw = _defaultYaw;
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
                                painter: Cube3dPainter(
                                  cube: _cube,
                                  colors: colors,
                                  body: const Color(0xFF1A1A1A),
                                  yaw: _yaw,
                                  pitch: _pitch,
                                  turn: _turn,
                                  progress: Curves.easeInOut.transform(_animation.value),
                                  hintDistance: settings.simulatorHintDistance,
                                  cubeSize: settings.simulatorCubeSize,
                                  stickerless: settings.simulatorStickerless,
                                  hintLabels: settings.simulatorHintLabels,
                                  isLit: _stickering == Stickering.full
                                      ? null
                                      : (home, face) => _stickering.lit(_size, home, face),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          left: 0,
                          child: SizedBox(
                            width: 120,
                            child: MochiSelect<Stickering>(
                              size: .sm,
                              value: _stickering,
                              onChanged: (v) => setState(() => _stickering = v),
                              options: [
                                for (final v in Stickering.values)
                                  MochiSelectOption(
                                    value: v,
                                    label: v == Stickering.full ? l10n.simulatorStickeringFull : v.label,
                                  ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: SizedBox(
                            width: 150,
                            child: MochiSelect<int>(
                              size: .sm,
                              value: _orientation,
                              onChanged: (i) {
                                final text = withOrientation(
                                  _setupField.text,
                                  previous: _heldAs,
                                  rotation: orientations[i].rotation,
                                );
                                _orientation = i;
                                _heldAs = orientations[i].rotation;
                                _setupField.text = text;
                                _onSetupChanged(text);
                              },
                              options: [
                                for (final (i, o) in orientations.indexed)
                                  MochiSelectOption(
                                    value: i,
                                    label: l10n.simulatorOrientation(o.top, o.front),
                                  ),
                              ],
                            ),
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
                  enabled: _index > 0 && _turn == null,
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
                  enabled: _index < _turns.length && _turn == null,
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
                    // Held as it was, so the scramble is of the cube the way it is picked up.
                    final text = withOrientation(
                      randomNxNScramble(_size, length: 20).toString(),
                      previous: "",
                      rotation: _heldAs,
                    );
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
                  onPress: () => _replace(invertNotation(_moves.text)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
