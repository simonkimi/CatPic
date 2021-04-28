import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../i18n.dart';

Widget buildFooter(BuildContext context, LoadStatus? status) {
  Widget buildRow(List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: children,
      ),
    );
  }

  switch (status ?? LoadStatus.loading) {
    case LoadStatus.idle:
      return buildRow([
        const Icon(Icons.arrow_upward),
        const SizedBox(
          width: 10,
        ),
        Text(
          I18n.of(context).idle_loading,
          style: const TextStyle(color: Colors.black),
        ),
      ]);
    case LoadStatus.canLoading:
      return buildRow([
        const Icon(Icons.arrow_downward),
        const SizedBox(
          width: 10,
        ),
        Text(
          I18n.of(context).can_load_text,
          style: const TextStyle(color: Colors.black),
        )
      ]);
    case LoadStatus.loading:
      return buildRow([
        const SizedBox(
          width: 25,
          height: 25,
          child: CircularProgressIndicator(strokeWidth: 2.5),
        ),
        const SizedBox(
          width: 10,
        ),
        Text(
          I18n.of(context).loading_text,
          style: const TextStyle(color: Colors.black),
        )
      ]);
    case LoadStatus.noMore:
      return buildRow([
        const Icon(Icons.flag),
        const SizedBox(width: 10),
        Text(
          I18n.of(context).no_more_text,
          style: const TextStyle(color: Colors.black),
        )
      ]);
    case LoadStatus.failed:
      return buildRow([
        const Icon(Icons.sms_failed),
        const SizedBox(
          width: 10,
        ),
        Text(
          I18n.of(context).load_fail,
          style: const TextStyle(color: Colors.black),
        )
      ]);
  }
}
