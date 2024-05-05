class Auth {
  String email;
  String accessToken;
  int id;

  Auth({
    required this.email,
    required this.accessToken,
    required this.id,
  });

  Auth copyWith({
    String? email,
    int? id,
    String? accessToken,
  }) {
    return Auth(
      email: email ?? this.email,
      id: id ?? this.id,
      accessToken: accessToken ?? this.accessToken,
    );
  }
}
