import 'dart:io' as io;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:review_makanan/models/restaurant.dart';
import 'package:path/path.dart' as path;

class RestaurantService {
  static final FirebaseFirestore _database = FirebaseFirestore.instance;
  static final CollectionReference _RestaurantCollection =
      _database.collection('Restorant');
  static final FirebaseStorage _storage = FirebaseStorage.instance;

  static Future<void> addRestaurant(Restaurant restaurant) async {
    Map<String, dynamic> newRestaurant = {
      'nama': restaurant.nama,
      'alamat': restaurant.alamat,
      'image_url': restaurant.imageUrl,
      'created_at': FieldValue.serverTimestamp(),
      'updated_at': FieldValue.serverTimestamp(),
    };
    await _RestaurantCollection.add(newRestaurant);
  }

  static Stream<List<Restaurant>> getRestaurantList() {
    return _RestaurantCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Restaurant(
          id: doc.id,
          nama: data['nama'],
          alamat: data['alamat'],
          imageUrl: data['image_url'],
          createdAt: data['created_at'] != null
              ? data['created_at'] as Timestamp
              : null,
          updatedAt: data['updated_at'] != null
              ? data['updated_at'] as Timestamp
              : null,
        );
      }).toList();
    });
  }

  static Future<void> updateRestaurant(Restaurant restaurant) async {
    Map<String, dynamic> updatedRestaurant = {
      'nama': restaurant.nama,
      'alamat': restaurant.alamat,
      'image_url': restaurant.imageUrl,
      'created_at': restaurant.createdAt,
      'updated_at': FieldValue.serverTimestamp(),
    };
    await _RestaurantCollection.doc(restaurant.id).update(updatedRestaurant);
  }

  static Future<void> deleteRestaurant(Restaurant restaurant) async {
    await _RestaurantCollection.doc(restaurant.id).delete();
  }

  static Future<String?> uploadImage(XFile imageFile) async {
    try {
      String fileName = path.basename(imageFile.path);
      Reference ref = _storage.ref().child('image/$fileName');
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