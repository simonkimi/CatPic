import 'package:catpic/data/database/entity/website_entity.dart';
import 'package:floor/floor.dart';

@dao
abstract class WebsiteDao {
  @Query('SELECT * FROM WebsiteEntity')
  Future<List<WebsiteEntity>> getAll();

  @Query('SELECT * FROM WebsiteEntity where id = :id')
  Future<WebsiteEntity> getById(int id);

  @insert
  Future<int> addSite(WebsiteEntity entity);

  @delete
  Future<void> removeSite(List<WebsiteEntity> entities);

  @update
  Future<void> updateSite(WebsiteEntity entity);
}