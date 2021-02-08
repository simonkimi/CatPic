enum PostRating { SAFE, EXPLICIT, QUESTIONABLE }

class BooruPost {
  BooruPost({
    this.id,
    this.md5,
    this.creatorId,
    this.imgURL,
    this.previewURL,
    this.sampleURL,
    this.width,
    this.height,
    this.sampleWidth,
    this.sampleHeight,
    this.previewWidth,
    this.previewHeight,
    this.rating,
    this.status,
    this.tags,
    this.source,
  });

  final String id;
  final String creatorId;
  final String md5;

  final String imgURL;
  final String previewURL;
  final String sampleURL;

  final int width;
  final int height;
  final int sampleWidth;
  final int sampleHeight;
  final int previewWidth;
  final int previewHeight;

  final PostRating rating;
  final String status;
  final Map<String, List<String>> tags;
  final String source;
}
