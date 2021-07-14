import 'package:moor/moor.dart';

class EhDownloadTable extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get createTime =>
      integer().clientDefault(() => DateTime.now().millisecond)();

  IntColumn get websiteId => integer()();

  IntColumn get status => integer()();

  IntColumn get pageTotal => integer()();

  IntColumn get pageDownload => integer()();

  TextColumn get gid => text()();

  TextColumn get gtoken => text()();

  BlobColumn get galleryPb => blob()();
}
