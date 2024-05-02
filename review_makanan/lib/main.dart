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

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    FavoriteScreen(),
    ProfileScreen(),
  ];

  void _selectedNavMenu(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Color(0xfffc88ff),
        currentIndex: _selectedIndex,
        onTap: _selectedNavMenu,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Favorite")
        ],
      ),
    );
  }
}