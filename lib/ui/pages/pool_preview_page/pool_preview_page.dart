import 'package:catpic/data/models/booru/booru_pool.dart';
import 'package:flutter/material.dart';

class PoolPreviewPage extends StatelessWidget {
  const PoolPreviewPage({
    Key? key,
    required this.booruPool,
  }) : super(key: key);
  final BooruPool booruPool;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [SliverAppBar()],
      ),
    );
  }
}
