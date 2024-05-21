import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:secret_forest_flutter/layout/default_layout.dart';
import 'package:secret_forest_flutter/models/themes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeScreen extends ConsumerWidget {
  const ThemeScreen({super.key});

  Future<Themes> getOneTheme(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken') ?? '';
    final dio = Dio();
    final response = await dio.get(
      'http://localhost:3000/themes/${GoRouterState.of(context).pathParameters['id']}',
      options: Options(
        headers: {
          "Authorization": "Bearer $accessToken",
        },
      ),
    );
    if (response.statusCode == 200) {
      final Themes responseData = response.data;
      final Themes themes = responseData;
      return themes;
    } else {
      throw Exception('Failed to load themes');
    }
  }

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    return DefaultLayout(
      body: Center(
        child: FutureBuilder<Themes>(
          future: getOneTheme(
            context,
          ),
          builder: (BuildContext context, AsyncSnapshot<Themes> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
              // context.pushReplacement('/');
              return const Text('Error');
            } else {
              final themes = snapshot.data!;
              return Text(themes.title);
            }
          },
        ),
      ),
    );
  }
}
