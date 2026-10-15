import 'dart:async';
import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/mock_books.dart';
import '../models/book_edition.dart';
import '../models/impression.dart';
import '../models/quote.dart';
import '../state/app_state.dart';
import '../theme/app_colors.dart';
import '../widgets/book_cover.dart';
import 'read_screen.dart';
import 'audio_player_screen.dart';

class BookDetailsScreen extends StatefulWidget {
  final String editionId;

  const BookDetailsScreen({super.key, required this.editionId});

  @override
  State<BookDetailsScreen> createState() => _BookDetailsScreenState();
}

class _BookDetailsScreenState extends State<BookDetailsScreen> {
  AppState? _appState;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final s = context.read<AppState>();
      _appState = s;
      s.addRecentlyViewed(widget.editionId);
      s.registerOpenDetails(widget.editionId);
    });
  }

  @override
  void dispose() {
    final s = _appState;
    if (s != null) {
      // Откладываем на микротаск, чтобы не вызывать notifyListeners
      // прямо во время dispose.
      scheduleMicrotask(() => s.unregisterOpenDetails(widget.editionId));
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final book = findEditionById(widget.editionId);
    if (book == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Книга не найдена')),
      );
    }

    final state = context.watch<AppState>();
    final inLibrary = state.isInLibrary(book.id);

    final otherEditions = otherEditionsOf(book);
    final readWith = editionsByIds(book.readWithIds);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // ---------- Верхняя панель иконок ----------
            _TopBar(
              inLibrary: inLibrary,
              onBack: () => Navigator.of(context).maybePop(),
              onToggleLibrary: () {
                final added =
                    context.read<AppState>().toggleLibrary(book.id);
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      content: Text(
                        added
                            ? '«${book.title}» добавлена в «Мои книги»'
                            : '«${book.title}» удалена из «Моих книг»',
                      ),
                      duration: const Duration(seconds: 2),
                    ),
                  );
              },
            ),

            // ---------- Табы Текст / Аудио ----------
            if (otherEditions.isNotEmpty)
              _FormatTabs(
                current: book.format,
                hasText: book.format == BookFormat.text ||
                    otherEditions.any((e) => e.format == BookFormat.text),
                hasAudio: book.format == BookFormat.audio ||
                    otherEditions.any((e) => e.format == BookFormat.audio),
                onTextTap: () {
                  if (book.format != BookFormat.text) {
                    final text = otherEditions.firstWhere(
                      (e) => e.format == BookFormat.text,
                      orElse: () => book,
                    );
                    _replaceWith(context, text.id);
                  }
                },
                onAudioTap: () {
                  if (book.format != BookFormat.audio) {
                    final audio = otherEditions.firstWhere(
                      (e) => e.format == BookFormat.audio,
                      orElse: () => book,
                    );
                    _replaceWith(context, audio.id);
                  }
                },
              ),

            // ---------- Скроллируемый контент ----------
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(bottom: 32),
                children: [
                  // Обложка
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                    child: Center(
                      child: _CoverWithGlow(book: book),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Название + автор
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        Text(
                          book.title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            height: 1.25,
                            letterSpacing: -0.4,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          book.author,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            color:
                                Theme.of(context).textTheme.bodySmall?.color,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Статистика
                  _StatsRow(book: book),
                  const SizedBox(height: 20),

                  // Кнопки Читать / Слушать
                  _ReadListenButtons(
                    book: book,
                    onRead: () {
                      // Пробуем найти текстовую версию.
                      final textId = book.format == BookFormat.text
                          ? book.id
                          : otherEditionsOf(book)
                              .firstWhere((e) => e.format == BookFormat.text,
                                  orElse: () => book)
                              .id;
                      context.read<AppState>().openBook(textId);
                      Navigator.of(context, rootNavigator: true).push(
                        MaterialPageRoute(
                            builder: (_) => ReadScreen(editionId: textId)),
                      );
                    },
                    onListen: () {
                      // Пробуем найти аудио-версию.
                      final audioId = book.format == BookFormat.audio
                          ? book.id
                          : otherEditionsOf(book)
                              .firstWhere((e) => e.format == BookFormat.audio,
                                  orElse: () => book)
                              .id;
                      context.read<AppState>().openBook(audioId);
                      Navigator.of(context, rootNavigator: true).push(
                        MaterialPageRoute(
                            builder: (_) => AudioPlayerScreen(editionId: audioId)),
                      );
                    },
                  ),

                  // Описание
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _DescriptionBlock(book: book),
                  ),
                  const SizedBox(height: 12),

                  // Возраст / год
                  if (book.ageRestriction != null ||
                      book.originalYear != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: _MetaLines(book: book),
                    ),
                  const SizedBox(height: 16),

                  // Жанры
                  if (book.genres.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: _GenreChips(genres: book.genres),
                    ),

                  // «Другие версии книги»
                  if (otherEditions.isNotEmpty) ...[
                    const _SectionHeader(title: 'Другие версии книги'),
                    _BookCarousel(
                      books: otherEditions,
                      onTap: (b) => _replaceWith(context, b.id),
                    ),
                  ],

                  // «С этой книгой читают»
                  if (readWith.isNotEmpty) ...[
                    _SectionHeader(
                      title: 'С этой книгой читают',
                      trailing: _LinkButton('Все', () {}),
                    ),
                    _BookCarousel(
                      books: readWith,
                      onTap: (b) => _pushDetails(context, b.id),
                    ),
                  ],

                  // Цитаты
                  if (book.quotes.isNotEmpty) ...[
                    _SectionHeader(
                      title: 'Цитаты',
                      trailing: _LinkButton('Все', () {}),
                    ),
                    ...book.quotes
                        .take(3)
                        .map((q) => _QuoteCard(quote: q)),
                    if (book.quotesCount > 3)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                        child: _BigOutlineButton(
                          label: 'Показать все (${book.quotesCount})',
                          onTap: () {},
                        ),
                      ),
                  ],

                  // Впечатления
                  if (book.impressions.isNotEmpty ||
                      book.impressionsCount > 0) ...[
                    _SectionHeader(
                      title: 'Впечатления',
                      trailing: _LinkButton('Все', () {}),
                    ),
                    _ImpressionsBlock(book: book),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _replaceWith(BuildContext context, String editionId) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => BookDetailsScreen(editionId: editionId),
      ),
    );
  }

  void _pushDetails(BuildContext context, String editionId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BookDetailsScreen(editionId: editionId),
      ),
    );
  }

  void _openReader(BuildContext context, BookEdition book) {
    context.read<AppState>().openBook(book.id);

    if (book.isAudio) {
      Navigator.of(context, rootNavigator: true).push(
        MaterialPageRoute(
          builder: (_) => AudioPlayerScreen(editionId: book.id),
        ),
      );
    } else {
      Navigator.of(context, rootNavigator: true).push(
        MaterialPageRoute(
          builder: (_) => ReadScreen(editionId: book.id),
        ),
      );
    }
  }
}

// ============================================================
// Верхняя панель иконок
// ============================================================

class _TopBar extends StatelessWidget {
  final bool inLibrary;
  final VoidCallback onBack;
  final VoidCallback onToggleLibrary;

  const _TopBar({
    required this.inLibrary,
    required this.onBack,
    required this.onToggleLibrary,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back_rounded),
            tooltip: 'Назад',
          ),
          const Spacer(),
          IconButton(
            onPressed: onToggleLibrary,
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              transitionBuilder: (c, a) => ScaleTransition(scale: a, child: c),
              child: Icon(
                inLibrary ? Icons.check_rounded : Icons.add_rounded,
                key: ValueKey<bool>(inLibrary),
              ),
            ),
            tooltip: inLibrary ? 'В библиотеке' : 'В библиотеку',
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.ios_share_rounded),
            tooltip: 'Поделиться',
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert_rounded),
            tooltip: 'Ещё',
          ),
        ],
      ),
    );
  }
}

// ============================================================
// Табы Текст / Аудио
// ============================================================

class _FormatTabs extends StatelessWidget {
  final BookFormat current;
  final bool hasText;
  final bool hasAudio;
  final VoidCallback onTextTap;
  final VoidCallback onAudioTap;

  const _FormatTabs({
    required this.current,
    required this.hasText,
    required this.hasAudio,
    required this.onTextTap,
    required this.onAudioTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Row(
        children: [
          if (hasText)
            _FormatTab(
              label: 'Текст',
              active: current == BookFormat.text,
              onTap: onTextTap,
            ),
          if (hasText && hasAudio) const SizedBox(width: 24),
          if (hasAudio)
            _FormatTab(
              label: 'Аудио',
              active: current == BookFormat.audio,
              onTap: onAudioTap,
            ),
        ],
      ),
    );
  }
}

class _FormatTab extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _FormatTab({
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final inactiveColor = theme.textTheme.bodySmall?.color;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                color: active ? theme.textTheme.bodyLarge?.color : inactiveColor,
              ),
            ),
            const SizedBox(height: 6),
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              height: 2,
              width: active ? 40 : 0,
              decoration: BoxDecoration(
                color: theme.textTheme.bodyLarge?.color,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// Статистика: Страницы · Читают · Цитаты · Впечатления · Полки
// ============================================================

class _StatsRow extends StatelessWidget {
  final BookEdition book;

  const _StatsRow({required this.book});

  @override
  Widget build(BuildContext context) {
    final secondary = Theme.of(context).textTheme.bodySmall?.color;

    final items = <_StatItem>[
      if (book.pages > 0) _StatItem('${book.pages}', 'Страницы'),
      _StatItem(book.readersLabel, 'Читают'),
      _StatItem(book.quotesLabel, 'Цитаты'),
      _StatItem(book.impressionsLabel, 'Впечатлений'),
      _StatItem(book.shelvesLabel, 'Полок'),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: items
            .map(
              (it) => Expanded(
                child: Column(
                  children: [
                    Text(
                      it.value,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      it.label,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 11,
                        color: secondary,
                        height: 1.1,
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _StatItem {
  final String value;
  final String label;

  _StatItem(this.value, this.label);
}

// ============================================================
// Кнопки «Читать» / «Слушать» в одной плашке
// ============================================================

class _ReadListenButtons extends StatelessWidget {
  final BookEdition book;
  final VoidCallback onRead;   // тексту
  final VoidCallback onListen; // аудио

  const _ReadListenButtons({
    required this.book,
    required this.onRead,
    required this.onListen,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bg = isDark ? Colors.white : const Color(0xFF1A1A1A);
    final fg = isDark ? const Color(0xFF1A1A1A) : Colors.white;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Container(
        height: 46,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: onRead,
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(10),
                ),
                child: Center(
                  child: Text('Читать',
                      style: TextStyle(
                          color: fg,
                          fontSize: 14,
                          fontWeight: FontWeight.w700)),
                ),
              ),
            ),
            Container(
              width: 0.5,
              height: 24,
              color: fg.withValues(alpha: 0.2),
            ),
            Expanded(
              child: InkWell(
                onTap: onListen,
                borderRadius: const BorderRadius.horizontal(
                  right: Radius.circular(10),
                ),
                child: Center(
                  child: Text('Слушать',
                      style: TextStyle(
                          color: fg,
                          fontSize: 14,
                          fontWeight: FontWeight.w700)),
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
// Описание
// ============================================================

class _DescriptionBlock extends StatefulWidget {
  final BookEdition book;

  const _DescriptionBlock({required this.book});

  @override
  State<_DescriptionBlock> createState() => _DescriptionBlockState();
}

class _DescriptionBlockState extends State<_DescriptionBlock> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 220),
          crossFadeState: _expanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          firstChild: Text(
            widget.book.description,
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 15, height: 1.4),
          ),
          secondChild: Text(
            widget.book.description,
            style: const TextStyle(fontSize: 15, height: 1.4),
          ),
        ),
        GestureDetector(
          onTap: () => setState(() => _expanded = !_expanded),
          child: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              _expanded ? 'Свернуть' : 'Ещё',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ============================================================
// Возраст / год
// ============================================================

class _MetaLines extends StatelessWidget {
  final BookEdition book;

  const _MetaLines({required this.book});

  @override
  Widget build(BuildContext context) {
    final secondary = Theme.of(context).textTheme.bodySmall?.color;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (book.ageRestriction != null)
          Text(
            'ВОЗРАСТНЫЕ ОГРАНИЧЕНИЯ: ${book.ageRestriction}',
            style: TextStyle(
              fontSize: 11,
              letterSpacing: 0.5,
              color: secondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        if (book.ageRestriction != null && book.originalYear != null)
          const SizedBox(height: 4),
        if (book.originalYear != null)
          Text(
            'ПУБЛИКАЦИЯ ОРИГИНАЛА: ${book.originalYear}',
            style: TextStyle(
              fontSize: 11,
              letterSpacing: 0.5,
              color: secondary,
              fontWeight: FontWeight.w500,
            ),
          ),
      ],
    );
  }
}

// ============================================================
// Жанры
// ============================================================

class _GenreChips extends StatelessWidget {
  final List<String> genres;

  const _GenreChips({required this.genres});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final border =
        isDark ? AppColors.darkChipBorder : AppColors.lightChipBorder;

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: genres
          .map(
            (g) => Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: border, width: 0.8),
              ),
              child: Text(
                g,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

// ============================================================
// Заголовок секции
// ============================================================

class _SectionHeader extends StatelessWidget {
  final String title;
  final Widget? trailing;

  const _SectionHeader({required this.title, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.3,
              ),
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

class _LinkButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _LinkButton(this.label, this.onTap);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        label,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: Theme.of(context).textTheme.bodySmall?.color,
        ),
      ),
    );
  }
}

// ============================================================
// Карусель книг
// ============================================================

class _BookCarousel extends StatelessWidget {
  final List<BookEdition> books;
  final ValueChanged<BookEdition> onTap;

  const _BookCarousel({required this.books, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final secondary = Theme.of(context).textTheme.bodySmall?.color;

    return SizedBox(
      height: 235,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: books.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, i) {
          final b = books[i];
          return GestureDetector(
            onTap: () => onTap(b),
            child: SizedBox(
              width: 130,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BookCover(
                    book: b,
                    width: 130,
                    height: 174,
                    radius: 6,
                    heroTag: 'carousel_${b.id}',
                  ),
                  const SizedBox(height: 6),
                  Text(
                    b.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    b.author,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 11, color: secondary),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ============================================================
// Карточка цитаты (как пост пользователя)
// ============================================================

class _QuoteCard extends StatelessWidget {
  final Quote quote;

  const _QuoteCard({required this.quote});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final secondary = theme.textTheme.bodySmall?.color;
    final cardBg = isDark ? const Color(0xFF2A2926) : const Color(0xFFF7F7F9);

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Шапка: аватар, имя, время, ⋮
          Row(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: AppColors.accent.withValues(alpha: 0.15),
                child: Text(
                  quote.author.characters.first.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.accent,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                quote.author,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                quote.timeAgo,
                style: TextStyle(fontSize: 12, color: secondary),
              ),
              const Spacer(),
              Icon(Icons.more_vert_rounded, size: 18, color: secondary),
            ],
          ),
          const SizedBox(height: 10),
          // Вертикальная полоса слева + текст цитаты
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  width: 3,
                  decoration: BoxDecoration(
                    color: AppColors.accent.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    quote.text,
                    style: const TextStyle(fontSize: 14, height: 1.4),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          // Нижняя панель действий
          Row(
            children: [
              _ActionIcon(
                icon: Icons.favorite_border_rounded,
                label: '${quote.likes}',
              ),
              const SizedBox(width: 18),
              _ActionIcon(icon: Icons.chat_bubble_outline_rounded),
              const Spacer(),
              _ActionIcon(icon: Icons.ios_share_rounded),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionIcon extends StatelessWidget {
  final IconData icon;
  final String? label;

  const _ActionIcon({required this.icon, this.label});

  @override
  Widget build(BuildContext context) {
    final secondary = Theme.of(context).textTheme.bodySmall?.color;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: secondary),
        if (label != null) ...[
          const SizedBox(width: 4),
          Text(label!, style: TextStyle(fontSize: 13, color: secondary)),
        ],
      ],
    );
  }
}

// ============================================================
// «Показать все» — большая кнопка-контур
// ============================================================

class _BigOutlineButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _BigOutlineButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final border =
        isDark ? AppColors.darkChipBorder : AppColors.lightChipBorder;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: border, width: 0.8),
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

// ============================================================
// Блок «Впечатления»
// ============================================================

class _ImpressionsBlock extends StatelessWidget {
  final BookEdition book;

  const _ImpressionsBlock({required this.book});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final secondary = theme.textTheme.bodySmall?.color;
    final cardBg = isDark ? const Color(0xFF2A2926) : const Color(0xFFF7F7F9);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Прогресс-бар распределения реакций
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Row(
              children: [
                Expanded(
                  flex: 64,
                  child: Container(height: 4, color: const Color(0xFFFFC107)),
                ),
                Expanded(
                  flex: 12,
                  child: Container(height: 4, color: const Color(0xFFFF7043)),
                ),
                Expanded(
                  flex: 9,
                  child: Container(height: 4, color: const Color(0xFF8E24AA)),
                ),
                Expanded(
                  flex: 15,
                  child: Container(height: 4, color: Colors.transparent),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Сводка реакций
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              _ImpressionStat(
                emoji: '👍',
                count: 64,
                label: 'Советую',
              ),
              const SizedBox(width: 24),
              _ImpressionStat(
                emoji: '💡',
                count: 12,
                label: 'Познавательно',
              ),
              const SizedBox(width: 24),
              _ImpressionStat(
                emoji: '😈',
                count: 9,
                label: 'Мудро',
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // «Уже читали? Как вам?»
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const Text(
                'Уже читали? Как вам?',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: const Center(
                        child: Text('👍', style: TextStyle(fontSize: 20)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: const Center(
                        child: Text('👎', style: TextStyle(fontSize: 20)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Карточки впечатлений
        ...book.impressions.map((imp) => _ImpressionCard(impression: imp)),

        // «Показать все»
        if (book.impressionsCount > book.impressions.length)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: _BigOutlineButton(
              label: 'Показать все (${book.impressionsCount})',
              onTap: () {},
            ),
          ),
      ],
    );
  }
}

class _ImpressionStat extends StatelessWidget {
  final String emoji;
  final int count;
  final String label;

  const _ImpressionStat({
    required this.emoji,
    required this.count,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final secondary = Theme.of(context).textTheme.bodySmall?.color;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 4),
            Text(
              '$count',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(label, style: TextStyle(fontSize: 12, color: secondary)),
      ],
    );
  }
}

class _ImpressionCard extends StatelessWidget {
  final Impression impression;

  const _ImpressionCard({required this.impression});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final secondary = theme.textTheme.bodySmall?.color;
    final cardBg = isDark ? const Color(0xFF2A2926) : const Color(0xFFF7F7F9);
    final tagBg = isDark
        ? const Color(0xFF3A3428)
        : const Color(0xFFFFF2D8);
    final tagFg = isDark
        ? const Color(0xFFFFD166)
        : const Color(0xFF8B6B00);

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Шапка
          Row(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: AppColors.accent.withValues(alpha: 0.15),
                child: Text(
                  impression.author.characters.first.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.accent,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                impression.author,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                impression.timeAgo,
                style: TextStyle(fontSize: 12, color: secondary),
              ),
              const Spacer(),
              Icon(Icons.more_vert_rounded, size: 18, color: secondary),
            ],
          ),
          const SizedBox(height: 10),

          // Тег «Советую»
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 255, 245, 188),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(impression.tagEmoji,
                    style: const TextStyle(fontSize: 13)),
                const SizedBox(width: 4),
                Text(
                  impression.tagLabel,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: tagFg,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Текст
          Text(
            impression.text,
            style: const TextStyle(fontSize: 14, height: 1.4),
          ),
          const SizedBox(height: 10),

          // Действия
          Row(
            children: [
              _ActionIcon(
                icon: Icons.favorite_border_rounded,
                label: '${impression.likes}',
              ),
              const SizedBox(width: 18),
              _ActionIcon(icon: Icons.chat_bubble_outline_rounded),
              const Spacer(),
              _ActionIcon(icon: Icons.ios_share_rounded),
            ],
          ),
        ],
      ),
    );
  }
  
}

// ============================================================
// Обложка с размытым «облаком» позади
// ============================================================

class _CoverWithGlow extends StatelessWidget {
  final BookEdition book;

  const _CoverWithGlow({required this.book});

  @override
  Widget build(BuildContext context) {
    // У аудиокниг обложка квадратная, у текстовых — вертикальная.
    final isAudio = book.isAudio;
    final w = isAudio ? 260.0 : 200.0;
    final h = isAudio ? 260.0 : 288.0;
    final radius = isAudio ? 12.0 : 8.0;

    // Облако чуть больше обложки.
    final glowW = w + 60;
    final glowH = h + 60;

    return SizedBox(
      width: glowW,
      height: glowH,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Размытое облако
          IgnorePointer(
            child: Opacity(
              opacity: 0.55,
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 48, sigmaY: 48),
                child: BookCover(
                  book: book,
                  width: glowW,
                  height: glowH,
                  radius: 20,
                  square: isAudio,
                ),
              ),
            ),
          ),
          // Чёткая обложка
          BookCover(
            book: book,
            width: w,
            height: h,
            radius: radius,
            heroTag: 'cover_${book.id}',
            square: isAudio,
          ),
        ],
      ),
    );
  }
}