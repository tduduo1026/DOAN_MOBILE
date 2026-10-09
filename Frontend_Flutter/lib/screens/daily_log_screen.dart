import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_style.dart';
import '../models/health_record.dart';
import '../widgets/health_bottom_navigation.dart';

/// Form ghi nhận nhật ký số đo cơ thể hằng ngày và tính BMI.
class DailyLogScreen extends StatefulWidget {
  const DailyLogScreen({super.key});

  @override
  State<DailyLogScreen> createState() => _DailyLogScreenState();
}

class _DailyLogScreenState extends State<DailyLogScreen> {
  final _formKey = GlobalKey<FormState>();
  final _heightController = TextEditingController(text: '170');
  final _weightController = TextEditingController(text: '65');
  final _heartRateController = TextEditingController(text: '72');
  DateTime _measurementDate = DateTime.now();

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    _heartRateController.dispose();
    super.dispose();
  }

  String? _validatePositiveInt(String? value, String label,
      {required int min, required int max}) {
    if (value == null || value.trim().isEmpty) return 'Vui lòng nhập $label';
    final number = int.tryParse(value.trim());
    if (number == null || number < min || number > max) {
      return '$label phải từ $min đến $max';
    }
    return null;
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _measurementDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 1)),
      helpText: 'Chọn ngày đo',
      cancelText: 'Hủy',
      confirmText: 'Chọn',
    );
    if (picked != null && mounted) setState(() => _measurementDate = picked);
  }

  Future<void> _calculateAndSave() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    final height = double.parse(_heightController.text.trim());
    final weight = double.parse(_weightController.text.trim());
    final heartRate = int.parse(_heartRateController.text.trim());
    final record = HealthRecord(
      date: _measurementDate,
      heightCm: height,
      weightKg: weight,
      heartRateBpm: heartRate,
    );
    HealthRecordStore.save(record);

    final bmi = record.bmi;
    final bmiInfo = _bmiDescription(bmi);
    if (!mounted) return;
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        icon: const Icon(Icons.monitor_heart_outlined, color: AppColors.primary, size: 36),
        title: const Text('Kết quả chỉ số BMI'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(bmi.toStringAsFixed(1), style: AppText.display.copyWith(color: bmiInfo.color)),
            const SizedBox(height: AppSpacing.small),
            AppPill(text: bmiInfo.label, color: bmiInfo.color),
            const SizedBox(height: AppSpacing.small),
            Text('Số đo đã được lưu vào lịch sử.', textAlign: TextAlign.center, style: AppText.body.copyWith(color: AppColors.textSecondary)),
          ],
        ),
        actions: [
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Hoàn tất'),
          ),
        ],
      ),
    );
  }

  ({String label, Color color}) _bmiDescription(double bmi) {
    if (bmi < 18.5) return (label: 'Thiếu cân', color: AppColors.info);
    if (bmi < 25) return (label: 'Bình thường', color: AppColors.success);
    if (bmi < 30) return (label: 'Thừa cân', color: AppColors.warning);
    return (label: 'Béo phì', color: AppColors.error);
  }

  String _formatDate(DateTime date) =>
      '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nhập số đo cơ thể', style: AppText.h2),
        backgroundColor: AppColors.surface,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.screen),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.screen),
            decoration: AppStyle.card,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Thông số cơ thể', style: AppText.h2),
                  const SizedBox(height: 4),
                  Text('Nhập thông tin để tính chỉ số BMI', style: AppText.body.copyWith(color: AppColors.textSecondary)),
                  const SizedBox(height: AppSpacing.section),
                  _MeasurementField(
                    label: 'Chiều cao (cm)',
                    controller: _heightController,
                    hint: 'VD: 170',
                    suffix: 'cm',
                    icon: Icons.height_rounded,
                    validator: (v) => _validatePositiveInt(v, 'chiều cao', min: 80, max: 250),
                  ),
                  const SizedBox(height: AppSpacing.small + 4),
                  _MeasurementField(
                    label: 'Cân nặng (kg)',
                    controller: _weightController,
                    hint: 'VD: 65',
                    suffix: 'kg',
                    icon: Icons.monitor_weight_outlined,
                    validator: (v) => _validatePositiveInt(v, 'cân nặng', min: 20, max: 350),
                  ),
                  const SizedBox(height: AppSpacing.small + 4),
                  _MeasurementField(
                    label: 'Nhịp tim (bpm)',
                    controller: _heartRateController,
                    hint: 'VD: 72',
                    suffix: 'bpm',
                    icon: Icons.favorite_border_rounded,
                    validator: (v) => _validatePositiveInt(v, 'nhịp tim', min: 30, max: 220),
                  ),
                  const SizedBox(height: AppSpacing.small + 4),
                  Text('Ngày đo', style: AppText.label),
                  const SizedBox(height: 6),
                  Material(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppRadius.button),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(AppRadius.button),
                      onTap: _pickDate,
                      child: Container(
                        constraints: const BoxConstraints(minHeight: AppSize.fieldHeight),
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screen),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.border),
                          borderRadius: BorderRadius.circular(AppRadius.button),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.calendar_today_outlined, color: AppColors.textSecondary, size: 20),
                            const SizedBox(width: AppSpacing.small + 4),
                            Expanded(child: Text(_formatDate(_measurementDate), style: AppText.body)),
                            const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.textSecondary),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.section),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: AppStyle.primaryButton,
                      onPressed: _calculateAndSave,
                      icon: const Icon(Icons.calculate_outlined),
                      label: const Text('Tính chỉ số BMI'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: const HealthBottomNavigation(selectedIndex: 1),
    );
  }
}

class _MeasurementField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String hint;
  final String suffix;
  final IconData icon;
  final String? Function(String?) validator;

  const _MeasurementField({
    required this.label,
    required this.controller,
    required this.hint,
    required this.suffix,
    required this.icon,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppText.label),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          validator: validator,
          style: AppText.bodyBold,
          decoration: AppStyle.inputDecoration(
            hint: hint,
            suffix: suffix,
            prefixIcon: icon,
          ),
        ),
      ],
    );
  }
}
