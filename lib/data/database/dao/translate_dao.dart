import 'package:catpic/data/database/entity/eh_translate.dart';
import 'package:moor/moor.dart';
import '../database.dart';

part 'translate_dao.g.dart';

@UseDao(tables: [EhTranslateTable])
class TranslateDao extends DatabaseAccessor<AppDataBase>
    with _$TranslateDaoMixin {
  TranslateDao(attachedDatabase) : super(attachedDatabase);
}
