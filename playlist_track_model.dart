import 'package:cloud_firestore/cloud_firestore.dart';

class PlaylistTrack {
  final String id;
  final String title;
  final String? artist;
  final String? category;
  final DateTime playedAt;

  PlaylistTrack({
    required this.id,
    required this.title,
    this.artist,
    this.category,
    required this.playedAt,
  });

  factory PlaylistTrack.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;
    return PlaylistTrack(
      id: snapshot.id,
      title: data['title'] ?? 'Unknown Title',
      artist: data['artist'],
      category: data['category'],
      playedAt: (data['playedAt'] as Timestamp? ?? Timestamp.now()).toDate(),
    );
  }
}