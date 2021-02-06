abstract class PostViewInterface {
  final String searchText;

  PostViewInterface(this.searchText);

  Future<void> loadNextPage();
}
