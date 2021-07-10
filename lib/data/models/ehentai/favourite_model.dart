import 'package:catpic/data/models/gen/eh_storage.pb.dart';
import 'package:catpic/network/parser/ehentai/preview_parser.dart';

class EhFavouriteModel {
  EhFavouriteModel({
    required this.favourites,
    required this.previewModel,
  });

  final List<EhFavourite> favourites;
  final PreviewModel previewModel;
}
