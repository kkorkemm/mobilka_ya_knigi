import 'chapter.dart';
import 'impression.dart';
import 'quote.dart';
import 'review.dart';

enum BookFormat { text, audio }

class BookEdition {
  final String id;
  final String title;
  final String author;
  final BookFormat format;

  /// Чтец — только для аудио
  final String? narrator;

  /// Пока null — обложка рисуется заглушкой.
  final String? coverUrl;

  final String description;
  final List<String> genres;
  final double rating;
  final int reviewsCount;

  /// Возрастное ограничение, напр. «12+»
  final String? ageRestriction;

  /// Год первой публикации, напр. 1881
  final int? originalYear;

  final String? seriesTitle;
  final int? seriesNumber;

  final int pages;
  final Duration? audioDuration;

  // ---------- Статистика (строка над кнопками) ----------
  final int readersCount;     // «Читают»
  final int quotesCount;      // «Цитаты»
  final int impressionsCount; // «Впечатления»
  final int shelvesCount;     // «Полки»

  // ---------- Списки ----------
  final List<Review> reviews;
  final List<Quote> quotes;
  final List<Impression> impressions;
  final List<String> similarIds;

  /// Другие версии этой же книги (текст/аудио, другие издания).
  final List<String> otherEditionIds;

  /// «С этой книгой читают»
  final List<String> readWithIds;

  const BookEdition({
    required this.id,
    required this.title,
    required this.author,
    required this.format,
    this.narrator,
    this.coverUrl,
    required this.description,
    this.genres = const [],
    this.rating = 0,
    this.reviewsCount = 0,
    this.ageRestriction,
    this.originalYear,
    this.seriesTitle,
    this.seriesNumber,
    this.pages = 0,
    this.audioDuration,
    this.readersCount = 0,
    this.quotesCount = 0,
    this.impressionsCount = 0,
    this.shelvesCount = 0,
    this.reviews = const [],
    this.quotes = const [],
    this.impressions = const [],
    this.similarIds = const [],
    this.otherEditionIds = const [],
    this.readWithIds = const [],
  });

  bool get isAudio => format == BookFormat.audio;

  String get formatLabel => switch (format) {
        BookFormat.text => 'Книга',
        BookFormat.audio => 'Аудиокнига',
      };

  String get ratingLabel =>
      rating > 0 ? rating.toStringAsFixed(1).replaceAll('.', ',') : '';

  /// Формат числа: 4.3K / 77.7K / 1.2M
  String get ratingsLabel => formatCount(reviewsCount);
  String get readersLabel => formatCount(readersCount);
  String get quotesLabel => formatCount(quotesCount);
  String get impressionsLabel => formatCount(impressionsCount);
  String get shelvesLabel => formatCount(shelvesCount);

  static String formatCount(int n) {
    if (n < 1000) return '$n';
    if (n < 1000000) {
      final v = n / 1000;
      final s = v.toStringAsFixed(v < 10 ? 1 : 0);
      return '${s.replaceAll('.0', '')}K';
    }
    final v = n / 1000000;
    final s = v.toStringAsFixed(1);
    return '${s.replaceAll('.0', '')}M';
  }
}