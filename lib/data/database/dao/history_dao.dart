import 'package:catpic/data/database/entity/history.dart';
import 'package:moor/moor.dart';

import '../database.dart';

part 'history_dao.g.dart';

@UseDao(tables: [HistoryTable])
class HistoryDao extends DatabaseAccessor<AppDataBase> with _$HistoryDaoMixin {
  HistoryDao(attachedDatabase) : super(attachedDatabase);

  Future<List<HistoryTableData>> getAll() => select(historyTable).get();

  Future<List<HistoryTableData>> get(String history) =>
      (select(historyTable)..where((tbl) => tbl.history.equals(history))).get();

  Future<void> updateHistory(HistoryTableData data) =>
      update(historyTable).replace(data);

  Future<void> insert(HistoryTableData data) => into(historyTable).insert(data);
}
