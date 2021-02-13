import 'package:catpic/data/database/entity/tag_entity.dart';
import 'package:floor/floor.dart';

@dao
abstract class TagDao {
  @Query('SELECT * FROM TagEntity')
  Future<List<TagEntity>> getAll();

  @Insert(onConflict: OnConflictStrategy.ignore)
  Future<List<int>> addTag(List<TagEntity> entity);

  @Query('SELECT * FROM TagEntity WHERE website = :website AND tag LIKE :tag')
  Future<List<TagEntity>> getStart(int website, String tag);

  @Query('DELETE * FROM TagEntity')
  Future<void> deleteAll();
}
