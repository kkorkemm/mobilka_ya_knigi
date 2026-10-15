import 'package:flutter/material.dart';

import '../models/book_edition.dart';
import '../theme/app_colors.dart';

/// Обложка книги.
/// Если coverUrl == null — рисуем заглушку (градиент + название).
/// Когда появятся реальные картинки, достаточно проставить coverUrl.
class BookCover extends StatelessWidget {
  final BookEdition book;
  final double width;
  final double height;
  final double radius;
  final bool square;

  /// Тег для Hero-перехода. null — без анимации.
  final Object? heroTag;

  const BookCover({
    super.key,
    required this.book,
    required this.width,
    required this.height,
    this.radius = 8,
    this.heroTag,
    this.square = false,
  });

  @override
  Widget build(BuildContext context) {
    final w = width;
    final h = square ? width : height;
    Widget cover = ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: SizedBox(
        width: w,
        height: h,
        child: _buildContent(context, w),
      ),
    );

    // Тонкая тень как у обложек в оригинале
    cover = DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: cover,
    );

    if (heroTag != null) {
      cover = Hero(tag: heroTag!, child: cover);
    }
    return cover;
  }

  Widget _buildContent(BuildContext context, double width) {
    final url = book.coverUrl;
    if (url != null && url.isNotEmpty) {
      if (url.startsWith('http')) {
        return Image.network(url, fit: BoxFit.cover);
      }
      return Image.asset(url, fit: BoxFit.cover);
    }
    return _PlaceholderCover(book: book, width: width);
  }
}

class _PlaceholderCover extends StatelessWidget {
  final BookEdition book;
  final double width;

  const _PlaceholderCover({required this.book, required this.width});

  @override
  Widget build(BuildContext context) {
    final gradient =
        AppColors.coverGradients[book.title.hashCode.abs() %
            AppColors.coverGradients.length];

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              book.title,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: (width * 0.13).clamp(11, 20),
                height: 1.15,
              ),
            ),
          ),
          Text(
            book.author,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.85),
              fontSize: (width * 0.09).clamp(9, 13),
            ),
          ),
        ],
      ),
    );
  }
}