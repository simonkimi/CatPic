import 'package:moor/moor.dart';

class EhHistoryTable extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get galleryId => text()();

  TextColumn get galleryToken => text()();

  TextColumn get previewImg => text()();

  TextColumn get uploadTime => text()();

  IntColumn get pageNumber => integer()();

  IntColumn get star => integer()();

  IntColumn get readPage => integer()();

  TextColumn get uploader => text()();

  IntColumn get tag => integer()();

  IntColumn get lastOpen =>
      integer().clientDefault(() => DateTime.now().millisecond)();
}
