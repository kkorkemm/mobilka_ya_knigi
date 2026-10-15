import 'package:flutter/material.dart';
import 'dart:ui' show ImageFilter;
import '../models/book_edition.dart';
import 'book_cover.dart';
import '../theme/app_colors.dart';

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
    _controller = PageController(viewportFraction: 0.55, initialPage: initial);
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
                child: _CoverWithBeam(
                  book: b,
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
// ============================================================
// Обложка со световым лучом позади
// ============================================================

class _CoverWithBeam extends StatelessWidget {
  final BookEdition book;
  final Object? heroTag;

  const _CoverWithBeam({required this.book, this.heroTag});

  @override
  Widget build(BuildContext context) {
    final gradient =
        AppColors.coverGradients[book.title.hashCode.abs() %
            AppColors.coverGradients.length];

    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final h = constraints.maxHeight;

        const beamH = 54.0;
        // На сколько луч выступает за границу ячейки с каждой стороны.
        const beamExtend = 30.0;

        return Stack(
          // Важно: разрешаем детям выходить за границы Stack.
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            // ---------- Световой луч ----------
            // Positioned с left/right отрицательными — гарантированно
            // делает ширину = w + 2 * beamExtend, без обрезки.
            Positioned(
              left: -beamExtend,
              right: -beamExtend,
              top: (h - beamH) / 2,
              height: beamH,
              child: IgnorePointer(
                child: Opacity(
                  opacity: 0.9,
                  child: ImageFiltered(
                    imageFilter:
                        ImageFilter.blur(sigmaX: 30, sigmaY: 12),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            gradient[0].withValues(alpha: 0.0),
                            gradient[0].withValues(alpha: 0.9),
                            gradient[1].withValues(alpha: 0.9),
                            gradient[1].withValues(alpha: 0.0),
                          ],
                          stops: const [0.0, 0.25, 0.75, 1.0],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: gradient[1].withValues(alpha: 0.6),
                            blurRadius: 20,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // ---------- Обложка ----------
            BookCover(
              book: book,
              width: w,
              height: h,
              radius: 10,
              heroTag: heroTag,
            ),
          ],
        );
      },
    );
  }
}