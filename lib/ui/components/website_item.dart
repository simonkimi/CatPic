import 'package:catpic/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class WebsiteItem extends StatelessWidget {
  const WebsiteItem(
      {Key key,
      @required this.title,
      @required this.subtitle,
      @required this.leadingImage,
      @required this.onSettingPress,
      @required this.onDeletePress})
      : super(key: key);
  final Widget title;
  final Widget subtitle;
  final ImageProvider leadingImage;
  final Function onSettingPress;
  final Function onDeletePress;

  @override
  Widget build(BuildContext context) {
    return Slidable(
        actionPane: const SlidableDrawerActionPane(),
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
            caption: S.of(context).setting,
            color: Theme.of(context).primaryColor,
            icon: Icons.settings,
            onTap: onSettingPress,
          ),
          IconSlideAction(
            caption: S.of(context).delete,
            color: Colors.red,
            icon: Icons.delete,
            onTap: onDeletePress,
          ),
        ]);
  }
}
