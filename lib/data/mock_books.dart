import '../models/book_edition.dart';
import '../models/impression.dart';
import '../models/quote.dart';
import '../models/review.dart';

// ---------- Отзывы ----------
const _r1 = Review(
  author: 'Анна К.',
  rating: 5,
  text: 'Читала взахлёб. Отдельно отмечу язык — цитаты хочется выписывать.',
  date: '12 марта',
  likes: 48,
);
const _r2 = Review(
  author: 'Дмитрий В.',
  rating: 4,
  text: 'Первая половина чуть затянута, но дальше не оторваться.',
  date: '2 марта',
  likes: 21,
);
const _r3 = Review(
  author: 'Мария С.',
  rating: 5,
  text: 'Одна из тех книг, к которым возвращаешься через годы.',
  date: '28 февраля',
  likes: 63,
);

// ---------- Цитаты ----------
const _q1 = Quote(
  author: 'Дарья Лобанова',
  timeAgo: '2г',
  text: 'хлеб-соль вместе, а табачок врозь',
  likes: 12,
);
const _q2 = Quote(
  author: 'FinReal',
  timeAgo: '2г',
  text: 'убить без казуистики, убить для себя, для себя одного!',
  likes: 7,
);
const _q3 = Quote(
  author: 'Дарья Кондрашина',
  timeAgo: '2г',
  text:
      'Заметим кстати одну особенность по поводу всех окончательных решений, '
      'уже принятых им в этом деле. Они имели одно странное свойство: чем '
      'окончательнее они становились, тем безобразнее, нелепее, тотчас же '
      'становились и в его глазах',
  likes: 4,
);

// ---------- Впечатления ----------
const _i1 = Impression(
  author: 'Елена Т.',
  timeAgo: '5м',
  tag: ImpressionTag.recommend,
  text:
      'С большим удовольствием перечитала спустя несколько лет после школы '
      'и университета, хорошая книга',
  likes: 2,
);
const _i2 = Impression(
  author: 'Лаура Коштоян Знед',
  timeAgo: 'Знед',
  tag: ImpressionTag.recommend,
  text:
      'Интересно, захватывающе, переживательно. Но тяжелое. Осадок в конце остался',
  likes: 1,
);
const _i3 = Impression(
  author: 'Starry S.',
  timeAgo: 'Знед',
  tag: ImpressionTag.recommend,
  text:
      'Читал не отрываясь. Даже не жалею, что не читал в школе. Мне кажется '
      'тогда бы я не понял и не прочувствовал всего.',
  likes: 1,
);

// ============================================================
// Книги
// ============================================================

const mockEditions = <BookEdition>[
  // ——— Одиссея ———
  BookEdition(
    id: 'gomer_text',
    title: 'Одиссея',
    author: 'Гомер',
    format: BookFormat.text,
    coverUrl: 'assets/covers/gomer.png',
    description:
        'Эпическая поэма Гомера, уникальная уже тем, что дошла до наших дней в первозданном виде. '
        'Эта поэма - подлинное откровение стихотворной мысли древней Эллады. '
        'Полные очарования описания экзотических стран, опасных приключений и нежных чувств героев, '
        'а также легенды и тайны, которыми овеяно прошлое, - все это "Одиссея", книга, без которой немыслима мировая литература',
    genres: ['Русская классика', 'Мистика', 'Роман'],
    rating: 4.6,
    reviewsCount: 541,
    ageRestriction: '16+',
    originalYear: 1,
    pages: 401,
    readersCount: 70300,
    quotesCount: 16701,
    impressionsCount: 412,
    shelvesCount: 475,
    reviews: [_r1, _r2, _r3],
    quotes: [_q1, _q2, _q3],
    impressions: [_i1, _i2, _i3],
    similarIds: ['1984_text', 'piknik_text', 'three_comrades_text'],
    readWithIds: ['1984_text', 'three_comrades_text', 'dune_text'],
  ),
  // ——— Мастер и Маргарита (текст) ———
  BookEdition(
    id: 'master_text',
    title: 'Мастер и Маргарита',
    author: 'Михаил Булгаков',
    format: BookFormat.text,
    coverUrl: 'assets/covers/master.jpg',
    description:
        'Один из самых загадочных романов XX века. Дьявол приезжает в Москву '
        '1930-х, и город начинает сходить с ума. Параллельно разворачивается '
        'история Мастера и его Маргариты — история о любви, страхе и свободе '
        'творчества.',
    genres: ['Русская классика', 'Мистика', 'Роман'],
    rating: 4.8,
    reviewsCount: 12430,
    ageRestriction: '16+',
    originalYear: 1967,
    pages: 480,
    readersCount: 32800,
    quotesCount: 8900,
    impressionsCount: 412,
    shelvesCount: 156,
    reviews: [_r1, _r2, _r3],
    quotes: [_q1, _q2, _q3],
    impressions: [_i1, _i2, _i3],
    similarIds: ['1984_text', 'piknik_text', 'three_comrades_text'],
    otherEditionIds: ['master_audio'],
    readWithIds: ['1984_text', 'three_comrades_text', 'dune_text'],
  ),
  BookEdition(
    id: 'master_audio',
    title: 'Мастер и Маргарита',
    author: 'Михаил Булгаков',
    format: BookFormat.audio,
    narrator: 'Сергей Чонишвили',
    coverUrl: 'assets/covers/master_audio.jpg',
    description:
        'Один из самых загадочных романов XX века в исполнении Сергея Чонишвили.',
    genres: ['Русская классика', 'Мистика'],
    rating: 4.9,
    reviewsCount: 3210,
    ageRestriction: '16+',
    originalYear: 1967,
    audioDuration: const Duration(hours: 14, minutes: 25),
    readersCount: 5400,
    quotesCount: 230,
    impressionsCount: 87,
    shelvesCount: 22,
    reviews: [_r1, _r3],
    quotes: [_q1],
    impressions: [_i2],
    similarIds: ['master_text', '1984_audio'],
    otherEditionIds: ['master_text'],
    readWithIds: ['1984_audio'],
  ),

  // ——— 1984 ———
  BookEdition(
    id: '1984_text',
    title: '1984',
    author: 'Джордж Оруэлл',
    format: BookFormat.text,
    coverUrl: 'assets/covers/1984.jpg',
    description:
        'Классика антиутопии. Уинстон Смит работает в Министерстве правды и '
        'правит историю. Но однажды он начинает вести дневник — и это уже '
        'преступление.',
    genres: ['Антиутопия', 'Фантастика', 'Зарубежная классика'],
    rating: 4.7,
    reviewsCount: 9820,
    ageRestriction: '16+',
    originalYear: 1949,
    pages: 320,
    readersCount: 25400,
    quotesCount: 5400,
    impressionsCount: 300,
    shelvesCount: 88,
    reviews: [_r2, _r3],
    quotes: [_q2, _q3],
    impressions: [_i1, _i3],
    similarIds: ['master_text', 'dune_text', 'piknik_text'],
    otherEditionIds: ['1984_audio'],
    readWithIds: ['master_text', 'dune_text'],
  ),
  BookEdition(
    id: '1984_audio',
    title: '1984',
    author: 'Джордж Оруэлл',
    format: BookFormat.audio,
    narrator: 'Владимир Ерёмин',
    coverUrl: 'assets/covers/1984_audio.jpg',
    description: 'Классика антиутопии в аудиоформате.',
    genres: ['Антиутопия', 'Фантастика'],
    rating: 4.8,
    reviewsCount: 1540,
    ageRestriction: '16+',
    originalYear: 1949,
    audioDuration: const Duration(hours: 10, minutes: 5),
    readersCount: 4200,
    quotesCount: 120,
    impressionsCount: 45,
    shelvesCount: 12,
    reviews: [_r1],
    quotes: [_q1],
    impressions: [_i2],
    similarIds: ['1984_text', 'master_audio'],
    otherEditionIds: ['1984_text'],
    readWithIds: ['master_audio'],
  ),

  // ——— Три товарища ———
  BookEdition(
    id: 'three_comrades_text',
    title: 'Три товарища',
    author: 'Эрих Мария Ремарк',
    format: BookFormat.text,
    coverUrl: 'assets/covers/three_comrades.jpg',
    description:
        'Германия после Первой мировой. Трое друзей держатся друг за друга, '
        'пока вокруг рушится мир. И есть любовь, которая сильнее обстоятельств.',
    genres: ['Зарубежная классика', 'Роман', 'Драма'],
    rating: 4.9,
    reviewsCount: 15600,
    ageRestriction: '18+',
    originalYear: 1936,
    pages: 560,
    readersCount: 41500,
    quotesCount: 11200,
    impressionsCount: 520,
    shelvesCount: 210,
    reviews: [_r1, _r3],
    quotes: [_q1, _q3],
    impressions: [_i1, _i3],
    similarIds: ['master_text', 'shantaram_text'],
    readWithIds: ['master_text', 'shantaram_text'],
  ),

  // ——— Дюна ———
  BookEdition(
    id: 'dune_text',
    title: 'Дюна',
    author: 'Фрэнк Герберт',
    format: BookFormat.text,
    coverUrl: 'assets/covers/dune.jpg',
    description:
        'Арракис — планета пустыни и единственный источник спайса, самого '
        'ценного вещества во Вселенной. Молодой Пол Атрейдес оказывается в '
        'центре борьбы за власть.',
    genres: ['Фантастика', 'Космоопера', 'Приключения'],
    rating: 4.6,
    reviewsCount: 7300,
    ageRestriction: '16+',
    originalYear: 1965,
    pages: 800,
    readersCount: 18700,
    quotesCount: 3400,
    impressionsCount: 240,
    shelvesCount: 74,
    seriesTitle: 'Хроники Дюны',
    seriesNumber: 1,
    reviews: [_r2],
    quotes: [_q2],
    impressions: [_i2],
    similarIds: ['1984_text', 'piknik_text'],
    readWithIds: ['1984_text', 'piknik_text'],
  ),

  // ——— Пикник на обочине ———
  BookEdition(
    id: 'piknik_text',
    title: 'Пикник на обочине',
    author: 'Аркадий и Борис Стругацкие',
    format: BookFormat.text,
    coverUrl: 'assets/covers/piknik.jpg',
    description:
        'После посещения Земли пришельцами остались Зоны — территории с '
        'непонятными и смертельно опасными артефактами. Сталкер Рэдрик Шухарт '
        'ходит туда за «хабаром».',
    genres: ['Фантастика', 'Советская классика'],
    rating: 4.7,
    reviewsCount: 4100,
    ageRestriction: '16+',
    originalYear: 1972,
    pages: 256,
    readersCount: 12300,
    quotesCount: 2900,
    impressionsCount: 180,
    shelvesCount: 56,
    reviews: [_r3],
    quotes: [_q3],
    impressions: [_i1],
    similarIds: ['dune_text', '1984_text'],
    readWithIds: ['dune_text', '1984_text'],
  ),

  // ——— Гарри Поттер ———
  BookEdition(
    id: 'hp1_text',
    title: 'Гарри Поттер и философский камень',
    author: 'Дж. К. Роулинг',
    format: BookFormat.text,
    coverUrl: 'assets/covers/hp.jpg',
    description:
        'Мальчик, который выжил, узнаёт, что он волшебник, и отправляется '
        'в Хогвартс.',
    genres: ['Фэнтези', 'Детская литература', 'Приключения'],
    rating: 4.9,
    reviewsCount: 42300,
    ageRestriction: '6+',
    originalYear: 1997,
    pages: 432,
    readersCount: 95400,
    quotesCount: 18700,
    impressionsCount: 890,
    shelvesCount: 340,
    seriesTitle: 'Гарри Поттер',
    seriesNumber: 1,
    reviews: [_r1, _r2],
    quotes: [_q1, _q2],
    impressions: [_i3],
    similarIds: ['dune_text'],
    otherEditionIds: ['hp1_audio'],
    readWithIds: ['dune_text', '1984_text'],
  ),
  BookEdition(
    id: 'hp1_audio',
    title: 'Гарри Поттер и философский камень',
    author: 'Дж. К. Роулинг',
    format: BookFormat.audio,
    narrator: 'Александр Клюквин',
    coverUrl: 'assets/covers/hp_audio.jpg',
    description: 'Первая книга о Гарри Поттере в аудиоформате.',
    genres: ['Фэнтези', 'Детская литература'],
    rating: 4.9,
    reviewsCount: 8900,
    ageRestriction: '6+',
    originalYear: 1997,
    audioDuration: const Duration(hours: 9, minutes: 30),
    readersCount: 23400,
    quotesCount: 400,
    impressionsCount: 120,
    shelvesCount: 45,
    seriesTitle: 'Гарри Поттер',
    seriesNumber: 1,
    reviews: [_r3],
    quotes: [_q2],
    impressions: [_i1],
    similarIds: ['hp1_text'],
    otherEditionIds: ['hp1_text'],
    readWithIds: ['master_audio'],
  ),

  // ——— Шантарам ———
  BookEdition(
    id: 'shantaram_text',
    title: 'Шантарам',
    author: 'Грегори Дэвид Робертс',
    format: BookFormat.text,
    coverUrl: 'assets/covers/shantaram.jpg',
    description:
        'Беглый австралийский преступник оказывается в Бомбее и находит там '
        'новую жизнь, друзей и любовь.',
    genres: ['Современная проза', 'Приключения', 'Автобиография'],
    rating: 4.5,
    reviewsCount: 6100,
    ageRestriction: '18+',
    originalYear: 2003,
    pages: 860,
    readersCount: 15200,
    quotesCount: 3100,
    impressionsCount: 210,
    shelvesCount: 68,
    reviews: [_r2],
    quotes: [_q2],
    impressions: [_i2],
    similarIds: ['three_comrades_text'],
    readWithIds: ['three_comrades_text'],
  ),

  // ——— Атлант ———
  BookEdition(
    id: 'atlas_text',
    title: 'Атлант расправил плечи',
    author: 'Айн Рэнд',
    format: BookFormat.text,
    coverUrl: 'assets/covers/atlant.jpg',
    description:
        'Америка на грани краха. Люди, создающие ценности, исчезают один за '
        'другим. Кто остановит падение мира?',
    genres: ['Философия', 'Антиутопия', 'Роман'],
    rating: 4.4,
    reviewsCount: 3900,
    ageRestriction: '18+',
    originalYear: 1957,
    pages: 1400,
    readersCount: 8900,
    quotesCount: 2200,
    impressionsCount: 130,
    shelvesCount: 40,
    reviews: [_r3],
    quotes: [_q3],
    impressions: [_i3],
    similarIds: ['1984_text'],
    readWithIds: ['1984_text'],
  ),
];

// ---------- Вспомогательные ----------

final Map<String, BookEdition> _byId = {
  for (final e in mockEditions) e.id: e,
};

BookEdition? findEditionById(String? id) => id == null ? null : _byId[id];

List<BookEdition> editionsByIds(List<String> ids) =>
    ids.map(findEditionById).whereType<BookEdition>().toList();

List<BookEdition> searchEditions(String query) {
  final q = query.trim().toLowerCase();
  if (q.isEmpty) return const [];
  return mockEditions.where((e) {
    return e.title.toLowerCase().contains(q) ||
        e.author.toLowerCase().contains(q) ||
        e.genres.any((g) => g.toLowerCase().contains(q));
  }).toList();
}

List<BookEdition> get popularEditions =>
    mockEditions.where((e) => e.rating >= 4.7).take(6).toList();

/// Возвращает версии книги того же произведения (кроме самой книги).
List<BookEdition> otherEditionsOf(BookEdition book) =>
    editionsByIds(book.otherEditionIds);