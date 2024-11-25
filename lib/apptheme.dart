import 'package:flutter/material.dart';

final ThemeData appTheme = ThemeData(
  primarySwatch: Colors.blue,
  scaffoldBackgroundColor: Colors.blue.shade50,
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.blue.shade700,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      elevation: 5,
    ),
  ),
  textTheme: const TextTheme(
    titleLarge: TextStyle(
        fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
    bodyLarge: TextStyle(
        fontSize: 16, fontWeight: FontWeight.normal, color: Colors.black),
  ),
);
