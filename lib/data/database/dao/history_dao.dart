import 'package:catpic/data/database/entity/history_entity.dart';
import 'package:floor/floor.dart';

@dao
abstract class HistoryDao {
  @Query('SELECT * FROM TagEntity')
  Future<List<HistoryEntity>> getAll();

  @insert
  Future<int> addTag(HistoryEntity entity);

  @Query('DELETE * FROM HistoryEntity WHERE id = :id')
  Future<void> delete(int id);
}
