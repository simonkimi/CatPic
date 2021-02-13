import 'package:floor/floor.dart';

@Entity(tableName: 'TagEntity')
class TagEntity {
  TagEntity({
    this.website,
    this.tag,
  });


  @PrimaryKey()
  final String tag;

  final int website;
}
