import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/mock_books.dart';
import '../data/mock_content.dart';
import '../models/book_edition.dart';
import '../models/chapter.dart';
import '../state/app_state.dart';
import '../theme/app_colors.dart';

class ReadScreen extends StatefulWidget {
  final String editionId;

  const ReadScreen({super.key, required this.editionId});

  @override
  State<ReadScreen> createState() => _ReadScreenState();
}

class _ReadScreenState extends State<ReadScreen> {
  final ScrollController _scroll = ScrollController();
  late final List<Chapter> _chapters;

  bool _chromeVisible = true;
  double _progress = 0;
  double _lastSavedProgress = -1;

  /// Общее число «страниц» — заглушка для «ещё N стр».
  int get _totalPages => 13;

  @override
  void initState() {
    super.initState();
    _chapters = mockChaptersFor(widget.editionId);
    _scroll.addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final state = context.read<AppState>();
      state.openBook(widget.editionId);

      final saved = state.progressOf(widget.editionId);
      if (saved > 0.01 && _scroll.hasClients) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted || !_scroll.hasClients) return;
          final max = _scroll.position.maxScrollExtent;
          _scroll.jumpTo(max * saved);
        });
      }
    });
  }

  @override
  void dispose() {
    _scroll.removeListener(_onScroll);
    _scroll.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scroll.hasClients) return;
    final max = _scroll.position.maxScrollExtent;
    if (max <= 0) return;

    final p = (_scroll.offset / max).clamp(0.0, 1.0);
    if ((p - _progress).abs() > 0.001) {
      setState(() => _progress = p);
    }
    if ((p - _lastSavedProgress).abs() >= 0.01) {
      _lastSavedProgress = p;
      context.read<AppState>().updateProgress(widget.editionId, p);
    }
  }

  void _toggleChrome() {
    setState(() => _chromeVisible = !_chromeVisible);
  }

  void _scrollToChapter(int index) {
    final total = _chapters.length;
    final fraction = index / total;
    final max = _scroll.position.maxScrollExtent;
    _scroll.animateTo(
      max * fraction,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final book = findEditionById(widget.editionId);
    if (book == null) {
      return const Scaffold(body: Center(child: Text('Книга не найдена')));
    }

    final readerTheme = context.watch<AppState>().readerTheme;
    final palette = _ReadPalette.of(readerTheme);

    // Текущая страница / сколько осталось.
    final currentPage = (_progress * _totalPages).floor() + 1;
    final pagesLeft = (_totalPages - currentPage).clamp(0, _totalPages);

    return Theme(
      data: _readerThemeData(context, palette),
      child: Scaffold(
        backgroundColor: palette.background,
        body: GestureDetector(
          onTap: _toggleChrome,
          behavior: HitTestBehavior.translucent,
          child: SafeArea(
            child: Column(
              children: [
                // ---------- Верхняя панель ----------
                _AnimatedChrome(
                  visible: _chromeVisible,
                  slideFrom: const Offset(0, -1),
                  child: _TopBar(
                    title: book.title,
                    author: book.author,
                    palette: palette,
                    onBack: () => Navigator.of(context).maybePop(),
                    onMore: () {},
                  ),
                ),

                // ---------- Текст ----------
                Expanded(
                  child: ListView.builder(
                    controller: _scroll,
                    padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                    itemCount: _chapters.length,
                    itemBuilder: (context, i) {
                      final c = _chapters[i];
                      return _ChapterView(
                        chapter: c,
                        index: i,
                        isFirst: i == 0,
                        fontFamily:
                            context.watch<AppState>().readerFontFamily,
                        fontSize:
                            context.watch<AppState>().readerFontSize,
                        palette: palette,
                      );
                    },
                  ),
                ),

                // ---------- Нижняя панель ----------
                _AnimatedChrome(
                  visible: _chromeVisible,
                  slideFrom: const Offset(0, 1),
                  child: _BottomBar(
                    palette: palette,
                    progress: _progress,
                    currentPage: currentPage,
                    pagesLeft: pagesLeft,
                    onSeek: (v) {
                      final max = _scroll.position.maxScrollExtent;
                      _scroll.jumpTo(max * v);
                    },
                    onChapters: () => _openChaptersSheet(context),
                    onBookmark: () {},
                    onSettings: () => _openSettingsSheet(context),
                    onAssistant: () {},
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openChaptersSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.6,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        builder: (context, scrollController) => ListView.builder(
          controller: scrollController,
          itemCount: _chapters.length + 1,
          itemBuilder: (context, i) {
            if (i == 0) {
              return const Padding(
                padding: EdgeInsets.fromLTRB(20, 4, 20, 12),
                child: Text(
                  'Оглавление',
                  style:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
              );
            }
            final idx = i - 1;
            return ListTile(
              leading: Text(
                _romanNumeral(idx + 1),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              title: Text(_chapters[idx].title),
              onTap: () {
                Navigator.of(context).pop();
                _scrollToChapter(idx);
              },
            );
          },
        ),
      ),
    );
  }

  void _openSettingsSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (_) => const _SettingsSheet(),
    );
  }
}

// ============================================================
// Анимация появления/скрытия панели
// ============================================================

class _AnimatedChrome extends StatelessWidget {
  final bool visible;
  final Widget child;
  final Offset slideFrom;

  const _AnimatedChrome({
    required this.visible,
    required this.child,
    required this.slideFrom,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSlide(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      offset: visible ? Offset.zero : slideFrom,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: visible ? 1 : 0,
        child: IgnorePointer(ignoring: !visible, child: child),
      ),
    );
  }
}

// ============================================================
// Верхняя панель: [v]  Название / Автор  [⋮]
// ============================================================

class _TopBar extends StatelessWidget {
  final String title;
  final String author;
  final _ReadPalette palette;
  final VoidCallback onBack;
  final VoidCallback onMore;

  const _TopBar({
    required this.title,
    required this.author,
    required this.palette,
    required this.onBack,
    required this.onMore,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: palette.background,
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      child: Row(
        children: [
          // Круглая кнопка «v»
          _CircleButton(
            icon: Icons.keyboard_arrow_down_rounded,
            bg: palette.buttonBg,
            fg: palette.text,
            onTap: onBack,
          ),
          const SizedBox(width: 12),

          // Название + автор
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: palette.text,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  author,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: palette.textSecondary,
                    fontSize: 13,
                    height: 1.15,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),

          // Круглая кнопка «⋮»
          _CircleButton(
            icon: Icons.more_vert_rounded,
            bg: palette.buttonBg,
            fg: palette.text,
            onTap: onMore,
          ),
        ],
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final Color bg;
  final Color fg;
  final VoidCallback onTap;

  const _CircleButton({
    required this.icon,
    required this.bg,
    required this.fg,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: bg,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 40,
          height: 40,
          child: Icon(icon, size: 22, color: fg),
        ),
      ),
    );
  }
}

// ============================================================
// Нижняя панель: страница ... «ещё N стр», слайдер, 4 иконки
// ============================================================

class _BottomBar extends StatelessWidget {
  final _ReadPalette palette;
  final double progress;
  final int currentPage;
  final int pagesLeft;
  final ValueChanged<double> onSeek;
  final VoidCallback onChapters;
  final VoidCallback onBookmark;
  final VoidCallback onSettings;
  final VoidCallback onAssistant;

  const _BottomBar({
    required this.palette,
    required this.progress,
    required this.currentPage,
    required this.pagesLeft,
    required this.onSeek,
    required this.onChapters,
    required this.onBookmark,
    required this.onSettings,
    required this.onAssistant,
  });

  @override
  Widget build(BuildContext context) {
    final percent = (progress * 100).round();

    return Container(
      color: palette.background,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Строка: [оглавление + №] ... «ещё N стр»
          Row(
            children: [
              GestureDetector(
                onTap: onChapters,
                child: Row(
                  children: [
                    Icon(Icons.menu_rounded,
                        size: 20, color: palette.textSecondary),
                    const SizedBox(width: 4),
                    Text(
                      '$currentPage',
                      style: TextStyle(
                        fontSize: 14,
                        color: palette.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Text(
                'ещё $pagesLeft стр',
                style: TextStyle(
                  fontSize: 14,
                  color: palette.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),

          // Слайдер
          SliderTheme(
            data: SliderThemeData(
              trackHeight: 3,
              activeTrackColor: palette.textSecondary,
              inactiveTrackColor: palette.divider,
              thumbColor: palette.textSecondary,
              overlayColor: palette.textSecondary.withValues(alpha: 0.15),
              thumbShape:
                  const RoundSliderThumbShape(enabledThumbRadius: 7),
              overlayShape:
                  const RoundSliderOverlayShape(overlayRadius: 16),
            ),
            child: Slider(
              value: progress.clamp(0.0, 1.0),
              onChanged: onSeek,
            ),
          ),

          // «1% от всей книги»
          Text(
            '$percent% от всей книги',
            style: TextStyle(
              fontSize: 14,
              color: palette.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 14),

          // Четыре иконки
          Row(
            children: [
              _BottomIcon(
                icon: Icons.format_list_bulleted_rounded,
                color: palette.text,
                onTap: onChapters,
              ),
              _BottomIcon(
                icon: Icons.bookmark_border_rounded,
                color: palette.text,
                onTap: onBookmark,
              ),
              _BottomIcon(
                icon: Icons.text_fields_rounded,
                color: palette.text,
                onTap: onSettings,
              ),
              _BottomIcon(
                icon: Icons.auto_awesome,
                color: palette.text,
                onTap: onAssistant,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BottomIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _BottomIcon({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkResponse(
        onTap: onTap,
        radius: 28,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Icon(icon, size: 26, color: color),
        ),
      ),
    );
  }
}

// ============================================================
// Глава в читалке
// ============================================================

class _ChapterView extends StatelessWidget {
  final Chapter chapter;
  final int index;
  final bool isFirst;
  final String fontFamily;
  final double fontSize;
  final _ReadPalette palette;

  const _ChapterView({
    required this.chapter,
    required this.index,
    required this.isFirst,
    required this.fontFamily,
    required this.fontSize,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      fontSize: fontSize,
      height: 1.55,
      color: palette.text,
      fontFamily: fontFamily == 'serif' ? 'Georgia' : null,
    );

    // Отступ первой строки абзаца.
    final indentStyle = style.copyWith(height: 1.55);

    return Padding(
      padding: EdgeInsets.only(top: isFirst ? 4 : 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Римский номер главы по центру
          Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Text(
              _romanNumeral(index + 1),
              textAlign: TextAlign.center,
              style: style.copyWith(
                fontSize: fontSize + 4,
                fontWeight: FontWeight.w500,
                letterSpacing: 1.5,
              ),
            ),
          ),
          // Абзацы
          ...chapter.paragraphs.map(
            (p) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                p,
                style: indentStyle,
                textAlign: TextAlign.justify,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// Sheet настроек
// ============================================================

class _SettingsSheet extends StatelessWidget {
  const _SettingsSheet();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final secondary = Theme.of(context).textTheme.bodySmall?.color;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Настройки',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 20),

          // Размер шрифта
          Text('Размер шрифта',
              style: TextStyle(fontSize: 13, color: secondary)),
          const SizedBox(height: 8),
          Row(
            children: [
              const Text('А', style: TextStyle(fontSize: 14)),
              Expanded(
                child: Slider(
                  value: state.readerFontSize,
                  min: 14,
                  max: 26,
                  divisions: 6,
                  label: state.readerFontSize.round().toString(),
                  onChanged: (v) =>
                      context.read<AppState>().setReaderFontSize(v),
                ),
              ),
              const Text('А', style: TextStyle(fontSize: 20)),
            ],
          ),

          const SizedBox(height: 16),

          // Шрифт
          Text('Шрифт', style: TextStyle(fontSize: 13, color: secondary)),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _ChipToggle(
                  label: 'С засечками',
                  active: state.readerFontFamily == 'serif',
                  onTap: () =>
                      context.read<AppState>().setReaderFontFamily('serif'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _ChipToggle(
                  label: 'Без засечек',
                  active: state.readerFontFamily == 'sans',
                  onTap: () =>
                      context.read<AppState>().setReaderFontFamily('sans'),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Тема
          Text('Тема', style: TextStyle(fontSize: 13, color: secondary)),
          const SizedBox(height: 8),
          Row(
            children: [
              _ThemeCircle(
                bg: Colors.white,
                fg: Colors.black,
                active: state.readerTheme == ReaderTheme.light,
                onTap: () => context
                    .read<AppState>()
                    .setReaderTheme(ReaderTheme.light),
              ),
              const SizedBox(width: 12),
              _ThemeCircle(
                bg: const Color(0xFFF5ECD9),
                fg: const Color(0xFF5B4636),
                active: state.readerTheme == ReaderTheme.sepia,
                onTap: () => context
                    .read<AppState>()
                    .setReaderTheme(ReaderTheme.sepia),
              ),
              const SizedBox(width: 12),
              _ThemeCircle(
                bg: const Color(0xFF21201E),
                fg: Colors.white,
                active: state.readerTheme == ReaderTheme.dark,
                onTap: () => context
                    .read<AppState>()
                    .setReaderTheme(ReaderTheme.dark),
              ),
              const SizedBox(width: 12),
              _ThemeCircle(
                bg: Colors.black,
                fg: Colors.white,
                active: state.readerTheme == ReaderTheme.black,
                onTap: () => context
                    .read<AppState>()
                    .setReaderTheme(ReaderTheme.black),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ChipToggle extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _ChipToggle({
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final border =
        isDark ? AppColors.darkChipBorder : AppColors.lightChipBorder;
    final activeBg = isDark ? Colors.white : const Color(0xFF1A1A1A);
    final activeFg = isDark ? const Color(0xFF0E0E0E) : Colors.white;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? activeBg : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: border, width: active ? 0 : 0.8),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: active ? activeFg : null,
          ),
        ),
      ),
    );
  }
}

class _ThemeCircle extends StatelessWidget {
  final Color bg;
  final Color fg;
  final bool active;
  final VoidCallback onTap;

  const _ThemeCircle({
    required this.bg,
    required this.fg,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: bg,
          shape: BoxShape.circle,
          border: Border.all(
            color:
                active ? AppColors.accent : Theme.of(context).dividerColor,
            width: active ? 2 : 1,
          ),
        ),
        child: Text(
          'Aa',
          style: TextStyle(
            color: fg,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

// ============================================================
// Палитра читалки
// ============================================================

class _ReadPalette {
  final Color background;
  final Color text;
  final Color textSecondary;
  final Color divider;
  final Color buttonBg;
  final Color accent;

  const _ReadPalette({
    required this.background,
    required this.text,
    required this.textSecondary,
    required this.divider,
    required this.buttonBg,
    required this.accent,
  });

  static _ReadPalette of(ReaderTheme theme) {
    switch (theme) {
      case ReaderTheme.light:
        return const _ReadPalette(
          background: Color(0xFFFFFFFF),
          text: Color(0xFF1A1A1A),
          textSecondary: Color(0xFF8A8A8E),
          divider: Color(0xFFE8E8EA),
          buttonBg: Color(0xFFF2F2F4),
          accent: AppColors.accent,
        );
      case ReaderTheme.sepia:
        return const _ReadPalette(
          background: Color(0xFFF5ECD9),
          text: Color(0xFF5B4636),
          textSecondary: Color(0xFF8C7B63),
          divider: Color(0xFFE2D6BD),
          buttonBg: Color(0xFFEADFC8),
          accent: AppColors.accent,
        );
      case ReaderTheme.dark:
        return const _ReadPalette(
          background: Color(0xFF21201E),
          text: Color(0xFFFFFFFF),
          textSecondary: Color(0xFF9A9791),
          divider: Color(0xFF35332F),
          buttonBg: Color(0xFF2A2926),
          accent: AppColors.accent,
        );
      case ReaderTheme.black:
        return const _ReadPalette(
          background: Color(0xFF000000),
          text: Color(0xFFFFFFFF),
          textSecondary: Color(0xFF8A8A8E),
          divider: Color(0xFF2A2A2A),
          buttonBg: Color(0xFF1C1C1C),
          accent: AppColors.accent,
        );
      case ReaderTheme.system:
      default:
        return const _ReadPalette(
          background: Color(0xFF000000),
          text: Color(0xFFFFFFFF),
          textSecondary: Color(0xFF8A8A8E),
          divider: Color(0xFF2A2A2A),
          buttonBg: Color(0xFF1C1C1C),
          accent: AppColors.accent,
        );
    }
  }
}

ThemeData _readerThemeData(BuildContext context, _ReadPalette palette) {
  return Theme.of(context).copyWith(
    scaffoldBackgroundColor: palette.background,
    colorScheme: Theme.of(context).colorScheme.copyWith(
          surface: palette.background,
        ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: palette.background,
      surfaceTintColor: Colors.transparent,
    ),
    iconTheme: IconThemeData(color: palette.text),
    textTheme: Theme.of(context).textTheme.apply(
          bodyColor: palette.text,
          displayColor: palette.text,
        ),
    sliderTheme: SliderTheme.of(context).copyWith(
          activeTrackColor: palette.textSecondary,
          inactiveTrackColor: palette.divider,
          thumbColor: palette.textSecondary,
        ),
  );
}

// ============================================================
// Римские числа
// ============================================================

String _romanNumeral(int n) {
  if (n <= 0) return '';
  const pairs = [
    [1000, 'M'],
    [900, 'CM'],
    [500, 'D'],
    [400, 'CD'],
    [100, 'C'],
    [90, 'XC'],
    [50, 'L'],
    [40, 'XL'],
    [10, 'X'],
    [9, 'IX'],
    [5, 'V'],
    [4, 'IV'],
    [1, 'I'],
  ];
  final sb = StringBuffer();
  for (final p in pairs) {
    final v = p[0] as int;
    final s = p[1] as String;
    while (n >= v) {
      sb.write(s);
      n -= v;
    }
  }
  return sb.toString();
}