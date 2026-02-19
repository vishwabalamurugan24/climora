// Minimal shim for `geolocator` to satisfy analysis when package isn't fetched.
// This provides the small API surface used by the prototype.

class Position {
  final double latitude;
  final double longitude;
  Position(this.latitude, this.longitude);
}

enum LocationPermission { denied, deniedForever, whileInUse, always }

class LocationAccuracy {
  static const high = 0;
}

class Geolocator {
  static Future<bool> isLocationServiceEnabled() async => false;

  static Future<LocationPermission> checkPermission() async => LocationPermission.denied;

  static Future<LocationPermission> requestPermission() async => LocationPermission.denied;

  static Future<Position> getCurrentPosition({int desiredAccuracy = LocationAccuracy.high}) async {
    // Return a dummy position; real implementation requires the geolocator package.
    return Position(0.0, 0.0);
  }
}
