import 'dart:ui' show ImageFilter;
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/mock_audio.dart';
import '../data/mock_books.dart';
import '../models/audio_chapter.dart';
import '../models/book_edition.dart';
import '../state/app_state.dart';
import '../theme/app_colors.dart';
import '../widgets/book_cover.dart';
import 'book_details_screen.dart';
import 'read_screen.dart';

class AudioPlayerScreen extends StatefulWidget {
  final String editionId;

  const AudioPlayerScreen({super.key, required this.editionId});

  @override
  State<AudioPlayerScreen> createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
  Timer? _ticker;
  late final List<AudioChapter> _chapters;
  late final int _totalSeconds;

  @override
  void initState() {
    super.initState();
    final book = findEditionById(widget.editionId);
    _totalSeconds = book?.audioDuration?.inSeconds ?? 1;
    _chapters = mockAudioChapters(
      book?.audioDuration ?? const Duration(hours: 1),
    );

    // Помечаем книгу открытой и запускаем воспроизведение.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final state = context.read<AppState>();
      state.openBook(widget.editionId);
      state.registerOpenDetails(widget.editionId);
      state.setPlaying(true);
    });

    // Простейший тикер: двигает позицию каждую секунду, пока играет.
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      final state = context.read<AppState>();
      if (!state.isPlaying) return;
      final next = state.audioPositionSeconds(widget.editionId) + 1;
      if (next >= _totalSeconds) {
        state.setAudioPosition(widget.editionId, _totalSeconds);
        state.setPlaying(false);
      } else {
        state.setAudioPosition(widget.editionId, next);
        // Прогресс для мини-плеера.
        state.updateProgress(
            widget.editionId, next / _totalSeconds);
      }
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  AudioChapter get _currentChapter {
    final pos = context.read<AppState>().audioPositionSeconds(widget.editionId);
    for (final c in _chapters) {
      if (pos < c.end.inSeconds) return c;
    }
    return _chapters.last;
  }

  @override
  Widget build(BuildContext context) {
    final book = findEditionById(widget.editionId);
    if (book == null) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Text('Книга не найдена',
              style: TextStyle(color: Colors.white)),
        ),
      );
    }

    final state = context.watch<AppState>();
    final position = state.audioPositionSeconds(widget.editionId);
    final remaining = (_totalSeconds - position).clamp(0, _totalSeconds);
    final progress = _totalSeconds == 0
        ? 0.0
        : (position / _totalSeconds).clamp(0.0, 1.0);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // ---------- Верхняя панель ----------
            _TopBar(
              title: book.title,
              author: book.author,
              inLibrary: state.isInLibrary(book.id),
              onBack: () => Navigator.of(context).maybePop(),
              onToggleLibrary: () =>
                  context.read<AppState>().toggleLibrary(book.id),
              onMore: () {},
            ),

            // ---------- Обложка с glow ----------
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _CoverWithGlow(book: book),
                    const SizedBox(height: 28),
                    Text(
                      '${_formatDurationLong(Duration(seconds: remaining))} до конца книги',
                      style: const TextStyle(
                        color: Color(0xFF9A9791),
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ---------- Панель управления ----------
            _ControlsRow(
              isPlaying: state.isPlaying,
              speed: state.playbackSpeed,
              onSpeed: () => _showSpeedSheet(context),
              onRewind15: () {
                final p = state.audioPositionSeconds(widget.editionId) - 15;
                state.setAudioPosition(
                    widget.editionId, p.clamp(0, _totalSeconds));
              },
              onPlayPause: () => context.read<AppState>().togglePlaying(),
              onForward30: () {
                final p = state.audioPositionSeconds(widget.editionId) + 30;
                state.setAudioPosition(
                    widget.editionId, p.clamp(0, _totalSeconds));
              },
              onSleep: () => _showSleepSheet(context),
            ),
            const SizedBox(height: 20),

            // ---------- Строка главы ----------
            GestureDetector(
              onTap: () => _openChaptersSheet(context),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.format_list_bulleted_rounded,
                      size: 20, color: Colors.white),
                  const SizedBox(width: 8),
                  Text(
                    _currentChapter.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ---------- Слайдер + времена ----------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  SliderTheme(
                    data: SliderThemeData(
                      trackHeight: 3,
                      activeTrackColor: Colors.white,
                      inactiveTrackColor: const Color(0xFF2A2A2A),
                      thumbColor: Colors.white,
                      overlayColor: Colors.white.withValues(alpha: 0.15),
                      thumbShape: const RoundSliderThumbShape(
                          enabledThumbRadius: 7),
                      overlayShape: const RoundSliderOverlayShape(
                          overlayRadius: 16),
                    ),
                    child: Slider(
                      value: progress,
                      onChanged: (v) {
                        context.read<AppState>().setAudioPosition(
                              widget.editionId,
                              (v * _totalSeconds).round(),
                            );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Row(
                      children: [
                        Text(
                          _formatClock(Duration(seconds: position)),
                          style: const TextStyle(
                            color: Color(0xFF9A9791),
                            fontSize: 13,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '-${_formatClock(Duration(seconds: remaining))}',
                          style: const TextStyle(
                            color: Color(0xFF9A9791),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // ---------- Нижняя панель ----------
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Row(
                children: [
                  // Библиотека (добавить/убрать)
                  IconButton(
                    onPressed: () =>
                        context.read<AppState>().toggleLibrary(book.id),
                    icon: Icon(
                      state.isInLibrary(book.id)
                          ? Icons.bookmark_rounded
                          : Icons.bookmark_border_rounded,
                      color: Colors.white,
                    ),
                    tooltip: 'В библиотеку',
                  ),
                  const Spacer(),
                  // Пилюля «Читать»
                  SizedBox(
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (_) => ReadScreen(
                              editionId: book.id,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        elevation: 0,
                        padding:
                            const EdgeInsets.symmetric(horizontal: 28),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      child: const Text('Читать'),
                    ),
                  ),
                  const Spacer(),
                  // Искра ИИ
                  IconButton(
                    onPressed: () {},
                    icon: ShaderMask(
                      shaderCallback: (b) => const LinearGradient(
                        colors: [
                          Color(0xFFFF7AB6),
                          Color(0xFFC265F0),
                          Color(0xFF4AA3FF),
                        ],
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                      ).createShader(b),
                      blendMode: BlendMode.srcIn,
                      child: const Icon(Icons.auto_awesome,
                          color: Colors.white),
                    ),
                    tooltip: 'Люмен',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------- Sheets ----------

  void _openChaptersSheet(BuildContext context) {
    final state = context.read<AppState>();
    final current = state.audioPositionSeconds(widget.editionId);

    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: const Color(0xFF151515),
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
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              );
            }
            final idx = i - 1;
            final c = _chapters[idx];
            final isActive =
                current >= c.start.inSeconds && current < c.end.inSeconds;
            return ListTile(
              title: Text(
                c.title,
                style: TextStyle(
                  color: isActive ? AppColors.accent : Colors.white,
                  fontWeight:
                      isActive ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
              subtitle: Text(
                _formatClock(c.duration),
                style: const TextStyle(color: Color(0xFF9A9791)),
              ),
              onTap: () {
                Navigator.of(context).pop();
                context
                    .read<AppState>()
                    .setAudioPosition(widget.editionId, c.start.inSeconds);
              },
            );
          },
        ),
      ),
    );
  }

  void _showSpeedSheet(BuildContext context) {
    const speeds = [0.75, 1.0, 1.25, 1.5, 1.75, 2.0];
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: const Color(0xFF151515),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 4, 20, 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Скорость',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            ...speeds.map((s) {
              final active = context.watch<AppState>().playbackSpeed == s;
              return ListTile(
                title: Text(
                  '${s}x',
                  style: TextStyle(
                    color: active ? AppColors.accent : Colors.white,
                    fontWeight:
                        active ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
                onTap: () {
                  context.read<AppState>().setPlaybackSpeed(s);
                  Navigator.of(context).pop();
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  void _showSleepSheet(BuildContext context) {
    const options = [0, 5, 15, 30, 60];
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: const Color(0xFF151515),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 4, 20, 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Таймер сна',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            ...options.map((m) {
              final active =
                  context.watch<AppState>().sleepTimerMinutes == m;
              return ListTile(
                title: Text(
                  m == 0 ? 'Выключен' : '$m мин',
                  style: TextStyle(
                    color: active ? AppColors.accent : Colors.white,
                    fontWeight:
                        active ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
                onTap: () {
                  context.read<AppState>().setSleepTimerMinutes(m);
                  Navigator.of(context).pop();
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  // ---------- Форматирование ----------

  static String _formatClock(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes % 60;
    final s = d.inSeconds % 60;
    if (h > 0) {
      return '$h:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
    }
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  static String _formatDurationLong(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes % 60;
    if (h > 0) return '$h ч $m мин';
    return '$m мин';
  }
}

// ============================================================
// Верхняя панель
// ============================================================

class _TopBar extends StatelessWidget {
  final String title;
  final String author;
  final bool inLibrary;
  final VoidCallback onBack;
  final VoidCallback onToggleLibrary;
  final VoidCallback onMore;

  const _TopBar({
    required this.title,
    required this.author,
    required this.inLibrary,
    required this.onBack,
    required this.onToggleLibrary,
    required this.onMore,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      child: Row(
        children: [
          _CircleButton(
            icon: Icons.keyboard_arrow_down_rounded,
            onTap: onBack,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
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
                  style: const TextStyle(
                    color: Color(0xFF9A9791),
                    fontSize: 13,
                    height: 1.15,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          _CircleButton(
            icon: inLibrary ? Icons.check_rounded : Icons.add_rounded,
            onTap: onToggleLibrary,
          ),
          const SizedBox(width: 8),
          _CircleButton(
            icon: Icons.more_vert_rounded,
            onTap: onMore,
          ),
        ],
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF1C1C1C),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 40,
          height: 40,
          child: Icon(icon, size: 22, color: Colors.white),
        ),
      ),
    );
  }
}

// ============================================================
// Обложка с размытым свечением позади
// ============================================================

class _CoverWithGlow extends StatelessWidget {
  final BookEdition book;

  const _CoverWithGlow({required this.book});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Размытое свечение — та же обложка, но очень блюр и низкая прозрачность.
        Opacity(
          opacity: 0.45,
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
            child: SizedBox(
              width: 300,
              height: 400,
              child: BookCover(
                book: book,
                width: 300,
                height: 400,
                radius: 12,
              ),
            ),
          ),
        ),
        // Чёткая обложка
        BookCover(
          book: book,
          width: 240,
          height: 350,
          radius: 6,
          heroTag: 'player_${book.id}',
        ),
      ],
    );
  }
}

// ============================================================
// Панель управления
// ============================================================

class _ControlsRow extends StatelessWidget {
  final bool isPlaying;
  final double speed;
  final VoidCallback onSpeed;
  final VoidCallback onRewind15;
  final VoidCallback onPlayPause;
  final VoidCallback onForward30;
  final VoidCallback onSleep;

  const _ControlsRow({
    required this.isPlaying,
    required this.speed,
    required this.onSpeed,
    required this.onRewind15,
    required this.onPlayPause,
    required this.onForward30,
    required this.onSleep,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Скорость
          TextButton(
            onPressed: onSpeed,
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              minimumSize: const Size(48, 48),
            ),
            child: Text(
              '${_trimZero(speed)}x',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          // Rewind 15
          _RoundAction(
            icon: Icons.replay_rounded,
            badge: '15',
            onTap: onRewind15,
          ),

          // Play/Pause — большая
          Material(
            color: Colors.white,
            shape: const CircleBorder(),
            child: InkWell(
              onTap: onPlayPause,
              customBorder: const CircleBorder(),
              child: SizedBox(
                width: 72,
                height: 72,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 180),
                  transitionBuilder: (c, a) =>
                      ScaleTransition(scale: a, child: c),
                  child: Icon(
                    isPlaying
                        ? Icons.pause_rounded
                        : Icons.play_arrow_rounded,
                    key: ValueKey<bool>(isPlaying),
                    size: 40,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),

          // Forward 30
          _RoundAction(
            icon: Icons.refresh_rounded,
            badge: '30',
            reverse: true,
            onTap: onForward30,
          ),

          // Таймер сна
          IconButton(
            onPressed: onSleep,
            icon: const Icon(Icons.bedtime_outlined,
                color: Colors.white, size: 26),
            tooltip: 'Таймер сна',
          ),
        ],
      ),
    );
  }

  static String _trimZero(double v) {
    if (v == v.roundToDouble()) return v.toInt().toString();
    return v.toString();
  }
}

/// Круглая кнопка ↺15 / ↻30 с бейджем цифры по центру.
class _RoundAction extends StatelessWidget {
  final IconData icon;
  final String badge;
  final bool reverse;
  final VoidCallback onTap;

  const _RoundAction({
    required this.icon,
    required this.badge,
    required this.onTap,
    this.reverse = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: onTap,
      radius: 28,
      child: SizedBox(
        width: 52,
        height: 52,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.white),
            Positioned(
              bottom: 8,
              child: Text(
                badge,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}