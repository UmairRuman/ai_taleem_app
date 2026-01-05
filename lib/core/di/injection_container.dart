// Path: lib/core/di/injection_container.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taleem_ai/core/data/collections/concepts_content_collection.dart';
import 'package:taleem_ai/core/data/collections/concepts_metadata_collection.dart';
import 'package:taleem_ai/core/data/collections/institutions_collection.dart';
import 'package:taleem_ai/core/data/collections/search_index_collection.dart';
import 'package:taleem_ai/core/data/repositories/concepts_repository.dart';
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

final conceptsRepositoryProvider2 = Provider<ConceptsRepository2>(
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


final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

// ============================================
// COLLECTION PROVIDERS
// ============================================

final conceptsMetadataCollectionProvider = Provider<ConceptsMetadataCollection>((ref) {
  final firestore = ref.read(firestoreProvider);
  return ConceptsMetadataCollection(firestore: firestore);
});

final conceptsContentCollectionProvider = Provider<ConceptsContentCollection>((ref) {
  final firestore = ref.read(firestoreProvider);
  return ConceptsContentCollection(firestore: firestore);
});

final searchIndexCollectionProvider = Provider<SearchIndexCollection>((ref) {
  final firestore = ref.read(firestoreProvider);
  return SearchIndexCollection(firestore: firestore);
});

// ============================================
// REPOSITORY PROVIDER
// ============================================

final conceptsRepositoryProvider = Provider<ConceptsRepository>((ref) {
  final metadataCollection = ref.read(conceptsMetadataCollectionProvider);
  final contentCollection = ref.read(conceptsContentCollectionProvider);
  final searchIndexCollection = ref.read(searchIndexCollectionProvider);

  return ConceptsRepository(
    metadataCollection: metadataCollection,
    contentCollection: contentCollection,
    searchIndexCollection: searchIndexCollection,
  );
});