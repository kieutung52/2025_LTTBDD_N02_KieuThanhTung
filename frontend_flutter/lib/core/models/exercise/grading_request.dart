class GradingRequest {
  final int exerciseDailyId;
  final List<QuestionAnswer> answers;

  GradingRequest({required this.exerciseDailyId, required this.answers});

  Map<String, dynamic> toJson() {
    return {
      'exerciseDailyId': exerciseDailyId,
      'answers': answers.map((answer) => answer.toJson()).toList(),
    };
  }
}

class QuestionAnswer {
  final int questionId;
  final String userAnswer;

  QuestionAnswer({required this.questionId, required this.userAnswer});

  Map<String, dynamic> toJson() {
    return {
      'questionId': questionId,
      'userAnswer': userAnswer,
    };
  }
}