import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/models/learning/update_progress_request.dart';
import '../../../core/models/learning/word_progress_dto.dart';
import '../../../core/services/learning_service.dart';
import '../../../core/state/auth_provider.dart';

class DailyLessonScreen extends StatelessWidget {
  const DailyLessonScreen({super.key});

  Future<void> _testGetLesson(BuildContext context) async {
    final service = Provider.of<LearningService>(context, listen: false);
    log("--- Test API: GET /lesson/daily ---");
    try {
      final response = await service.getDailyLesson();
      if (response.success) {
        log("[SUCCESS] Dữ liệu trả về (số lượng): ${response.data?.length} từ");
      } else {
        log("[FAILURE] ${response.message}");
      }
    } catch (e) {
      log("[ERROR]", error: e);
    }
  }

  Future<void> _testUpdateProgress(BuildContext context) async {
    final service = Provider.of<LearningService>(context, listen: false);
    log("--- Test API: POST /lesson/progress ---");
    try {
      final requestBody = UpdateProgressRequest(
        progressList: [
          WordProgressDTO(dictionaryPersonalId: 1, wasCorrect: true),
          WordProgressDTO(dictionaryPersonalId: 2, wasCorrect: false),
        ],
      );

      log("Gửi Request: ${requestBody.toJson()}");
      final response = await service.updateProgress(requestBody);

      if (response.success) {
        log("[SUCCESS] Cập nhật tiến độ thành công.");
      } else {
        log("[FAILURE] ${response.message}");
      }
    } catch (e) {
      log("[ERROR]", error: e);
    }
  }

  void _logout(BuildContext context) {
    Provider.of<AuthProvider>(context, listen: false).logout();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text("API Tests (Learning):"),
        ElevatedButton(
          onPressed: () => _testGetLesson(context),
          child: const Text("Test API: GET /lesson/daily (ĐÃ MOCK)"),
        ),
        ElevatedButton(
          onPressed: () => _testUpdateProgress(context),
          child: const Text("Test API: POST /lesson/progress"),
        ),
        const Divider(height: 30),
        const Text("Điều hướng:"),
        ElevatedButton(
          onPressed: () => context.go('/profile'),
          child: const Text("Chuyển đến /profile"),
        ),
        ElevatedButton(
          onPressed: () => context.go('/exercise'),
          child: const Text("Chuyển đến /exercise"),
        ),
        ElevatedButton(
          onPressed: () => context.go('/search'),
          child: const Text("Chuyển đến /search"),
        ),
         ElevatedButton(
          onPressed: () => _logout(context),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red[100]),
          child: const Text("Đăng xuất"),
        ),
      ],
    );
  }
}