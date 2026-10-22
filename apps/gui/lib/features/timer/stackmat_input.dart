import "dart:async";
import "dart:typed_data";

import "package:cube_timer/cube_timer.dart";
import "package:record/record.dart";

/// A Stackmat on the audio input, as the packets it sends.
///
/// Listens on the default input, which is where the timer's cable goes: a phone's headset jack, or
/// a computer's microphone. The cleaning a recorder does for a voice is all turned off, as the gain
/// would follow every bit and the rest would smooth the square wave into something else.
class StackmatInput {
  static const _sampleRate = 44100;

  final _recorder = AudioRecorder();
  final _decoder = StackmatDecoder(sampleRate: _sampleRate.toDouble());

  /// Starts listening, and gives each packet that is read; null if there is no permission to.
  Future<Stream<StackmatState>?> start() async {
    if (!await _recorder.hasPermission()) return null;
    final bytes = await _recorder.startStream(
      const RecordConfig(
        encoder: AudioEncoder.pcm16bits,
        sampleRate: _sampleRate,
        numChannels: 1,
        autoGain: false,
        echoCancel: false,
        noiseSuppress: false,
      ),
    );
    final samples = Pcm16Samples();
    return bytes.expand((chunk) => _decoder.feed(samples.read(chunk)));
  }

  Future<void> stop() => _recorder.stop();

  Future<void> dispose() => _recorder.dispose();
}

/// 16 bit little endian PCM, as samples from -1 to 1.
///
/// A chunk from the recorder can end half way through a sample, so the odd byte is kept and
/// finishes the first sample of the next.
class Pcm16Samples {
  int? _carry;

  List<double> read(Uint8List chunk) {
    final bytes = _carry == null
        ? chunk
        : (Uint8List(chunk.length + 1)
            ..[0] = _carry!
            ..setAll(1, chunk));
    final whole = bytes.length & ~1;
    _carry = whole == bytes.length ? null : bytes.last;

    final data = ByteData.sublistView(bytes, 0, whole);
    return [for (var i = 0; i < whole; i += 2) data.getInt16(i, Endian.little) / 32768];
  }
}
