import 'package:equatable/equatable.dart';

class PlaceRecommendation extends Equatable {
  final String id;
  final String name;
  final String description;
  final double latitude;
  final double longitude;
  final String vibe; // e.g., 'calm', 'energetic', 'social'
  final String category;

  const PlaceRecommendation({
    required this.id,
    required this.name,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.vibe,
    required this.category,
  });

  @override
  List<Object?> get props => [id, name, latitude, longitude, vibe];
}
