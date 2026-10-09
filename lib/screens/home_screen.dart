import 'package:flutter/material.dart';

import '../data/mock_books.dart';
import '../data/mock_collection.dart';
import '../models/book_edition.dart';
import '../widgets/featured_carousel.dart';
import '../widgets/home_category_chips.dart';
import '../widgets/home_section.dart';
import 'book_details_screen.dart';
import '../navigation/tab_switcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _categoryIndex = 0;
  late final List<HomeCollection> _collections;

  @override
  void initState() {
    super.initState();
    _collections = buildHomeCollections();
  }

  @override
  Widget build(BuildContext context) {
    // Первая секция — featured (большая карусель + пилюля).
    final featured = _collections.firstWhere(
      (c) => c.isFeatured,
      orElse: () => _collections.first,
    );
    final rest = _collections.where((c) => !c.isFeatured).toList();

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(bottom: 32),
          children: [
            // ---------- Заголовок ----------
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Text(
                'Яндекс Книги',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.6,
                ),
              ),
            ),

            // ---------- Полоса категорий ----------
            HomeCategoryChips(
              selectedIndex: _categoryIndex,
              onSelect: (i) => setState(() => _categoryIndex = i),
            ),
            const SizedBox(height: 8),

            // ---------- Featured-карусель ----------
            if (featured.books.isNotEmpty)
              FeaturedCarousel(
                books: featured.books,
                onTap: (b) => _openDetails(context, b.id),
              ),

            // Заголовок-описание под каруселью
            if (featured.title.isNotEmpty)
              FeaturedTitle(text: featured.title),

            const SizedBox(height: 16),

            // Пилюля «+ Добавить книгу»
            AddBookButton(
               onTap: () {
                TabSwitcher.of(context)?.switchTo(TabIndex.search);
              },
            ),

            // ---------- Остальные секции ----------
            for (final c in rest) ...[
              HomeSectionHeader(
                title: c.title,
                showSeeAll: c.showSeeAll,
                onSeeAll: () {},
              ),
              if (c.books.isNotEmpty)
                HomeBooksRow(
                  books: c.books,
                  onTap: (b) => _openDetails(context, b.id),
                ),
            ],
          ],
        ),
      ),
    );
  }

  void _openDetails(BuildContext context, String id) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => BookDetailsScreen(editionId: id)),
    );
  }
}