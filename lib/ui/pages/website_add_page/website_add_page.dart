import 'package:catpic/data/database/entity/website_entity.dart';
import 'package:catpic/ui/components/setting/summary_tile.dart';
import 'package:catpic/ui/components/setting/text_input_tile.dart';
import 'package:flutter/material.dart';

class WebsiteAddPage extends StatefulWidget {
  @override
  _WebsiteAddPageState createState() => _WebsiteAddPageState();
}

class _WebsiteAddPageState extends State<WebsiteAddPage> {
  String websiteName;
  String websiteHost;
  int protocol;
  int websiteType;
  String trustHost;
  bool useDomainFronting;


  @override
  void initState() {
    super.initState();
    websiteName = "";
    websiteHost = "";
    protocol = WebsiteProtocol.HTTPS.index;
    websiteType = WebsiteType.GELBOORU.index;
    trustHost = "";
    useDomainFronting = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("添加网站"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {},
        ),
        actions: [IconButton(icon: Icon(Icons.check), onPressed: () {})],
      ),
      body: SafeArea(
        child: ListView(
          children: [
            SummaryTile("基础设置"),
            TextInputTile(
              title: Text("网站名称"),
              subtitle: Text(websiteName.isEmpty ? "example.org" : websiteName),
              leading: SizedBox(),
              onChanged: (value) {
                debugPrint(value);
              },
            ),
            Divider(),
            SummaryTile("网站设置"),
            TextInputTile(
              title: Text("主机"),
              subtitle: Text("example.org"),
              leading: Icon(Icons.home),
              hintText: "example.org",
              onChanged: (value) {
                debugPrint(value);
              },
            ),
            SwitchListTile(
              title: Text("协议"),
              subtitle: Text("使用更安全的HTTPS"),
              secondary: Icon(Icons.http),
              value: true,
              onChanged: (value) {},
            ),
            PopupMenuButton(
              itemBuilder: (context) => [
                PopupMenuItem(
                    child: Text("EHentai"), value: WebsiteType.EHENTAI.index),
                PopupMenuItem(
                    child: Text("Gelbooru"), value: WebsiteType.GELBOORU.index),
                PopupMenuItem(
                    child: Text("Moebooru"), value: WebsiteType.MOEBOORU.index),
                PopupMenuItem(
                    child: Text("Danbooru"), value: WebsiteType.DANBOORU.index),
              ],
              child: ListTile(
                title: Text("网站类型"),
                subtitle: Text("Ehentai"),
                leading: Icon(Icons.search),
              ),
            ),
            Divider(),
            SummaryTile("高级设置(可选)"),
            TextInputTile(
              leading: Icon(Icons.flag),
              title: Text("安全Host"),
              subtitle: Text("使用安全host来避免某些地区DNS污染"),
              onChanged: (value) {},
            ),
            ListTile(
              leading: Icon(Icons.autorenew_sharp),
              title: Text("自动获取可信Host"),
              onTap: () {

              },
            ),
            SwitchListTile(
              title: Text("域前置"),
              subtitle: Text("用于突破部分地区SNI封锁"),
              secondary: Icon(Icons.airplanemode_active_rounded),
              value: true,
              onChanged: (value) {},
            ),
          ],
        ),
      ),
    );
  }
}
