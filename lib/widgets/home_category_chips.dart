import 'package:flutter/material.dart';

import '../data/mock_collection.dart';
import '../theme/app_colors.dart';

/// Горизонтальная полоса категорий над каруселью.
/// Первый элемент — плитка-сетка, остальные — обычные чипсы.
class HomeCategoryChips extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  const HomeCategoryChips({
    super.key,
    required this.selectedIndex,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final border =
        isDark ? AppColors.darkChipBorder : AppColors.lightChipBorder;

    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: homeCategories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final c = homeCategories[i];
          final active = i == selectedIndex;

          return Center(
            child: GestureDetector(
              onTap: () => onSelect(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                height: 40,
                padding: EdgeInsets.symmetric(
                  horizontal: c.isGrid ? 12 : 16,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: border, width: 0.8),
                  color: active
                      ? border.withValues(alpha: 0.4)
                      : Colors.transparent,
                ),
                child: c.isGrid
                    ? Icon(
                        Icons.grid_view_rounded,
                        size: 20,
                        color: theme.textTheme.bodyLarge?.color,
                      )
                    : Center(
                        child: Text(
                          c.label,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
              ),
            ),
          );
        },
      ),
    );
  }
}