import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';

class CloudDataService {
  FirebaseFirestore get _firestore => FirebaseFirestore.instance;
  FirebaseStorage get _storage => FirebaseStorage.instance;

  // --- Mood Management ---
  Future<void> logMood({
    required String userId,
    required String vibe,
    String? notes,
  }) async {
    try {
      await _firestore.collection('mood_logs').add({
        'userId': userId,
        'vibe': vibe,
        'notes': notes,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('Error logging mood: $e');
    }
  }

  Stream<QuerySnapshot> getMoodHistory(String userId) {
    return _firestore
        .collection('mood_logs')
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  // --- Mapping / Location Tracking ---
  Future<void> logLocation({
    required String userId,
    required double latitude,
    required double longitude,
    String? activity,
  }) async {
    try {
      await _firestore.collection('location_logs').add({
        'userId': userId,
        'latitude': latitude,
        'longitude': longitude,
        'activity': activity,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('Error logging location: $e');
    }
  }

  Stream<QuerySnapshot> getLocationHistory(String userId) {
    return _firestore
        .collection('location_logs')
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  // --- Weather Snapshots ---
  Future<void> logWeather({
    required String userId,
    required String condition,
    required double temperature,
    String? locationName,
  }) async {
    try {
      await _firestore.collection('weather_snapshots').add({
        'userId': userId,
        'condition': condition,
        'temperature': temperature,
        'locationName': locationName,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('Error logging weather: $e');
    }
  }

  // --- Musical Management ---
  Future<void> addSongMetadata({
    required String title,
    required String artist,
    required String mood,
    required String weatherCondition,
    required String storageUrl,
  }) async {
    try {
      await _firestore.collection('songs').add({
        'title': title,
        'artist': artist,
        'mood': mood,
        'weatherCondition': weatherCondition,
        'storageUrl': storageUrl,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('Error adding song metadata: $e');
    }
  }

  Stream<QuerySnapshot>? getSongsByMood(String mood) {
    try {
      return _firestore
          .collection('songs')
          .where('mood', isEqualTo: mood)
          .snapshots();
    } catch (e) {
      debugPrint('Error getting songs by mood: $e');
      return null;
    }
  }

  Future<String?> uploadMusicFile(
    String userId,
    File file,
    String fileName,
  ) async {
    try {
      final ref = _storage.ref().child('users/$userId/music/$fileName');
      final uploadTask = await ref.putFile(file);
      return await uploadTask.ref.getDownloadURL();
    } catch (e) {
      debugPrint('Error uploading music file: $e');
      return null;
    }
  }
}
