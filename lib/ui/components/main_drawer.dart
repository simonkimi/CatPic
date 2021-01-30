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
          return Column(
            // padding: EdgeInsets.zero,
            children: [
              buildUserAccountsDrawerHeader(),
              buildBody(),
            ],
          );
        },
      ),
    );
  }

  Expanded buildBody() {
    return Expanded(
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 200),
        child: Column(
          key: Key(showWebsiteList ? 'WebsiteList' : 'MainMenu'),
          children: showWebsiteList ? buildWebsiteList() : buildMainMenu(),
        ),
      ),
    );
  }


  List<Widget> buildWebsiteList() {
    return [
      Expanded(
        child: ListView(
          padding: EdgeInsets.zero,
          children: mainStore.websiteList.map((element) {
            var scheme = getSchemeString(element.scheme);
            ImageProvider favicon;
            if (element.favicon.isNotEmpty) {
              favicon = MemoryImage(element.favicon);
            }
            return ListTile(
              key: Key('site${element.name}'),
              title: Text(element.name),
              subtitle: Text('$scheme://${element.host}/'),
              selected: mainStore.websiteEntity?.id == element.id ?? false,
              leading: CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage: favicon,
              ),
              onTap: () {
                // mainStore.setWebsite(element);
              },
            );
          }).toList(),
        ),
      ),
      Divider(),
      ListTile(
        leading: Icon(Icons.settings),
        title: Text(S.of(context).website_manager),
        onTap: () {
          Navigator.pushNamed(context, WebsiteManagerPage.routeName);
        },
      )
    ];
  }

  List<Widget> buildMainMenu() {
    return [
      Expanded(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            ListTile(
              leading: Icon(Icons.home),
              title: Text(S.of(context).home),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.local_fire_department),
              title: Text(S.of(context).hot),
              onTap: () {},
            ),
            // Expanded(child: null),
            ListTile(
              leading: Icon(Icons.favorite),
              title: Text(S.of(context).favourite),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.history),
              title: Text(S.of(context).history),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.download_rounded),
              title: Text(S.of(context).download),
              onTap: () {},
            ),
          ],
        ),
      ),
      Divider(),
      ListTile(
        leading: Icon(Icons.settings),
        title: Text(S.of(context).setting),
        onTap: () {},
      )
    ];
  }

  UserAccountsDrawerHeader buildUserAccountsDrawerHeader() {
    var subTitle = S.of(context).no_website;
    ImageProvider favicon;
    if (mainStore.websiteEntity != null) {
      var scheme = getSchemeString(mainStore.websiteEntity.scheme);
      subTitle = '$scheme://${mainStore.websiteEntity.host}/';
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
              // mainStore.setWebsite(element);
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
