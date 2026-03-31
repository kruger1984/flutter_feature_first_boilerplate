import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/auth/home_screen.dart';
import '../../features/auth/login_screen.dart';
import '../../features/auth/providers/auth_provider.dart';
import '../../features/payment/payment_screen.dart';
import '../../features/payment/thanks_screen.dart';

part 'router_pod.g.dart';

@riverpod
GoRouter router(Ref ref) {
  // Стежимо за станом авторизації.
  // Коли authProvider змінить стан (data/error/loading), цей провайдер перествориться
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    // Допомагає бачити переходи в консолі (через Talker)

    // Головна логіка редіректів (заміна AuthGate)
    redirect: (context, state) {
      // Отримуємо поточну сесію (якщо вона є)
      final session = authState.asData?.value;

      // Перевіряємо, чи ми зараз на екрані логіну
      final isLoggingIn = state.matchedLocation == '/login';

      // 1. Якщо даних ще немає (завантаження), нікуди не перенаправляємо
      if (authState.isLoading) return null;

      // 2. Якщо користувач НЕ авторизований
      if (session == null) {
        // Якщо він не на логіні — відправляємо на логін
        return isLoggingIn ? null : '/login';
      }

      // 3. Якщо користувач авторизований, але намагається зайти на /login
      if (isLoggingIn) {
        return '/'; // Відправляємо на головну
      }

      // В усіх інших випадках залишаємось там, де є
      return null;
    },

    routes: [
      // Екран логіну
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),

      // Головний екран (Home)
      GoRoute(
        path: '/',
        builder: (context, state) {
          // Оскільки редірект гарантує, що тут session != null,
          // ми можемо безпечно взяти значення
          final session = authState.asData!.value!;
          return AuthHomeScreen(session: session);
        },
      ),

      /* Тут ти будеш додавати нові маршрути для фіч, наприклад:
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      */
      GoRoute(path: '/payment', builder: (context, state) => const PaymentScreen()),

      GoRoute(
        path: '/payment/thanks',
        builder: (context, state) {
          final message = state.extra as String? ?? 'Дякуємо за покупку!';
          return ThanksScreen(message: message);
        },
      ),
    ],

    // Обробка помилок навігації (якщо ввели неправильний URL)
    errorBuilder: (context, state) => Scaffold(body: Center(child: Text('Сторінку не знайдено: ${state.error}'))),
  );
}
