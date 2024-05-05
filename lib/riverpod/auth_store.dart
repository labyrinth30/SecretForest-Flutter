import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:secret_forest_flutter/utils/auth.dart';

final authProvider = StateNotifierProvider<AuthNotifier, Auth>((ref) {
  return AuthNotifier();
});

class AuthNotifier extends StateNotifier<Auth> {
  AuthNotifier()
      : super(
          Auth(),
        );
}
