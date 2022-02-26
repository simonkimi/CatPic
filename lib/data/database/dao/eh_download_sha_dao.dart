import 'package:catpic/data/database/database.dart';
import 'package:catpic/data/database/entity/eh_image_sha.dart';
import 'package:drift/drift.dart';

part 'eh_download_sha_dao.g.dart';

@DriftAccessor(tables: [EhDownloadShaTable])
class EhDownloadShaDao extends DatabaseAccessor<AppDataBase>
    with _$EhDownloadShaDaoMixin {
  EhDownloadShaDao(AppDataBase attachedDatabase) : super(attachedDatabase);

  Future<void> add(EhDownloadShaTableCompanion entity) =>
      into(ehDownloadShaTable).insert(entity);

  Future<void> remove(EhDownloadShaTableData entity) =>
      delete(ehDownloadShaTable).delete(entity);

  Future<List<EhDownloadShaTableData>> get(String sha) =>
      (select(ehDownloadShaTable)..where((tbl) => tbl.sha.equals(sha))).get();
}
