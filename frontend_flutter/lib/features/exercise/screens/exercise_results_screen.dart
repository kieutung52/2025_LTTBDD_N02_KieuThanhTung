import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:frontend_flutter/app/app_theme.dart';
import 'package:frontend_flutter/core/models/exercise/exercise_daily_response.dart';
import 'package:frontend_flutter/core/services/exercise_service.dart';
import 'package:intl/intl.dart';
import 'package:lucide_flutter/lucide_flutter.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:frontend_flutter/l10n/app_localizations.dart';

class ExerciseResultsScreen extends StatefulWidget {
  const ExerciseResultsScreen({super.key});

  @override
  State<ExerciseResultsScreen> createState() => _ExerciseResultsScreenState();
}

class _ExerciseResultsScreenState extends State<ExerciseResultsScreen> {
  DateTime _selectedDate = DateTime.now();
  List<ExerciseDailyResponse>? _results;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchResults(_selectedDate);
  }

  Future<void> _fetchResults(DateTime date) async {
    setState(() { _isLoading = true; });
    final exerciseService = context.read<ExerciseService>();
    final l10n = AppLocalizations.of(context)!;
    
    try {
      final response = await exerciseService.getResultsByDate(date);
      if (!mounted) return;
      if (response.success) {
        setState(() {
          _results = response.data;
          _isLoading = false;
        });
      } else {
        throw Exception(response.message);
      }
    } catch (e) {
      log("Lỗi khi tải kết quả", error: e);
      if (!mounted) return;
      setState(() { _isLoading = false; });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.errorPrefix(e.toString())), backgroundColor: AppColors.error),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ListView(
      padding: const EdgeInsets.all(8.0),
      children: [
        _buildCalendar(),
        const SizedBox(height: 24),
        Text(l10n.exerciseResultsTitle(_results?.length.toString() ?? '0')),
        const SizedBox(height: 16),
        _buildResultsList(),
      ],
    );
  }

  Widget _buildCalendar() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TableCalendar(
          locale: 'vi_VN',
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.now(),
          focusedDay: _selectedDate,
          selectedDayPredicate: (day) => isSameDay(_selectedDate, day),
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDate = selectedDay;
            });
            _fetchResults(selectedDay);
          },
          calendarStyle: CalendarStyle(
            todayDecoration: BoxDecoration(
              color: AppColors.primaryBlue.withAlpha((255 * 0.5).round()),
              shape: BoxShape.circle,
            ),
            selectedDecoration: const BoxDecoration(
              color: AppColors.primaryBlue,
              shape: BoxShape.circle,
            ),
          ),
          headerStyle: const HeaderStyle(
            titleCentered: true,
            formatButtonVisible: false,
          ),
        ),
      ),
    );
  }

  Widget _buildResultsList() {
    final l10n = AppLocalizations.of(context)!;

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_results == null || _results!.isEmpty) {
      return  Card(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Center(
            child: Column(
              children: [
                Icon(LucideIcons.fileSearch, size: 64, color: AppColors.textDisabled),
                SizedBox(height: 16),
                Text(l10n.noExercisesTitle, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                SizedBox(height: 8),
                Text(l10n.noExercisesSubtitle, style: TextStyle(color: AppColors.textSecondary)),
              ],
            ),
          ),
        ),
      );
    }

    return Column(
      children: _results!.map((result) => _buildResultCard(result)).toList(),
    );
  }

  Widget _buildResultCard(ExerciseDailyResponse result) {
    final double score = (result.correctAnswers / result.totalQuestions) * 100;
    final Color scoreColor = score >= 80 ? AppColors.success : (score >= 60 ? AppColors.flame : AppColors.error);
    final String emoji = score >= 80 ? '🎉' : (score >= 60 ? '😊' : '📚');
    final l10n = AppLocalizations.of(context)!;


    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.all(16.0),
        title: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.exerciseCardTitle(result.id.toString()),
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  l10n.correctAnswersLabel(result.correctAnswers.toString(), result.totalQuestions.toString()),
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
                ),
              ],
            ),
            const Spacer(),
            Text(
              "${score.toInt()}%",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: scoreColor),
            ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.answerDetailsTitle(DateFormat('yyyy-MM-dd').format(result.date)),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                if (result.details == null || result.details!.isEmpty)
                  Text(l10n.noDetailsForExercise)
                else
                  ...result.details!.map((detail) {
                    final isCorrect = detail.isCorrect;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isCorrect ? AppColors.success.withAlpha((255 * 0.5).round()) : AppColors.error.withAlpha((255 * 0.5).round()),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: isCorrect ? AppColors.success.withAlpha((255 * 0.2).round()) : AppColors.error.withAlpha((255 * 0.2).round())),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(detail.question, style: const TextStyle(fontWeight: FontWeight.w500)),
                            const SizedBox(height: 4),
                            Text(
                              l10n.yourAnswerLabel(detail.userAnswer ?? 'N/A'),
                              style: TextStyle(color: isCorrect ? AppColors.success : AppColors.error),
                            ),
                            if (!isCorrect)
                              Text(
                                l10n.correctAnswerLabel(detail.trueAnswer),
                                style: const TextStyle(color: AppColors.success),
                              ),
                            const Divider(height: 16),
                            Text(
                              detail.aiExplain ?? l10n.noExplanation,
                              style: const TextStyle(color: AppColors.textSecondary, fontStyle: FontStyle.italic, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    );
                  })
              ],
            ),
          )
        ],
      ),
    );
  }
}