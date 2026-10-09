import 'package:flutter/material.dart';

/// Палитра, приближенная к Яндекс Книгам.
/// Значения подгони под пипетку со скриншотов из ДЗ1.
class AppColors {
  AppColors._();

  // Акцент (кнопки «Читать», активная вкладка, ссылки)
  static const accent = Color(0xFFFFFFFF);
  static const accentPressed = Color(0xFFFFFFFF);
  static const accentSoft = Color(0x1AFC3F1D); // 10% от accent

  // Светлая тема
  static const lightBackground = Color(0xFFFFFFFF);
  static const lightSurface = Color(0xFFF2F2F5);
  static const lightCard = Color(0xFFFFFFFF);
  static const lightDivider = Color(0xFFE8E8EA);
  static const lightTextPrimary = Color(0xFF1A1A1A);
  static const lightTextSecondary = Color(0xFF8A8A8E);

  static const lightChipBorder = Color(0xFFE0E0E2);
static const darkChipBorder = Color(0xFF3A3A3C);

  // Тёмная тема
  static const darkBackground = Color(0xFF21201E);
  static const darkSurface = Color(0xFF1C1C1E);
  static const darkDivider = Color(0xFF2A2A2C);
  static const darkTextPrimary = Color(0xFFFFFFFF);
  static const darkTextSecondary = Color(0xFF98989E);
  static const darkCard = Color(0xFF1E1E1F);

  // Служебные
  static const rating = Color(0xFFFFA000);
  static const success = Color(0xFF34C759);
  static const error = Color(0xFFFF3B30);

  /// Палитра для генерации заглушек-обложек,
  /// пока нет реальных картинок.
  static const coverGradients = <List<Color>>[
    [Color(0xFF6A11CB), Color(0xFF2575FC)],
    [Color(0xFFFF512F), Color(0xFFDD2476)],
    [Color(0xFF11998E), Color(0xFF38EF7D)],
    [Color(0xFFFC466B), Color(0xFF3F5EFB)],
    [Color(0xFF232526), Color(0xFF414345)],
    [Color(0xFFF7971E), Color(0xFFFFD200)],
    [Color(0xFF00C6FF), Color(0xFF0072FF)],
    [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
  ];
}