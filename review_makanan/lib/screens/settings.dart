import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:review_makanan/providers/theme_notifier.dart';
import 'package:review_makanan/screens/signin.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool isNotificationEnabled = false;

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Setting', style: TextStyle(color: Colors.white)),
        ),
        leading: IconButton(
          icon:
              const Icon(Icons.keyboard_backspace_rounded, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: const Text('Mode Gelap',
                  style: TextStyle(color: Colors.blue)),
              trailing: Switch(
                value: themeNotifier.isDarkMode,
                onChanged: (bool value) {
                  themeNotifier.toggleTheme();
                },
              ),
            ),
            const SizedBox(height: 20),
            Center(
                child: ElevatedButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                minimumSize: Size(200, 50),
              ),
              child: const Text('Logout'),
            )),
          ],
        ),
      ),
    );
  }
}
