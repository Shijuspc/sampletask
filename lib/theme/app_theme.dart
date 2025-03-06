import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: const Color.fromARGB(255, 247, 247, 247),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.blue,
    ),
    iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(foregroundColor: Colors.white)),
    textTheme: TextTheme(
      bodyMedium: TextStyle(color: Colors.black87),
      bodySmall: TextStyle(color: Colors.white),
      titleMedium: TextStyle(color: Colors.black),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: Colors.blue,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.blue),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.blue, width: 2),
      ),
      labelStyle: TextStyle(color: Colors.blue),
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: Colors.blue,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: Colors.blue, foregroundColor: Colors.white));

ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: const Color.fromARGB(255, 21, 21, 21),
    iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(foregroundColor: Colors.white)),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.blue,
    ),
    textTheme: TextTheme(
      bodyMedium: TextStyle(color: Colors.white),
      bodySmall: TextStyle(color: Colors.white),
      titleMedium: TextStyle(color: Colors.white),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: Colors.blue,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey[800],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.blue),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.blue, width: 2),
      ),
      labelStyle: TextStyle(color: Colors.blue),
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: Colors.blue,
    ),
    dropdownMenuTheme: DropdownMenuThemeData(
      textStyle: TextStyle(color: Colors.white),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey[800],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.blue),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.blue, width: 2),
        ),
        labelStyle: TextStyle(color: Colors.blue),
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: Colors.grey[800], foregroundColor: Colors.white));
