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

  BoolColumn get onlyHost => boolean()();

  BoolColumn get directLink => boolean()();

  TextColumn get cookies => text().withDefault(const Constant(''))();

  BlobColumn get favicon =>
      blob().clientDefault(() => Uint8List.fromList([]))();

  TextColumn get username => text().nullable()();

  TextColumn get password => text().nullable()();

  IntColumn get lastOpen =>
      integer().clientDefault(() => DateTime.now().microsecond)();
}

enum WebsiteScheme {
  HTTP,
  HTTPS,
}

class WebsiteType {
  static const EHENTAI = 0;
  static const GELBOORU = 1;
  static const MOEBOORU = 2;
  static const DANBOORU = 3;
  static const UNKNOWN = -1;
}

extension WebsiteTypeName on int {
  String get string {
    switch (this) {
      case WebsiteType.EHENTAI:
        return 'EHentai';
      case WebsiteType.GELBOORU:
        return 'Gelbooru';
      case WebsiteType.MOEBOORU:
        return 'Moebooru';
      case WebsiteType.DANBOORU:
        return 'Danbooru';
      case WebsiteType.UNKNOWN:
      default:
        return 'Unknown';
    }
  }
}
