import "dart:io";
import "dart:math";
import "dart:typed_data";

import "package:cube_timer/cube_timer.dart";
import "package:test/test.dart";

/// The recorded session, as its sample rate and samples in -1 to 1.
({int sampleRate, List<double> samples}) readWav(String path) {
  final bytes = File(path).readAsBytesSync();
  final data = ByteData.sublistView(bytes);
  var sampleRate = 0;
  var offset = 12;
  while (offset + 8 <= bytes.length) {
    final id = String.fromCharCodes(bytes.sublist(offset, offset + 4));
    final size = data.getUint32(offset + 4, Endian.little);
    final body = offset + 8;
    if (id == "fmt ") sampleRate = data.getUint32(body + 4, Endian.little);
    if (id == "data") {
      return (
        sampleRate: sampleRate,
        samples: [for (var i = 0; i + 1 < size; i += 2) data.getInt16(body + i, Endian.little) / 32768],
      );
    }
    offset = body + size + (size.isOdd ? 1 : 0);
  }
  throw const FormatException("no data chunk");
}

/// A packet as the timer sends it: its head, its digits, the checksum and the line end.
String packet(String head, String digits) {
  var sum = 64;
  for (final c in digits.codeUnits) {
    sum += c - 0x30;
  }
  return "$head$digits${String.fromCharCode(sum)}\r\n";
}

/// The sound a timer makes sending [packets]: each byte framed by a start and a stop bit at 1200
/// bits a second, the line high while idle.
List<double> encode(List<String> packets, {required int sampleRate, double noise = 0, int seed = 1}) {
  // Low for a moment so the decoder finds its level, then idle high before the first packet.
  final bits = [...List.filled(30, 0), ...List.filled(30, 1)];
  for (final p in packets) {
    for (final c in p.codeUnits) {
      bits.add(0);
      for (var i = 0; i < 8; i++) {
        bits.add((c >> i) & 1);
      }
      bits.add(1);
    }
    bits.addAll(List.filled(12, 1));
  }
  bits.addAll(List.filled(30, 1));

  final random = Random(seed);
  final perBit = sampleRate / 1200;
  final samples = <double>[];
  for (var k = 0; k < bits.length; k++) {
    final length = ((k + 1) * perBit).round() - (k * perBit).round();
    for (var i = 0; i < length; i++) {
      final jitter = noise == 0 ? 0.0 : (random.nextDouble() * 2 - 1) * noise;
      samples.add((bits[k] == 1 ? 1.0 : -1.0) + jitter);
    }
  }
  return samples;
}

List<StackmatState> decodeSynthetic(List<String> packets, {int sampleRate = 8000, double noise = 0}) =>
    StackmatDecoder(sampleRate: sampleRate.toDouble())
        .feed(encode(packets, sampleRate: sampleRate, noise: noise));

void main() {
  test("the recorded session ends stopped at 1.727 s, after a run", () {
    final wav = readWav("test/fixtures/stackmat.wav");
    final states = StackmatDecoder(sampleRate: wav.sampleRate.toDouble()).feed(wav.samples);

    expect(states.any((s) => s.running), isTrue);
    expect(states.last.elapsed, const Duration(milliseconds: 1727));
    expect(states.last.running, isFalse);
  });

  test("a ten character packet is read to the millisecond, even with some noise", () {
    for (final noise in [0.0, 0.1]) {
      final states = decodeSynthetic([packet(" ", "012345")], noise: noise);

      expect(states, hasLength(1), reason: "noise $noise");
      expect(states.single.elapsed, const Duration(seconds: 12, milliseconds: 345));
    }
  });

  test("a nine character packet counts hundredths", () {
    final states = decodeSynthetic([packet(" ", "01234")]);

    expect(states.single.elapsed, const Duration(seconds: 12, milliseconds: 340));
  });

  test("a packet with the wrong checksum is dropped", () {
    final bad = "${packet(" ", "012345").substring(0, 7)}Z\r\n";

    expect(decodeSynthetic([bad]), isEmpty);
  });

  test("a time that goes on is running, and one that stops is not", () {
    final states = decodeSynthetic([packet(" ", "001000"), packet(" ", "002000"), packet("S", "002000")]);

    expect(states.map((s) => s.running).toList(), [true, true, false]);
    expect(states.map((s) => s.head).toList(), [" ", " ", "S"]);
  });

  test("the same packets decode at 48 kHz", () {
    final samples = encode([packet(" ", "012345")], sampleRate: 48000);
    final states = StackmatDecoder(sampleRate: 48000).feed(samples);

    expect(states.single.elapsed, const Duration(seconds: 12, milliseconds: 345));
  });
}
