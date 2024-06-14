import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  primaryColor: Colors.white,
  brightness: Brightness.light,
  appBarTheme: const AppBarTheme(
    color: Color(0xfffc88ff),
  ),
);

final ThemeData darkTheme = ThemeData(
  primaryColor: Colors.black,
  brightness: Brightness.dark,
  appBarTheme: const AppBarTheme(
    color: Colors.black,
  ),
);
