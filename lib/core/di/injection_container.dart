// Path: lib/core/di/injection_container.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taleem_ai/core/data/collections/institutions_collection.dart';
import 'package:taleem_ai/core/data/repositories/concepts_repository_2.dart';
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

// Providers for InstitutionsCollection
final institutionsCollectionProvider = Provider<InstitutionsCollection>(
  (ref) => InstitutionsCollection.instance,
);

// Providers for InstitutionRepository
final institutionRepositoryProvider = Provider<InstitutionRepository>(
  (ref) => InstitutionRepository(ref.read(institutionsCollectionProvider)),
);

final conceptsRepositoryProvider = Provider<ConceptsRepository2>(
  (ref) => ConceptsRepository2(),
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
