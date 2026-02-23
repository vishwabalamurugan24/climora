import 'dart:async';
import 'package:flutter/foundation.dart';

class AssistantService {
  static final AssistantService _instance = AssistantService._internal();
  factory AssistantService() => _instance;
  AssistantService._internal();

  final _statusController = StreamController<AssistantStatus>.broadcast();
  Stream<AssistantStatus> get statusStream => _statusController.stream;

  final _commandController = StreamController<String>.broadcast();
  Stream<String> get commandStream => _commandController.stream;

  AssistantStatus _currentStatus = AssistantStatus.idle;
  AssistantStatus get currentStatus => _currentStatus;

  bool _isListening = false;

  void startListening() {
    if (_isListening) return;
    _isListening = true;
    _setStatus(AssistantStatus.idle);

    // Simulate background listening for wake word
    // In a real app, this would use a speech-to-text package with wake-word support
    debugPrint("AI Assistant is now listening for 'Hey Climora'...");
  }

  void stopListening() {
    _isListening = false;
    _setStatus(AssistantStatus.idle);
  }

  // Simulate wake word detection
  void simulateWakeWord() {
    if (!_isListening) return;
    _setStatus(AssistantStatus.listening);
    debugPrint("Wake word detected! Listening for command...");

    // Simulate command processing after 3 seconds
    Timer(const Duration(seconds: 3), () {
      if (_currentStatus == AssistantStatus.listening) {
        // Mock command
        final mockCommands = [
          "Play some happy music",
          "I'm feeling sad",
          "Play rain sounds",
          "Find a calm playlist",
        ];
        final command =
            mockCommands[DateTime.now().second % mockCommands.length];
        processCommand(command);
      }
    });
  }

  void processCommand(String command) {
    _commandController.add(command);
    _setStatus(AssistantStatus.processing);
    debugPrint("Processing command: $command");

    final String lowerCommand = command.toLowerCase();

    // Multilingual Keyword Mapping
    String mood = "calm";

    // Happy Keywords (English, Spanish, French, German, Hindi)
    if (_matches(lowerCommand, [
      "happy",
      "feliz",
      "heureux",
      "glücklich",
      "khush",
    ])) {
      mood = "happy";
    }
    // Calm Keywords
    else if (_matches(lowerCommand, [
      "calm",
      "tranquilo",
      "calme",
      "ruhig",
      "shant",
    ])) {
      mood = "calm";
    }
    // Sad Keywords
    else if (_matches(lowerCommand, ["sad", "triste", "traurig", "dukh"])) {
      mood = "sad";
    }
    // Focus Keywords
    else if (_matches(lowerCommand, [
      "focus",
      "enfoque",
      "concentration",
      "fokus",
      "dhyan",
    ])) {
      mood = "focus";
    }
    // Rain Keywords
    else if (_matches(lowerCommand, [
      "rain",
      "lluvia",
      "pluie",
      "regen",
      "baarish",
    ])) {
      mood = "rain";
    }

    Timer(const Duration(seconds: 2), () {
      _setStatus(AssistantStatus.responding);
      debugPrint("Responding to mood: $mood");

      Timer(const Duration(seconds: 2), () {
        _setStatus(AssistantStatus.idle);
      });
    });
  }

  bool _matches(String command, List<String> keywords) {
    for (var word in keywords) {
      if (command.contains(word)) return true;
    }
    return false;
  }

  void _setStatus(AssistantStatus status) {
    _currentStatus = status;
    _statusController.add(status);
  }

  void dispose() {
    _statusController.close();
    _commandController.close();
  }
}

enum AssistantStatus { idle, listening, processing, responding }
