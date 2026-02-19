import 'dart:io' show Platform;
import '../shims/speech_to_text.dart' as stt;

class SpeechService {
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool available = false;
  double currentSoundLevel = 0.0;

  Future<bool> init() async {
    available = await _speech.initialize(onStatus: (status) {}, onError: (error) {});
    return available;
  }

  void startListening({required void Function(String) onResult, bool listenForSoundLevel = true}) async {
    if (!available) await init();

    _speech.listen(onResult: (result) {
      onResult(result.recognizedWords);
    }, listenForSoundLevel: listenForSoundLevel, onSoundLevelChange: (level) {
      currentSoundLevel = level;
    });
  }

  /// Start listening with an explicit locale id (e.g. 'en_US', 'es_ES').
  /// Callback provides recognized words and the latest sound level.
  void startListeningMultilingual({required void Function(String, double) onResult, String? localeId, bool listenForSoundLevel = true}) async {
    if (!available) await init();
    // prefer the provided localeId or fall back to system locale
    final preferred = localeId ?? Platform.localeName;
    // use shim's listenWithLocale if available
    try {
      _speech.listenWithLocale(onResult: (result) {
        onResult(result.recognizedWords, _speech.currentSoundLevel);
      }, localeId: preferred, listenForSoundLevel: listenForSoundLevel, onSoundLevelChange: (level) {
        currentSoundLevel = level;
      });
    } catch (_) {
      // fallback to basic listen
      _speech.listen(onResult: (result) {
        onResult(result.recognizedWords, _speech.currentSoundLevel);
      }, listenForSoundLevel: listenForSoundLevel, onSoundLevelChange: (level) {
        currentSoundLevel = level;
      });
    }
  }

  void stop() {
    _speech.stop();
  }

  bool get isListening => _speech.isListening;

  /// Return a reasonable preferred locale id for STT.
  String getPreferredLocale() {
    return Platform.localeName;
  }
}
