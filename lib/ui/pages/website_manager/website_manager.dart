import 'package:catpic/data/database/database_helper.dart';
import 'package:catpic/data/database/entity/website_entity.dart';
import 'package:catpic/generated/l10n.dart';
import 'package:catpic/ui/components/website_item.dart';
import 'package:catpic/ui/pages/host_manager_page/host_manager_page.dart';
import 'package:catpic/ui/pages/website_add_page/website_add_page.dart';
import 'package:catpic/utils/event_util.dart';
import 'package:catpic/utils/misc_util.dart';
import 'package:flutter/material.dart';

class WebsiteManagerPage extends StatefulWidget {
  static String routeName = 'WebsiteManager';

  @override
  _WebsiteManagerState createState() => _WebsiteManagerState();
}

class _WebsiteManagerState extends State<WebsiteManagerPage> {
  var eventBus = EventBusUtil().bus;
  List<WebsiteEntity> websiteList;

  @override
  void initState() {
    super.initState();
    updateWebsiteList();
    eventBus.on<EventSiteChange>().listen((event) {
      updateWebsiteList();
    });
  }

  void updateWebsiteList() {
    var websiteDao = DatabaseHelper().websiteDao;
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
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
          tooltip: S.of(context).back,
        ),
        title: Text(S.of(context).website_manager),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, WebsiteAddPage.routeName);
        },
        child: Icon(Icons.add),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

  List<Widget> buildWebsiteList() {
    return websiteList?.map((e) {
          var title = e.name;
          var scheme = getSchemeString(e.scheme);
          var subTitle = '$scheme://${e.host}/';
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
              var websiteDao = DatabaseHelper().websiteDao;
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
  }
}
