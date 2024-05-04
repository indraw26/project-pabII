import 'package:flutter/material.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Setting',style: TextStyle(color: Colors.white),),
        ),
        leading: IconButton(
          icon: const Icon(Icons.keyboard_backspace_rounded,color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: const Color(0xfffc88ff),
      ),
      body: const Center(
        child: Text('Setting Screen'),
      ),
    );
  }
}