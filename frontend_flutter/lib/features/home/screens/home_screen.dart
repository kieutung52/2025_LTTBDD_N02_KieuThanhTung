import 'package:flutter/material.dart';
import 'package:frontend_flutter/app/app_theme.dart';
import 'package:frontend_flutter/core/models/user/user_response.dart';
import 'package:frontend_flutter/core/state/auth_provider.dart';
import 'package:frontend_flutter/shared/widgets/streak_display.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_flutter/lucide_flutter.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:frontend_flutter/l10n/app_localizations.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final UserResponse? user = context.watch<AuthProvider>().user;

    if (user == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        FadeInDown(
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primaryBlue,
                  AppColors.primaryBlue.withAlpha((255 * 0.8).round())
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.homeWelcomeMessage(user.fullName),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.homeWelcomeSubtitle,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),

        FadeInUp(
          delay: const Duration(milliseconds: 200),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Text(
                    l10n.consecutiveStudyDays,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  StreakDisplay(streak: user.streak),
                  const SizedBox(height: 24),
                  Text(
                    user.streak > 0 ? l10n.streakMessagePositive(user.streak.toString()) : l10n.streakMessageZero,
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),

        FadeInUp(
          delay: const Duration(milliseconds: 400),
          child: ResponsiveBuilder(
            builder: (context, sizingInformation) {
              bool isMobile = sizingInformation.isMobile;
              if (isMobile) {
                return Column(
                  children: [
                    ActionCard(
                      icon: LucideIcons.bookOpen,
                      title: l10n.learnNewVocab,
                      description: l10n.learnNewVocabDescription,
                      buttonText:l10n.startLearningButton,
                      onTap: () {
                        context.go('/learn');
                      },
                      isPrimary: true,
                    ),
                    const SizedBox(height: 16),
                    ActionCard(
                      icon: LucideIcons.target,
                      title: l10n.doExercises,
                      description: l10n.doExercises,
                      buttonText: l10n.doExercisesButton,
                      onTap: () {
                        context.go('/exercise');
                      },
                      isPrimary: false,
                    ),
                  ],
                );
              } 
              
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ActionCard(
                      icon: LucideIcons.bookOpen,
                      title: l10n.learnNewVocab,
                      description: l10n.learnNewVocabDescription,
                      buttonText: l10n.startLearningButton,
                      onTap: () {
                        context.go('/learn');
                      },
                      isPrimary: true,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ActionCard(
                      icon: LucideIcons.target,
                      title: l10n.doExercises,
                      description: l10n.doExercisesDescription,
                      buttonText: l10n.doExercisesButton,
                      onTap: () {
                        context.go('/exercise');
                      },
                      isPrimary: false,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

class ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String buttonText;
  final VoidCallback onTap;
  final bool isPrimary;

  const ActionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.buttonText,
    required this.onTap,
    this.isPrimary = true,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon,
                  size: 32,
                  color: isPrimary ? AppColors.primaryBlue : AppColors.success),
              const SizedBox(height: 16),
              Text(title,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Text(description,
                  style: const TextStyle(
                      fontSize: 14, color: AppColors.textSecondary)),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: isPrimary
                    ? ElevatedButton(onPressed: onTap, child: Text(buttonText))
                    : OutlinedButton(
                        onPressed: onTap,
                        child: Text(buttonText),
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }
}