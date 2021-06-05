import 'package:catpic/data/database/entity/eh_history.dart';
import 'package:moor/moor.dart';

import '../database.dart';

part 'eh_history_dao.g.dart';

@UseDao(tables: [EhHistoryTable])
class EhHistoryDao<T extends AppDataBase> extends DatabaseAccessor<AppDataBase>
    with _$EhHistoryDaoMixin {
  EhHistoryDao(T attachedDatabase) : super(attachedDatabase);

  Future<List<EhHistoryTableData>> getAll() => (select(ehHistoryTable)
        ..orderBy([
          (u) => OrderingTerm(expression: u.lastOpen, mode: OrderingMode.desc)
        ]))
      .get();

  Future<EhHistoryTableData?> getById(String id) =>
      (select(ehHistoryTable)..where((tbl) => tbl.galleryId.equals(id)))
          .getSingleOrNull();

  Future<void> updateHistory(EhHistoryTableData data) =>
      update(ehHistoryTable).replace(data);

  Future<int> insert(EhHistoryTableCompanion data) =>
      into(ehHistoryTable).insert(data);

  Future<void> remove(EhHistoryTableData data) =>
      delete(ehHistoryTable).delete(data);

  Future<void> updatePage(String gid, int page) =>
      (update(ehHistoryTable)..where((tbl) => tbl.galleryId.equals(gid)))
          .write(EhHistoryTableCompanion(readPage: Value(page)));
}
