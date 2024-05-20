import 'dart:convert'; // json decoding을 위해 필요합니다.
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:secret_forest_flutter/layout/default_layout.dart';
import 'package:secret_forest_flutter/models/themes.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart'; // http 라이브러리를 사용하기 위한 import 문

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  Future<List<Themes>> getThemes() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken') ?? '';
    final dio = Dio(); // Dio 인스턴스를 생성합니다.
    final response = await dio.get(
      'http://localhost:3000/themes',
      options: Options(
        headers: {
          "Authorization": "Bearer $accessToken",
        },
      ),
    );
    if (response.statusCode == 200) {
      final List<dynamic> responseData = response.data;
      final List<Themes> themes =
          responseData.map<Themes>((theme) => Themes.fromJson(theme)).toList();
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
        child: FutureBuilder<List<Themes>>(
          future: getThemes(),
          builder:
              (BuildContext context, AsyncSnapshot<List<Themes>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error loading themes: ${snapshot.error}');
            } else {
              final themes = snapshot.data!;
              return ListView.builder(
                itemCount: themes.length,
                itemBuilder: (context, index) {
                  final theme = themes[index];
                  return Text('Theme: ${theme.title}');
                },
              );
            }
          },
        ),
      ),
    );
  }
}
