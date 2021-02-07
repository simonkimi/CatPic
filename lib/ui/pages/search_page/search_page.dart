import 'package:catpic/generated/l10n.dart';
import 'package:catpic/ui/fragment/drawer/main_drawer.dart';
import 'package:catpic/ui/fragment/post_result/post_result_fragment.dart';
import 'package:catpic/ui/pages/website_add_page/website_add_page.dart';
import 'package:catpic/ui/pages/website_manager/website_manager.dart';
import 'package:catpic/ui/store/main/main_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';

enum SearchType { POST, POOL, ARTIST }

class SearchPage extends StatefulWidget {
  static String routeName = 'SearchPage';

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String searchText;
  SearchType searchType;
  Widget searchBody;

  @override
  void initState() {
    super.initState();
    if (Get.arguments is Map) {
      searchText = Get.arguments['searchText'] ?? '';
      searchType = Get.arguments['searchType'] ?? SearchType.POST;
    } else {
      searchText = '';
      searchType = SearchType.POST;
    }
    searchBody = buildSearchBody(searchText, searchType);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(),
      body: buildEmpty(),
    );
  }

  void changeSearchBody(String tag, SearchType type) {
    var widget = buildSearchBody(tag, type);
    setState(() {
      searchBody = widget;
    });
  }

  Widget buildSearchBody(String tag, SearchType type) {
    if (mainStore.websiteEntity != null) {
      switch (searchType) {
        case SearchType.POST:
          return PostResultFragment(
            searchText: tag,
            adapter: mainStore.websiteEntity.getAdapter(),
            onSearch: (value) {
              changeSearchBody(value.trim(), SearchType.POST);
            },
          );
        case SearchType.POOL:
          throw Exception('TODO POOL');
          break;
        case SearchType.ARTIST:
          throw Exception('TODO ARTIST');
          break;
      }
    }
  }

  Widget buildEmpty() {
    return SafeArea(
      child: Stack(
        children: [
          GestureDetector(
            onTap: () {
              Get.toNamed(WebsiteAddPage.routeName);
            },
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
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    S.of(context).to_add_website,
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor),
                  )
                ],
              ),
            ),
          ),
          FloatingSearchBar(
            hint: 'CatPic',
            scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
            transitionDuration: const Duration(milliseconds: 300),
            transitionCurve: Curves.easeInOut,
            physics: const BouncingScrollPhysics(),
            openAxisAlignment: 0.0,
            debounceDelay: const Duration(milliseconds: 500),
            transition: CircularFloatingSearchBarTransition(),
            builder: (context, transition) {
              return Container();
            },
          ),
        ],
      ),
    );
  }
}
