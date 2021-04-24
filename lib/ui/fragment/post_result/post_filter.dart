import 'dart:ui' as ui;
import 'package:catpic/ui/fragment/post_result/store/filter_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:catpic/ui/components/search_bar.dart';
import 'package:catpic/utils/utils.dart';

class PostFilter extends StatefulWidget {
  const PostFilter({
    Key? key,
    required this.controller,
    required this.store,
    required this.tmpController,
  }) : super(key: key);
  final FloatingSearchBarController controller;
  final SearchBarTmpController tmpController;
  final FilterStore store;

  @override
  _PostFilterState createState() => _PostFilterState();
}

class _PostFilterState extends State<PostFilter> {
  late final initTags =
      widget.store.searchText.trim().split(' ').where((e) => e.isNotEmpty);

  Widget buildTags() {
    final nowList = widget.store.searchText
        .trim()
        .split(' ')
        .where((e) => e.isNotEmpty)
        .toList();

    final mergedTag = <String>[].addAsSet(nowList).addAsSet(initTags);

    return Wrap(
      spacing: 5,
      children: mergedTag.map((e) {
        return FilterChip(
          key: ValueKey(e),
          selected: nowList.contains(e),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          label: Text(
            e,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w400,
            ),
          ),
          selectedColor: Theme.of(context).primaryColor,
          onSelected: (v) {
            if (v) {
              if (nowList.isNotEmpty && e.contains(nowList.last)) {
                nowList
                  ..removeLast()
                  ..add(e);
              } else {
                nowList.add(e);
              }
              widget.tmpController.tmp = nowList.join(' ');
              widget.store.setSearchText(nowList.join(' '));
            } else {
              nowList.removeWhere((element) => element == e);
              widget.tmpController.tmp = nowList.join(' ');
              widget.store.setSearchText(nowList.join(' '));
            }
          },
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final barHeight = MediaQueryData.fromWindow(ui.window).padding.top;
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(top: barHeight + 60, left: 4, right: 4),
          child: Card(
            child: Observer(builder: (_) {
              return ListView(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                children: [
                  buildTags(),
                ],
              );
            }),
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 18, right: 18),
            child: FloatingActionButton(
              onPressed: () {
                widget.tmpController.search();
              },
              child: const Icon(Icons.search),
            ),
          ),
        )
      ],
    );
  }
}
