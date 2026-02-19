// Shim for `url_launcher`'s `launchUrlString` to satisfy analysis when
// the real package isn't available. This shim returns false (not opened).
Future<bool> launchUrlString(String url) async {
  // No-op fallback: cannot open external apps in this environment.
  return false;
}
