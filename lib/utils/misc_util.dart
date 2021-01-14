import 'package:catpic/data/database/entity/website_entity.dart';

String getProtocolString(int protocol) {
  if (protocol == null) return null;
  return protocol == WebsiteProtocol.HTTP.index ? 'http' : 'https';
}
