// Path: lib/core/di/injection_container.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taleem_ai/core/data/repositories/concepts_repository.dart';
import 'package:taleem_ai/core/data/repositories/institutions_repository.dart';
import 'package:taleem_ai/core/data/repositories/lessons_repository.dart';
import 'package:taleem_ai/core/data/repositories/progress_repository.dart';
import 'package:taleem_ai/core/data/repositories/quiz_attempts_repository.dart';
import 'package:taleem_ai/core/data/repositories/quizzes_repository.dart';
import 'package:taleem_ai/core/data/repositories/recommendations_repository.dart';
import 'package:taleem_ai/core/data/repositories/user_repository.dart';

// Repository Providers for Dependency Injection
final userRepositoryProvider = Provider<UserRepository>(
  (ref) => UserRepository(),
);

final institutionsRepositoryProvider = Provider<InstitutionsRepository>(
  (ref) => InstitutionsRepository(),
);

final conceptsRepositoryProvider = Provider<ConceptsRepository>(
  (ref) => ConceptsRepository(),
);

final lessonsRepositoryProvider = Provider<LessonsRepository>(
  (ref) => LessonsRepository(),
);

final quizzesRepositoryProvider = Provider<QuizzesRepository>(
  (ref) => QuizzesRepository(),
);

final quizAttemptsRepositoryProvider = Provider<QuizAttemptsRepository>(
  (ref) => QuizAttemptsRepository(),
);

final progressRepositoryProvider = Provider<ProgressRepository>(
  (ref) => ProgressRepository(),
);

final recommendationsRepositoryProvider = Provider<RecommendationsRepository>(
  (ref) => RecommendationsRepository(),
);
