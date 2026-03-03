
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:climora/core/errors/exceptions.dart';
import 'package:climora/domain/entities/song_entity.dart';

abstract class RemoteMusicDatabase {
  Future<List<SongEntity>> getSongs();
}

class RemoteMusicDatabaseImpl implements RemoteMusicDatabase {
  final http.Client client;

  RemoteMusicDatabaseImpl({required this.client});

  @override
  Future<List<SongEntity>> getSongs() async {
    final response = await client.get(
      Uri.parse('http://localhost:3000/api/music'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final songs = jsonDecode(response.body) as List;
      return songs.map((song) => SongEntity.fromJson(song)).toList();
    } else {
      throw ServerException();
    }
  }
}
