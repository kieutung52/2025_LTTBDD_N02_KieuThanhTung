import '../enums/role_account.dart';

class RegisterResponse {
  final bool registered;
  final String email;
  final String fullName;
  final RoleAccount role;

  RegisterResponse({
    required this.registered,
    required this.email,
    required this.fullName,
    required this.role,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      registered: json['registered'] as bool,
      email: json['email'] as String,
      fullName: json['fullName'] as String,
      role: RoleAccount.values.firstWhere(
        (e) => e.name == (json['role'] as String?)?.toLowerCase(),
        orElse: () => RoleAccount.user,
      ),
    );
  }
}