import 'package:flutter/material.dart';

class AppColors {
  // الألوان الأساسية للتطبيق
  static const Color primaryGreen = Color(0xFF4A5C3D); // أخضر زيتي داكن
  static const Color lightGreen = Color(0xFFEAF0E5); // أخضر فاتح
  static const Color beige = Color(0xFFF5F5DC); // بيج خفيف
  static const Color cream = Color(0xFFFFFEF7); // أبيض نائل
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  
  // ألوان إضافية
  static const Color darkGreen = Color(0xFF2D3A2A);
  static const Color mediumGreen = Color(0xFF6B7B5A);
  static const Color lightGray = Color(0xFFF8F8F8);
  static const Color gray = Color(0xFF9E9E9E);
  static const Color darkGray = Color(0xFF424242);
  
  // ألوان الحالة
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);
  
  // تدرجات الألوان
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryGreen, mediumGreen],
  );
  
  static const LinearGradient lightGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [lightGreen, cream],
  );
}
