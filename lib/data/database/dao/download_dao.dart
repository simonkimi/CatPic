import 'package:catpic/data/database/entity/download_entity.dart';
import 'package:floor/floor.dart';

@dao
abstract class DownloadDao {
  @insert
  Future<int> create(DownloadEntity entity);

  @Query('SELECT * FROM DownloadEntity')
  Future<List<DownloadEntity>> getALL();
}
