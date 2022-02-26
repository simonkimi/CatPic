import 'package:catpic/data/database/entity/tag.dart';
import 'package:drift/drift.dart';
import '../database.dart';

part 'tag_dao.g.dart';

@DriftAccessor(tables: [TagTable])
class TagDao extends DatabaseAccessor<AppDataBase> with _$TagDaoMixin {
  TagDao(AppDataBase attachedDatabase) : super(attachedDatabase);

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
