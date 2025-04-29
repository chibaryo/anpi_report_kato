import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../../models/firestore/topic/topic.dart';

// Create a provider for your repository
import 'package:hooks_riverpod/hooks_riverpod.dart';

final topicRepositoryProvider = Provider<TopicRepository>((ref) {
  return TopicRepository();
});

// Repository
class TopicRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

// Create - Add new topic with auto-incremented sortNumber and proper bitMaskNum
  Future<void> createTopic(Topic topic) async {
    try {
// Get current maximum sortNumber to auto-increment
      final maxSortQuery = await _firestore
          .collection('topics')
          .orderBy('sortNumber', descending: true)
          .limit(1)
          .get();

      final currentMaxSort = maxSortQuery.docs.isNotEmpty
          ? maxSortQuery.docs.first.data()['sortNumber'] as int
          : 0;

// Calculate next sortNumber and bitMaskNum
      final newSortNumber = currentMaxSort + 1;
      final newBitMaskNum = 1 << (newSortNumber - 1); // 1, 2, 4, 8, 16...

      final newTopic = topic.copyWith(
        sortNumber: newSortNumber,
        bitMaskNum: newBitMaskNum,
      );

      await _firestore.collection('topics').add(newTopic.toJson());
      debugPrint('Created new topic with sortNumber: $newSortNumber');
    } catch (e) {
      debugPrint('Error creating topic: $e');
      rethrow;
    }
  }

// Read - Get all active topics (existing implementation)
  Future<List<Topic>> getActiveTopics() async {
    try {
      final snapshot = await _firestore
          .collection('topics')
          .where('isActive', isEqualTo: true)
          .orderBy('sortNumber')
          .get();

      return snapshot.docs.map((doc) => Topic.fromJson(doc.data())).toList();
    } catch (e) {
      debugPrint('Error fetching topics: $e');
      rethrow;
    }
  }

// Read - Get single topic by sortNumber
  Future<Topic?> getTopicBySortNumber(int sortNumber) async {
    try {
      final snapshot = await _firestore
          .collection('topics')
          .where('sortNumber', isEqualTo: sortNumber)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) return null;
      return Topic.fromJson(snapshot.docs.first.data());
    } catch (e) {
      debugPrint('Error fetching topic by sortNumber: $e');
      rethrow;
    }
  }

// Update - Modify existing topic by sortNumber
  Future<void> updateTopicBySortNumber(
      int sortNumber, Topic updatedTopic) async {
    try {
      final query = await _firestore
          .collection('topics')
          .where('sortNumber', isEqualTo: sortNumber)
          .limit(1)
          .get();

      if (query.docs.isEmpty) {
        throw Exception('Topic with sortNumber $sortNumber not found');
      }

      await query.docs.first.reference.update(updatedTopic.toJson());
      debugPrint('Updated topic with sortNumber: $sortNumber');
    } catch (e) {
      debugPrint('Error updating topic: $e');
      rethrow;
    }
  }

// Delete - Remove topic by sortNumber (soft delete by setting isActive to false)
  Future<void> deleteTopicBySortNumber(int sortNumber) async {
    try {
      final query = await _firestore
          .collection('topics')
          .where('sortNumber', isEqualTo: sortNumber)
          .limit(1)
          .get();

      if (query.docs.isEmpty) {
        throw Exception('Topic with sortNumber $sortNumber not found');
      }

// Soft delete by setting isActive to false
      await query.docs.first.reference.update({'isActive': false});
      debugPrint('Soft-deleted topic with sortNumber: $sortNumber');
    } catch (e) {
      debugPrint('Error deleting topic: $e');
      rethrow;
    }
  }

// Optional: Hard delete (completely remove document)
  Future<void> hardDeleteTopicBySortNumber(int sortNumber) async {
    try {
      final query = await _firestore
          .collection('topics')
          .where('sortNumber', isEqualTo: sortNumber)
          .limit(1)
          .get();

      if (query.docs.isEmpty) {
        throw Exception('Topic with sortNumber $sortNumber not found');
      }

      await query.docs.first.reference.delete();
      debugPrint('Hard-deleted topic with sortNumber: $sortNumber');
    } catch (e) {
      debugPrint('Error hard deleting topic: $e');
      rethrow;
    }
  }
}
