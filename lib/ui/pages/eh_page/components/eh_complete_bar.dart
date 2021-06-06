import 'dart:ui' as ui;
import 'package:bot_toast/bot_toast.dart';
import 'package:catpic/data/database/database.dart';
import 'package:catpic/data/database/entity/history.dart';
import 'package:catpic/data/models/ehentai/preview_model.dart';
import 'package:catpic/i18n.dart';
import 'package:catpic/main.dart';
import 'package:catpic/network/api/ehentai/eh_filter.dart';
import 'package:catpic/ui/components/search_bar.dart';
import 'package:catpic/ui/components/seelct_tile.dart';
import 'package:catpic/ui/components/select_button.dart';
import 'package:catpic/ui/components/tiny_switch_tile.dart';
import 'package:catpic/ui/pages/eh_page/index_page/store/store.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:get/get.dart';
import 'package:catpic/utils/utils.dart';

class EhCompleteBar extends StatefulWidget {
  const EhCompleteBar({
    Key? key,
    this.onSubmitted,
    required this.searchText,
    required this.body,
    this.controller,
    required this.store,
  }) : super(key: key);

  final ValueChanged<String>? onSubmitted;
  final String searchText;
  final Widget body;
  final FloatingSearchBarController? controller;
  final EhIndexStore store;

  @override
  _EhCompleteBarState createState() => _EhCompleteBarState();
}

class _EhCompleteBarState extends State<EhCompleteBar>
    with TickerProviderStateMixin {
  late final FloatingSearchBarController searchBarController =
      widget.controller ?? FloatingSearchBarController();

  late final actionController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 200),
  );

  late final Animation<double> actionAnimation =
      Tween<double>(begin: 0.0, end: 0.375).animate(actionController);

  var searchSuggestion = <SearchSuggestion>[];

  var filterDisplaySwitch = false;

  var lastClickBack = DateTime.now();

  late final EhAdvanceFilter filter = widget.store.filter;

  void onActionPress() {
    if (searchBarController.query.isNotEmpty) {
      searchBarController.clear();
    } else if (searchBarController.isOpen) {
      searchBarController.close();
    } else {
      if (!filterDisplaySwitch) {
        // 当前为搜索页面
        setState(() {
          filterDisplaySwitch = true;
        });
        actionController.forward();
      } else {
        backToSearch();
      }
    }
  }

  void backToSearch([Function? callBack]) {
    setState(() {
      filterDisplaySwitch = false;
    });
    actionController.reverse();
    callBack?.call();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (Scaffold.of(context).isDrawerOpen) {
          return true;
        }
        if (searchBarController.isOpen) {
          searchBarController.close();
          return false;
        }
        if (filterDisplaySwitch) {
          backToSearch();
          return false;
        }
        final nowTime = DateTime.now();
        if (mainStore.searchPageCount <= 1 &&
            nowTime.difference(lastClickBack) > const Duration(seconds: 2)) {
          BotToast.showText(text: I18n.g.click_again_to_exit);
          lastClickBack = nowTime;
          return false;
        }
        return true;
      },
      child: SearchBar(
        controller: searchBarController,
        searchText: widget.searchText,
        showTmp: filterDisplaySwitch,
        onSubmitted: (value) {
          _setSearchHistory(value.trim());
          widget.onSubmitted?.call(value);
        },
        onFocusChanged: (isFocus) {
          if (!filterDisplaySwitch) {
            actionController.play(isFocus);
          }
          _onSearchTagChange();
        },
        onQueryChanged: (value) {
          _onSearchTagChange(value);
        },
        actions: [
          FloatingSearchBarAction(
            showIfOpened: true,
            showIfClosed: true,
            child: RotationTransition(
              alignment: Alignment.center,
              turns: actionAnimation,
              child: CircularButton(
                icon: const Icon(Icons.add),
                onPressed: onActionPress,
              ),
            ),
          ),
        ],
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, animation) => FadeTransition(
            opacity: animation,
            child: child,
          ),
          child:
              filterDisplaySwitch ? buildFilterFragment(context) : widget.body,
        ),
        candidateBuilder: (BuildContext context, Animation<double> transition) {
          return Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: searchSuggestion.map((e) {
                return ListTile(
                  title: Text(e.title),
                  subtitle: e.subTitle != null ? Text(e.subTitle!) : null,
                  onTap: () {
                    late final String completeTag;
                    if (e.title.contains(' ')) {
                      if (e.title.contains(':')) {
                        final tagParams = e.title.split(':');
                        completeTag = tagParams[0] + ':"${tagParams[1]}\$"';
                      } else {
                        completeTag = '"${e.title}\$"';
                      }
                    } else {
                      completeTag = e.title;
                    }
                    final newTag = searchBarController.query.split(' ')
                      ..removeLast()
                      ..add(completeTag);
                    searchBarController.query = newTag.join(' ') + ' ';
                  },
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }

  Future<void> _onSearchTagChange([String? tag]) async {
    final fullTag = tag ?? searchBarController.query;

    final Iterable<HistoryTableData> history = (await DB().historyDao.getAll())
        .where((e) => e.type == HistoryType.EH)
        .where((e) => e.history.startsWith(tag ?? ''))
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

  Widget buildFilterFragment(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(
            top: MediaQueryData.fromWindow(ui.window).padding.top + 30,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
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
                        children: filter.typeFilter.entries
                            .map((e) => Obx(() => SelectButton(
                                  activeColor: e.key.color,
                                  isSelect: filter.typeFilter[e.key]!.value,
                                  onPressed: () {
                                    filter.typeFilter[e.key]!.value =
                                        !filter.typeFilter[e.key]!.value;
                                  },
                                  onLongPressed: () {
                                    final value =
                                        !filter.typeFilter[e.key]!.value;
                                    filter.typeFilter.entries
                                        .where((ele) => ele.key != e.key)
                                        .forEach((element) {
                                      element.value.value = value;
                                    });
                                    filter.typeFilter[e.key]!.value = !value;
                                    vibrate(duration: 50, amplitude: 100);
                                  },
                                  text: e.key.string,
                                )))
                            .toList(),
                      ),
                      const SizedBox(height: 10),
                      const Divider(),
                      Row(
                        children: [
                          Text(I18n.of(context).advance_search),
                          Obx(() => Switch(
                                value: widget.store.useAdvance.value,
                                onChanged: (value) {
                                  widget.store.useAdvance.value =
                                      !widget.store.useAdvance.value;
                                },
                              )),
                          const Expanded(child: SizedBox()),
                          TextButton(
                            onPressed: () {},
                            child: Text(I18n.of(context).reset),
                          ),
                        ],
                      ),
                      Obx(() => TinySwitchTile(
                            title: Text(I18n.of(context).search_gallery_name),
                            value: filter.searchGalleryName.value,
                            onChanged: (value) {
                              print(value);
                              filter.searchGalleryName.value = value;
                            },
                          )),
                      Obx(() => TinySwitchTile(
                            title: Text(I18n.of(context).search_gallery_tag),
                            value: filter.searchGalleryTag.value,
                            onChanged: (value) {
                              filter.searchGalleryTag.value = value;
                            },
                          )),
                      Obx(() => TinySwitchTile(
                            title: Text(I18n.of(context).search_torrent),
                            value: filter.searchTorrentFile.value,
                            onChanged: (value) {
                              filter.searchTorrentFile.value = value;
                            },
                          )),
                      Obx(() => TinySwitchTile(
                            title: Text(I18n.of(context).search_description),
                            value: filter.searchGalleryDescription.value,
                            onChanged: (value) {
                              filter.searchGalleryDescription.value = value;
                            },
                          )),
                      Obx(() => TinySwitchTile(
                            title: Text(I18n.of(context).search_low_power_tags),
                            value: filter.searchLowPowerTag.value,
                            onChanged: (value) {
                              filter.searchLowPowerTag.value = value;
                            },
                          )),
                      Obx(() => TinySwitchTile(
                            title:
                                Text(I18n.of(context).show_expunged_galleries),
                            value: filter.showExpungedGallery.value,
                            onChanged: (value) {
                              filter.showExpungedGallery.value = value;
                            },
                          )),
                      Obx(() => TinySwitchTile(
                            title: Text(I18n.of(context).show_only_torrent),
                            value: filter.onlyShowGalleriesWithTorrents.value,
                            onChanged: (value) {
                              filter.onlyShowGalleriesWithTorrents.value = value;
                            },
                          )),
                      Obx(() => TinySwitchTile(
                            title: Text(I18n.of(context).search_downvote_tag),
                            value: filter.searchDownvotedTags.value,
                            onChanged: (value) {
                              filter.searchDownvotedTags.value = value;
                            },
                          )),
                      SizedBox(
                        height: 40,
                        child: Row(
                          children: [
                            Text(I18n.of(context).search_page),
                            Obx(() => Switch(
                                value: filter.betweenPage.value,
                                onChanged: (value) {
                                  filter.betweenPage.value = value;
                                })),
                            const Expanded(child: SizedBox()),
                            SizedBox(
                              width: 50,
                              child: Obx(() => TextFormField(
                                    initialValue: filter.pageStart.toString(),
                                    decoration:
                                        const InputDecoration(isDense: true),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) {
                                      filter.pageStart.value = int.parse(value);
                                    },
                                  )),
                            ),
                            Text(I18n.of(context).to),
                            SizedBox(
                              width: 50,
                              child: Obx(() => TextFormField(
                                    initialValue: filter.pageEnd.toString(),
                                    decoration:
                                        const InputDecoration(isDense: true),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) {
                                      filter.pageEnd.value = int.parse(value);
                                    },
                                  )),
                            ),
                          ],
                        ),
                      ),
                      Obx(() => TinySelectTile<int>(
                            title: I18n.of(context).minimum_rating,
                            onChange: (value) {
                              filter.minimumRating.value = value;
                            },
                            selectedValue: filter.minimumRating.value,
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
                          )),
                      const Divider(),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Text(
                                I18n.of(context).disable_default_filter + ':'),
                          )
                        ],
                      ),
                      Obx(() => TinySwitchTile(
                            title: Text(I18n.of(context).language),
                            value: filter.disableLanguage.value,
                            onChanged: (value) {
                              filter.disableLanguage.value = value;
                            },
                          )),
                      Obx(() => TinySwitchTile(
                            title: Text(I18n.of(context).uploader),
                            value: filter.disableUploader.value,
                            onChanged: (value) {
                              filter.disableUploader.value = value;
                            },
                          )),
                      Obx(() => TinySwitchTile(
                            title: Text(I18n.of(context).tags),
                            value: filter.disableTag.value,
                            onChanged: (value) {
                              filter.disableTag.value = value;
                            },
                          )),
                      const SizedBox(height: 70),
                    ],
                  ),
                ),
              ],
            ),
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
    );
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
