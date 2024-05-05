import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:secret_forest_flutter/models/auth.dart';

final authProvider = StateNotifierProvider<AuthNotifier, Auth>((ref) {
  return AuthNotifier();
});

class AuthNotifier extends StateNotifier<Auth> {
  AuthNotifier()
      : super(
          Auth(
            email: '',
            id: 0,
            accessToken: '',
          ),
        );
  void updateUser({
    String? email,
    int? id,
    String? accessToken,
  }) {
    state = state.copyWith(
      email: email,
      id: id,
      accessToken: accessToken,
    );
  }
}
