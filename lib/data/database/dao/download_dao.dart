import 'package:catpic/data/database/database.dart';
import 'package:catpic/data/database/entity/download.dart';
import 'package:moor/moor.dart';

part 'download_dao.g.dart';

@UseDao(tables: [DownloadTable])
class DownloadDao extends DatabaseAccessor<AppDataBase>
    with _$DownloadDaoMixin {
  DownloadDao(AppDataBase attachedDatabase) : super(attachedDatabase);

  Future<List<DownloadTableData>> getAll() => select(downloadTable).get();

  Stream<List<DownloadTableData>> getAllStream() =>
      select(downloadTable).watch();

  Future<List<DownloadTableData>> getUnfinished() => (select(downloadTable)
        ..where((tbl) =>
            tbl.status.equals(DownloadStatus.PENDING) |
            tbl.status.equals(DownloadStatus.FAIL)))
      .get();

  Future<void> startDownload() => (update(downloadTable)
        ..where((tbl) => tbl.status.equals(DownloadStatus.FAIL)))
      .write(
          const DownloadTableCompanion(status: Value(DownloadStatus.PENDING)));

  Future<void> replace(DownloadTableData data) =>
      update(downloadTable).replace(data);

  Future<void> insert(DownloadTableCompanion data) =>
      into(downloadTable).insert(data);

  Future<void> remove(DownloadTableData data) =>
      delete(downloadTable).delete(data);

  Future<void> onWebsiteDelete(int id) => (update(downloadTable)
        ..where((tbl) =>
            tbl.websiteId.equals(id) &
            tbl.status.equals(DownloadStatus.PENDING)))
      .write(const DownloadTableCompanion(
          status: Value(DownloadStatus.UNREACHABLE)));
}
