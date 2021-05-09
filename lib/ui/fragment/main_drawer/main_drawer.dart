import 'package:catpic/network/adapter/booru_adapter.dart';
import 'package:catpic/data/database/database.dart';
import 'package:catpic/i18n.dart';
import 'package:catpic/themes.dart';
import 'package:catpic/ui/pages/download_page/download_manager.dart';
import 'package:catpic/ui/pages/login_page/login_page.dart';
import 'package:catpic/ui/pages/search_page/search_page.dart';
import 'package:catpic/ui/pages/setting_page/setting_page.dart';
import 'package:catpic/main.dart';
import 'package:catpic/ui/pages/website_manager/website_manager.dart';
import 'package:catpic/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

typedef SearchChange = bool Function(SearchType);

class MainDrawer extends StatefulWidget {
  const MainDrawer({
    Key? key,
    this.onSearchChange,
    this.type,
  }) : super(key: key);
  final SearchChange? onSearchChange;
  final SearchType? type;

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
        child: StreamBuilder<List<WebsiteTableData>>(
            stream: DatabaseHelper().websiteDao.getAllStream(),
            initialData: const [],
            builder: (context, snapshot) {
              return ListView(
                padding: EdgeInsets.zero,
                children: snapshot.data?.map((element) {
                      final scheme = getSchemeString(element.scheme);
                      ImageProvider? favicon;
                      if (element.favicon.isNotEmpty) {
                        favicon = MemoryImage(element.favicon);
                      }
                      return Builder(
                          key: Key('site${element.name}'),
                          builder: (context) => ListTile(
                                title: Text(element.name),
                                subtitle: Text('$scheme://${element.host}/'),
                                selected:
                                    mainStore.websiteEntity?.id == element.id,
                                leading: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  backgroundImage: favicon,
                                ),
                                onTap: () {
                                  pushNewWebsite(context, element);
                                },
                              ));
                    }).toList() ??
                    [],
              );
            }),
      ),
      const Divider(),
      ListTile(
        leading: const Icon(Icons.settings),
        title: Text(I18n.of(context).website_manager),
        onTap: () {
          Navigator.of(context).pop();
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => WebsiteManagerPage()));
        },
      )
    ];
  }

  List<Widget> buildMainMenu() {
    List<SupportPage>? support;
    if (mainStore.websiteEntity != null) {
      support =
          BooruAdapter.fromWebsite(mainStore.websiteEntity!).getSupportPage();
    }

    return [
      Expanded(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            if (support?.contains(SupportPage.POSTS) ?? false) buildPostTile(),
            if (support?.contains(SupportPage.FAVOURITE) ?? false)
              buildHotTile(),
            if (support?.contains(SupportPage.POOLS) ?? false) buildPoolTile(),
            if (support?.contains(SupportPage.TAGS) ?? false) buildTagTile(),
            if (support?.contains(SupportPage.ARTISTS) ?? false)
              buildArtistTile(),
          ],
        ),
      ),
      const Divider(),
      buildDownloadTile(),
      buildSettingTile()
    ];
  }

  ListTile buildSettingTile() {
    return ListTile(
      leading: const Icon(Icons.settings),
      title: Text(I18n.of(context).setting),
      onTap: () {
        Navigator.of(context).pop();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SettingPage()),
        );
      },
    );
  }

  ListTile buildDownloadTile() {
    return ListTile(
      leading: const Icon(Icons.download_rounded),
      title: Text(I18n.of(context).download),
      onTap: () {
        Navigator.of(context).pop();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DownloadManagerPage()),
        );
      },
    );
  }

  ListTile buildFavouriteTile() {
    return ListTile(
      leading: const Icon(Icons.favorite),
      title: Text(I18n.of(context).favourite),
      onTap: () async {
        final website = (await DatabaseHelper()
            .websiteDao
            .getById(mainStore.websiteEntity!.id))!;
        if (website.username != null) {
          Navigator.of(context).pop();
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return SearchPage(
              searchText: BooruAdapter.fromWebsite(website)
                  .favouriteList(website.username!),
              searchType: SearchType.FAVOURITE,
            );
          }));
        } else {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        }
      },
    );
  }

  ListTile buildArtistTile() {
    return ListTile(
      leading: const Icon(Icons.supervisor_account_sharp),
      title: Text(I18n.of(context).artist),
      selected: widget.type == SearchType.ARTIST,
      onTap: () {
        if (widget.onSearchChange?.call(SearchType.ARTIST) ?? true)
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) => const SearchPage(
                        searchType: SearchType.ARTIST,
                      )),
              (route) => false);
        else
          Navigator.of(context).pop();
      },
    );
  }

  ListTile buildTagTile() {
    return ListTile(
      leading: const Icon(Icons.tag),
      title: Text(I18n.of(context).tag),
      selected: widget.type == SearchType.TAGS,
      onTap: () {
        if (widget.onSearchChange?.call(SearchType.TAGS) ?? true)
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) => const SearchPage(
                        searchType: SearchType.TAGS,
                      )),
              (route) => false);
        else
          Navigator.of(context).pop();
      },
    );
  }

  ListTile buildPoolTile() {
    return ListTile(
      leading: const Icon(Icons.filter),
      title: Text(I18n.of(context).pools),
      selected: widget.type == SearchType.POOL,
      onTap: () {
        if (widget.onSearchChange?.call(SearchType.POOL) ?? true)
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) => const SearchPage(
                        searchType: SearchType.POOL,
                      )),
              (route) => false);
        else
          Navigator.of(context).pop();
      },
    );
  }

  ListTile buildHotTile() {
    return ListTile(
      leading: const Icon(Icons.whatshot),
      title: Text(I18n.of(context).hot),
      selected: widget.type == SearchType.FAVOURITE,
      onTap: () {
        Navigator.of(context).pop();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SearchPage(
              searchType: SearchType.HOT,
            ),
          ),
        );
      },
    );
  }

  ListTile buildPostTile() {
    return ListTile(
      leading: const Icon(Icons.image),
      title: Text(I18n.of(context).posts),
      selected: widget.type == SearchType.POST,
      onTap: () {
        if (widget.onSearchChange?.call(SearchType.POST) ?? true)
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const SearchPage()),
              (route) => false);
        else
          Navigator.of(context).pop();
      },
    );
  }

  Widget buildUserAccountsDrawerHeader() {
    var subTitle = I18n.of(context).no_website;
    if (mainStore.websiteEntity != null) {
      final scheme = getSchemeString(mainStore.websiteEntity!.scheme);
      subTitle = '$scheme://${mainStore.websiteEntity!.host}/';
    }
    return Observer(builder: (_) {
      return Theme(
          data: Theme.of(context).copyWith(
            primaryColor:
                isDarkMode(context) ? darkBlueTheme.primaryColorDark : null,
          ),
          child: UserAccountsDrawerHeader(
            accountName: Text(mainStore.websiteEntity?.name ?? 'CatPic'),
            accountEmail: Text(subTitle),
            currentAccountPicture: CircleAvatar(
              backgroundImage: mainStore.websiteIcon != null &&
                      mainStore.websiteIcon!.isNotEmpty
                  ? MemoryImage(mainStore.websiteIcon!)
                  : null,
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
                        pushNewWebsite(ctx, element);
                      },
                      child: CircleAvatar(
                        backgroundImage: element.favicon.isNotEmpty
                            ? MemoryImage(element.favicon)
                            : null,
                        backgroundColor: Colors.white,
                      )));
            }).toList(),
          ));
    });
  }

  Future<void> pushNewWebsite(
      BuildContext context, WebsiteTableData entity) async {
    Navigator.of(context).pop();
    await mainStore.setWebsite(entity);
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const SearchPage()),
      (route) => false,
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
