import 'dart:async';

import 'package:catpic/data/database/database_helper.dart';
import 'package:catpic/data/database/entity/website_entity.dart';
import 'package:catpic/generated/l10n.dart';
import 'package:catpic/ui/components/website_item.dart';
import 'package:catpic/ui/pages/website_add_page/website_add_page.dart';
import 'package:catpic/utils/event_util.dart';
import 'package:catpic/utils/misc_util.dart';
import 'package:flutter/material.dart';

import 'package:catpic/router.dart';

class WebsiteManagerPage extends StatefulWidget {
  static String routeName = 'WebsiteManager';

  @override
  _WebsiteManagerState createState() => _WebsiteManagerState();
}

class _WebsiteManagerState extends State<WebsiteManagerPage> {
  final eventBus = EventBusUtil().bus;
  StreamSubscription<EventSiteChange> _eventSiteChangeListener;
  List<WebsiteEntity> websiteList;

  @override
  void initState() {
    super.initState();
    debugPrint('WebsiteManagerPage initState');
    updateWebsiteList();
    _eventSiteChangeListener = eventBus.on<EventSiteChange>().listen((event) {
      updateWebsiteList();
    });
  }

  void updateWebsiteList() {
    final websiteDao = DatabaseHelper().websiteDao;
    websiteDao.getAll().then((value) {
      setState(() {
        websiteList = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: buildWebsiteList(),
        ),
      ),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
          tooltip: S.of(context).back,
        ),
        title: Text(S.of(context).website_manager),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          MyRouteDelegate.of(context).push(
            CatPicPage(
              key: const ValueKey('WebsiteAddPage'),
              name: '/WebsiteAddPage',
              builder: (ctx) => WebsiteAddPage(),
            ),
          );
        },
        child: const Icon(Icons.add),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

  List<Widget> buildWebsiteList() {
    return websiteList?.map((e) {
          final title = e.name;
          final scheme = getSchemeString(e.scheme);
          final subTitle = '$scheme://${e.host}/';
          ImageProvider favIcon;
          if (e.favicon.isNotEmpty) {
            favIcon = MemoryImage(e.favicon);
          }
          return WebsiteItem(
            key: Key('website-$title'),
            title: Text(title),
            subtitle: Text(subTitle),
            leadingImage: favIcon,
            onDeletePress: () {
              final websiteDao = DatabaseHelper().websiteDao;
              websiteDao.removeSite([e]).then((value) {
                EventBusUtil().bus.fire(EventSiteChange());
              });
            },
            onSettingPress: () {},
          );
        })?.toList() ??
        [];
  }

  @override
  void dispose() {
    super.dispose();
    debugPrint('WebsiteManagerPage dispose');
    _eventSiteChangeListener.cancel();
  }
}
