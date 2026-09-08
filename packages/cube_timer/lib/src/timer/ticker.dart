class Ticker {
  const Ticker();

  /// emit every 10ms, the number of milliseconds passed
  Stream<int> tick({Duration duration = const Duration(milliseconds: 10)}) {
    return Stream.periodic(duration, (x) => 10);
  }
}
