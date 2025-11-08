import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_vi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('vi')
  ];

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginButton;

  /// No description provided for @registerButton.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get registerButton;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get emailHint;

  /// No description provided for @passwordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get passwordHint;

  /// A welcome message with a user's name
  ///
  /// In en, this message translates to:
  /// **'Welcome, {userName}!'**
  String welcomeMessage(String userName);

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'EnglishMaster'**
  String get appName;

  /// No description provided for @toggleMenuTooltip.
  ///
  /// In en, this message translates to:
  /// **'Toggle menu'**
  String get toggleMenuTooltip;

  /// No description provided for @openMenuTooltip.
  ///
  /// In en, this message translates to:
  /// **'Open menu'**
  String get openMenuTooltip;

  /// No description provided for @logoutButton.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logoutButton;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navLearn.
  ///
  /// In en, this message translates to:
  /// **'Learn'**
  String get navLearn;

  /// No description provided for @navExercise.
  ///
  /// In en, this message translates to:
  /// **'Exercise'**
  String get navExercise;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @navSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get navSearch;

  /// No description provided for @exerciseResultsTitle.
  ///
  /// In en, this message translates to:
  /// **'Results ({count} exercises)'**
  String exerciseResultsTitle(Object count);

  /// No description provided for @noExercisesTitle.
  ///
  /// In en, this message translates to:
  /// **'No Exercises Yet'**
  String get noExercisesTitle;

  /// No description provided for @noExercisesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t completed any exercises on this day.'**
  String get noExercisesSubtitle;

  /// No description provided for @exerciseCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Exercise #{id}'**
  String exerciseCardTitle(Object id);

  /// No description provided for @correctAnswersLabel.
  ///
  /// In en, this message translates to:
  /// **'Correct: {correct}/{total}'**
  String correctAnswersLabel(Object correct, Object total);

  /// No description provided for @answerDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Answer Details (Date: {date})'**
  String answerDetailsTitle(Object date);

  /// No description provided for @noDetailsForExercise.
  ///
  /// In en, this message translates to:
  /// **'No details available for this exercise.'**
  String get noDetailsForExercise;

  /// No description provided for @yourAnswerLabel.
  ///
  /// In en, this message translates to:
  /// **'You chose: {answer}'**
  String yourAnswerLabel(Object answer);

  /// No description provided for @correctAnswerLabel.
  ///
  /// In en, this message translates to:
  /// **'Answer: {answer}'**
  String correctAnswerLabel(Object answer);

  /// No description provided for @noExplanation.
  ///
  /// In en, this message translates to:
  /// **'No explanation available.'**
  String get noExplanation;

  /// No description provided for @exerciseTitle.
  ///
  /// In en, this message translates to:
  /// **'Exercise'**
  String get exerciseTitle;

  /// No description provided for @exerciseSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Practice and test your knowledge'**
  String get exerciseSubtitle;

  /// No description provided for @createExerciseTab.
  ///
  /// In en, this message translates to:
  /// **'Create Exercise'**
  String get createExerciseTab;

  /// No description provided for @resultsTab.
  ///
  /// In en, this message translates to:
  /// **'Results'**
  String get resultsTab;

  /// No description provided for @errorNoVocabForExercise.
  ///
  /// In en, this message translates to:
  /// **'Error: No vocabulary available to create an exercise.'**
  String get errorNoVocabForExercise;

  /// No description provided for @errorCannotCreateExercise.
  ///
  /// In en, this message translates to:
  /// **'Could not create exercise'**
  String get errorCannotCreateExercise;

  /// No description provided for @errorCannotGradeExercise.
  ///
  /// In en, this message translates to:
  /// **'Could not grade exercise'**
  String get errorCannotGradeExercise;

  /// No description provided for @vocabExerciseTitle.
  ///
  /// In en, this message translates to:
  /// **'Vocabulary Exercise'**
  String get vocabExerciseTitle;

  /// No description provided for @vocabExerciseDescription.
  ///
  /// In en, this message translates to:
  /// **'This exercise consists of 10 multiple-choice questions. Choose the best answer.'**
  String get vocabExerciseDescription;

  /// No description provided for @startQuizButton.
  ///
  /// In en, this message translates to:
  /// **'Start Quiz'**
  String get startQuizButton;

  /// No description provided for @errorLoadingExercise.
  ///
  /// In en, this message translates to:
  /// **'Error loading exercise'**
  String get errorLoadingExercise;

  /// No description provided for @questionProgress.
  ///
  /// In en, this message translates to:
  /// **'Question {current}/{total}'**
  String questionProgress(Object current, Object total);

  /// No description provided for @previousQuestionButton.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previousQuestionButton;

  /// No description provided for @submitButton.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submitButton;

  /// No description provided for @nextQuestionButton.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get nextQuestionButton;

  /// No description provided for @errorLoadingResults.
  ///
  /// In en, this message translates to:
  /// **'Error loading results'**
  String get errorLoadingResults;

  /// No description provided for @resultScore.
  ///
  /// In en, this message translates to:
  /// **'Result: {score}%'**
  String resultScore(Object score);

  /// No description provided for @resultSummary.
  ///
  /// In en, this message translates to:
  /// **'You answered {correct}/{total} questions correctly'**
  String resultSummary(Object correct, Object total);

  /// No description provided for @answerDetails.
  ///
  /// In en, this message translates to:
  /// **'Answer Details'**
  String get answerDetails;

  /// No description provided for @newExerciseButton.
  ///
  /// In en, this message translates to:
  /// **'Start New Exercise'**
  String get newExerciseButton;

  /// No description provided for @flashcardTitle.
  ///
  /// In en, this message translates to:
  /// **'Flashcard'**
  String get flashcardTitle;

  /// No description provided for @noVocabForToday.
  ///
  /// In en, this message translates to:
  /// **'No vocabulary for today.'**
  String get noVocabForToday;

  /// No description provided for @meaningOfWord.
  ///
  /// In en, this message translates to:
  /// **'Meaning'**
  String get meaningOfWord;

  /// No description provided for @noExample.
  ///
  /// In en, this message translates to:
  /// **'No example available'**
  String get noExample;

  /// No description provided for @learnedProgress.
  ///
  /// In en, this message translates to:
  /// **'Learned: {learned}/{total}'**
  String learnedProgress(Object learned, Object total);

  /// No description provided for @remainingProgress.
  ///
  /// In en, this message translates to:
  /// **'Remaining: {remaining}'**
  String remainingProgress(Object remaining);

  /// No description provided for @flipCardButton.
  ///
  /// In en, this message translates to:
  /// **'Flip Card'**
  String get flipCardButton;

  /// No description provided for @alreadyLearnedButton.
  ///
  /// In en, this message translates to:
  /// **'✓ Learned'**
  String get alreadyLearnedButton;

  /// No description provided for @markAsLearnedButton.
  ///
  /// In en, this message translates to:
  /// **'I Remembered'**
  String get markAsLearnedButton;

  /// No description provided for @tapToFlip.
  ///
  /// In en, this message translates to:
  /// **'Tap to flip'**
  String get tapToFlip;

  /// No description provided for @streakSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Streak maintained successfully!'**
  String get streakSuccessMessage;

  /// No description provided for @streakErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Error updating streak'**
  String get streakErrorMessage;

  /// No description provided for @matchingGameTitle.
  ///
  /// In en, this message translates to:
  /// **'Matching Game'**
  String get matchingGameTitle;

  /// No description provided for @playAgainButton.
  ///
  /// In en, this message translates to:
  /// **'Play Again'**
  String get playAgainButton;

  /// No description provided for @noVocabForGame.
  ///
  /// In en, this message translates to:
  /// **'No vocabulary to play.'**
  String get noVocabForGame;

  /// No description provided for @movesLabel.
  ///
  /// In en, this message translates to:
  /// **'Moves'**
  String get movesLabel;

  /// No description provided for @matchedLabel.
  ///
  /// In en, this message translates to:
  /// **'Matched'**
  String get matchedLabel;

  /// No description provided for @gameCompleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Completed!'**
  String get gameCompleteTitle;

  /// No description provided for @gameCompleteSubtitle.
  ///
  /// In en, this message translates to:
  /// **'You finished the game in {moves} moves!'**
  String gameCompleteSubtitle(Object moves);

  /// No description provided for @learnVocabTitle.
  ///
  /// In en, this message translates to:
  /// **'Learn Vocabulary'**
  String get learnVocabTitle;

  /// No description provided for @flashcardDescription1.
  ///
  /// In en, this message translates to:
  /// **'Learn new vocabulary through flashcards.'**
  String get flashcardDescription1;

  /// No description provided for @flashcardDescription2.
  ///
  /// In en, this message translates to:
  /// **'Flip the card to see the meaning and example.'**
  String get flashcardDescription2;

  /// No description provided for @startLearningButton.
  ///
  /// In en, this message translates to:
  /// **'Start Learning'**
  String get startLearningButton;

  /// No description provided for @matchingGameDescription1.
  ///
  /// In en, this message translates to:
  /// **'Match English words with their Vietnamese meanings.'**
  String get matchingGameDescription1;

  /// No description provided for @matchingGameDescription2.
  ///
  /// In en, this message translates to:
  /// **'Fun and effective!'**
  String get matchingGameDescription2;

  /// No description provided for @playNowButton.
  ///
  /// In en, this message translates to:
  /// **'Play Now'**
  String get playNowButton;

  /// No description provided for @loginFailedError.
  ///
  /// In en, this message translates to:
  /// **'Login failed: {error}'**
  String loginFailedError(Object error);

  /// No description provided for @passwordMismatchError.
  ///
  /// In en, this message translates to:
  /// **'Confirmation password does not match'**
  String get passwordMismatchError;

  /// No description provided for @registerSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Registration successful! Please log in.'**
  String get registerSuccessMessage;

  /// No description provided for @registerFailedError.
  ///
  /// In en, this message translates to:
  /// **'Registration failed: {error}'**
  String registerFailedError(Object error);

  /// No description provided for @createAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccountTitle;

  /// No description provided for @fullNameHint.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullNameHint;

  /// No description provided for @confirmPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPasswordHint;

  /// No description provided for @editButton.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get editButton;

  /// No description provided for @streakStatsTitle.
  ///
  /// In en, this message translates to:
  /// **'Streak Statistics'**
  String get streakStatsTitle;

  /// No description provided for @currentStreakLabel.
  ///
  /// In en, this message translates to:
  /// **'Current Streak'**
  String get currentStreakLabel;

  /// No description provided for @streakDays.
  ///
  /// In en, this message translates to:
  /// **'{days} days'**
  String streakDays(Object days);

  /// No description provided for @lastActiveLabel.
  ///
  /// In en, this message translates to:
  /// **'Last Active'**
  String get lastActiveLabel;

  /// No description provided for @currentDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Current Date'**
  String get currentDateLabel;

  /// No description provided for @personalInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInfoTitle;

  /// No description provided for @fullNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullNameLabel;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// No description provided for @userIdLabel.
  ///
  /// In en, this message translates to:
  /// **'User ID'**
  String get userIdLabel;

  /// No description provided for @saveChangesButton.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChangesButton;

  /// No description provided for @cancelButton.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelButton;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @changeLanguageLabel.
  ///
  /// In en, this message translates to:
  /// **'Change language:'**
  String get changeLanguageLabel;

  /// No description provided for @vietnameseButton.
  ///
  /// In en, this message translates to:
  /// **'Tiếng Việt'**
  String get vietnameseButton;

  /// No description provided for @englishButton.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get englishButton;

  /// No description provided for @profileUpdateSuccess.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully!'**
  String get profileUpdateSuccess;

  /// No description provided for @homeWelcomeMessage.
  ///
  /// In en, this message translates to:
  /// **'Hello, {name}!'**
  String homeWelcomeMessage(Object name);

  /// No description provided for @homeWelcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Keep learning to maintain your streak.'**
  String get homeWelcomeSubtitle;

  /// No description provided for @consecutiveStudyDays.
  ///
  /// In en, this message translates to:
  /// **'Consecutive Study Streak'**
  String get consecutiveStudyDays;

  /// No description provided for @streakMessagePositive.
  ///
  /// In en, this message translates to:
  /// **'Awesome! You\'ve studied for {days} consecutive days!'**
  String streakMessagePositive(Object days);

  /// No description provided for @streakMessageZero.
  ///
  /// In en, this message translates to:
  /// **'Start learning today!'**
  String get streakMessageZero;

  /// No description provided for @learnNewVocab.
  ///
  /// In en, this message translates to:
  /// **'Learn New Vocabulary'**
  String get learnNewVocab;

  /// No description provided for @learnNewVocabDescription.
  ///
  /// In en, this message translates to:
  /// **'Learn with flashcards and matching games'**
  String get learnNewVocabDescription;

  /// No description provided for @doExercises.
  ///
  /// In en, this message translates to:
  /// **'Do Exercises'**
  String get doExercises;

  /// No description provided for @doExercisesDescription.
  ///
  /// In en, this message translates to:
  /// **'Test your knowledge with multiple-choice questions'**
  String get doExercisesDescription;

  /// No description provided for @doExercisesButton.
  ///
  /// In en, this message translates to:
  /// **'Do Exercises'**
  String get doExercisesButton;

  /// No description provided for @searchVocabHint.
  ///
  /// In en, this message translates to:
  /// **'Search for vocabulary...'**
  String get searchVocabHint;

  /// No description provided for @errorPrefix.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String errorPrefix(Object error);

  /// No description provided for @transcriptionUK.
  ///
  /// In en, this message translates to:
  /// **'UK: {transcription}'**
  String transcriptionUK(Object transcription);

  /// No description provided for @transcriptionUS.
  ///
  /// In en, this message translates to:
  /// **'US: {transcription}'**
  String transcriptionUS(Object transcription);

  /// No description provided for @examplePrefix.
  ///
  /// In en, this message translates to:
  /// **'Example: \"{example}\"'**
  String examplePrefix(Object example);

  /// No description provided for @wordNotFoundTitle.
  ///
  /// In en, this message translates to:
  /// **'Word Not Found'**
  String get wordNotFoundTitle;

  /// No description provided for @wordNotFoundSubtitle.
  ///
  /// In en, this message translates to:
  /// **'The vocabulary you requested was not found.'**
  String get wordNotFoundSubtitle;

  /// No description provided for @searchDictionaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Dictionary Search'**
  String get searchDictionaryTitle;

  /// No description provided for @searchDictionarySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter the vocabulary you want to look up in the box above.'**
  String get searchDictionarySubtitle;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'vi': return AppLocalizationsVi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
