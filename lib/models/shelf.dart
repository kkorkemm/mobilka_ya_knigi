class Shelf {
  final String id;
  final String title;
  final int booksCount;
  final int followers;
  final String? coverUrl;

  const Shelf({
    required this.id,
    required this.title,
    this.booksCount = 0,
    this.followers = 0,
    this.coverUrl,
  });
}