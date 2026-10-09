import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/book_edition.dart';
import '../state/app_state.dart';
import '../theme/app_colors.dart';
import 'book_cover.dart';

/// Строка книги на экране «Добавленные».
/// Отличия от BookRow:
///   • на обложке — бейдж с процентом прогресса;
///   • в чипах рядом с форматом — «18+»;
///   • справа — «✓» (в библиотеке) или «↓» (скачать).
class AddedBookRow extends StatelessWidget {
  final BookEdition book;
  final VoidCallback? onTap;

  const AddedBookRow({super.key, required this.book, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final secondary = theme.textTheme.bodySmall?.color;
    final chipBorder =
        isDark ? AppColors.darkChipBorder : AppColors.lightChipBorder;

    final state = context.watch<AppState>();
    final inLibrary = state.isInLibrary(book.id);
    final progress = state.progressOf(book.id);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 10, 12, 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Обложка с бейджем прогресса
            SizedBox(
              width: 68,
              height: 98,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  BookCover(
                    book: book,
                    width: 68,
                    height: 98,
                    radius: 6,
                    heroTag: 'added_${book.id}',
                  ),
                  if (progress > 0.01 && progress < 0.99)
                    Positioned(
                      top: 6,
                      right: 6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.7),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${(progress * 100).round()}%',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 12),

            // Текст
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    book.author,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 14, color: secondary),
                  ),
                  const SizedBox(height: 8),
                  // Чипы: [формат] [18+] 👤 N
                  Row(
                    children: [
                      _MiniChip(
                        label: book.formatLabel,
                        borderColor: chipBorder,
                        textColor: theme.textTheme.bodyLarge?.color,
                      ),
                      if (book.ageRestriction != null) ...[
                        const SizedBox(width: 6),
                        _MiniChip(
                          label: book.ageRestriction!,
                          borderColor: chipBorder,
                          textColor: theme.textTheme.bodyLarge?.color,
                        ),
                      ],
                      if (book.readersCount > 0) ...[
                        const SizedBox(width: 10),
                        Icon(Icons.person_outline_rounded,
                            size: 14, color: secondary),
                        const SizedBox(width: 3),
                        Text(
                          book.readersLabel,
                          style: TextStyle(
                            fontSize: 13,
                            color: secondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 6),

            // ✓ или ↓
            SizedBox(
              width: 40,
              height: 40,
              child: inLibrary
                  ? Icon(Icons.check_rounded,
                      size: 24, color: theme.textTheme.bodyLarge?.color)
                  : IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {},
                      icon: Icon(
                        Icons.download_rounded,
                        size: 22,
                        color: theme.textTheme.bodyLarge?.color,
                      ),
                      tooltip: 'Скачать',
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniChip extends StatelessWidget {
  final String label;
  final Color borderColor;
  final Color? textColor;

  const _MiniChip({
    required this.label,
    required this.borderColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor, width: 0.8),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: textColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}