import 'package:catpic/data/database/database.dart';
import 'package:catpic/data/database/entity/download.dart';
import 'package:catpic/data/database/entity/eh_download.dart';
import 'package:drift/drift.dart';

part 'eh_download_dao.g.dart';

@DriftAccessor(tables: [EhDownloadTable])
class EhDownloadDao extends DatabaseAccessor<AppDataBase>
    with _$EhDownloadDaoMixin {
  EhDownloadDao(AppDataBase attachedDatabase) : super(attachedDatabase);

  Future<List<EhDownloadTableData>> getAll() => select(ehDownloadTable).get();

  Future<EhDownloadTableData?> get(int id) =>
      (select(ehDownloadTable)..where((tbl) => tbl.id.equals(id)))
          .getSingleOrNull();

  Future<EhDownloadTableData?> getByGid(String gid, String gtoken) =>
      (select(ehDownloadTable)
            ..where((tbl) =>
                tbl.gid.equals(gid.trim()) & tbl.gtoken.equals(gtoken.trim())))
          .getSingleOrNull();

  Stream<List<EhDownloadTableData>> getAllStream() =>
      select(ehDownloadTable).watch();

  Future<void> replace(EhDownloadTableData data) =>
      update(ehDownloadTable).replace(data);

  Future<int> insert(EhDownloadTableCompanion data) =>
      into(ehDownloadTable).insert(data);

  Future<void> remove(EhDownloadTableData data) =>
      delete(ehDownloadTable).delete(data);

  Future<void> onWebsiteDelete(int id) => (update(ehDownloadTable)
        ..where((tbl) =>
            tbl.websiteId.equals(id) &
            tbl.status.equals(DownloadStatus.PENDING)))
      .write(const EhDownloadTableCompanion(
          status: Value(DownloadStatus.UNREACHABLE)));

  Future<void> deleteAll() => delete(ehDownloadTable).go();
}
