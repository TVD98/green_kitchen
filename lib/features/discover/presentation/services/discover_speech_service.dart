import 'package:speech_to_text/speech_to_text.dart';

class DiscoverSpeechService {
  DiscoverSpeechService({SpeechToText? speech}) : _speech = speech ?? SpeechToText();

  final SpeechToText _speech;
  bool _initialized = false;

  Future<bool> initialize() async {
    if (_initialized) {
      return _speech.isAvailable;
    }
    _initialized = await _speech.initialize();
    return _initialized && _speech.isAvailable;
  }

  Future<bool> startListening({
    required void Function(String transcript) onResult,
    required void Function(Object error) onError,
  }) async {
    final ready = await initialize();
    if (!ready) {
      onError(StateError('speech_unavailable'));
      return false;
    }
    if (_speech.isListening) {
      await _speech.stop();
    }
    try {
      await _speech.listen(
        onResult: (result) {
          if (result.recognizedWords.isNotEmpty) {
            onResult(result.recognizedWords);
          }
        },
        listenOptions: SpeechListenOptions(
          listenMode: ListenMode.confirmation,
          cancelOnError: true,
        ),
      );
      return true;
    } catch (error) {
      onError(error);
      return false;
    }
  }

  Future<void> stopListening() => _speech.stop();

  bool get isListening => _speech.isListening;
}
