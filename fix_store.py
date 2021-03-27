with open('./lib/data/store/main/main_store.g.dart', 'r') as f:
    data = f.read()
    data = data.replace('List<dynamic> get websiteList', 'List<WebsiteTableData> get websiteList')
    data = data.replace('set websiteList(List<dynamic> value)', 'set websiteList(List<WebsiteTableData> value)')
    data = data.replace('dynamic get websiteEntity', 'WebsiteTableData? get websiteEntity')

with open('./lib/data/store/main/main_store.g.dart', 'w') as f:
    f.write(data)

print('success')