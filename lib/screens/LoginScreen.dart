import 'package:flutter/material.dart';
import 'package:secret_forest_flutter/layout/default_layout.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const DefaultLayout(
      body: Center(
        child: Text('Login Screen'),
      ),
    );
  }
}
