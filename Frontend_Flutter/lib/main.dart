import 'package:flutter/material.dart';

import 'constants/app_style.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/water_calorie_form.dart';
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
      theme: AppStyle.theme, // Sử dụng chuẩn UI/UX của nhóm
      initialRoute: '/login', // Điểm bắt đầu bắt buộc là Đăng nhập
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
        '/water_calorie': (context) => const WaterCalorieForm(),
        '/daily-log': (context) => const DailyLogScreen(),
        '/stats': (context) => const StatsScreen(),
        '/profile': (context) => const ProfileSetupScreen(),
     
      },
    );
  }
}
