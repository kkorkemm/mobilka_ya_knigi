import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  /// Радиусы, которые в оригинале повторяются повсюду
  static const radiusCard = 16.0;
  static const radiusButton = 12.0;
  static const radiusChip = 20.0;
  static const hPad = 16.0; // горизонтальные отступы экрана

  static ThemeData light() => _build(Brightness.light);
  static ThemeData dark() => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;

    final bg = isDark ? AppColors.darkBackground : AppColors.lightBackground;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final card = isDark ? AppColors.darkCard : AppColors.lightCard;
    final divider = isDark ? AppColors.darkDivider : AppColors.lightDivider;
    final textPrimary =
        isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    final base = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: bg,
      splashFactory: InkSparkle.splashFactory,
    );

    return base.copyWith(
      colorScheme: base.colorScheme.copyWith(
        primary: AppColors.accent,
        secondary: AppColors.accent,
        surface: bg,
        error: AppColors.error,
      ),
      dividerColor: divider,
      cardColor: card,
      appBarTheme: AppBarTheme(
        backgroundColor: bg,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: textPrimary, size: 24),
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.2,
        ),
      ),
      textTheme: base.textTheme
          .apply(
            bodyColor: textPrimary,
            displayColor: textPrimary,
            // fontFamily: 'YSText',
          )
          .copyWith(
            // Заголовок экрана
            headlineMedium: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.5,
              color: textPrimary,
            ),
            // Заголовок секции
            titleLarge: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.3,
              color: textPrimary,
            ),
            // Название книги в списке
            titleMedium: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: textPrimary,
            ),
            // Основной текст
            bodyLarge: TextStyle(fontSize: 16, color: textPrimary),
            bodyMedium: TextStyle(fontSize: 14, color: textPrimary),
            // Вторичный текст (автор, метаданные)
            bodySmall: TextStyle(fontSize: 13, color: textSecondary),
            labelLarge: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        hintStyle: TextStyle(color: textSecondary, fontSize: 16),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusButton),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusButton),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusButton),
          borderSide: const BorderSide(color: AppColors.accent, width: 1.5),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accent,
          foregroundColor: Colors.white,
          elevation: 0,
          minimumSize: const Size(0, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusButton),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: textPrimary,
          minimumSize: const Size(0, 52),
          side: BorderSide(color: divider),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusButton),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.accent,
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: bg,
        selectedItemColor: AppColors.accent,
        unselectedItemColor: textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        showUnselectedLabels: true,
        selectedLabelStyle:
            const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(fontSize: 11),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: isDark ? const Color(0xFF2C2C2E) : const Color(0xFF2B2B2B),
        contentTextStyle: const TextStyle(color: Colors.white, fontSize: 14),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusButton),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: bg,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
      ),
    );
  }
}