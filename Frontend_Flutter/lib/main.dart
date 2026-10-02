import 'package:flutter/material.dart';
import 'constants/app_style.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quản lý sức khỏe',
      debugShowCheckedModeBanner: false,
      theme: AppStyle.theme,
      home: const HomeScreen(),
    );
  }
}