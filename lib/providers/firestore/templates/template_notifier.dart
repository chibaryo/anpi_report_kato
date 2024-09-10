import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../models/template/template.dart';

part 'template_notifier.g.dart';

@riverpod
class StreamTemplateNotifier extends  _$StreamTemplateNotifier {
  @override
  Stream<List<Map<String, dynamic>>> build() async* {
    yield* FirebaseFirestore.instance
      .collection("notitemplates")
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) {
        final template = Template.fromJson(doc.data());
        return {
          'template': template,
          'docId': doc.id,
        };
      }).toList());
  }

  // Get a Report by UID
  Future<Template?> getTemplateById(String id) async {
    try {
      final doc = await FirebaseFirestore.instance
        .collection("notitemplates")
        .doc(id)
        .get();
    
      if (doc.exists) {
        return Template.fromJson(doc.data()!);
      } else {
        return null;
      }
    } catch (err) {
      //
      return null;
    }
  }

  // Add a new record
  Future<void> addTemplate(String id, Template template) async {
    try {
      await FirebaseFirestore.instance
        .collection("notitemplates")
        .doc(id)
        .set(template.toJson());
    } catch (e) {
      // Handle any errors here, such as logging
    }
  }

  // Update an existing  record
  Future<void> updateTemplate(String id, Map<String, dynamic> updates) async {
    try {
      await FirebaseFirestore.instance
        .collection("notitemplates")
        .doc(id)
        .set(updates, SetOptions(merge: true));
    } catch (e) {
      // Handle any errors here, such as logging
    }
  }

  Future<void> deleteTemplate(String id) async {
    try {
      await FirebaseFirestore.instance
        .collection("notitemplates")
        .doc(id)
        .delete();
    } catch (e) {
      //
    }
  }
}
