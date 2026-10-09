import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Нижняя панель вкладок.
/// В оригинале — своя (не Material BottomNavigationBar): плоские иконки,
/// без подписей, лёгкая анимация переключения, тонкий разделитель сверху.
class AppBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
            width: 0.5,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 56,
          child: Row(
            children: [
              // 1. Мои книги
              _NavItem(
                index: 0,
                currentIndex: currentIndex,
                onTap: onTap,
                icon: const Icon(Icons.book_outlined, size: 26),
                activeIcon: const Icon(Icons.book_rounded, size: 26),
              ),
              // 2. Главный экран — логотип Яндекс (картинка)
              _NavItem(
                index: 1,
                currentIndex: currentIndex,
                onTap: onTap,
                // Логотип одинаковый в активном/неактивном состоянии —
                // активность подчёркивается только цветом «подложки».
                icon: const _YandexLogo(size: 24),
                activeIcon: const _YandexLogo(size: 24),
              ),
              // 3. ИИ-ассистент
              _NavItem(
                index: 2,
                currentIndex: currentIndex,
                onTap: onTap,
                icon: const _SparkleGradientIcon(size: 26),
                activeIcon: const _SparkleGradientIcon(size: 26),
              ),
              // 4. Поиск
              _NavItem(
                index: 3,
                currentIndex: currentIndex,
                onTap: onTap,
                icon: const Icon(Icons.search_rounded, size: 26),
                activeIcon: const Icon(Icons.search_rounded, size: 26),
              ),
              // 5. Мой профиль
              _NavItem(
                index: 4,
                currentIndex: currentIndex,
                onTap: onTap,
                icon: const Icon(Icons.person_outline_rounded, size: 26),
                activeIcon: const Icon(Icons.person_rounded, size: 26),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Логотип Яндекс Книг (или Яндекс-«Я») для средней вкладки.
/// Цвет регулируется через ColorFilter (в Material 3 API используем .srcIn).
class _YandexLogo extends StatelessWidget {
  final double size;

  const _YandexLogo({required this.size});

  @override
  Widget build(BuildContext context) {
    return ColorFiltered(
      // Красим PNG в нужный цвет в рантайме:
      //   активная вкладка → AppColors.accent,
      //   неактивная → серый.
      // ВНИМАНИЕ: это работает, только если PNG — монохромный
      // (белый или чёрный силуэт на прозрачном фоне).
      colorFilter: const ColorFilter.mode(
        Colors.black, // заглушка, реальный цвет задаёт _NavItem ниже
        BlendMode.dstIn,
      ),
      child: Image.asset(
        'assets/icons/main_logo.png',
        width: size,
        height: size,
        fit: BoxFit.contain,
        filterQuality: FilterQuality.high,
      ),
    );
  }
}


class _NavItem extends StatelessWidget {
  final int index;
  final int currentIndex;
  final ValueChanged<int> onTap;
  final Widget icon;
  final Widget activeIcon;

  const _NavItem({
    required this.index,
    required this.currentIndex,
    required this.onTap,
    required this.icon,
    required this.activeIcon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isActive = index == currentIndex;
    final inactiveColor = theme.textTheme.bodySmall?.color ?? Colors.grey;
    final color = isActive ? AppColors.accent : inactiveColor;

    // Для Widget-иконок (Icon) применяем цвет напрямую,
    // для картинок (Image.asset) — оборачиваем в ColorFiltered,
    // чтобы покрасить монохромный PNG.
    Widget painted(Widget child) {
      if (child is Icon) {
        return Icon(
          child.icon,
          size: child.size,
          color: color,
        );
      }
      // Для Image.asset (нашего логотипа) — красим через ColorFilter.
      if (child is Image) {
        return ColorFiltered(
          colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
          child: child,
        );
      }
      return child;
    }

    return Expanded(
      child: InkResponse(
        onTap: () => onTap(index),
        radius: 40,
        containedInkWell: false,
        child: Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 180),
            switchInCurve: Curves.easeOutBack,
            switchOutCurve: Curves.easeIn,
            transitionBuilder: (child, anim) =>
                ScaleTransition(scale: anim, child: child),
            child: KeyedSubtree(
              key: ValueKey<bool>(isActive),
              child: painted(isActive ? activeIcon : icon),
            ),
          ),
        ),
      ),
    );
  }
}

class _SparkleGradientIcon extends StatelessWidget {
  final double size;

  const _SparkleGradientIcon({required this.size});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
        colors: [
          Color(0xFFFF7AB6),
          Color(0xFFC265F0),
          Color(0xFF4AA3FF),
        ],
        begin: Alignment.bottomLeft,
        end: Alignment.topRight,
      ).createShader(bounds),
      blendMode: BlendMode.srcIn,
      child: Icon(
        Icons.auto_awesome,
        size: size,
        color: Colors.white,
      ),
    );
  }
}