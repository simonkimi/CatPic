import 'package:catpic/data/database/entity/history.dart';
import 'package:moor/moor.dart';

import '../database.dart';

part 'history_dao.g.dart';

@UseDao(tables: [HistoryTable])
class HistoryDao extends DatabaseAccessor<AppDataBase> with _$HistoryDaoMixin {
  HistoryDao(AppDataBase attachedDatabase) : super(attachedDatabase);

  Future<List<HistoryTableData>> getAll() => (select(historyTable)
        ..orderBy([
          (u) => OrderingTerm(expression: u.createTime, mode: OrderingMode.desc)
        ]))
      .get();

  Future<HistoryTableData?> get(String history) =>
      (select(historyTable)..where((tbl) => tbl.history.equals(history)))
          .getSingleOrNull();

  Future<void> updateHistory(HistoryTableData data) =>
      update(historyTable).replace(data);

  Future<void> insert(HistoryTableCompanion data) =>
      into(historyTable).insert(data);
}
