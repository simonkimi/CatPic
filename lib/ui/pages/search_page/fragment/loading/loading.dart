import 'package:catpic/data/models/booru/load_more.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';
import 'package:catpic/i18n.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({
    Key? key,
    required this.store,
  }) : super(key: key);
  final ILoadMore store;

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        print(store.isLoading);
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: store.isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : store.observableList.isEmpty
                  ? GestureDetector(
                      onTap: store.onRefresh,
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
                    )
                  : const SizedBox(),
        );
      },
    );
  }
}