class PreViewModel {
  PreViewModel({
    this.gid,
    this.gtoken,
    this.title,
    this.tag,
    this.uploader,
    this.uploadTime,
    this.pages,
    this.stars,
    this.targetUrl,
    this.previewImg,
    this.language,
    this.keyTags,
    this.previewHeight,
    this.previewWidth,
  });

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

  String titleJpn;

  @override
  String toString() {
    return 'PreViewModel title: $title upload: $uploadTime';
  }
}

class PreviewTag {
  PreviewTag({this.tag, this.color});

  final String tag;
  final int color;

  @override
  String toString() {
    return '{$tag $color}';
  }
}
