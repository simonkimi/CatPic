import 'package:catpic/data/models/booru/booru_post.dart';
import 'package:catpic/network/api/base_client.dart';

abstract class BooruPool {
  BooruPool({
    required this.id,
    required this.name,
    required this.createAt,
    required this.description,
    required this.postCount,
  });

  final String id;
  final String name;
  final String createAt;
  final String description;
  final int postCount;

  Future<BooruPost> fromIndex(BaseClient client, int index);

  Future<void> getPosts(BaseClient client);
}
