import 'package:catpic/data/database/entity/tag_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:catpic/data/database/database.dart';

void main() {
  test('检测自动补全', () async {
    TestWidgetsFlutterBinding.ensureInitialized();

    final database = await $FloorAppDatabase
        .inMemoryDatabaseBuilder()
        .build();

    final tagDao = database.tagDao;

    await tagDao.addTag(TagEntity(tag: 'huge_breasts', website: 1));

    await tagDao.addTag(TagEntity(tag: 'huge_breasts', website: 1));

    await tagDao.addTag(TagEntity(tag: 'big_breasts', website: 1));

    await tagDao.addTag(TagEntity(tag: 'big_penis', website: 1));

    final data = await tagDao.getStart(1, 'big_%');

    // await tagDao.deleteAll();

    print(data.map((e) => e.tag));
  });
}
