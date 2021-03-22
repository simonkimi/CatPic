import 'package:floor/floor.dart';

@Entity(tableName: 'TagEntity')
class TagEntity {
  TagEntity({
    required this.website,
    required this.tag,
  });

  @PrimaryKey()
  final String tag;

  final int website;
}
