import 'package:flutter/material.dart';
import '../constants/app_style.dart';
import '../widgets/health_bottom_navigation.dart';
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

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Dữ liệu hiển thị lấy từ JSON mẫu, được cập nhật khi người dùng nhập form.
  late int _water;
  late int _calories;
  late final Map<String, dynamic> _nutrition;
  late final Map<String, dynamic> _workout;

  @override
  void initState() {
    super.initState();
    _nutrition = kDailyJson["nutrition"] as Map<String, dynamic>;
    _workout = kDailyJson["workout"] as Map<String, dynamic>;
    _water = kDailyJson["waterIntakeMl"] as int;
    _calories = _nutrition["consumedCalories"] as int;
  }

  /// "2026-10-02" -> "02/10/2026"
  String _formatDate(String iso) {
    final p = iso.split('-');
    return p.length == 3 ? '${p[2]}/${p[1]}/${p[0]}' : iso;
  }

  Future<void> _openForm() async {
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(builder: (_) => const WaterCalorieForm()),
    );
    if (result == null) return;
    // Form trả về lượng nước / calo của lần ghi nhận này → cộng dồn vào tổng.
    setState(() {
      _water += result["waterIntakeMl"] as int;
      _calories += result["consumedCalories"] as int;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.screen),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Tổng quan hôm nay', style: AppText.h1),
              const SizedBox(height: AppSpacing.small),
              Row(
                children: [
                  const Icon(Icons.calendar_today_outlined,
                      size: 14, color: AppColors.textSecondary),
                  const SizedBox(width: AppSpacing.small / 2),
                  Text(_formatDate(kDailyJson["recordDate"] as String),
                      style: AppText.caption),
                ],
              ),
              const SizedBox(height: AppSpacing.section),
              _WaterCard(
                current: _water,
                goal: kWaterGoalMl,
                drinks: kDailyJson["drinksInfo"] as String,
              ),
              const SizedBox(height: AppSpacing.section),
              _CalorieCard(
                consumed: _calories,
                goal: kCalorieGoal,
                meals: List<String>.from(_nutrition["meals"] as List),
              ),
              const SizedBox(height: AppSpacing.section),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Danh sách bài tập', style: AppText.h2),
                  Text('1 buổi', style: AppText.caption),
                ],
              ),
              const SizedBox(height: AppSpacing.small),
              // Hiện JSON mẫu chỉ có 1 buổi tập; khi có nhiều buổi thì map qua list.
              _WorkoutTile(data: _workout),
              const SizedBox(height: AppSpacing.section),
              ElevatedButton.icon(
                style: AppStyle.primaryButton,
                onPressed: _openForm,
                icon: const Icon(Icons.add_circle_outline),
                label: const Text('Nhập nước & calo'),
              ),
            ],
          ),
        ),
      ),
      // Thanh điều hướng dùng chung với các màn hình của người 3.
      bottomNavigationBar: const HealthBottomNavigation(selectedIndex: 0),
    );
  }
}

/// Ô icon nền xanh nhạt dùng chung trong các thẻ.
class _IconBadge extends StatelessWidget {
  final IconData icon;
  const _IconBadge(this.icon);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(AppRadius.button),
      ),
      child: Icon(icon, color: AppColors.primary, size: 22),
    );
  }
}

/// Viên thuốc nhỏ: icon + chữ.
class _Pill extends StatelessWidget {
  final IconData? icon;
  final String text;
  final Color? color;
  const _Pill({this.icon, required this.text, this.color});

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppColors.primary;
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: 12, vertical: AppSpacing.small / 2),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(AppRadius.button),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: c),
            const SizedBox(width: AppSpacing.small / 2),
          ],
          Text(text, style: AppText.caption.copyWith(color: c)),
        ],
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
    final remaining = goal - current;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.screen),
      decoration: AppStyle.card,
      child: Column(
        children: [
          Row(
            children: [
              const _IconBadge(Icons.water_drop_outlined),
              const SizedBox(width: AppSpacing.small + 4),
              Expanded(child: Text('Tiến độ uống nước', style: AppText.h2)),
              Text('Mục tiêu $goal ml', style: AppText.caption),
            ],
          ),
          const SizedBox(height: AppSpacing.section),
          SizedBox(
            width: 180,
            height: 180,
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: progress),
              duration: const Duration(milliseconds: 900),
              curve: Curves.easeOutCubic,
              builder: (context, value, _) => Stack(
                fit: StackFit.expand,
                children: [
                  CircularProgressIndicator(
                    value: value,
                    strokeWidth: 14,
                    strokeCap: StrokeCap.round,
                    backgroundColor: AppColors.primaryLight,
                    valueColor:
                        const AlwaysStoppedAnimation(AppColors.primary),
                  ),
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.water_drop,
                            color: AppColors.primary, size: 24),
                        const SizedBox(height: AppSpacing.small / 2),
                        Text('${(value * 100).round()}%', style: AppText.h1),
                        Text('$current / $goal ml', style: AppText.caption),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.section),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: AppSpacing.small,
            runSpacing: AppSpacing.small,
            children: [
              _Pill(icon: Icons.local_drink_outlined, text: drinks),
              remaining > 0
                  ? _Pill(
                      icon: Icons.flag_outlined, text: 'Còn $remaining ml')
                  : const _Pill(
                      icon: Icons.check_circle_outline,
                      text: 'Đã đạt mục tiêu'),
            ],
          ),
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
    final isOver = remaining < 0;
    final statusColor = isOver ? AppColors.error : AppColors.success;
    final progress = (consumed / goal).clamp(0.0, 1.0);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.screen),
      decoration: AppStyle.card,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const _IconBadge(Icons.local_fire_department_outlined),
              const SizedBox(width: AppSpacing.small + 4),
              Expanded(child: Text('Tổng calo tiêu thụ', style: AppText.h2)),
              Text(
                isOver ? 'Vượt ${-remaining} kcal' : 'Còn $remaining kcal',
                style: AppText.caption.copyWith(
                  color: statusColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.screen),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text('$consumed', style: AppText.h1),
              const SizedBox(width: AppSpacing.small / 2),
              Text('/ $goal kcal', style: AppText.caption),
            ],
          ),
          const SizedBox(height: AppSpacing.small),
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0, end: progress),
            duration: const Duration(milliseconds: 900),
            curve: Curves.easeOutCubic,
            builder: (context, value, _) => ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.button),
              child: LinearProgressIndicator(
                value: value,
                minHeight: 8,
                backgroundColor: AppColors.primaryLight,
                valueColor: AlwaysStoppedAnimation(
                    isOver ? AppColors.error : AppColors.primary),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.section),
          Text('Bữa ăn hôm nay', style: AppText.caption),
          const SizedBox(height: AppSpacing.small),
          Wrap(
            spacing: AppSpacing.small,
            runSpacing: AppSpacing.small,
            children: meals
                .map((m) => _Pill(icon: Icons.restaurant_outlined, text: m))
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
          const _IconBadge(Icons.fitness_center),
          const SizedBox(width: AppSpacing.small + 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(data["activityType"] as String,
                    style: AppText.body.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: AppSpacing.small / 2),
                Text('Nhóm cơ: ${data["muscleGroup"]}',
                    style: AppText.caption),
              ],
            ),
          ),
          _Pill(
              icon: Icons.timer_outlined,
              text: '${data["durationMinutes"]} phút'),
        ],
      ),
    );
  }
}