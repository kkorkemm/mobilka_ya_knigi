import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/app_state.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final theme = Theme.of(context);
    final secondary = theme.textTheme.bodySmall?.color;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            // ---------- Заголовок ----------
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Text(
                'Профиль',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.6,
                ),
              ),
            ),

            // ---------- Шапка профиля ----------
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
              child: Row(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Color(0xFF5B6BF0), Color(0xFF9A4FE0)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: const Icon(Icons.person,
                        size: 34, color: Colors.white),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Пользователь',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Подписка Плюс активна',
                          style:
                              TextStyle(fontSize: 13, color: secondary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const Divider(height: 1),

            // ---------- ОТЛАДКА: имитация отсутствия сети ----------
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 4),
              child: Text(
                'Для отладки',
                style:
                    TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),
            ),
            SwitchListTile(
              value: state.simulateNetworkError,
              onChanged: (v) =>
                  context.read<AppState>().setSimulateNetworkError(v),
              title: const Text('Имитировать отсутствие сети'),
              subtitle: const Text(
                'Проверка состояния «Нет интернета»',
                style: TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}