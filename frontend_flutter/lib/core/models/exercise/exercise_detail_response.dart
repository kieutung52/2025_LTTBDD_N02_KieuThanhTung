class ExerciseDetailResponse {
  final int id;
  final String question;
  final String questionType;
  final List<String> options;
  final String trueAnswer;
  final String? userAnswer;
  final bool isCorrect;
  final String? aiExplain;

  ExerciseDetailResponse({
    required this.id,
    required this.question,
    required this.questionType,
    required this.options,
    required this.trueAnswer,
    this.userAnswer,
    required this.isCorrect,
    this.aiExplain,
  });

  factory ExerciseDetailResponse.fromJson(Map<String, dynamic> json) {
    List<String> parsedOptions = [];
    if (json['options'] != null) {
       parsedOptions = List<String>.from(json['options']);
    }

    return ExerciseDetailResponse(
      id: json['id'] as int,
      question: json['question'] as String,
      questionType: json['questionType'] as String,
      options: parsedOptions,
      trueAnswer: json['trueAnswer'] as String,
      userAnswer: json['userAnswer'] as String?,
      isCorrect: json['correct'] as bool,
      aiExplain: json['aiExplain'] as String?,
    );
  }
}