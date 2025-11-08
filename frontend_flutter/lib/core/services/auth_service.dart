import 'dart:developer';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/api_response.dart';
import '../models/auth/auth_request.dart';
import '../models/auth/auth_response.dart';
import '../models/auth/register_request.dart';
import '../models/auth/register_response.dart';
import 'api_client.dart';

class AuthService {
  final ApiClient _apiClient;
  final FlutterSecureStorage _storage; 

  AuthService(this._apiClient, this._storage);

  Future<ApiResponse<AuthResponse>> login(AuthRequest request) async {
    final response = await _apiClient.post(
      '/login',
      data: request.toJson(),
    );

    final apiResponse = ApiResponse.fromJson(
      response.data,
      (json) => AuthResponse.fromJson(json as Map<String, dynamic>),
    );
    
    if(apiResponse.success && apiResponse.data != null) {
        await _storage.write(key: 'jwt_token', value: apiResponse.data!.token);
        log('Đã lưu token với key "jwt_token": ${apiResponse.data!.token}');
    }
    
    return apiResponse;
  }

  Future<ApiResponse<RegisterResponse>> register(RegisterRequest request) async {
    final response = await _apiClient.post(
      '/register',
      data: request.toJson(),
    );

    return ApiResponse.fromJson(
      response.data,
      (json) => RegisterResponse.fromJson(json as Map<String, dynamic>),
    );
  }
  
  Future<void> logout() async {
      await _storage.delete(key: 'jwt_token');
  }
}