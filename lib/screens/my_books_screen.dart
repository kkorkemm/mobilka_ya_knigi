import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/book_edition.dart';
import '../models/shelf.dart';
import '../state/app_state.dart';
import '../theme/app_colors.dart';
import '../widgets/book_cover.dart';
import '../widgets/library_section_row.dart';
import 'book_details_screen.dart';
import 'added_books_screen.dart';
import '../navigation/tab_switcher.dart';

class MyBooksScreen extends StatelessWidget {
  const MyBooksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final library = state.libraryBooks;
    final current = state.currentEdition;
    final continueBooks = state.continueBooks;
    final finishedCount = state.finishedBooks.length;

    // «Горизонтальная лента» — все книги с прогрессом (кроме текущей).
    final progressBooks =
    continueBooks.where((b) => b.id != current?.id).toList();

    final hasAnything = library.isNotEmpty ||
        current != null ||
        continueBooks.isNotEmpty;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(bottom: 32),
          children: [
            // ---------- Заголовок ----------
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Text(
                'Мои книги',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.6,
                ),
              ),
            ),

            // ---------- Карточка статистики ----------
            _StatsCard(state: state),

            const SizedBox(height: 16),

            // ---------- Пусто / контент ----------
            if (!hasAnything)
              _EmptyLibraryCard(
                onFindBooks: () {
                  TabSwitcher.of(context)?.switchTo(TabIndex.search);
                },
              )
            else ...[
              // Крупная карточка текущей книги
              if (current != null)
                _CurrentBookCard(
                  book: current,
                  progress: state.progressOf(current.id),
                  onRead: () => _openDetails(context, current.id),
                ),

              // Горизонтальная лента обложек с процентами
              if (progressBooks.isNotEmpty) ...[
                const SizedBox(height: 16),
                SizedBox(
                  height: 210,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: progressBooks.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, i) {
                      final b = progressBooks[i];
                      return _ProgressCover(
                        book: b,
                        progress: state.progressOf(b.id),
                        onTap: () => _openDetails(context, b.id),
                      );
                    },
                  ),
                ),
              ],

              const SizedBox(height: 16),
            ],

            // ---------- Список секций ----------
            LibrarySectionRow(
              icon: Icons.bookmark_border_rounded,
              title: 'Добавленные',
              count: library.length,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const AddedBooksScreen()),
                );
              },
            ),
            LibrarySectionRow(
              icon: Icons.phone_android_rounded,
              title: 'Серии',
              count: library.where((b) => b.seriesTitle != null).length,
              onTap: () {},
            ),
            const LibrarySectionRow(
              icon: Icons.person_outline_rounded,
              title: 'Подписки на авторов',
              count: 0,
            ),
            LibrarySectionRow(
              icon: Icons.emoji_emotions_outlined,
              title: 'Впечатления',
              count: 0,
              onTap: () {},
            ),
            LibrarySectionRow(
              icon: Icons.auto_awesome_outlined,
              title: 'Цитаты',
              count: library.fold<int>(
                  0, (acc, b) => acc + b.quotesCount),
              onTap: () {},
            ),
            LibrarySectionRow(
              icon: Icons.edit_outlined,
              title: 'Законченные',
              count: finishedCount,
              onTap: () {},
            ),
            const LibrarySectionRow(
              icon: Icons.cloud_download_outlined,
              title: 'На устройстве',
              count: 0,
            ),
            LibrarySectionRow(
              icon: Icons.menu_book_outlined,
              title: 'Все книги',
              count: library.length,
              onTap: () {},
            ),

            const SizedBox(height: 16),

            // ---------- Нижние действия ----------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: _BottomAction(
                      icon: Icons.bar_chart_rounded,
                      label: 'СОЗДАТЬ ПОЛКУ',
                      onTap: () {},
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: _BottomAction(
                      icon: Icons.file_upload_outlined,
                      label: 'ЗАГРУЗИТЬ БЕСПЛАТНО',
                      onTap: () {},
                    ),
                  ),
                ],
              ),
            ),

            // ---------- Мои полки ----------
            if (state.shelves.isNotEmpty) ...[
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 32, 16, 12),
                child: Text(
                  'Мои полки',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.4,
                  ),
                ),
              ),
              ...state.shelves.map((s) => _ShelfRow(shelf: s)),
            ],
          ],
        ),
      ),
    );
  }

  void _openDetails(BuildContext context, String id) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => BookDetailsScreen(editionId: id)),
    );
  }
}

// ============================================================
// Карточка статистики
// ============================================================

class _StatsCard extends StatelessWidget {
  final AppState state;

  const _StatsCard({required this.state});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final secondary = theme.textTheme.bodySmall?.color;
    final cardBg = isDark ? const Color(0xFF2A2926) : const Color(0xFFF7F7F9);
    final divider =
        isDark ? AppColors.darkDivider : AppColors.lightDivider;

    final totalRead = state.totalBooksRead;
    // Псевдопрогресс: сколько из 5 книг прочитано (для полоски).
    final progress = (totalRead / 5).clamp(0.0, 1.0);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(14),
        ),
        padding: const EdgeInsets.fromLTRB(16, 14, 8, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Верхняя строка: три показателя + стрелка
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _StatColumn(
                    label: 'сегодня',
                    value: '${state.minutesToday} мин',
                  ),
                ),
                Expanded(
                  child: _StatColumn(
                    label: 'в сентябре',
                    value: '${state.daysThisMonth} ${_pluralDays(state.daysThisMonth)}',
                  ),
                ),
                Expanded(
                  child: _StatColumn(
                    label: 'подряд',
                    value: '${state.streakDays} ${_pluralDays(state.streakDays)}',
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(right: 4, top: 2),
                  child: Icon(Icons.chevron_right_rounded, size: 24),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Нижняя строка: бейджи + «N книг прочитаны» + полоска + info
            Row(
              children: [
                // Имитация бейджей — 3 кружка с градиентами
                SizedBox(
                  width: 70,
                  height: 32,
                  child: Stack(
                    children: [
                      _Badge(gradient: AppColors.coverGradients[0], left: 0),
                      _Badge(gradient: AppColors.coverGradients[2], left: 20),
                      _Badge(gradient: AppColors.coverGradients[5], left: 40),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$totalRead ${_pluralBooks(totalRead)} ${_pluralRead(totalRead)}',
                        style: TextStyle(fontSize: 13, color: secondary),
                      ),
                      const SizedBox(height: 6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(2),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 3,
                          backgroundColor:
                              divider.withValues(alpha: 0.6),
                          valueColor: AlwaysStoppedAnimation(
                            secondary ?? Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.info_outline_rounded,
                      size: 18, color: secondary),
                  splashRadius: 18,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static String _pluralDays(int n) {
    final m10 = n % 10;
    final m100 = n % 100;
    if (m10 == 1 && m100 != 11) return 'день';
    if (m10 >= 2 && m10 <= 4 && (m100 < 12 || m100 > 14)) return 'дня';
    return 'дней';
  }

  static String _pluralBooks(int n) {
    final m10 = n % 10;
    final m100 = n % 100;
    if (m10 == 1 && m100 != 11) return 'книга';
    if (m10 >= 2 && m10 <= 4 && (m100 < 12 || m100 > 14)) return 'книги';
    return 'книг';
  }

  static String _pluralRead(int n) {
    final m10 = n % 10;
    final m100 = n % 100;
    if (m10 == 1 && m100 != 11) return 'прочитана';
    return 'прочитаны';
  }
}

class _StatColumn extends StatelessWidget {
  final String label;
  final String value;

  const _StatColumn({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final secondary = Theme.of(context).textTheme.bodySmall?.color;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 13, color: secondary)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            height: 1.1,
          ),
        ),
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  final List<Color> gradient;
  final double left;

  const _Badge({required this.gradient, required this.left});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      top: 0,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: gradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(
            color: Theme.of(context).scaffoldBackgroundColor,
            width: 2,
          ),
        ),
        child: const Icon(Icons.menu_book_rounded,
            size: 14, color: Colors.white),
      ),
    );
  }
}

// ============================================================
// Пустая библиотека
// ============================================================

class _EmptyLibraryCard extends StatelessWidget {
  final VoidCallback onFindBooks;

  const _EmptyLibraryCard({required this.onFindBooks});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final secondary = theme.textTheme.bodySmall?.color;
    final cardBg = isDark ? const Color(0xFF2A2926) : const Color(0xFFF7F7F9);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 32, 24, 28),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Image.asset(
              'assets/images/pora_v_library.png',
              width: 180,
              height: 160,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) =>
                  const _EmptyLibraryIllustration(),
            ),
            const SizedBox(height: 24),
            const Text(
              'Пора в Библиотеку',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.4,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'А здесь будет всё, что вам\nзахочется почитать',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: secondary,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 24),
            // Белая пилюля
            SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: onFindBooks,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isDark ? Colors.white : const Color(0xFF1A1A1A),
                  foregroundColor:
                      isDark ? const Color(0xFF1A1A1A) : Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: const Text(
                  'Найти интересные книги',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Рисованная заглушка — открытая книга с красной звездой.
/// Используется, пока нет assets/images/empty_library.png.
class _EmptyLibraryIllustration extends StatelessWidget {
  const _EmptyLibraryIllustration();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      height: 160,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Левая страница
          Transform.rotate(
            angle: -0.15,
            child: Container(
              width: 90,
              height: 120,
              decoration: BoxDecoration(
                color: const Color(0xFFFFF0DC),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          // Правая страница
          Transform.translate(
            offset: const Offset(30, -6),
            child: Transform.rotate(
              angle: 0.2,
              child: Container(
                width: 90,
                height: 120,
                decoration: BoxDecoration(
                  color: const Color(0xFFFCE0C0),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
          // Звезда
          const Icon(
            Icons.star_rounded,
            size: 56,
            color: Color(0xFFFC3F1D),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// Крупная карточка текущей книги
// ============================================================

class _CurrentBookCard extends StatelessWidget {
  final BookEdition book;
  final double progress;
  final VoidCallback onRead;

  const _CurrentBookCard({
    required this.book,
    required this.progress,
    required this.onRead,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final secondary = theme.textTheme.bodySmall?.color;
    final cardBg = isDark ? const Color(0xFF2A2926) : const Color(0xFFF7F7F9);
    final divider =
        isDark ? AppColors.darkDivider : AppColors.lightDivider;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.fromLTRB(16, 14, 8, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Заголовок: название + автор
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        book.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        book.author,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 13, color: secondary),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.ios_share_rounded, size: 20),
                  splashRadius: 22,
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.more_horiz_rounded, size: 20),
                  splashRadius: 22,
                ),
              ],
            ),
            const SizedBox(height: 4),

            // Крупная обложка по центру
            Center(
              child: BookCover(
                book: book,
                width: 150,
                height: 220,
                radius: 8,
                heroTag: 'current_${book.id}',
              ),
            ),
            const SizedBox(height: 18),

            // Прогресс-бар
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 3,
                      backgroundColor: divider.withValues(alpha: 0.6),
                      valueColor: AlwaysStoppedAnimation(
                        secondary ?? Colors.grey,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${(progress * 100).round()}% от всей книги',
                    style: TextStyle(fontSize: 12, color: secondary),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Кнопка «Читать» / «Слушать» по центру
            Center(
              child: SizedBox(
                height: 44,
                child: ElevatedButton.icon(
                  onPressed: onRead,
                  icon: book.isAudio
                      ? const Icon(Icons.play_arrow_rounded, size: 20)
                      : const Icon(Icons.subject_rounded, size: 20),
                  label: Text(book.isAudio ? 'Слушать' : 'Читать'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isDark ? Colors.white : const Color(0xFF1A1A1A),
                    foregroundColor:
                        isDark ? const Color(0xFF1A1A1A) : Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// Обложка с процентом в углу
// ============================================================

class _ProgressCover extends StatelessWidget {
  final BookEdition book;
  final double progress;
  final VoidCallback onTap;

  const _ProgressCover({
    required this.book,
    required this.progress,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 140,
        height: 210,
        child: Stack(
          children: [
            BookCover(
              book: book,
              width: 140,
              height: 210,
              radius: 6,
            ),
            // Бейдж с процентом в правом верхнем углу
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.65),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${(progress * 100).round()}%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// Нижние действия
// ============================================================

class _BottomAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _BottomAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final secondary = Theme.of(context).textTheme.bodySmall?.color;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, size: 26, color: secondary),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              letterSpacing: 0.5,
              color: secondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// Строка полки
// ============================================================

class _ShelfRow extends StatelessWidget {
  final Shelf shelf;

  const _ShelfRow({required this.shelf});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final secondary = theme.textTheme.bodySmall?.color;
    final divider =
        isDark ? AppColors.darkDivider : AppColors.lightDivider;

    return InkWell(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: divider, width: 0.5),
          ),
        ),
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        child: Row(
          children: [
            // Квадратная «плитка» полки — градиент
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                gradient: const LinearGradient(
                  colors: [Color(0xFF7FD2E8), Color(0xFF4A9BD1)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    shelf.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: divider,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '${shelf.booksCount} книг',
                          style: TextStyle(
                              fontSize: 11, color: secondary),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(Icons.person_outline_rounded,
                          size: 12, color: secondary),
                      const SizedBox(width: 3),
                      Text(
                        '${shelf.followers}',
                        style:
                            TextStyle(fontSize: 12, color: secondary),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded,
                size: 22, color: secondary),
          ],
        ),
      ),
    );
  }
}