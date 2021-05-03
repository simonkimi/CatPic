class BooruComments {
  const BooruComments({
    required this.id,
    required this.creator,
    required this.createAt,
    required this.body,
  });

  final String id;
  final String creator;
  final String createAt;
  final String body;
}
