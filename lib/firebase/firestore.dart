import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreAPI {
  Stream<QuerySnapshot<Map<String, dynamic>>> getWatchlistForUser() {
    return FirebaseFirestore.instance.collection("/users").snapshots();
  }
}
