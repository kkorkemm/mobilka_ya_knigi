import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/mock_books.dart';
import '../models/book_edition.dart';
import '../state/app_state.dart';
import '../theme/app_colors.dart';
import '../widgets/book_row.dart';
import '../widgets/empty_state.dart';
import 'book_details_screen.dart';
import '../widgets/no_internet_view.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

enum _SearchStatus { idle, loading, results, empty, error }

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focus = FocusNode();

  Timer? _debounce;
  _SearchStatus _status = _SearchStatus.idle;
  List<BookEdition> _results = const [];
  String _lastQuery = '';
  bool _hasFocus = false;

  int _filterIndex = 0;
  static const _filterLabels = [
    'Все',
    'Книги',
    'Аудиокниги',
    'Комиксы',
    'Пользователи',
    'Полки',
    'Серии',
    'Сериалы',
    'Авторы',
    'Рассказчики'
  ];

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onChanged);
    _focus.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.removeListener(_onChanged);
    _focus.removeListener(_onFocusChanged);
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _onFocusChanged() {
    if (_focus.hasFocus == _hasFocus) return;
    setState(() => _hasFocus = _focus.hasFocus);
  }

  void _onChanged() {
    final q = _controller.text;
    _debounce?.cancel();
    if (q.trim().isEmpty) {
      setState(() {
        _status = _SearchStatus.idle;
        _results = const [];
        _lastQuery = '';
      });
      return;
    }
    setState(() => _status = _SearchStatus.loading);
    _debounce = Timer(const Duration(milliseconds: 300), () => _performSearch(q));
  }

  Future<void> _performSearch(String query) async {
    await Future<void>.delayed(const Duration(milliseconds: 220));
    if (!mounted) return;
    if (_controller.text != query) return;

    if (context.read<AppState>().simulateNetworkError) {
      setState(() {
        _status = _SearchStatus.error;
        _results = const [];
        _lastQuery = query;
      });
      return;
    }

    var results = searchEditions(query);
    if (_filterIndex == 1) {
      results = results.where((e) => e.format == BookFormat.text).toList();
    } else if (_filterIndex == 2) {
      results = results.where((e) => e.format == BookFormat.audio).toList();
    } else if (_filterIndex == 3 || _filterIndex == 4) {
      results = const [];
    }

    if (results.isNotEmpty && query.trim().length >= 2) {
      context.read<AppState>().addSearchQuery(query.trim());
    }

    setState(() {
      _results = results;
      _lastQuery = query;
      _status = results.isEmpty ? _SearchStatus.empty : _SearchStatus.results;
    });
  }

  void _submitQuery(String query) {
    _controller.text = query;
    _controller.selection = TextSelection.collapsed(offset: query.length);
    _focus.requestFocus();
    _debounce?.cancel();
    _performSearch(query);
  }

  void _clear() {
    _controller.clear();
    // Оставляем фокус — по оригиналу после очистки сразу открывается история.
    _focus.requestFocus();
  }

  void _onFilterTap(int i) {
    if (i == _filterIndex) return;
    setState(() => _filterIndex = i);
    if (_controller.text.isNotEmpty) {
      _performSearch(_controller.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final chipBorder =
        isDark ? AppColors.darkChipBorder : AppColors.lightChipBorder;

    // Фильтр-чипсы видны только когда есть поиск (результаты/пусто/ошибка).
    final showFilterRow = _status == _SearchStatus.results ||
        _status == _SearchStatus.empty ||
        _status == _SearchStatus.error;

    return Scaffold(
      body: SafeArea(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ---------- Строка поиска: ← [поле] × ----------
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 8, 16, 8),
              child: Row(
                children: [
                  if (_hasFocus || _controller.text.isNotEmpty)
                    IconButton(
                      onPressed: () {
                        if (_controller.text.isNotEmpty) {
                          _clear();
                        } else {
                          _focus.unfocus();
                        }
                      },
                      icon: const Icon(Icons.arrow_back_rounded, size: 24),
                      tooltip: 'Назад',
                    )
                  else
                    const SizedBox(width: 8),
                  // Поле поиска
                  Expanded(
                    child: Container(
                      height: 44,
                      decoration: BoxDecoration(
                        // Тёмная подложка в тёмной теме, светлая — в светлой.
                        color: isDark
                            ? const Color(0xFF2A2926)
                            : const Color(0xFFF2F2F4),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      alignment: Alignment.center,
                      child: TextField(
                        controller: _controller,
                        focusNode: _focus,
                        textInputAction: TextInputAction.search,
                        onSubmitted: _performSearch,
                        cursorColor: AppColors.accent,
                        style: const TextStyle(fontSize: 16),
                        onTapOutside: (_) {}, // не снимать фокус автоматически
                        decoration: InputDecoration(
                          isDense: true,
                          hintText: 'Книги, авторы, жанры',
                          hintStyle: TextStyle(
                            fontSize: 16,
                            color: isDark
                                ? const Color(0xFF7C7C82)
                                : const Color(0xFF9A9AA0),
                          ),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 12),
                          // Крестик только если есть текст
                          suffixIcon: _controller.text.isEmpty
                              ? null
                              : IconButton(
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  iconSize: 20,
                                  splashRadius: 18,
                                  icon: Icon(
                                    Icons.close_rounded,
                                    color: isDark
                                        ? const Color(0xFF9A9791)
                                        : const Color(0xFF8A8A8E),
                                  ),
                                  onPressed: _clear,
                                  tooltip: 'Очистить',
                                ),
                          suffixIconConstraints: const BoxConstraints(
                            minWidth: 28,
                            minHeight: 28,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

              // ---------- Фильтр-чипсы ----------
              if (showFilterRow)
                SizedBox(
                  height: 44,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    scrollDirection: Axis.horizontal,
                    itemCount: _filterLabels.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, i) => _FilterChip(
                      label: _filterLabels[i],
                      active: i == _filterIndex,
                      onTap: () => _onFilterTap(i),
                      borderColor: chipBorder,
                    ),
                  ),
                ),

              Expanded(child: _buildBody(state)),
            ],
          ),
        ),
      );
  }

  Widget _buildBody(AppState state) {
    switch (_status) {
      case _SearchStatus.idle:
        // В фокусе → история. Без фокуса → подборки.
        if (_hasFocus) {
          return _SearchHistoryView(
            queries: state.searchHistory,
            onQueryTap: _submitQuery,
            onRemoveQuery: (q) =>
                context.read<AppState>().removeSearchQuery(q),
            onClearQueries: () =>
                context.read<AppState>().clearSearchHistory(),
            recentBooks: state.searchOpenedBooks,
            onBookTap: (id) => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => BookDetailsScreen(editionId: id),
              ),
            ),
          );
        }
        return _IdleView(onQueryTap: _submitQuery);

      case _SearchStatus.loading:
        return const Center(child: CircularProgressIndicator());
      case _SearchStatus.results:
        return _ResultsView(query: _lastQuery, results: _results);
      case _SearchStatus.empty:
        return _EmptyView(query: _lastQuery);
      case _SearchStatus.error:
        return _ErrorView(
          onRetry: () {
            final q = _controller.text;
            if (q.trim().isEmpty) return;
            // Показываем состояние загрузки и пробуем снова.
            setState(() => _status = _SearchStatus.loading);
            _performSearch(q);
          },
        );
      }
  }
}

// ============================================================
// Экран истории (когда поле в фокусе и пустое)
// ============================================================

class _SearchHistoryView extends StatelessWidget {
  final List<String> queries;
  final ValueChanged<String> onQueryTap;
  final ValueChanged<String> onRemoveQuery;
  final VoidCallback onClearQueries;
  final List<BookEdition> recentBooks;
  final ValueChanged<String> onBookTap;

  const _SearchHistoryView({
    required this.queries,
    required this.onQueryTap,
    required this.onRemoveQuery,
    required this.onClearQueries,
    required this.recentBooks,
    required this.onBookTap,
  });

  @override
  Widget build(BuildContext context) {
    final secondary = Theme.of(context).textTheme.bodySmall?.color;

    // Обе секции пустые — показываем подсказку.
    if (queries.isEmpty && recentBooks.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Text(
            'Введите название книги, автора или жанр,\n'
            'чтобы начать поиск',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: secondary),
          ),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.only(bottom: 24),
      children: [
        // ---------- История запросов ----------
        if (queries.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 8, 4),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'История запросов',
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                ),
                TextButton(
                  onPressed: onClearQueries,
                  child: const Text('Очистить'),
                ),
              ],
            ),
          ),
          ...queries.map(
            (q) => InkWell(
              onTap: () => onQueryTap(q),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  children: [
                    Icon(Icons.search_rounded, size: 22, color: secondary),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        q,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close_rounded,
                          size: 18, color: secondary),
                      onPressed: () => onRemoveQuery(q),
                      splashRadius: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],

        // ---------- История поиска — те же строки, что и в результатах ----------
        if (recentBooks.isNotEmpty) ...[
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: Text(
              'История поиска',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
          ),
          ...recentBooks.map(
            (b) => BookRow(
              book: b,
              onTap: () => onBookTap(b.id),
            ),
          ),
        ],
      ],
    );
  }
}

// ============================================================
// Пустое состояние без фокуса: «Сейчас популярно» + «Категории»
// ============================================================

class _IdleView extends StatelessWidget {
  final ValueChanged<String> onQueryTap;

  const _IdleView({required this.onQueryTap});

  static const _popularNow = <String>[
    'Светлана Тюльбашева. Проклятая земля',
    'Последний день лета — 2',
    'Отель с неприятностями: осенняя новинка Аси Лавринович',
    'Atomic Heart. Миссия ХРАЗ',
    'Главные новинки августа',
    'Сыщик с кружевным платочком',
  ];

  static const _categories = <String>[
    'Аудио',
    'Детям',
    'Комиксы',
    'Проза',
    'Бесплатно',
    'Классика',
    'Фантастика',
    'Триллеры и хорроры',
    'Романтика',
    'Саморазвитие',
    'Психология',
    'Фэнтези',
    'Нон-фикшн',
    'Детективы',
    'Здоровье',
    'Бизнес',
    'Young Adult',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final secondary = theme.textTheme.bodySmall?.color;
    final chipBorder =
        isDark ? AppColors.darkChipBorder : AppColors.lightChipBorder;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        const Text(
          'Сейчас популярно',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        _PopularLine(items: _popularNow, onTap: onQueryTap),

        const SizedBox(height: 24),

        const Text(
          'Категории',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _categories
              .map(
                (c) => GestureDetector(
                  onTap: () => onQueryTap(c),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: chipBorder, width: 0.8),
                    ),
                    child: Text(
                      c,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

/// Строка популярных запросов через « · », каждый элемент тапается.
class _PopularLine extends StatelessWidget {
  final List<String> items;
  final ValueChanged<String> onTap;

  const _PopularLine({required this.items, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final sep = Theme.of(context).textTheme.bodySmall?.color;
    final children = <Widget>[];
    for (var i = 0; i < items.length; i++) {
      children.add(
        GestureDetector(
          onTap: () => onTap(items[i]),
          child: Text(
            items[i],
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w500,
              height: 1.5,
            ),
          ),
        ),
      );
      if (i != items.length - 1) {
        children.add(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text('·',
                style: TextStyle(fontSize: 17, color: sep)),
          ),
        );
      }
    }
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: children,
    );
  }
}

// ============================================================
// Чипс-фильтр
// ============================================================

class _FilterChip extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;
  final Color borderColor;

  const _FilterChip({
    required this.label,
    required this.active,
    required this.onTap,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final activeBg = isDark ? Colors.white : const Color(0xFF1A1A1A);
    final activeFg = isDark ? const Color(0xFF0E0E0E) : Colors.white;

    return Center(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: active ? activeBg : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            border: active
                ? null
                : Border.all(color: borderColor, width: 0.8),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: active ? activeFg : theme.textTheme.bodyLarge?.color,
              fontSize: 15,
              fontWeight: active ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// Результаты / пусто / ошибка — без изменений
// ============================================================

class _ResultsView extends StatelessWidget {
  final String query;
  final List<BookEdition> results;

  const _ResultsView({required this.query, required this.results});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, i) {
        final book = results[i];
        return BookRow(
          book: book,
          onTap: () {
            // Открытие из результатов → книга попадёт в «Историю поиска».
            context.read<AppState>().addSearchOpened(book.id);
            Navigator.of(context, rootNavigator: false).push(
              MaterialPageRoute(
                builder: (_) => BookDetailsScreen(editionId: book.id),
              ),
            );
          },
        );
      },
    );
  }
}

// ============================================================
// Ничего не найдено
// ============================================================

class _EmptyView extends StatelessWidget {
  final String query;

  const _EmptyView({required this.query});

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      imagePath: 'assets/images/not_found.png',
      fallbackIcon: Icons.search_off_rounded,
      title: 'Сейчас нет того, что вы искали',
      subtitle: 'Поищем что-нибудь еще?'
    );
  }
}

// ============================================================
// Нет подключения к сети
// ============================================================

class _ErrorView extends StatelessWidget {
  /// Действие по нажатию «Обновить». Пробрасываем из состояния экрана.
  final VoidCallback onRetry;

  const _ErrorView({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return NoInternetView(
      onRetry: onRetry,
      onOpenLocal: () {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            const SnackBar(
              content: Text('Список скачанных книг пока пуст'),
              duration: Duration(seconds: 2),
            ),
          );
      },
    );
  }
}