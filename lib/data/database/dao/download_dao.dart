import 'package:catpic/data/database/database.dart';
import 'package:catpic/data/database/entity/download.dart';
import 'package:moor/moor.dart';

part 'download_dao.g.dart';

@UseDao(tables: [DownloadTable])
class DownloadDao extends DatabaseAccessor<AppDataBase>
    with _$DownloadDaoMixin {
  DownloadDao(attachedDatabase) : super(attachedDatabase);

  Future<List<DownloadTableData>> getAll() => select(downloadTable).get();

  Future<void> insert(DownloadTableCompanion data) =>
      into(downloadTable).insert(data);
}
