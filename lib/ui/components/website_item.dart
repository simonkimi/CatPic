import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class WebsiteItem extends StatelessWidget {
  final Widget title;
  final Widget subtitle;
  final ImageProvider leadingImage;
  final Function onSettingPress;
  final Function onDeletePress;

  const WebsiteItem(
      {Key key,
      @required this.title,
      @required this.subtitle,
      @required this.leadingImage,
      @required this.onSettingPress,
      @required this.onDeletePress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Slidable(
        actionPane: SlidableDrawerActionPane(),
        actionExtentRatio: 0.25,
        child: ListTile(
          title: title,
          subtitle: subtitle,
          leading: CircleAvatar(
            backgroundImage: leadingImage,
            backgroundColor: Colors.white,
          ),
        ),
        secondaryActions: [
          IconSlideAction(
            caption: '设置',
            color: Theme.of(context).primaryColor,
            icon: Icons.settings,
            onTap: onSettingPress,
          ),
          IconSlideAction(
            caption: '删除',
            color: Colors.red,
            icon: Icons.delete,
            onTap: onDeletePress,
          ),
        ]);
  }
}
