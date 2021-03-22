import 'package:floor/floor.dart';
import 'package:flutter/material.dart';

@Entity(tableName: 'HostEntity')
class HostEntity {
  HostEntity({
    this.id,
    required this.host,
    required this.ip,
    required this.websiteId,
  });

  @PrimaryKey(autoGenerate: true)
  final int? id;

  final String host;
  final String ip;
  final int websiteId;
}
