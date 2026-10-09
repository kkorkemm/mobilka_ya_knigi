import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/root_screen.dart';
import 'state/app_state.dart';
import 'theme/app_theme.dart';

class YandexBooksApp extends StatelessWidget {
  const YandexBooksApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppState(),
      // Consumer нужен, чтобы MaterialApp перестраивался при
      // изменении themeMode в AppState.
      child: Consumer<AppState>(
        builder: (context, state, _) {
          return MaterialApp(
            title: 'Яндекс Книги',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light(),
            darkTheme: AppTheme.dark(),
            themeMode: state.themeMode,
            home: const RootScreen(),
          );
        },
      ),
    );
  }
}