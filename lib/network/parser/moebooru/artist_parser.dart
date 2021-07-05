import 'dart:convert';
import 'package:catpic/data/models/booru/booru_artist.dart';
import 'artist_model.dart';

class MoebooruArtistParse {
  static List<BooruArtist> parse(String postJson) {
    final List<Map<String, dynamic>> artists =
        (jsonDecode(postJson) as List<dynamic>).cast();

    return artists
        .map((e) => Root.fromJson(e))
        .map((e) => BooruArtist(
              name: e.name,
              urls: e.urls,
              id: e.id.toString(),
            ))
        .toList();
  }
}
