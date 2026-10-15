import '../models/book_edition.dart';
import 'mock_books.dart';

/// Категории-чипсы в самом верху главного экрана.
/// Первый элемент — «плитка» (все категории), у неё иконка сетки.
class HomeCategory {
  final String label;
  final bool isGrid;

  const HomeCategory({required this.label, this.isGrid = false});
}

const homeCategories = <HomeCategory>[
  HomeCategory(label: 'Все', isGrid: true),
  HomeCategory(label: 'Аудио'),
  HomeCategory(label: 'Детям'),
  HomeCategory(label: 'Комиксы'),
  HomeCategory(label: 'Проза'),
  HomeCategory(label: 'Бесплатно'),
  HomeCategory(label: 'Классика'),
  HomeCategory(label: 'Фантастика'),
  HomeCategory(label: 'Детективы'),
  HomeCategory(label: 'Фэнтези'),
  HomeCategory(label: 'Нон-фикшн'),
];

/// Подборка-секция на главном.
class HomeCollection {
  final String title;
  final String? subtitle; // заголовок-описание над пилюлей «Добавить книгу»
  final bool isFeatured;  // большая карусель с пилюлей
  final bool showSeeAll;  // ссылка «Все» справа от заголовка
  final List<BookEdition> books;

  const HomeCollection({
    required this.title,
    this.subtitle,
    this.isFeatured = false,
    this.showSeeAll = true,
    required this.books,
  });
}

/// Подбираем книги для главного экрана.
/// Используем существующие mockEditions, чтобы не заводить новые данные.
List<HomeCollection> buildHomeCollections() {
  final all = mockEditions;

  List<BookEdition> pick(List<String> ids) => editionsByIds(ids);

  return [
    // Большая карусель-«фокус» с пилюлей «Добавить книгу».
    HomeCollection(
      title: 'Нолан экранизирует Гомера! Перечитываем величайшую античную поэму',
      isFeatured: true,
      showSeeAll: false,
      books: pick([
        'nameofrose_text',
        'gomer_text',
        'master_text',
        'parusa_text',
        'hp1_text',
        '1984_text',
      ]),
    ),
    HomeCollection(
      title: 'Вам может понравиться',
      books: pick([
        '1984_text',
        'pdk1_text',
        'vsadnik_text',
        'povelitel_text',
        'kamo_text',
      ]),
    ),
    HomeCollection(
      title: 'Новинки',
      books: pick([
        'pdk3_text',
        'hp5_text',
        'hp6_text',
        'hp7_text',
        '1984_text',
      ]),
    ),
    HomeCollection(
      title: 'Сейчас читают',
      books: pick([
        'master_text',
        '1984_text',
        'gomer_text',
        'nameofrose_text',
        'pdk7_text',
      ]),
    ),
    HomeCollection(
      title: 'Аудиокниги',
      books: all.where((b) => b.isAudio).toList(),
    ),
    HomeCollection(
      title: 'Классика',
      books: pick([
        'master_text',
        'treasure_island_text',
        'pdk2_text',
        'vsadnik_text',
      ]),
    ),
    HomeCollection(
      title: 'Бесплатно',
      books: pick([
        'povelitel_text',
        'parusa_text',
        'vsadnik_text',
      ]),
    ),
  ];
}