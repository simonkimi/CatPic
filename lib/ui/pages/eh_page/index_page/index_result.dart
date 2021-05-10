import 'package:catpic/network/adapter/eh_adapter.dart';
import 'package:flutter/material.dart';

class EhIndexResult extends StatelessWidget {
  const EhIndexResult({
    Key? key,
    this.searchText = '',
    required this.adapter,
  }) : super(key: key);

  final String searchText;
  final EHAdapter adapter;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
