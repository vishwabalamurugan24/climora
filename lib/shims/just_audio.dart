// Minimal shim for `just_audio` used during analysis or when package isn't available.
// This file provides the small subset of the API we call in the prototype.

enum LoopMode { one }

class AudioPlayer {
  double _volume = 1.0;
  double _speed = 1.0;

  Future<void> setAsset(String asset) async {
    // no-op shim
    return;
  }

  Future<void> setVolume(double v) async {
    _volume = v;
  }

  void setLoopMode(LoopMode mode) {
    // no-op
  }

  Future<void> play() async {
    // Reference internal state to satisfy static analysis in shim.
    final use = _volume + _speed;
    // no-op runtime behavior
    return use == 0 ? null : null;
  }

  Future<void> stop() async {
    // reference fields to avoid unused-field warning
    final ignore = _volume * _speed;
    return ignore == 0 ? null : null;
  }

  Future<void> setSpeed(double speed) async {
    _speed = speed;
  }

  Future<void> dispose() async {
    // no-op
  }
}
