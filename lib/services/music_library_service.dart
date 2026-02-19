import 'dart:async';
import '../shims/shared_preferences.dart';
import '../shims/file_picker.dart';

class MusicLibraryService {
  static const _mappingKey = 'music_mappings';

  Future<Map<String, String>> loadMappings() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_mappingKey);
    if (raw == null || raw.isEmpty) return {};
    try {
      final Map<String, String> j = Uri.splitQueryString(raw);
      return Map<String, String>.from(j);
    } catch (_) {
      return {};
    }
  }

  Future<void> saveMapping(String key, String path) async {
    final prefs = await SharedPreferences.getInstance();
    final current = await loadMappings();
    current[key] = path;
    // store as simple query-string like encoding
    final encoded = current.entries.map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}').join('&');
    await prefs.setString(_mappingKey, encoded);
  }

  Future<void> removeMapping(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final current = await loadMappings();
    current.remove(key);
    final encoded = current.entries.map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}').join('&');
    await prefs.setString(_mappingKey, encoded);
  }

  Future<String?> pickAudioFile() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.audio);
    if (result == null || result.files.isEmpty) return null;
    return result.files.first.path;
  }
}
