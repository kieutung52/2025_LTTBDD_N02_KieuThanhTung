import 'package:flutter/material.dart';
import 'package:frontend_flutter/app/app_theme.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_flutter/lucide_flutter.dart';
import 'package:animate_do/animate_do.dart';
import 'package:frontend_flutter/l10n/app_localizations.dart';

class LearnPage extends StatelessWidget {
  const LearnPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        FadeInDown(
          child: Padding(
            padding: EdgeInsets.only(bottom: 24.0),
            child: Text(
              l10n.learnVocabTitle,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        
        FadeInUp(
          delay: const Duration(milliseconds: 100),
          child: Card(
            elevation: 2,
            shadowColor: AppColors.primaryBlue.withAlpha((255 * 0.1).round()),
            child: InkWell(
              onTap: () => context.go('/learn/flashcard'),
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.lightBlue,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: const Icon(LucideIcons.bookOpen, size: 48, color: AppColors.primaryBlue),
                    ),
                    const SizedBox(height: 16),
                    Text(l10n.flashcardTitle, style: Theme.of(context).textTheme.headlineSmall),
                    const SizedBox(height: 8),
                    Text(
                      (l10n.flashcardDescription1 + l10n.flashcardDescription2),
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => context.go('/learn/flashcard'),
                        child: Text(l10n.startLearningButton),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        
        const SizedBox(height: 16),

        FadeInUp(
          delay: const Duration(milliseconds: 200),
          child: Card(
            elevation: 2,
            shadowColor: AppColors.success.withAlpha((255 * 0.1).round()),
            child: InkWell(
              onTap: () => context.go('/learn/matching'),
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.success.withAlpha((255 * 0.1).round()),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Icon(LucideIcons.shuffle, size: 48, color: AppColors.success),
                    ),
                    const SizedBox(height: 16),
                    Text(l10n.matchingGameTitle, style: Theme.of(context).textTheme.headlineSmall),
                    const SizedBox(height: 8),
                    Text(
                      l10n.matchingGameDescription1 + l10n.matchingGameDescription2,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () => context.go('/learn/matching'),
                        child: Text(l10n.playNowButton),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}