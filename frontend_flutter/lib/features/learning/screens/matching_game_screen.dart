import 'dart:async';
import 'package:flutter/material.dart';
import 'package:frontend_flutter/app/app_theme.dart';
import 'package:frontend_flutter/core/models/dictionary/dict_personal_dto.dart';
import 'package:frontend_flutter/core/state/auth_provider.dart';
import 'package:frontend_flutter/core/state/learning_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_flutter/lucide_flutter.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import 'package:frontend_flutter/l10n/app_localizations.dart';

class MatchCard {
  final String id;
  final String content;
  final int pairId;
  final bool isWord;
  bool isSelected = false;
  bool isMatched = false;
  bool isWrong = false;

  MatchCard({
    required this.id,
    required this.content,
    required this.pairId,
    required this.isWord,
  });
}

class MatchingGameScreen extends StatefulWidget {
  const MatchingGameScreen({super.key});

  @override
  State<MatchingGameScreen> createState() => _MatchingGameScreenState();
}

class _MatchingGameScreenState extends State<MatchingGameScreen> {
  List<MatchCard> _cards = [];
  MatchCard? _selectedCard;
  int _moves = 0;
  bool _isComplete = false;
  bool _isLoading = true;
  // ignore: unused_field
  bool _hasUpdatedStreak = false;

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  void _initializeGame() {
    final lesson = context.read<LearningProvider>().dailyLesson;
    if (lesson == null || lesson.isEmpty) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    List<MatchCard> gameCards = [];
    int idCounter = 0;

    final List<DictPersonalDTO> gameWords = lesson.take(6).toList();

    for (var vocab in gameWords) {
      final pairId = vocab.id;
      gameCards.add(MatchCard(
        id: 'word-$idCounter',
        content: vocab.dictionary.vocabulary,
        pairId: pairId,
        isWord: true,
      ));
      gameCards.add(MatchCard(
        id: 'mean-$idCounter',
        content: vocab.dictionary.details.first.meaning,
        pairId: pairId,
        isWord: false,
      ));
      idCounter++;
    }

    gameCards.shuffle();
    setState(() {
      _cards = gameCards;
      _selectedCard = null;
      _moves = 0;
      _isComplete = false;
      _isLoading = false;
    });
  }

  void _handleCardClick(MatchCard card) {
    if (card.isMatched || card.isSelected || _isComplete) return;

    setState(() {
      card.isSelected = true;
    });

    if (_selectedCard == null) {
      _selectedCard = card;
    } else {
      _moves++;
      if (_selectedCard!.pairId == card.pairId &&
          _selectedCard!.isWord != card.isWord) {
        setState(() {
          _selectedCard!.isMatched = true;
          card.isMatched = true;
          _selectedCard = null;
        });
        if (_cards.every((c) => c.isMatched)) {
          Timer(const Duration(milliseconds: 500), () {
            setState(() {
              _isComplete = true;
            });
            _updateStreak();
          });
        }
      } else {
        setState(() {
          _selectedCard!.isWrong = true;
          card.isWrong = true;
        });
        Timer(const Duration(seconds: 1), () {
          if (mounted) {
            setState(() {
              _selectedCard?.isSelected = false;
              _selectedCard?.isWrong = false;
              card.isSelected = false;
              card.isWrong = false;
              _selectedCard = null;
            });
          }
        });
      }
    }
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

  @override
  Widget build(BuildContext context) {
    final int matchedCount = _cards.where((c) => c.isMatched).length ~/ 2;
    final int totalPairs = _cards.length ~/ 2;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.pop()),
        title: Text(l10n.matchingGameTitle),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: TextButton.icon(
              icon: const Icon(LucideIcons.rotateCcw, size: 16),
              label: Text(l10n.playAgainButton),
              onPressed: _initializeGame,
            ),
          )
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _cards.isEmpty
              ? Center(child: Text(l10n.noVocabForGame))
              : ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: [
                    Card(
                      color: AppColors.background,
                      elevation: 0,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                Text(l10n.movesLabel,
                                    style: TextStyle(
                                        color: AppColors.textSecondary)),
                                Text(_moves.toString(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium),
                              ],
                            ),
                            Column(
                              children: [
                                Text(l10n.matchedLabel,
                                    style: TextStyle(
                                        color: AppColors.textSecondary)),
                                Text("$matchedCount/$totalPairs",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    if (_isComplete)
                      FadeInDown(
                        child: Card(
                          color: AppColors.success.withAlpha((255 * 0.1).round()),
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              children: [
                                const Icon(LucideIcons.trophy,
                                    size: 64, color: AppColors.success),
                                const SizedBox(height: 16),
                                Text(
                                  l10n.gameCompleteTitle,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(color: AppColors.success),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  l10n.gameCompleteSubtitle(_moves.toString()),
                                  style: const TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 16),
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: _initializeGame,
                                  child: Text(l10n.playAgainButton),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                    if (!_isComplete)
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          childAspectRatio: 1.2,
                        ),
                        itemCount: _cards.length,
                        itemBuilder: (context, index) {
                          final card = _cards[index];
                          return _MatchCardWidget(
                            card: card,
                            onTap: () => _handleCardClick(card),
                          );
                        },
                      ),
                  ],
                ),
    );
  }
}

class _MatchCardWidget extends StatelessWidget {
  final MatchCard card;
  final VoidCallback onTap;

  const _MatchCardWidget({required this.card, required this.onTap});

  @override
  Widget build(BuildContext context) {
    Color borderColor = AppColors.textDisabled.withAlpha((255 * 0.2).round());
    Color bgColor = AppColors.card;

    if (card.isMatched) {
      borderColor = AppColors.success;
      bgColor = AppColors.success.withAlpha((255 * 0.1).round());
    } else if (card.isSelected) {
      borderColor = AppColors.primaryBlue;
      bgColor = AppColors.lightBlue;
    }

    if (card.isWrong) {
      borderColor = AppColors.error;
      bgColor = AppColors.error.withAlpha((255 * 0.1).round());
    }

    return InkWell(
      onTap: card.isMatched ? null : onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: 2),
        ),
        child: Center(
          child: Text(
            card.content,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: card.isMatched
                  ? AppColors.success
                  : (card.isWrong
                      ? AppColors.error
                      : AppColors.textPrimary),
            ),
          ),
        ),
      ),
    );
  }
}