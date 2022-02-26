import 'package:catpic/data/database/database.dart';
import 'package:catpic/data/database/entity/eh_gallery_preview_img_cache.dart';
import 'package:drift/drift.dart';

part 'eh_gallery_preview_img_dao.g.dart';

@DriftAccessor(tables: [EhGalleryPreviewImgCache])
class EhGalleryPreviewImageDao extends DatabaseAccessor<AppDataBase>
    with _$EhGalleryPreviewImageDaoMixin {
  EhGalleryPreviewImageDao(AppDataBase attachedDatabase)
      : super(attachedDatabase);
}
