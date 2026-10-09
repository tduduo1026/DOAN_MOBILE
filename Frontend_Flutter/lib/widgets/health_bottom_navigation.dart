import 'package:flutter/material.dart';
import '../constants/app_style.dart';

/// Thanh điều hướng 4 mục theo giao diện trong video.
class HealthBottomNavigation extends StatelessWidget {
  final int selectedIndex;

  const HealthBottomNavigation({
    super.key,
    required this.selectedIndex,
  });

  static const _routes = ['/home', '/daily-log', '/stats', '/profile'];

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: selectedIndex,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      backgroundColor: AppColors.surface,
      indicatorColor: AppColors.primaryLight,
      onDestinationSelected: (index) {
        if (index == selectedIndex) return;
        Navigator.of(context).pushReplacementNamed(_routes[index]);
      },
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home_rounded),
          label: 'Tổng quan',
        ),
        NavigationDestination(
          icon: Icon(Icons.monitor_weight_outlined),
          selectedIcon: Icon(Icons.monitor_weight_rounded),
          label: 'Nhập số đo',
        ),
        NavigationDestination(
          icon: Icon(Icons.bar_chart_outlined),
          selectedIcon: Icon(Icons.bar_chart_rounded),
          label: 'Thống kê',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline_rounded),
          selectedIcon: Icon(Icons.person_rounded),
          label: 'Hồ sơ',
        ),
      ],
    );
  }
}
