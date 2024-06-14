import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:review_makanan/models/menu.dart';
import 'package:review_makanan/models/profile.dart';
import 'package:review_makanan/services/profile_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

class CommentScreen extends StatefulWidget {
  final MenuItem menuItem;

  const CommentScreen({super.key, required this.menuItem});

  @override
  _CommentScreenState createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final TextEditingController _commentController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseService _firebaseService = FirebaseService();
  Future<Users?>? _currentUserFuture;
  double _currentRating = 0.0;

  @override
  void initState() {
    super.initState();
    _currentUserFuture = _loadCurrentUser();
  }

  Future<Users?> _loadCurrentUser() async {
    User? user = _auth.currentUser;
    if (user != null) {
      return await _firebaseService.getUser(user.uid);
    }
    return null;
  }

  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<void> _addComment(Users currentUser) async {
    if (_commentController.text.isEmpty || _currentRating == 0.0) return;

    try {
      Position position = await _getCurrentLocation();

      await FirebaseFirestore.instance.collection('comments').add({
        'userId': currentUser.uid,
        'userName': currentUser.name,
        'menuId': widget.menuItem.id,
        'restaurantId': widget.menuItem.restaurantId,
        'comment': _commentController.text,
        'rating': _currentRating,
        'timestamp': FieldValue.serverTimestamp(),
        'latitude': position.latitude,
        'longitude': position.longitude,
      });

      _commentController.clear();
      setState(() {
        _currentRating = 0.0;
      });
    } catch (e) {
      print("Failed to add comment: $e");
    }
  }

  Widget _buildRatingStars() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return IconButton(
          icon: Icon(
            index < _currentRating ? Icons.star : Icons.star_border,
            color: index < _currentRating ? Colors.yellow : null,
          ),
          onPressed: () {
            setState(() {
              _currentRating = index + 1.0;
            });
          },
        );
      }),
    );
  }

  void _openMap(double latitude, double longitude) async {
    final url = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comment'),
        backgroundColor: const Color(0xfffc88ff),
      ),
      body: FutureBuilder<Users?>(
        future: _currentUserFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('User not found.'));
          }

          final currentUser = snapshot.data!;

          return Column(
            children: [
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('comments')
                      .where('menuId', isEqualTo: widget.menuItem.id)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final comments = snapshot.data?.docs ?? [];

                    return ListView.builder(
                      itemCount: comments.length,
                      itemBuilder: (context, index) {
                        final comment = comments[index].data() as Map<String, dynamic>;

                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            color: const Color(0xfffccbff),
                            child: ListTile(
                              leading: const CircleAvatar(
                                backgroundColor: Colors.red,
                                child: Icon(Icons.person, color: Colors.white),
                              ),
                              title: Row(
                                children: [
                                  Text(comment['userName']),
                                  const SizedBox(width: 8),
                                  const Icon(Icons.star, color: Colors.yellow),
                                  const SizedBox(width: 4),
                                  Text(comment['rating'].toString()),
                                ],
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(comment['comment']),
                                  TextButton(
                                    onPressed: () => _openMap(comment['latitude'], comment['longitude']),
                                    child: const Text('Open in Maps'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    _buildRatingStars(),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _commentController,
                            decoration: const InputDecoration(
                              hintText: 'Add a comment...',
                            ),
                          ),
                        ),
                        FloatingActionButton(
                          onPressed: () => _addComment(currentUser),
                          child: const Icon(Icons.add),
                          backgroundColor: const Color(0xfffc88ff),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
