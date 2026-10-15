import '../models/book_edition.dart';
import '../models/impression.dart';
import '../models/quote.dart';
import '../models/review.dart';

// ---------- Отзывы ----------
const _r1 = Review(
  author: 'Еркем Ж.',
  rating: 5,
  text: 'Читала взахлёб. Отдельно отмечу язык — цитаты хочется выписывать.',
  date: '12 марта',
  likes: 48,
);
const _r2 = Review(
  author: 'Гамаль К.',
  rating: 4,
  text: 'Первая половина чуть затянута, но дальше не оторваться.',
  date: '2 марта',
  likes: 21,
);
const _r3 = Review(
  author: 'Болат Ж.',
  rating: 5,
  text: 'Одна из тех книг, к которым возвращаешься через годы.',
  date: '28 февраля',
  likes: 63,
);

// ---------- Цитаты ----------
const _q1 = Quote(
  author: 'Амина Искакова',
  timeAgo: '2г',
  text: 'Конечно, это происходит в твоей голове, Гарри, но почему это не может быть правдой? ',
  likes: 12,
);
const _q2 = Quote(
  author: 'Mekrok',
  timeAgo: '2г',
  text: 'Я торжественно клянусь, что замышляю только шалость!',
  likes: 73,
);
const _q3 = Quote(
  author: 'Александр Хорошилов',
  timeAgo: '2г',
  text:
      '- После стольких лет? - Всегда...',
  likes: 4,
);

// ---------- Впечатления ----------
const _i1 = Impression(
  author: 'Асем Ж.',
  timeAgo: '5м',
  tag: ImpressionTag.recommend,
  text:
      'С большим удовольствием перечитала спустя несколько лет после школы '
      'и университета, хорошая книга',
  likes: 2,
);
const _i2 = Impression(
  author: 'Баян Куанышбаева',
  timeAgo: 'Знед',
  tag: ImpressionTag.recommend,
  text:
      'Интересно, захватывающе, переживательно. Но тяжелое. Осадок в конце остался',
  likes: 1,
);
const _i3 = Impression(
  author: 'Олеся П.',
  timeAgo: 'Знед',
  tag: ImpressionTag.recommend,
  text:
      'Читала не отрываясь. Даже не жалею, что не читала в школе. Мне кажется '
      'тогда бы я не поняла и не прочувствовала всего.',
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
    similarIds: ['1984_text', 'kamo_text', 'nameofrose_text', 'pdk1_text'],
    readWithIds: ['1984_text', 'kamo_text', 'nameofrose_text', 'pdk1_text'],
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

  // ——— Имя розы ———
  BookEdition(
    id: 'nameofrose_text',
    title: 'Имя розы',
    author: 'Умберто Эко',
    format: BookFormat.text,
    coverUrl: 'assets/covers/nameofrose.jpg',
    description:
        'Какие тайны хранит библиотека аббатства? Расследование ведут монах и послушник.\n "Имя розы"- '
        'книга с загадкой. В начале XIV века, вскоре после того, как Данты сочинил "Божественную комедию", '
        'в сердце Европы, в бенедиктинском монастыре обнаруживаются убитые. Льется Кровь, разверзаются сферы небес. '
        'Череда преступлений воспроизводит не английскую считалочку, а провозвестия Апокалипсиса. Сыщик, конечно, англичанин. '
        'Он напоминает Шерлока Холмса, а его юный ученик - доктора Ватсона. В жесткой конструкции детектива находистя место и ярким фактам '
        'истории Средневековья, и перекличкам с историей XX века, и рассказам о религионых конфликтах и бунтах, и трогательной повести о любви,'
        'и множеству новых загадок, которые мы, читатели, торопимся разрешить, но хитрый автор неизменно обыгрывает нас... '
        'Вплоть до парадоксального и жуткого финала.'
        ,
    genres: ['Проза', 'Исторические детективы', 'Детективы', 'Зарубежная литература', 'Современная литература'],
    rating: 4.9,
    reviewsCount: 15600,
    ageRestriction: '18+',
    originalYear: 1980,
    pages: 560,
    readersCount: 41500,
    quotesCount: 11200,
    impressionsCount: 520,
    shelvesCount: 210,
    reviews: [_r1, _r3],
    quotes: [_q1, _q3],
    impressions: [_i1, _i3],
    similarIds: ['master_text', 'kamo_text', 'pdk1_text'],
    readWithIds: ['master_text', 'kamo_text', 'pdk1_text'],
  ),

  // ——— Камо грядеши ———
  BookEdition(
    id: 'kamo_text',
    title: 'Камо грядеши',
    author: 'Генрик Сенкевич',
    format: BookFormat.text,
    coverUrl: 'assets/covers/kamo.jpg',
    description:
        'Трагическая история первых христиан в Риме и приближенных императора Нерона. ',
    genres: ['Проза', 'Классика', 'Историческая проза'],
    rating: 4.6,
    reviewsCount: 7300,
    ageRestriction: '16+',
    originalYear: 1896,
    pages: 800,
    readersCount: 18700,
    quotesCount: 3400,
    impressionsCount: 240,
    shelvesCount: 74,
    seriesNumber: 1,
    reviews: [_r2],
    quotes: [_q2],
    impressions: [_i2],
    similarIds: ['nameofrose_text', 'vsadnik_text', 'parusa_text'],
    readWithIds: ['nameofrose_text', 'vsadnik_text', 'parusa_text'],
  ),

  // ——— Всадник без головы ———
  BookEdition(
    id: 'vsadnik_text',
    title: 'Всадник без головы',
    author: 'Томас Майн Рид',
    format: BookFormat.text,
    coverUrl: 'assets/covers/vsadnik.jpg',
    description:
        'Середина XIX века. Бескрайние прерии штата Техас... История любви дочери богатого '
        'плантатора Луизы и молодого ловца мустангов Мориса Джеральда, загадочное исчезновение брата Луизы - '
        'Генри Пойнтдекстера и таинственный всадник без головы, наводящий ужас на плататоров, солдат и бандитов... '
        'Коварство и ревность, хитрость и отвага, самоотверженность и предательство - все это складывается '
        'в захватывающий любовно-детективный сюжет, который держит в напряжении до самых последних страниц и будоражит воображение '
        'искателей приключений всех возрастов. '
        ,
    genres: ['Проза', 'Классика', 'Приключения', 'Историческая проза'],
    rating: 4.7,
    reviewsCount: 4100,
    ageRestriction: '12+',
    originalYear: 1865,
    pages: 184,
    readersCount: 21300,
    quotesCount: 2900,
    impressionsCount: 180,
    shelvesCount: 56,
    reviews: [_r3],
    quotes: [_q3],
    impressions: [_i1],
    similarIds: ['treasure_island_text', 'vsadnik_text'],
    readWithIds: ['treasure_island_text', 'vsadnik_text'],
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
    similarIds: ['treasure_island_text'],
    otherEditionIds: ['hp1_audio'],
    readWithIds: ['hp2_text', 'hp3_text', 'hp4_text', 'hp5_text', 'hp6_text', 'hp7_text'],
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
    readWithIds: ['hp2_text'],
  ),
    // ============================================================
  // Гарри Поттер и Тайная комната (книга 2)
  // ============================================================
  BookEdition(
    id: 'hp2_text',
    title: 'Гарри Поттер и Тайная комната',
    author: 'Дж. К. Роулинг',
    format: BookFormat.text,
    coverUrl: 'assets/covers/hp2.jpg',
    description:
        'Второй год обучения в Хогвартсе. В школе появляется таинственный '
        'монстр, на стенах — кровавые надписи, а ученики каменеют один за '
        'другим. Гарри, Рон и Гермиона берутся раскрыть тайну Тайной комнаты.',
    genres: ['Фэнтези', 'Детская литература', 'Приключения'],
    rating: 4.9,
    reviewsCount: 32100,
    ageRestriction: '6+',
    originalYear: 1998,
    pages: 480,
    readersCount: 85400,
    quotesCount: 14200,
    impressionsCount: 760,
    shelvesCount: 280,
    seriesTitle: 'Гарри Поттер',
    seriesNumber: 2,
    reviews: [_r1, _r2],
    quotes: [_q1, _q2],
    impressions: [_i3],
    similarIds: ['hp1_text'],
    otherEditionIds: ['hp2_audio'],
    readWithIds: ['hp1_text', 'hp3_text', 'hp4_text', 'hp5_text', 'hp6_text', 'hp7_text'],
  ),
  BookEdition(
    id: 'hp2_audio',
    title: 'Гарри Поттер и Тайная комната',
    author: 'Дж. К. Роулинг',
    format: BookFormat.audio,
    narrator: 'Александр Клюквин',
    coverUrl: 'assets/covers/hp2_audio.jpg',
    description: 'Вторая книга о Гарри Поттере в аудиоформате.',
    genres: ['Фэнтези', 'Детская литература'],
    rating: 4.9,
    reviewsCount: 7800,
    ageRestriction: '6+',
    originalYear: 1998,
    audioDuration: const Duration(hours: 10, minutes: 40),
    readersCount: 21300,
    quotesCount: 360,
    impressionsCount: 105,
    shelvesCount: 40,
    seriesTitle: 'Гарри Поттер',
    seriesNumber: 2,
    reviews: [_r3],
    quotes: [_q2],
    impressions: [_i1],
    similarIds: ['hp1_audio'],
    otherEditionIds: ['hp2_text'],
    readWithIds: ['hp1_audio'],
  ),

  // ============================================================
  // Гарри Поттер и узник Азкабана (книга 3)
  // ============================================================
  BookEdition(
    id: 'hp3_text',
    title: 'Гарри Поттер и узник Азкабана',
    author: 'Дж. К. Роулинг',
    format: BookFormat.text,
    coverUrl: 'assets/covers/hp3.jpg',
    description:
        'Из тюрьмы Азкабан сбегает опасный преступник Сириус Блэк, и, '
        'кажется, он охотится за Гарри. Но не всё так просто: правда '
        'оказывается куда запутаннее, чем говорит Министерство магии.',
    genres: ['Фэнтези', 'Детская литература', 'Приключения'],
    rating: 4.9,
    reviewsCount: 28900,
    ageRestriction: '6+',
    originalYear: 1999,
    pages: 528,
    readersCount: 78900,
    quotesCount: 12600,
    impressionsCount: 720,
    shelvesCount: 265,
    seriesTitle: 'Гарри Поттер',
    seriesNumber: 3,
    reviews: [_r1, _r3],
    quotes: [_q1, _q3],
    impressions: [_i2],
    similarIds: ['hp2_text', 'hp1_text'],
    otherEditionIds: ['hp3_audio'],
    readWithIds: ['hp1_text', 'hp2_text', 'hp4_text', 'hp5_text', 'hp6_text', 'hp7_text'],
  ),
  BookEdition(
    id: 'hp3_audio',
    title: 'Гарри Поттер и узник Азкабана',
    author: 'Дж. К. Роулинг',
    format: BookFormat.audio,
    narrator: 'Александр Клюквин',
    coverUrl: 'assets/covers/hp3_audio.jpg',
    description: 'Третья книга о Гарри Поттере в аудиоформате.',
    genres: ['Фэнтези', 'Детская литература'],
    rating: 4.9,
    reviewsCount: 7200,
    ageRestriction: '6+',
    originalYear: 1999,
    audioDuration: const Duration(hours: 12, minutes: 15),
    readersCount: 19700,
    quotesCount: 340,
    impressionsCount: 98,
    shelvesCount: 38,
    seriesTitle: 'Гарри Поттер',
    seriesNumber: 3,
    reviews: [_r2],
    quotes: [_q1],
    impressions: [_i3],
    similarIds: ['hp2_audio'],
    otherEditionIds: ['hp3_text'],
    readWithIds: ['hp2_audio'],
  ),

  // ============================================================
  // Гарри Поттер и Кубок огня (книга 4)
  // ============================================================
  BookEdition(
    id: 'hp4_text',
    title: 'Гарри Поттер и Кубок огня',
    author: 'Дж. К. Роулинг',
    format: BookFormat.text,
    coverUrl: 'assets/covers/hp4.jpg',
    description:
        'В Хогвартсе проходит Турнир Трёх Волшебников, и имя Гарри '
        'неожиданно оказывается среди участников — хотя он ещё слишком '
        'юн. Соревнование обернётся событиями, которые изменят всё.',
    genres: ['Фэнтези', 'Детская литература', 'Приключения'],
    rating: 4.9,
    reviewsCount: 34500,
    ageRestriction: '12+',
    originalYear: 2000,
    pages: 640,
    readersCount: 82300,
    quotesCount: 15100,
    impressionsCount: 810,
    shelvesCount: 310,
    seriesTitle: 'Гарри Поттер',
    seriesNumber: 4,
    reviews: [_r1, _r2, _r3],
    quotes: [_q2, _q3],
    impressions: [_i1, _i2],
    similarIds: ['hp3_text', 'dune_text'],
    otherEditionIds: ['hp4_audio'],
    readWithIds: ['hp1_text', 'hp2_text', 'hp3_text', 'hp5_text', 'hp6_text', 'hp7_text'],
  ),
  BookEdition(
    id: 'hp4_audio',
    title: 'Гарри Поттер и Кубок огня',
    author: 'Дж. К. Роулинг',
    format: BookFormat.audio,
    narrator: 'Александр Клюквин',
    coverUrl: 'assets/covers/hp4_audio.jpg',
    description: 'Четвёртая книга о Гарри Поттере в аудиоформате.',
    genres: ['Фэнтези', 'Детская литература'],
    rating: 4.9,
    reviewsCount: 8400,
    ageRestriction: '12+',
    originalYear: 2000,
    audioDuration: const Duration(hours: 20, minutes: 30),
    readersCount: 22100,
    quotesCount: 410,
    impressionsCount: 132,
    shelvesCount: 52,
    seriesTitle: 'Гарри Поттер',
    seriesNumber: 4,
    reviews: [_r3],
    quotes: [_q3],
    impressions: [_i1],
    similarIds: ['hp3_audio'],
    otherEditionIds: ['hp4_text'],
    readWithIds: ['hp3_audio'],
  ),

  // ============================================================
  // Гарри Поттер и Орден Феникса (книга 5)
  // ============================================================
  BookEdition(
    id: 'hp5_text',
    title: 'Гарри Поттер и Орден Феникса',
    author: 'Дж. К. Роулинг',
    format: BookFormat.text,
    coverUrl: 'assets/covers/hp5.jpg',
    description:
        'Волан-де-Морт вернулся, но Министерство магии отказывается это '
        'признавать. Гарри предстоит узнать правду о прошлом, собрать '
        'Орден Феникса и научиться защищаться.',
    genres: ['Фэнтези', 'Детская литература', 'Приключения'],
    rating: 4.8,
    reviewsCount: 29800,
    ageRestriction: '12+',
    originalYear: 2003,
    pages: 896,
    readersCount: 71200,
    quotesCount: 13400,
    impressionsCount: 690,
    shelvesCount: 275,
    seriesTitle: 'Гарри Поттер',
    seriesNumber: 5,
    reviews: [_r2, _r3],
    quotes: [_q1, _q3],
    impressions: [_i2, _i3],
    similarIds: ['hp4_text', '1984_text'],
    otherEditionIds: ['hp5_audio'],
    readWithIds: ['hp1_text', 'hp2_text', 'hp3_text', 'hp4_text', 'hp6_text', 'hp7_text'],
  ),
  BookEdition(
    id: 'hp5_audio',
    title: 'Гарри Поттер и Орден Феникса',
    author: 'Дж. К. Роулинг',
    format: BookFormat.audio,
    narrator: 'Александр Клюквин',
    coverUrl: 'assets/covers/hp5_audio.jpg',
    description: 'Пятая книга о Гарри Поттере в аудиоформате.',
    genres: ['Фэнтези', 'Детская литература'],
    rating: 4.8,
    reviewsCount: 6900,
    ageRestriction: '12+',
    originalYear: 2003,
    audioDuration: const Duration(hours: 29, minutes: 20),
    readersCount: 18400,
    quotesCount: 380,
    impressionsCount: 115,
    shelvesCount: 44,
    seriesTitle: 'Гарри Поттер',
    seriesNumber: 5,
    reviews: [_r1],
    quotes: [_q2],
    impressions: [_i2],
    similarIds: ['hp4_audio'],
    otherEditionIds: ['hp5_text'],
    readWithIds: ['hp4_audio'],
  ),

  // ============================================================
  // Гарри Поттер и Принц-полукровка (книга 6)
  // ============================================================
  BookEdition(
    id: 'hp6_text',
    title: 'Гарри Поттер и Принц-полукровка',
    author: 'Дж. К. Роулинг',
    format: BookFormat.text,
    coverUrl: 'assets/covers/hp6.jpg',
    description:
        'Гарри находит старый учебник зельеварения с пометками загадочного '
        'Принца-полукровки. А Дамблдор знакомит его с воспоминаниями о '
        'прошлом Волан-де-Морта.',
    genres: ['Фэнтези', 'Детская литература', 'Приключения'],
    rating: 4.8,
    reviewsCount: 25600,
    ageRestriction: '12+',
    originalYear: 2005,
    pages: 672,
    readersCount: 68900,
    quotesCount: 11200,
    impressionsCount: 640,
    shelvesCount: 245,
    seriesTitle: 'Гарри Поттер',
    seriesNumber: 6,
    reviews: [_r1, _r3],
    quotes: [_q1, _q2],
    impressions: [_i1, _i3],
    similarIds: ['hp5_text'],
    otherEditionIds: ['hp6_audio'],
    readWithIds: ['hp1_text', 'hp2_text', 'hp3_text', 'hp4_text', 'hp5_text', 'hp7_text'],
  ),
  BookEdition(
    id: 'hp6_audio',
    title: 'Гарри Поттер и Принц-полукровка',
    author: 'Дж. К. Роулинг',
    format: BookFormat.audio,
    narrator: 'Александр Клюквин',
    coverUrl: 'assets/covers/hp6_audio.jpg',
    description: 'Шестая книга о Гарри Поттере в аудиоформате.',
    genres: ['Фэнтези', 'Детская литература'],
    rating: 4.8,
    reviewsCount: 6200,
    ageRestriction: '12+',
    originalYear: 2005,
    audioDuration: const Duration(hours: 19, minutes: 40),
    readersCount: 16800,
    quotesCount: 320,
    impressionsCount: 102,
    shelvesCount: 41,
    seriesTitle: 'Гарри Поттер',
    seriesNumber: 6,
    reviews: [_r2],
    quotes: [_q1],
    impressions: [_i3],
    similarIds: ['hp5_audio'],
    otherEditionIds: ['hp6_text'],
    readWithIds: ['hp5_audio'],
  ),

  // ============================================================
  // Гарри Поттер и Дары Смерти (книга 7)
  // ============================================================
  BookEdition(
    id: 'hp7_text',
    title: 'Гарри Поттер и Дары Смерти',
    author: 'Дж. К. Роулинг',
    format: BookFormat.text,
    coverUrl: 'assets/covers/hp7.jpg',
    description:
        'Финальная битва с Волан-де-Мортом. Гарри, Рон и Гермиона '
        'отправляются на поиски крестражей, оставив Хогвартс. От исхода '
        'их путешествия зависит судьба магического мира.',
    genres: ['Фэнтези', 'Детская литература', 'Приключения'],
    rating: 4.9,
    reviewsCount: 38200,
    ageRestriction: '12+',
    originalYear: 2007,
    pages: 704,
    readersCount: 92100,
    quotesCount: 16800,
    impressionsCount: 920,
    shelvesCount: 355,
    seriesTitle: 'Гарри Поттер',
    seriesNumber: 7,
    reviews: [_r1, _r2, _r3],
    quotes: [_q1, _q2, _q3],
    impressions: [_i1, _i2, _i3],
    similarIds: ['hp6_text', 'master_text'],
    otherEditionIds: ['hp7_audio'],
    readWithIds: ['hp1_text', 'hp2_text', 'hp3_text', 'hp4_text', 'hp5_text', 'hp6_text'],
  ),
  BookEdition(
    id: 'hp7_audio',
    title: 'Гарри Поттер и Дары Смерти',
    author: 'Дж. К. Роулинг',
    format: BookFormat.audio,
    narrator: 'Александр Клюквин',
    coverUrl: 'assets/covers/hp7_audio.jpg',
    description: 'Седьмая книга о Гарри Поттере в аудиоформате.',
    genres: ['Фэнтези', 'Детская литература'],
    rating: 4.9,
    reviewsCount: 9600,
    ageRestriction: '12+',
    originalYear: 2007,
    audioDuration: const Duration(hours: 24, minutes: 10),
    readersCount: 24600,
    quotesCount: 430,
    impressionsCount: 148,
    shelvesCount: 58,
    seriesTitle: 'Гарри Поттер',
    seriesNumber: 7,
    reviews: [_r1, _r3],
    quotes: [_q2],
    impressions: [_i1],
    similarIds: ['hp6_audio'],
    otherEditionIds: ['hp7_text'],
    readWithIds: ['hp6_audio', 'master_audio'],
  ),

  // ——— Остров сокровищ ———
  BookEdition(
    id: 'treasure_island_text',
    title: 'Остров сокровищ',
    author: 'Роберт Льюис Стивенсон',
    format: BookFormat.text,
    coverUrl: 'assets/covers/treasure_island.jpg',
    description:
        'Таинственная карта давно  погибшего знаменитого пирата с указанием '
        'местоположения клада, зарытого на необитаемом острове, становится причиной '
        'зловещих заговоров, загадочных убийств и других захватывающих событий. '
        ,
    genres: ['Проза', 'Приключения', 'Детская проза'],
    rating: 4.5,
    reviewsCount: 6100,
    ageRestriction: '18+',
    originalYear: 1883,
    pages: 860,
    readersCount: 15200,
    quotesCount: 3100,
    impressionsCount: 210,
    shelvesCount: 68,
    reviews: [_r2],
    quotes: [_q2],
    impressions: [_i2],
    similarIds: ['vsadnik_text', 'povelitel_text', 'parusa_text'],
    readWithIds: ['vsadnik_text', 'povelitel_text', 'parusa_text'],
  ),

  // ——— Алые паруса ———
  BookEdition(
    id: 'parusa_text',
    title: 'Алые паруса',
    author: 'Александр Грин',
    format: BookFormat.text,
    coverUrl: 'assets/covers/parusa.jpg',
    description:
        'Романтическая повесть Александра Грина, в которой рассказывается история Ассоль - '
        'девушки, живущей в деревне у моря. Однажды она встречает необычного незнакомца, который предсказывает, '
        'что в будущем за девушкой на корабле под алыми парусами прибудет принц. В это время на другом конце '
        'света Артур Грей - единственный отпрыск богатой семьи, готовится отправиться в морское путешествие. '
        ,
    genres: ['Проза', 'Русская литература', 'Романтика'],
    rating: 4.4,
    reviewsCount: 3900,
    ageRestriction: '18+',
    originalYear: 1923,
    pages: 84,
    readersCount: 8900,
    quotesCount: 2200,
    impressionsCount: 130,
    shelvesCount: 40,
    reviews: [_r3],
    quotes: [_q3],
    impressions: [_i3],
    similarIds: ['treasure_island_text', 'vsadnik_text'],
    readWithIds: ['treasure_island_text', 'vsadnik_text'],
  ),

  // ——— Повелитель мух ———
  BookEdition(
    id: 'povelitel_text',
    title: 'Повелитель мух',
    author: 'Уильям Голдинг',
    format: BookFormat.text,
    coverUrl: 'assets/covers/povelitel.jpg',
    description:
        'История благовоспитанных мальчиков, внезапно оказавшихся на необитаемом острове.  '
        'Философская притча о том, что может произойти с людьми, забывшими о любви и милосердии. '
        'Гротескная антиутопия, роман-предубеждение и, конечно, напоминание о хрупкости мира, '
        'в котором живем мы все.'
        ,
    genres: ['Проза', 'Зарубежная классика', 'Антиутопия', 'Литература XX века'],
    rating: 4.4,
    reviewsCount: 3900,
    ageRestriction: '18+',
    originalYear: 1954,
    pages: 320,
    readersCount: 8900,
    quotesCount: 2200,
    impressionsCount: 130,
    shelvesCount: 40,
    reviews: [_r3],
    quotes: [_q3],
    impressions: [_i3],
    similarIds: ['1984_text', 'nameofrose_text'],
    readWithIds: ['1984_text', 'nameofrose_text'],
  ),

  // ============================================================
  // Проклятые короли — Морис Дрюон
  // ============================================================
  BookEdition(
    id: 'pdk1_text',
    title: 'Железный король',
    author: 'Морис Дрюон',
    format: BookFormat.text,
    coverUrl: 'assets/covers/pdk1.jpg',
    description:
        'Франция, 1314 год. Король Филипп IV Красивый, прозванный Железным, '
        'расправляется с орденом тамплиеров. Великий магистр Жак де Моле, '
        'всходя на костёр, проклинает короля и его потомков. Проклятие '
        'начинает сбываться.',
    genres: ['Исторический роман', 'Историческая проза', 'Зарубежная классика'],
    rating: 4.8,
    reviewsCount: 12400,
    ageRestriction: '16+',
    originalYear: 1955,
    pages: 384,
    readersCount: 45200,
    quotesCount: 3100,
    impressionsCount: 340,
    shelvesCount: 128,
    seriesTitle: 'Проклятые короли',
    seriesNumber: 1,
    reviews: [_r1, _r3],
    quotes: [_q1, _q3],
    impressions: [_i1, _i3],
    similarIds: ['pdk2_text', 'nameofrose_text', 'kamo_text'],
    readWithIds: ['nameofrose_text', 'kamo_text', 'pdk2_text','pdk3_text','pdk4_text','pdk5_text','pdk6_text','pdk7_text'],
  ),

  BookEdition(
    id: 'pdk2_text',
    title: 'Узница Шато-Гайара',
    author: 'Морис Дрюон',
    format: BookFormat.text,
    coverUrl: 'assets/covers/pdk2.jpg',
    description:
        'После смерти Филиппа Красивого на трон всходит его сын Людовик X. '
        'Его жена Маргарита Бургундская, уличенная в измене, заперта в '
        'крепости Шато-Гайар. В королевстве начинается борьба за власть.',
    genres: ['Исторический роман', 'Историческая проза', 'Зарубежная классика'],
    rating: 4.8,
    reviewsCount: 9800,
    ageRestriction: '16+',
    originalYear: 1955,
    pages: 320,
    readersCount: 38400,
    quotesCount: 2700,
    impressionsCount: 290,
    shelvesCount: 96,
    seriesTitle: 'Проклятые короли',
    seriesNumber: 2,
    reviews: [_r2, _r3],
    quotes: [_q2, _q3],
    impressions: [_i1, _i2],
    similarIds: ['pdk1_text', 'pdk3_text'],
    readWithIds: ['pdk1_text','pdk3_text','pdk4_text','pdk5_text','pdk6_text','pdk7_text'],
  ),

  BookEdition(
    id: 'pdk3_text',
    title: 'Яд и корона',
    author: 'Морис Дрюон',
    format: BookFormat.text,
    coverUrl: 'assets/covers/pdk3.jpg',
    description:
        'Людовик X умирает, оставив после себя беременную жену и '
        'королевство в смятении. Англия и Франция плетут интриги, а '
        'придворные делят трон, не гнушаясь ни ядом, ни мечом.',
    genres: ['Исторический роман', 'Историческая проза', 'Зарубежная классика'],
    rating: 4.8,
    reviewsCount: 8900,
    ageRestriction: '16+',
    originalYear: 1956,
    pages: 352,
    readersCount: 34100,
    quotesCount: 2500,
    impressionsCount: 270,
    shelvesCount: 88,
    seriesTitle: 'Проклятые короли',
    seriesNumber: 3,
    reviews: [_r1, _r2],
    quotes: [_q1, _q2],
    impressions: [_i2, _i3],
    similarIds: ['pdk2_text', 'pdk4_text'],
    readWithIds: ['pdk1_text','pdk2_text','pdk4_text','pdk5_text','pdk6_text','pdk7_text'],
  ),

  BookEdition(
    id: 'pdk4_text',
    title: 'Негоже лилиям прясть',
    author: 'Морис Дрюон',
    format: BookFormat.text,
    coverUrl: 'assets/covers/pdk4.jpg',
    description:
        'Филипп V Длинный, новый король Франции, сталкивается с '
        'проблемой престолонаследия. Впервые в истории поднимается '
        'вопрос о том, может ли женщина взойти на французский трон.',
    genres: ['Исторический роман', 'Историческая проза', 'Зарубежная классика'],
    rating: 4.7,
    reviewsCount: 7600,
    ageRestriction: '16+',
    originalYear: 1957,
    pages: 336,
    readersCount: 29800,
    quotesCount: 2200,
    impressionsCount: 240,
    shelvesCount: 74,
    seriesTitle: 'Проклятые короли',
    seriesNumber: 4,
    reviews: [_r2, _r3],
    quotes: [_q2, _q3],
    impressions: [_i1, _i3],
    similarIds: ['pdk3_text', 'pdk5_text'],
    readWithIds: ['pdk1_text','pdk2_text','pdk3_text','pdk5_text','pdk6_text','pdk7_text'],
  ),

  BookEdition(
    id: 'pdk5_text',
    title: 'Французская волчица',
    author: 'Морис Дрюон',
    format: BookFormat.text,
    coverUrl: 'assets/covers/pdk5.jpg',
    description:
        'Королева Изабелла, сестра французского короля и жена английского '
        'монарха, решает отомстить за поруганную честь. Её план приведёт '
        'к войне, которая изменит судьбу двух королевств.',
    genres: ['Исторический роман', 'Историческая проза', 'Зарубежная классика'],
    rating: 4.8,
    reviewsCount: 8200,
    ageRestriction: '16+',
    originalYear: 1959,
    pages: 416,
    readersCount: 31500,
    quotesCount: 2400,
    impressionsCount: 260,
    shelvesCount: 82,
    seriesTitle: 'Проклятые короли',
    seriesNumber: 5,
    reviews: [_r1, _r3],
    quotes: [_q1, _q3],
    impressions: [_i1, _i2],
    similarIds: ['pdk4_text', 'pdk6_text'],
    readWithIds: ['pdk1_text','pdk2_text','pdk3_text','pdk4_text','pdk6_text','pdk7_text'],
  ),

  BookEdition(
    id: 'pdk6_text',
    title: 'Лилия и лев',
    author: 'Морис Дрюон',
    format: BookFormat.text,
    coverUrl: 'assets/covers/pdk6.jpg',
    description:
        'Эдуард III Английский предъявляет права на французский престол, '
        'и над Европой нависает тень Столетней войны. Франция должна '
        'решить, кто её истинный король.',
    genres: ['Исторический роман', 'Историческая проза', 'Зарубежная классика'],
    rating: 4.7,
    reviewsCount: 7100,
    ageRestriction: '16+',
    originalYear: 1960,
    pages: 400,
    readersCount: 27400,
    quotesCount: 2100,
    impressionsCount: 220,
    shelvesCount: 68,
    seriesTitle: 'Проклятые короли',
    seriesNumber: 6,
    reviews: [_r2, _r3],
    quotes: [_q2],
    impressions: [_i2, _i3],
    similarIds: ['pdk5_text', 'pdk7_text'],
    readWithIds: ['pdk1_text','pdk2_text','pdk3_text','pdk4_text','pdk5_text','pdk7_text'],
  ),

  BookEdition(
    id: 'pdk7_text',
    title: 'Когда король губит Францию',
    author: 'Морис Дрюон',
    format: BookFormat.text,
    coverUrl: 'assets/covers/pdk7.jpg',
    description:
        'Заключительная книга цикла. Иоанн II Добрый попадает в '
        'английский плен, и Франция погружается в хаос. Проклятие '
        'тамплиеров исполняется до конца.',
    genres: ['Исторический роман', 'Историческая проза', 'Зарубежная классика'],
    rating: 4.8,
    reviewsCount: 8400,
    ageRestriction: '16+',
    originalYear: 1977,
    pages: 448,
    readersCount: 30100,
    quotesCount: 2600,
    impressionsCount: 280,
    shelvesCount: 90,
    seriesTitle: 'Проклятые короли',
    seriesNumber: 7,
    reviews: [_r1, _r2, _r3],
    quotes: [_q1, _q2, _q3],
    impressions: [_i1, _i2, _i3],
    similarIds: ['pdk6_text', 'pdk1_text'],
    readWithIds: ['pdk1_text','pdk2_text','pdk3_text','pdk4_text','pdk5_text','pdk6_text'],
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