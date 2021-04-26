import 'package:catpic/data/models/booru/booru_post.dart';

class BooruPool {
  const BooruPool({
    required this.id,
    required this.name,
    required this.createAt,
    required this.description,
    required this.posts,
  });

  final String id;
  final String name;
  final String createAt;
  final String description;
  final List<BooruPost> posts;
}
