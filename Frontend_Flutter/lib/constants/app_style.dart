import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Bảng màu chủ đạo — KHÔNG hardcode màu ở file màn hình, chỉ dùng AppColors.
class AppColors {
  static const Color primary = Color(0xFF1A56DB);
  static const Color primaryLight = Color(0xFFE1EFFE);
  static const Color background = Color(0xFFF3F4F6);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color error = Color(0xFFE02424);
  static const Color success = Color(0xFF057A55);
  static const Color border = Color(0xFFD1D5DB);

  // Màu phụ cho biểu tượng / trạng thái (bổ sung cho bảng màu chuẩn).
  static const Color info = Color(0xFF3B82F6);
  static const Color warning = Color(0xFFD97706);
  static const Color water = Color(0xFF0EA5E9);
  static const Color accent = Color(0xFF8B5CF6);

  // Màu phân loại BMI.
  static const Color bmiUnderweight = info;
  static const Color bmiNormal = success;
  static const Color bmiOverweight = warning;
  static const Color bmiObese = error;

  /// Nền nhạt của một màu (icon badge, pill, hộp lời khuyên...).
  static Color tint(Color color, [double alpha = 0.12]) =>
      color.withValues(alpha: alpha);
}

/// Hệ thống lưới bội số của 8.
class AppSpacing {
  static const double screen = 16; // lề trái/phải màn hình, padding thẻ
  static const double section = 24; // giữa các khối lớn
  static const double small = 8; // giữa các thành phần nhỏ
}

class AppRadius {
  static const double button = 8;
  static const double card = 12;
  static const double pill = 999;
}

class AppSize {
  static const double buttonHeight = 48;
  static const double fieldHeight = 48;
  static const double iconBadge = 40;
}

/// Typography (Inter - Google Fonts).
class AppText {
  static TextStyle get display => GoogleFonts.inter(
    fontSize: 40,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );
  static TextStyle get h1 => GoogleFonts.inter(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );
  static TextStyle get h2 => GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );
  static TextStyle get body => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );
  static TextStyle get label => body.copyWith(fontWeight: FontWeight.w500);
  static TextStyle get bodyBold => body.copyWith(fontWeight: FontWeight.w600);
  static TextStyle get caption => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );
  static TextStyle get button => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: AppColors.onPrimary,
  );
}

/// Thành phần dùng chung.
class AppStyle {
  /// Nút chính: cao 48, nền primary, chữ trắng đậm, bo 8, không đổ bóng.
  static ButtonStyle get primaryButton => ElevatedButton.styleFrom(
    backgroundColor: AppColors.primary,
    foregroundColor: AppColors.onPrimary,
    disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.6),
    disabledForegroundColor: AppColors.onPrimary,
    minimumSize: const Size.fromHeight(AppSize.buttonHeight),
    elevation: 0,
    textStyle: AppText.button,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.button),
    ),
  );

  /// Thẻ nội dung: nền trắng, bo 12, đổ bóng cực nhẹ.
  static BoxDecoration get card => BoxDecoration(
    color: AppColors.surface,
    borderRadius: BorderRadius.circular(AppRadius.card),
    boxShadow: [
      BoxShadow(
        color: AppColors.textPrimary.withValues(alpha: 0.05),
        blurRadius: 8,
        offset: const Offset(0, 2),
      ),
    ],
  );

  /// Hộp nền nhạt theo một màu (không đổ bóng).
  static BoxDecoration tintBox(
    Color color, {
    double radius = AppRadius.button,
  }) => BoxDecoration(
    color: AppColors.tint(color),
    borderRadius: BorderRadius.circular(radius),
  );

  static OutlineInputBorder _border(Color color) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(AppRadius.button),
    borderSide: BorderSide(color: color),
  );

  /// Ô nhập liệu: cao 48, viền xám nhạt, focus chuyển primary, lỗi màu đỏ.
  static InputDecoration inputDecoration({
    String? hint,
    String? suffix,
    IconData? prefixIcon,
    Widget? suffixIcon,
  }) => InputDecoration(
    hintText: hint,
    hintStyle: AppText.body.copyWith(color: AppColors.textSecondary),
    suffixText: suffix,
    suffixStyle: AppText.body.copyWith(color: AppColors.textSecondary),
    prefixIcon: prefixIcon == null
        ? null
        : Icon(prefixIcon, size: 20, color: AppColors.textSecondary),
    suffixIcon: suffixIcon,
    filled: true,
    fillColor: AppColors.surface,
    contentPadding: const EdgeInsets.symmetric(
      horizontal: AppSpacing.screen,
      vertical: 0,
    ),
    constraints: const BoxConstraints(minHeight: AppSize.fieldHeight),
    border: _border(AppColors.border),
    enabledBorder: _border(AppColors.border),
    focusedBorder: _border(AppColors.primary),
    errorBorder: _border(AppColors.error),
    focusedErrorBorder: _border(AppColors.error),
    errorStyle: AppText.caption.copyWith(color: AppColors.error),
  );

  /// Theme toàn app — dùng trong MaterialApp(theme: AppStyle.theme).
  static ThemeData get theme => ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      primary: AppColors.primary,
      surface: AppColors.surface,
      error: AppColors.error,
    ),
    fontFamily: GoogleFonts.inter().fontFamily,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.surface,
      foregroundColor: AppColors.textPrimary,
      elevation: 0,
      scrolledUnderElevation: 0,
      titleTextStyle: AppText.h2,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(style: primaryButton),
    dividerTheme: const DividerThemeData(
      color: AppColors.border,
      thickness: 1,
      space: 1,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.surface,
      indicatorColor: AppColors.primaryLight,
      labelTextStyle: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected)
            ? AppText.caption.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              )
            : AppText.caption,
      ),
      iconTheme: WidgetStateProperty.resolveWith(
        (states) => IconThemeData(
          color: states.contains(WidgetState.selected)
              ? AppColors.primary
              : AppColors.textSecondary,
          size: 24,
        ),
      ),
    ),
  );
}

/// Ô icon nền nhạt dùng chung trong các thẻ.
class AppIconBadge extends StatelessWidget {
  final IconData icon;
  final Color color;
  const AppIconBadge({super.key, required this.icon, this.color = AppColors.primary});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSize.iconBadge,
      height: AppSize.iconBadge,
      decoration: AppStyle.tintBox(color),
      child: Icon(icon, color: color, size: 22),
    );
  }
}

/// Viên thuốc nhỏ: icon + chữ, nền nhạt theo màu.
class AppPill extends StatelessWidget {
  final String text;
  final IconData? icon;
  final Color color;
  const AppPill({
    super.key,
    required this.text,
    this.icon,
    this.color = AppColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: AppStyle.tintBox(color, radius: AppRadius.pill),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
          ],
          Flexible(
            child: Text(
              text,
              overflow: TextOverflow.ellipsis,
              style: AppText.caption.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}