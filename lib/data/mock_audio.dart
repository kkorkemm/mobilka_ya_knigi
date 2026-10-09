import '../models/audio_chapter.dart';

/// Заглушка оглавления аудиокниги.
/// Для любой книги генерируем одинаковый набор глав с таймингами,
/// пропорционально общей длительности.
List<AudioChapter> mockAudioChapters(Duration total) {
  final titles = [
    'Глава 1',
    'Глава 2',
    'Глава 3',
    'Глава 4',
    'Глава 5',
    'Глава 6',
    'Глава 7',
    'Эпилог',
  ];

  final part = total.inSeconds ~/ titles.length;

  return List.generate(titles.length, (i) {
    final start = Duration(seconds: part * i);
    // Последняя глава забирает остаток.
    final dur = i == titles.length - 1
        ? total - start
        : Duration(seconds: part);
    return AudioChapter(title: titles[i], start: start, duration: dur);
  });
}