class Ticker {
  const Ticker();

  /// Emits the number of milliseconds elapsed since the stream was listened to.
  ///
  /// The value is read from a [Stopwatch] instead of counting ticks, so a late
  /// or dropped tick cannot make the reported time drift behind real time.
  Stream<int> tick({Duration interval = const Duration(milliseconds: 10)}) async* {
    final stopwatch = Stopwatch()..start();
    yield* Stream<int>.periodic(interval, (_) => stopwatch.elapsedMilliseconds);
  }
}
