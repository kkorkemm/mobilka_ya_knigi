import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../data/mock_books.dart';
import '../models/book_edition.dart';
import '../models/shelf.dart';

class AppState extends ChangeNotifier {
  // ============================================================
  // Тема
  // ============================================================

  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;

  void setThemeMode(ThemeMode mode) {
    if (_themeMode == mode) return;
    _themeMode = mode;
    notifyListeners();
  }

  void cycleThemeMode() {
    const order = [ThemeMode.system, ThemeMode.light, ThemeMode.dark];
    final i = order.indexOf(_themeMode);
    setThemeMode(order[(i + 1) % order.length]);
  }

  // ============================================================
  // Отладка
  // ============================================================

  bool _simulateNetworkError = false;
  bool get simulateNetworkError => _simulateNetworkError;

  void setSimulateNetworkError(bool value) {
    _simulateNetworkError = value;
    notifyListeners();
  }

  // ============================================================
  // Библиотека («Мои книги»)
  // ============================================================

  final Set<String> _libraryIds = <String>{};
  Set<String> get libraryIds => Set.unmodifiable(_libraryIds);

  bool isInLibrary(String id) => _libraryIds.contains(id);

  void addToLibrary(String id) {
    if (_libraryIds.add(id)) notifyListeners();
  }

  void removeFromLibrary(String id) {
    if (_libraryIds.remove(id)) notifyListeners();
  }

  /// Возвращает true, если книга теперь в библиотеке.
  bool toggleLibrary(String id) {
    final added = !_libraryIds.remove(id);
    if (added) _libraryIds.add(id);
    notifyListeners();
    return added;
  }

  // ============================================================
  // Текущая книга и прогресс
  // ============================================================

  /// Книга, закреплённая внизу экрана (мини-плеер).
  String? _currentEditionId;
  String? get currentEditionId => _currentEditionId;
  BookEdition? get currentEdition => findEditionById(_currentEditionId);
  bool get hasCurrentBook => _currentEditionId != null;

  /// editionId -> прогресс 0..1
  final Map<String, double> _progress = <String, double>{};

  /// Когда книгу последний раз открывали (для сортировки).
  final Map<String, DateTime> _lastOpened = <String, DateTime>{};

  /// Прочитанные до конца книги.
  final Set<String> _finished = <String>{};

  double progressOf(String id) => _progress[id] ?? 0;
  bool isFinished(String id) => _finished.contains(id);

  /// Порядковый номер книги по времени последнего открытия.
  /// 0 — самая свежая.
  int lastOpenedRank(String id) {
    final list = _lastOpened.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return list.indexWhere((e) => e.key == id);
  }

  void openBook(String id) {
    _currentEditionId = id;
    _progress.putIfAbsent(id, () => 0);
    _lastOpened[id] = DateTime.now();
    notifyListeners();
  }

  void updateProgress(String id, double value) {
    _progress[id] = value.clamp(0.0, 1.0);
    if (_progress[id]! >= 0.999) _finished.add(id);
    _lastOpened[id] = DateTime.now();
    notifyListeners();
  }

  void toggleFinished(String id) {
    if (!_finished.remove(id)) {
      _finished.add(id);
      _progress[id] = 1.0;
    } else {
      _progress[id] = 0.0;
    }
    notifyListeners();
  }

  void closeCurrentBook() {
    _currentEditionId = null;
    notifyListeners();
  }

  // ============================================================
  // Открытые сейчас страницы книги
  // ============================================================

  final Set<String> _openDetailsIds = <String>{};
  Set<String> get openDetailsIds => Set.unmodifiable(_openDetailsIds);

  void registerOpenDetails(String editionId) {
    if (_openDetailsIds.add(editionId)) notifyListeners();
  }

  void unregisterOpenDetails(String editionId) {
    if (_openDetailsIds.remove(editionId)) notifyListeners();
  }

  bool get isCurrentBookDetailsOpen {
    final id = _currentEditionId;
    return id != null && _openDetailsIds.contains(id);
  }

  // ============================================================
  // Библиотека — фильтры и группировки
  // ============================================================

  /// Все книги библиотеки (сначала добавленные позже).
  List<BookEdition> get libraryBooks {
    final ids = _libraryIds.toList().reversed.toList();
    return editionsByIds(ids);
  }

  /// Список «Продолжить»: есть прогресс, но не дочитано.
  List<BookEdition> get continueBooks {
    final ids = <String>{};

    // Всё, где есть хоть какой-то прогресс, но не закончено.
    _progress.forEach((id, p) {
      if (p > 0 && !_finished.contains(id)) ids.add(id);
    });

    // Текущая книга — даже с нулевым прогрессом.
    final cur = _currentEditionId;
    if (cur != null && !_finished.contains(cur)) ids.add(cur);

    final list = editionsByIds(ids.toList());
    list.sort((a, b) => (_lastOpened[b.id] ?? DateTime(0))
        .compareTo(_lastOpened[a.id] ?? DateTime(0)));
    return list;
  }
  
  /// «Прочитано».
  List<BookEdition> get finishedBooks =>
      libraryBooks.where((b) => isFinished(b.id)).toList();

  /// «Читаю / Слушаю» — всё, что не дочитано.
  List<BookEdition> get inProgressBooks =>
      libraryBooks.where((b) => !isFinished(b.id)).toList();

  // ============================================================
  // История поиска
  // ============================================================

  final List<String> _searchHistory = <String>[];
  List<String> get searchHistory => List.unmodifiable(_searchHistory);

  void addSearchQuery(String query) {
    final q = query.trim();
    if (q.isEmpty) return;
    _searchHistory.removeWhere((e) => e.toLowerCase() == q.toLowerCase());
    _searchHistory.insert(0, q);
    if (_searchHistory.length > 10) _searchHistory.removeLast();
    notifyListeners();
  }

  void removeSearchQuery(String query) {
    _searchHistory.remove(query);
    notifyListeners();
  }

  void clearSearchHistory() {
    _searchHistory.clear();
    notifyListeners();
  }

  // ============================================================
  // История открытых книг
  // ============================================================

  final List<String> _recentlyViewed = <String>[];
  List<String> get recentlyViewedIds => List.unmodifiable(_recentlyViewed);
  List<BookEdition> get recentlyViewedBooks => editionsByIds(_recentlyViewed);

  void addRecentlyViewed(String id) {
    _recentlyViewed.remove(id);
    _recentlyViewed.insert(0, id);
    if (_recentlyViewed.length > 10) _recentlyViewed.removeLast();
    notifyListeners();
  }

  final List<String> _searchOpenedIds = <String>[];
  List<String> get searchOpenedIds => List.unmodifiable(_searchOpenedIds);

  List<BookEdition> get searchOpenedBooks => editionsByIds(_searchOpenedIds);

  void addSearchOpened(String id) {
    _searchOpenedIds.remove(id);
    _searchOpenedIds.insert(0, id);
    if (_searchOpenedIds.length > 10) _searchOpenedIds.removeLast();
    notifyListeners();
  }

  // ============================================================
  // Полки
  // ============================================================

  final List<Shelf> _shelves = <Shelf>[
    const Shelf(
      id: 'marathon',
      title: 'Марафон',
      booksCount: 5,
      followers: 1,
    ),
  ];
  List<Shelf> get shelves => List.unmodifiable(_shelves);

  // ============================================================
  // Статистика чтения (заглушка)
  // ============================================================

  int get minutesToday => 10;
  int get daysThisMonth => 1;
  int get streakDays => 1;

  /// Всего прочитанных книг за всё время (заглушка + реально отмеченные).
  int get totalBooksRead => 2 + _finished.length;


  // ============================================================
  // Настройки читалки
  // ============================================================

  double _readerFontSize = 18;
  double get readerFontSize => _readerFontSize;

  void setReaderFontSize(double value) {
    if (_readerFontSize == value) return;
    _readerFontSize = value;
    notifyListeners();
  }

  /// 'sans' или 'serif'
  String _readerFontFamily = 'serif';
  String get readerFontFamily => _readerFontFamily;

  void setReaderFontFamily(String family) {
    if (_readerFontFamily == family) return;
    _readerFontFamily = family;
    notifyListeners();
  }

  ReaderTheme _readerTheme = ReaderTheme.black;
  ReaderTheme get readerTheme => _readerTheme;

  void setReaderTheme(ReaderTheme theme) {
    if (_readerTheme == theme) return;
    _readerTheme = theme;
    notifyListeners();
  }

  // ============================================================
  // Плеер аудиокниги
  // ============================================================

  bool _isPlaying = false;
  bool get isPlaying => _isPlaying;

  void setPlaying(bool v) {
    if (_isPlaying == v) return;
    _isPlaying = v;
    notifyListeners();
  }

  void togglePlaying() => setPlaying(!_isPlaying);

  /// Текущая позиция в секундах для каждой книги.
  final Map<String, int> _audioPositions = <String, int>{};

  int audioPositionSeconds(String id) => _audioPositions[id] ?? 0;

  void setAudioPosition(String id, int seconds) {
    _audioPositions[id] = seconds;
    notifyListeners();
  }

  /// Скорость воспроизведения (общая для всех аудиокниг).
  double _playbackSpeed = 1.0;
  double get playbackSpeed => _playbackSpeed;

  void setPlaybackSpeed(double v) {
    if (_playbackSpeed == v) return;
    _playbackSpeed = v;
    notifyListeners();
  }

  /// Таймер сна: сколько минут осталось (0 — выключен).
  int _sleepTimerMinutes = 0;
  int get sleepTimerMinutes => _sleepTimerMinutes;

  void setSleepTimerMinutes(int m) {
    _sleepTimerMinutes = m;
    notifyListeners();
  }
}

enum ReaderTheme { system, light, sepia, dark, black }
