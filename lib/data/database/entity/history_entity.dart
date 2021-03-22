import 'package:floor/floor.dart';

@Entity(tableName: 'HistoryEntity')
class HistoryEntity {
  HistoryEntity({
    this.id,
    required this.history,
    required this.createTime,
  });

  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String history;
  int createTime;
}
