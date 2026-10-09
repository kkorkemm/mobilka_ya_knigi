import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../widgets/app_bottom_nav.dart';
import '../widgets/mini_player.dart';
import 'ai_assistant_screen.dart';
import 'home_screen.dart';
import 'my_books_screen.dart';
import 'profile_screen.dart';
import 'search_screen.dart';
import '../navigation/tab_switcher.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  // Порядок вкладок:
  //   0 — Мои книги
  //   1 — Главная
  //   2 — ИИ-ассистент
  //   3 — Поиск
  //   4 — Профиль
  static const int _homeTabIndex = 1;

  int _index = _homeTabIndex;

  // У каждой вкладки — свой Navigator. Это даёт два эффекта:
  //   1. Стек переходов вкладки сохраняется при переключении между вкладками.
  //   2. Нижняя панель и мини-плеер остаются видимыми на вложенных экранах
  //      (страница книги, читалка и т.п.), потому что push идёт в этот
  //      внутренний Navigator, а не в корневой.
  final List<GlobalKey<NavigatorState>> _navKeys =
      List.generate(5, (_) => GlobalKey<NavigatorState>());

  Widget _screenForTab(int i) {
    switch (i) {
      case 0:
        return const MyBooksScreen();
      case 1:
        return const HomeScreen();
      case 2:
        return const AiAssistantScreen();
      case 3:
        return const SearchScreen();
      case 4:
        return const ProfileScreen();
      default:
        return const SizedBox.shrink();
    }
  }

  void _onTabTapped(int i) {
    if (i == _index) {
      // Повторный тап по активной вкладке — pop до её корня.
      _navKeys[i].currentState?.popUntil((r) => r.isFirst);
      return;
    }
    setState(() => _index = i);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;

        final navState = _navKeys[_index].currentState;
        if (navState != null) {
          final popped = await navState.maybePop();
          if (popped) return;
        }
        if (!mounted) return;

        if (_index != _homeTabIndex) {
          setState(() => _index = _homeTabIndex);
          return;
        }
        SystemNavigator.pop();
      },
      child: TabSwitcher(
        switchTo: (i) {
          if (i < 0 || i > 4 || i == _index) return;
          setState(() => _index = i);
        },
        child: Scaffold(
          body: IndexedStack(
            index: _index,
            children: List.generate(
              5,
              (i) => Navigator(
                key: _navKeys[i],
                onGenerateRoute: (_) => MaterialPageRoute(
                  builder: (_) => _screenForTab(i),
                ),
              ),
            ),
          ),
          bottomNavigationBar: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const MiniPlayer(),
              AppBottomNav(currentIndex: _index, onTap: _onTabTapped),
            ],
          ),
        ),
      ),
    );
  }
}