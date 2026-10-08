import 'package:flutter/material.dart';
import '../constants/app_style.dart';
import 'common_widgets.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  // DỮ LIỆU MẪU 7 ngày
  static const List<String> _days = [
    'T2',
    'T3',
    'T4',
    'T5',
    'T6',
    'T7',
    'CN',
  ];

  static const List<double> _weights = [
    58.0,
    57.8,
    57.5,
    57.6,
    57.2,
    57.0,
    56.8,
  ];

  static const List<double> _calories = [
    1850,
    2100,
    1700,
    1950,
    2300,
    2000,
    1800,
  ];

  @override
  Widget build(BuildContext context) {
    final change = _weights.last - _weights.first;
    final avgCalo =
        _calories.reduce((a, b) => a + b) / _calories.length;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Thống kê',
          style: AppText.h1,
        ),
        backgroundColor: AppColors.surface,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: AppColors.textPrimary,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.screen),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '7 ngày gần nhất',
                style: AppText.caption,
              ),

              const SizedBox(height: AppSpacing.small),

              // ==============================
              // THẺ TÓM TẮT
              // ==============================

              Row(
                children: [
                  Expanded(
                    child: _SummaryCard(
                      title: 'Cân nặng hiện tại',
                      value:
                          '${_weights.last.toStringAsFixed(1)} kg',
                      icon: Icons.monitor_weight,
                    ),
                  ),

                  const SizedBox(width: AppSpacing.screen),

                  Expanded(
                    child: _SummaryCard(
                      title: 'Thay đổi tuần',
                      value:
                          '${change > 0 ? '+' : ''}${change.toStringAsFixed(1)} kg',
                      icon: change <= 0
                          ? Icons.trending_down
                          : Icons.trending_up,
                      valueColor: change <= 0
                          ? AppColors.success
                          : AppColors.error,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.screen),

              _SummaryCard(
                title: 'Calo trung bình mỗi ngày',
                value: '${avgCalo.toStringAsFixed(0)} kcal',
                icon: Icons.local_fire_department,
              ),

              const SizedBox(height: AppSpacing.section),

              // ==============================
              // BIỂU ĐỒ CÂN NẶNG
              // ==============================

              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Biểu đồ cân nặng (kg)',
                      style: AppText.h2,
                    ),

                    const SizedBox(
                      height: AppSpacing.section,
                    ),

                    SizedBox(
                      height: 220,
                      child: _WeightChart(
                        weights: _weights,
                        days: _days,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.section),

              // ==============================
              // BIỂU ĐỒ CALO
              // ==============================

              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Calo nạp vào (kcal)',
                      style: AppText.h2,
                    ),

                    const SizedBox(
                      height: AppSpacing.section,
                    ),

                    SizedBox(
                      height: 220,
                      child: _CalorieChart(
                        calories: _calories,
                        days: _days,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.section),
            ],
          ),
        ),
      ),
    );
  }
}

// ======================================================
// THẺ TÓM TẮT
// ======================================================

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color valueColor;

  const _SummaryCard({
    required this.title,
    required this.value,
    required this.icon,
    this.valueColor = AppColors.textPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(
              AppSpacing.small,
            ),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(
                AppRadius.button,
              ),
            ),
            child: Icon(
              icon,
              color: AppColors.primary,
            ),
          ),

          const SizedBox(
            width: AppSpacing.small + 4,
          ),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppText.caption,
                ),

                const SizedBox(height: 4),

                Text(
                  value,
                  style: AppText.h2.copyWith(
                    color: valueColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ======================================================
// BIỂU ĐỒ CÂN NẶNG
// ======================================================

class _WeightChart extends StatelessWidget {
  final List<double> weights;
  final List<String> days;

  const _WeightChart({
    required this.weights,
    required this.days,
  });

  @override
  Widget build(BuildContext context) {
    final minWeight =
        weights.reduce((a, b) => a < b ? a : b) - 1;

    final maxWeight =
        weights.reduce((a, b) => a > b ? a : b) + 1;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Trục Y
        SizedBox(
          width: 35,
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [
              Text(
                maxWeight.toStringAsFixed(0),
                style: AppText.caption,
              ),
              Text(
                ((maxWeight + minWeight) / 2)
                    .toStringAsFixed(0),
                style: AppText.caption,
              ),
              Text(
                minWeight.toStringAsFixed(0),
                style: AppText.caption,
              ),
            ],
          ),
        ),

        const SizedBox(width: AppSpacing.small),

        // Biểu đồ
        Expanded(
          child: Column(
            children: [
              Expanded(
                child: CustomPaint(
                  painter: _WeightChartPainter(
                    weights: weights,
                    minWeight: minWeight,
                    maxWeight: maxWeight,
                  ),
                  child: Container(),
                ),
              ),

              const SizedBox(
                height: AppSpacing.small,
              ),

              // Trục X
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceAround,
                children: days
                    .map(
                      (day) => Text(
                        day,
                        style: AppText.caption,
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ======================================================
// PAINTER BIỂU ĐỒ CÂN NẶNG
// ======================================================

class _WeightChartPainter extends CustomPainter {
  final List<double> weights;
  final double minWeight;
  final double maxWeight;

  _WeightChartPainter({
    required this.weights,
    required this.minWeight,
    required this.maxWeight,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = AppColors.border
      ..strokeWidth = 1;

    final linePaint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final pointPaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.fill;

    // Vẽ các đường ngang
    for (int i = 0; i <= 2; i++) {
      final y = size.height * i / 2;

      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        gridPaint,
      );
    }

    final points = <Offset>[];

    for (int i = 0; i < weights.length; i++) {
      final x = weights.length == 1
          ? size.width / 2
          : i *
              size.width /
              (weights.length - 1);

      final ratio =
          (weights[i] - minWeight) /
              (maxWeight - minWeight);

      final y =
          size.height - ratio * size.height;

      points.add(
        Offset(x, y),
      );
    }

    if (points.isEmpty) return;

    // Đường biểu đồ
    final path = Path();

    path.moveTo(
      points.first.dx,
      points.first.dy,
    );

    for (int i = 1; i < points.length; i++) {
      path.lineTo(
        points[i].dx,
        points[i].dy,
      );
    }

    canvas.drawPath(
      path,
      linePaint,
    );

    // Các điểm trên biểu đồ
    for (final point in points) {
      canvas.drawCircle(
        point,
        5,
        pointPaint,
      );
    }
  }

  @override
  bool shouldRepaint(
    covariant _WeightChartPainter oldDelegate,
  ) {
    return oldDelegate.weights != weights ||
        oldDelegate.minWeight != minWeight ||
        oldDelegate.maxWeight != maxWeight;
  }
}

// ======================================================
// BIỂU ĐỒ CALO
// ======================================================

class _CalorieChart extends StatelessWidget {
  final List<double> calories;
  final List<String> days;

  const _CalorieChart({
    required this.calories,
    required this.days,
  });

  @override
  Widget build(BuildContext context) {
    final maxCalories =
        calories.reduce((a, b) => a > b ? a : b);

    return Column(
      children: [
        Expanded(
          child: Row(
            crossAxisAlignment:
                CrossAxisAlignment.stretch,
            children: [
              // Trục Y
              SizedBox(
                width: 40,
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      maxCalories.toStringAsFixed(0),
                      style: AppText.caption,
                    ),
                    Text(
                      (maxCalories / 2)
                          .toStringAsFixed(0),
                      style: AppText.caption,
                    ),
                    Text(
                      '0',
                      style: AppText.caption,
                    ),
                  ],
                ),
              ),

              const SizedBox(
                width: AppSpacing.small,
              ),

              // Các cột
              Expanded(
                child: Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.end,
                  mainAxisAlignment:
                      MainAxisAlignment.spaceAround,
                  children: [
                    for (int i = 0;
                        i < calories.length;
                        i++)
                      _CalorieBar(
                        value: calories[i],
                        maxValue: maxCalories,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(
          height: AppSpacing.small,
        ),

        // Trục X
        Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceAround,
          children: days
              .map(
                (day) => Text(
                  day,
                  style: AppText.caption,
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

// ======================================================
// CỘT CALO
// ======================================================

class _CalorieBar extends StatelessWidget {
  final double value;
  final double maxValue;

  const _CalorieBar({
    required this.value,
    required this.maxValue,
  });

  @override
  Widget build(BuildContext context) {
    final ratio = value / maxValue;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 5,
        ),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: FractionallySizedBox(
            heightFactor: ratio,
            child: Container(
              width: 16,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius:
                    const BorderRadius.vertical(
                  top: Radius.circular(
                    AppRadius.button / 2,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}