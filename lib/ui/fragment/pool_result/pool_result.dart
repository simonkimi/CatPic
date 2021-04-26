import 'package:catpic/data/adapter/booru_adapter.dart';
import 'package:flutter/material.dart';

class PoolResultFragment extends StatefulWidget {
  const PoolResultFragment({
    Key? key,
    this.searchText = '',
    required this.adapter,
  }) : super(key: key);

  final String searchText;
  final BooruAdapter adapter;

  @override
  _PoolResultFragmentState createState() => _PoolResultFragmentState();
}

class _PoolResultFragmentState extends State<PoolResultFragment> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
