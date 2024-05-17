import 'package:go_router/go_router.dart';
import 'package:secret_forest_flutter/screens/auth_screen.dart';
import 'package:secret_forest_flutter/screens/home_screen.dart';
import 'package:secret_forest_flutter/screens/login_screen.dart';
import 'package:secret_forest_flutter/screens/main_screen.dart';

final router = GoRouter(
  errorBuilder: (context, state) => const HomeScreen(),
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const LoginScreen(),
      routes: [
        GoRoute(
          path: 'main',
          builder: (context, state) => const MainScreen(),
        ),
        GoRoute(
          path: 'auth',
          builder: (context, state) => const AuthScreen(),
        ),
      ],
    ),
  ],
);
