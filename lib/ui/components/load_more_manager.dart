import 'package:catpic/data/models/booru/load_more.dart';
import 'package:catpic/i18n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';

class LoadMoreManager extends StatelessWidget {
  const LoadMoreManager({
    Key? key,
    required this.store,
    required this.body,
    this.isLoading = false,
  }) : super(key: key);

  final ILoadMore store;
  final bool isLoading;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: () {
            if (store.isLoading && store.observableList.isEmpty)
              return const Padding(
                padding: EdgeInsets.all(30),
                child: Center(child: CircularProgressIndicator()),
              );
            if (store.lastException != null &&
                store.lastException!.isNotEmpty &&
                store.observableList.isEmpty)
              return EmptyWidget(
                errMsg: store.lastException!,
                onTap: store.onRefresh,
              );
            if (store.observableList.isEmpty)
              return EmptyWidget(
                onTap: store.onRefresh,
                errMsg: I18n.of(context).search_empty,
              );
            return body;
          }(),
        );
      },
    );
  }
}

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({
    Key? key,
    required this.errMsg,
    required this.onTap,
  }) : super(key: key);

  final GestureTapCallback onTap;

  final String errMsg;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(30),
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  errMsg,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
