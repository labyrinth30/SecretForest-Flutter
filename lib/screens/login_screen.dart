import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:secret_forest_flutter/components/my_button.dart';
import 'package:secret_forest_flutter/components/my_textfield.dart';
import 'package:secret_forest_flutter/riverpod/auth_store.dart';
import 'package:secret_forest_flutter/services/auth_service.dart';
import 'package:gap/gap.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({
    super.key,
  });

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // sign user in
  void signUserIn(
    Dio dio,
    WidgetRef ref,
  ) async {
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    try {
      final response = await AuthService.signIn(
        emailController.text.trim(),
        passwordController.text.trim(),
        dio,
      );
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('accessToken', response.data['accessToken']);
      context.pop(context);
      context.go('/main');
    } on Exception catch (_) {
      context.pop(context);
      showErrorMessage("Wrong Email or Password");
    }
  }

  // wrong login message
  void showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.deepPurple,
          title: Text(
            message,
            style: const TextStyle(color: Colors.white),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final dio = Dio();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[300],
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Gap(50),
                // logo
                const Image(
                  image: AssetImage(
                    'assets/logo.jpg',
                  ),
                  width: 200,
                  height: 200,
                ),
                const Gap(50),
                Text(
                  "비밀의숲 관리자 페이지입니다.",
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontSize: 20,
                  ),
                ),
                const Gap(25),
                // email textfield
                MyTextField(
                  controller: emailController,
                  hintText: 'Username',
                  obscureText: false,
                ),
                const Gap(10),
                // password textfield
                MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),
                const Gap(25),
                // sign in button
                MyButton(
                  text: "Sign In",
                  // login button
                  onTap: () {
                    signUserIn(
                      dio,
                      ref,
                    );
                  },
                ),
                const Gap(50),
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
                const Gap(50),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
