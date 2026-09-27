import 'package:flutter/material.dart';

abstract final class AppColors {
  static const primary = Color(0xFF52C41A);
  static const gold = Color(0xFFFAAD14);
  static const info = Color(0xFF1677FF);
  static const error = Color(0xFFFF4D4F);

  // The web app puts white text on the accents above, which fails WCAG AA
  // contrast on every one of them (as low as 1.9:1 on gold).
  static const onAccent = Color(0xFF0A0A0A);

  static const backgroundLight = Color(0xFFF5F5F5);
  static const surfaceLight = Color(0xFFFFFFFF);

  static const onSurfaceLight = Color(0xE0000000);
  static const onSurfaceVariantLight = Color(0xA6000000);

  static const backgroundDark = Color(0xFF0A0A0A);
  static const surfaceDark = Color(0xFF141414);
  static const surfaceElevatedDark = Color(0xFF1F1F1F);

  static const onSurfaceDark = Color(0xD9FFFFFF);
  static const onSurfaceVariantDark = Color(0xA6FFFFFF);
}
