import 'dart:convert';
import 'dart:developer';
import 'package:flutter/services.dart';

import '../models/api_response.dart';
import '../models/dictionary/dict_personal_dto.dart';
import '../models/learning/update_progress_request.dart';
import 'api_client.dart';

class LearningService {
  final ApiClient _apiClient;

  LearningService(this._apiClient);

  Future<ApiResponse<List<DictPersonalDTO>>> getDailyLesson() async {
    log("Đang gọi getDailyLesson (ĐÃ MOCK)", name: "LearningService");
    try {
      final String jsonString =
          await rootBundle.loadString('lib/mock_data/lesson_daily.json');
      final Map<String, dynamic> jsonMap = jsonDecode(jsonString);

      return ApiResponse.fromJson(
        jsonMap,
        (jsonData) => (jsonData as List)
            .map((item) => DictPersonalDTO.fromJson(item as Map<String, dynamic>))
            .toList(),
      );
    } catch (e) {
      log("Lỗi khi đọc file mock trong LearningService", error: e);
      return ApiResponse(
        success: false,
        message: "Lỗi đọc file mock: ${e.toString()}",
        data: null,
      );
    }
  }

  Future<ApiResponse<void>> updateProgress(
      UpdateProgressRequest request) async {
    final response = await _apiClient.post(
      '/lesson/progress',
      data: request.toJson(),
    );

    return ApiResponse.fromJson(response.data, (_) => {});
  }
}