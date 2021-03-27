import 'package:catpic/data/database/entity/tag.dart';
import 'package:moor/moor.dart';
import '../database.dart';

part 'tag_dao.g.dart';

@UseDao(tables: [TagTable])
class TagDao extends DatabaseAccessor<AppDataBase> with _$TagDaoMixin {
  TagDao(attachedDatabase) : super(attachedDatabase);

  Future<List<TagTableData>> getAll() => select(tagTable).get();

  Future<void> insert(TagTableCompanion entity) =>
      into(tagTable).insert(entity, mode: InsertMode.insertOrIgnore);

  Future<List<TagTableData>> getStart(int website, String tag) async {
    return (select(tagTable)
          ..where(
              (tbl) => tbl.website.equals(website) & tbl.tag.like('%$tag%')))
        .get();
  }
}
