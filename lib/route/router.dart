import 'package:go_router/go_router.dart';
import 'package:secret_forest_flutter/screens/HomeScreen.dart';
import 'package:secret_forest_flutter/screens/LoginScreen.dart';

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
