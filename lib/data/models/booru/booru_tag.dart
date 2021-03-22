enum BooruTagType { GENERAL, COPYRIGHT, ARTIST, CHARACTER, METADATA }

class BooruTag {
  BooruTag({
    required this.id,
    required this.count,
    required this.name,
    required this.type,
  });

  final String id;
  final int count;
  final String name;
  final BooruTagType type;
}
