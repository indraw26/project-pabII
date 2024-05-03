import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:review_makanan/screens/detail.dart';
import 'package:review_makanan/screens/favorite.dart';
import 'package:review_makanan/screens/home.dart';
import 'package:review_makanan/screens/signin.dart';
import 'package:review_makanan/screens/profile.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:review_makanan/screens/signup.dart';
import 'firebase_options.dart';

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Review Makanan",
        theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.pink.shade100,
              primary: Colors.black ,
              secondary: Colors.white
              ),
            useMaterial3: true),
        home: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasData) {
                return LoginScreen();
              } else if (snapshot.hasError) {
                return const MaterialApp(
                  home: Text("Terjadi Kesalahan"),
                );
              } else {
                return LoginScreen();
              }
            }));
  }
}
