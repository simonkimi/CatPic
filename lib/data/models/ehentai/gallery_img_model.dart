class GalleryImgModel {
  GalleryImgModel({
    required this.imgUrl,
    required this.imgSize,
    required this.rawImgUrl,
    required this.rawImgSize,
    required this.width,
    required this.height,
    required this.rawWidth,
    required this.rawHeight,
    required this.sha,
  });

  final String imgUrl;
  final String imgSize;
  final int width;
  final int height;

  final int rawWidth;
  final int rawHeight;
  final String rawImgUrl;
  final String rawImgSize;

  final String sha;

  @override
  String toString() {
    return '$width x $height $imgUrl';
  }
}
