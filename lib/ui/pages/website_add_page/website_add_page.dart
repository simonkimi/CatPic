import 'package:catpic/data/database/entity/website_entity.dart';
import 'package:catpic/generated/l10n.dart';
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
  bool domainFronting;

  @override
  void initState() {
    super.initState();
    websiteName = "";
    websiteHost = "";
    protocol = WebsiteProtocol.HTTPS.index;
    websiteType = WebsiteType.GELBOORU.index;
    trustHost = "";
    domainFronting = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).add_website),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {},
        ),
        actions: [IconButton(icon: Icon(Icons.check), onPressed: () {})],
      ),
      body: SafeArea(
        child: ListView(
          children: [
            SummaryTile(S.of(context).basic_settings),
            TextInputTile(
              title: Text(S.of(context).website_nickname),
              subtitle: Text(
                  websiteName.isEmpty ? S.of(context).not_set : websiteName),
              leading: SizedBox(),
              onChanged: (value) {
                setState(() {
                  websiteName = value;
                });
              },
            ),
            Divider(),
            SummaryTile(S.of(context).website_settings),
            TextInputTile(
              title: Text(S.of(context).host),
              subtitle: Text(
                  websiteHost.isEmpty ? S.of(context).not_set : websiteHost),
              leading: Icon(Icons.home),
              hintText: "example.org",
              onChanged: (value) {
                setState(() {
                  websiteHost = value;
                });
              },
            ),
            SwitchListTile(
              title: Text(S.of(context).protocol),
              subtitle: Text(S.of(context).protocol_https),
              secondary: Icon(Icons.http),
              value: protocol == WebsiteProtocol.HTTPS.index,
              onChanged: (value) {
                setState(() {
                  protocol = value
                      ? WebsiteProtocol.HTTPS.index
                      : WebsiteProtocol.HTTP.index;
                });
              },
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
                title: Text(S.of(context).site_type),
                subtitle: Text(websiteTypeName[websiteType]),
                leading: Icon(Icons.search),
              ),
              onSelected: (value) {
                setState(() {
                  websiteType = value;
                });
              },
            ),
            Divider(),
            SummaryTile(S.of(context).advanced_settings),
            TextInputTile(
              leading: Icon(Icons.flag),
              title: Text(S.of(context).trusted_host),
              subtitle: Text(trustHost.isEmpty
                  ? S.of(context).trusted_host_desc
                  : trustHost),
              onChanged: (value) {
                setState(() {
                  trustHost = value;
                });
              },
            ),
            ListTile(
              leading: Icon(Icons.autorenew_sharp),
              title: Text(S.of(context).trusted_host_auto),
              onTap: () {},
            ),
            SwitchListTile(
              title: Text(S.of(context).domain_fronting),
              subtitle: Text(S.of(context).domain_fronting_desc),
              secondary: Icon(Icons.airplanemode_active_rounded),
              value: domainFronting,
              onChanged: (value) {
                setState(() {
                  domainFronting = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
