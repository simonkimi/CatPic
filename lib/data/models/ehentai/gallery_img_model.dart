class GalleryImgModel {
  final String imgUrl;
  final String imgSize;
  final int width;
  final int height;

  final int rawWidth;
  final int rawHeight;
  final String rawImgUrl;
  final String rawImgSize;

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

  @override
  String toString() {
    return '$width x $height $imgUrl';
  }
}
