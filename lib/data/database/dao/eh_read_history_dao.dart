import 'package:catpic/data/database/database.dart';
import 'package:catpic/data/database/entity/eh_read_history.dart';
import 'package:moor/moor.dart';

part 'eh_read_history_dao.g.dart';

@UseDao(tables: [EhReadHistoryTable])
class EhReadHistoryDao extends DatabaseAccessor<AppDataBase>
    with _$EhReadHistoryDaoMixin {
  EhReadHistoryDao(AppDataBase attachedDatabase) : super(attachedDatabase);

  Future<EhReadHistoryTableData?> get(String gid, String gtoken) =>
      (select(ehReadHistoryTable)
            ..where((tbl) => tbl.gtoken.equals(gtoken) & tbl.gid.equals(gid)))
          .getSingleOrNull();

  Future<int> getPage(String gid, String gtoken, int page) async {
    final table = await get(gid, gtoken);
    if (table == null) {
      await add(gid, gtoken);
    }
    return table?.readPage ?? 0;
  }

  Future<void> add(
    String gid,
    String gtoken,
  ) =>
      into(ehReadHistoryTable).insert(EhReadHistoryTableCompanion.insert(
          gid: gid, gtoken: gtoken, readPage: 0));

  Future<void> setPage(String gid, String gtoken, int page) async {
    final table = await get(gid, gtoken);
    if (table != null) {
      update(ehReadHistoryTable).replace(table.copyWith(readPage: page));
    }
  }
}
