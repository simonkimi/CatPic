import 'package:catpic/data/database/database.dart';
import 'package:catpic/data/database/entity/history.dart';
import 'package:catpic/data/models/ehentai/preview_model.dart';
import 'package:catpic/i18n.dart';
import 'package:catpic/main.dart';
import 'package:catpic/ui/components/search_bar.dart';
import 'package:catpic/ui/components/seelct_tile.dart';
import 'package:catpic/ui/components/select_button.dart';
import 'package:catpic/ui/components/tiny_switch_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:get/get.dart';

class EhCompleteBar extends StatefulWidget {
  const EhCompleteBar({
    Key? key,
    this.onSubmitted,
    required this.searchText,
    required this.body,
    this.controller,
  }) : super(key: key);

  final ValueChanged<String>? onSubmitted;
  final String searchText;
  final Widget body;
  final FloatingSearchBarController? controller;

  @override
  _EhCompleteBarState createState() => _EhCompleteBarState();
}

class _EhCompleteBarState extends State<EhCompleteBar> {
  late final FloatingSearchBarController searchBarController =
      widget.controller ?? FloatingSearchBarController();

  var searchSuggestion = <SearchSuggestion>[];

  var typeFilter = <EhGalleryType, Rx<bool>>{
    EhGalleryType.Doujinshi: true.obs,
    EhGalleryType.Manga: true.obs,
    EhGalleryType.Artist_CG: true.obs,
    EhGalleryType.Game_CG: true.obs,
    EhGalleryType.Western: true.obs,
    EhGalleryType.Non_H: true.obs,
    EhGalleryType.Image_Set: true.obs,
    EhGalleryType.Cosplay: true.obs,
    EhGalleryType.Asian_Porn: true.obs,
    EhGalleryType.Misc: true.obs,
  };

  @override
  Widget build(BuildContext context) {
    return SearchBar(
      controller: searchBarController,
      searchText: widget.searchText,
      onSubmitted: (value) {
        _setSearchHistory(value.trim());
        widget.onSubmitted?.call(value);
      },
      onFocusChanged: (value) {
        _onSearchTagChange();
      },
      onQueryChanged: (value) {
        _onSearchTagChange(value);
      },
      actions: [
        FloatingSearchBarAction.searchToClear(showIfClosed: false),
        FloatingSearchBarAction(
          showIfOpened: false,
          showIfClosed: true,
          child: CircularButton(
            icon: const Icon(Icons.filter_alt_outlined),
            onPressed: showFilterDialog,
          ),
        )
      ],
      body: widget.body,
      candidateBuilder: (BuildContext context, Animation<double> transition) {
        return Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: searchSuggestion.map((e) {
              return ListTile(
                title: Text(e.title),
                subtitle: e.subTitle != null ? Text(e.subTitle!) : null,
                onTap: () {
                  final tag = e.title.contains(' ') && !e.isHistory
                      ? '"${e.title}\$"'
                      : e.title;
                  final newTag = searchBarController.query.split(' ')
                    ..removeLast()
                    ..add(tag);
                  searchBarController.query = newTag.join(' ') + ' ';
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Future<void> _onSearchTagChange([String? tag]) async {
    final fullTag = tag ?? searchBarController.query;

    final Iterable<HistoryTableData> history = (await DB().historyDao.getAll())
        .where((e) => e.type == HistoryType.EH)
        .where((e) => e.history.startsWith(tag!))
        .take(20);

    final String lastTag = fullTag.split(' ').last;
    final List<EhTranslateTableData> complete =
        lastTag.isEmpty || !settingStore.ehAutoCompute
            ? <EhTranslateTableData>[]
            : await DB().translateDao.getByTag(lastTag);

    setState(() {
      searchSuggestion = <SearchSuggestion>[
        ...history
            .map((e) => SearchSuggestion(title: e.history, isHistory: true)),
        ...complete.take(50).map((e) => SearchSuggestion(
              title: '${e.namespace.substring(0, 1)}:${e.name}',
              subTitle: e.translate,
            ))
      ];
    });
  }

  Future<void> _setSearchHistory(String tag) async {
    if (tag.isEmpty) {
      return;
    }
    final dao = DB().historyDao;
    final history = await dao.get(tag);
    if (history != null) {
      await dao.updateHistory(history.copyWith(createTime: DateTime.now()));
    } else {
      dao.insert(HistoryTableCompanion.insert(
        history: tag,
        type: HistoryType.EH,
      ));
    }
  }

  Future<void> showFilterDialog() async {
    await showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    child: Text(
                      I18n.of(context).filter,
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                  const Divider(height: 0),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: Column(
                      children: [
                        GridView.count(
                          crossAxisCount: 2,
                          crossAxisSpacing: 3,
                          mainAxisSpacing: 3,
                          childAspectRatio: 5,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          children: typeFilter.entries
                              .map((e) => Obx(() => SelectButton(
                                    activeColor: e.key.color,
                                    isSelect: typeFilter[e.key]!.value,
                                    onPressed: () {
                                      typeFilter[e.key]!.value =
                                          !typeFilter[e.key]!.value;
                                    },
                                    text: e.key.string,
                                  )))
                              .toList(),
                        ),
                        const SizedBox(height: 10),
                        const Divider(),
                        TinySwitchTile(
                          title: Text(I18n.of(context).search_gallery_name),
                          value: true,
                          onChanged: (value) {},
                        ),
                        TinySwitchTile(
                          title: Text(I18n.of(context).search_gallery_tag),
                          value: true,
                          onChanged: (value) {},
                        ),
                        TinySwitchTile(
                          title: Text(I18n.of(context).search_torrent),
                          value: true,
                          onChanged: (value) {},
                        ),
                        TinySwitchTile(
                          title: Text(I18n.of(context).search_description),
                          value: true,
                          onChanged: (value) {},
                        ),
                        TinySwitchTile(
                          title: Text(I18n.of(context).search_low_power_tags),
                          value: true,
                          onChanged: (value) {},
                        ),
                        TinySwitchTile(
                          title: Text(I18n.of(context).show_expunged_galleries),
                          value: true,
                          onChanged: (value) {},
                        ),
                        TinySwitchTile(
                          title: Text(I18n.of(context).show_only_torrent),
                          value: true,
                          onChanged: (value) {},
                        ),
                        TinySwitchTile(
                          title: Text(I18n.of(context).search_downvote_tag),
                          value: true,
                          onChanged: (value) {},
                        ),
                        SizedBox(
                          height: 40,
                          child: Row(
                            children: [
                              Text(I18n.of(context).search_page),
                              Switch(value: true, onChanged: (value) {}),
                              const Expanded(child: SizedBox()),
                              SizedBox(
                                width: 50,
                                child: TextFormField(
                                  decoration:
                                      const InputDecoration(isDense: true),
                                ),
                              ),
                              Text(I18n.of(context).to),
                              SizedBox(
                                width: 50,
                                child: TextFormField(
                                  decoration:
                                      const InputDecoration(isDense: true),
                                ),
                              ),
                            ],
                          ),
                        ),
                        TinySelectTile<int>(
                          title: I18n.of(context).minimum_rating,
                          onChange: (value) {},
                          selectedValue: 0,
                          items: [
                            SelectTileItem<int>(
                                title: I18n.of(context).none, value: -1),
                            SelectTileItem<int>(
                                title: I18n.of(context).star_num('2'),
                                value: 2),
                            SelectTileItem<int>(
                                title: I18n.of(context).star_num('3'),
                                value: 3),
                            SelectTileItem<int>(
                                title: I18n.of(context).star_num('4'),
                                value: 4),
                            SelectTileItem<int>(
                                title: I18n.of(context).star_num('5'),
                                value: 5),
                          ],
                        ),
                        const Divider(),
                        Text(I18n.of(context).disable_default_filter),
                        TinySwitchTile(
                          title: Text(I18n.of(context).language),
                          value: true,
                          onChanged: (value) {},
                        ),
                        TinySwitchTile(
                          title: Text(I18n.of(context).uploader),
                          value: true,
                          onChanged: (value) {},
                        ),
                        TinySwitchTile(
                          title: Text(I18n.of(context).tags),
                          value: true,
                          onChanged: (value) {},
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}

class SearchSuggestion {
  const SearchSuggestion({
    required this.title,
    this.isHistory = false,
    this.subTitle,
  });

  final String title;
  final String? subTitle;
  final bool isHistory;
}
