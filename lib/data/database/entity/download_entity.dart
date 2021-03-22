import 'package:floor/floor.dart';

@Entity(tableName: 'DownloadEntity')
class DownloadEntity {
  DownloadEntity({
    this.id,
    required this.postId,
    required this.previewUrl,
    required this.md5,
    required this.websiteId,
    required this.imgUrl,
    required this.largerUrl,
    required this.quality,
    required this.isFinish,
  });

  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String postId;
  final String md5;
  final int websiteId;
  final String imgUrl;
  final String largerUrl;
  final String previewUrl;
  final bool isFinish;
  int quality;
}
