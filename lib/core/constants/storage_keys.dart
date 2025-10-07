class StorageKeys {
  // Auth
  static const String authToken = 'auth_token';
  static const String refreshToken = 'refresh_token';
  static const String userId = 'user_id';
  static const String userRole = 'user_role';
  static const String userEmail = 'user_email';

  // App Settings
  static const String language = 'language';
  static const String theme = 'theme';
  static const String isFirstLaunch = 'is_first_launch';

  // User Preferences
  static const String selectedGrade = 'selected_grade';
  static const String schoolId = 'school_id';
  static const String schoolName = 'school_name';

  // Cache
  static const String cachedLessons = 'cached_lessons';
  static const String lastSyncTime = 'last_sync_time';
}

// lib/core/constants/app_constants.dart
class AppConstants {
  // App Info
  static const String appName = 'TaleemIE AI';
  static const String appVersion = '1.0.0';
  static const String packageName = 'pk.taleemie.ai';

  // Grades
  static const List<int> supportedGrades = [6, 7, 8];
  static const Map<int, String> gradeNames = {
    6: 'Grade 6',
    7: 'Grade 7',
    8: 'Grade 8',
  };

  // Languages
  static const String english = 'en';
  static const String urdu = 'ur';
  static const List<String> supportedLanguages = [english, urdu];

  // User Roles
  static const String studentRole = 'student';
  static const String teacherRole = 'teacher';
  static const String adminRole = 'admin';

  // Progress Status
  static const String notStarted = 'not_started';
  static const String inProgress = 'in_progress';
  static const String completed = 'completed';

  // Quiz Pass Threshold
  static const double quizPassPercentage = 70.0;

  // Difficulty Levels
  static const String easy = 'easy';
  static const String medium = 'medium';
  static const String hard = 'hard';

  // Animation Durations
  static const int shortAnimationDuration = 200;
  static const int mediumAnimationDuration = 400;
  static const int longAnimationDuration = 600;

  // Cache Duration
  static const int cacheDurationDays = 7;
}
