import "dart:async";

import "package:cube_timer/cube_timer.dart";
import "package:drift/native.dart";
import "package:test/test.dart";

/// A ticker that counts only when told to.
class _ManualTicker extends Ticker {
  final _controller = StreamController<int>.broadcast();

  void at(int ms) => _controller.add(ms);

  @override
  Stream<int> tick({Duration interval = const Duration(milliseconds: 10)}) => _controller.stream;
}

void main() {
  late AppDatabase db;
  late _ManualTicker ticker;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    ticker = _ManualTicker();
  });
  tearDown(() => db.close());

  Future<TimerBloc> bloc({required bool inspection}) async {
    final bloc = TimerBloc(
      ticker: ticker,
      config: Stream.value(TimerConfig(inspectionEnabled: inspection)),
      recordsDao: db.recordsDao,
    );
    await pumpEventQueue();
    return bloc;
  }

  Future<TimerState> after(TimerBloc bloc, List<TimerEvent> events) async {
    for (final event in events) {
      bloc.add(event);
      await pumpEventQueue();
    }
    return bloc.state;
  }

  group("with a Stackmat", () {
    test("the screen starts and stops a solve as ever, and the timer's packets do not touch it", () async {
      final b = await bloc(inspection: false);

      await after(b, const [TimerPressed()]);
      await Future<void>.delayed(const TimerConfig().holdDuration * 2);
      expect(await after(b, const [TimerReleased()]), isA<TimerRunInProgress>());

      // The Stackmat idling, or reporting a run of its own, neither starts nor ends this one.
      expect(await after(b, const [TimerStackmatStarted()]), isA<TimerRunInProgress>());
      expect(await after(b, const [TimerStackmatStopped(9999)]), isA<TimerRunInProgress>());

      final done = await after(b, const [TimerPressed()]);
      expect(done, isA<TimerRunComplete>().having((s) => s.elapsed, "elapsed", isNot(9999)));
      await b.close();
    });

    test("a solve the timer started is its own to stop, at the time it shows", () async {
      final b = await bloc(inspection: false);

      expect(await after(b, const [TimerStackmatStarted()]), const TimerRunInProgress(0));

      // A hand on the screen does not end it.
      expect(await after(b, const [TimerPressed(), TimerReleased()]), isA<TimerRunInProgress>());

      ticker.at(1300);
      await pumpEventQueue();
      final done = await after(b, const [TimerStackmatStopped(1362)]);
      expect(done, isA<TimerRunComplete>().having((s) => s.elapsed, "elapsed", 1362));
      await b.close();
    });

    test("a tap opens inspection, which the timer starting ends, with its penalty", () async {
      final b = await bloc(inspection: true);

      expect(await after(b, const [TimerPressed(), TimerReleased()]), isA<TimerRunInInspection>());
      ticker.at(16000); // a second over the fifteen
      await pumpEventQueue();

      expect(await after(b, const [TimerStackmatStarted()]), const TimerRunInProgress(0, penalty: .plus2));
      await b.close();
    });

    test("the screen can start the solve from inspection too, and then ends it", () async {
      final b = await bloc(inspection: true);
      await after(b, const [TimerPressed(), TimerReleased()]);

      await after(b, const [TimerPressed()]);
      await Future<void>.delayed(const TimerConfig().holdDuration * 2);
      expect(await after(b, const [TimerReleased()]), isA<TimerRunInProgress>());

      expect(await after(b, const [TimerPressed()]), isA<TimerRunComplete>());
      await b.close();
    });

    test("starting the timer without a tap skips inspection even when it is on", () async {
      final b = await bloc(inspection: true);

      expect(await after(b, const [TimerStackmatStarted()]), const TimerRunInProgress(0));
      await b.close();
    });
  });

  test("the timer's packets become one start and one stop, at the time it showed", () async {
    StackmatState packet(String head, int ms, {required bool running}) => StackmatState(
      elapsed: Duration(milliseconds: ms),
      head: head,
      running: running,
    );

    final events = await Stream.fromIterable([
      packet("I", 0, running: false),
      packet(" ", 17, running: true),
      packet(" ", 128, running: true),
      packet("I", 1362, running: true),
      packet("I", 1362, running: false),
      packet("I", 0, running: false),
    ]).timerEvents.toList();

    expect(events, hasLength(2));
    expect(events.first, isA<TimerStackmatStarted>());
    expect(events.last, isA<TimerStackmatStopped>().having((e) => e.elapsed, "elapsed", 1362));
  });
}
