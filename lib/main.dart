import 'package:flutter/material.dart';
import 'package:inventory_management/constants.dart';

import 'screens/home_screen.dart';

void main() {
  runApp(
    MaterialApp(
      home: const HomeScreen(),
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        appBarTheme: const AppBarTheme(
          backgroundColor: kPrimaryColor,
          centerTitle: true,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(kPrimaryColor),
          ),
        ),
      ),
    ),
  );
}
