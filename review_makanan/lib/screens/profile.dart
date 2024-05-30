import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:review_makanan/screens/signin.dart';

class ProfileScreen extends StatelessWidget {
  final User? user = FirebaseAuth.instance.currentUser;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: user != null
          ? FutureBuilder<DocumentSnapshot>(
              future: _firestore.collection('users').doc(user!.uid).get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || !snapshot.data!.exists) {
                  return Center(child: Text('No user data found'));
                } else {
                  var userData = snapshot.data!.data() as Map<String, dynamic>;
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Name: ${userData['name'] ?? 'No name provided'}',
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Email: ${userData['email'] ?? 'No email provided'}',
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Nomor Telepon: ${userData['noHp'] ?? 'no Nomor Hp provided'}',
                          style: TextStyle(fontSize: 20),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            await FirebaseAuth.instance.signOut();
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => LoginScreen(),
                              ),
                            );
                          },
                          child: Text('Logout'),
                        ),
                      ],
                    ),
                  );
                }
              },
            )
          : Center(
              child: Text('No user is signed in'),
            ),
    );
  }
}
