import 'package:flutter/material.dart';
import '../constants/app_style.dart';
import 'water_calorie_form.dart';

/// JSON mẫu của nhóm (data_cddd.js) — bắt buộc giữ nguyên cấu trúc key.
const Map<String, dynamic> kDailyJson = {
  "recordDate": "2026-10-02",
  "waterIntakeMl": 1500,
  "drinksInfo": "Nước cam pha loãng",
  "nutrition": {
    "consumedCalories": 1200,
    "meals": ["Cơm trắng", "Đùi gà", "Trứng vịt"]
  },
  "workout": {
    "activityType": "Gym - Tập tạ",
    "muscleGroup": "Tay và Bụng",
    "durationMinutes": 60
  }
};

/// Mục tiêu mặc định (JSON mẫu chưa có) — sau này lấy từ hồ sơ cá nhân.
const int kWaterGoalMl = 2000;
const int kCalorieGoal = 2000;

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final data = kDailyJson;
    final nutrition = data["nutrition"] as Map<String, dynamic>;
    final workout = data["workout"] as Map<String, dynamic>;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.screen),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Tổng quan hôm nay', style: AppText.h1),
              const SizedBox(height: AppSpacing.small),
              Text('Ngày ${data["recordDate"]}', style: AppText.caption),
              const SizedBox(height: AppSpacing.section),
              _WaterCard(
                current: data["waterIntakeMl"] as int,
                goal: kWaterGoalMl,
                drinks: data["drinksInfo"] as String,
              ),
              const SizedBox(height: AppSpacing.section),
              _CalorieCard(
                consumed: nutrition["consumedCalories"] as int,
                goal: kCalorieGoal,
                meals: List<String>.from(nutrition["meals"] as List),
              ),
              const SizedBox(height: AppSpacing.section),
              Text('Danh sách bài tập', style: AppText.h2),
              const SizedBox(height: AppSpacing.small),
              // Hiện JSON mẫu chỉ có 1 buổi tập; khi có nhiều buổi thì map qua list.
              _WorkoutTile(data: workout),
              const SizedBox(height: AppSpacing.section),
              ElevatedButton(
                style: AppStyle.primaryButton,
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const WaterCalorieForm()),
                ),
                child: const Text('Nhập nước & calo'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WaterCard extends StatelessWidget {
  final int current;
  final int goal;
  final String drinks;
  const _WaterCard(
      {required this.current, required this.goal, required this.drinks});

  @override
  Widget build(BuildContext context) {
    final progress = (current / goal).clamp(0.0, 1.0);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.screen),
      decoration: AppStyle.card,
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text('Tiến độ uống nước', style: AppText.h2),
          ),
          const SizedBox(height: AppSpacing.screen),
          SizedBox(
            width: 160,
            height: 160,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 12,
                  strokeCap: StrokeCap.round,
                  backgroundColor: AppColors.primaryLight,
                  valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                ),
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('${(progress * 100).round()}%', style: AppText.h1),
                      Text('$current / $goal ml', style: AppText.caption),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.screen),
          Text(drinks, style: AppText.caption),
        ],
      ),
    );
  }
}

class _CalorieCard extends StatelessWidget {
  final int consumed;
  final int goal;
  final List<String> meals;
  const _CalorieCard(
      {required this.consumed, required this.goal, required this.meals});

  @override
  Widget build(BuildContext context) {
    final remaining = goal - consumed;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.screen),
      decoration: AppStyle.card,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.small),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(AppRadius.button),
                ),
                child: const Icon(Icons.local_fire_department,
                    color: AppColors.primary),
              ),
              const SizedBox(width: AppSpacing.screen),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Tổng calo tiêu thụ', style: AppText.caption),
                    Text('$consumed kcal', style: AppText.h2),
                  ],
                ),
              ),
              Text(
                remaining >= 0 ? 'Còn $remaining' : 'Vượt ${-remaining}',
                style: AppText.body.copyWith(
                  color: remaining >= 0 ? AppColors.success : AppColors.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.screen),
          Text('Bữa ăn hôm nay', style: AppText.caption),
          const SizedBox(height: AppSpacing.small),
          Wrap(
            spacing: AppSpacing.small,
            runSpacing: AppSpacing.small,
            children: meals
                .map((m) => Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: AppSpacing.small / 2),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(AppRadius.button),
                      ),
                      child: Text(m,
                          style: AppText.caption
                              .copyWith(color: AppColors.primary)),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _WorkoutTile extends StatelessWidget {
  final Map<String, dynamic> data;
  const _WorkoutTile({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.screen),
      decoration: AppStyle.card,
      child: Row(
        children: [
          const Icon(Icons.fitness_center, color: AppColors.primary),
          const SizedBox(width: AppSpacing.screen),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(data["activityType"] as String, style: AppText.body),
                Text('Nhóm cơ: ${data["muscleGroup"]}', style: AppText.caption),
              ],
            ),
          ),
          Text('${data["durationMinutes"]} phút',
              style: AppText.body.copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}