import 'package:catpic/data/database/database_helper.dart';
import 'package:catpic/generated/l10n.dart';
import 'package:catpic/router/catpic_page.dart';
import 'package:catpic/router/route_delegate.dart';
import 'package:catpic/ui/components/website_item.dart';
import 'package:catpic/ui/pages/website_add_page/website_add_page.dart';
import 'package:catpic/ui/store/main/main_store.dart';
import 'package:catpic/utils/event_util.dart';
import 'package:catpic/utils/misc_util.dart';
import 'package:flutter/material.dart';


import 'package:flutter_mobx/flutter_mobx.dart';

class WebsiteManagerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Observer(
        builder: (ctx) => SafeArea(
          child: ListView(
            children: buildWebsiteList(),
          ),
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
            CatPicPage(body: WebsiteAddPage()),
          );
        },
        child: const Icon(Icons.add),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

  List<Widget> buildWebsiteList() {
    return mainStore.websiteList.map((e) {
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
            EventBusUtil().bus.fire(EventSiteListChange());
          });
        },
        onSettingPress: () {},
      );
    }).toList();
  }
}
