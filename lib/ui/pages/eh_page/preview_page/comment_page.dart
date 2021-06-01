import 'package:catpic/ui/components/app_bar.dart';
import 'package:catpic/ui/pages/eh_page/components/eh_comment/eh_comment.dart';
import 'package:catpic/ui/pages/eh_page/preview_page/store/store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import 'package:catpic/i18n.dart';

class EhCommentPage extends StatelessWidget {
  const EhCommentPage({
    Key? key,
    required this.store,
  }) : super(key: key);

  final EhGalleryStore store;

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) {
      return Scaffold(appBar: buildAppBar(context), body: buildBody());
    });
  }

  Scrollbar buildBody() {
    return Scrollbar(
      showTrackOnHover: true,
      child: ListView.separated(
        padding: const EdgeInsets.only(bottom: 60),
        itemCount: store.commentList.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: EhComment(
              model: store.commentList[index],
              displayVote: true,
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return const Divider();
        },
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      leading: appBarBackButton(),
      centerTitle: true,
      title: Text(
        I18n.of(context).comment,
        style: const TextStyle(fontSize: 18, color: Colors.white),
      ),
    );
  }
}
