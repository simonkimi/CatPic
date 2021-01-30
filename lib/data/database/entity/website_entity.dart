import 'dart:typed_data';

import 'package:floor/floor.dart';
import 'package:flutter/cupertino.dart';

/// 网站的类型
/// [id] 主键
/// [name] 网站昵称
/// [host] 网站host
/// [scheme] 协议, 来源于[WebsiteScheme]
/// [type] 网站类型, 来源于[WebsiteType]
/// [useHostList] 是否使用host列表
/// [cookies] cookies
/// [extendLayout] 是否使用详细布局
/// [displayOriginal] 详情页面显示大图
@Entity(tableName: 'WebsiteEntity')
class WebsiteEntity {
  @PrimaryKey(autoGenerate: true)
  final int id;

  final String name;
  final String host;
  final int scheme;
  final int type;

  final bool useHostList;
  final String cookies;

  Uint8List favicon;

  WebsiteEntity({
    this.id,
    @required this.name,
    @required this.host,
    @required this.scheme,
    @required this.type,
    @required this.useHostList,
    @required this.favicon,
    this.cookies,
  });
}

enum WebsiteScheme { HTTP, HTTPS }

enum WebsiteType { EHENTAI, GELBOORU, MOEBOORU, DANBOORU }

Map<int, String> websiteTypeName = {
  WebsiteType.EHENTAI.index: 'EHentai',
  WebsiteType.GELBOORU.index: 'Gelbooru',
  WebsiteType.MOEBOORU.index: 'Moebooru',
  WebsiteType.DANBOORU.index: 'Danbooru',
};
