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
}

/// Hệ thống lưới bội số của 8.
class AppSpacing {
  static const double screen = 16; // lề trái/phải màn hình
  static const double section = 24; // giữa các khối lớn
  static const double small = 8; // giữa các thành phần nhỏ
}

class AppRadius {
  static const double button = 8;
  static const double card = 12;
}

class AppSize {
  static const double buttonHeight = 48;
  static const double fieldHeight = 48;
}

/// Typography (Inter - Google Fonts).
class AppText {
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

  static OutlineInputBorder _border(Color color) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(AppRadius.button),
    borderSide: BorderSide(color: color),
  );

  /// Ô nhập liệu: viền xám nhạt, focus chuyển primary, lỗi màu đỏ.
  static InputDecoration inputDecoration({String? hint, String? suffix}) =>
      InputDecoration(
        hintText: hint,
        hintStyle: AppText.body.copyWith(color: AppColors.textSecondary),
        suffixText: suffix,
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screen,
          vertical: 0,
        ),
        constraints: const BoxConstraints(minHeight: AppSize.fieldHeight),
        enabledBorder: _border(AppColors.border),
        focusedBorder: _border(AppColors.primary),
        errorBorder: _border(AppColors.error),
        focusedErrorBorder: _border(AppColors.error),
        errorStyle: AppText.caption.copyWith(color: AppColors.error),
      );

  /// Theme toàn app — dùng trong MaterialApp(theme: AppStyle.theme).
  static ThemeData get theme => ThemeData(
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      primary: AppColors.primary,
      surface: AppColors.surface,
      error: AppColors.error,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.background,
      foregroundColor: AppColors.textPrimary,
      elevation: 0,
      titleTextStyle: AppText.h2,
    ),
    fontFamily: GoogleFonts.inter().fontFamily,
  );
}
