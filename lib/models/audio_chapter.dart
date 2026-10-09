class AudioChapter {
  final String title;

  /// Начало главы от начала книги.
  final Duration start;

  /// Длительность главы.
  final Duration duration;

  const AudioChapter({
    required this.title,
    required this.start,
    required this.duration,
  });

  Duration get end => start + duration;
}