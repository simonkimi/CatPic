import 'package:catpic/data/database/database.dart';
import 'package:catpic/data/database/entity/eh_gallery_historary.dart';
import 'package:moor/moor.dart';

part 'gallery_history_dao.g.dart';

@UseDao(tables: [EhGalleryHistoryTable])
class GalleryHistoryDao extends DatabaseAccessor<AppDataBase>
    with _$GalleryHistoryDaoMixin {
  GalleryHistoryDao(AppDataBase attachedDatabase) : super(attachedDatabase);

  Stream<List<EhGalleryHistoryTableData>> all() =>
      select(ehGalleryHistoryTable).watch();

  Future<void> updateHistory(EhGalleryHistoryTableData entity) =>
      update(ehGalleryHistoryTable)
          .replace(entity..copyWith(lastViewTime: DateTime.now().millisecond));

  Future<void> add(EhGalleryHistoryTableCompanion entity) =>
      into(ehGalleryHistoryTable)
          .insert(entity, mode: InsertMode.insertOrReplace);
}
