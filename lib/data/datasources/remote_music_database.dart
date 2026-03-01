
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:climora/core/errors/exceptions.dart';
import 'package:climora/data/models/song_model.dart';

abstract class RemoteMusicDatabase {
  Future<List<SongModel>> getSongs();
}

class RemoteMusicDatabaseImpl implements RemoteMusicDatabase {
  final http.Client client;

  RemoteMusicDatabaseImpl({required this.client});

  @override
  Future<List<SongModel>> getSongs() async {
    final response = await client.get(
      Uri.parse('http://localhost:3000/api/music'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final songs = jsonDecode(response.body) as List;
      return songs.map((song) => SongModel.fromJson(song)).toList();
    } else {
      throw ServerException();
    }
  }
}
