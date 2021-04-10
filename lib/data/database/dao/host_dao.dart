import 'package:catpic/data/database/entity/host.dart';
import 'package:moor/moor.dart';
import '../database.dart';

part 'host_dao.g.dart';

@UseDao(tables: [HostTable])
class HostDao extends DatabaseAccessor<AppDataBase> with _$HostDaoMixin {
  HostDao(attachedDatabase) : super(attachedDatabase);

  Future<List<HostTableData>> getAll() => select(hostTable).get();

  Stream<List<HostTableData>> getAllStream() => select(hostTable).watch();

  Future<int> insert(HostTableCompanion entity) => into(hostTable).insert(entity);

  Future<int> remove(HostTableData entity) => delete(hostTable).delete(entity);

  Future<bool> updateHost(HostTableData entity) =>
      update(hostTable).replace(entity);

  Future<HostTableData?> getByHost(String host) =>
      (select(hostTable)..where((tbl) => tbl.host.equals(host)))
          .getSingleOrNull();
}
