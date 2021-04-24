import 'dart:ui' as ui;
import 'package:catpic/ui/fragment/post_result/store/filter_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';

class PostFilter extends StatelessWidget {
  const PostFilter({
    Key? key,
    required this.controller,
    required this.store,
  }) : super(key: key);
  final FloatingSearchBarController controller;
  final FilterStore store;

  @override
  Widget build(BuildContext context) {
    final barHeight = MediaQueryData.fromWindow(ui.window).padding.top;
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(top: barHeight + 60, left: 4, right: 4),
            child: Card(
              child: Observer(builder: (_) {
                return ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  children: [
                    Wrap(
                      spacing: 5,
                      children: store.searchText
                          .trim()
                          .split(' ')
                          .where((e) => e.isNotEmpty)
                          .map((e) {
                        return FilterChip(
                          key: ValueKey(e),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          label: Text(
                            e,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          backgroundColor: Theme.of(context).primaryColor,
                          onSelected: (v) {},
                        );
                      }).toList(),
                    )
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
                onPressed: () {},
                child: const Icon(Icons.search),
              ),
            ),
          )
        ],
      ),
    );
  }
}
