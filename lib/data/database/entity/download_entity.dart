import 'package:floor/floor.dart';

@Entity(tableName: 'DownloadEntity')
class DownloadEntity {
  DownloadEntity({
    this.id,
    this.postId,
    this.downloadUrl,
    this.previewUrl,
    this.md5,
  });

  @PrimaryKey(autoGenerate: true)
  final int id;
  final String postId;
  final String downloadUrl;
  final String previewUrl;
  final String md5;
}
