// Lightweight shim for `shared_preferences` used during analysis/prototyping.
class SharedPreferences {
  final Map<String, String> _store = {};
  SharedPreferences._();

  static Future<SharedPreferences> getInstance() async {
    return SharedPreferences._();
  }

  String? getString(String key) => _store[key];

  Future<bool> setString(String key, String value) async {
    _store[key] = value;
    return true;
  }
}
