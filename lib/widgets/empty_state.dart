import 'package:flutter/material.dart';

/// Универсальный вид для пустых состояний и ошибок:
/// картинка (если есть) + заголовок + подпись.
///
/// Картинка берётся из assets. Если её нет — показывается fallbackIcon.
class EmptyState extends StatelessWidget {
  /// Путь к картинке, например 'assets/images/no_results.png'.
  final String imagePath;

  /// Иконка-заглушка, если картинки нет.
  final IconData fallbackIcon;

  final String title;
  final String subtitle;

  /// Размер картинки/иконки.
  final double imageSize;

  const EmptyState({
    super.key,
    required this.imagePath,
    required this.fallbackIcon,
    required this.title,
    required this.subtitle,
    this.imageSize = 160,
  });

  @override
  Widget build(BuildContext context) {
    final secondary = Theme.of(context).textTheme.bodySmall?.color;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Пытаемся показать картинку, при ошибке — иконку.
            Image.asset(
              imagePath,
              width: imageSize,
              height: imageSize,
              fit: BoxFit.contain,
              filterQuality: FilterQuality.high,
              errorBuilder: (context, error, stack) => Icon(
                fallbackIcon,
                size: imageSize * 0.4,
                color: secondary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: secondary),
            ),
          ],
        ),
      ),
    );
  }
}