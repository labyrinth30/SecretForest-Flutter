import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:secret_forest_flutter/layout/default_layout.dart';
import 'package:secret_forest_flutter/models/auth.dart';
import 'package:secret_forest_flutter/riverpod/auth_store.dart';

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final Auth authState = ref.watch(authProvider);
    return DefaultLayout(
      body: Center(
        child: Text('Welcome ${authState.email}'),
      ),
    );
  }
}
