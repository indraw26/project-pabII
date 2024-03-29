import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Review Makanan',
            style: TextStyle(color: Colors.white),
            ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.all(12.0),
            child: Icon(Icons.settings, color: Colors.white),),
        ],
        leading: Padding(
          padding: EdgeInsets.all(12.0),
          child: Icon(Icons.menu, color: Colors.white),
          ),
      backgroundColor: Color(0xfffc88ff),
      ),
      body: Center(
        child: Text('Home Screen'),
      ),
    );
  }
}
