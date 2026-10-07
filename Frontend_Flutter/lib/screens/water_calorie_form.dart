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
    if (!_formKey.currentState!.validate()) return;
    final result = {
      "waterIntakeMl": int.parse(_waterCtrl.text.trim()),
      "consumedCalories": int.parse(_calorieCtrl.text.trim()),
    };
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.success,
        content: Text('Đã lưu thành công',
            style: AppText.body.copyWith(color: AppColors.onPrimary)),
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
          child: Form(
            key: _formKey,
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.screen),
              decoration: AppStyle.card,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Ghi nhận hôm nay', style: AppText.h2),
                  const SizedBox(height: AppSpacing.section),
                  Text('Lượng nước đã uống', style: AppText.body),
                  const SizedBox(height: AppSpacing.small),
                  TextFormField(
                    controller: _waterCtrl,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    style: AppText.body,
                    decoration:
                        AppStyle.inputDecoration(hint: 'VD: 500', suffix: 'ml'),
                    validator: (v) =>
                        _validate(v, max: 10000, label: 'Lượng nước'),
                  ),
                  const SizedBox(height: AppSpacing.section),
                  Text('Calo tiêu thụ', style: AppText.body),
                  const SizedBox(height: AppSpacing.small),
                  TextFormField(
                    controller: _calorieCtrl,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    style: AppText.body,
                    decoration: AppStyle.inputDecoration(
                        hint: 'VD: 350', suffix: 'kcal'),
                    validator: (v) => _validate(v, max: 10000, label: 'Calo'),
                  ),
                  const SizedBox(height: AppSpacing.section),
                  ElevatedButton(
                    style: AppStyle.primaryButton,
                    onPressed: _submit,
                    child: const Text('Lưu'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}