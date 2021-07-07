// https://github.com/mobxjs/mobx.dart/issues/405
import 'dart:io';

final replace = <Map<String, String>>[
  {
    'raw': 'List<dynamic> get websiteList',
    'new': 'List<WebsiteTableData> get websiteList'
  },
  {
    'raw': 'set websiteList(List<dynamic> value)',
    'new': 'set websiteList(List<WebsiteTableData> value)'
  },
  {
    'raw': 'dynamic get websiteEntity',
    'new': 'WebsiteTableData? get websiteEntity'
  },
];

void main() {
  final file = File('./lib/data/store/main/main_store.g.dart');
  var fileString = file.readAsStringSync();
  for (final re in replace) {
    fileString = fileString.replaceAll(re['raw']!, re['new']!);
  }
  file.writeAsStringSync(fileString);
  print('replace dynamic success');
}
