import 'package:flutter/material.dart';
import '../models/session_model.dart';
import '../models/playlist_track_model.dart';
import '../models/place_recommendation_model.dart';
import '../services/firestore_service.dart';

class SessionDetailScreen extends StatelessWidget {
  final Session session;
  final FirestoreService _firestoreService = FirestoreService();

  SessionDetailScreen({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
    final weatherCondition = session.weather['condition'] ?? 'N/A';
    final temperature = session.weather['temperature']?.toStringAsFixed(1) ?? '--';

    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Session on ${session.timestamp.toLocal().toString().substring(0, 10)}'),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Mood: ${session.detectedMood} | Weather: $weatherCondition, ${temperature}°C',
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              'Playlist',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          StreamBuilder<List<PlaylistTrack>>(
            stream: _firestoreService.getSessionPlaylist(session.id),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(
                    child: Text('Error: ${snapshot.error.toString()}'));
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const ListTile(title: Text('No playlist found for this session.'));
              }

              final playlist = snapshot.data!;
              return ListView.builder(
                shrinkWrap: true, // Important for nested lists
                physics: const NeverScrollableScrollPhysics(), // Disable inner scrolling
                itemCount: playlist.length,
                itemBuilder: (context, index) {
                  final track = playlist[index];
                  return ListTile(
                    leading: const Icon(Icons.music_note, color: Colors.grey),
                    title: Text(track.title),
                    subtitle: Text(track.artist ?? 'Unknown Artist'),
                    trailing: Text(
                      track.category ?? '',
                      style: const TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Colors.grey,
                      ),
                    ),
                  );
                },
              );
            },
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              'Recommended Places',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          StreamBuilder<List<PlaceRecommendation>>(
            stream: _firestoreService.getSessionRecommendations(session.id),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(
                    child: Text('Error: ${snapshot.error.toString()}'));
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const ListTile(title: Text('No places were recommended for this session.'));
              }

              final places = snapshot.data!;
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: places.length,
                itemBuilder: (context, index) {
                  final place = places[index];
                  return ListTile(
                    leading: const Icon(Icons.place, color: Colors.grey),
                    title: Text(place.name),
                    subtitle: Text(place.category),
                  );
                },
              );
            },
          ),
        ],
      ),
      ),
    );
  }
}