import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_style.dart';
import '../widgets/health_bottom_navigation.dart';

/// Hồ sơ cá nhân. Mặc định hiển thị tóm tắt như video;
/// nút "Chỉnh sửa hồ sơ" mở các trường nhập theo yêu cầu phân công.
class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _heightController = TextEditingController(text: '172');
  final _targetWeightController = TextEditingController(text: '68');
  final _waterGoalController = TextEditingController(text: '2000');
  final _calorieGoalController = TextEditingController(text: '1800');

  bool _isEditing = false;
  double _height = 172;
  double _targetWeight = 68;
  int _waterGoal = 2000;
  int _calorieGoal = 1800;

  @override
  void dispose() {
    _heightController.dispose();
    _targetWeightController.dispose();
    _waterGoalController.dispose();
    _calorieGoalController.dispose();
    super.dispose();
  }

  String? _validateNumber(String? value, String label,
      {required double min, required double max}) {
    if (value == null || value.trim().isEmpty) return 'Vui lòng nhập $label';
    final parsed = double.tryParse(value.trim());
    if (parsed == null || parsed < min || parsed > max) {
      return '$label phải từ $min đến $max';
    }
    return null;
  }

  String? _validateInteger(String? value, String label,
      {required int min, required int max}) {
    if (value == null || value.trim().isEmpty) return 'Vui lòng nhập $label';
    final parsed = int.tryParse(value.trim());
    if (parsed == null || parsed < min || parsed > max) {
      return '$label phải là số nguyên từ $min đến $max';
    }
    return null;
  }

  void _saveProfile() {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _height = double.parse(_heightController.text.trim());
      _targetWeight = double.parse(_targetWeightController.text.trim());
      _waterGoal = int.parse(_waterGoalController.text.trim());
      _calorieGoal = int.parse(_calorieGoalController.text.trim());
      _isEditing = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đã cập nhật hồ sơ cá nhân')),
    );
  }

  Future<void> _confirmSignOut() async {
    final shouldSignOut = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Đăng xuất'),
        content: const Text('Bạn có chắc chắn muốn đăng xuất khỏi tài khoản?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Hủy'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Đăng xuất'),
          ),
        ],
      ),
    );
    if (shouldSignOut == true && mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hồ sơ cá nhân', style: AppText.h2),
        backgroundColor: AppColors.surface,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.screen),
          child: Column(
            children: [
              _buildIdentityCard(),
              const SizedBox(height: AppSpacing.section),
              _buildHealthInfoCard(),
              const SizedBox(height: AppSpacing.section),
              if (_isEditing) ...[
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: AppStyle.primaryButton,
                    onPressed: _saveProfile,
                    icon: const Icon(Icons.check_rounded),
                    label: const Text('Lưu hồ sơ'),
                  ),
                ),
                const SizedBox(height: AppSpacing.small),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(AppSize.buttonHeight),
                    foregroundColor: AppColors.textSecondary,
                    side: const BorderSide(color: AppColors.border),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.button),
                    ),
                  ),
                  onPressed: () => setState(() => _isEditing = false),
                  child: const Text('Hủy chỉnh sửa'),
                ),
              ] else ...[
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: AppStyle.primaryButton,
                    onPressed: () => setState(() => _isEditing = true),
                    icon: const Icon(Icons.edit_outlined),
                    label: const Text('Chỉnh sửa hồ sơ'),
                  ),
                ),
                const SizedBox(height: AppSpacing.small),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(AppSize.buttonHeight),
                      foregroundColor: AppColors.error,
                      side: const BorderSide(color: AppColors.error),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.button),
                      ),
                    ),
                    onPressed: _confirmSignOut,
                    icon: const Icon(Icons.logout_rounded),
                    label: const Text('Đăng xuất'),
                  ),
                ),
              ],
              const SizedBox(height: AppSpacing.section),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const HealthBottomNavigation(selectedIndex: 3),
    );
  }

  Widget _buildIdentityCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.section),
      decoration: AppStyle.card,
      child: Column(
        children: [
          Container(
            width: 88,
            height: 88,
            decoration: AppStyle.tintBox(AppColors.info, radius: AppRadius.pill),
            child: const Icon(
              Icons.person_rounded,
              size: 48,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: AppSpacing.small + 4),
          Text('Nguyễn Văn An', style: AppText.h2),
          const SizedBox(height: 4),
          Text('nguyenvanan@email.com', style: AppText.body.copyWith(
            color: AppColors.textSecondary,
          )),
        ],
      ),
    );
  }

  Widget _buildHealthInfoCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.screen),
      decoration: AppStyle.card,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Thông tin sức khỏe', style: AppText.h2),
          const SizedBox(height: AppSpacing.small),
          if (_isEditing) ...[
            Form(
              key: _formKey,
              child: Column(
                children: [
                  _ProfileInput(
                    label: 'Chiều cao (cm)',
                    controller: _heightController,
                    icon: Icons.height_rounded,
                    validator: (v) => _validateNumber(v, 'chiều cao', min: 80, max: 250),
                  ),
                  _ProfileInput(
                    label: 'Cân nặng mục tiêu (kg)',
                    controller: _targetWeightController,
                    icon: Icons.monitor_weight_outlined,
                    validator: (v) => _validateNumber(v, 'cân nặng', min: 20, max: 350),
                  ),
                  _ProfileInput(
                    label: 'Mục tiêu nước (ml/ngày)',
                    controller: _waterGoalController,
                    icon: Icons.water_drop_outlined,
                    validator: (v) => _validateInteger(v, 'mục tiêu nước', min: 250, max: 10000),
                    integerOnly: true,
                  ),
                  _ProfileInput(
                    label: 'Mục tiêu calo (kcal/ngày)',
                    controller: _calorieGoalController,
                    icon: Icons.local_fire_department_outlined,
                    validator: (v) => _validateInteger(v, 'mục tiêu calo', min: 500, max: 10000),
                    integerOnly: true,
                  ),
                ],
              ),
            ),
          ] else ...[
            _InfoRow(
              icon: Icons.height_rounded,
              iconColor: AppColors.primary,
              label: 'Chiều cao',
              value: '${_height.toStringAsFixed(_height % 1 == 0 ? 0 : 1)} cm',
            ),
            _InfoRow(
              icon: Icons.monitor_weight_outlined,
              iconColor: AppColors.accent,
              label: 'Cân nặng mục tiêu',
              value: '${_targetWeight.toStringAsFixed(_targetWeight % 1 == 0 ? 0 : 1)} kg',
            ),
            _InfoRow(
              icon: Icons.water_drop_outlined,
              iconColor: AppColors.water,
              label: 'Mục tiêu nước',
              value: '$_waterGoal ml/ngày',
            ),
            _InfoRow(
              icon: Icons.local_fire_department_outlined,
              iconColor: AppColors.error,
              label: 'Mục tiêu calo',
              value: '$_calorieGoal kcal/ngày',
              isLast: true,
            ),
          ],
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final bool isLast;

  const _InfoRow({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.small + 2),
          child: Row(
            children: [
              AppIconBadge(icon: icon, color: iconColor),
              const SizedBox(width: AppSpacing.small + 4),
              Expanded(
                child: Text(label, style: AppText.body.copyWith(color: AppColors.textSecondary)),
              ),
              const SizedBox(width: AppSpacing.small),
              Flexible(
                child: Text(value, textAlign: TextAlign.end, style: AppText.bodyBold),
              ),
            ],
          ),
        ),
        if (!isLast) const Divider(height: 1),
      ],
    );
  }
}

class _ProfileInput extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final IconData icon;
  final String? Function(String?) validator;
  final bool integerOnly;

  const _ProfileInput({
    required this.label,
    required this.controller,
    required this.icon,
    required this.validator,
    this.integerOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.small + 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppText.label),
          const SizedBox(height: 6),
          TextFormField(
            controller: controller,
            keyboardType: TextInputType.numberWithOptions(decimal: !integerOnly),
            inputFormatters: integerOnly ? [FilteringTextInputFormatter.digitsOnly] : null,
            validator: validator,
            style: AppText.body,
            decoration: AppStyle.inputDecoration(prefixIcon: icon),
          ),
        ],
      ),
    );
  }
}
