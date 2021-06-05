import 'package:catpic/data/database/entity/eh_translate.dart';
import 'package:moor/moor.dart';
import '../database.dart';

part 'translate_dao.g.dart';

@UseDao(tables: [EhTranslateTable])
class TranslateDao extends DatabaseAccessor<AppDataBase>
    with _$TranslateDaoMixin {
  TranslateDao(AppDataBase attachedDatabase) : super(attachedDatabase);

  Future<List<EhTranslateTableData>> getAll() => select(ehTranslateTable).get();

  Future<List<EhTranslateTableData>> getByTag(String value) =>
      (select(ehTranslateTable)
            ..where((tbl) =>
                tbl.name.like('%$value%') | tbl.translate.like('%$value%')))
          .get();

  Future<void> addTrList(List<EhTranslateTableCompanion> entities) async {
    await batch((batch) {
      batch.insertAll(ehTranslateTable, entities);
    });
  }

  Future<int> clear() => delete(ehTranslateTable).go();
}
