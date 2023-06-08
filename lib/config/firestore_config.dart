import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latihanuas/models/catatan_model.dart';

class FirestoreConfig {
  late FirebaseFirestore _db;

  FirestoreConfig() {
    _db = FirebaseFirestore.instance;
    // _db.settings = const Settings(
    //   persistenceEnabled: true,
    //   cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    // );
  }

  FirebaseFirestore getInstance() {
    return _db;
  }

  final String _collection = 'catatan';

  // Future createOrUpdateNote (
  //     String idDocument, {
  //       String? catatan,
  //       String? owner,
  //       DateTime? created_at,
  //     }) async {
  //   Map<String, dynamic> builder = {};
  //   if (catatan != null) {
  //     builder['catatan'] = catatan;
  //   }
  //   if (owner != null) {
  //     builder['owner'] = owner;
  //   }
  //   if (created_at != null) {
  //     builder['created_at'] = created_at;
  //   }
  //
  //   await _db.collection(_collection)
  //       .doc(idDocument)
  //       .set(builder, SetOptions(merge: true));
  // }
  Future createOrUpdateNote (CatatanModel model) async {
    await _db.collection(_collection)
        .doc(model.id)
        .set(model.toMap(), SetOptions(merge: true));
  }

  Future deleteNote (String idDocument) async {
    await _db.collection(_collection)
        .doc(idDocument)
        .delete();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getNotes () async {
    return await _db.collection(_collection)
        .get();
  }

}