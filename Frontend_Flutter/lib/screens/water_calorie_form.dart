import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_style.dart';

class WaterCalorieForm extends StatefulWidget {
  const WaterCalorieForm({super.key});

  @override
  State<WaterCalorieForm> createState() => _WaterCalorieFormState();
}

class _WaterCalorieFormState extends State<WaterCalorieForm> {
  final _formKey = GlobalKey<FormState>();
  final _waterCtrl = TextEditingController();
  final _calorieCtrl = TextEditingController();

  @override
  void dispose() {
    _waterCtrl.dispose();
    _calorieCtrl.dispose();
    super.dispose();
  }

  String? _validate(String? v, {required int max, required String label}) {
    if (v == null || v.trim().isEmpty) return 'Vui lòng nhập $label';
    final n = int.tryParse(v.trim());
    if (n == null || n <= 0) return '$label phải là số lớn hơn 0';
    if (n > max) return '$label không được vượt quá $max';
    return null;
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
    final result = {
      "waterIntakeMl": int.parse(_waterCtrl.text.trim()),
      "consumedCalories": int.parse(_calorieCtrl.text.trim()),
    };
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.button),
        ),
        content: Row(
          children: [
            const Icon(Icons.check_circle_outline,
                color: AppColors.onPrimary, size: 20),
            const SizedBox(width: AppSpacing.small),
            Text('Đã lưu thành công',
                style: AppText.body.copyWith(color: AppColors.onPrimary)),
          ],
        ),
      ),
    );
    Navigator.pop(context, result); // trả dữ liệu về HomeScreen / gọi API sau
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nhập nước & calo')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.screen),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Ghi nhận hôm nay', style: AppText.h1),
                const SizedBox(height: AppSpacing.small),
                Text(
                  'Nhập lượng nước và calo của lần này, tổng quan sẽ tự cập nhật.',
                  style: AppText.caption,
                ),
                const SizedBox(height: AppSpacing.section),
                _FormSection(
                  icon: Icons.water_drop_outlined,
                  title: 'Lượng nước đã uống',
                  subtitle: 'Tối đa 10000 ml',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: _waterCtrl,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        style: AppText.body,
                        decoration: AppStyle.inputDecoration(
                                hint: 'VD: 500', suffix: 'ml')
                            .copyWith(
                          prefixIcon: const Icon(Icons.opacity,
                              color: AppColors.textSecondary, size: 20),
                        ),
                        validator: (v) =>
                            _validate(v, max: 10000, label: 'Lượng nước'),
                      ),
                      const SizedBox(height: AppSpacing.screen),
                      _QuickChips(
                        values: const [250, 500, 750, 1000],
                        unit: 'ml',
                        controller: _waterCtrl,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.section),
                _FormSection(
                  icon: Icons.local_fire_department_outlined,
                  title: 'Calo tiêu thụ',
                  subtitle: 'Tối đa 10000 kcal',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: _calorieCtrl,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        style: AppText.body,
                        decoration: AppStyle.inputDecoration(
                                hint: 'VD: 350', suffix: 'kcal')
                            .copyWith(
                          prefixIcon: const Icon(Icons.restaurant_outlined,
                              color: AppColors.textSecondary, size: 20),
                        ),
                        validator: (v) =>
                            _validate(v, max: 10000, label: 'Calo'),
                      ),
                      const SizedBox(height: AppSpacing.screen),
                      _QuickChips(
                        values: const [100, 300, 500, 800],
                        unit: 'kcal',
                        controller: _calorieCtrl,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.section),
                ElevatedButton.icon(
                  style: AppStyle.primaryButton,
                  onPressed: _submit,
                  icon: const Icon(Icons.check),
                  label: const Text('Lưu ghi nhận'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Thẻ nhóm một trường nhập: icon + tiêu đề + mô tả + nội dung.
class _FormSection extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget child;
  const _FormSection({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.child,
  });

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
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(AppRadius.button),
                ),
                child: Icon(icon, color: AppColors.primary, size: 22),
              ),
              const SizedBox(width: AppSpacing.small + 4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppText.h2),
                    Text(subtitle, style: AppText.caption),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.screen),
          child,
        ],
      ),
    );
  }
}

/// Các nút chọn nhanh — bấm để điền sẵn số vào ô nhập.
class _QuickChips extends StatelessWidget {
  final List<int> values;
  final String unit;
  final TextEditingController controller;
  const _QuickChips({
    required this.values,
    required this.unit,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.button),
    );

    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (context, value, _) {
        return Wrap(
          spacing: AppSpacing.small,
          runSpacing: AppSpacing.small,
          children: values.map((n) {
            final selected = value.text.trim() == '$n';
            return Material(
              color: selected ? AppColors.primaryLight : AppColors.surface,
              shape: shape.copyWith(
                side: BorderSide(
                  color: selected ? AppColors.primary : AppColors.border,
                ),
              ),
              child: InkWell(
                customBorder: shape,
                onTap: () {
                  final text = '$n';
                  controller.value = TextEditingValue(
                    text: text,
                    selection: TextSelection.collapsed(offset: text.length),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.screen,
                    vertical: AppSpacing.small,
                  ),
                  child: Text(
                    '$n $unit',
                    style: AppText.body.copyWith(
                      color: selected
                          ? AppColors.primary
                          : AppColors.textPrimary,
                      fontWeight:
                          selected ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}