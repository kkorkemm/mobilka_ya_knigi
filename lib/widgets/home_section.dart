import 'package:flutter/material.dart';

import '../models/book_edition.dart';
import '../theme/app_colors.dart';
import 'book_cover.dart';

/// Заголовок секции главного экрана.
class HomeSectionHeader extends StatelessWidget {
  final String title;
  final bool showSeeAll;
  final VoidCallback? onSeeAll;

  const HomeSectionHeader({
    super.key,
    required this.title,
    this.showSeeAll = true,
    this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    final secondary = Theme.of(context).textTheme.bodySmall?.color;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.4,
              ),
            ),
          ),
          if (showSeeAll)
            GestureDetector(
              onTap: onSeeAll,
              child: Text(
                'Все',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: secondary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Горизонтальная лента обложек секции.
class HomeBooksRow extends StatelessWidget {
  final List<BookEdition> books;
  final ValueChanged<BookEdition> onTap;

  const HomeBooksRow({
    super.key,
    required this.books,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final secondary = Theme.of(context).textTheme.bodySmall?.color;

    return SizedBox(
      height: 230,
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
              width: 118,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BookCover(
                    book: b,
                    width: 118,
                    height: 168,
                    radius: 6,
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

/// Заголовок-описание над пилюлей на featured-секции.
class FeaturedTitle extends StatelessWidget {
  final String text;

  const FeaturedTitle({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          height: 1.35,
          letterSpacing: -0.2,
        ),
      ),
    );
  }
}

/// Белая пилюля «+ Добавить книгу».
class AddBookButton extends StatelessWidget {
  final VoidCallback onTap;

  const AddBookButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: SizedBox(
        height: 40,
        child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: isDark ? Colors.white : const Color(0xFF1A1A1A),
            foregroundColor:
                isDark ? const Color(0xFF1A1A1A) : Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.add_rounded, size: 18),
              SizedBox(width: 6),
              Text(
                'Добавить книгу',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Небольшая утилита — «Все книги» — кнопка справа у чипсов (пригодится).
class SmallLink extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const SmallLink({super.key, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).textTheme.bodySmall?.color,
          ),
        ),
      ),
    );
  }
}