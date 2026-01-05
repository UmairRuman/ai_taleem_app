// Path: lib/core/presentation/providers/recommendations_provider.dart
import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taleem_ai/core/di/injection_container.dart';
import 'package:taleem_ai/core/domain/entities/recommendation_item.dart';

final recommendationsProvider =
    NotifierProvider<RecommendationsStateController, RecommendationsStates>(
      RecommendationsStateController.new,
    );

class RecommendationsStateController extends Notifier<RecommendationsStates> {
  @override
  RecommendationsStates build() {
    return RecommendationsInitialState();
  }

  Future<void> getAllRecommendationItems(String userId) async {
    state = RecommendationsLoadingState();
    try {
      final repo = ref.read(recommendationsRepositoryProvider);
      final items = await repo.getAllRecommendationItems(userId);
      state = RecommendationsLoadedState(items: items);
    } catch (e) {
      state = RecommendationsErrorState(error: e.toString());
      log("Error in getting recommendation items: ${e.toString()}");
    }
  }

  Future<void> getRecommendationItem(
    String userId,
    String recommendationId,
  ) async {
    state = RecommendationsLoadingState();
    try {
      final repo = ref.read(recommendationsRepositoryProvider);
      final item = await repo.getRecommendationItem(userId, recommendationId);
      state =
          item != null
              ? RecommendationsSingleLoadedState(item: item)
              : RecommendationsErrorState(
                error: 'Recommendation item not found',
              );
    } catch (e) {
      state = RecommendationsErrorState(error: e.toString());
      log("Error in getting recommendation item: ${e.toString()}");
    }
  }

  Future<void> addRecommendationItem(
    String userId,
    RecommendationItem item,
  ) async {
    try {
      final repo = ref.read(recommendationsRepositoryProvider);
      await repo.addRecommendationItem(userId, item);
      await getAllRecommendationItems(userId); // Refresh list
    } catch (e) {
      state = RecommendationsErrorState(error: e.toString());
      log("Error in adding recommendation item: ${e.toString()}");
    }
  }

  Future<void> updateRecommendationItem(
    String userId,
    RecommendationItem item,
  ) async {
    try {
      final repo = ref.read(recommendationsRepositoryProvider);
      await repo.updateRecommendationItem(userId, item);
      await getAllRecommendationItems(userId); // Refresh list
    } catch (e) {
      state = RecommendationsErrorState(error: e.toString());
      log("Error in updating recommendation item: ${e.toString()}");
    }
  }

  Future<void> deleteRecommendationItem(
    String userId,
    String recommendationId,
  ) async {
    try {
      final repo = ref.read(recommendationsRepositoryProvider);
      await repo.deleteRecommendationItem(userId, recommendationId);
      await getAllRecommendationItems(userId); // Refresh list
    } catch (e) {
      state = RecommendationsErrorState(error: e.toString());
      log("Error in deleting recommendation item: ${e.toString()}");
    }
  }

  Future<void> dismissRecommendation(
    String userId,
    String recommendationId,
  ) async {
    try {
      final repo = ref.read(recommendationsRepositoryProvider);
      await repo.dismissRecommendation(userId, recommendationId);
      await getAllRecommendationItems(userId); // Refresh list
    } catch (e) {
      state = RecommendationsErrorState(error: e.toString());
      log("Error in dismissing recommendation: ${e.toString()}");
    }
  }

  Future<void> getHighPriorityRecommendations(String userId) async {
    state = RecommendationsLoadingState();
    try {
      final repo = ref.read(recommendationsRepositoryProvider);
      final items = await repo.getHighPriorityRecommendations(userId);
      state = RecommendationsLoadedState(items: items);
    } catch (e) {
      state = RecommendationsErrorState(error: e.toString());
      log("Error in getting high priority recommendations: ${e.toString()}");
    }
  }
}

abstract class RecommendationsStates {}

class RecommendationsInitialState extends RecommendationsStates {}

class RecommendationsLoadingState extends RecommendationsStates {}

class RecommendationsLoadedState extends RecommendationsStates {
  final List<RecommendationItem> items;
  RecommendationsLoadedState({required this.items});
}

class RecommendationsSingleLoadedState extends RecommendationsStates {
  final RecommendationItem item;
  RecommendationsSingleLoadedState({required this.item});
}

class RecommendationsErrorState extends RecommendationsStates {
  final String error;
  RecommendationsErrorState({required this.error});
}
