import 'dart:typed_data';

import 'package:floor/floor.dart';
import 'package:flutter/cupertino.dart';

/// 网站的类型
/// [id] 主键
/// [name] 网站昵称
/// [host] 网站host
/// [protocol] 协议, 来源于[WebsiteProtocol]
/// [type] 网站类型, 来源于[WebsiteType]
/// [trustHost] 可信host
/// [useDomainFronting] 是否使用域前置

@Entity(tableName: 'WebsiteEntity')
class WebsiteEntity {
  @PrimaryKey(autoGenerate: true)
  final int id;

  final String name;
  final String host;
  final int protocol;
  final int type;

  final bool useHostList;
  final bool useDomainFronting;

  final String cookies;

  final bool extendLayout;
  final bool displayOriginal;

  Uint8List favicon;

  WebsiteEntity({
    this.id,
    @required this.name,
    @required this.host,
    @required this.protocol,
    @required this.type,
    @required this.useHostList,
    @required this.useDomainFronting,
    @required this.extendLayout,
    @required this.displayOriginal,
    @required this.favicon,
    this.cookies,
  });
}

enum WebsiteProtocol { HTTP, HTTPS }

enum WebsiteType { EHENTAI, GELBOORU, MOEBOORU, DANBOORU }

Map<int, String> websiteTypeName = {
  WebsiteType.EHENTAI.index: 'EHentai',
  WebsiteType.GELBOORU.index: 'Gelbooru',
  WebsiteType.MOEBOORU.index: 'Moebooru',
  WebsiteType.DANBOORU.index: 'Danbooru',
};
