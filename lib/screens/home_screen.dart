import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:secret_forest_flutter/common/custom_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Secret Forest'),
      ),
      body: Center(
        child: CustomButton(
          text: 'login',
          onPressed: () => context.go('/login'),
        ),
      ),
    );
  }
}
