import '../models/api_response.dart';
import 'api_client.dart';

class SeedingService {
  final ApiClient _apiClient;

  SeedingService(this._apiClient);

  Future<ApiResponse<String>> addWord(String word) async {
    final response = await _apiClient.post(
      '/seeding/add-word',
      data: {'newWord': word},
    );
    return ApiResponse.fromJson(
      response.data,
      (json) => json as String,
    );
  }

  Future<ApiResponse<void>> runSeeding() async {
    final response = await _apiClient.post('/seeding/run');
    return ApiResponse.fromJson(response.data, (_) => {});
  }
}