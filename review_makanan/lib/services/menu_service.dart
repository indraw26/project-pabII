import 'dart:io' as io;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:review_makanan/models/menu.dart';

class MenuService {
  static final FirebaseFirestore _database = FirebaseFirestore.instance;
  static final CollectionReference _menuCollection =
      _database.collection('menuItems');
  static final FirebaseStorage _storage = FirebaseStorage.instance;

  static Future<void> addMenuItem(MenuItem menuItem) async {
    Map<String, dynamic> newMenuItem = {
      'name': menuItem.name,
      'description': menuItem.description,
      'price': menuItem.price,
      'image_url': menuItem.imageUrl,
      'restaurant_id': menuItem.restaurantId,
    };
    await _menuCollection.add(newMenuItem);
  }

  static Stream<List<MenuItem>> getMenuItemsByRestaurant(String restaurantId) {
    return _menuCollection
        .where('restaurant_id', isEqualTo: restaurantId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return MenuItem.fromMap(data, doc.id);
      }).toList();
    });
  }

  static Future<void> updateMenuItem(MenuItem menuItem) async {
    Map<String, dynamic> updateMenuItem = {
      'name': menuItem.name,
      'description': menuItem.description,
      'price': menuItem.price,
      'image_url': menuItem.imageUrl,
      'restaurant_id': menuItem.restaurantId,
    };
    await _menuCollection.doc(menuItem.id).update(updateMenuItem);
  }

  static Future<void> deleteMenuItem(String id) async {
    await _menuCollection.doc(id).delete();
  }

  static Future<String?> uploadImage(XFile imageFile) async {
    try {
      String fileName = path.basename(imageFile.path);
      Reference ref = _storage.ref().child('menu/$fileName');
      UploadTask uploadTask;

      if (kIsWeb) {
        uploadTask = ref.putData(await imageFile.readAsBytes());
      } else {
        uploadTask = ref.putFile(io.File(imageFile.path));
      }

      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      return null;
    }
  }
  
}
