import 'package:mobx/mobx.dart';

part 'store.g.dart';

class PostImageViewStore = PostImageViewStoreBase with _$PostImageViewStore;


abstract class PostImageViewStoreBase with Store {
  PostImageViewStoreBase(this.index);

  @observable
  bool bottomBarVis = true;

  @observable
  int index;


  @action
  void setBottomBarVis(bool value) => bottomBarVis = value;

  @action
  void setIndex(int value) => index = value;
}