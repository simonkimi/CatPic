import 'package:catpic/data/models/gen/eh_storage.pb.dart';
import 'package:html/parser.dart' as parser;
import 'package:catpic/utils/utils.dart';

class EhFavouriteParser {
  static void parse(String html) {
    final document = parser.parse(html).body!;
    final favList = document.querySelectorAll('.fp:not(.fps)');
    final re = RegExp(r'favcat=(\d)');
    final favourite = favList.map((e) => EhFavourite(
          count: e.children[0].text.toInt(),
          tag: e.children.last.text,
          favcat: re.firstMatch(e.attributes['onclick']!)![1]!.toInt(),
        ));

    print(favourite);
  }
}
