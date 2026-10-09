import 'package:flutter/material.dart';

class NoInternetView extends StatelessWidget {
  /// Что делать при нажатии «Обновить» — повторить текущий запрос.
  final VoidCallback onRetry;

  /// Что делать при нажатии «Смотреть книги на устройстве».
  final VoidCallback? onOpenLocal;

  const NoInternetView({
    super.key,
    required this.onRetry,
    this.onOpenLocal,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final secondary = theme.textTheme.bodySmall?.color;
    final isDark = theme.brightness == Brightness.dark;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(32, 24, 32, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ---------- Иллюстрация ----------
            Image.asset(
              'assets/images/not_found.png',
              width: 200,
              height: 200,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const _NloIllustration(),
            ),
            const SizedBox(height: 24),

            // ---------- Заголовок ----------
            const Text(
              'Нет интернета',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.3,
                height: 1.15,
              ),
            ),
            const SizedBox(height: 12),

            // ---------- Подзаголовок ----------
            Text(
              'Сейчас можно читать и слушать\n'
              'только книги, которые вы\n'
              'загрузили на устройство раньше',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: secondary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),

            // ---------- Кнопка «Обновить» ----------
            SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: onRetry,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isDark ? Colors.white : const Color(0xFF1A1A1A),
                  foregroundColor:
                      isDark ? const Color(0xFF1A1A1A) : Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: const Text(
                  'Обновить',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // ---------- Ссылка «Смотреть книги на устройстве» ----------
            GestureDetector(
              onTap: onOpenLocal ?? () {},
              child: Text(
                'Смотреть книги на устройстве',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: theme.textTheme.bodyLarge?.color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NloIllustration extends StatelessWidget {
  const _NloIllustration();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Основание тарелки — вытянутый овал
          Positioned(
            bottom: 40,
            child: Container(
              width: 160,
              height: 26,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(13),
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF6B35), Color(0xFFFF3F3F)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),

          // Купол (полусфера)
          Positioned(
            bottom: 60,
            child: Container(
              width: 110,
              height: 70,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFFFB07A), Color(0xFFFF7A45)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(60),
                  topRight: Radius.circular(60),
                ),
              ),
            ),
          ),

          // Ножки-опоры слева
          Positioned(
            bottom: 20,
            left: 34,
            child: Transform.rotate(
              angle: -0.35,
              child: Container(
                width: 26,
                height: 10,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF7A45),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
          // Ножка справа
          Positioned(
            bottom: 20,
            right: 34,
            child: Transform.rotate(
              angle: 0.35,
              child: Container(
                width: 26,
                height: 10,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF7A45),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),

          // Вопросительный знак справа сверху
          const Positioned(
            top: 12,
            right: 8,
            child: Text(
              '?',
              style: TextStyle(
                fontSize: 68,
                fontWeight: FontWeight.w900,
                height: 0.9,
                color: Color(0xFFFFB6C1),
              ),
            ),
          ),

          // Звёздочка 1 (слева сверху)
          const Positioned(
            top: 20,
            left: 20,
            child: Icon(
              Icons.auto_awesome,
              size: 26,
              color: Color(0xFFFFB6C1),
            ),
          ),
          // Звёздочка 2 (справа, ниже)
          const Positioned(
            top: 90,
            right: -2,
            child: Icon(
              Icons.auto_awesome,
              size: 34,
              color: Color(0xFFFFB6C1),
            ),
          ),
        ],
      ),
    );
  }
}