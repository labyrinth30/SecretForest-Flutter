import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:secret_forest_flutter/riverpod/auth_store.dart';
import 'package:secret_forest_flutter/services/auth_service.dart';
import 'dart:html';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  Future<void> checkAuth(
    WidgetRef ref,
    BuildContext context,
    Dio dio,
  ) async {
    final authState = ref.read(authProvider);
    try {
      final response = await AuthService.checkUserIsLogin(dio);
      print(response);
      if (response == true) {
        context.go('/main');
      }
      context.go('/login');
    } on Exception catch (e) {
      ref.read(authProvider.notifier).updateUser(
            accessToken: '',
            email: '',
            id: 0,
          );
      context.go('/login');
    }
  }

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final authState = ref.watch(authProvider);
    final dio = Dio();
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final clientId = dotenv.env['githubClientId'];
          final redirectUrl = dotenv.env['githubRedirectUrl'];
          final url =
              'https://github.com/login/oauth/authorize?client_id=$clientId&redirect_uri=$redirectUrl';
        },
      ),
      appBar: AppBar(
        title: Text('비밀의숲 ${authState.email}'),
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text('login'),
          onPressed: () async {
            await checkAuth(
              ref,
              context,
              dio,
            );
          },
        ),
      ),
    );
  }
}
