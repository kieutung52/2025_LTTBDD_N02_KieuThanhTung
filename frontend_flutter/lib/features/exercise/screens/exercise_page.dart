import 'package:flutter/material.dart';
import 'package:frontend_flutter/features/exercise/screens/exercise_generate_screen.dart';
import 'package:frontend_flutter/features/exercise/screens/exercise_results_screen.dart';
import 'package:lucide_flutter/lucide_flutter.dart';
import 'package:animate_do/animate_do.dart';
import 'package:frontend_flutter/l10n/app_localizations.dart';

class ExercisePage extends StatelessWidget {
  const ExercisePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return DefaultTabController(
      length: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FadeInDown(
              child: Text(
                l10n.exerciseTitle,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
            ),
            FadeInDown(
              delay: const Duration(milliseconds: 100),
              child: Text(
                l10n.exerciseSubtitle,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 24),
            FadeInDown(
              delay: const Duration(milliseconds: 200),
              child: Align(
                alignment: Alignment.centerLeft,
                child: TabBar(
                  isScrollable: true,
                  tabs: [
                    Tab(
                      child: Row(
                        children: [
                          Icon(LucideIcons.pencilRuler),
                          SizedBox(width: 8),
                          Text(l10n.createExerciseTab),
                        ],
                      ),
                    ),
                    Tab(
                      child: Row(
                        children: [
                          Icon(LucideIcons.checkCheck),
                          SizedBox(width: 8),
                          Text(l10n.resultsTab),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            Expanded(
              child: FadeInUp(
                delay: const Duration(milliseconds: 300),
                child: const TabBarView(
                  children: [
                    ExerciseGenerateScreen(),
                    ExerciseResultsScreen(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}