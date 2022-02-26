import 'package:catpic/data/models/ehentai/eh_storage.dart';
import 'package:catpic/data/models/gen/eh_storage.pbenum.dart';
import 'package:catpic/ui/components/app_bar.dart';
import 'package:catpic/ui/pages/setting_page/eh_setting.dart';
import 'package:catpic/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import 'eh_image_viewer/store/store.dart';

class BackAppBar extends HookWidget implements PreferredSizeWidget {
  const BackAppBar({
    Key? key,
    required this.store,
    required this.onDisplayTypeChange,
  }) : super(key: key);

  final EhReadStore store;
  final ValueChanged<DisplayType> onDisplayTypeChange;

  @override
  Widget build(BuildContext context) {
    final appBarController =
        useAnimationController(duration: const Duration(milliseconds: 200));

    final appBarHideAni =
        Tween<Offset>(begin: const Offset(0, 0), end: const Offset(0, -1))
            .animate(appBarController);

    return Observer(builder: (context) {
      appBarController.byValue(store.displayPageSlider);
      return SlideTransition(
        position: appBarHideAni,
        child: AppBar(
          backgroundColor: Colors.transparent,
          leading: appBarBackButton(onPress: () {
            SystemChrome.setPreferredOrientations([]);
            Navigator.of(context).pop();
          }),
          elevation: 0,
          actions: [
            IconButton(
              onPressed: () {
                onDisplayTypeChange(
                    store.adapter.websiteEntity.displayType.next());
              },
              icon:
                  store.adapter.websiteEntity.displayType == DisplayType.Single
                      ? const Icon(Icons.library_books_sharp)
                      : store.adapter.websiteEntity.displayType ==
                              DisplayType.DoubleNormal
                          ? const Icon(Icons.chrome_reader_mode_outlined)
                          : const Icon(Icons.chrome_reader_mode),
            ),
            IconButton(
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return const EHSettingPage();
                  }));
                },
                icon: const Icon(Icons.settings)),
          ],
        ),
      );
    });
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
