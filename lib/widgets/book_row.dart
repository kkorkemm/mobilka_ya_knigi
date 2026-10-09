import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/book_edition.dart';
import '../state/app_state.dart';
import '../theme/app_colors.dart';
import 'book_cover.dart';

/// Строка книги в поиске и в списках.
/// Структура ровно как в оригинале:
///   [обложка]  название (2 строки)
///              автор
///              [чип формата]  ★ 77.7K            [+/✓]
class BookRow extends StatelessWidget {
  final BookEdition book;
  final VoidCallback? onTap;
  final bool showLibraryButton;

  const BookRow({
    super.key,
    required this.book,
    this.onTap,
    this.showLibraryButton = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final secondary = theme.textTheme.bodySmall?.color;
    final chipBorder =
        isDark ? AppColors.darkChipBorder : AppColors.lightChipBorder;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 10, 12, 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BookCover(
              book: book,
              width: 68,
              height: 98,
              radius: 6,
              heroTag: 'cover_${book.id}',
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Название
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
                  // Автор
                  Text(
                    book.author,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 14, color: secondary),
                  ),
                  const SizedBox(height: 8),
                  // [чип формата] [★ 77.7K]
                  Row(
                    children: [
                      _FormatChip(
                        label: book.formatLabel,
                        borderColor: chipBorder,
                        textColor: theme.textTheme.bodyLarge?.color,
                      ),
                      if (book.reviewsCount > 0) ...[
                        const SizedBox(width: 10),
                        // Иконка-силуэт человека (число читателей/слушателей).
                        Icon(
                          Icons.person_outline_rounded,
                          size: 15,
                          color: secondary,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          book.ratingsLabel,
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
            if (showLibraryButton)
              _LibraryToggleButton(book: book),
          ],
        ),
      ),
    );
  }
}

/// Маленький чип с форматом («Книга» / «Аудиокнига»).
class _FormatChip extends StatelessWidget {
  final String label;
  final Color borderColor;
  final Color? textColor;

  const _FormatChip({
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

/// «+» / «✓» справа. Без снекбара — просто меняет состояние.
/// (Снекбар оставим только когда добавляем из открытой карточки.)
class _LibraryToggleButton extends StatelessWidget {
  final BookEdition book;

  const _LibraryToggleButton({required this.book});

  @override
  Widget build(BuildContext context) {
    final inLibrary = context.watch<AppState>().isInLibrary(book.id);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final color = isDark ? const Color(0xFF9A9AA0) : const Color(0xFF8A8A8E);

    return SizedBox(
      width: 40,
      height: 40,
      child: IconButton(
        padding: EdgeInsets.zero,
        onPressed: () {
          context.read<AppState>().toggleLibrary(book.id);
        },
        icon: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          transitionBuilder: (child, anim) =>
              ScaleTransition(scale: anim, child: child),
          child: Icon(
            inLibrary
                ? Icons.check_rounded
                : Icons.add_rounded,
            key: ValueKey<bool>(inLibrary),
            color: color,
            size: inLibrary ? 26 : 30,
          ),
        ),
        tooltip: inLibrary ? 'В «Моих книгах»' : 'Добавить в «Мои книги»',
      ),
    );
  }
}