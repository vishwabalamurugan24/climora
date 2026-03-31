'''import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AssistantService {
  static final AssistantService _instance = AssistantService._internal();
  factory AssistantService() => _instance;
  AssistantService._internal();

  final _statusController = StreamController<AssistantStatus>.broadcast();
  Stream<AssistantStatus> get statusStream => _statusController.stream;

  final _commandController = StreamController<String>.broadcast();
  Stream<String> get commandStream => _commandController.stream;

  final _aiResponseController = StreamController<String>.broadcast();
  Stream<String> get aiResponseStream => _aiResponseController.stream;

  AssistantStatus _currentStatus = AssistantStatus.idle;
  AssistantStatus get currentStatus => _currentStatus;

  bool _isListening = false;
  bool _isAiMode = false;

  void startListening() {
    if (_isListening) return;
    _isListening = true;
    _setStatus(AssistantStatus.idle);
    debugPrint("AI Assistant is now listening for 'Hey Climora'...");
  }

  void stopListening() {
    _isListening = false;
    _setStatus(AssistantStatus.idle);
  }

  void simulateWakeWord() {
    if (!_isListening) return;
    _setStatus(AssistantStatus.listening);
    debugPrint("Wake word detected! Listening for command...");

    // Simulate command processing after 3 seconds
    Timer(const Duration(seconds: 3), () {
      if (_currentStatus == AssistantStatus.listening) {
        final mockCommands = [
          "Play some happy music",
          "I'm feeling sad",
          "Ask the AI what is the capital of France",
          "Play rain sounds",
          "Find a calm playlist",
        ];
        final command =
            mockCommands[DateTime.now().second % mockCommands.length];
        processCommand(command);
      }
    });
  }

  Future<void> processCommand(String command) async {
    if (_isAiMode) {
      _askAi(command);
      return;
    }

    _commandController.add(command);
    _setStatus(AssistantStatus.processing);
    debugPrint("Processing command: $command");

    final String lowerCommand = command.toLowerCase();

    if (_matches(lowerCommand, ["ask ai", "ask the ai"])) {
      _isAiMode = true;
      final query = lowerCommand.replaceFirst("ask ai", "").replaceFirst("ask the ai", "").trim();
      if (query.isNotEmpty) {
        _askAi(query);
      } else {
        _setStatus(AssistantStatus.ai_listening);
      }
      return;
    }

    // Multilingual Keyword Mapping
    String mood = "calm";

    // Happy Keywords
    if (_matches(lowerCommand, ["happy", "feliz", "heureux", "glücklich", "khush"])) {
      mood = "happy";
    }
    // Calm Keywords
    else if (_matches(lowerCommand, ["calm", "tranquilo", "calme", "ruhig", "shant"])) {
      mood = "calm";
    }
    // Sad Keywords
    else if (_matches(lowerCommand, ["sad", "triste", "traurig", "dukh"])) {
      mood = "sad";
    }
    // Focus Keywords
    else if (_matches(lowerCommand, ["focus", "enfoque", "concentration", "fokus", "dhyan"])) {
      mood = "focus";
    }
    // Rain Keywords
    else if (_matches(lowerCommand, ["rain", "lluvia", "pluie", "regen", "baarish"])) {
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

  Future<void> _askAi(String query) async {
    _setStatus(AssistantStatus.processing);
    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/api/ai/chat'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'message': query}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _aiResponseController.add(data['content']);
        _setStatus(AssistantStatus.ai_responding);
      } else {
        _aiResponseController.add("Error: ${response.body}");
        _setStatus(AssistantStatus.ai_responding);
      }
    } catch (e) {
      _aiResponseController.add("Error: $e");
      _setStatus(AssistantStatus.ai_responding);
    }
     Timer(const Duration(seconds: 3), () {
        if(!_isAiMode)
        {
           _setStatus(AssistantStatus.idle);
        }
        else{
          _setStatus(AssistantStatus.ai_listening);
        }
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

  void exitAiMode() {
    _isAiMode = false;
    _setStatus(AssistantStatus.idle);
  }

  void dispose() {
    _statusController.close();
    _commandController.close();
    _aiResponseController.close();
  }
}

enum AssistantStatus { idle, listening, processing, responding, ai_listening, ai_responding }
''