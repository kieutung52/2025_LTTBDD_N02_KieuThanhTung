class GradingResponse {
  final int exerciseDailyId;
  final int totalQuestions;
  final int correctAnswers;
  final double score;
  final List<QuestionResult> results;

  GradingResponse({
    required this.exerciseDailyId,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.score,
    required this.results,
  });

  factory GradingResponse.fromJson(Map<String, dynamic> json) {
    var resultsList = json['results'] as List;
    List<QuestionResult> results =
        resultsList.map((i) => QuestionResult.fromJson(i)).toList();

    return GradingResponse(
      exerciseDailyId: json['exerciseDailyId'] as int,
      totalQuestions: json['totalQuestions'] as int,
      correctAnswers: json['correctAnswers'] as int,
      score: json['score'] as double,
      results: results,
    );
  }
}

class QuestionResult {
  final int questionId;
  final String question;
  final String userAnswer;
  final String correctAnswer;
  final bool isCorrect;
  final String explanation;
  final String questionType;
  final List<String> options;

  QuestionResult({
    required this.questionId,
    required this.question,
    required this.userAnswer,
    required this.correctAnswer,
    required this.isCorrect,
    required this.explanation,
    required this.questionType,
    required this.options,
  });

  factory QuestionResult.fromJson(Map<String, dynamic> json) {
    return QuestionResult(
      questionId: json['questionId'] as int,
      question: json['question'] as String,
      userAnswer: json['userAnswer'] as String,
      correctAnswer: json['correctAnswer'] as String,
      isCorrect: json['correct'] as bool,
      explanation: json['explanation'] as String,
      questionType: json['questionType'] as String,
      options: List<String>.from(json['options'] ?? []),
    );
  }
}