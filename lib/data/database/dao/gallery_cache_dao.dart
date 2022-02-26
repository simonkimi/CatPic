import 'package:catpic/data/database/entity/gallery_cache.dart';
import 'package:catpic/data/models/gen/eh_gallery.pb.dart';
import 'package:drift/drift.dart';

import '../database.dart';

part 'gallery_cache_dao.g.dart';

@DriftAccessor(tables: [GalleryCacheTable])
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

  Future<List<GalleryCacheTableData>> get(String gid, String gtoken) =>
      (select(galleryCacheTable)
            ..where((tbl) => tbl.gid.equals(gid) & tbl.token.equals(gtoken)))
          .get();

  Future<GalleryCacheTableData?> getByGid(String gid, String gtoken) =>
      (select(galleryCacheTable)
            ..where((tbl) => tbl.gid.equals(gid) & tbl.token.equals(gtoken)))
          .getSingleOrNull();

  Future<void> remove(String gid, String gtoken) => (delete(galleryCacheTable)
        ..where((tbl) => tbl.gid.equals(gid) & tbl.token.equals(gtoken)))
      .go();

  Future<void> replace(GalleryCacheTableData entity) =>
      update(galleryCacheTable).replace(entity);

  Future<void> updateFavcat(String gid, String gtoken, int favcat) async {
    final tableList = await get(gid, gtoken);
    for (final table in tableList) {
      await replace(table.copyWith(
        data: (GalleryModel.fromBuffer(table.data)..favcat = favcat)
            .writeToBuffer(),
      ));
    }
  }
}
