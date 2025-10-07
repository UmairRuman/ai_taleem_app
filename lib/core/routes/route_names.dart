// lib/core/routes/route_names.dart
class RouteNames {
  // Onboarding & Auth
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String roleSelection = '/role-selection';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String realContentEntry = '/data-entry';
  static const String emailVerification = "/email-verification";
  static const String fakeInstitutionDataEntrySc =
      "/fake-institution-data-entry";
  static const String fakeUserDataEntrySc = "/fake-user-data-entry";
  static const String fakeRecomendationDataEntrySc =
      "/fake-recommendation-data-entry";

  // Main App - Student
  static const String home = '/home';
  static const String gradeSelection = '/grade-selection';

  // Lessons
  static const String lessons = '/lessons';
  static const String lessonDetail = '/lessons/:id';
  static const String lessonsByGrade = '/lessons/grade/:grade';
  static const String lessonsByTopic = '/lessons/topic/:topic';

  // Quizzes & Practice
  static const String quiz = '/quiz/:id';
  static const String quizResult = '/quiz/:id/result';
  static const String practice = '/practice';
  static const String practiceByTopic = '/practice/topic/:topic';

  // Progress & Analytics
  static const String progress = '/progress';
  static const String analytics = '/analytics';
  static const String achievements = '/achievements';
  static const String recommendations = '/recommendations';

  // Profile & Settings
  static const String profile = '/profile';
  static const String editProfile = '/profile/edit';
  static const String settings = '/settings';
  static const String language = '/settings/language';
  static const String notifications = '/settings/notifications';
  static const String about = '/settings/about';
  static const String help = '/settings/help';

  // Teacher Dashboard
  static const String teacherDashboard = '/teacher/dashboard';
  static const String teacherHome = '/teacher/home';
  static const String classList = '/teacher/classes';
  static const String classDetail = '/teacher/class/:id';
  static const String studentList = '/teacher/students';
  static const String studentDetail = '/teacher/student/:id';
  static const String classAnalytics = '/teacher/analytics/:classId';
  static const String assignQuiz = '/teacher/assign-quiz';

  // School/Institution Management
  static const String schoolRegistration = '/school/register';
  static const String schoolSelection = '/school/select';
  static const String schoolDetail = '/school/:id';

  // Search & Filter
  static const String search = '/search';
  static const String searchResults = '/search/results';

  // Error & Misc
  static const String error = '/error';
  static const String maintenance = '/maintenance';
  static const String noInternet = '/no-internet';

  // Prevent instantiation
  RouteNames._();
}
