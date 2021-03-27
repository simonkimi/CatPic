import 'package:moor/moor.dart';

/// 网站的类型
/// [id] 主键
/// [name] 网站昵称
/// [host] 网站host
/// [scheme] 协议, 来源于[WebsiteScheme]
/// [type] 网站类型, 来源于[WebsiteType]
/// [cookies] cookies
class WebsiteTable extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();

  TextColumn get host => text()();

  IntColumn get scheme => integer()();

  IntColumn get type => integer()();

  BoolColumn get useDoH => boolean()();

  BoolColumn get directLink => boolean()();

  TextColumn get cookies => text().nullable()();

  BlobColumn get favicon => blob().nullable()();
}

enum WebsiteScheme { HTTP, HTTPS }

enum WebsiteType { EHENTAI, GELBOORU, MOEBOORU, DANBOORU }

Map<int, String> websiteTypeName = {
  WebsiteType.EHENTAI.index: 'EHentai',
  WebsiteType.GELBOORU.index: 'Gelbooru',
  WebsiteType.MOEBOORU.index: 'Moebooru',
  WebsiteType.DANBOORU.index: 'Danbooru',
};
