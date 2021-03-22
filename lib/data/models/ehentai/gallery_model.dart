class GalleryModel {
  GalleryModel({
    required this.maxPageIndex,
    required this.parent,
    required this.visible,
    required this.fileSize,
    required this.favorited,
    required this.tags,
    required this.previewImages,
    required this.comments,
  });

  final String parent;
  final String visible;
  final String fileSize;
  final int favorited;
  final List<TagModels> tags;
  List<PreviewImage> previewImages;
  final int maxPageIndex;
  final List<CommentModel> comments;
}

class TagModels {
  TagModels({required this.key, required this.value});

  final String key;
  final List<String> value;

  @override
  String toString() {
    return '$key: ${value.join(' ')}';
  }
}

class PreviewImage {
  PreviewImage(
      {required this.height,
      required this.image,
      required this.positioning,
      required this.target});

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
  });

  final String username;
  final String comment;
  final String commentTime;

  @override
  String toString() {
    return '$username $commentTime $comment';
  }
}
