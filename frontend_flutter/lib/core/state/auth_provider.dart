import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/auth/auth_request.dart';
import '../models/auth/register_request.dart';
import '../models/user/user_response.dart';
import '../services/auth_service.dart';
import '../services/user_service.dart';
import 'learning_provider.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

bool _isSameDay(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
}

class AuthProvider extends ChangeNotifier {
  final AuthService _authService;
  final UserService _userService;
  final FlutterSecureStorage _storage;
  LearningProvider? learningProvider;

  AuthStatus _status = AuthStatus.unknown;
  AuthStatus get status => _status;

  UserResponse? _user;
  UserResponse? get user => _user;

  UserResponse get authenticatedUser => _user!;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  AuthProvider(
    this._authService,
    this._userService,
    this._storage,
    this.learningProvider,
  ) {
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    final token = await _storage.read(key: 'jwt_token');
    if (token == null) {
      _status = AuthStatus.unauthenticated;
    } else {
      try {
        await fetchUserProfile();
        if (learningProvider != null) {
          await learningProvider!.loadDailyLesson();
        }
      } catch (e) {
        log("Token hỏng, đăng xuất...", error: e, name: "AuthProvider");
        _status = AuthStatus.unauthenticated;
        await _storage.delete(key: 'jwt_token');
      }
    }
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _setLoading(true);
    try {
      final request = AuthRequest(email: email, password: password);
      final response = await _authService.login(request);

      if (response.success) {
        await fetchUserProfile();
        if (learningProvider != null) {
          await learningProvider!.loadDailyLesson();
        }
        _setLoading(false);
        return true;
      } else {
        throw Exception(response.message ?? "Login failed");
      }
    } catch (e) {
      _setLoading(false);
      rethrow;
    }
  }

  Future<bool> register(String email, String password, String fullName) async {
    _setLoading(true);
    try {
      final request = RegisterRequest(
          email: email, password: password, fullName: fullName);
      final response = await _authService.register(request);

      if (response.success) {
        _setLoading(false);
        return true;
      } else {
        throw Exception(response.message ?? "Register failed");
      }
    } catch (e) {
      _setLoading(false);
      rethrow;
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    if (learningProvider != null) {
      await learningProvider!.clearCache();
    }
    _user = null;
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }

  Future<void> fetchUserProfile() async {
    final response = await _userService.getMyProfile();
    if (response.success && response.data != null) {
      _user = response.data;
      _status = AuthStatus.authenticated;

      notifyListeners();

    } else {
      throw Exception(response.message ?? "Failed to fetch user profile");
    }
  }

  Future<void> optimisticallyUpdateStreak() async {
    if (_user == null) return;

    final today = _user!.currentDate;
    final lastActive = _user!.lastStreakActiveDate;

    if (_isSameDay(lastActive, today)) {
      log("Streak đã được cập nhật hôm nay rồi.", name: "AuthProvider");
      return;
    }

    log("Optimistically updating streak...", name: "AuthProvider");
    
    _user = _user!.copyWith(
      streak: _user!.streak + 1,
      lastStreakActiveDate: today,
    );
    notifyListeners(); 

    try {
      final response = await _userService.updateStreak();
      if (response.success) {
        log("Streak đã đồng bộ với backend: ${response.data}", name: "AuthProvider");
      } else {
        throw Exception(response.message);
      }
    } catch (e) {
      log("Lỗi khi đồng bộ streak, nhưng UI đã cập nhật.", error: e, name: "AuthProvider");
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}