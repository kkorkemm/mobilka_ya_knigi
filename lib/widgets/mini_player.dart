import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/audio_player_screen.dart';
import '../screens/book_details_screen.dart';
import '../state/app_state.dart';
import '../theme/app_colors.dart';
import 'book_cover.dart';
import '../screens/read_screen.dart';

/// Мини-плеер над нижней панелью.
/// Показывает закреплённую книгу: обложка, название, автор, кнопка «Читать».
class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
  final state = context.watch<AppState>();

  // Скрыт, когда открыта страница той же книги — не дублируем.
  if (state.isCurrentBookDetailsOpen) return const SizedBox.shrink();

  final book = state.currentEdition;
  if (book == null) return const SizedBox.shrink();

  final theme = Theme.of(context);
  final isDark = theme.brightness == Brightness.dark;
  final divider = isDark ? AppColors.darkDivider : AppColors.lightDivider;
  final secondary = theme.textTheme.bodySmall?.color;

  final buttonBg =
      isDark ? const Color(0xFF2C2C2E) : const Color(0xFFF2F2F4);
  final buttonFg = isDark ? Colors.white : const Color(0xFF1A1A1A);

  return Material(
    color: theme.scaffoldBackgroundColor,
    child: Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: divider, width: 0.5),
        ),
      ),
      child: InkWell(
        // Тап по всему мини-плееру → страница книги.
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => BookDetailsScreen(editionId: book.id),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
          height: 56,
          child: Row(
            children: [
              // Обложка
              BookCover(
                book: book,
                width: 36,
                height: 44,
                radius: 4,
              ),
              const SizedBox(width: 10),
              // Название + автор
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      book.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      book.author,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 12, color: secondary),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Кнопка «Читать» — открывает читалку/плеер.
              InkWell(
                onTap: () {
                  if (book.isAudio) {
                    Navigator.of(context, rootNavigator: true).push(
                      MaterialPageRoute(
                        builder: (_) =>
                            AudioPlayerScreen(editionId: book.id),
                      ),
                    );
                  } else {
                    Navigator.of(context, rootNavigator: true).push(
                      MaterialPageRoute(
                        builder: (_) => ReadScreen(editionId: book.id),
                      ),
                    );
                  }
                },
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 18, vertical: 8),
                  decoration: BoxDecoration(
                    color: buttonBg,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    book.isAudio ? 'Слушать' : 'Читать',
                    style: TextStyle(
                      color: buttonFg,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
}