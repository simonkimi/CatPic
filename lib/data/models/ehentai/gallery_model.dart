class GalleryBase {
  GalleryBase({
    required this.gid,
    required this.token,
  });

  final String gid;
  final String token;

  @override
  String toString() => 'gid: $gid, gtoken: $token';
}

class GalleryModel extends GalleryBase {
  GalleryModel({
    required String gid,
    required String token,
    required this.title,
    required this.maxPageIndex,
    required this.parent,
    required this.visible,
    required this.fileSize,
    required this.favorited,
    required this.tags,
    required this.previewImages,
    required this.comments,
    required this.imageCount,
    required this.language,
  }) : super(gid: gid, token: token);

  final String title;
  final GalleryBase? parent;
  final bool visible;
  final String fileSize;
  final int favorited;
  final List<TagModels> tags;
  List<PreviewImage> previewImages;
  final int maxPageIndex;
  final List<CommentModel> comments;
  final int imageCount;
  final String language;

  @override
  String toString() {
    return 'title: $title, tags: $tags parent: $parent';
  }
}

class TagModels {
  TagModels({
    required this.key,
    required this.value,
  });

  final String key;
  final List<String> value;

  @override
  String toString() {
    return '$key: ${value.join(' ')}';
  }
}

class PreviewImage {
  PreviewImage({
    required this.height,
    required this.image,
    required this.positioning,
    required this.target,
  });

  final int height;
  final String image;
  final int positioning;
  final String target;

  @override
  String toString() {
    return '$image $height $positioning $target';
  }
}

class CommentModel {
  CommentModel({
    required this.username,
    required this.comment,
    required this.commentTime,
    required this.score,
    required this.voteUser,
  });

  final String username;
  final String comment;
  final String commentTime;
  final int score;
  final List<String> voteUser;

  @override
  String toString() {
    return '$username $commentTime $comment';
  }
}
