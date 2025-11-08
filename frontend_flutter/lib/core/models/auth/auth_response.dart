class AuthResponse {
  final bool authenticated;
  final String token;

  AuthResponse({required this.authenticated, required this.token});

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      authenticated: json['authenticated'] as bool,
      token: json['token'] as String,
    );
  }
}