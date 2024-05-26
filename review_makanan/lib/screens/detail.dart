import 'package:flutter/material.dart';
import 'package:review_makanan/models/restaurant.dart';

class DetailScreen extends StatefulWidget {
  final Restaurant? resto;
  const DetailScreen({super.key, this.resto});
  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Halo'),
    );
  }
}