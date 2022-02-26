import 'package:catpic/data/database/database.dart';
import 'package:catpic/data/database/entity/eh_image_cache.dart';
import 'package:drift/drift.dart';

part 'eh_image_dao.g.dart';

@DriftAccessor(tables: [EhImageCache])
class EhImageDao extends DatabaseAccessor<AppDataBase> with _$EhImageDaoMixin {
  EhImageDao(AppDataBase attachedDatabase) : super(attachedDatabase);

  Future<int> insert(EhImageCacheCompanion entity) =>
      into(ehImageCache).insert(entity, mode: InsertMode.insertOrReplace);

  Future<void> clearCache() async {
    final int now = DateTime.now().millisecond - 30 * 24 * 60 * 60 * 1000;
    await (delete(ehImageCache)
          ..where((tbl) => tbl.lastViewTime.isSmallerThanValue(now)))
        .go();
  }

  Future<EhImageCacheData?> get(String gid, String shaToken, int page) async {
    final model = await (select(ehImageCache)
          ..where((tbl) =>
              tbl.gid.equals(gid) &
              tbl.shaToken.equals(shaToken) &
              tbl.page.equals(page)))
        .getSingleOrNull();
    if (model != null &&
        model.lastViewTime <
            DateTime.now().millisecond - 30 * 24 * 60 * 60 * 1000) return null;
    return model;
  }
}
