import 'package:catpic/data/models/gen/eh_gallery.pb.dart' as pb;

class GalleryBase {
  GalleryBase({
    required this.gid,
    required this.token,
  });

  factory GalleryBase.fromPb(pb.GalleryBase p) {
    return GalleryBase(
      gid: p.gid,
      token: p.token,
    );
  }

  final String gid;
  final String token;

  @override
  String toString() => 'gid: $gid, gtoken: $token';

  pb.GalleryBase toPb() => pb.GalleryBase(gid: gid, token: token);
}

class GalleryModel {
  GalleryModel({
    required this.gid,
    required this.token,
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
  });

  factory GalleryModel.fromPb(pb.GalleryModel p) {
    return GalleryModel(
      token: p.token,
      gid: p.gid,
      visible: p.visible,
      previewImages:
          p.previewImages.map((e) => PreviewImage.fromPb(e)).toList(),
      maxPageIndex: p.maxPageIndex,
      language: p.language,
      imageCount: p.imageCount,
      fileSize: p.fileSize,
      favorited: p.favorited,
      title: p.title,
      tags: p.tags.map((e) => TagModels.fromPb(e)).toList(),
      comments: p.comments.map((e) => CommentModel.fromPb(e)).toList(),
      parent: p.hasParent() ? GalleryBase.fromPb(p.parent) : null,
    );
  }

  final String gid;
  final String token;
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

  pb.GalleryModel toPb() => pb.GalleryModel(
        parent: parent?.toPb(),
        token: token,
        gid: gid,
        comments: comments.map((e) => e.toPb()),
        tags: tags.map((e) => e.toPb()),
        title: title,
        favorited: favorited,
        fileSize: fileSize,
        imageCount: imageCount,
        language: language,
        maxPageIndex: maxPageIndex,
        previewImages: previewImages.map((e) => e.toPb()),
        visible: visible,
      );
}

class TagItem {
  TagItem(this.value, this.parent);

  factory TagItem.fromPb(pb.TagItem p) {
    return TagItem(p.value, p.parent);
  }

  // tag的类别
  final String parent;

  // tag具体内容
  final String value;
  String? translate;

  pb.TagItem toPb() => pb.TagItem(value: value, parent: parent);
}

class TagModels {
  TagModels({
    required this.key,
    required this.value,
  });

  factory TagModels.fromPb(pb.TagModels p) {
    return TagModels(
        key: p.key, value: p.value.map((e) => TagItem.fromPb(e)).toList());
  }

  // tag类别
  final String key;
  String? keyTranslate;

  // tags
  final List<TagItem> value;

  @override
  String toString() {
    return '$key: ${value.join(' ')}';
  }

  pb.TagModels toPb() =>
      pb.TagModels(value: value.map((e) => e.toPb()), key: key);
}

class PreviewImage {
  PreviewImage({
    required this.width,
    required this.height,
    required this.image,
    required this.positioning,
    required this.target,
  });

  factory PreviewImage.fromPb(pb.PreviewImage p) {
    return PreviewImage(
      target: p.target,
      positioning: p.positioning,
      image: p.image,
      width: p.width,
      height: p.height,
    );
  }

  final int height;
  final int width;
  final String image;
  final int positioning;
  final String target;

  @override
  String toString() {
    return '$image $height $positioning $target';
  }

  pb.PreviewImage toPb() => pb.PreviewImage(
        height: height,
        width: width,
        image: image,
        positioning: positioning,
        target: target,
      );
}

class CommentModel {
  CommentModel({
    required this.username,
    required this.comment,
    required this.commentTime,
    required this.score,
    required this.voteUser,
  });

  factory CommentModel.fromPb(pb.CommentModel p) {
    return CommentModel(
        voteUser: p.voteUser,
        username: p.username,
        score: p.score,
        comment: p.comment,
        commentTime: p.commentTime);
  }

  final String username;
  final String comment;
  final String commentTime;
  final int score;
  final List<String> voteUser;

  @override
  String toString() {
    return '$username $commentTime $comment';
  }

  pb.CommentModel toPb() => pb.CommentModel(
        commentTime: commentTime,
        comment: comment,
        score: score,
        username: username,
        voteUser: voteUser,
      );
}
