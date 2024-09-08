import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../entity/report/attendoffice_status.dart';
import '../../../entity/report/injury_status.dart';
import '../../../models/firestoreuser.dart';
import '../../../models/notification/notification.dart';
import '../../../models/profile.dart';
import '../../../models/report/report.dart';
import 'firestoreuser_notifier.dart';

import 'package:rxdart/rxdart.dart';

part 'users_who_did_not_answered_notifier.g.dart';

@riverpod
class StreamAnsOrNotAnsNotificationCombinedNotifier extends _$StreamAnsOrNotAnsNotificationCombinedNotifier {
  @override
  Stream<Map<String, List<Map<String, dynamic>>>> build(String notiId) {
    // Stream for users who have answered the notification
final answeredStream = FirebaseFirestore.instance
    .collection("notifications")
    .doc(notiId)
    .collection("reports")
    .snapshots()
    .asyncMap((reportSnapshot) async {
      List<Map<String, dynamic>> answeredUsers = [];

      for (var reportDoc in reportSnapshot.docs) {
        // Retrieve the report details
        final reportData = reportDoc.data();
        final report = Report.fromJson(reportData);

        final injuryStatusDetails = getInjuryStatusTypeDetailsBySortNumber(report.injuryStatus);
        final attendOfficeStatusDetails = getAttendOfficeStatusTypeDetailsBySortNumber(report.attendOfficeStatus);

        // Retrieve the user details for the report
        final userDoc = await FirebaseFirestore.instance
            .collection("users")
            .doc(report.uid) // Use uid from the report
            .get();
        // // Also retreive the user profile details for the report
        final profileDoc = await FirebaseFirestore.instance
          .collection("users")
          .doc(report.uid)
          .collection("profiles")
          .doc(report.uid)
          .get();

        if (userDoc.exists && profileDoc.exists) {
          final user = FirestoreUser.fromJson(userDoc.data()!);
          final profile = Profile.fromJson(profileDoc.data()!);

          answeredUsers.add({
            'user': user,
            'profile': profile,
            'answered': true, // Mark as answered
            'report': {
              'uid': report.uid,
              'injuryStatus': injuryStatusDetails?['displayName'],
              'attendOfficeStatus': attendOfficeStatusDetails?['displayName'],
              'location': report.location,
              'message': report.message,
              'isConfirmed': report.isConfirmed,
              'createdAt': report.createdAt,
              'updatedAt': report.updatedAt,
            }
          });
        }
      }

      return answeredUsers;
    });

    // Stream for users who have not answered the notification
    final notAnsweredStream = FirebaseFirestore.instance
        .collection("users")
        .snapshots()
        .asyncMap((userSnapshot) async {
          List<Map<String, dynamic>> notAnsweredUsers = [];

          for (var userDoc in userSnapshot.docs) {
            // Check if the user has a report in the specific notification's "reports" sub-collection
            final reportDoc = await FirebaseFirestore.instance
                .collection("notifications")
                .doc(notiId)
                .collection("reports")
                .doc(userDoc.id) // Check by userId
                .get();
            // // Also retreive the user profile details for the report
            final profileDoc = await FirebaseFirestore.instance
              .collection("users")
              .doc(userDoc.id)
              .collection("profiles")
              .doc(userDoc.id)
              .get();

            // If no report exists, the user hasn't answered
            if (!reportDoc.exists && profileDoc.exists) {
              final user = FirestoreUser.fromJson(userDoc.data()!);
              final profile = Profile.fromJson(profileDoc.data()!);

              notAnsweredUsers.add({
                'user': user,
                'profile': profile,
                'answered': false, // Mark as not answered
              });
            }
          }

          return notAnsweredUsers;
        });

    return CombineLatestStream.combine2<List<Map<String, dynamic>>, List<Map<String, dynamic>>, Map<String, List<Map<String, dynamic>>>>(
      answeredStream,
      notAnsweredStream,
      (answered, notAnswered) => {
        'answered': answered,
        'notAnswered': notAnswered,
      },
    );
  }
}
