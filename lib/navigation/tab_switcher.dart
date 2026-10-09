import 'package:flutter/widgets.dart';

/// Позволяет экранам внутри IndexedStack программно переключать
/// активную вкладку в RootScreen.
///
/// Использование из любого потомка:
///   TabSwitcher.of(context)?.switchTo(3); // Поиск
class TabSwitcher extends InheritedWidget {
  final void Function(int index) switchTo;

  const TabSwitcher({
    super.key,
    required this.switchTo,
    required super.child,
  });

  static TabSwitcher? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<TabSwitcher>();
  }

  @override
  bool updateShouldNotify(TabSwitcher oldWidget) =>
      switchTo != oldWidget.switchTo;
}

/// Индексы вкладок — в одном месте, чтобы не путаться.
class TabIndex {
  static const int myBooks = 0;
  static const int home = 1;
  static const int assistant = 2;
  static const int search = 3;
  static const int profile = 4;
}