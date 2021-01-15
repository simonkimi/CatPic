
import 'package:catpic/data/database/entity/host_entity.dart';
import 'package:floor/floor.dart';

@dao
abstract class HostDao {
  @Query('SELECT * FROM HostEntity')
  Future<List<HostEntity>> getAll();

  @insert
  Future<int> addHost(HostEntity entity);

  @delete
  Future<void> removeHost(List<HostEntity> entities);

  @update
  Future<void> updateHost(HostEntity entity);

  @Query('SELECT * FROM HostEntity where host = :host')
  Future<HostEntity> getByHost(String host);
}