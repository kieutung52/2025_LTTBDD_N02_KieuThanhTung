import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:frontend_flutter/app/app_theme.dart';
import 'package:frontend_flutter/core/models/exercise/exercise_daily_response.dart';
import 'package:frontend_flutter/core/models/exercise/grading_request.dart';
import 'package:frontend_flutter/core/models/exercise/grading_response.dart';
import 'package:frontend_flutter/core/services/exercise_service.dart';
import 'package:frontend_flutter/core/state/learning_provider.dart';
import 'package:provider/provider.dart';
import 'package:lucide_flutter/lucide_flutter.dart';
import 'package:frontend_flutter/core/models/exercise/generate_exercise_request.dart'; 
import 'package:frontend_flutter/l10n/app_localizations.dart';

enum QuizState { intro, loading, inProgress, finished }

class ExerciseGenerateScreen extends StatefulWidget {
  const ExerciseGenerateScreen({super.key});

  @override
  State<ExerciseGenerateScreen> createState() => _ExerciseGenerateScreenState();
}

class _ExerciseGenerateScreenState extends State<ExerciseGenerateScreen> {
  QuizState _quizState = QuizState.intro;
  ExerciseDailyResponse? _exercise;
  GradingResponse? _gradingResult;
  int _currentQuestionIndex = 0;
  final Map<int, String> _answers = {};

  Future<void> _startQuiz() async {
    setState(() { _quizState = QuizState.loading; });
    
    final l10n = AppLocalizations.of(context)!;
    final exerciseService = context.read<ExerciseService>();
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final wordIds = context.read<LearningProvider>().dailyLesson
        ?.take(10).map((e) => e.dictionary.id).toList() ?? [];

    if (wordIds.isEmpty) {
      if (!mounted) return;
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text(l10n.errorNoVocabForExercise),
          backgroundColor: AppColors.error,
        ),
      );
      setState(() { _quizState = QuizState.intro; });
      return;
    }

    try {
      final request = GenerateExerciseRequest(dictionaryIds: wordIds);
      final response = await exerciseService.generateExercise(request);
      
      if (!mounted) return;
      if (response.success && response.data != null) {
        setState(() {
          _exercise = response.data;
          _quizState = QuizState.inProgress;
          _currentQuestionIndex = 0;
          _answers.clear();
          _gradingResult = null;
        });
      } else {
        throw Exception(response.message ?? l10n.errorCannotCreateExercise);
      }
    } catch (e) {
      log("Lỗi khi tạo bài tập", error: e);
      if (!mounted) return;
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text("Lỗi: ${e.toString()}"), backgroundColor: AppColors.error),
      );
      setState(() { _quizState = QuizState.intro; });
    }
  }

  Future<void> _submitQuiz() async {
    if (_exercise == null) return;
    setState(() { _quizState = QuizState.loading; });

    final l10n = AppLocalizations.of(context)!;
    final exerciseService = context.read<ExerciseService>();
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    final List<QuestionAnswer> answerList = [];
    _answers.forEach((questionId, userAnswer) {
      answerList.add(QuestionAnswer(questionId: questionId, userAnswer: userAnswer));
    });
    final request = GradingRequest(exerciseDailyId: _exercise!.id, answers: answerList);

    try {
      final response = await exerciseService.gradeExercise(request);
      if (!mounted) return;
      if (response.success && response.data != null) {
        setState(() {
          _gradingResult = response.data;
          _quizState = QuizState.finished;
        });
      } else {
        throw Exception(response.message ?? l10n.errorCannotGradeExercise);
      }
    } catch (e) {
      log("Lỗi khi chấm điểm", error: e);
      if (!mounted) return;
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text(l10n.errorPrefix(e.toString())), backgroundColor: AppColors.error),
      );
      setState(() { _quizState = QuizState.inProgress; }); // Quay lại quiz
    }
  }

  void _onAnswerSelect(int questionId, String answer) {
    setState(() {
      _answers[questionId] = answer;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (_quizState) {
      case QuizState.intro:
        return _buildIntroCard(context);
      case QuizState.loading:
        return const Center(child: CircularProgressIndicator());
      case QuizState.inProgress:
        return _buildQuizInProgress(context);
      case QuizState.finished:
        return _buildQuizResults(context);
    }
  }

  Widget _buildIntroCard(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(l10n.vocabExerciseTitle, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Text(
                  l10n.vocabExerciseDescription,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _startQuiz,
                  child: Text(l10n.startQuizButton),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuizInProgress(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (_exercise == null) return Center(child: Text(l10n.errorLoadingExercise));
    
    final question = _exercise!.details![_currentQuestionIndex];
    final progress = (_currentQuestionIndex + 1) / _exercise!.totalQuestions;
    final bool allAnswered = _answers.length == _exercise!.totalQuestions;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: Column(
          children: [
            Text(l10n.questionProgress((_currentQuestionIndex + 1).toString(), _exercise!.totalQuestions.toString()), style: const TextStyle(color: AppColors.textSecondary)),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 24),

            Expanded(
              child: Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        question.question,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 24),
                      Expanded(
                        child: ListView.builder(
                          itemCount: question.options.length,
                          itemBuilder: (context, index) {
                            final option = question.options[index];
                            final isSelected = _answers[question.id] == option;
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12.0),
                              // --- BẮT ĐẦU SỬA ---
                              child: ListTile(
                                title: Text(option),
                                onTap: () {
                                  _onAnswerSelect(question.id, option);
                                },
                                leading: Radio<String>(
                                  value: option,
                                  // ignore: deprecated_member_use
                                  groupValue: _answers[question.id],
                                  // ignore: deprecated_member_use
                                  onChanged: (value) {
                                    if (value != null) {
                                      _onAnswerSelect(question.id, value);
                                    }
                                  },
                                  activeColor: AppColors.primaryBlue,
                                ),
                                selected: isSelected,
                                selectedTileColor: AppColors.lightBlue.withAlpha((255 * 0.5).round()),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: BorderSide(
                                    color: isSelected ? AppColors.primaryBlue : Colors.grey.shade300,
                                    width: 2,
                                  ),
                                ),
                              ),
                              // --- KẾT THÚC SỬA ---
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.only(top: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton(
                    onPressed: _currentQuestionIndex == 0 ? null : () {
                      setState(() { _currentQuestionIndex--; });
                    },
                    child: Text(l10n.previousQuestionButton),
                  ),
                  if (_currentQuestionIndex == _exercise!.totalQuestions - 1)
                    ElevatedButton(
                      onPressed: allAnswered ? _submitQuiz : null,
                      child: Text(l10n.submitButton),
                    )
                  else
                    ElevatedButton(
                      onPressed: () {
                        setState(() { _currentQuestionIndex++; });
                      },
                      child: Text(l10n.nextQuestionButton),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuizResults(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (_gradingResult == null) return Center(child: Text(l10n.errorLoadingResults));

    final result = _gradingResult!;
    
    return ListView(
      padding: const EdgeInsets.all(8),
      children: [
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Card(
              color: AppColors.lightBlue,
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    Text(
                      result.score >= 80 ? '🎉' : (result.score >= 60 ? '😊' : '📚'),
                      style: const TextStyle(fontSize: 64),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      l10n.resultScore(result.score.toInt().toString()),
                      style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.primaryBlue),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.resultSummary(result.correctAnswers.toString(), result.totalQuestions.toString()),
                      style: const TextStyle(fontSize: 16, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        
        const SizedBox(height: 24),
        Text(l10n.answerDetails, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
        const SizedBox(height: 16),

        ...result.results.map((res) {
          final isCorrect = res.isCorrect;
          return Card(
            elevation: 1,
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: isCorrect ? AppColors.success.withAlpha((255 * 0.5).round()) : AppColors.error.withAlpha((255 * 0.5).round())),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        isCorrect ? LucideIcons.circleCheck : LucideIcons.circleX,
                        color: isCorrect ? AppColors.success : AppColors.error,
                      ),
                      const SizedBox(width: 8),
                      Expanded(child: Text(res.question, style: const TextStyle(fontWeight: FontWeight.bold))),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    l10n.yourAnswerLabel(res.userAnswer),
                    style: TextStyle(color: isCorrect ? AppColors.success : AppColors.error),
                  ),
                  if (!isCorrect)
                    Text(
                      l10n.correctAnswerLabel(res.correctAnswer),
                      style: const TextStyle(color: AppColors.success),
                    ),
                  const Divider(height: 24),
                  Text(
                    res.explanation,
                    style: const TextStyle(color: AppColors.textSecondary, fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),
          );
        }),

        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: _startQuiz,
          child: Text(l10n.newExerciseButton),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}