import '../enums/exercise_type.dart';
import 'exercise_detail_response.dart';

class ExerciseDailyResponse {
  final int id;
  final int totalQuestions;
  final int correctAnswers;
  final ExerciseType exerciseType;
  final DateTime date;
  final String? analytics;
  final List<ExerciseDetailResponse>? details;

  ExerciseDailyResponse({
    required this.id,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.exerciseType,
    required this.date,
    this.analytics,
    this.details,
  });

  factory ExerciseDailyResponse.fromJson(Map<String, dynamic> json) {
    List<ExerciseDetailResponse>? detailsList;
    if (json['details'] != null) {
      detailsList = (json['details'] as List)
          .map((i) => ExerciseDetailResponse.fromJson(i))
          .toList();
    }

    return ExerciseDailyResponse(
      id: json['id'] as int,
      totalQuestions: json['totalQuestions'] as int,
      correctAnswers: json['correctAnswers'] as int,
      exerciseType: exerciseTypeFromString(json['exerciseType']),
      date: DateTime.parse(json['date'] as String),
      analytics: json['analytics'] as String?,
      details: detailsList,
    );
  }
}