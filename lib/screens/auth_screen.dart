import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:secret_forest_flutter/models/auth.dart';
import 'package:secret_forest_flutter/riverpod/auth_store.dart';

class AuthScreen extends ConsumerWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Auth authState = ref.watch(authProvider);
    return Scaffold(
      body: Center(
        child: Text(authState.email),
      ),
    );
  }
}
