import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:secret_forest_flutter/layout/default_layout.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    return DefaultLayout(
      body: Center(
        child: FutureBuilder<SharedPreferences>(
          future: SharedPreferences.getInstance(),
          builder: (BuildContext context,
              AsyncSnapshot<SharedPreferences> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return const Text('Error loading preferences');
            } else {
              final prefs = snapshot.data;
              final accessToken =
                  prefs?.getString('accessToken') ?? 'No access token found';
              return Text('Welcome, your access token is: $accessToken');
            }
          },
        ),
      ),
    );
  }
}
