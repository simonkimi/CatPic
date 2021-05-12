import 'package:bot_toast/bot_toast.dart';
import 'package:catpic/network/adapter/booru_adapter.dart';
import 'package:catpic/data/models/booru/booru_comment.dart';
import 'package:dio/dio.dart';
import 'package:mobx/mobx.dart';

import 'package:catpic/i18n.dart';

part 'comment_store.g.dart';

class CommentStore = CommentStoreBase with _$CommentStore;

abstract class CommentStoreBase with Store {
  CommentStoreBase({
    required this.adapter,
    required this.id,
  }) {
    load();
  }

  final String id;
  final BooruAdapter adapter;

  final commentList = ObservableList<BooruComments>();

  @observable
  var isLoading = false;

  @action
  Future<void> load() async {
    isLoading = true;
    try {
      commentList
        ..clear()
        ..addAll(await adapter.comment(id: id));
    } on DioError catch (e) {
      BotToast.showText(text: '${I18n.g.network_error}:${e.message}');
    } catch (e) {
      BotToast.showText(text: e.toString());
    } finally {
      isLoading = false;
    }
  }
}
