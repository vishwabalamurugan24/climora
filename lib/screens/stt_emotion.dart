import 'package:flutter/material.dart';
import '../services/speech_service.dart';
import '../services/emotion_service.dart';
import '../services/recommendation_service.dart';
import '../services/weather_music_settings.dart';
import '../services/weather_service.dart';
import '../services/audio_service.dart';
import '../services/music_library_service.dart';
import '../services/assistant_config.dart';

class SttEmotionScreen extends StatefulWidget {
  const SttEmotionScreen({super.key});

  @override
  State<SttEmotionScreen> createState() => _SttEmotionScreenState();
}

class _SttEmotionScreenState extends State<SttEmotionScreen> {
  final SpeechService _speech = SpeechService();
  final EmotionService _emotion = EmotionService();
  final RecommendationService _reco = RecommendationService();
  final AudioService _audio = AudioService();
  final MusicLibraryService _musicLib = MusicLibraryService();
  String _transcript = '';
  EmotionResult? _emotionResult;
  double _avgSoundLevel = 0.0;
  int _soundSamples = 0;
  bool _musicPlaying = false;

  @override
  void initState() {
    super.initState();
    _speech.init();
  }

  void _start() {
    setState(() {
      _transcript = '';
      _emotionResult = null;
      _avgSoundLevel = 0.0;
      _soundSamples = 0;
    });
    _speech.startListeningMultilingual(
      onResult: (text, level) async {
        setState(() {
          _transcript = text;
          _soundSamples++;
          _avgSoundLevel =
              ((_avgSoundLevel * (_soundSamples - 1)) + level) / _soundSamples;
        });
        final result = await _emotion.analyzeDual(_transcript, _avgSoundLevel);
        if (!mounted) return;
        setState(() {
          _emotionResult = result;
        });
      },
      localeId: _speech.getPreferredLocale(),
    );
  }

  void _stop() {
    _speech.stop();
    setState(() {});
  }

  Future<void> _playRecommendation() async {
    if (_emotionResult == null) return;
    final reco = _reco.recommend(
      emotion: _emotionResult,
      weather: WeatherData(
        temp: 20.0,
        humidity: 50,
        windSpeed: 1.5,
        cloudiness: 20,
        description: 'Clear',
        precipitation: 0.0,
      ),
      settings: WeatherMusicSettings(enabled: true),
    );
    // last recommendation intentionally not stored in UI state
    // load and play music
    final musicKey = 'music_track';
    try {
      if (!_audio.isLoaded(musicKey)) {
        await _audio.loadAsset(musicKey, reco.songAsset, volume: reco.volume);
      }
      await _audio.setSpeed(musicKey, reco.speed);
      await _audio.play(musicKey);
      // load ambient keys
      for (final a in reco.ambientKeys) {
        final path = 'assets/audio/$a.mp3';
        if (!_audio.isLoaded(a)) {
          try {
            await _audio.loadAsset(a, path, volume: 0.5);
          } catch (_) {}
        }
        await _audio.play(a);
      }
      setState(() {
        _musicPlaying = true;
      });
    } catch (e) {
      // ignore asset issues for prototype
    }
  }

  Future<void> _stopAllAudio() async {
    await _audio.stopAll();
    setState(() {
      _musicPlaying = false;
    });
  }

  Future<void> _mapLocalMusic() async {
    final choice = await showDialog<String?>(
      context: context,
      builder: (ctx) {
        return SimpleDialog(
          title: const Text('Map Local Music'),
          children: [
            SimpleDialogOption(
              child: const Text('Calming (calming_1)'),
              onPressed: () => Navigator.pop(ctx, 'calming'),
            ),
            SimpleDialogOption(
              child: const Text('Uplift (uplift_1)'),
              onPressed: () => Navigator.pop(ctx, 'uplift'),
            ),
            SimpleDialogOption(
              child: const Text('Neutral (neutral_1)'),
              onPressed: () => Navigator.pop(ctx, 'neutral'),
            ),
            SimpleDialogOption(
              child: const Text('Slow pad (slow_pad)'),
              onPressed: () => Navigator.pop(ctx, 'slow_pad'),
            ),
            SimpleDialogOption(
              child: const Text('Cancel'),
              onPressed: () => Navigator.pop(ctx, null),
            ),
          ],
        );
      },
    );

    if (choice == null) return;
    final path = await _musicLib.pickAudioFile();
    if (path == null) return;
    await _musicLib.saveMapping(choice, path);
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Mapping saved')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('$assistantName — STT & Emotion')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Listening: ${_speech.isListening}'),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _speech.isListening ? _stop : _start,
              child: Text(_speech.isListening ? 'Stop' : 'Start Listening'),
            ),
            const SizedBox(height: 16),
            Text('Transcript:', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Text(
                _transcript.isEmpty ? '(no speech yet)' : _transcript,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Vocal-tone proxy (avg sound level): ${_avgSoundLevel.toStringAsFixed(2)}',
            ),
            const SizedBox(height: 12),
            Text('Semantic emotion:'),
            const SizedBox(height: 8),
            if (_emotionResult == null)
              const Text('(no result)')
            else
              Text(
                '${_emotionResult!.label} (${_emotionResult!.score.toStringAsFixed(2)})',
              ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _emotionResult == null ? null : _playRecommendation,
              child: Text(
                _musicPlaying ? 'Stop Recommendation' : 'Play Recommendation',
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _stopAllAudio,
              child: const Text('Stop All Audio'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _mapLocalMusic,
              child: const Text('Map Local Music'),
            ),
          ],
        ),
      ),
    );
  }
}
