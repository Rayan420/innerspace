import 'package:flutter/material.dart';

ThemeData darkTheme = ThemeData(
  colorScheme: const ColorScheme.light(
      background: Color(0xFFF9FDFF), // Dark gray base
      onBackground: Color(0xFF263238),
      primary: Color(0xFF48D1CC),
      onPrimary: Color(0xFF212121),
      secondary: Color(0xFF00D8E7),
      onSecondary: Color(0xFF3A5160),
      tertiary: Color(0xFFF59E0B),
      error: Color.fromARGB(255, 143, 0, 26),
      outline: Color(0xFF424242)),
  textTheme: const TextTheme(
    displayLarge: TextStyle(
      fontSize: 72.0,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
    titleLarge: TextStyle(
      fontSize: 36.0,
      fontStyle: FontStyle.italic,
      color: Colors.black,
    ),
    bodyMedium: TextStyle(
      fontSize: 18.0,
      fontFamily: 'RobotoCondensed',
      color: Colors.black,
    ),
    bodySmall: TextStyle(
      fontSize: 14.0,
      fontFamily: 'RobotoCondensed',
      color: Colors.black,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: const Color(0xFF303030),
      backgroundColor: const Color(0xFF00F58D), // Dark gray text on button
      elevation: 0, // Embrace Material 3's flat design
    ),
  ),
  // colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.green)
  //   .copyWith(error: const Color(0xFFCF6679)), // Removed to avoid conflict
);
