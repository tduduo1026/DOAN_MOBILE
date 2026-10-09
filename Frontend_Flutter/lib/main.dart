import 'package:flutter/material.dart';

import 'constants/app_style.dart';
import 'screens/profile_setup_screen.dart';
import 'screens/daily_log_screen.dart';
import 'screens/stats_screen.dart';
import 'screens/login_screen.dart';
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

      initialRoute: '/', // Đổi về '/' để trình duyệt Web không bị lú

      routes: {
        '/': (context) => LoginScreen(), // Gắn trang Login vào route gốc
        '/login': (context) => LoginScreen(),
        '/profile_setup': (context) => const ProfileSetupScreen(),
        '/daily_log': (context) => const DailyLogScreen(),
        // '/stats': (context) => const StatsScreen(),
        '/home': (context) => const HomeScreen(), // Dòng này phải nằm TRƯỚC dấu ngoặc nhọn đóng nhé
      }, // Dấu ngoặc nhọn đóng của routes phải nằm ở cuối cùng
    );
  }
}
