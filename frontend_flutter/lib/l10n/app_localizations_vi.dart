// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get loginButton => 'Đăng nhập';

  @override
  String get registerButton => 'Đăng ký';

  @override
  String get emailHint => 'Nhập email của bạn';

  @override
  String get passwordHint => 'Nhập mật khẩu của bạn';

  @override
  String welcomeMessage(String userName) {
    return 'Chào mừng, $userName!';
  }

  @override
  String get appName => 'EnglishMaster';

  @override
  String get toggleMenuTooltip => 'Thu/gọn menu';

  @override
  String get openMenuTooltip => 'Mở menu';

  @override
  String get logoutButton => 'Đăng xuất';

  @override
  String get navHome => 'Trang chủ';

  @override
  String get navLearn => 'Học';

  @override
  String get navExercise => 'Bài tập';

  @override
  String get navProfile => 'Hồ sơ';

  @override
  String get navSearch => 'Tra từ';

  @override
  String exerciseResultsTitle(Object count) {
    return 'Kết quả ($count bài tập)';
  }

  @override
  String get noExercisesTitle => 'Chưa có bài tập';

  @override
  String get noExercisesSubtitle => 'Bạn chưa làm bài tập nào vào ngày này.';

  @override
  String exerciseCardTitle(Object id) {
    return 'Bài tập #$id';
  }

  @override
  String correctAnswersLabel(Object correct, Object total) {
    return 'Đúng: $correct/$total';
  }

  @override
  String answerDetailsTitle(Object date) {
    return 'Chi tiết câu trả lời (Ngày: $date)';
  }

  @override
  String get noDetailsForExercise => 'Không có chi tiết cho bài tập này.';

  @override
  String yourAnswerLabel(Object answer) {
    return 'Bạn chọn: $answer';
  }

  @override
  String correctAnswerLabel(Object answer) {
    return 'Đáp án: $answer';
  }

  @override
  String get noExplanation => 'Không có giải thích.';

  @override
  String get exerciseTitle => 'Bài tập';

  @override
  String get exerciseSubtitle => 'Luyện tập và kiểm tra kiến thức của bạn';

  @override
  String get createExerciseTab => 'Tạo bài tập';

  @override
  String get resultsTab => 'Kết quả';

  @override
  String get errorNoVocabForExercise => 'Lỗi: Không có từ vựng nào để tạo bài tập.';

  @override
  String get errorCannotCreateExercise => 'Không thể tạo bài tập';

  @override
  String get errorCannotGradeExercise => 'Không thể chấm điểm';

  @override
  String get vocabExerciseTitle => 'Bài tập từ vựng';

  @override
  String get vocabExerciseDescription => 'Bài tập gồm 10 câu hỏi trắc nghiệm về từ vựng. Hãy chọn đáp án đúng nhất.';

  @override
  String get startQuizButton => 'Bắt đầu làm bài';

  @override
  String get errorLoadingExercise => 'Lỗi tải bài tập';

  @override
  String questionProgress(Object current, Object total) {
    return 'Câu $current/$total';
  }

  @override
  String get previousQuestionButton => 'Câu trước';

  @override
  String get submitButton => 'Nộp bài';

  @override
  String get nextQuestionButton => 'Câu sau';

  @override
  String get errorLoadingResults => 'Lỗi tải kết quả';

  @override
  String resultScore(Object score) {
    return 'Kết quả: $score%';
  }

  @override
  String resultSummary(Object correct, Object total) {
    return 'Bạn trả lời đúng $correct/$total câu';
  }

  @override
  String get answerDetails => 'Chi tiết câu trả lời';

  @override
  String get newExerciseButton => 'Làm bài tập mới';

  @override
  String get flashcardTitle => 'Flashcard';

  @override
  String get noVocabForToday => 'Không có từ vựng cho hôm nay.';

  @override
  String get meaningOfWord => 'Nghĩa của từ';

  @override
  String get noExample => 'Không có ví dụ';

  @override
  String learnedProgress(Object learned, Object total) {
    return 'Đã học: $learned/$total';
  }

  @override
  String remainingProgress(Object remaining) {
    return 'Còn lại: $remaining';
  }

  @override
  String get flipCardButton => 'Lật thẻ';

  @override
  String get alreadyLearnedButton => '✓ Đã học';

  @override
  String get markAsLearnedButton => 'Đã nhớ';

  @override
  String get tapToFlip => 'Nhấn để lật';

  @override
  String get streakSuccessMessage => 'Duy trì streak thành công!';

  @override
  String get streakErrorMessage => 'Có lỗi khi cập nhật streak';

  @override
  String get matchingGameTitle => 'Ghép từ';

  @override
  String get playAgainButton => 'Chơi lại';

  @override
  String get noVocabForGame => 'Không có từ vựng để chơi.';

  @override
  String get movesLabel => 'Số lần thử';

  @override
  String get matchedLabel => 'Đã ghép';

  @override
  String get gameCompleteTitle => 'Hoàn thành!';

  @override
  String gameCompleteSubtitle(Object moves) {
    return 'Bạn đã hoàn thành game với $moves lần thử!';
  }

  @override
  String get learnVocabTitle => 'Học từ vựng';

  @override
  String get flashcardDescription1 => 'Học từ vựng mới qua thẻ ghi nhớ.';

  @override
  String get flashcardDescription2 => 'Lật thẻ để xem nghĩa và ví dụ.';

  @override
  String get startLearningButton => 'Bắt đầu học';

  @override
  String get matchingGameDescription1 => 'Ghép các từ tiếng Anh với nghĩa tiếng Việt tương ứng.';

  @override
  String get matchingGameDescription2 => 'Vui vẻ và hiệu quả!';

  @override
  String get playNowButton => 'Chơi ngay';

  @override
  String loginFailedError(Object error) {
    return 'Đăng nhập thất bại: $error';
  }

  @override
  String get passwordMismatchError => 'Mật khẩu xác nhận không khớp';

  @override
  String get registerSuccessMessage => 'Đăng ký thành công! Vui lòng đăng nhập.';

  @override
  String registerFailedError(Object error) {
    return 'Đăng ký thất bại: $error';
  }

  @override
  String get createAccountTitle => 'Tạo tài khoản';

  @override
  String get fullNameHint => 'Họ và tên';

  @override
  String get confirmPasswordHint => 'Xác nhận mật khẩu';

  @override
  String get editButton => 'Chỉnh sửa';

  @override
  String get streakStatsTitle => 'Thống kê Streak';

  @override
  String get currentStreakLabel => 'Streak hiện tại';

  @override
  String streakDays(Object days) {
    return '$days ngày';
  }

  @override
  String get lastActiveLabel => 'Học lần cuối';

  @override
  String get currentDateLabel => 'Ngày hiện tại';

  @override
  String get personalInfoTitle => 'Thông tin cá nhân';

  @override
  String get fullNameLabel => 'Họ và tên';

  @override
  String get emailLabel => 'Email';

  @override
  String get userIdLabel => 'User ID';

  @override
  String get saveChangesButton => 'Lưu thay đổi';

  @override
  String get cancelButton => 'Hủy';

  @override
  String get settingsTitle => 'Cài đặt';

  @override
  String get changeLanguageLabel => 'Đổi ngôn ngữ:';

  @override
  String get vietnameseButton => 'Tiếng Việt';

  @override
  String get englishButton => 'English';

  @override
  String get profileUpdateSuccess => 'Cập nhật hồ sơ thành công!';

  @override
  String homeWelcomeMessage(Object name) {
    return 'Xin chào, $name!';
  }

  @override
  String get homeWelcomeSubtitle => 'Hãy tiếp tục học tập để duy trì chuỗi ngày học của bạn.';

  @override
  String get consecutiveStudyDays => 'Chuỗi ngày học liên tiếp';

  @override
  String streakMessagePositive(Object days) {
    return 'Tuyệt vời! Bạn đã học $days ngày liên tiếp!';
  }

  @override
  String get streakMessageZero => 'Bắt đầu học hôm nay nhé!';

  @override
  String get learnNewVocab => 'Học từ vựng mới';

  @override
  String get learnNewVocabDescription => 'Học với flashcard và trò chơi ghép từ';

  @override
  String get doExercises => 'Làm bài tập';

  @override
  String get doExercisesDescription => 'Kiểm tra kiến thức với các bài trắc nghiệm';

  @override
  String get doExercisesButton => 'Làm bài tập';

  @override
  String get searchVocabHint => 'Tìm kiếm từ vựng...';

  @override
  String errorPrefix(Object error) {
    return 'Lỗi: $error';
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
    return 'Ví dụ: \"$example\"';
  }

  @override
  String get wordNotFoundTitle => 'Không tìm thấy từ';

  @override
  String get wordNotFoundSubtitle => 'Không tìm thấy từ vựng bạn yêu cầu.';

  @override
  String get searchDictionaryTitle => 'Tìm kiếm từ điển';

  @override
  String get searchDictionarySubtitle => 'Nhập từ vựng bạn muốn tra vào ô bên trên.';
}
