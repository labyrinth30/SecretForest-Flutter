import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
      int difficulty, BuildContext context) async {
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
              return Column(
                children: [
                  Text('Title: ${themes.title}'),
                  Text('Description: ${themes.description}'),
                  Text('난이도: ${themes.difficulty}'),
                  Text('공포도: ${themes.fear}'),
                  ElevatedButton(
                    onPressed: () {
                      // Open a dialog for editing theme details
                      showDialog(
                        context: context,
                        builder: (context) => EditThemeDialog(
                          initialTitle: themes.title,
                          initialDescription: themes.description,
                          initialFear: themes.fear,
                          initialDifficulty: themes.difficulty,
                          onSave: (title, description, fear, difficulty) async {
                            try {
                              final updatedTheme = await updateTheme(title,
                                  description, fear, difficulty, context);
                              // Update UI with the updated theme details (optional)
                              // Navigator.pop(context); // Close the dialog
                              // ScaffoldMessenger.of(context)
                              //   .showSnackBar(SnackBar(content: Text('Theme updated successfully!')));
                            } on Exception catch (error) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          'Error updating theme: $error')));
                            }
                          },
                        ),
                      );
                    },
                    child: const Text('수정'),
                  ),
                  // Rest of your ListView content...
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
