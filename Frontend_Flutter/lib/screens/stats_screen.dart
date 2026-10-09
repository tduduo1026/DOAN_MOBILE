import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../constants/app_style.dart';
import '../models/health_record.dart';
import '../widgets/health_bottom_navigation.dart';

/// Màn hình thống kê cân nặng, calo và lịch sử đo.
/// Các chuỗi chart là dữ liệu demo, chờ kết nối API ở giai đoạn backend.
class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  int _periodIndex = 0;

  static const _periodNames = ['Tuần', 'Tháng', 'Năm'];
  static const _weekLabels = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];
  static const _weekWeights = [69.0, 68.5, 68.9, 67.8, 68.2, 67.5, 67.0];
  static const _weekCalories = [1600.0, 1800.0, 1400.0, 1700.0, 1500.0, 1900.0, 1650.0];

  static const _monthLabels = ['1', '5', '10', '15', '20', '25', '30'];
  static const _monthWeights = [70.0, 69.4, 69.0, 68.8, 68.5, 68.2, 67.0];
  static const _monthCalories = [1600.0, 1750.0, 1820.0, 1420.0, 1680.0, 1540.0, 1900.0, 1640.0, 1480.0, 1740.0, 1580.0, 1810.0];
  static const _monthCalorieLabels = ['1', '3', '5', '7', '9', '11', '13', '15', '17', '19', '21', '23'];

  static const _yearLabels = ['T1', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'T8', 'T9', 'T10', 'T11', 'T12'];
  static const _yearWeights = [72.0, 71.8, 71.2, 70.7, 70.0, 69.5, 69.2, 68.8, 68.5, 68.0, 67.5, 67.0];
  static const _yearCalories = [1750.0, 1820.0, 1680.0, 1900.0, 1720.0, 1650.0, 1800.0, 1740.0, 1600.0, 1700.0, 1580.0, 1650.0];

  List<double> get _weightValues => switch (_periodIndex) {
        0 => _weekWeights,
        1 => _monthWeights,
        _ => _yearWeights,
      };

  List<String> get _weightLabels => switch (_periodIndex) {
        0 => _weekLabels,
        1 => _monthLabels,
        _ => _yearLabels,
      };

  List<double> get _calorieValues {
    final values = switch (_periodIndex) {
      0 => [..._weekCalories],
      1 => [..._monthCalories],
      _ => [..._yearCalories],
    };
     final sampleIndex = switch (_periodIndex) {
      0 => 4, // T6
      1 => 0, // ngày đầu tháng
      _ => 9, // tháng 10
    };
    values[sampleIndex] = HealthRecordStore.sampleCalories;
    return values;
  }

  List<String> get _calorieLabels => switch (_periodIndex) {
        0 => _weekLabels,
        1 => _monthCalorieLabels,
        _ => _yearLabels,
      };

  String _formatDate(DateTime date) =>
      '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';

  @override
  Widget build(BuildContext context) {
    final records = [...HealthRecordStore.records]
      ..sort((a, b) => b.date.compareTo(a.date));

    return Scaffold(
      appBar: AppBar(
        title: Text('Thống kê & Lịch sử', style: AppText.h2),
        backgroundColor: AppColors.surface,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screen,
            AppSpacing.screen,
            AppSpacing.screen,
            AppSpacing.section,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPeriodSelector(),
              const SizedBox(height: AppSpacing.section),
              _buildWeightChart(),
              const SizedBox(height: AppSpacing.section),
              _buildCalorieChart(),
              const SizedBox(height: AppSpacing.section),
              Text('Lịch sử đo', style: AppText.h2),
              const SizedBox(height: AppSpacing.small),
              if (records.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppSpacing.section),
                  decoration: AppStyle.card,
                  child: Text('Chưa có số đo nào. Hãy nhập số đo cơ thể để bắt đầu.', style: AppText.body),
                )
              else
                ...records.take(12).map((record) => Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.small),
                      child: _HistoryCard(
                        date: _formatDate(record.date),
                        weight: record.weightKg,
                        bmi: record.bmi,
                        heartRate: record.heartRateBpm,
                      ),
                    )),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const HealthBottomNavigation(selectedIndex: 2),
    );
  }

  Widget _buildPeriodSelector() {
    return Row(
      children: List.generate(_periodNames.length, (index) {
        final selected = _periodIndex == index;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: index == _periodNames.length - 1 ? 0 : AppSpacing.small),
            child: Material(
              color: selected ? AppColors.primary : AppColors.surface,
              borderRadius: BorderRadius.circular(AppRadius.pill),
              child: InkWell(
                borderRadius: BorderRadius.circular(AppRadius.pill),
                onTap: () => setState(() => _periodIndex = index),
                child: Container(
                  height: 42,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                    border: Border.all(color: selected ? AppColors.primary : AppColors.border),
                  ),
                  child: Text(
                    _periodNames[index],
                    style: AppText.body.copyWith(
                      color: selected ? AppColors.onPrimary : AppColors.textSecondary,
                      fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildWeightChart() {
    final values = _weightValues;
    final minWeight = values.reduce((a, b) => a < b ? a : b);
    final maxWeight = values.reduce((a, b) => a > b ? a : b);
    final minY = (minWeight - 0.7).floorToDouble();
    final maxY = (maxWeight + 0.7).ceilToDouble();
    final interval = ((maxY - minY) / 3).clamp(0.5, 2.0).toDouble();

    return _ChartCard(
      title: 'Cân nặng theo thời gian',
      unit: 'kg',
      child: SizedBox(
        height: 210,
        child: LineChart(
          LineChartData(
            minX: 0,
            maxX: (values.length - 1).toDouble(),
            minY: minY,
            maxY: maxY,
            clipData: const FlClipData.all(),
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: interval,
              getDrawingHorizontalLine: (_) => FlLine(
                color: AppColors.border.withValues(alpha: 0.65),
                strokeWidth: 1,
              ),
            ),
            borderData: FlBorderData(show: false),
            titlesData: FlTitlesData(
              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 34,
                  interval: interval,
                  getTitlesWidget: (value, meta) => Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: Text(value.toStringAsFixed(0), style: AppText.caption.copyWith(fontSize: 10)),
                  ),
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 24,
                  interval: _weightLabels.length > 7 ? 2 : 1,
                  getTitlesWidget: (value, meta) {
                    final index = value.round();
                    if (index < 0 || index >= _weightLabels.length) return const SizedBox.shrink();
                    if (_periodIndex == 2 && index.isOdd) return const SizedBox.shrink();
                    return Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Text(_weightLabels[index], style: AppText.caption.copyWith(fontSize: 10)),
                    );
                  },
                ),
              ),
            ),
            lineBarsData: [
              LineChartBarData(
                spots: List.generate(values.length, (index) => FlSpot(index.toDouble(), values[index])),
                isCurved: true,
                curveSmoothness: 0.2,
                color: AppColors.primary,
                barWidth: 2.5,
                dotData: FlDotData(
                  show: true,
                  getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                    radius: 3.5,
                    color: AppColors.primary,
                    strokeWidth: 1.5,
                    strokeColor: AppColors.surface,
                  ),
                ),
                belowBarData: BarAreaData(
                  show: true,
                  color: AppColors.primaryLight.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
          duration: const Duration(milliseconds: 450),
        ),
      ),
    );
  }

  Widget _buildCalorieChart() {
    final values = _calorieValues;
    final labels = _calorieLabels;
    return _ChartCard(
      title: 'Calo mỗi ngày',
      unit: 'kcal',
      child: SizedBox(
        height: 220,
        child: BarChart(
          BarChartData(
            maxY: 2200,
            minY: 0,
            alignment: BarChartAlignment.spaceAround,
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: 500,
              getDrawingHorizontalLine: (_) => FlLine(
                color: AppColors.border.withValues(alpha: 0.65),
                strokeWidth: 1,
              ),
            ),
            borderData: FlBorderData(show: false),
            titlesData: FlTitlesData(
              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 34,
                  interval: 500,
                  getTitlesWidget: (value, meta) => Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: Text(value == 0 ? '0' : value.toInt().toString(), style: AppText.caption.copyWith(fontSize: 10)),
                  ),
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 24,
                  getTitlesWidget: (value, meta) {
                    final index = value.toInt();
                    if (index < 0 || index >= labels.length) return const SizedBox.shrink();
                    return Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Text(labels[index], style: AppText.caption.copyWith(fontSize: 10)),
                    );
                  },
                ),
              ),
            ),
            barGroups: List.generate(values.length, (index) => BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: values[index],
                  width: _periodIndex == 1 ? 10 : 16,
                  color: AppColors.primary,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                  backDrawRodData: BackgroundBarChartRodData(
                    show: false,
                    toY: 2200,
                    color: AppColors.primaryLight,
                  ),
                ),
              ],
            )),
          ),
          duration: const Duration(milliseconds: 450),
        ),
      ),
    );
  }
}

class _ChartCard extends StatelessWidget {
  final String title;
  final String unit;
  final Widget child;

  const _ChartCard({required this.title, required this.unit, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.screen),
      decoration: AppStyle.card,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(title, style: AppText.h2)),
              Text(unit, style: AppText.caption),
            ],
          ),
          const SizedBox(height: AppSpacing.small + 4),
          child,
        ],
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  final String date;
  final double weight;
  final double bmi;
  final int heartRate;

  const _HistoryCard({
    required this.date,
    required this.weight,
    required this.bmi,
    required this.heartRate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.small + 4),
      decoration: AppStyle.card,
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: AppStyle.tintBox(AppColors.info),
            child: const Icon(Icons.calendar_month_outlined, color: AppColors.primary),
          ),
          const SizedBox(width: AppSpacing.small + 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(date, style: AppText.bodyBold),
                const SizedBox(height: 5),
                Wrap(
                  spacing: 5,
                  runSpacing: 5,
                  children: [
                    AppPill(text: '${weight.toStringAsFixed(1)} kg', color: AppColors.primary),
                    AppPill(text: 'BMI ${bmi.toStringAsFixed(1)}', color: AppColors.success),
                    AppPill(text: '$heartRate bpm', color: AppColors.error),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 4),
          const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary),
        ],
      ),
    );
  }
}
