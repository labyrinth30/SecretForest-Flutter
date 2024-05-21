import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:secret_forest_flutter/layout/default_layout.dart';
import 'package:secret_forest_flutter/models/themes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeScreen extends ConsumerWidget {
  final String themeId;

  const ThemeScreen({
    super.key,
    required this.themeId,
  });

  Future<Themes> getOneTheme(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken') ?? '';
    final dio = Dio();
    final response = await dio.get(
      'http://localhost:3000/themes/$themeId',
      options: Options(
        headers: {
          "Authorization": "Bearer $accessToken",
        },
      ),
    );
    if (response.statusCode == 200) {
      final responseData = response.data;
      final themes = Themes.fromJson(responseData);
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
              return ListView(
                children: [
                  Text('Title: ${themes.title}'),
                  Text('Description: ${themes.description}'),
                  Text('난이도: ${themes.difficulty}'),
                  Text('공포도: ${themes.fear}'),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
