class PreViewModel {
  PreViewModel(
      {required this.gid,
      required this.gtoken,
      required this.title,
      required this.tag,
      required this.uploader,
      required this.uploadTime,
      required this.pages,
      required this.stars,
      required this.targetUrl,
      required this.previewImg,
      required this.language,
      required this.keyTags,
      required this.previewHeight,
      required this.previewWidth,
      this.titleJpn});

  final String title;
  final String tag;
  final String uploader;
  final String uploadTime;
  final int pages;
  final double stars;
  final String language;

  final String targetUrl;
  final String previewImg;
  final List<PreviewTag> keyTags;

  final int previewHeight;
  final int previewWidth;

  final String gid;
  final String gtoken;

  String? titleJpn;

  @override
  String toString() {
    return 'PreViewModel title: $title upload: $uploadTime';
  }
}

class PreviewTag {
  PreviewTag({required this.tag, required this.color});

  final String tag;
  final int color;

  @override
  String toString() {
    return '{$tag $color}';
  }
}
