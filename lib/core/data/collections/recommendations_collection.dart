// Path: lib/core/data/collections/recommendations_collection.dart
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taleem_ai/core/domain/entities/recommendation_item.dart'; // Assuming entity path

class RecommendationsCollection {
  static final RecommendationsCollection instance =
      RecommendationsCollection._internal();
  RecommendationsCollection._internal();
  static const String recommendationsCollection = 'recommendations';
  static const String itemsSubcollection = 'items';
  factory RecommendationsCollection() {
    return instance;
  }

  Future<bool> addRecommendationItem(
    String userId,
    RecommendationItem item,
  ) async {
    try {
      await FirebaseFirestore.instance
          .collection(recommendationsCollection)
          .doc(userId)
          .collection(itemsSubcollection)
          .doc(item.id)
          .set(item.toMap());
      log('Recommendation item added for user $userId, item ${item.id}');
      return true;
    } catch (e) {
      log("Error adding recommendation item: $e");
      return false;
    }
  }

  Future<bool> updateRecommendationItem(
    String userId,
    RecommendationItem item,
  ) async {
    try {
      await FirebaseFirestore.instance
          .collection(recommendationsCollection)
          .doc(userId)
          .collection(itemsSubcollection)
          .doc(item.id)
          .update(item.toMap());
      log('Recommendation item updated for user $userId, item ${item.id}');
      return true;
    } catch (e) {
      log("Error updating recommendation item: $e");
      return false;
    }
  }

  Future<bool> deleteRecommendationItem(
    String userId,
    String recommendationId,
  ) async {
    try {
      await FirebaseFirestore.instance
          .collection(recommendationsCollection)
          .doc(userId)
          .collection(itemsSubcollection)
          .doc(recommendationId)
          .delete();
      log(
        'Recommendation item deleted for user $userId, item $recommendationId',
      );
      return true;
    } catch (e) {
      log("Error deleting recommendation item: $e");
      return false;
    }
  }

  Future<RecommendationItem?> getRecommendationItem(
    String userId,
    String recommendationId,
  ) async {
    try {
      DocumentSnapshot snapshot =
          await FirebaseFirestore.instance
              .collection(recommendationsCollection)
              .doc(userId)
              .collection(itemsSubcollection)
              .doc(recommendationId)
              .get();
      if (snapshot.exists) {
        return RecommendationItem.fromMap(
          snapshot.data() as Map<String, dynamic>,
        );
      }
      log(
        'Recommendation item not found for user $userId, item $recommendationId',
      );
      return null;
    } catch (e) {
      log("Error getting recommendation item: $e");
      return null;
    }
  }

  Future<List<RecommendationItem>> getAllRecommendationItems(
    String userId,
  ) async {
    List<RecommendationItem> items = [];
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance
              .collection(recommendationsCollection)
              .doc(userId)
              .collection(itemsSubcollection)
              .get();
      for (var doc in snapshot.docs) {
        items.add(
          RecommendationItem.fromMap(doc.data() as Map<String, dynamic>),
        );
      }
      log('Fetched ${items.length} recommendation items for user $userId');
      return items;
    } catch (e) {
      log("Error getting all recommendation items: $e");
      return [];
    }
  }

  // Additional useful method: Dismiss recommendation
  Future<bool> dismissRecommendation(
    String userId,
    String recommendationId,
  ) async {
    try {
      await FirebaseFirestore.instance
          .collection(recommendationsCollection)
          .doc(userId)
          .collection(itemsSubcollection)
          .doc(recommendationId)
          .update({'dismissed': true});
      log('Dismissed recommendation for user $userId, item $recommendationId');
      return true;
    } catch (e) {
      log("Error dismissing recommendation: $e");
      return false;
    }
  }

  // Additional useful method: Get high priority recommendations
  Future<List<RecommendationItem>> getHighPriorityRecommendations(
    String userId,
  ) async {
    List<RecommendationItem> items = [];
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance
              .collection(recommendationsCollection)
              .doc(userId)
              .collection(itemsSubcollection)
              .where('priority', isEqualTo: 'high')
              .where('dismissed', isEqualTo: false)
              .get();
      for (var doc in snapshot.docs) {
        items.add(
          RecommendationItem.fromMap(doc.data() as Map<String, dynamic>),
        );
      }
      log(
        'Fetched ${items.length} high priority recommendations for user $userId',
      );
      return items;
    } catch (e) {
      log("Error getting high priority recommendations: $e");
      return [];
    }
  }
}
