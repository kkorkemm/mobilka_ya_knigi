enum ImpressionTag { recommend, informative, wise }

class Impression {
  final String author;
  final String timeAgo;
  final ImpressionTag tag;
  final String text;
  final int likes;

  const Impression({
    required this.author,
    required this.timeAgo,
    required this.tag,
    required this.text,
    this.likes = 0,
  });

  String get tagLabel => switch (tag) {
        ImpressionTag.recommend => 'Советую',
        ImpressionTag.informative => 'Познавательно',
        ImpressionTag.wise => 'Мудро',
      };

  String get tagEmoji => switch (tag) {
        ImpressionTag.recommend => '👍',
        ImpressionTag.informative => '💡',
        ImpressionTag.wise => '😈',
      };
}