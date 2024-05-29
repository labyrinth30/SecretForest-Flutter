import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:secret_forest_flutter/components/edit_theme_dialog.dart';
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

  Future<Themes> updateTheme(String title, String description, int fear,
      int difficulty, List<String> timetable, BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken') ?? '';
    final dio = Dio();
    final response = await dio.patch(
      'http://localhost:3000/themes/$themeId',
      options: Options(
        headers: {
          "Authorization": "Bearer $accessToken",
        },
      ),
      data: {
        'title': title,
        'description': description,
        'fear': fear,
        'difficulty': difficulty,
        'timetable': timetable,
      },
    );
    if (response.statusCode == 200) {
      final responseData = response.data;
      final themes = Themes.fromJson(responseData);
      return themes;
    } else {
      throw Exception('Failed to update theme');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultLayout(
      body: Center(
        child: FutureBuilder<Themes>(
          future: getOneTheme(context),
          builder: (BuildContext context, AsyncSnapshot<Themes> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              final themes = snapshot.data!;
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Title: ${themes.title}'),
                    Text('Description: ${themes.description}'),
                    Text('난이도: ${themes.difficulty}'),
                    Text('공포도: ${themes.fear}'),
                    const Gap(8),
                    const Text('시간표:'),
                    const SizedBox(height: 8),
                    // 중앙 정렬을 위해 Column으로 변경
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: themes.timetable.map((time) {
                        return Center(
                          child: ListTile(
                            title: Text(time, textAlign: TextAlign.center),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => EditThemeDialog(
                            initialTitle: themes.title,
                            initialDescription: themes.description,
                            initialFear: themes.fear,
                            initialDifficulty: themes.difficulty,
                            initialTimetable: themes.timetable ?? [],
                            onSave: (title, description, fear, difficulty,
                                timetable) async {
                              try {
                                final updatedTheme = await updateTheme(
                                    title,
                                    description,
                                    fear,
                                    difficulty,
                                    timetable,
                                    context);
                                Navigator.pop(context); // Close the dialog
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'Theme updated successfully!')));
                              } on Exception catch (error) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content:
                                        Text('Error updating theme: $error'),
                                  ),
                                );
                              }
                            },
                          ),
                        );
                      },
                      child: const Text('수정'),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
