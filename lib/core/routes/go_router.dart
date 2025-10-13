// lib/core/routes/app_router.dart
import 'package:go_router/go_router.dart';
import 'package:taleem_ai/features/admin/data_entry_screen.dart';
import 'package:taleem_ai/features/admin/fake_data_entry/recommendation_data_entry_screen.dart';
import 'package:taleem_ai/features/admin/presentation/screens/admin_panel_screen.dart';
import 'package:taleem_ai/features/auth/presentation/screens/email_verification_screen.dart';
import 'package:taleem_ai/features/auth/presentation/screens/forgot_pass_screen.dart';
import 'package:taleem_ai/features/guardian/presentation/screens/student_dashboard_screen.dart';
import 'package:taleem_ai/features/learning/presentation/screens/concept_detail_screen.dart';
import 'package:taleem_ai/features/learning/presentation/screens/concept_quiz_screen.dart';
import 'package:taleem_ai/features/learning/presentation/screens/course_content_list_screen.dart';
import 'package:taleem_ai/features/learning/presentation/screens/course_search_screen.dart';

import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/role_selection_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/onboarding/presentation/screens/splash_screen.dart';
import 'route_names.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: RouteNames.splash,
  routes: [
    GoRoute(
      path: RouteNames.splash,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: RouteNames.onboarding,
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: RouteNames.roleSelection,
      builder: (context, state) => const RoleSelectionScreen(),
    ),
    GoRoute(
      path: RouteNames.login,
      builder: (context, state) {
        final role = state.uri.queryParameters['role'] ?? 'student';
        return LoginScreen(role: role);
      },
    ),
    GoRoute(
      path: RouteNames.register,
      builder: (context, state) {
        final role = state.uri.queryParameters['role'] ?? 'student';
        return RegisterScreen(role: role);
      },
    ),
    GoRoute(
      path: RouteNames.forgotPassword,
      builder: (context, state) => ForgotPasswordScreen(),
    ),

    GoRoute(
      path: RouteNames.emailVerification,
      builder:
          (context, state) =>
              EmailVerificationScreen(email: "programmerumair29@gmail.com"),
    ),

    // Add this route:
    GoRoute(
      path: RouteNames.studentDashboard,
      builder: (context, state) => const StudentDashboardScreen(),
    ),
    // Real Content Entry Screen
    GoRoute(
      path: RouteNames.realContentEntry,
      builder: (context, state) => DataEntryScreen(),
    ),

    GoRoute(
      path: RouteNames.adminPanel,
      builder: (context, state) => AdminPanelScreen(),
    ),

    // Fake Data Entry Screens for Admin
    // GoRoute(
    //   path: RouteNames.fakeInstitutionDataEntrySc,

    //   builder: (context, state) => const InstitutionDataEntryScreen(),
    // ),
    GoRoute(
      path: RouteNames.fakeRecomendationDataEntrySc,
      builder: (context, state) => const RecommendationDataEntryScreen(),
    ),
    // GoRoute(
    //   path: RouteNames.fakeUserDataEntrySc,
    //   builder: (context, state) => const UserDataEntryScreen(),
    // ),
    GoRoute(
      path: RouteNames.courseSearchScreen,
      name: 'courseSearch',
      builder: (context, state) => const CourseSearchScreen(),
    ),

    // Content Screens
    GoRoute(
      path: RouteNames.courseContentListScreen,
      builder: (context, state) {
        final grade = int.tryParse(state.uri.queryParameters['grade'] ?? '6');
        return CourseContentListScreen(initialGrade: grade);
      },
    ),
    GoRoute(
      path: '${RouteNames.conceptDetailScreen}/:conceptId',
      name: 'conceptDetail',
      builder: (context, state) {
        final conceptId = state.pathParameters['conceptId']!;
        return ConceptDetailScreen(conceptId: conceptId);
      },
    ),
    GoRoute(
      path: '${RouteNames.conceptQuizScreen}/:conceptId',
      name: 'conceptQuiz',
      builder: (context, state) {
        final conceptId = state.pathParameters['conceptId']!;
        return ConceptQuizScreen(conceptId: conceptId);
      },
    ),
  ],
);
