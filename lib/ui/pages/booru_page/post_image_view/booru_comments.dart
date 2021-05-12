import 'package:catpic/network/adapter/booru_adapter.dart';
import 'package:catpic/ui/components/app_bar.dart';
import 'package:catpic/ui/pages/booru_page/post_image_view/store/comment_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';

import 'package:catpic/i18n.dart';

class BooruCommentsPage extends StatelessWidget {
  BooruCommentsPage({
    Key? key,
    required this.id,
    required this.adapter,
  })   : store = CommentStore(id: id, adapter: adapter),
        super(key: key);

  final String id;
  final BooruAdapter adapter;
  final CommentStore store;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: buildBody(context),
    );
  }

  SafeArea buildBody(BuildContext context) {
    return SafeArea(
      child: Observer(
        builder: (BuildContext context) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: store.isLoading ? buildLoading() : buildCommentList(context),
          );
        },
      ),
    );
  }

  Widget buildEmpty(BuildContext context) {
    return GestureDetector(
      onTap: store.load,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              child: SvgPicture.asset(
                'assets/svg/empty.svg',
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              I18n.of(context).search_empty,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildLoading() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget buildCommentList(BuildContext context) {
    return store.commentList.isEmpty
        ? buildEmpty(context)
        : ListView.builder(
            itemBuilder: commentBuilder,
            itemCount: store.commentList.length,
          );
  }

  Widget commentBuilder(BuildContext context, int index) {
    final comments = store.commentList[index];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                comments.creator,
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const Expanded(child: SizedBox()),
              Text(
                comments.createAt,
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Text(comments.body),
              )
            ],
          ),
          const SizedBox(height: 8),
          const Divider(height: 1.0),
        ],
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        '# $id',
        style: const TextStyle(fontSize: 18, color: Colors.white),
      ),
      centerTitle: true,
      leading: appBarBackButton(),
    );
  }
}
