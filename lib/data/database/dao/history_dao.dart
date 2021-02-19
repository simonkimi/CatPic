import 'package:catpic/data/database/entity/history_entity.dart';
import 'package:floor/floor.dart';

@dao
abstract class HistoryDao {
  @Query('SELECT * FROM HistoryEntity ORDER BY createTime DESC')
  Future<List<HistoryEntity>> getAll();

  @Query('SELECT * FROM HistoryEntity WHERE history = :history')
  Future<HistoryEntity> getByHistory(String history);

  @update
  Future<void> updateHistory(HistoryEntity entity);

  @insert
  Future<int> addHistory(HistoryEntity entity);

  @Query('DELETE * FROM HistoryEntity WHERE id = :id')
  Future<void> delete(int id);
}
