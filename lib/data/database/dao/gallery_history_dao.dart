import 'package:catpic/data/database/database.dart';
import 'package:catpic/data/database/entity/eh_gallery_historary.dart';
import 'package:drift/drift.dart';

part 'gallery_history_dao.g.dart';

@DriftAccessor(tables: [EhGalleryHistoryTable])
class GalleryHistoryDao extends DatabaseAccessor<AppDataBase>
    with _$GalleryHistoryDaoMixin {
  GalleryHistoryDao(AppDataBase attachedDatabase) : super(attachedDatabase);

  Stream<List<EhGalleryHistoryTableData>> all() =>
      (select(ehGalleryHistoryTable)
            ..orderBy([
              (u) => OrderingTerm(
                  expression: u.lastViewTime, mode: OrderingMode.desc)
            ]))
          .watch();

  Future<void> updateHistory(EhGalleryHistoryTableData entity) =>
      update(ehGalleryHistoryTable)
          .replace(entity..copyWith(lastViewTime: DateTime.now().millisecond));

  Future<void> add(EhGalleryHistoryTableCompanion entity) =>
      into(ehGalleryHistoryTable)
          .insert(entity, mode: InsertMode.insertOrReplace);
}
