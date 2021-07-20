import 'package:catpic/data/database/database.dart';
import 'package:catpic/data/database/entity/eh_gallery_preview_img_cache.dart';
import 'package:catpic/data/database/entity/eh_image_cache.dart';
import 'package:moor/moor.dart';

part 'eh_image_dao.g.dart';

@UseDao(tables: [EhImageCache])
class EhImageDao extends DatabaseAccessor<AppDataBase> with _$EhImageDaoMixin {
  EhImageDao(AppDataBase attachedDatabase) : super(attachedDatabase);
}
