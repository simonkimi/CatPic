import 'package:catpic/generated/l10n.dart';
import 'package:catpic/ui/store/main/main_store.dart';
import 'package:catpic/ui/pages/website_manager/website_manager.dart';
import 'package:catpic/utils/misc_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:catpic/router.dart';

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
        duration: const Duration(milliseconds: 200),
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
            final scheme = getSchemeString(element.scheme);
            ImageProvider favicon;
            if (element.favicon.isNotEmpty) {
              favicon = MemoryImage(element.favicon);
            }
            return Builder(
                key: Key('site${element.name}'),
                builder: (context) => ListTile(
                      subtitle: Text('$scheme://${element.host}/'),
                      selected:
                          mainStore.websiteEntity?.id == element.id ?? false,
                      leading: CircleAvatar(
                        backgroundColor: Colors.white,
                        backgroundImage: favicon,
                      ),
                      onTap: () {
                        Scaffold.of(context).openEndDrawer();
                        mainStore.setWebsite(element);
                      },
                    ));
          }).toList(),
        ),
      ),
      const Divider(),
      ListTile(
        leading: const Icon(Icons.settings),
        title: Text(S.of(context).website_manager),
        onTap: () {
          MyRouteDelegate.of(context).push(CatPicPage(
            builder: (ctx) => WebsiteManagerPage(),
          ));
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
              leading: const Icon(Icons.home),
              title: Text(S.of(context).home),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.local_fire_department),
              title: Text(S.of(context).hot),
              onTap: () {},
            ),
            // Expanded(child: null),
            ListTile(
              leading: const Icon(Icons.favorite),
              title: Text(S.of(context).favourite),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: Text(S.of(context).history),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.download_rounded),
              title: Text(S.of(context).download),
              onTap: () {},
            ),
          ],
        ),
      ),
      const Divider(),
      ListTile(
        leading: const Icon(Icons.settings),
        title: Text(S.of(context).setting),
        onTap: () {},
      )
    ];
  }

  Widget buildUserAccountsDrawerHeader() {
    var subTitle = S.of(context).no_website;
    ImageProvider favicon;
    if (mainStore.websiteEntity != null) {
      final scheme = getSchemeString(mainStore.websiteEntity.scheme);
      subTitle = '$scheme://${mainStore.websiteEntity.host}/';
      if (mainStore.websiteEntity.favicon.isNotEmpty) {
        favicon = MemoryImage(mainStore.websiteEntity.favicon);
      }
    }
    return UserAccountsDrawerHeader(
      accountName: Text(mainStore.websiteEntity?.name ?? 'CatPic'),
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
        return Builder(
            builder: (ctx) => InkWell(
                onTap: () {
                  mainStore.setWebsite(element);
                  Scaffold.of(ctx).openEndDrawer();
                },
                child: CircleAvatar(
                  backgroundImage: element.favicon.isNotEmpty
                      ? MemoryImage(element.favicon)
                      : null,
                  backgroundColor: Colors.white,
                )));
      }).toList(),
    );
  }

  @override
  void initState() {
    super.initState();
    print('MainDrawer initState');
  }

  @override
  void dispose() {
    super.dispose();
    print('MainDrawer dispose');
  }
}
