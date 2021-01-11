import 'package:catpic/ui/components/website_item.dart';
import 'package:flutter/material.dart';

class WebsiteManager extends StatefulWidget {
  @override
  _WebsiteManagerState createState() => _WebsiteManagerState();
}

class _WebsiteManagerState extends State<WebsiteManager> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            WebsiteItem(
              title: Text("E-Hentai"),
              subtitle: Text("https://e-hentai.org/"),
              leadingImage: AssetImage('assets/icons/efav.ico'),
              onDeletePress: () {},
              onSettingPress: () {},
            ),
          ],
        ),
      ),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {},
          tooltip: "返回",
        ),
        title: Text("网站管理"),
        actions: [

        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }
}
