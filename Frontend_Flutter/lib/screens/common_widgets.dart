import 'package:flutter/material.dart';
import '../constants/app_style.dart';

/// Thẻ nội dung: nền trắng, bo 12, đổ bóng nhẹ.
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.screen),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: AppStyle.card,
      child: child,
    );
  }
}

/// Ô nhập: nhãn phía trên, cách ô nhập 8px.
class AppTextField extends StatelessWidget {
  final String label;
  final TextEditingController? controller;
  final String? hint;
  final String? suffixText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final int maxLines;

  const AppTextField({
    super.key,
    required this.label,
    this.controller,
    this.hint,
    this.suffixText,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.onChanged,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppText.body),
        const SizedBox(height: AppSpacing.small),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          onChanged: onChanged,
          maxLines: maxLines,
          style: AppText.body,
          cursorColor: AppColors.primary,
          decoration: AppStyle.inputDecoration(hint: hint, suffix: suffixText),
        ),
      ],
    );
  }
}

/// Nút chính: cao 48, nền Primary, chữ trắng đậm, bo 8.
class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: AppSize.buttonHeight,
      child: ElevatedButton(
        style: AppStyle.primaryButton,
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 20),
              const SizedBox(width: AppSpacing.small),
            ],
            Text(label, style: AppText.button),
          ],
        ),
      ),
    );
  }
}

/// Nhóm lựa chọn dạng chip (chọn 1). Dùng cho mục tiêu, bữa ăn, ...
class OptionChips extends StatelessWidget {
  final List<String> options;
  final String? selected;
  final ValueChanged<String> onSelected;

  const OptionChips({
    super.key,
    required this.options,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.small,
      runSpacing: AppSpacing.small,
      children: options.map((o) {
        final isSelected = o == selected;
        return GestureDetector(
          onTap: () => onSelected(o),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primaryLight : AppColors.surface,
              borderRadius: BorderRadius.circular(AppRadius.button),
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.border,
              ),
            ),
            child: Text(
              o,
              style: AppText.body.copyWith(
                color: isSelected ? AppColors.primary : AppColors.textPrimary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

/// Validator dùng chung cho form số.
class AppValidators {
  AppValidators._();

  static String? number(String? value,
      {required String name, double? min, double? max, bool required = true}) {
    final text = value?.trim().replaceAll(',', '.') ?? '';
    if (text.isEmpty) return required ? 'Vui lòng nhập $name' : null;
    final n = double.tryParse(text);
    if (n == null) return '$name phải là số';
    if (min != null && n < min) return '$name tối thiểu $min';
    if (max != null && n > max) return '$name tối đa $max';
    return null;
  }

  static String? text(String? value, {required String name}) {
    if (value == null || value.trim().isEmpty) return 'Vui lòng nhập $name';
    return null;
  }
}