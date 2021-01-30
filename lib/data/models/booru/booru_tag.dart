enum BooruTagType {
  GENERAL,
  COPYRIGHT,
  ARTIST,
  CHARACTER,
  METADATA
}

class BooruTag {
  final String id;
  final int count;
  final String name;
  final BooruTagType type;

  BooruTag({this.id, this.count, this.name, this.type});
}

