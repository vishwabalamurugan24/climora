import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:climora/domain/entities/song_entity.dart';
import 'package:climora/domain/repositories/music_repository.dart';
import 'package:climora/services/weather_music_settings.dart';

class SQLiteMusicRepository implements MusicRepository {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('climora_music.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE songs (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        artist TEXT NOT NULL,
        assetPath TEXT NOT NULL,
        genres TEXT,
        languages TEXT,
        moods TEXT,
        weatherTriggers TEXT,
        idealTimeRanges TEXT
      )
    ''');
  }

  @override
  Future<List<SongEntity>> getAllSongs() async {
    final db = await database;
    final result = await db.query('songs');
    return result.map((json) => _fromMap(json)).toList();
  }

  @override
  Future<void> addSong(SongEntity song) async {
    final db = await database;
    await db.insert(
      'songs',
      _toMap(song),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> removeSong(String id) async {
    final db = await database;
    await db.delete('songs', where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<List<SongEntity>> getRecommendedSongs({
    required List<String> triggers,
    required List<String> genres,
  }) async {
    final all = await getAllSongs();
    return all.where((s) => s.genres.any((g) => genres.contains(g))).toList();
  }

  Map<String, dynamic> _toMap(SongEntity song) {
    return {
      'id': song.id,
      'title': song.title,
      'artist': song.artist,
      'assetPath': song.assetPath,
      'genres': song.genres.join(','),
      'languages': song.languages.join(','),
      'moods': song.moods.map((m) => m.name).join(','),
      'weatherTriggers': song.weatherTriggers.map((t) => t.name).join(','),
      'idealTimeRanges': song.idealTimeRanges.map((r) => r.name).join(','),
    };
  }

  SongEntity _fromMap(Map<String, dynamic> map) {
    final moodsStr = map['moods'] as String? ?? '';
    final triggersStr = map['weatherTriggers'] as String? ?? '';
    final rangesStr = map['idealTimeRanges'] as String? ?? '';

    return SongEntity(
      id: map['id'],
      title: map['title'],
      artist: map['artist'],
      assetPath: map['assetPath'],
      genres: (map['genres'] as String? ?? '').split(','),
      languages: (map['languages'] as String? ?? '').split(','),
      moods: moodsStr.isEmpty
          ? []
          : moodsStr
                .split(',')
                .map((s) => s.trim())
                .where((s) => s.isNotEmpty)
                .map((s) => SongMood.values.byName(s))
                .toList(),
      weatherTriggers: triggersStr.isEmpty
          ? []
          : triggersStr
                .split(',')
                .map((s) => s.trim())
                .where((s) => s.isNotEmpty)
                .map((s) => WeatherTrigger.values.byName(s))
                .toList(),
      idealTimeRanges: rangesStr.isEmpty
          ? []
          : rangesStr
                .split(',')
                .map((s) => s.trim())
                .where((s) => s.isNotEmpty)
                .map((s) => TimeRange.values.byName(s))
                .toList(),
    );
  }
}
