import 'package:flutter/material.dart';
import '../constants/app_style.dart';
import 'common_widgets.dart';

class DailyLogScreen extends StatefulWidget {
  const DailyLogScreen({super.key});

  @override
  State<DailyLogScreen> createState() => _DailyLogScreenState();
}

class _DailyLogScreenState extends State<DailyLogScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  // Mỗi tab một form riêng.
  final _mealKey = GlobalKey<FormState>();
  final _waterKey = GlobalKey<FormState>();
  final _exerciseKey = GlobalKey<FormState>();
  final _sleepKey = GlobalKey<FormState>();

  // Bữa ăn
  static const _mealTypes = ['Sáng', 'Trưa', 'Tối', 'Ăn vặt'];
  String _mealType = 'Sáng';
  final _foodController = TextEditingController();
  final _caloController = TextEditingController();

  // Nước uống
  final _waterController = TextEditingController();

  // Vận động
  final _activityController = TextEditingController();
  final _minutesController = TextEditingController();
  final _burnController = TextEditingController();

  // Giấc ngủ
  final _sleepHoursController = TextEditingController();
  final _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _foodController.dispose();
    _caloController.dispose();
    _waterController.dispose();
    _activityController.dispose();
    _minutesController.dispose();
    _burnController.dispose();
    _sleepHoursController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _submit(GlobalKey<FormState> key, List<TextEditingController> toClear,
      String message) {
    if (!key.currentState!.validate()) return;
    FocusScope.of(context).unfocus();

    // TODO: lưu nhật ký xuống DB/API ở đây.
    for (final c in toClear) {
      c.clear();
    }
    _showSuccessSnackBar(message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Ghi nhận sinh hoạt', style: AppText.h1),
        backgroundColor: AppColors.surface,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.primary,
          labelStyle: AppText.body.copyWith(fontWeight: FontWeight.w600),
          unselectedLabelStyle: AppText.body,
          tabs: const [
            Tab(icon: Icon(Icons.restaurant), text: 'Ăn uống'),
            Tab(icon: Icon(Icons.local_drink), text: 'Nước'),
            Tab(icon: Icon(Icons.fitness_center), text: 'Vận động'),
            Tab(icon: Icon(Icons.bedtime), text: 'Giấc ngủ'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildMealTab(),
          _buildWaterTab(),
          _buildExerciseTab(),
          _buildSleepTab(),
        ],
      ),
    );
  }

  // ---------- Khung chung cho mỗi tab ----------
  Widget _tabScaffold({
    required GlobalKey<FormState> formKey,
    required String title,
    required List<Widget> fields,
    required String buttonLabel,
    required VoidCallback onSave,
  }) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.screen),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppText.h2),
                  const SizedBox(height: AppSpacing.screen),
                  ...fields,
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.section),
            PrimaryButton(label: buttonLabel, icon: Icons.add, onPressed: onSave),
          ],
        ),
      ),
    );
  }

  static const _gap = SizedBox(height: AppSpacing.screen);

  // ---------- Tab Ăn uống ----------
  Widget _buildMealTab() {
    return _tabScaffold(
      formKey: _mealKey,
      title: 'Bữa ăn',
      buttonLabel: 'Lưu bữa ăn',
      onSave: () => _submit(_mealKey, [_foodController, _caloController],
          'Đã ghi nhận bữa ăn'),
      fields: [
        Text('Loại bữa', style: AppText.body),
        const SizedBox(height: AppSpacing.small),
        OptionChips(
          options: _mealTypes,
          selected: _mealType,
          onSelected: (v) => setState(() => _mealType = v),
        ),
        _gap,
        AppTextField(
          label: 'Món ăn',
          hint: 'VD: Cơm gà, salad',
          controller: _foodController,
          validator: (v) => AppValidators.text(v, name: 'tên món ăn'),
        ),
        _gap,
        AppTextField(
          label: 'Lượng calo',
          hint: 'VD: 450',
          suffixText: 'kcal',
          controller: _caloController,
          keyboardType: TextInputType.number,
          validator: (v) =>
              AppValidators.number(v, name: 'calo', min: 0, max: 5000),
        ),
      ],
    );
  }

  // ---------- Tab Nước ----------
  Widget _buildWaterTab() {
    return _tabScaffold(
      formKey: _waterKey,
      title: 'Nước uống',
      buttonLabel: 'Lưu lượng nước',
      onSave: () =>
          _submit(_waterKey, [_waterController], 'Đã ghi nhận lượng nước'),
      fields: [
        AppTextField(
          label: 'Lượng nước',
          hint: 'VD: 250',
          suffixText: 'ml',
          controller: _waterController,
          keyboardType: TextInputType.number,
          validator: (v) =>
              AppValidators.number(v, name: 'lượng nước', min: 1, max: 5000),
        ),
        _gap,
        Text('Chọn nhanh', style: AppText.caption),
        const SizedBox(height: AppSpacing.small),
        Wrap(
          spacing: AppSpacing.small,
          children: ['200', '250', '500', '1000'].map((ml) {
            return ActionChip(
              label: Text('$ml ml', style: AppText.body),
              backgroundColor: AppColors.primaryLight,
              side: const BorderSide(color: AppColors.primary),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.button),
              ),
              onPressed: () => setState(() => _waterController.text = ml),
            );
          }).toList(),
        ),
      ],
    );
  }

  // ---------- Tab Vận động ----------
  Widget _buildExerciseTab() {
    return _tabScaffold(
      formKey: _exerciseKey,
      title: 'Vận động',
      buttonLabel: 'Lưu hoạt động',
      onSave: () => _submit(
        _exerciseKey,
        [_activityController, _minutesController, _burnController],
        'Đã ghi nhận hoạt động',
      ),
      fields: [
        AppTextField(
          label: 'Hoạt động',
          hint: 'VD: Chạy bộ, đạp xe',
          controller: _activityController,
          validator: (v) => AppValidators.text(v, name: 'tên hoạt động'),
        ),
        _gap,
        AppTextField(
          label: 'Thời gian',
          hint: 'VD: 30',
          suffixText: 'phút',
          controller: _minutesController,
          keyboardType: TextInputType.number,
          validator: (v) =>
              AppValidators.number(v, name: 'thời gian', min: 1, max: 600),
        ),
        _gap,
        AppTextField(
          label: 'Calo tiêu hao (không bắt buộc)',
          hint: 'VD: 200',
          suffixText: 'kcal',
          controller: _burnController,
          keyboardType: TextInputType.number,
          validator: (v) => AppValidators.number(v,
              name: 'calo tiêu hao', min: 0, max: 5000, required: false),
        ),
      ],
    );
  }

  // ---------- Tab Giấc ngủ ----------
  Widget _buildSleepTab() {
    return _tabScaffold(
      formKey: _sleepKey,
      title: 'Giấc ngủ',
      buttonLabel: 'Lưu giấc ngủ',
      onSave: () => _submit(_sleepKey, [_sleepHoursController, _noteController],
          'Đã ghi nhận giấc ngủ'),
      fields: [
        AppTextField(
          label: 'Số giờ ngủ',
          hint: 'VD: 7.5',
          suffixText: 'giờ',
          controller: _sleepHoursController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          validator: (v) =>
              AppValidators.number(v, name: 'số giờ ngủ', min: 0.5, max: 24),
        ),
        _gap,
        AppTextField(
          label: 'Ghi chú (không bắt buộc)',
          hint: 'VD: Ngủ muộn, hay tỉnh giấc',
          controller: _noteController,
          maxLines: 3,
        ),
      ],
    );
  }
}