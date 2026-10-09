import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/book_edition.dart';
import '../state/app_state.dart';
import '../theme/app_colors.dart';
import '../widgets/added_book_row.dart';
import 'book_details_screen.dart';

class AddedBooksScreen extends StatefulWidget {
  const AddedBooksScreen({super.key});

  @override
  State<AddedBooksScreen> createState() => _AddedBooksScreenState();
}

class _AddedBooksScreenState extends State<AddedBooksScreen> {
  final TextEditingController _search = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    _search.addListener(() {
      final q = _search.text.trim().toLowerCase();
      if (q == _query) return;
      setState(() => _query = q);
    });
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  List<BookEdition> _allBooks(AppState state) {
    return state.libraryBooks;
  }

  List<BookEdition> _filter(List<BookEdition> all) {
    if (_query.isEmpty) return all;
    return all.where((b) {
      return b.title.toLowerCase().contains(_query) ||
          b.author.toLowerCase().contains(_query) ||
          b.genres.any((g) => g.toLowerCase().contains(_query));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final all = _allBooks(state);
    final visible = _filter(all);

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // ---------- Верхняя панель: ← + поиск ----------
                Padding(
                  padding: const EdgeInsets.fromLTRB(4, 8, 16, 8),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(context).maybePop(),
                        icon: const Icon(Icons.arrow_back_rounded),
                        tooltip: 'Назад',
                      ),
                      Expanded(
                        child: Container(
                          height: 44,
                          padding:
                              const EdgeInsets.symmetric(horizontal: 14),
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF2A2926)
                                : const Color(0xFFF2F2F4),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: Alignment.center,
                          child: TextField(
                            controller: _search,
                            cursorColor: AppColors.accent,
                            style: const TextStyle(fontSize: 16),
                            decoration: InputDecoration(
                              isDense: true,
                              hintText: 'Книга, автор или интерес',
                              hintStyle: TextStyle(
                                fontSize: 16,
                                color: isDark
                                    ? const Color(0xFF7C7C82)
                                    : const Color(0xFF9A9AA0),
                              ),
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 12),
                              suffixIcon: _search.text.isEmpty
                                  ? null
                                  : IconButton(
                                      padding: EdgeInsets.zero,
                                      constraints:
                                          const BoxConstraints(),
                                      iconSize: 20,
                                      splashRadius: 18,
                                      icon: Icon(
                                        Icons.close_rounded,
                                        color: isDark
                                            ? const Color(0xFF9A9791)
                                            : const Color(0xFF8A8A8E),
                                      ),
                                      onPressed: () => _search.clear(),
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

                // ---------- Список ----------
                Expanded(
                  child: visible.isEmpty
                      ? _EmptySearch(query: _search.text)
                      : ListView.builder(
                          padding: const EdgeInsets.only(bottom: 96),
                          itemCount: visible.length,
                          itemBuilder: (context, i) {
                            final b = visible[i];
                            return AddedBookRow(
                              book: b,
                              onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => BookDetailsScreen(
                                      editionId: b.id),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),

            // ---------- Плавающая пилюля «ФИЛЬТРЫ» ----------
            Positioned(
              left: 0,
              right: 0,
              bottom: 16,
              child: Center(
                child: _FilterPill(
                  onTap: () => _openFilters(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openFilters(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (_) => const _FiltersSheet(),
    );
  }
}

// ============================================================
// Плавающая пилюля «ФИЛЬТРЫ»
// ============================================================

class _FilterPill extends StatelessWidget {
  final VoidCallback onTap;

  const _FilterPill({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Material(
      color: isDark ? const Color(0xFF2A2926) : Colors.white,
      elevation: 6,
      borderRadius: BorderRadius.circular(28),
      shadowColor: Colors.black.withValues(alpha: 0.25),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(28),
        child: Container(
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Иконка сетки
              Icon(
                Icons.grid_view_rounded,
                size: 20,
                color: theme.textTheme.bodyLarge?.color,
              ),
              const SizedBox(width: 12),
              // Вертикальный разделитель
              Container(
                width: 1,
                height: 22,
                color: theme.dividerColor,
              ),
              const SizedBox(width: 12),
              Text(
                'ФИЛЬТРЫ',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                  color: theme.textTheme.bodyLarge?.color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// Sheet «Фильтры»
// ============================================================

class _FiltersSheet extends StatelessWidget {
  const _FiltersSheet();

  static const _sortOptions = [
    'По времени добавления',
    'По названию',
    'По автору',
    'По прогрессу',
  ];

  static const _formatOptions = [
    'Книги',
    'Аудиокниги',
    'Комиксы',
  ];

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.55,
      minChildSize: 0.3,
      maxChildSize: 0.9,
      builder: (context, controller) => ListView(
        controller: controller,
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        children: [
          const Text(
            'Фильтры',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 16),

          const _GroupTitle('Сортировка'),
          ..._sortOptions.map((s) => _CheckLine(title: s, checked: false)),

          const SizedBox(height: 16),
          const _GroupTitle('Формат'),
          ..._formatOptions.map((s) => _CheckLine(title: s, checked: false)),
        ],
      ),
    );
  }
}

class _GroupTitle extends StatelessWidget {
  final String text;
  const _GroupTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 4),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.4,
          color: Theme.of(context).textTheme.bodySmall?.color,
        ),
      ),
    );
  }
}

class _CheckLine extends StatelessWidget {
  final String title;
  final bool checked;

  const _CheckLine({required this.title, required this.checked});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: Text(title, style: const TextStyle(fontSize: 16)),
            ),
            Icon(
              checked
                  ? Icons.check_circle_rounded
                  : Icons.circle_outlined,
              size: 22,
              color: checked
                  ? AppColors.accent
                  : Theme.of(context).dividerColor,
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// Пустой результат поиска
// ============================================================

class _EmptySearch extends StatelessWidget {
  final String query;

  const _EmptySearch({required this.query});

  @override
  Widget build(BuildContext context) {
    final secondary = Theme.of(context).textTheme.bodySmall?.color;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off_rounded, size: 56, color: secondary),
            const SizedBox(height: 12),
            const Text(
              'Ничего не найдено',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            Text(
              query.isEmpty
                  ? 'Список пуст'
                  : 'По запросу «$query» нет книг в этой коллекции',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: secondary),
            ),
          ],
        ),
      ),
    );
  }
}