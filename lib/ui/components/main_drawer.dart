import 'package:catpic/generated/l10n.dart';
import 'package:catpic/ui/pages/main_page/store/main_store.dart';
import 'package:catpic/ui/pages/website_manager/website_manager.dart';
import 'package:catpic/utils/misc_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class MainDrawer extends StatefulWidget {
  @override
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  bool showWebsiteList = false;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Observer(
        builder: (context) {
          return ListView(
            padding: EdgeInsets.zero,
            children: [
              buildUserAccountsDrawerHeader(),
              showWebsiteList ? buildWebsiteList() : buildMainMenu(),
            ],
          );
        },
      ),
    );
  }

  Widget buildWebsiteList() {
    return Column(
      key: Key("WebsiteList"),
      children: mainStore.websiteList.map((element) {
        var protocol = getProtocolString(element.protocol);
        ImageProvider favicon;
        if (element.favicon.isNotEmpty) {
          favicon = MemoryImage(element.favicon);
        }
        return ListTile(
          key: Key('site${element.name}'),
          title: Text(element.name),
          subtitle: Text('$protocol://${element.host}/'),
          selected: mainStore.websiteEntity?.id == element.id ?? false,
          leading: CircleAvatar(
            backgroundColor: Colors.white,
            backgroundImage: favicon,
          ),
          onTap: () {
            mainStore.setWebsite(element);
          },
        );
      }).toList()
        ..addAll([
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('网站设置'),
            onTap: () {
              Navigator.pushNamed(context, WebsiteManagerPage.routeName);
            },
          )
        ]),
    );
  }

  Widget buildMainMenu() {
    return Column(
      key: Key("MainMenu"),
      children: [
        ListTile(
          leading: Icon(Icons.home),
          title: Text('主页'),
          onTap: () {},
        ),
        ListTile(
          leading: Icon(Icons.local_fire_department),
          title: Text('热门'),
          onTap: () {},
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.favorite),
          title: Text('收藏'),
          onTap: () {},
        ),
        ListTile(
          leading: Icon(Icons.history),
          title: Text('历史'),
          onTap: () {},
        ),
        ListTile(
          leading: Icon(Icons.download_rounded),
          title: Text('下载'),
          onTap: () {},
        ),
        ListTile(
          leading: Icon(Icons.settings),
          title: Text('设置'),
          onTap: () {
            Navigator.pushNamed(context, WebsiteManagerPage.routeName);
          },
        )
      ],
    );
  }

  UserAccountsDrawerHeader buildUserAccountsDrawerHeader() {
    var subTitle = S.of(context).no_website;
    ImageProvider favicon;
    if (mainStore.websiteEntity != null) {
      var protocol = getProtocolString(mainStore.websiteEntity.protocol);
      subTitle = '$protocol://${mainStore.websiteEntity.host}/';
      if (mainStore.websiteEntity.favicon.isNotEmpty) {
        favicon = MemoryImage(mainStore.websiteEntity.favicon);
      }
    }

    return UserAccountsDrawerHeader(
      accountName: Text(mainStore.websiteEntity?.name ?? "CatPic"),
      accountEmail: Text(subTitle),
      currentAccountPicture: CircleAvatar(
        backgroundImage: favicon,
        backgroundColor: Colors.white,
      ),
      onDetailsPressed: () {
        setState(() {
          showWebsiteList = !showWebsiteList;
        });
      },
      otherAccountsPictures: mainStore.websiteList
          .where((e) => e.id != (mainStore.websiteEntity?.id ?? -1))
          .map((element) {
        return InkWell(
            onTap: () {
              mainStore.setWebsite(element);
            },
            child: CircleAvatar(
              backgroundImage: element.favicon.isNotEmpty
                  ? MemoryImage(element.favicon)
                  : null,
              backgroundColor: Colors.white,
            ));
      }).toList(),
    );
  }
}
