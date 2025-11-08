import 'dart:developer';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/dictionary/dict_personal_dto.dart';

class LearningProvider extends ChangeNotifier {
  List<DictPersonalDTO>? _dailyLesson;
  List<DictPersonalDTO>? get dailyLesson => _dailyLesson;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  LearningProvider();

  Future<void> loadDailyLesson() async {
    _isLoading = true;
    notifyListeners();

    try {
      log("Nạp bài học từ MOCK DATA...", name: "LearningProvider");
      await _fetchFromMockData();
    } catch (e) {
      log("Lỗi khi load bài học từ MOCK", error: e, name: "LearningProvider");
      _dailyLesson = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _fetchFromMockData() async {
    try {
      final String jsonString =
          await rootBundle.loadString('lib/mock_data/lesson_daily.json');
      final Map<String, dynamic> jsonMap = jsonDecode(jsonString);

      if (jsonMap['success'] == true && jsonMap['data'] != null) {
        final List<dynamic> dataList = jsonMap['data'];

        _dailyLesson = dataList.map((item) {
          return DictPersonalDTO.fromJson(item as Map<String, dynamic>);
        }).toList();

        log("Đã nạp ${_dailyLesson?.length} từ vựng từ file mock",
            name: "LearningProvider");
      } else {
        throw Exception("Cấu trúc file mock JSON không hợp lệ hoặc success=false");
      }
    } catch (e) {
      log("Lỗi nghiêm trọng khi đọc file mock:",
          error: e, name: "LearningProvider");
      _dailyLesson = [];
    }
  }

  Future<void> clearCache() async {
    _dailyLesson = null;
    notifyListeners();
    log("Đã xóa cache bài học.", name: "LearningProvider");
  }
}