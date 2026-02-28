import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/firestore_service.dart';

// Mock model for a place fetched from Google Places API
class LivePlace {
  final String placeId;
  final String name;
  final String type;
  final double distance; // in km
  final double lat;
  final double lon;

  LivePlace({required this.placeId, required this.name, required this.type, required this.distance, required this.lat, required this.lon});
}

class RefreshModeScreen extends StatefulWidget {
  const RefreshModeScreen({super.key});

  @override
  State<RefreshModeScreen> createState() => _RefreshModeScreenState();
}

class _RefreshModeScreenState extends State<RefreshModeScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  Future<List<Map<String, dynamic>>>? _destinationsFuture;

  @override
  void initState() { // This should be initState, not initSate
    super.initState();
    _destinationsFuture = _fetchDestinations();
  }

  // This function now simulates fetching from Google Places API
  Future<List<LivePlace>> _fetchLivePlaces() async {
    try {
      // 1. Get user's current location (ensure permissions are handled)
      // final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

      // 2. Get current weather (replace with your actual weather API call)
      final currentWeather = "Cloudy"; // Example weather
      final currentMood = "Stressed"; // Example mood

      // 3. Call Google Places API with mood/weather filters (MOCKED HERE)
      print('Fetching places suitable for mood: $currentMood, weather: $currentWeather');
      // In a real app, you would use the http package to call:
      // https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=...&radius=...&type=park&key=...

      // --- MOCK API RESPONSE ---
      await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
      return [
        LivePlace(placeId: 'ChIJN1t_tDeuEmsRUsoyG83frY4', name: 'Riverside Park', type: 'park', distance: 1.2, lat: -33.867, lon: 151.206),
        LivePlace(placeId: 'ChIJi3l_sDeuEmsR2x2l_2Vd', name: 'The Quiet Corner Bookstore', type: 'bookstore', distance: 2.5, lat: -33.87, lon: 151.208),
      ];
    } catch (e) {
      // Handle errors (e.g., location permission denied)
      print("Error fetching destinations: $e");
      throw Exception('Failed to load destinations. Please ensure location services are enabled.');
    }
  }
  
  // This function is now incorrect as _fetchDestinations is removed.
  // Let's adapt the structure to use _fetchLivePlaces
  Future<List<Map<String, dynamic>>> _fetchDestinations() async {
    final places = await _fetchLivePlaces();
    return places.map((p) => {'destination': p, 'distance': p.distance}).toList();
  }

  // Helper to launch maps for navigation
  void _launchMaps(double lat, double lon) async {
    final uri = Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lon');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      // In a real app, show a snackbar or dialog
      print("Could not launch maps");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Refresh Mode: Destinations'),
        backgroundColor: Colors.teal,
      ),
      body: FutureBuilder<List<LivePlace>>(
        future: _destinationsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No suitable destinations found nearby.'));
          }

          final destinations = snapshot.data!;

          return ListView.builder(
            itemCount: destinations.length,
            itemBuilder: (context, index) {
              final place = destinations[index];

              return Card(
                margin: const EdgeInsets.all(10),
                clipBehavior: Clip.antiAlias,
                elevation: 5,
                child: ListTile(
                  leading: Icon(_getPlaceIcon(place.type), color: Colors.teal),
                  title: Text(place.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('${place.type.capitalize()} - ${place.distance.toStringAsFixed(1)} km away'),
                  trailing: IconButton(
                    icon: const Icon(Icons.navigation_outlined, color: Colors.blue),
                    tooltip: 'Navigate',
                    onPressed: () {
                      // Log the interaction to Firestore
                      _firestoreService.logPlaceInteraction(
                        placeId: place.placeId,
                        placeName: place.name,
                        placeType: place.type,
                        moodContext: "Stressed", // Example context
                        weatherContext: "Cloudy", // Example context
                        timeOfDay: "Afternoon", // Example context
                        distanceFromUser: place.distance,
                        navigationUsed: true,
                        visitStatus: 'navigated',
                      );
                      // Launch maps
                      _launchMaps(place.lat, place.lon);
                    },
                  ),
                  onTap: () {
                    // Handle tap for viewing details, maybe show a bottom sheet
                    // with more info from a Places API Details call.
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  IconData _getPlaceIcon(String type) {
    switch (type) {
      case 'park':
        return Icons.park;
      case 'bookstore':
        return Icons.book;
      case 'cafe':
        return Icons.local_cafe;
      default:
        return Icons.place;
    }
  }
}

extension StringExtension on String {
    String capitalize() => "${this[0].toUpperCase()}${substring(1)}";
}