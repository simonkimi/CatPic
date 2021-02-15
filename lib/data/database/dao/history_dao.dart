import 'package:catpic/data/database/entity/history_entity.dart';
import 'package:floor/floor.dart';

@dao
abstract class HistoryDao {
  @Query('SELECT * FROM HistoryEntity')
  Future<List<HistoryEntity>> getAll();

  @insert
  Future<int> addHistory(HistoryEntity entity);

  @Query('DELETE * FROM HistoryEntity WHERE id = :id')
  Future<void> delete(int id);
}
