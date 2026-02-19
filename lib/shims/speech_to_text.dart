// Minimal shim for `speech_to_text` package to satisfy analysis when the
// real package isn't available. This provides the small API used by the
// prototype and is a no-op implementation.

class SpeechRecognitionResult {
  final String recognizedWords;
  SpeechRecognitionResult(this.recognizedWords);
}

class SpeechToText {
  bool _isListening = false;
  double currentSoundLevel = 0.0;

  Future<bool> initialize({void Function(String)? onStatus, void Function(dynamic)? onError}) async {
    return true;
  }

  void listen({required void Function(SpeechRecognitionResult) onResult, bool listenForSoundLevel = true, void Function(double)? onSoundLevelChange, void Function(String)? onStatus, void Function(dynamic)? onError}) {
    _isListening = true;
    // no-op: this shim does not perform real speech recognition
  }

  /// Shim supports optional locale id parameter used by real package.
  void listenWithLocale({required void Function(SpeechRecognitionResult) onResult, String? localeId, bool listenForSoundLevel = true, void Function(double)? onSoundLevelChange, void Function(String)? onStatus, void Function(dynamic)? onError}) {
    _isListening = true;
    // no-op
  }

  void stop() {
    _isListening = false;
  }

  bool get isListening => _isListening;
}
