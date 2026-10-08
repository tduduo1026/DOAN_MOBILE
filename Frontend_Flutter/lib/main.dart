import 'package:flutter/material.dart';

import 'constants/app_style.dart';
import 'screens/profile_setup_screen.dart';
import 'screens/daily_log_screen.dart';
import 'screens/stats_screen.dart';

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

      // Mở thẳng giao diện Home, không cần Login/Register
      initialRoute: '/profile_setup',

      routes: {
        '/profile_setup': (context) => const ProfileSetupScreen(),
        '/daily_log': (context) => const DailyLogScreen(),
        '/stats': (context) => const StatsScreen(),
      },
    );
  }
}