import '../shims/just_audio.dart';

class AudioService {
  final Map<String, AudioPlayer> _players = {};
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    // AudioSession may not be available in some environments; keep init lightweight.
    // If you want to configure an audio session, uncomment and use `audio_session` package.
    _initialized = true;
  }

  /// Load asset for a suggestion key. `assetPath` is relative to project (e.g., 'assets/audio/rain.mp3')
  Future<void> loadAsset(String key, String assetPath, {double volume = 0.5}) async {
    await init();
    final player = AudioPlayer();
    try {
      await player.setAsset(assetPath);
    } catch (_) {
      // asset missing or failed to load; keep player but don't crash
    }
    await player.setVolume(volume.clamp(0.0, 1.0).toDouble());
    player.setLoopMode(LoopMode.one);
    _players[key] = player;
  }

  bool isLoaded(String key) => _players.containsKey(key);

  Future<void> play(String key) async {
    final p = _players[key];
    if (p == null) return;
    await p.play();
  }

  Future<void> stop(String key) async {
    final p = _players[key];
    if (p == null) return;
    await p.stop();
  }

  Future<void> stopAll() async {
    for (final p in _players.values) {
      await p.stop();
    }
  }

  Future<void> setVolume(String key, double volume) async {
    final p = _players[key];
    if (p == null) return;
    await p.setVolume(volume.clamp(0.0, 1.0).toDouble());
  }

  Future<void> setSpeed(String key, double speed) async {
    final p = _players[key];
    if (p == null) return;
    await p.setSpeed(speed.clamp(0.5, 2.0).toDouble());
  }

  Future<void> dispose() async {
    for (final p in _players.values) {
      await p.dispose();
    }
    _players.clear();
  }
}
