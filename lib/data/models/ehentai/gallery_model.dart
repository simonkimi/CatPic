class GalleryModel {
  GalleryModel(
      {this.maxPageIndex,
      this.parent,
      this.visible,
      this.fileSize,
      this.favorited,
      this.tags,
      this.previewImages,
      this.comments});

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
  TagModels({this.key, this.value});

  final String key;
  final List<String> value;

  @override
  String toString() {
    return '$key: ${value.join(' ')}';
  }
}

class PreviewImage {
  PreviewImage({this.height, this.image, this.positioning, this.target});

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
    this.username,
    this.comment,
    this.commentTime,
  });

  final String username;
  final String comment;
  final String commentTime;

  @override
  String toString() {
    return '$username $commentTime $comment';
  }
}
