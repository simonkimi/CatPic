abstract class PostViewInterface {
  PostViewInterface(this.searchText);

  final String searchText;

  Future<void> loadNextPage();
}
