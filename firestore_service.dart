import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// A simple model representing a music track.
/// In a real app, this would be more detailed.
class MusicTrack {
  final String id;
  final String title;
  final String? artist;

  MusicTrack({required this.id, required this.title, this.artist});

  factory MusicTrack.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return MusicTrack(
      id: doc.id,
      title: data['title'] ?? 'Unknown Title',
      artist: data['artist'],
    );
  }
}

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  /// Logs a user's interaction with a suggested place to the `place_history` subcollection.
  /// This creates a behavioral record for personalization and learning.
  Future<String?> logPlaceInteraction({
    required String placeId, // From Google Places API
    required String placeName,
    required String placeType,
    required String moodContext,
    required String weatherContext,
    required String intent, // e.g., 'find a place to eat'
    required String? budgetContext, // e.g., '500 rupees', can be null
    required String timeOfDay,
    required double distanceFromUser, // in km
    required bool navigationUsed,
    required String visitStatus, // e.g., 'visited', 'ignored', 'liked'
  }) async {
    final user = _auth.currentUser;
    if (user == null) return null;

    final historyRef =
        _db.collection('users').doc(user.uid).collection('place_history');

    // Use .add() to create the document and get its reference.
    final docRef = await historyRef.add({
      'placeId': placeId,
      'suggestedPlaceName': placeName,
      'placeType': placeType,
      'moodContext': moodContext,
      'weatherContext': weatherContext,
      'intent': intent,
      'budgetContext': budgetContext,
      'timeOfDay': timeOfDay,
      'distanceFromUser': distanceFromUser,
      'navigationUsed': navigationUsed,
      'visitStatus': visitStatus,
      'timestamp': FieldValue.serverTimestamp(),
    });
    // Return the ID of the newly created document.
    return docRef.id;
  }

  /// Logs a snapshot of the user's mood and environment.
  Future<void> logMoodHistory({
    required String detectedMood,
    required String timeOfDay,
    required Map<String, dynamic> weatherContext,
    required String locationName,
  }) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final historyRef =
        _db.collection('users').doc(user.uid).collection('mood_history');

    await historyRef.add({
      'detectedMood': detectedMood,
      'timeOfDay': timeOfDay,
      'weatherContext': weatherContext,
      'locationName': locationName,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  /// Logs how a user interacted with a specific music track.
  Future<void> logMusicActivity({
    required String playedTrackId,
    required String language,
    required String moodAtPlayback,
    required int startPosition, // in seconds
    required bool voiceCommandUsed,
    required bool liked,
    required bool skipped,
    required int listeningDuration,
    required String recommendationSource,
  }) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final activityRef =
        _db.collection('users').doc(user.uid).collection('music_activity');

    await activityRef.add({
      'playedTrackId': playedTrackId,
      'language': language,
      'moodAtPlayback': moodAtPlayback,
      'startPosition': startPosition,
      'voiceCommandUsed': voiceCommandUsed,
      'liked': liked,
      'skipped': skipped,
      'listeningDuration': listeningDuration,
      'recommendationSource': recommendationSource,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  /// Adds or updates a place in the user's list of favorite places.
  Future<void> updateUserFavoritePlace({
    required String placeId,
    required String placeName,
    required String placeType,
  }) async {
    final user = _auth.currentUser;
    if (user == null) return;

    // Use the placeId as the document ID for easy lookup and to prevent duplicates.
    final favoriteRef = _db
        .collection('users')
        .doc(user.uid)
        .collection('favorite_places')
        .doc(placeId);

    await favoriteRef.set({
      'placeName': placeName,
      'placeType': placeType,
      'lastVisited': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true)); // Use merge to avoid overwriting if it exists
  }

  /// Updates a specific place_history document with a mood improvement tag.
  /// This is called after a user has a positive experience with a recommendation.
  Future<void> addMoodTagToPlaceHistory({
    required String historyDocId,
    required String moodImprovementTag, // e.g., 'felt_relaxed', 'energized'
  }) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final historyDocRef = _db
        .collection('users')
        .doc(user.uid)
        .collection('place_history')
        .doc(historyDocId);

    // Update the document with the new tag and confirm the visit status.
    await historyDocRef.update({
      'moodImprovementTag': moodImprovementTag,
      'visitStatus': 'visited', // Explicitly mark as visited upon positive feedback.
    });
  }

  /// Updates the user's AI profile summary in their main document.
  /// This is typically called by a trusted server environment (like a Cloud Function)
  /// after analyzing user history.
  Future<void> updateAiProfile(Map<String, dynamic> aiProfileData) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception("User must be logged in to update AI profile.");
    }

    final userDocRef = _db.collection('users').doc(user.uid);

    // Use `SetOptions(merge: true)` to update the ai_profile field
    // without overwriting the entire user document.
    await userDocRef.set(
      {
        'ai_profile': aiProfileData,
      },
      SetOptions(merge: true),
    );
  }

  /// Fetches the user's AI profile from their main document.
  Future<Map<String, dynamic>?> getAiProfile() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    final userDoc = await _db.collection('users').doc(user.uid).get();
    if (userDoc.exists && userDoc.data()!.containsKey('ai_profile')) {
      return userDoc.data()!['ai_profile'] as Map<String, dynamic>;
    }
    return null;
  }

  /// Fetches full music track details from a list of track IDs.
  /// Assumes a top-level `music_tracks` collection exists.
  Future<List<MusicTrack>> getTracksByIds(List<String> trackIds) async {
    if (trackIds.isEmpty) return [];

    // Firestore 'in' queries are limited to 30 elements. For larger lists,
    // you would need to batch the requests into multiple queries.
    final querySnapshot = await _db
        .collection('music_tracks')
        .where(FieldPath.documentId, whereIn: trackIds)
        .get();

    return querySnapshot.docs.map((doc) => MusicTrack.fromFirestore(doc)).toList();
  }

  /// Generic fallback to get tracks by category (e.g., for new users).
  Future<List<MusicTrack>> getTracksByCategory(String category) async {
    final querySnapshot = await _db
        .collection('music_tracks')
        .where('category', isEqualTo: category)
        .limit(10) // Limit the results for performance
        .get();
    return querySnapshot.docs.map((doc) => MusicTrack.fromFirestore(doc)).toList();
  }
}

// Assume Session model exists from previous steps