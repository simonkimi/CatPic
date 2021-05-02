import 'dart:convert';
import 'package:catpic/data/models/booru/booru_artist.dart';
import 'artist_model.dart';

class MoebooruArtistParse {
  static List<BooruArtist> parse(String postJson) {
    final List<dynamic> artists = jsonDecode(postJson);

    return artists
        .map((e) => Root.fromJson(e))
        .map((e) => BooruArtist(name: e.name, extra: e.urls))
        .toList();
  }
}
