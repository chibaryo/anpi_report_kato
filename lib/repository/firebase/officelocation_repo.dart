import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../../models/firestore/officelocation/officelocation.dart';

// Create a provider for your repository
import 'package:hooks_riverpod/hooks_riverpod.dart';

final officeLocationRepositoryProvider = Provider<OfficeLocationRepository>((ref) {
  return OfficeLocationRepository();
});

// Repository
class OfficeLocationRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

// Create - Add new officeLocation with auto-incremented sortNumber and proper bitMaskNum
  Future<void> createOfficeLocation(OfficeLocation officeLocation) async {
    try {
// Get current maximum sortNumber to auto-increment
      final maxSortQuery = await _firestore
          .collection('officeLocations')
          .orderBy('sortNumber', descending: true)
          .limit(1)
          .get();

      final currentMaxSort = maxSortQuery.docs.isNotEmpty
          ? maxSortQuery.docs.first.data()['sortNumber'] as int
          : 0;

// Calculate next sortNumber and bitMaskNum
      final newSortNumber = currentMaxSort + 1;
      //final newBitMaskNum = 1 << (newSortNumber - 1); // 1, 2, 4, 8, 16...

      final newOfficeLocation = officeLocation.copyWith(
        sortNumber: newSortNumber,
      );

      await _firestore.collection('officeLocations').add(newOfficeLocation.toJson());
      debugPrint('Created new officeLocation with sortNumber: $newSortNumber');
    } catch (e) {
      debugPrint('Error creating officeLocation: $e');
      rethrow;
    }
  }

// Read - Get all active officeLocations (existing implementation)
  Future<List<OfficeLocation>> getActiveOfficeLocations() async {
    try {
      final snapshot = await _firestore
          .collection('officeLocations')
          .where('isActive', isEqualTo: true)
          .orderBy('sortNumber')
          .get();

      return snapshot.docs.map((doc) => OfficeLocation.fromJson(doc.data())).toList();
    } catch (e) {
      debugPrint('Error fetching officeLocations: $e');
      rethrow;
    }
  }

// Read - Get single officeLocation by sortNumber
  Future<OfficeLocation?> getOfficeLocationBySortNumber(int sortNumber) async {
    try {
      final snapshot = await _firestore
          .collection('officeLocations')
          .where('sortNumber', isEqualTo: sortNumber)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) return null;
      return OfficeLocation.fromJson(snapshot.docs.first.data());
    } catch (e) {
      debugPrint('Error fetching officeLocation by sortNumber: $e');
      rethrow;
    }
  }

// Update - Modify existing officeLocation by sortNumber
  Future<void> updateOfficeLocationBySortNumber(
      int sortNumber, OfficeLocation updatedOfficeLocation) async {
    try {
      final query = await _firestore
          .collection('officeLocations')
          .where('sortNumber', isEqualTo: sortNumber)
          .limit(1)
          .get();

      if (query.docs.isEmpty) {
        throw Exception('OfficeLocation with sortNumber $sortNumber not found');
      }

      await query.docs.first.reference.update(updatedOfficeLocation.toJson());
      debugPrint('Updated officeLocation with sortNumber: $sortNumber');
    } catch (e) {
      debugPrint('Error updating officeLocation: $e');
      rethrow;
    }
  }

// Delete - Remove officeLocation by sortNumber (soft delete by setting isActive to false)
  Future<void> deleteOfficeLocationBySortNumber(int sortNumber) async {
    try {
      final query = await _firestore
          .collection('officeLocations')
          .where('sortNumber', isEqualTo: sortNumber)
          .limit(1)
          .get();

      if (query.docs.isEmpty) {
        throw Exception('OfficeLocation with sortNumber $sortNumber not found');
      }

// Soft delete by setting isActive to false
      await query.docs.first.reference.update({'isActive': false});
      debugPrint('Soft-deleted officeLocation with sortNumber: $sortNumber');
    } catch (e) {
      debugPrint('Error deleting officeLocation: $e');
      rethrow;
    }
  }

// Optional: Hard delete (completely remove document)
  Future<void> hardDeleteOfficeLocationBySortNumber(int sortNumber) async {
    try {
      final query = await _firestore
          .collection('officeLocations')
          .where('sortNumber', isEqualTo: sortNumber)
          .limit(1)
          .get();

      if (query.docs.isEmpty) {
        throw Exception('OfficeLocation with sortNumber $sortNumber not found');
      }

      await query.docs.first.reference.delete();
      debugPrint('Hard-deleted officeLocation with sortNumber: $sortNumber');
    } catch (e) {
      debugPrint('Error hard deleting officeLocation: $e');
      rethrow;
    }
  }
}
