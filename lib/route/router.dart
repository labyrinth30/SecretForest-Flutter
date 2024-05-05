import 'package:go_router/go_router.dart';
import 'package:secret_forest_flutter/screens/home_screen.dart';
import 'package:secret_forest_flutter/screens/login_screen.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
      routes: [
        GoRoute(
          path: 'login',
          builder: (context, state) => const LoginScreen(),
        )
      ],
    ),
  ],
);
