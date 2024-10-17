import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../models/template/template.dart';

part 'template_notifier.g.dart';

@riverpod
class StreamTemplateNotifier extends  _$StreamTemplateNotifier {
  @override
  Stream<List<Template>> build() async* {
    final snapshot = FirebaseFirestore.instance.collection('templates').snapshots();
    
    await for (final querySnapshot in snapshot) {
      yield querySnapshot.docs.map((doc) {
        return Template.fromJson(doc.data());
      }).toList();
    }
  }

  // Get a Report by UID
  Future<Template?> getTemplateById(String id) async {
    try {
      final doc = await FirebaseFirestore.instance
        .collection("templates")
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
        .collection("templates")
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
        .collection("templates")
        .doc(id)
        .set(updates, SetOptions(merge: true));
    } catch (e) {
      // Handle any errors here, such as logging
    }
  }

  Future<void> deleteTemplate(String id) async {
    try {
      await FirebaseFirestore.instance
        .collection("templates")
        .doc(id)
        .delete();
    } catch (e) {
      //
    }
  }
}
