import "dart:async";

import "package:cube_timer/cube_timer.dart";
import "package:flutter/foundation.dart" show kIsWeb;
import "package:flutter/widgets.dart";
import "package:flutter_bloc/flutter_bloc.dart";

import "stackmat_input.dart";

/// While [enabled], listens to a Stackmat on the audio input and sends its start and stop to the
/// timer. Off, or on the web where there is no input to listen to, it does nothing.
class StackmatBridge extends StatefulWidget {
  const StackmatBridge({super.key, required this.enabled, required this.child});

  final bool enabled;
  final Widget child;

  @override
  State<StackmatBridge> createState() => _StackmatBridgeState();
}

class _StackmatBridgeState extends State<StackmatBridge> {
  StackmatInput? _input;
  StreamSubscription<TimerEvent>? _subscription;

  @override
  void initState() {
    super.initState();
    if (widget.enabled) unawaited(_start());
  }

  @override
  void didUpdateWidget(StackmatBridge old) {
    super.didUpdateWidget(old);
    if (widget.enabled != old.enabled) {
      widget.enabled ? unawaited(_start()) : unawaited(_stop());
    }
  }

  @override
  void dispose() {
    unawaited(_stop());
    super.dispose();
  }

  Future<void> _start() async {
    if (kIsWeb || _input != null) return;
    final input = StackmatInput();
    _input = input;
    final bloc = context.read<TimerBloc>();
    try {
      final states = await input.start();
      // Switched off while the input was opening.
      if (states == null || _input != input) return;
      _subscription = states.timerEvents.listen(bloc.add);
    } catch (e) {
      // Without the recorder (or a permission) there is nothing to time with; the screen still works.
      debugPrint("stackmat: cannot listen: $e");
      await _stop();
    }
  }

  Future<void> _stop() async {
    final input = _input;
    _input = null;
    await _subscription?.cancel();
    _subscription = null;
    if (input != null) await input.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
