// import 'package:catpic/data/models/booru/booru_pool.dart';
// import 'package:catpic/data/models/booru/booru_post.dart';
// import 'package:catpic/data/models/booru/load_more.dart';
// import 'package:mobx/mobx.dart';
//
// part 'pool_post_store';
//
// class PoolPostStore = PoolPostStoreBase with _$PoolPostStore;
//
// abstract class PoolPostStoreBase extends ILoadMore<BooruPost> with Store {
//   PoolPostStoreBase({
//     required String searchText,
//     required this.booruPool,
//   }) : super(searchText);
//
//   final BooruPool booruPool;
//
//   @override
//   Future<void> onDataChange() async {}
//
//   @override
//   Future<List<BooruPost>> onLoadNextPage() => booruPool.fetchPosts(client)
// }
