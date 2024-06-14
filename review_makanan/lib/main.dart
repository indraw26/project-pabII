import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:review_makanan/screens/home.dart';
import 'package:review_makanan/screens/signin.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:review_makanan/providers/theme_notifier.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeNotifier(),
      child: Consumer<ThemeNotifier>(
        builder: (context, themeNotifier, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: "Review Makanan",
            theme: themeNotifier.currentTheme,
            home: StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasData) {
                  return const LoginScreen();
                } else if (snapshot.hasError) {
                  return const MaterialApp(
                    home: Scaffold(
                      body: Center(
                        child: Text("Terjadi Kesalahan"),
                      ),
                    ),
                  );
                } else {
                  return const LoginScreen();
                }
              },
            ),
          );
        },
      ),
    );
  }
}
