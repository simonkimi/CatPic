import 'package:catpic/data/database/entity/website.dart';
import 'package:drift/drift.dart';
import '../database.dart';

part 'website_dao.g.dart';

@DriftAccessor(tables: [WebsiteTable])
class WebsiteDao extends DatabaseAccessor<AppDataBase> with _$WebsiteDaoMixin {
  WebsiteDao(AppDataBase attachedDatabase) : super(attachedDatabase);

  Future<List<WebsiteTableData>> getAll() => select(websiteTable).get();

  Future<WebsiteTableData?> getById(int id) =>
      (select(websiteTable)..where((tbl) => tbl.id.equals(id)))
          .getSingleOrNull();

  Stream<List<WebsiteTableData>> getAllStream() => (select(websiteTable)
        ..orderBy([
          (u) => OrderingTerm(expression: u.lastOpen, mode: OrderingMode.desc)
        ]))
      .watch();

  Future<int> insert(WebsiteTableCompanion data) =>
      into(websiteTable).insert(data);

  Future<void> remove(WebsiteTableData data) =>
      delete(websiteTable).delete(data);

  Future<void> replace(WebsiteTableData data) =>
      update(websiteTable).replace(data);
}
