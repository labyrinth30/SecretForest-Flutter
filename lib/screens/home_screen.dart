import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Secret Forest'),
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
