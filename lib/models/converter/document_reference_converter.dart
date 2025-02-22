import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

class DocumentReferenceConverter
    implements JsonConverter<DocumentReference, DocumentReference> {
  const DocumentReferenceConverter();

  @override
  DocumentReference fromJson(DocumentReference docRef) => docRef;

  @override
  DocumentReference toJson(DocumentReference docRef) => docRef;
}

class DocumentReferenceStringConverter
    implements JsonConverter<String, DocumentReference> {
  const DocumentReferenceStringConverter();

  @override
  String fromJson(DocumentReference ref) => ref.id;

  @override
  DocumentReference toJson(String str) => FirebaseFirestore.instance.doc(str);
}

class DocumentReferenceNullStringConverter
    implements JsonConverter<String?, DocumentReference?> {
  const DocumentReferenceNullStringConverter();

  @override
  String? fromJson(DocumentReference? ref) => ref?.path;

  @override
  DocumentReference? toJson(String? str) =>
      str != null ? FirebaseFirestore.instance.doc(str) : null;
}