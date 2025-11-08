import '../models/api_response.dart';
import '../models/exercise/exercise_daily_response.dart';
import '../models/exercise/generate_exercise_request.dart';
import '../models/exercise/grading_request.dart';
import '../models/exercise/grading_response.dart';
import 'api_client.dart';

class ExerciseService {
  final ApiClient _apiClient;

  ExerciseService(this._apiClient);

  Future<ApiResponse<ExerciseDailyResponse>> generateExercise(
      GenerateExerciseRequest request) async {
    final response = await _apiClient.post(
      '/exercise/generate',
      data: request.toJson(),
    );

    return ApiResponse.fromJson(
      response.data,
      (json) => ExerciseDailyResponse.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<GradingResponse>> gradeExercise(
      GradingRequest request) async {
    final response = await _apiClient.post(
      '/exercise/grade',
      data: request.toJson(),
    );

    return ApiResponse.fromJson(
      response.data,
      (json) => GradingResponse.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<List<ExerciseDailyResponse>>> getResultsByDate(
      DateTime date) async {
    final response = await _apiClient.get(
      '/exercise/results',
      queryParams: {
        'date': date.toIso8601String().split('T').first,
      },
    );

    return ApiResponse.fromJson(
      response.data,
      (json) => (json as List)
          .map((item) =>
              ExerciseDailyResponse.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}