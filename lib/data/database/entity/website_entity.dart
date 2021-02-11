import 'dart:typed_data';

import 'package:catpic/data/adapter/booru_adapter.dart';
import 'package:catpic/data/adapter/gelbooru_adapter.dart';
import 'package:catpic/data/adapter/moebooru_adapter.dart';
import 'package:floor/floor.dart';
import 'package:flutter/material.dart';

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
  WebsiteEntity({
    this.id,
    @required this.name,
    @required this.host,
    @required this.scheme,
    @required this.type,
    @required this.useDoH,
    @required this.favicon,
    @required this.directLink,
    this.cookies,
  });

  @PrimaryKey(autoGenerate: true)
  final int id;

  final String name;
  final String host;
  final int scheme;
  final int type;

  final bool useDoH;
  final bool directLink;

  final String cookies;

  Uint8List favicon;

  BooruAdapter getAdapter() {
    if (type == WebsiteType.GELBOORU.index) {
      return GelbooruAdapter(this);
    } else if (type == WebsiteType.MOEBOORU.index) {
      return MoebooruAdapter(this);
    }
    // TODO(me): Danbooru Adapter
    throw Exception('TODO Danbooru Adapter');
  }
}

enum WebsiteScheme { HTTP, HTTPS }

enum WebsiteType { EHENTAI, GELBOORU, MOEBOORU, DANBOORU }

Map<int, String> websiteTypeName = {
  WebsiteType.EHENTAI.index: 'EHentai',
  WebsiteType.GELBOORU.index: 'Gelbooru',
  WebsiteType.MOEBOORU.index: 'Moebooru',
  WebsiteType.DANBOORU.index: 'Danbooru',
};
