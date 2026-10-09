import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Строка списка в «Моих книгах»: иконка + название + счётчик + стрелка.
class LibrarySectionRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final int count;
  final VoidCallback? onTap;

  const LibrarySectionRow({
    super.key,
    required this.icon,
    required this.title,
    required this.count,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final secondary = theme.textTheme.bodySmall?.color;
    final divider =
        isDark ? AppColors.darkDivider : AppColors.lightDivider;

    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: divider, width: 0.5),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        child: Row(
          children: [
            Icon(icon, size: 22, color: secondary),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Text(
              '$count',
              style: TextStyle(fontSize: 16, color: secondary),
            ),
          ],
        ),
      ),
    );
  }
}