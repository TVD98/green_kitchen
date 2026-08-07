// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appTitle => 'Green Kitchen';

  @override
  String get settingsTitle => 'Cài đặt';

  @override
  String get languageSettingsTitle => 'Ngôn ngữ';

  @override
  String get languageSystem => 'Theo hệ thống';

  @override
  String get languageVietnamese => 'Tiếng Việt';

  @override
  String get languageEnglish => 'Tiếng Anh';

  @override
  String get languageSampleHint => 'Nội dung này theo ngôn ngữ bạn đã chọn.';

  @override
  String get openLanguageSettings => 'Ngôn ngữ';

  @override
  String get authWelcomeTitle => 'Bắt đầu nào!';

  @override
  String get authWelcomeSubtitle => 'Hãy đăng nhập vào tài khoản của bạn';

  @override
  String get authSignUp => 'Đăng ký';

  @override
  String get authSignIn => 'Đăng nhập';

  @override
  String get authPrivacyPolicy => 'Chính sách bảo mật';

  @override
  String get authTermsOfService => 'Điều khoản dịch vụ';

  @override
  String get authPrivacyTermsSeparator => '  ·  ';

  @override
  String get authContinueWithGoogle => 'Tiếp tục với Google';

  @override
  String get authContinueWithFacebook => 'Tiếp tục với Facebook';

  @override
  String get authOrContinueWith => 'hoặc tiếp tục với';

  @override
  String get authGoogle => 'Google';

  @override
  String get authFacebook => 'Facebook';

  @override
  String get authLoginTitle => 'Chào mừng trở lại!';

  @override
  String get authLoginSubtitle =>
      'Đăng nhập để tiếp tục hành trình nấu ăn lành mạnh.';

  @override
  String get authEmail => 'Email';

  @override
  String get authPassword => 'Mật khẩu';

  @override
  String get authRememberMe => 'Ghi nhớ đăng nhập';

  @override
  String get authForgotPassword => 'Quên mật khẩu?';

  @override
  String get authNoAccountPrompt => 'Chưa có tài khoản? ';

  @override
  String get authSignupTitle => 'Tham gia Green Kitchen ngay!';

  @override
  String get authSignupSubtitle =>
      'Tạo tài khoản để bắt đầu nấu những bữa ăn lành mạnh hơn.';

  @override
  String get authAgreeTerms => 'Tôi đồng ý với Điều khoản & Điều kiện';

  @override
  String get authHaveAccountPrompt => 'Đã có tài khoản? ';

  @override
  String get authForgotTitle => 'Quên mật khẩu?';

  @override
  String get authForgotSubtitle =>
      'Nhập email bạn đã dùng để đăng ký. Chúng tôi sẽ gửi mã một lần để đặt lại mật khẩu.';

  @override
  String get authRegisteredEmail => 'Email đã đăng ký';

  @override
  String get authSendOtp => 'Gửi mã OTP';

  @override
  String get authOtpTitle => 'Nhập mã OTP';

  @override
  String get authOtpSubtitle =>
      'Nhập mã OTP từ email để xác minh danh tính của bạn.';

  @override
  String authOtpResendInSeconds(int seconds) {
    return 'Bạn có thể gửi lại mã sau $seconds giây';
  }

  @override
  String get authOtpResendNow => 'Bạn có thể gửi lại mã ngay bây giờ';

  @override
  String get authResendCode => 'Gửi lại mã';

  @override
  String get authRequestNewCode => 'Yêu cầu mã mới';

  @override
  String get authResetTitle => 'Bảo vệ tài khoản của bạn';

  @override
  String get authResetSubtitle =>
      'Mật khẩu mới phải có ít nhất 8 ký tự. Tránh dùng lại mật khẩu cũ.';

  @override
  String get authCreateNewPassword => 'Tạo mật khẩu mới';

  @override
  String get authConfirmNewPassword => 'Xác nhận mật khẩu mới';

  @override
  String get authRequestNewResetCode => 'Yêu cầu mã đặt lại mới';

  @override
  String get authSaveNewPassword => 'Lưu mật khẩu mới';

  @override
  String get authPasswordUpdatedTitle => 'Hoàn tất!';

  @override
  String get authPasswordUpdatedSubtitle =>
      'Mật khẩu của bạn đã được cập nhật.';

  @override
  String get authLogOut => 'Đăng xuất';

  @override
  String get authHomeWelcome => 'Xin chào!';

  @override
  String authHomeWelcomeNamed(String name) {
    return 'Xin chào, $name!';
  }

  @override
  String get authValidationEmailInvalid =>
      'Email không hợp lệ. Vui lòng kiểm tra lại.';

  @override
  String get authValidationPasswordWeak =>
      'Mật khẩu từ 8-32 ký tự, gồm chữ hoa, chữ thường, số và ký tự đặc biệt.';

  @override
  String get authValidationPasswordRequired => 'Vui lòng nhập mật khẩu.';

  @override
  String get authValidationPasswordMismatch => 'Mật khẩu xác nhận không khớp.';

  @override
  String get authValidationOtpInvalid => 'Mã OTP gồm 4 chữ số.';

  @override
  String get authErrorNetwork => 'Không có kết nối mạng. Vui lòng thử lại.';

  @override
  String get authErrorServer =>
      'Đã có lỗi xảy ra. Vui lòng thử lại sau ít phút.';

  @override
  String get authErrorInvalidCredentials =>
      'Email hoặc mật khẩu không chính xác.';

  @override
  String get authErrorInvalidOtp => 'Mã OTP không chính xác. Vui lòng thử lại.';

  @override
  String get authErrorOtpExpired =>
      'Mã OTP đã hết hạn. Vui lòng yêu cầu gửi lại mã.';

  @override
  String get authErrorUserExists => 'Email này đã được đăng ký.';

  @override
  String get authErrorAccountLocked =>
      'Tài khoản của bạn tạm thời bị khóa do nhập sai quá nhiều lần.';

  @override
  String get authErrorRateLimited =>
      'Bạn đã thao tác quá nhanh. Vui lòng thử lại sau 1 phút.';

  @override
  String get authErrorSocial =>
      'Đăng nhập mạng xã hội thất bại. Vui lòng thử lại.';

  @override
  String get authErrorInvalidResetToken =>
      'Liên kết đặt lại mật khẩu không còn hợp lệ.';

  @override
  String get authErrorResetTokenExpired =>
      'Phiên đặt lại mật khẩu đã hết hạn. Vui lòng thử lại.';

  @override
  String get authErrorSessionExpired =>
      'Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại.';

  @override
  String get authErrorInvalidInput =>
      'Thông tin nhập vào không hợp lệ. Vui lòng kiểm tra lại.';

  @override
  String get tabDiscover => 'Khám phá';

  @override
  String get tabRecipes => 'Công thức';

  @override
  String get tabSuggestions => 'Gợi ý';

  @override
  String get tabProfile => 'Cá nhân';

  @override
  String get discoverTitle => 'Hôm nay bạn muốn nấu gì?';

  @override
  String get discoverSubtitle =>
      'Mô tả món bạn muốn hoặc chọn gợi ý nhanh bên dưới.';

  @override
  String get discoverPromptHint => 'Ví dụ: món chay nhanh cho bữa tối…';

  @override
  String get discoverVoiceSuggestion => 'Nói thay vì gõ';

  @override
  String get discoverUsePreferencesTitle => 'Dùng sở thích ăn uống';

  @override
  String get discoverUsePreferencesSubtitle =>
      'Gợi ý theo khẩu vị và chế độ ăn của bạn';

  @override
  String get discoverExcludeAllergiesTitle => 'Loại trừ dị ứng';

  @override
  String get discoverExcludeAllergiesSubtitle => 'Tránh nguyên liệu bạn dị ứng';

  @override
  String get discoverQuickStartLabel => 'Bắt đầu nhanh';

  @override
  String get discoverQuickStartFridge => 'Nguyên liệu trong tủ lạnh';

  @override
  String get discoverQuickStartCravings => 'Cơn thèm';

  @override
  String get discoverQuickStartFastHealthy => 'Nhanh & lành mạnh';

  @override
  String get discoverQuickStartVegetarian => 'Chỉ ăn chay';

  @override
  String get discoverFindRecipes => 'Tìm công thức';

  @override
  String get discoverAiDisclaimer =>
      'Gợi ý do AI tạo. Hãy kiểm tra nguyên liệu và dị ứng trước khi nấu.';

  @override
  String get discoverVoicePermissionDenied =>
      'Cần quyền micro để dùng nhập giọng nói.';

  @override
  String get discoverFridgeSheetTitle => 'Chọn nguyên liệu';

  @override
  String get discoverFridgeSheetSubtitle => 'Chọn tối đa 7 nguyên liệu bạn có';

  @override
  String get discoverFridgeSearchHint => 'Tìm nguyên liệu…';

  @override
  String get discoverFridgeSearchEmpty => 'Gõ tên nguyên liệu để tìm';

  @override
  String discoverFridgeAddIngredients(int count, int max) {
    return 'Thêm nguyên liệu ($count/$max)';
  }

  @override
  String get discoverFridgeClearSelection => 'Xóa lựa chọn';

  @override
  String discoverPromptFridgeWithIngredients(String ingredients) {
    return 'Tôi có: $ingredients. Gợi ý món nấu.';
  }

  @override
  String get discoverPromptFridgeEmpty =>
      'Tôi có nguyên liệu trong tủ lạnh. Gợi ý món nấu.';

  @override
  String discoverPromptCravingsWithInput(String craving) {
    return 'Tôi đang thèm: $craving. Tôi có thể nấu gì?';
  }

  @override
  String get discoverPromptCravingsTemplate =>
      'Tôi đang thèm: ... Tôi có thể nấu gì?';

  @override
  String get discoverPromptFastHealthy => 'Gợi ý món nhanh và lành mạnh';

  @override
  String get discoverPromptVegetarian => 'Gợi ý món chay';

  @override
  String get discoverIngredientCategoryVegetable => 'Rau củ';

  @override
  String get discoverIngredientCategoryProtein => 'Đạm';

  @override
  String get discoverIngredientCategoryDairy => 'Sữa';

  @override
  String get discoverIngredientCategoryGrain => 'Ngũ cốc';

  @override
  String get discoverIngredientCategoryCarb => 'Tinh bột';

  @override
  String get discoverIngredientCategoryAromatic => 'Gia vị thơm';

  @override
  String get discoverIngredientCategorySpice => 'Gia vị';

  @override
  String get discoverIngredientCategorySeasoning => 'Nêm';

  @override
  String get discoverIngredientCategoryHerb => 'Rau thơm';

  @override
  String get discoverIngredientCategoryOther => 'Khác';

  @override
  String get discoverRecentSearches => 'Tìm gần đây';

  @override
  String get discoverNoRecent => 'Chưa có lần tìm nào.';

  @override
  String get discoveryResultsTitle => 'Kết quả tìm kiếm';

  @override
  String discoveryResultsCount(int count) {
    return '$count công thức';
  }

  @override
  String get discoverySearching => 'Đang tìm công thức phù hợp…';

  @override
  String get discoveryEmpty => 'Không tìm thấy công thức phù hợp.';

  @override
  String get discoveryEmptyHint =>
      'Thử đổi câu hỏi hoặc chỉnh sở thích và dị ứng.';

  @override
  String get discoveryRetry => 'Thử lại';

  @override
  String get pantryResultsTitle => 'Món gợi ý';

  @override
  String get pantryRetry => 'Thử lại';

  @override
  String get pantryEmpty => 'Không tìm thấy công thức cho bộ nguyên liệu này.';

  @override
  String get pantryError => 'Không tải được gợi ý. Vui lòng thử lại.';

  @override
  String get filterTitle => 'Bộ lọc tìm kiếm';

  @override
  String get filterMaxTime => 'Thời gian nấu tối đa (phút)';

  @override
  String get filterDifficulty => 'Độ khó';

  @override
  String get filterApply => 'Áp dụng';

  @override
  String get filterAny => 'Bất kỳ';

  @override
  String get filterEasy => 'Dễ';

  @override
  String get filterMedium => 'Trung bình';

  @override
  String get filterHard => 'Khó';

  @override
  String get librarySegmentAll => 'Tất cả';

  @override
  String get librarySegmentViewed => 'Đã xem';

  @override
  String get librarySegmentSaved => 'Đã lưu';

  @override
  String get librarySegmentFromPantry => 'Từ tủ bếp';

  @override
  String get libraryEmptyAll =>
      'Chưa có công thức. Khám phá hoặc lưu món để xem tại đây.';

  @override
  String get libraryEmptyViewed => 'Bạn chưa xem công thức nào.';

  @override
  String get libraryEmptySaved => 'Chưa có công thức đã lưu.';

  @override
  String get libraryEmptyFromPantry => 'Chưa có lần tìm từ tủ bếp.';

  @override
  String get suggestionsFeatured => 'Nổi bật hôm nay';

  @override
  String get suggestionsPopular => 'Nhiều người quan tâm';

  @override
  String get suggestionsQuick => 'Nấu nhanh';

  @override
  String get suggestionsEasy => 'Dễ làm';

  @override
  String suggestionsMockViews(String count) {
    return '$count lượt xem';
  }

  @override
  String get profileTitle => 'Cá nhân';

  @override
  String get profileLanguage => 'Ngôn ngữ';

  @override
  String get profileLogout => 'Đăng xuất';

  @override
  String get profilePreferences => 'Sở thích ăn uống';

  @override
  String get profilePreferencesSubtitle =>
      'Chế độ ăn, độ cay, ẩm thực và mục tiêu';

  @override
  String get profilePreferencesSubtitleEmpty => 'Chưa thiết lập';

  @override
  String profilePreferencesSubtitleStyle(String style) {
    return '$style';
  }

  @override
  String profilePreferencesSubtitleParts(String parts) {
    return '$parts';
  }

  @override
  String profilePreferencesSubtitleCuisineCount(int count) {
    return '$count ẩm thực';
  }

  @override
  String profilePreferencesSubtitleGoalCount(int count) {
    return '$count mục tiêu';
  }

  @override
  String profilePreferencesSubtitleDislikedCount(int count) {
    return '$count không thích';
  }

  @override
  String get profileAllergies => 'Dị ứng';

  @override
  String get profileAllergiesSubtitleEmpty => 'Chưa thiết lập';

  @override
  String profileAllergiesSubtitleCount(int count) {
    return '$count nguyên liệu';
  }

  @override
  String get profilePreferencesTitle => 'Sở thích ăn uống';

  @override
  String get profilePreferencesSave => 'Lưu';

  @override
  String get profilePreferencesRetry => 'Thử lại';

  @override
  String get profilePreferencesError =>
      'Không tải được sở thích. Vui lòng thử lại.';

  @override
  String get profilePreferencesSaveError =>
      'Không lưu được sở thích. Vui lòng thử lại.';

  @override
  String get profilePreferencesSaved => 'Đã lưu sở thích';

  @override
  String get profilePreferencesSummaryTitle => 'Đang áp dụng';

  @override
  String get profilePreferencesSummaryEmpty =>
      'Chưa chọn gì — chọn bên dưới để cá nhân hóa';

  @override
  String get profilePreferencesPickOne => 'Chọn một';

  @override
  String get profilePreferencesPickMany => 'Chọn nhiều tùy thích';

  @override
  String profilePreferencesCountSelected(int count) {
    return 'Đã chọn $count';
  }

  @override
  String get profileDietaryStyle => 'Chế độ ăn';

  @override
  String get profileSpiceLevel => 'Độ cay';

  @override
  String get profileCuisines => 'Ẩm thực ưa thích';

  @override
  String get profileHealthGoals => 'Mục tiêu sức khỏe';

  @override
  String get profileDislikedIngredients => 'Nguyên liệu không thích';

  @override
  String get profileDislikedHint => 'Thêm nguyên liệu';

  @override
  String get profileDislikedAdd => 'Thêm';

  @override
  String get profileDislikedEmpty =>
      'Chưa có — thêm nguyên liệu bạn muốn tránh';

  @override
  String get profileDietaryOmnivore => 'Ăn tạp';

  @override
  String get profileDietaryVegetarian => 'Ăn chay (có trứng/sữa)';

  @override
  String get profileDietaryVegan => 'Thuần chay';

  @override
  String get profileDietaryPescatarian => 'Ăn chay + hải sản';

  @override
  String get profileSpiceMild => 'Nhẹ';

  @override
  String get profileSpiceMedium => 'Vừa';

  @override
  String get profileSpiceHot => 'Cay';

  @override
  String get profileCuisineVietnamese => 'Việt Nam';

  @override
  String get profileCuisineJapanese => 'Nhật';

  @override
  String get profileCuisineKorean => 'Hàn';

  @override
  String get profileCuisineChinese => 'Trung';

  @override
  String get profileCuisineThai => 'Thái';

  @override
  String get profileCuisineWestern => 'Âu Mỹ';

  @override
  String get profileCuisineIndian => 'Ấn Độ';

  @override
  String get profileGoalLowCarb => 'Ít tinh bột';

  @override
  String get profileGoalHighProtein => 'Nhiều đạm';

  @override
  String get profileGoalLowFat => 'Ít béo';

  @override
  String get profileGoalBalanced => 'Cân bằng';

  @override
  String get profileGoalWeightLoss => 'Giảm cân';

  @override
  String get profileAllergiesTitle => 'Dị ứng';

  @override
  String get profileAllergiesSave => 'Lưu';

  @override
  String get profileAllergiesClearAll => 'Xóa hết';

  @override
  String get profileAllergiesRetry => 'Thử lại';

  @override
  String get profileAllergiesError =>
      'Không tải được dị ứng. Vui lòng thử lại.';

  @override
  String get profileAllergiesSaveError =>
      'Không lưu được dị ứng. Vui lòng thử lại.';

  @override
  String get profileAllergiesSaved => 'Đã lưu dị ứng';

  @override
  String get profileAllergiesEmpty =>
      'Chưa chọn dị ứng. Tìm kiếm để thêm nguyên liệu.';

  @override
  String get profileAllergiesSearchHint => 'Tìm nguyên liệu';

  @override
  String get profileAllergiesSelected => 'Đã chọn';

  @override
  String get profileAllergiesResults => 'Kết quả';

  @override
  String get recipeDetailIngredients => 'Nguyên liệu';

  @override
  String get recipeDetailSteps => 'Các bước';

  @override
  String get recipeDetailNutrition => 'Dinh dưỡng';

  @override
  String get recipeDetailSave => 'Lưu';

  @override
  String get recipeDetailUnsave => 'Đã lưu';

  @override
  String get recipeDetailNotFound => 'Không tìm thấy công thức.';

  @override
  String recipeDetailMinutes(int minutes) {
    return '$minutes phút';
  }

  @override
  String recipeDetailServings(int count) {
    return '$count khẩu phần';
  }

  @override
  String get recipeDifficultyEasy => 'Dễ';

  @override
  String get recipeDifficultyMedium => 'Trung bình';

  @override
  String get recipeDifficultyHard => 'Khó';

  @override
  String get discoveryErrorNotFound => 'Không tìm thấy công thức.';

  @override
  String get discoveryErrorServer => 'Đã có lỗi xảy ra. Vui lòng thử lại.';

  @override
  String get discoveryErrorRateLimited =>
      'Quá nhiều yêu cầu. Vui lòng đợi và thử lại.';
}
