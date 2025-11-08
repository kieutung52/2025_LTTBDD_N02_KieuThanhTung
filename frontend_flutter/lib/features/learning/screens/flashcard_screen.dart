import 'package:flutter/material.dart';
import 'package:frontend_flutter/app/app_theme.dart';
import 'package:frontend_flutter/core/models/dictionary/dict_personal_dto.dart';
import 'package:frontend_flutter/core/state/auth_provider.dart';
import 'package:frontend_flutter/core/state/learning_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_flutter/lucide_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flip_card/flip_card.dart';
import 'package:animate_do/animate_do.dart';
import 'package:frontend_flutter/l10n/app_localizations.dart';

class FlashcardScreen extends StatefulWidget {
  const FlashcardScreen({super.key});

  @override
  State<FlashcardScreen> createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardScreen> {
  int _currentIndex = 0;
  final Set<int> _learned = {};
  final GlobalKey<FlipCardState> _cardKey = GlobalKey<FlipCardState>();
  bool _hasUpdatedStreak = false;

  void _markAsLearned(int id) {
    setState(() {
      _learned.add(id);
    });

    final lesson = context.read<LearningProvider>().dailyLesson;
    if (lesson != null && _learned.length == lesson.length && !_hasUpdatedStreak) {
      _updateStreak();
    }

    _handleNext();
  }

  Future<void> _updateStreak() async {
    final l10n = AppLocalizations.of(context)!;
    final authProvider = context.read<AuthProvider>();
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      setState(() {
        _hasUpdatedStreak = true;
      });

      await authProvider.optimisticallyUpdateStreak();
      
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text(l10n.streakSuccessMessage),
          backgroundColor: AppColors.success,
        ),
      );
    } catch (e) {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text(l10n.streakErrorMessage),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  void _handleNext() {
    final lesson = context.read<LearningProvider>().dailyLesson;
    if (lesson == null) return;

    if (_currentIndex < lesson.length - 1) {
      setState(() {
        _currentIndex++;
      });
      _cardKey.currentState?.controller?.reset();
    }
  }

  void _handlePrev() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
      });
      _cardKey.currentState?.controller?.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final lessonProvider = context.watch<LearningProvider>();
    final List<DictPersonalDTO>? lesson = lessonProvider.dailyLesson;

    if (lessonProvider.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (lesson == null || lesson.isEmpty) {
      return Scaffold(
        appBar: AppBar(leading: BackButton(onPressed: () => context.pop())),
        body: Center(child: Text(l10n.noVocabForToday)),
      );
    }

    final currentCard = lesson[_currentIndex];
    final progress = (_currentIndex + 1) / lesson.length;
    final bool isLearned = _learned.contains(currentCard.id);

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.pop()),
        title: Text(l10n.flashcardTitle),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: AppColors.background,
            valueColor:
                const AlwaysStoppedAnimation<Color>(AppColors.primaryBlue),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: FlipCard(
                    key: _cardKey,
                    front: _FlashcardFace(
                      level: currentCard.dictionary.level.name.toUpperCase(),
                      vocabulary: currentCard.dictionary.vocabulary,
                      transcription:
                          currentCard.dictionary.transcriptionUk ?? "",
                      isFront: true,
                    ),
                    back: _FlashcardFace(
                      level: l10n.meaningOfWord,
                      vocabulary:
                          currentCard.dictionary.details.first.meaning,
                      transcription: currentCard
                              .dictionary.details.first.exampleSentence ??
                          l10n.noExample,
                      isFront: false,
                    ),
                  ),
                ),
              ),
            ),

            FadeInUp(
              delay: const Duration(milliseconds: 200),
              child: Card(
                color: AppColors.background,
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(l10n.learnedProgress(_learned.length.toString(), lesson.length.toString()),
                          style: TextStyle(color: AppColors.textSecondary)),
                      Text(l10n.remainingProgress((lesson.length - _learned.length).toString()),
                          style: TextStyle(color: AppColors.textSecondary)),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            FadeInUp(
              delay: const Duration(milliseconds: 300),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(LucideIcons.chevronLeft, size: 32),
                        onPressed: _currentIndex == 0 ? null : _handlePrev,
                      ),
                      OutlinedButton(
                        onPressed: () => _cardKey.currentState?.toggleCard(),
                        child: Text(l10n.flipCardButton),
                      ),
                      IconButton(
                        icon: const Icon(LucideIcons.chevronRight, size: 32),
                        onPressed: _currentIndex == lesson.length - 1
                            ? null
                            : _handleNext,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed:
                          isLearned ? null : () => _markAsLearned(currentCard.id),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isLearned
                            ? AppColors.success.withAlpha((255 * 0.5).round())
                            : AppColors.success,
                      ),
                      child: Text(isLearned ? l10n.alreadyLearnedButton : l10n.markAsLearnedButton),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FlashcardFace extends StatelessWidget {
  final String level;
  final String vocabulary;
  final String transcription;
  final bool isFront;

  const _FlashcardFace({
    required this.level,
    required this.vocabulary,
    required this.transcription,
    required this.isFront,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      elevation: 4,
      child: Container(
        height: 400,
        width: double.infinity,
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Chip(
              label: Text(level),
              backgroundColor: isFront
                  ? AppColors.lightBlue
                  : AppColors.success.withAlpha((255 * 0.1).round()),
              labelStyle: TextStyle(
                  color: isFront ? AppColors.primaryBlue : AppColors.success,
                  fontWeight: FontWeight.bold),
              side: BorderSide.none,
            ),
            const SizedBox(height: 24),
            Text(
              vocabulary,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: isFront ? AppColors.primaryBlue : AppColors.success,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              transcription,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: AppColors.textSecondary,
                fontStyle: isFront ? FontStyle.normal : FontStyle.italic,
              ),
            ),
            const Spacer(),
            Text(
              l10n.tapToFlip,
              style: TextStyle(fontSize: 14, color: AppColors.textDisabled),
            ),
          ],
        ),
      ),
    );
  }
}