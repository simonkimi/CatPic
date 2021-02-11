import 'package:catpic/generated/l10n.dart';
import 'package:catpic/router/catpic_page.dart';
import 'package:catpic/router/route_delegate.dart';
import 'package:catpic/ui/pages/website_manager/website_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';


class EmptyWebsiteFragment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          GestureDetector(
            onTap: () {
              MyRouteDelegate.of(context).push(
                CatPicPage(
                  body: WebsiteManagerPage(),
                ),
              );
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
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    S.of(context).to_add_website,
                    style: TextStyle(
                        fontSize: 14,
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
