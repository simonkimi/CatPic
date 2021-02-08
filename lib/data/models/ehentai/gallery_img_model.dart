class GalleryImgModel {
  GalleryImgModel({
    this.imgUrl,
    this.imgSize,
    this.rawImgUrl,
    this.rawImgSize,
    this.width,
    this.height,
    this.rawWidth,
    this.rawHeight,
  });

  final String imgUrl;
  final String imgSize;
  final int width;
  final int height;

  final int rawWidth;
  final int rawHeight;
  final String rawImgUrl;
  final String rawImgSize;

  @override
  String toString() {
    return '$width x $height $imgUrl';
  }
}
