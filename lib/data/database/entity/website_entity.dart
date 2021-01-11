import 'package:floor/floor.dart';

/// 网站的类型
/// [id] 主键
/// [name] 网站昵称
/// [host] 网站host
/// [protocol] 协议, 来源于[WebsiteProtocol]
/// [type] 网站类型, 来源于[WebsiteType]
/// [trustHost] 可信host
/// [useDomainFronting] 是否使用域前置
@entity
class WebsiteEntity {
  @primaryKey
  final int id;

  final String name;
  final String host;
  final int protocol;
  final int type;

  final String trustHost;
  final bool useDomainFronting;

  final String cookies;


  WebsiteEntity({
    this.id,
    this.name,
    this.host,
    this.protocol,
    this.type,
    this.trustHost,
    this.useDomainFronting,
    this.cookies
  });
}

enum WebsiteProtocol { HTTP, HTTPS }

enum WebsiteType { EHENTAI, GELBOORU, MOEBOORU, DANBOORU }
