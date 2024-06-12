import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:review_makanan/models/menu.dart';

class FavoriteService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> addFavorite(MenuItem menuItem) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('favorites')
        .doc(menuItem.id)
        .set(menuItem.toMap());
  }

  static Future<void> removeFavorite(MenuItem menuItem) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('favorites')
        .doc(menuItem.id)
        .delete();
  }

  static Future<bool> isFavorite(MenuItem menuItem) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return false;
    final doc = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('favorites')
        .doc(menuItem.id)
        .get();
    return doc.exists;
  }

  static Future<List<MenuItem>> getFavorites() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return [];
    final querySnapshot = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('favorites')
        .get();
    return querySnapshot.docs
        .map((doc) => MenuItem.fromMap(doc.data(), doc.id))
        .toList();
  }
}
