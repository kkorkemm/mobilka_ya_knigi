import 'package:flutter/material.dart';

import '../models/book_edition.dart';
import 'book_cover.dart';

/// Карусель «фокус» с центральной обложкой и подглядывающими соседями.
class FeaturedCarousel extends StatefulWidget {
  final List<BookEdition> books;
  final ValueChanged<BookEdition> onTap;
  final ValueChanged<int>? onPageChanged;

  const FeaturedCarousel({
    super.key,
    required this.books,
    required this.onTap,
    this.onPageChanged,
  });

  @override
  State<FeaturedCarousel> createState() => _FeaturedCarouselState();
}

class _FeaturedCarouselState extends State<FeaturedCarousel> {
  late final PageController _controller;
  int _index = 1; // Начинаем со второй, чтобы «соседи» были по краям.

  @override
  void initState() {
    super.initState();
    final initial = widget.books.length > 1 ? 1 : 0;
    _index = initial;
    _controller = PageController(viewportFraction: 0.7, initialPage: initial);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onPageChanged?.call(initial);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 340,
      child: PageView.builder(
        controller: _controller,
        itemCount: widget.books.length,
        onPageChanged: (i) {
          setState(() => _index = i);
          widget.onPageChanged?.call(i);
        },
        itemBuilder: (context, i) {
          final b = widget.books[i];
          final isCenter = i == _index;

          return AnimatedScale(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
            scale: isCenter ? 1.0 : 0.88,
            child: AnimatedPadding(
              duration: const Duration(milliseconds: 250),
              padding: EdgeInsets.symmetric(
                horizontal: 8,
                vertical: isCenter ? 0 : 24,
              ),
              child: GestureDetector(
                onTap: () => widget.onTap(b),
                child: BookCover(
                  book: b,
                  width: double.infinity,
                  height: double.infinity,
                  radius: 10,
                  heroTag: isCenter ? 'featured_${b.id}' : null,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}