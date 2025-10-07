// Path: lib/core/data/repositories/recommendations_repository.dart
import 'package:taleem_ai/core/data/collections/recommendations_collection.dart';
import 'package:taleem_ai/core/domain/entities/recommendation_item.dart';

class RecommendationsRepository {
  final RecommendationsCollection _recommendationsCollection =
      RecommendationsCollection.instance;

  Future<bool> addRecommendationItem(
    String userId,
    RecommendationItem item,
  ) async {
    return await _recommendationsCollection.addRecommendationItem(userId, item);
  }

  Future<bool> updateRecommendationItem(
    String userId,
    RecommendationItem item,
  ) async {
    return await _recommendationsCollection.updateRecommendationItem(
      userId,
      item,
    );
  }

  Future<bool> deleteRecommendationItem(
    String userId,
    String recommendationId,
  ) async {
    return await _recommendationsCollection.deleteRecommendationItem(
      userId,
      recommendationId,
    );
  }

  Future<RecommendationItem?> getRecommendationItem(
    String userId,
    String recommendationId,
  ) async {
    return await _recommendationsCollection.getRecommendationItem(
      userId,
      recommendationId,
    );
  }

  Future<List<RecommendationItem>> getAllRecommendationItems(
    String userId,
  ) async {
    return await _recommendationsCollection.getAllRecommendationItems(userId);
  }

  Future<bool> dismissRecommendation(
    String userId,
    String recommendationId,
  ) async {
    return await _recommendationsCollection.dismissRecommendation(
      userId,
      recommendationId,
    );
  }

  Future<List<RecommendationItem>> getHighPriorityRecommendations(
    String userId,
  ) async {
    return await _recommendationsCollection.getHighPriorityRecommendations(
      userId,
    );
  }
}
