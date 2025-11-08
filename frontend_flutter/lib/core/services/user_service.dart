import '../models/api_response.dart';
import '../models/user/user_response.dart';
import 'api_client.dart';

class UserService {
  final ApiClient _apiClient;

  UserService(this._apiClient);

  Future<ApiResponse<UserResponse>> getMyProfile() async {
    final response = await _apiClient.get('/user/me');

    return ApiResponse.fromJson(
      response.data,
      (json) => UserResponse.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<UserResponse>> updateProfile(String fullName) async {
    final response = await _apiClient.put(
      '/user/profile',
      data: {'fullName': fullName},
    );

    return ApiResponse.fromJson(
      response.data,
      (json) => UserResponse.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<String>> updateStreak() async {
    final response = await _apiClient.post('/user/update-streak');

    return ApiResponse.fromJson(
      response.data,
      (json) => json as String,
    );
  }
}