import 'package:floor/floor.dart';
import 'package:flutter/cupertino.dart';

@Entity(tableName: 'HostEntity')
class HostEntity {
  HostEntity({
    this.id,
    @required this.host,
    @required this.ip,
    @required this.sni,
  });

  @PrimaryKey(autoGenerate: true)
  final int id;

  final String host;
  final String ip;
  final bool sni;
}
