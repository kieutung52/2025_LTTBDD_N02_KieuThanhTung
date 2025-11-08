import '../models/api_response.dart';
import '../models/dictionary/search_word_response.dart';
import 'api_client.dart';

class DictionaryService {
  final ApiClient _apiClient;

  DictionaryService(this._apiClient);

  Future<ApiResponse<SearchWordResponse>> searchWord(String word) async {
    final response = await _apiClient.get(
      '/dictionary/search',
      queryParams: {'word': word},
    );

    return ApiResponse.fromJson(
      response.data,
      (json) => SearchWordResponse.fromJson(json as Map<String, dynamic>),
    );
  }
}