import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:review_makanan/models/menu.dart';

class FavoriteService {
  static Future<void> addFavorite(String userId, MenuItem menuItem) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('favorites')
          .add(menuItem.toMap());
    } catch (e) {
      print('Error adding favorite: $e');
    }
  }
}