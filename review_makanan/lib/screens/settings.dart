import 'package:flutter/material.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool isDarkMode = false;
  bool isNotificationEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Setting', style: TextStyle(color: Colors.white)),
        ),
        leading: IconButton(
          icon: const Icon(Icons.keyboard_backspace_rounded, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: const Color(0xfffc88ff),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: const Text('Mode Gelap', style: TextStyle(color: Colors.blue)),
              trailing: Switch(
                value: isDarkMode,
                onChanged: (bool value) {
                  setState(() {
                    isDarkMode = value;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text('Notifikasi', style: TextStyle(color: Colors.blue)),
              trailing: Switch(
                value: isNotificationEnabled,
                onChanged: (bool value) {
                  setState(() {
                    isNotificationEnabled = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: TextButton(
                onPressed: () {
                  // Add logout functionality here
                },
                child: const Text(
                  'Logout',
                  style: TextStyle(color: Colors.red, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
