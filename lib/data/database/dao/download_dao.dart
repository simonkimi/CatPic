import 'package:catpic/data/database/database.dart';
import 'package:catpic/data/database/entity/download.dart';
import 'package:moor/moor.dart';

part 'download_dao.g.dart';

@UseDao(tables: [DownloadTable])
class DownloadDao extends DatabaseAccessor<AppDataBase>
    with _$DownloadDaoMixin {
  DownloadDao(attachedDatabase) : super(attachedDatabase);

  Future<List<DownloadTableData>> getAll() => select(downloadTable).get();

  Stream<List<DownloadTableData>> getAllStream() =>
      select(downloadTable).watch();

  Future<List<DownloadTableData>> getPending() => (select(downloadTable)
        ..where((tbl) => tbl.status.equals(DownloadStatus.PENDING)))
      .get();

  Future<void> replace(DownloadTableData data) =>
      update(downloadTable).replace(data);

  Future<void> insert(DownloadTableCompanion data) =>
      into(downloadTable).insert(data);

  Future<void> onWebsiteDelete(int id) =>
      (update(downloadTable)..where((tbl) => tbl.websiteId.equals(id)))
          .write(const DownloadTableCompanion(status: Value(DownloadStatus.UNREACHABLE)));
}
