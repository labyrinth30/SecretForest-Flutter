import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:secret_forest_flutter/riverpod/auth_store.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final authState = ref.watch(authProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('비밀의숲 ${authState.email}'),
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text('login'),
          onPressed: () => context.pushReplacement('/login'),
        ),
      ),
    );
  }
}
