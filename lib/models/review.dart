class Review {
  final String author;
  final String? avatarUrl;
  final double rating;
  final String text;
  final String date;
  final int likes;

  const Review({
    required this.author,
    this.avatarUrl,
    required this.rating,
    required this.text,
    required this.date,
    this.likes = 0,
  });
}