import "dart:collection";
import "dart:math";

/// What a Stackmat said in one packet.
final class StackmatState {
  const StackmatState({required this.elapsed, required this.head, required this.running});

  /// The time on the timer's display.
  final Duration elapsed;

  /// The packet's first character: ` ` while running, `S` stopped, `I` idle, `L`, `R` or `C` for a
  /// hand on the timer, and `A` for both hands with the green light.
  final String head;

  /// Whether the timer is counting, decided from this packet and the one before it.
  final bool running;

  bool get greenLight => head == "A";
  bool get leftHand => head == "L" || head == "A" || head == "C";
  bool get rightHand => head == "R" || head == "A" || head == "C";

  @override
  String toString() => "StackmatState($head, ${elapsed.inMilliseconds} ms, running: $running)";
}

/// Reads a Stackmat's sound and gives the packets in it, as csTimer's decoder does.
///
/// Feed it the audio in order, as samples between -1 and 1 at [sampleRate]. The level is followed
/// sample by sample after an automatic gain, which evens out how loud the cable is. Each run of one
/// level is counted in bits at 1200 a second, and bytes are framed by their start and stop bits. A
/// packet is nine or ten characters, and is given only if its checksum is right.
final class StackmatDecoder {
  StackmatDecoder({required double sampleRate})
    : _samplesPerBit = sampleRate / 1200,
      _gainRate = 0.001 / (sampleRate / 1200),
      _recent = ListQueue.of(List.filled((sampleRate / 1200 / 6).ceil(), 0.0));

  final double _samplesPerBit;
  final double _gainRate;

  /// The last few samples, so an edge is seen as a change over a short stretch rather than one sample.
  final ListQueue<double> _recent;
  double _power = 1;
  int _level = 0;
  double _sinceEdge = 0;

  final _bits = <int>[];
  final _chars = <String>[];
  int _idle = 0;
  int _lastBit = 0;
  int _lastBitLength = 0;

  String _previousHead = "I";
  int _previousMs = 0;
  int _previousUnit = 10;

  /// The packets completed by [samples], in order.
  List<StackmatState> feed(Iterable<double> samples) {
    final out = <StackmatState>[];
    for (final sample in samples) {
      _power = max(0.0001, _power + (sample * sample - _power) * _gainRate);
      _signal(sample / sqrt(_power), out);
    }
    return out;
  }

  void _signal(double x, List<StackmatState> out) {
    _recent.addFirst(x);
    final old = _recent.removeLast();
    final sign = _level == 1 ? 1 : -1;
    final edge = (old - x) * sign > 0.7 && (x - sign).abs() - 1 > 0.2 && _sinceEdge > _samplesPerBit * 0.6;

    if (edge) {
      final bits = (_sinceEdge / _samplesPerBit).round();
      for (var i = 0; i < bits; i++) {
        _bit(_level, out);
      }
      _level ^= 1;
      _sinceEdge = 0;
    } else if (_sinceEdge > _samplesPerBit * 2) {
      _bit(_level, out);
      _sinceEdge -= _samplesPerBit;
    }
    _sinceEdge++;
  }

  void _bit(int bit, List<StackmatState> out) {
    _bits.add(bit);
    if (bit != _lastBit) {
      _lastBit = bit;
      _lastBitLength = 1;
    } else {
      _lastBitLength++;
    }

    if (_lastBitLength > 10) {
      // A long run is the line idling, which ends whatever packet was being read.
      _idle = bit;
      _bits.clear();
      _chars.clear();
    } else if (_bits.length == 10) {
      if (_bits.first == _idle || _bits.last != _idle) {
        _bits.removeAt(0);
      } else {
        var value = 0;
        for (var i = 8; i > 0; i--) {
          value = (value << 1) | (_bits[i] == _idle ? 1 : 0);
        }
        _bits.clear();
        _chars.add(String.fromCharCode(value));
        _decode(_chars, out);
      }
    }
  }

  void _decode(List<String> chars, List<StackmatState> out) {
    final n = chars.length;
    if (n != 9 && n != 10) return;
    if (!" SILRCA".contains(chars[0])) return;

    var checksum = 64;
    for (var i = 1; i < n - 3; i++) {
      final c = chars[i].codeUnitAt(0);
      if (c < 0x30 || c > 0x39) return;
      checksum += c - 0x30;
    }
    if (checksum != chars[n - 3].codeUnitAt(0)) return;

    // A nine character packet counts hundredths, so its last digit is a zero of milliseconds.
    final ms =
        int.parse(chars[1]) * 60000 +
        int.parse(chars[2] + chars[3]) * 1000 +
        int.parse(chars[4] + chars[5] + (n == 10 ? chars[6] : "0"));
    _push(chars[0], ms, n == 9 ? 10 : 1, out);
  }

  void _push(String head, int ms, int unit, List<StackmatState> out) {
    final incremented = unit == _previousUnit ? ms > _previousMs : ms ~/ 10 > _previousMs ~/ 10;
    final running = (head != "S" || _previousHead == "S") && (head == " " || incremented);
    _previousHead = head;
    _previousMs = ms;
    _previousUnit = unit;
    out.add(
      StackmatState(
        elapsed: Duration(milliseconds: ms),
        head: head,
        running: running,
      ),
    );
  }
}
