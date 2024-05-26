import 'package:cloud_firestore/cloud_firestore.dart';

class Restaurant{
  String? id;
  final String nama;
  final String alamat;
  String? imageUrl;
  Timestamp? createdAt;
  Timestamp? updatedAt;

  Restaurant({
    this.id,
    required this.nama,
    required this.alamat,
    this.imageUrl,
    this.createdAt,
    this.updatedAt,
  });

  factory Restaurant.fromDocument(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Restaurant(
      id: doc.id,
      nama: data['nama'],
      alamat: data['alamat'],
      imageUrl: data['image_url'],
      createdAt: data['created_at'] as Timestamp,
      updatedAt: data['updated_at'] as Timestamp,
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      'nama': nama,
      'alamat': alamat,
      'image_url': imageUrl,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}