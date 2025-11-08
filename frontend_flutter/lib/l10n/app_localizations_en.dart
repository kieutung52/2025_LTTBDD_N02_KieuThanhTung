// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get loginButton => 'Login';

  @override
  String get registerButton => 'Register';

  @override
  String get emailHint => 'Enter your email';

  @override
  String get passwordHint => 'Enter your password';

  @override
  String welcomeMessage(String userName) {
    return 'Welcome, $userName!';
  }

  @override
  String get appName => 'EnglishMaster';

  @override
  String get toggleMenuTooltip => 'Toggle menu';

  @override
  String get openMenuTooltip => 'Open menu';

  @override
  String get logoutButton => 'Logout';

  @override
  String get navHome => 'Home';

  @override
  String get navLearn => 'Learn';

  @override
  String get navExercise => 'Exercise';

  @override
  String get navProfile => 'Profile';

  @override
  String get navSearch => 'Search';

  @override
  String exerciseResultsTitle(Object count) {
    return 'Results ($count exercises)';
  }

  @override
  String get noExercisesTitle => 'No Exercises Yet';

  @override
  String get noExercisesSubtitle => 'You haven\'t completed any exercises on this day.';

  @override
  String exerciseCardTitle(Object id) {
    return 'Exercise #$id';
  }

  @override
  String correctAnswersLabel(Object correct, Object total) {
    return 'Correct: $correct/$total';
  }

  @override
  String answerDetailsTitle(Object date) {
    return 'Answer Details (Date: $date)';
  }

  @override
  String get noDetailsForExercise => 'No details available for this exercise.';

  @override
  String yourAnswerLabel(Object answer) {
    return 'You chose: $answer';
  }

  @override
  String correctAnswerLabel(Object answer) {
    return 'Answer: $answer';
  }

  @override
  String get noExplanation => 'No explanation available.';

  @override
  String get exerciseTitle => 'Exercise';

  @override
  String get exerciseSubtitle => 'Practice and test your knowledge';

  @override
  String get createExerciseTab => 'Create Exercise';

  @override
  String get resultsTab => 'Results';

  @override
  String get errorNoVocabForExercise => 'Error: No vocabulary available to create an exercise.';

  @override
  String get errorCannotCreateExercise => 'Could not create exercise';

  @override
  String get errorCannotGradeExercise => 'Could not grade exercise';

  @override
  String get vocabExerciseTitle => 'Vocabulary Exercise';

  @override
  String get vocabExerciseDescription => 'This exercise consists of 10 multiple-choice questions. Choose the best answer.';

  @override
  String get startQuizButton => 'Start Quiz';

  @override
  String get errorLoadingExercise => 'Error loading exercise';

  @override
  String questionProgress(Object current, Object total) {
    return 'Question $current/$total';
  }

  @override
  String get previousQuestionButton => 'Previous';

  @override
  String get submitButton => 'Submit';

  @override
  String get nextQuestionButton => 'Next';

  @override
  String get errorLoadingResults => 'Error loading results';

  @override
  String resultScore(Object score) {
    return 'Result: $score%';
  }

  @override
  String resultSummary(Object correct, Object total) {
    return 'You answered $correct/$total questions correctly';
  }

  @override
  String get answerDetails => 'Answer Details';

  @override
  String get newExerciseButton => 'Start New Exercise';

  @override
  String get flashcardTitle => 'Flashcard';

  @override
  String get noVocabForToday => 'No vocabulary for today.';

  @override
  String get meaningOfWord => 'Meaning';

  @override
  String get noExample => 'No example available';

  @override
  String learnedProgress(Object learned, Object total) {
    return 'Learned: $learned/$total';
  }

  @override
  String remainingProgress(Object remaining) {
    return 'Remaining: $remaining';
  }

  @override
  String get flipCardButton => 'Flip Card';

  @override
  String get alreadyLearnedButton => '✓ Learned';

  @override
  String get markAsLearnedButton => 'I Remembered';

  @override
  String get tapToFlip => 'Tap to flip';

  @override
  String get streakSuccessMessage => 'Streak maintained successfully!';

  @override
  String get streakErrorMessage => 'Error updating streak';

  @override
  String get matchingGameTitle => 'Matching Game';

  @override
  String get playAgainButton => 'Play Again';

  @override
  String get noVocabForGame => 'No vocabulary to play.';

  @override
  String get movesLabel => 'Moves';

  @override
  String get matchedLabel => 'Matched';

  @override
  String get gameCompleteTitle => 'Completed!';

  @override
  String gameCompleteSubtitle(Object moves) {
    return 'You finished the game in $moves moves!';
  }

  @override
  String get learnVocabTitle => 'Learn Vocabulary';

  @override
  String get flashcardDescription1 => 'Learn new vocabulary through flashcards.';

  @override
  String get flashcardDescription2 => 'Flip the card to see the meaning and example.';

  @override
  String get startLearningButton => 'Start Learning';

  @override
  String get matchingGameDescription1 => 'Match English words with their Vietnamese meanings.';

  @override
  String get matchingGameDescription2 => 'Fun and effective!';

  @override
  String get playNowButton => 'Play Now';

  @override
  String loginFailedError(Object error) {
    return 'Login failed: $error';
  }

  @override
  String get passwordMismatchError => 'Confirmation password does not match';

  @override
  String get registerSuccessMessage => 'Registration successful! Please log in.';

  @override
  String registerFailedError(Object error) {
    return 'Registration failed: $error';
  }

  @override
  String get createAccountTitle => 'Create Account';

  @override
  String get fullNameHint => 'Full Name';

  @override
  String get confirmPasswordHint => 'Confirm Password';

  @override
  String get editButton => 'Edit';

  @override
  String get streakStatsTitle => 'Streak Statistics';

  @override
  String get currentStreakLabel => 'Current Streak';

  @override
  String streakDays(Object days) {
    return '$days days';
  }

  @override
  String get lastActiveLabel => 'Last Active';

  @override
  String get currentDateLabel => 'Current Date';

  @override
  String get personalInfoTitle => 'Personal Information';

  @override
  String get fullNameLabel => 'Full Name';

  @override
  String get emailLabel => 'Email';

  @override
  String get userIdLabel => 'User ID';

  @override
  String get saveChangesButton => 'Save Changes';

  @override
  String get cancelButton => 'Cancel';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get changeLanguageLabel => 'Change language:';

  @override
  String get vietnameseButton => 'Tiếng Việt';

  @override
  String get englishButton => 'English';

  @override
  String get profileUpdateSuccess => 'Profile updated successfully!';

  @override
  String homeWelcomeMessage(Object name) {
    return 'Hello, $name!';
  }

  @override
  String get homeWelcomeSubtitle => 'Keep learning to maintain your streak.';

  @override
  String get consecutiveStudyDays => 'Consecutive Study Streak';

  @override
  String streakMessagePositive(Object days) {
    return 'Awesome! You\'ve studied for $days consecutive days!';
  }

  @override
  String get streakMessageZero => 'Start learning today!';

  @override
  String get learnNewVocab => 'Learn New Vocabulary';

  @override
  String get learnNewVocabDescription => 'Learn with flashcards and matching games';

  @override
  String get doExercises => 'Do Exercises';

  @override
  String get doExercisesDescription => 'Test your knowledge with multiple-choice questions';

  @override
  String get doExercisesButton => 'Do Exercises';

  @override
  String get searchVocabHint => 'Search for vocabulary...';

  @override
  String errorPrefix(Object error) {
    return 'Error: $error';
  }

  @override
  String transcriptionUK(Object transcription) {
    return 'UK: $transcription';
  }

  @override
  String transcriptionUS(Object transcription) {
    return 'US: $transcription';
  }

  @override
  String examplePrefix(Object example) {
    return 'Example: \"$example\"';
  }

  @override
  String get wordNotFoundTitle => 'Word Not Found';

  @override
  String get wordNotFoundSubtitle => 'The vocabulary you requested was not found.';

  @override
  String get searchDictionaryTitle => 'Dictionary Search';

  @override
  String get searchDictionarySubtitle => 'Enter the vocabulary you want to look up in the box above.';
}
