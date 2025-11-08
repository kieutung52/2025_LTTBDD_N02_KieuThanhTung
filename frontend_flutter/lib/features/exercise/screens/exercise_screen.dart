import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/models/exercise/generate_exercise_request.dart';
import '../../../core/services/exercise_service.dart';

class ExerciseScreen extends StatelessWidget {
  const ExerciseScreen({super.key});

  Future<void> _testGenerate(BuildContext context) async {
    final service = Provider.of<ExerciseService>(context, listen: false);
    log("--- Test API: POST /exercise/generate ---");
    try {
      final requestBody = GenerateExerciseRequest(dictionaryIds: [1, 2, 3, 4, 5]);
      log("Gửi Request: ${requestBody.toJson()}");
      final response = await service.generateExercise(requestBody);
      if (response.success) {
        log("[SUCCESS] Tạo bài tập (số câu): ${response.data?.details?.length}");
      } else {
        log("[FAILURE] ${response.message}");
      }
    } catch (e) {
      log("[ERROR]", error: e);
    }
  }
  
  Future<void> _testGrade(BuildContext context) async {
    log("--- Test API: POST /exercise/grade (chưa implement) ---");
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ElevatedButton(
          onPressed: () => _testGenerate(context),
          child: const Text("Test API: POST /exercise/generate"),
        ),
        ElevatedButton(
          onPressed: () => _testGrade(context),
          child: const Text("Test API: POST /exercise/grade"),
        ),
      ],
    );
  }
}