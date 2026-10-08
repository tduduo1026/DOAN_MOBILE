import 'package:flutter/material.dart';
import '../constants/app_style.dart';
import 'common_widgets.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _targetWeightController = TextEditingController();
  
  // Đã thêm biến Tuổi và Giới tính
  final _ageController = TextEditingController();
  static const List<String> _genders = ['Nam', 'Nữ'];
  String _selectedGender = 'Nam';

  static const List<String> _goals = [
    'Giảm cân',
    'Giữ cân',
    'Tăng cân',
    'Tăng cơ',
  ];
  String _selectedGoal = 'Giữ cân';

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    _targetWeightController.dispose();
    _ageController.dispose(); // Hủy biến tuổi khi đóng form
    super.dispose();
  }

  double? _parse(String s) => double.tryParse(s.trim().replaceAll(',', '.'));

  /// BMI = cân nặng (kg) / (chiều cao (m))^2
  double? get _bmi {
    final h = _parse(_heightController.text);
    final w = _parse(_weightController.text);
    if (h == null || w == null || h <= 0) return null;
    final m = h / 100;
    return w / (m * m);
  }

  String _bmiLabel(double bmi) {
    if (bmi < 18.5) return 'Thiếu cân';
    if (bmi < 25) return 'Bình thường';
    if (bmi < 30) return 'Thừa cân';
    return 'Béo phì';
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();

    // TODO: gọi service/API lưu hồ sơ ở đây. Dữ liệu đã đủ: _ageController.text, _selectedGender, v.v...
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Đã lưu hồ sơ thành công'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bmi = _bmi;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Hồ sơ cá nhân', style: AppText.h1),
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.screen),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Nhập thông tin cơ bản để theo dõi sức khỏe chính xác hơn.',
                  style: AppText.caption,
                ),
                const SizedBox(height: AppSpacing.section),

                // ---- THÔNG TIN CÁ NHÂN (Mới thêm) ----
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Thông tin cá nhân', style: AppText.h2),
                      const SizedBox(height: AppSpacing.screen),
                      AppTextField(
                        label: 'Tuổi',
                        hint: 'VD: 20',
                        controller: _ageController,
                        keyboardType: TextInputType.number,
                        validator: (v) => AppValidators.number(v, name: 'tuổi', min: 1, max: 120),
                      ),
                      const SizedBox(height: AppSpacing.screen),
                      Text('Giới tính', style: AppText.caption),
                      const SizedBox(height: 8),
                      OptionChips(
                        options: _genders,
                        selected: _selectedGender,
                        onSelected: (g) => setState(() => _selectedGender = g),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.section),

                // ---- Chỉ số cơ thể ----
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Chỉ số cơ thể', style: AppText.h2),
                      const SizedBox(height: AppSpacing.screen),
                      AppTextField(
                        label: 'Chiều cao',
                        hint: 'VD: 165',
                        suffixText: 'cm',
                        controller: _heightController,
                        keyboardType:
                            const TextInputType.numberWithOptions(decimal: true),
                        onChanged: (_) => setState(() {}),
                        validator: (v) => AppValidators.number(v,
                            name: 'chiều cao', min: 50, max: 250),
                      ),
                      const SizedBox(height: AppSpacing.screen),
                      AppTextField(
                        label: 'Cân nặng',
                        hint: 'VD: 55',
                        suffixText: 'kg',
                        controller: _weightController,
                        keyboardType:
                            const TextInputType.numberWithOptions(decimal: true),
                        onChanged: (_) => setState(() {}),
                        validator: (v) => AppValidators.number(v,
                            name: 'cân nặng', min: 10, max: 300),
                      ),
                      if (bmi != null) ...[
                        const SizedBox(height: AppSpacing.screen),
                        _BmiBox(bmi: bmi, label: _bmiLabel(bmi)),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.section),

                // ---- Mục tiêu ----
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Mục tiêu sức khỏe', style: AppText.h2),
                      const SizedBox(height: AppSpacing.screen),
                      OptionChips(
                        options: _goals,
                        selected: _selectedGoal,
                        onSelected: (g) => setState(() => _selectedGoal = g),
                      ),
                      if (_selectedGoal != 'Giữ cân') ...[
                        const SizedBox(height: AppSpacing.screen),
                        AppTextField(
                          label: 'Cân nặng mục tiêu (không bắt buộc)',
                          hint: 'VD: 50',
                          suffixText: 'kg',
                          controller: _targetWeightController,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          validator: (v) => AppValidators.number(v,
                              name: 'cân nặng mục tiêu',
                              min: 10,
                              max: 300,
                              required: false),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.section),

                PrimaryButton(
                  label: 'Lưu hồ sơ',
                  icon: Icons.check,
                  onPressed: _save,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BmiBox extends StatelessWidget {
  final double bmi;
  final String label;

  const _BmiBox({required this.bmi, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.screen),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(AppRadius.button),
      ),
      child: Row(
        children: [
          const Icon(Icons.monitor_heart, color: AppColors.primary),
          const SizedBox(width: AppSpacing.small + 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Chỉ số BMI', style: AppText.caption),
                Text(
                  '${bmi.toStringAsFixed(1)} - $label',
                  style: AppText.h2.copyWith(color: AppColors.primary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}