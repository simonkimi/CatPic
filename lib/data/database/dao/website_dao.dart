import 'package:catpic/data/database/entity/website_entity.dart';
import 'package:floor/floor.dart';

@dao
abstract class WebsiteDao {
  @Query("SELECT * FROM WebsiteEntity")
  Future<List<WebsiteEntity>> getAll();

  @Query("SELECT * FROM WebsiteEntity where id = :id")
  Future<WebsiteEntity> getById(int id);

  @insert
  Future<List<int>> add(List<WebsiteEntity> entities);

  @delete
  Future<void> remove(List<WebsiteEntity> entities);
}