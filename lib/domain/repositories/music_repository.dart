import '../entities/song_entity.dart';

abstract class MusicRepository {
  Future<List<SongEntity>> getAllSongs();
  Future<void> addSong(SongEntity song);
  Future<void> removeSong(String id);
  Future<List<SongEntity>> getRecommendedSongs({
    required List<String> triggers,
    required List<String> genres,
  });
}
