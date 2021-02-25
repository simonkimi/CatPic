import 'package:floor/floor.dart';

@Entity(tableName: 'DownloadEntity')
class DownloadEntity {
  DownloadEntity(
      {this.id,
      this.postId,
      this.previewUrl,
      this.md5,
      this.websiteId,
      this.imgUrl,
      this.largerUrl,
      this.quality,
      this.progress});

  @PrimaryKey(autoGenerate: true)
  final int id;
  final String postId;
  final String md5;
  final int websiteId;
  final String imgUrl;
  final String largerUrl;
  final String previewUrl;
  double progress;
  int quality;
}
