import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:review_makanan/models/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addUser(Users user) async {
    await _firestore.collection('users').doc(user.uid).set(user.toMap());
  }

  Future<Users?> getUser(String uid) async {
    DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
    if (doc.exists) {
      return Users.fromMap(doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  Future<void> updateUser(Users user) async {
    await _firestore.collection('users').doc(user.uid).update(user.toMap());
  }

  Stream<Users?> streamUser(String uid) {
    return _firestore.collection('users').doc(uid).snapshots().map((snapshot) {
      if (snapshot.exists) {
        return Users.fromMap(snapshot.data() as Map<String, dynamic>);
      }
      return null;
    });
  }
}
