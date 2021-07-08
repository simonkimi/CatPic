import 'package:catpic/data/database/entity/gallery_cache.dart';
import 'package:moor/moor.dart';

import '../database.dart';

part 'gallery_cache_dao.g.dart';

@UseDao(tables: [GalleryCacheTable])
class GalleryCacheDao extends DatabaseAccessor<AppDataBase>
    with _$GalleryCacheDaoMixin {
  GalleryCacheDao(AppDataBase attachedDatabase) : super(attachedDatabase);

  Future<int> insert(GalleryCacheTableCompanion entity) =>
      into(galleryCacheTable).insert(entity, mode: InsertMode.insertOrReplace);

  Future<void> clearCache() async {
    final int now = DateTime.now().millisecond - 30 * 24 * 60 * 60 * 1000;
    await (delete(galleryCacheTable)
          ..where((tbl) => tbl.cacheTime.isSmallerThanValue(now)))
        .go();
  }

  Future<GalleryCacheTableData?> get(String gid) =>
      (select(galleryCacheTable)..where((tbl) => tbl.gid.equals(gid)))
          .getSingleOrNull();
}
