// lib/core/constants/api_constants.dart
class ApiConstants {
  // Base URL - Update this based on your backend
  static const String baseUrl = 'https://api.taleemie.pk/v1';

  // Auth endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh';

  // Lesson endpoints
  static const String lessons = '/lessons';
  static const String lessonById = '/lessons/{id}';
  static const String lessonsByGrade = '/lessons/grade/{grade}';

  // Quiz endpoints
  static const String quizzes = '/quizzes';
  static const String quizById = '/quizzes/{id}';
  static const String submitAnswer = '/quizzes/{id}/submit';

  // Progress endpoints
  static const String progress = '/progress';
  static const String updateProgress = '/progress/update';
  static const String recommendations = '/progress/recommendations';

  // Analytics endpoints
  static const String studentAnalytics = '/analytics/student/{id}';
  static const String classAnalytics = '/analytics/class/{id}';
  static const String teacherDashboard = '/analytics/teacher/dashboard';

  // School/Institution endpoints
  static const String schools = '/schools';
  static const String schoolById = '/schools/{id}';
  static const String schoolStudents = '/schools/{id}/students';

  // Timeouts
  static const int connectionTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 30000; // 30 seconds
}
