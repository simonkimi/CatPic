import 'package:floor/floor.dart';

@Entity(tableName: 'HistoryEntity')
class HistoryEntity {
  HistoryEntity({
    this.id,
    this.history,
    this.createTime,
  });

  @PrimaryKey(autoGenerate: true)
  final int id;
  final String history;
  final int createTime;
}
