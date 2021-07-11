import 'package:catpic/data/database/entity/website.dart';
import 'package:catpic/network/adapter/booru_adapter.dart';
import 'package:catpic/data/database/database.dart';
import 'package:catpic/i18n.dart';
import 'package:catpic/themes.dart';
import 'package:catpic/ui/pages/booru_page/download_page/download_manager.dart';
import 'package:catpic/ui/pages/booru_page/login_page/login_page.dart';
import 'package:catpic/ui/pages/eh_page/eh_page.dart';
import 'package:catpic/ui/pages/booru_page/result/booru_result_page.dart';
import 'package:catpic/ui/pages/eh_page/favourite_page/favourite_page.dart';
import 'package:catpic/ui/pages/eh_page/history_page/history_page.dart';
import 'package:catpic/ui/pages/setting_page/setting_page.dart';
import 'package:catpic/main.dart';
import 'package:catpic/ui/pages/website_manager/website_manager.dart';
import 'package:catpic/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

typedef SearchChange = bool Function(SearchType);

typedef EhSearchChange = bool Function(EHSearchType);

class MainDrawer extends HookWidget {
  const MainDrawer({
    Key? key,
    this.onSearchChange,
    this.boooruType,
    this.ehSearchType,
    this.onEHSearchChange,
  }) : super(key: key);
  final SearchChange? onSearchChange;
  final EhSearchChange? onEHSearchChange;
  final SearchType? boooruType;
  final EHSearchType? ehSearchType;

  @override
  Widget build(BuildContext context) {
    final showWebsiteList = useState(false);
    return Drawer(
      child: Observer(
        builder: (context) {
          return Column(
            children: [
              buildUserAccountsDrawerHeader(context, showWebsiteList),
              buildBody(context, showWebsiteList),
            ],
          );
        },
      ),
    );
  }

  Expanded buildBody(
      BuildContext context, ValueNotifier<bool> showWebsiteList) {
    return Expanded(
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: Column(
          key: Key(showWebsiteList.value ? 'WebsiteList' : 'MainMenu'),
          children: showWebsiteList.value
              ? buildWebsiteList(context)
              : buildMainMenu(context),
        ),
      ),
    );
  }

  List<Widget> buildWebsiteList(BuildContext context) {
    return [
      Expanded(
        child: StreamBuilder<List<WebsiteTableData>>(
            stream: DB().websiteDao.getAllStream(),
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

  List<Widget> buildMainMenu(BuildContext context) {
    Widget buildEhList() {
      return Expanded(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            buildEhIndex(context),
            buildEhWatched(context),
            buildEhPopular(context),
            buildEhFavourite(context),
            buildEhHistory(context),
          ],
        ),
      );
    }

    Widget buildBooruList() {
      List<SupportPage>? support;
      if (mainStore.websiteEntity != null) {
        support =
            BooruAdapter.fromWebsite(mainStore.websiteEntity!).getSupportPage();
      }
      return Expanded(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            if (support?.contains(SupportPage.POSTS) ?? false)
              buildPostTile(context),
            if (support?.contains(SupportPage.POPULAR) ?? false)
              buildPopularTile(context),
            if (support?.contains(SupportPage.POOLS) ?? false)
              buildPoolTile(context),
            if (support?.contains(SupportPage.TAGS) ?? false)
              buildTagTile(context),
            if (support?.contains(SupportPage.ARTISTS) ?? false)
              buildArtistTile(context),
            if (support?.contains(SupportPage.FAVOURITE) ?? false)
              buildFavouriteTile(context),
          ],
        ),
      );
    }

    return [
      if (mainStore.websiteEntity?.type != WebsiteType.EHENTAI)
        buildBooruList(),
      if (mainStore.websiteEntity?.type == WebsiteType.EHENTAI) buildEhList(),
      const Divider(),
      if (mainStore.websiteEntity?.type != WebsiteType.EHENTAI)
        buildDownloadTile(context),
      buildSettingTile(context)
    ];
  }

  ListTile buildEhIndex(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.home),
      title: Text(I18n.of(context).home),
      selected: ehSearchType == EHSearchType.INDEX,
      onTap: () {
        if (onEHSearchChange?.call(EHSearchType.INDEX) ?? true)
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) => const EhPage(
                        searchType: EHSearchType.INDEX,
                      )),
              (route) => false);
        else
          Navigator.of(context).pop();
      },
    );
  }

  ListTile buildEhFavourite(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.favorite),
      title: Text(I18n.of(context).favourite),
      selected: ehSearchType == EHSearchType.FAVOURITE,
      onTap: () {
        if (onEHSearchChange?.call(EHSearchType.FAVOURITE) ?? true) {
          Navigator.of(context).pop();
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const EhFavouritePage()),
          );
        } else {
          Navigator.of(context).pop();
        }
      },
    );
  }

  ListTile buildEhHistory(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.history_sharp),
      title: Text(I18n.of(context).history),
      selected: ehSearchType == EHSearchType.HISTORY,
      onTap: () {
        if (onEHSearchChange?.call(EHSearchType.HISTORY) ?? true) {
          Navigator.of(context).pop();
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const EhHistoryPage()),
          );
        } else {
          Navigator.of(context).pop();
        }
      },
    );
  }

  ListTile buildEhWatched(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.remove_red_eye_outlined),
      title: Text(I18n.of(context).watched),
      selected: ehSearchType == EHSearchType.WATCHED,
      onTap: () {
        if (onEHSearchChange?.call(EHSearchType.WATCHED) ?? true)
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) => const EhPage(
                        searchType: EHSearchType.WATCHED,
                      )),
              (route) => false);
        else
          Navigator.of(context).pop();
      },
    );
  }

  ListTile buildEhPopular(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.local_fire_department),
      title: Text(I18n.of(context).popular),
      selected: ehSearchType == EHSearchType.POPULAR,
      onTap: () {
        if (onEHSearchChange?.call(EHSearchType.POPULAR) ?? true)
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) => const EhPage(
                        searchType: EHSearchType.POPULAR,
                      )),
              (route) => false);
        else
          Navigator.of(context).pop();
      },
    );
  }

  ListTile buildSettingTile(BuildContext context) {
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

  ListTile buildDownloadTile(BuildContext context) {
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

  ListTile buildFavouriteTile(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.favorite),
      title: Text(I18n.of(context).favourite),
      onTap: () async {
        final website =
            (await DB().websiteDao.getById(mainStore.websiteEntity!.id))!;
        if (website.username != null) {
          Navigator.of(context).pop();
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return BooruPage(
              searchText: BooruAdapter.fromWebsite(website)
                  .favouriteList(website.username!),
              searchType: SearchType.FAVOURITE,
            );
          }));
        } else {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => BooruLoginPage()),
          );
        }
      },
    );
  }

  ListTile buildArtistTile(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.supervisor_account_sharp),
      title: Text(I18n.of(context).artist),
      selected: boooruType == SearchType.ARTIST,
      onTap: () {
        if (onSearchChange?.call(SearchType.ARTIST) ?? true)
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) => const BooruPage(
                        searchType: SearchType.ARTIST,
                      )),
              (route) => false);
        else
          Navigator.of(context).pop();
      },
    );
  }

  ListTile buildTagTile(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.tag),
      title: Text(I18n.of(context).tag),
      selected: boooruType == SearchType.TAGS,
      onTap: () {
        if (onSearchChange?.call(SearchType.TAGS) ?? true)
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) => const BooruPage(
                        searchType: SearchType.TAGS,
                      )),
              (route) => false);
        else
          Navigator.of(context).pop();
      },
    );
  }

  ListTile buildPoolTile(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.filter),
      title: Text(I18n.of(context).pools),
      selected: boooruType == SearchType.POOL,
      onTap: () {
        if (onSearchChange?.call(SearchType.POOL) ?? true)
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) => const BooruPage(
                        searchType: SearchType.POOL,
                      )),
              (route) => false);
        else
          Navigator.of(context).pop();
      },
    );
  }

  ListTile buildPopularTile(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.whatshot),
      title: Text(I18n.of(context).hot),
      selected: boooruType == SearchType.POPULAR,
      onTap: () {
        Navigator.of(context).pop();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const BooruPage(
              searchType: SearchType.POPULAR,
            ),
          ),
        );
      },
    );
  }

  ListTile buildPostTile(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.image),
      title: Text(I18n.of(context).posts),
      selected: boooruType == SearchType.POST,
      onTap: () {
        if (onSearchChange?.call(SearchType.POST) ?? true)
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const BooruPage()),
              (route) => false);
        else
          Navigator.of(context).pop();
      },
    );
  }

  Widget buildUserAccountsDrawerHeader(
      BuildContext context, ValueNotifier<bool> showWebsiteList) {
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
              showWebsiteList.value = !showWebsiteList.value;
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
    if (entity.type != WebsiteType.EHENTAI) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const BooruPage()),
        (route) => false,
      );
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const EhPage()),
        (route) => false,
      );
    }
  }
}
