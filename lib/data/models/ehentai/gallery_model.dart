class GalleryModel {
  final String parent;
  final String visible;
  final String fileSize;
  final int favorited;
  final List<TagModels> tags;
  List<PreviewImage> previewImages;
  final int maxPageIndex;
  final List<CommentModel> comments;

  GalleryModel({
    this.maxPageIndex,
    this.parent,
    this.visible,
    this.fileSize,
    this.favorited,
    this.tags,
    this.previewImages,
    this.comments
  });
}

class TagModels {
  final String key;
  final List<String> value;

  TagModels({this.key, this.value});

  @override
  String toString() {
    return '$key: ${value.join(" ")}';
  }
}

class PreviewImage {
  final int height;
  final String image;
  final int positioning;
  final String target;

  PreviewImage({this.height, this.image, this.positioning, this.target});

  @override
  String toString() {
    return '${image} ${height} ${positioning} ${target}';
  }
}

class CommentModel {
  final String username;
  final String comment;
  final String commentTime;

  CommentModel({
    this.username,
    this.comment,
    this.commentTime,
  });

  @override
  String toString() {
    return '$username $commentTime $comment';
  }
}
