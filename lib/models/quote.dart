class Quote {
  final String author;
  final String timeAgo; // «2г», «5м», «Знед»
  final String text;
  final int likes;

  const Quote({
    required this.author,
    required this.timeAgo,
    required this.text,
    this.likes = 0,
  });
}