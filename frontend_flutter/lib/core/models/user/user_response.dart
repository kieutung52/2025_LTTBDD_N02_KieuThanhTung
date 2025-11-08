import '../enums/role_account.dart';

class UserResponse {
  final String id;
  final String email;
  final String fullName;
  final RoleAccount role;
  final int streak;
  final DateTime lastStreakActiveDate;
  final DateTime currentDate;

  UserResponse({
    required this.id,
    required this.email,
    required this.fullName,
    required this.role,
    required this.streak,
    required this.lastStreakActiveDate,
    required this.currentDate
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      id: json['id'] as String,
      email: json['email'] as String,
      fullName: json['fullName'] as String,
      role: RoleAccount.values.firstWhere(
            (e) => e.name == (json['role'] as String?)?.toLowerCase(),
            orElse: () => RoleAccount.user,
          ),
      streak: json['streak'] as int,
      lastStreakActiveDate: json['lastStreakActiveDate'] != null 
        ? DateTime.parse(json['lastStreakActiveDate'] as String)
        : DateTime.now().subtract(const Duration(days: 1)),
      currentDate: DateTime.parse(json['currentDate'] as String),
    );
  }
  UserResponse copyWith({
    String? id,
    String? email,
    String? fullName,
    RoleAccount? role,
    int? streak,
    DateTime? lastStreakActiveDate,
    DateTime? currentDate,
  }) {
    return UserResponse(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      role: role ?? this.role,
      streak: streak ?? this.streak,
      lastStreakActiveDate: lastStreakActiveDate ?? this.lastStreakActiveDate,
      currentDate: currentDate ?? this.currentDate,
    );
  }
}