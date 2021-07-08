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
  final bool visible;
  final String fileSize;
  final int favorited;
  final int maxPageIndex;
  final int imageCount;
  final String language;

  final GalleryBase? parent;
  final List<TagModels> tags;
  final List<CommentModel> comments;
  final List<PreviewImage> previewImages;

  @override
  String toString() {
    return 'title: $title, tags: $tags parent: $parent';
  }
}

class TagItem {
  TagItem(this.value, this.parent);

  // tag的类别
  final String parent;

  // tag具体内容
  final String value;
  String? translate;
}

class TagModels {
  TagModels({
    required this.key,
    required this.value,
  });

  // tag类别
  final String key;
  String? keyTranslate;
  // tags
  final List<TagItem> value;

  @override
  String toString() {
    return '$key: ${value.join(' ')}';
  }
}

class PreviewImage {
  PreviewImage({
    required this.width,
    required this.height,
    required this.image,
    required this.positioning,
    required this.target,
  });

  final int height;
  final int width;
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
