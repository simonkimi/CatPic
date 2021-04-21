import 'package:catpic/data/database/database.dart';
import 'package:catpic/i18n.dart';
import 'package:catpic/ui/components/website_item.dart';
import 'package:catpic/ui/pages/website_add_page/website_add_page.dart';
import 'package:catpic/utils/utils.dart';
import 'package:flutter/material.dart';

class WebsiteManagerPage extends StatelessWidget {
  static const route = 'WebsiteManagerPage';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildWebsiteList(),
      appBar: buildAppBar(context),
      floatingActionButton: buildFloatingActionButton(context),
    );
  }

  FloatingActionButton buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WebsiteAddPage(),
            ));
      },
      child: const Icon(Icons.add),
      backgroundColor: Theme
          .of(context)
          .primaryColor,
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios,
          size: 18,
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
        tooltip: I18n
            .of(context)
            .back,
      ),
      title: Text(
        I18n
            .of(context)
            .website_manager,
        style: const TextStyle(fontSize: 18),
      ),
    );
  }

  Widget _buildWebsiteList() {
    return StreamBuilder<List<WebsiteTableData>>(
        stream: DatabaseHelper().websiteDao.getAllStream(),
        builder: (context, s) {
          return ListView(
            children: s.data?.map((e) {
              final title = e.name;
              final scheme = getSchemeString(e.scheme);
              final subTitle = '$scheme://${e.host}/';
              ImageProvider? favIcon;
              if (e.favicon.isNotEmpty) {
                favIcon = MemoryImage(e.favicon);
              }
              return WebsiteItem(
                key: Key('website-$title'),
                title: Text(title),
                subtitle: Text(subTitle),
                leadingImage: favIcon,
                onDeletePress: () {
                  DatabaseHelper().websiteDao.remove(e);
                  DatabaseHelper().downloadDao.onWebsiteDelete(e.id);
                },
                onSettingPress: () {},
              );
            }).toList() ??
                [],
          );
        });
  }
}
